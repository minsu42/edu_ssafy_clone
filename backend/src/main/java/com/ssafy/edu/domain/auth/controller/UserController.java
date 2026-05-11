package com.ssafy.edu.domain.auth.controller;

import com.ssafy.edu.domain.auth.dto.request.ChangePasswordRequest;
import com.ssafy.edu.domain.auth.dto.request.UpdateProfileRequest;
import com.ssafy.edu.domain.auth.dto.response.UserResponse;
import com.ssafy.edu.domain.auth.service.UserService;
import com.ssafy.edu.global.response.ApiResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@Tag(name = "User", description = "사용자 계정 API")
@RestController
@RequestMapping("/api/v1/users")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @Operation(summary = "내 프로필 조회", description = "FR-AUTH-PROFILE-001")
    @GetMapping("/me")
    public ResponseEntity<ApiResponse<UserResponse>> getProfile(@AuthenticationPrincipal Long userId) {
        return ResponseEntity.ok(ApiResponse.success(userService.getProfile(userId)));
    }

    @Operation(summary = "내 프로필 수정", description = "FR-AUTH-PROFILE-002")
    @PatchMapping("/me")
    public ResponseEntity<ApiResponse<UserResponse>> updateProfile(
            @AuthenticationPrincipal Long userId,
            @Valid @RequestBody UpdateProfileRequest request) {
        return ResponseEntity.ok(ApiResponse.success(userService.updateProfile(userId, request)));
    }

    @Operation(summary = "비밀번호 변경", description = "FR-AUTH-CREDENTIAL-001")
    @PutMapping("/me/password")
    public ResponseEntity<Void> changePassword(
            @AuthenticationPrincipal Long userId,
            @Valid @RequestBody ChangePasswordRequest request,
            HttpServletRequest httpRequest) {
        String ip = httpRequest.getRemoteAddr();
        String ua = httpRequest.getHeader("User-Agent");
        userService.changePassword(userId, request, ip, ua);
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "회원 탈퇴", description = "FR-AUTH-WITHDRAW-001")
    @DeleteMapping("/me")
    public ResponseEntity<Void> withdraw(@AuthenticationPrincipal Long userId) {
        userService.withdraw(userId);
        return ResponseEntity.noContent().build();
    }
}
