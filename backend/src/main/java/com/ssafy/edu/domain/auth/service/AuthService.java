package com.ssafy.edu.domain.auth.service;

import com.ssafy.edu.domain.auth.dto.request.LoginRequest;
import com.ssafy.edu.domain.auth.dto.request.RefreshRequest;
import com.ssafy.edu.domain.auth.dto.response.LoginResponse;
import com.ssafy.edu.domain.auth.dto.response.TokenResponse;
import com.ssafy.edu.domain.auth.entity.RefreshToken;
import com.ssafy.edu.domain.auth.entity.User;
import com.ssafy.edu.domain.auth.entity.UserStatus;
import com.ssafy.edu.domain.auth.repository.RefreshTokenRepository;
import com.ssafy.edu.domain.auth.repository.UserRepository;
import com.ssafy.edu.global.exception.ApiException;
import com.ssafy.edu.global.exception.ErrorCode;
import com.ssafy.edu.global.file.repository.FileRepository;
import com.ssafy.edu.global.security.JwtProvider;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class AuthService {

    private final UserRepository userRepository;
    private final RefreshTokenRepository refreshTokenRepository;
    private final FileRepository fileRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtProvider jwtProvider;
    private final long refreshTokenExpiry;

    public AuthService(UserRepository userRepository,
                       RefreshTokenRepository refreshTokenRepository,
                       FileRepository fileRepository,
                       PasswordEncoder passwordEncoder,
                       JwtProvider jwtProvider,
                       @Value("${jwt.refresh-token-expiry}") long refreshTokenExpiry) {
        this.userRepository = userRepository;
        this.refreshTokenRepository = refreshTokenRepository;
        this.fileRepository = fileRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtProvider = jwtProvider;
        this.refreshTokenExpiry = refreshTokenExpiry;
    }

    public LoginResponse login(LoginRequest request) {
        User user = userRepository.findByEmail(request.email())
                .orElseThrow(() -> new ApiException(ErrorCode.INVALID_CREDENTIALS));

        if (!passwordEncoder.matches(request.password(), user.getPassword())) {
            throw new ApiException(ErrorCode.INVALID_CREDENTIALS);
        }

        if (user.getStatus() != UserStatus.ACTIVE) {
            throw new ApiException(ErrorCode.ACCOUNT_INACTIVE);
        }

        refreshTokenRepository.deleteByUserId(user.getId());

        String accessToken = jwtProvider.generateAccessToken(user.getId(), user.getRole().name());
        String refreshToken = jwtProvider.generateRefreshToken(user.getId());
        refreshTokenRepository.save(RefreshToken.of(user.getId(), refreshToken, refreshTokenExpiry));

        String profileImageUrl = user.getProfileFileId() == null ? null
                : fileRepository.findById(user.getProfileFileId())
                        .map(f -> f.getFileUrl())
                        .orElse(null);

        return new LoginResponse(
                accessToken,
                refreshToken,
                new LoginResponse.LoginUserInfo(user.getId(), user.getEmail(), user.getName(),
                        user.getRole().name(), profileImageUrl)
        );
    }

    public void logout(Long userId) {
        refreshTokenRepository.deleteByUserId(userId);
    }

    public TokenResponse refresh(RefreshRequest request) {
        String rawToken = request.refreshToken();

        if (!jwtProvider.isTokenValid(rawToken)) {
            throw new ApiException(ErrorCode.TOKEN_INVALID);
        }

        RefreshToken stored = refreshTokenRepository.findByToken(rawToken)
                .orElseThrow(() -> new ApiException(ErrorCode.TOKEN_INVALID));

        Long userId = jwtProvider.getUserId(rawToken);

        refreshTokenRepository.delete(stored);

        String newAccessToken = jwtProvider.generateAccessToken(userId,
                userRepository.findById(userId)
                        .orElseThrow(() -> new ApiException(ErrorCode.RESOURCE_NOT_FOUND))
                        .getRole().name());
        String newRefreshToken = jwtProvider.generateRefreshToken(userId);
        refreshTokenRepository.save(RefreshToken.of(userId, newRefreshToken, refreshTokenExpiry));

        return new TokenResponse(newAccessToken, newRefreshToken);
    }
}
