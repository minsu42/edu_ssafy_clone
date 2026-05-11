package com.ssafy.edu.domain.auth.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

public record ChangePasswordRequest(
        @NotBlank String currentPassword,
        @NotBlank
        @Pattern(
                regexp = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*]).{8,}$",
                message = "8자 이상, 영문·숫자·특수문자(!@#$%^&*) 각 1자 이상 포함해야 합니다"
        )
        String newPassword
) {}
