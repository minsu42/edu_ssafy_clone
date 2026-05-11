package com.ssafy.edu.domain.auth.controller;

import com.ssafy.edu.domain.auth.dto.request.LoginRequest;
import com.ssafy.edu.domain.auth.dto.request.RefreshRequest;
import com.ssafy.edu.domain.auth.dto.response.LoginResponse;
import com.ssafy.edu.domain.auth.dto.response.TokenResponse;
import com.ssafy.edu.domain.auth.service.AuthService;
import com.ssafy.edu.global.response.ApiResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@Tag(name = "Auth", description = "인증 API")
@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @Operation(summary = "로그인", description = "FR-AUTH-LOGIN-001")
    @PostMapping("/login")
    public ResponseEntity<ApiResponse<LoginResponse>> login(@Valid @RequestBody LoginRequest request) {
        return ResponseEntity.ok(ApiResponse.success(authService.login(request)));
    }

    @Operation(summary = "로그아웃", description = "FR-AUTH-LOGOUT-001")
    @PostMapping("/logout")
    public ResponseEntity<Void> logout(@AuthenticationPrincipal Long userId) {
        authService.logout(userId);
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "토큰 갱신", description = "FR-AUTH-SESSION-001")
    @PostMapping("/refresh")
    public ResponseEntity<ApiResponse<TokenResponse>> refresh(@Valid @RequestBody RefreshRequest request) {
        return ResponseEntity.ok(ApiResponse.success(authService.refresh(request)));
    }
}
