package com.ssafy.edu.domain.auth.service;

import com.ssafy.edu.domain.auth.dto.request.LoginRequest;
import com.ssafy.edu.domain.auth.dto.request.RefreshRequest;
import com.ssafy.edu.domain.auth.dto.response.LoginResponse;
import com.ssafy.edu.domain.auth.dto.response.TokenResponse;
import com.ssafy.edu.domain.auth.entity.RefreshToken;
import com.ssafy.edu.domain.auth.entity.Role;
import com.ssafy.edu.domain.auth.entity.User;
import com.ssafy.edu.domain.auth.entity.UserStatus;
import com.ssafy.edu.domain.auth.repository.RefreshTokenRepository;
import com.ssafy.edu.domain.auth.repository.UserRepository;
import com.ssafy.edu.global.exception.ApiException;
import com.ssafy.edu.global.exception.ErrorCode;
import com.ssafy.edu.global.file.repository.FileRepository;
import com.ssafy.edu.global.security.JwtProvider;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.util.ReflectionTestUtils;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.verify;

@ExtendWith(MockitoExtension.class)
class AuthServiceTest {

    @Mock UserRepository userRepository;
    @Mock RefreshTokenRepository refreshTokenRepository;
    @Mock FileRepository fileRepository;
    @Mock PasswordEncoder passwordEncoder;
    @Mock JwtProvider jwtProvider;

    AuthService authService;

    @BeforeEach
    void setUp() {
        authService = new AuthService(userRepository, refreshTokenRepository, fileRepository,
                passwordEncoder, jwtProvider, 604800L);
    }

    private User activeUser() {
        User u = new User("hong@test.com", "encoded", "홍길동", Role.STUDENT);
        ReflectionTestUtils.setField(u, "id", 1L);
        return u;
    }

    @Test
    void login_정상_로그인_토큰_반환() {
        User user = activeUser();
        given(userRepository.findByEmail("hong@test.com")).willReturn(Optional.of(user));
        given(passwordEncoder.matches("plain", "encoded")).willReturn(true);
        given(jwtProvider.generateAccessToken(1L, "STUDENT")).willReturn("access-token");
        given(jwtProvider.generateRefreshToken(1L)).willReturn("refresh-token");
        given(refreshTokenRepository.save(any())).willReturn(RefreshToken.of(1L, "refresh-token", 604800L));

        LoginResponse response = authService.login(new LoginRequest("hong@test.com", "plain"));

        assertThat(response.accessToken()).isEqualTo("access-token");
        assertThat(response.refreshToken()).isEqualTo("refresh-token");
        assertThat(response.user().email()).isEqualTo("hong@test.com");
        verify(refreshTokenRepository).deleteByUserId(1L);
    }

    @Test
    void login_이메일_없으면_INVALID_CREDENTIALS() {
        given(userRepository.findByEmail(anyString())).willReturn(Optional.empty());

        assertThatThrownBy(() -> authService.login(new LoginRequest("no@test.com", "pw")))
                .isInstanceOf(ApiException.class)
                .satisfies(e -> assertThat(((ApiException) e).getErrorCode()).isEqualTo(ErrorCode.INVALID_CREDENTIALS));
    }

    @Test
    void login_비밀번호_불일치_INVALID_CREDENTIALS() {
        given(userRepository.findByEmail("hong@test.com")).willReturn(Optional.of(activeUser()));
        given(passwordEncoder.matches(anyString(), anyString())).willReturn(false);

        assertThatThrownBy(() -> authService.login(new LoginRequest("hong@test.com", "wrong")))
                .isInstanceOf(ApiException.class)
                .satisfies(e -> assertThat(((ApiException) e).getErrorCode()).isEqualTo(ErrorCode.INVALID_CREDENTIALS));
    }

    @Test
    void login_비활성_계정_ACCOUNT_INACTIVE() {
        User user = activeUser();
        user.withdraw();
        given(userRepository.findByEmail("hong@test.com")).willReturn(Optional.of(user));
        given(passwordEncoder.matches(anyString(), anyString())).willReturn(true);

        assertThatThrownBy(() -> authService.login(new LoginRequest("hong@test.com", "plain")))
                .isInstanceOf(ApiException.class)
                .satisfies(e -> assertThat(((ApiException) e).getErrorCode()).isEqualTo(ErrorCode.ACCOUNT_INACTIVE));
    }

    @Test
    void logout_리프레시토큰_삭제() {
        authService.logout(1L);
        verify(refreshTokenRepository).deleteByUserId(1L);
    }

    @Test
    void refresh_유효한_토큰_새_토큰_반환() {
        RefreshToken stored = RefreshToken.of(1L, "old-token", 604800L);
        User user = activeUser();
        given(jwtProvider.isTokenValid("old-token")).willReturn(true);
        given(refreshTokenRepository.findByToken("old-token")).willReturn(Optional.of(stored));
        given(jwtProvider.getUserId("old-token")).willReturn(1L);
        given(userRepository.findById(1L)).willReturn(Optional.of(user));
        given(jwtProvider.generateAccessToken(1L, "STUDENT")).willReturn("new-access");
        given(jwtProvider.generateRefreshToken(1L)).willReturn("new-refresh");

        TokenResponse response = authService.refresh(new RefreshRequest("old-token"));

        assertThat(response.accessToken()).isEqualTo("new-access");
        assertThat(response.refreshToken()).isEqualTo("new-refresh");
        verify(refreshTokenRepository).delete(stored);
    }

    @Test
    void refresh_유효하지않은_토큰_TOKEN_INVALID() {
        given(jwtProvider.isTokenValid("bad-token")).willReturn(false);

        assertThatThrownBy(() -> authService.refresh(new RefreshRequest("bad-token")))
                .isInstanceOf(ApiException.class)
                .satisfies(e -> assertThat(((ApiException) e).getErrorCode()).isEqualTo(ErrorCode.TOKEN_INVALID));
    }

    @Test
    void refresh_DB에없는_토큰_TOKEN_INVALID() {
        given(jwtProvider.isTokenValid("orphan")).willReturn(true);
        given(refreshTokenRepository.findByToken("orphan")).willReturn(Optional.empty());

        assertThatThrownBy(() -> authService.refresh(new RefreshRequest("orphan")))
                .isInstanceOf(ApiException.class)
                .satisfies(e -> assertThat(((ApiException) e).getErrorCode()).isEqualTo(ErrorCode.TOKEN_INVALID));
    }
}
