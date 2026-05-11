package com.ssafy.edu.domain.auth.entity;

import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "password_change_histories")
public class PasswordChangeHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Long userId;

    @Column(nullable = false)
    private LocalDateTime changedAt = LocalDateTime.now();

    @Column(length = 45)
    private String ipAddress;

    @Column(length = 500)
    private String userAgent;

    protected PasswordChangeHistory() {}

    public static PasswordChangeHistory of(Long userId, String ipAddress, String userAgent) {
        PasswordChangeHistory h = new PasswordChangeHistory();
        h.userId = userId;
        h.ipAddress = ipAddress;
        h.userAgent = userAgent;
        return h;
    }
}
