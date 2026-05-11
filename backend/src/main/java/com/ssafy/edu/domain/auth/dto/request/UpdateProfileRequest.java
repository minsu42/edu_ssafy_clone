package com.ssafy.edu.domain.auth.dto.request;

import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record UpdateProfileRequest(
        @Size(max = 100) String name,
        @Pattern(regexp = "^$|^\\d{2,3}-\\d{3,4}-\\d{4}$", message = "전화번호 형식이 올바르지 않습니다 (예: 010-1234-5678)")
        String phoneNumber,
        @Size(max = 20) String zipCode,
        @Size(max = 255) String address,
        @Size(max = 255) String addressDetail,
        Long profileFileId
) {}
