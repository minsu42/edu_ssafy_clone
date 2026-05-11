package com.ssafy.edu.domain.auth.service;

import com.ssafy.edu.domain.auth.dto.request.ChangePasswordRequest;
import com.ssafy.edu.domain.auth.dto.request.UpdateProfileRequest;
import com.ssafy.edu.domain.auth.dto.response.UserResponse;
import com.ssafy.edu.domain.auth.entity.Role;
import com.ssafy.edu.domain.auth.entity.User;
import com.ssafy.edu.domain.auth.entity.UserStatus;
import com.ssafy.edu.domain.auth.repository.PasswordChangeHistoryRepository;
import com.ssafy.edu.domain.auth.repository.RefreshTokenRepository;
import com.ssafy.edu.domain.auth.repository.UserRepository;
import com.ssafy.edu.global.exception.ApiException;
import com.ssafy.edu.global.exception.ErrorCode;
import com.ssafy.edu.global.file.entity.File;
import com.ssafy.edu.global.file.repository.FileRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.util.ReflectionTestUtils;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.BDDMockito.given;
import static org.mockito.BDDMockito.willThrow;
import static org.mockito.Mockito.verify;

@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock UserRepository userRepository;
    @Mock RefreshTokenRepository refreshTokenRepository;
    @Mock PasswordChangeHistoryRepository historyRepository;
    @Mock FileRepository fileRepository;
    @Mock PasswordEncoder passwordEncoder;

    @InjectMocks UserService userService;

    private User activeUser() {
        User u = new User("hong@test.com", "encoded", "홍길동", Role.STUDENT);
        ReflectionTestUtils.setField(u, "id", 1L);
        return u;
    }

    @Test
    void getProfile_정상_조회() {
        given(userRepository.findById(1L)).willReturn(Optional.of(activeUser()));

        UserResponse response = userService.getProfile(1L);

        assertThat(response.email()).isEqualTo("hong@test.com");
        assertThat(response.name()).isEqualTo("홍길동");
    }

    @Test
    void getProfile_없는_유저_RESOURCE_NOT_FOUND() {
        given(userRepository.findById(999L)).willReturn(Optional.empty());

        assertThatThrownBy(() -> userService.getProfile(999L))
                .isInstanceOf(ApiException.class)
                .satisfies(e -> assertThat(((ApiException) e).getErrorCode()).isEqualTo(ErrorCode.RESOURCE_NOT_FOUND));
    }

    @Test
    void updateProfile_이름만_변경() {
        User user = activeUser();
        given(userRepository.findById(1L)).willReturn(Optional.of(user));

        UserResponse response = userService.updateProfile(1L,
                new UpdateProfileRequest("새이름", null, null, null, null, null));

        assertThat(response.name()).isEqualTo("새이름");
    }

    @Test
    void updateProfile_없는_파일ID_RESOURCE_NOT_FOUND() {
        given(userRepository.findById(1L)).willReturn(Optional.of(activeUser()));
        given(fileRepository.existsById(99L)).willReturn(false);

        assertThatThrownBy(() -> userService.updateProfile(1L,
                new UpdateProfileRequest(null, null, null, null, null, 99L)))
                .isInstanceOf(ApiException.class)
                .satisfies(e -> assertThat(((ApiException) e).getErrorCode()).isEqualTo(ErrorCode.RESOURCE_NOT_FOUND));
    }

    @Test
    void changePassword_정상_변경_후_리프레시토큰_삭제() {
        User user = activeUser();
        given(userRepository.findById(1L)).willReturn(Optional.of(user));
        given(passwordEncoder.matches("current", "encoded")).willReturn(true);
        given(passwordEncoder.encode("New@pass1")).willReturn("new-encoded");

        userService.changePassword(1L, new ChangePasswordRequest("current", "New@pass1"), "127.0.0.1", "test-ua");

        verify(refreshTokenRepository).deleteByUserId(1L);
        verify(historyRepository).save(any());
    }

    @Test
    void changePassword_현재비밀번호_불일치_PASSWORD_MISMATCH() {
        given(userRepository.findById(1L)).willReturn(Optional.of(activeUser()));
        given(passwordEncoder.matches(anyString(), anyString())).willReturn(false);

        assertThatThrownBy(() -> userService.changePassword(1L,
                new ChangePasswordRequest("wrong", "New@pass1"), "127.0.0.1", "ua"))
                .isInstanceOf(ApiException.class)
                .satisfies(e -> assertThat(((ApiException) e).getErrorCode()).isEqualTo(ErrorCode.PASSWORD_MISMATCH));
    }

    @Test
    void withdraw_상태_WITHDRAWN으로_변경() {
        User user = activeUser();
        given(userRepository.findById(1L)).willReturn(Optional.of(user));

        userService.withdraw(1L);

        assertThat(user.getStatus()).isEqualTo(UserStatus.WITHDRAWN);
        verify(refreshTokenRepository).deleteByUserId(1L);
    }
}
