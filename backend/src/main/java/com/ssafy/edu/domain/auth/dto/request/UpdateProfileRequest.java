package com.ssafy.edu.domain.auth.dto.request;

public record UpdateProfileRequest(
        String name,
        String phoneNumber,
        String zipCode,
        String address,
        String addressDetail,
        Long profileFileId
) {}
