package com.ssafy.edu.domain.auth.entity;

import jakarta.persistence.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@Entity
@Table(name = "password_change_histories")
@EntityListeners(AuditingEntityListener.class)
public class PasswordChangeHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Long userId;

    @CreatedDate
    @Column(nullable = false, updatable = false)
    private LocalDateTime changedAt;

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
