package com.ssafy.edu.domain.auth.service;

import com.ssafy.edu.domain.auth.dto.request.ChangePasswordRequest;
import com.ssafy.edu.domain.auth.dto.request.UpdateProfileRequest;
import com.ssafy.edu.domain.auth.dto.response.UserResponse;
import com.ssafy.edu.domain.auth.entity.PasswordChangeHistory;
import com.ssafy.edu.domain.auth.entity.User;
import com.ssafy.edu.domain.auth.repository.PasswordChangeHistoryRepository;
import com.ssafy.edu.domain.auth.repository.RefreshTokenRepository;
import com.ssafy.edu.domain.auth.repository.UserRepository;
import com.ssafy.edu.global.exception.ApiException;
import com.ssafy.edu.global.exception.ErrorCode;
import com.ssafy.edu.global.file.repository.FileRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class UserService {

    private final UserRepository userRepository;
    private final RefreshTokenRepository refreshTokenRepository;
    private final PasswordChangeHistoryRepository historyRepository;
    private final FileRepository fileRepository;
    private final PasswordEncoder passwordEncoder;

    public UserService(UserRepository userRepository,
                       RefreshTokenRepository refreshTokenRepository,
                       PasswordChangeHistoryRepository historyRepository,
                       FileRepository fileRepository,
                       PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.refreshTokenRepository = refreshTokenRepository;
        this.historyRepository = historyRepository;
        this.fileRepository = fileRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional(readOnly = true)
    public UserResponse getProfile(Long userId) {
        User user = findUser(userId);
        return UserResponse.of(user, resolveProfileImageUrl(user));
    }

    public UserResponse updateProfile(Long userId, UpdateProfileRequest request) {
        User user = findUser(userId);

        if (request.profileFileId() != null && !fileRepository.existsById(request.profileFileId())) {
            throw new ApiException(ErrorCode.RESOURCE_NOT_FOUND);
        }

        user.updateProfile(request.name(), request.phoneNumber(), request.zipCode(),
                request.address(), request.addressDetail(), request.profileFileId());

        return UserResponse.of(user, resolveProfileImageUrl(user));
    }

    public void changePassword(Long userId, ChangePasswordRequest request,
                               String ipAddress, String userAgent) {
        User user = findUser(userId);

        if (!passwordEncoder.matches(request.currentPassword(), user.getPassword())) {
            throw new ApiException(ErrorCode.PASSWORD_MISMATCH);
        }

        user.changePassword(passwordEncoder.encode(request.newPassword()));
        refreshTokenRepository.deleteByUserId(userId);
        historyRepository.save(PasswordChangeHistory.of(userId, ipAddress, userAgent));
    }

    public void withdraw(Long userId) {
        User user = findUser(userId);
        user.withdraw();
        refreshTokenRepository.deleteByUserId(userId);
    }

    private User findUser(Long userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new ApiException(ErrorCode.RESOURCE_NOT_FOUND));
    }

    private String resolveProfileImageUrl(User user) {
        if (user.getProfileFileId() == null) return null;
        return fileRepository.findById(user.getProfileFileId())
                .map(f -> f.getFileUrl())
                .orElse(null);
    }
}
