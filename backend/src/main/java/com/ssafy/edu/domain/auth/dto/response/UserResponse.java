package com.ssafy.edu.domain.auth.dto.response;

import com.ssafy.edu.domain.auth.entity.User;

import java.time.LocalDateTime;

public record UserResponse(
        Long id,
        String email,
        String name,
        String studentNo,
        Integer generation,
        String region,
        Integer classNo,
        String phoneNumber,
        String emergencyPhoneNumber,
        String zipCode,
        String address,
        String addressDetail,
        String role,
        String status,
        String profileImageUrl,
        LocalDateTime createdAt
) {
    public static UserResponse of(User user, String profileImageUrl) {
        return new UserResponse(
                user.getId(),
                user.getEmail(),
                user.getName(),
                user.getStudentNo(),
                user.getGeneration(),
                user.getRegion(),
                user.getClassNo(),
                user.getPhoneNumber(),
                user.getEmergencyPhoneNumber(),
                user.getZipCode(),
                user.getAddress(),
                user.getAddressDetail(),
                user.getRole().name(),
                user.getStatus().name(),
                profileImageUrl,
                user.getCreatedAt()
        );
    }
}
