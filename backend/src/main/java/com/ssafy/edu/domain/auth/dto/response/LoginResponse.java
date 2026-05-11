package com.ssafy.edu.domain.auth.dto.response;

public record LoginResponse(String accessToken, String refreshToken, LoginUserInfo user) {

    public record LoginUserInfo(Long id, String email, String name, String role, String profileImageUrl) {}
}
