package com.ssafy.edu.domain.auth.entity;

import jakarta.persistence.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@Entity
@Table(name = "users")
@EntityListeners(AuditingEntityListener.class)
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(nullable = false)
    private String password;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(length = 50)
    private String studentNo;

    private Integer generation;

    @Column(length = 100)
    private String region;

    private Integer classNo;

    private Long profileFileId;

    @Column(length = 30)
    private String phoneNumber;

    @Column(length = 30)
    private String emergencyPhoneNumber;

    @Column(length = 20)
    private String zipCode;

    private String address;

    private String addressDetail;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private Role role = Role.STUDENT;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private UserStatus status = UserStatus.ACTIVE;

    @CreatedDate
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @LastModifiedDate
    @Column(nullable = false)
    private LocalDateTime updatedAt;

    protected User() {}

    public User(String email, String password, String name, Role role) {
        this.email = email;
        this.password = password;
        this.name = name;
        this.role = role;
        this.status = UserStatus.ACTIVE;
    }

    public void changePassword(String encodedPw) {
        this.password = encodedPw;
    }

    public void withdraw() {
        this.status = UserStatus.WITHDRAWN;
    }

    public void updateProfile(String name, String phoneNumber, String zipCode,
                              String address, String addressDetail, Long profileFileId) {
        if (name != null) this.name = name;
        if (phoneNumber != null) this.phoneNumber = phoneNumber;
        if (zipCode != null) this.zipCode = zipCode;
        if (address != null) this.address = address;
        if (addressDetail != null) this.addressDetail = addressDetail;
        if (profileFileId != null) this.profileFileId = profileFileId;
    }

    public boolean isActive() {
        return status == UserStatus.ACTIVE;
    }

    public Long getId() { return id; }
    public String getEmail() { return email; }
    public String getPassword() { return password; }
    public String getName() { return name; }
    public String getStudentNo() { return studentNo; }
    public Integer getGeneration() { return generation; }
    public String getRegion() { return region; }
    public Integer getClassNo() { return classNo; }
    public Long getProfileFileId() { return profileFileId; }
    public String getPhoneNumber() { return phoneNumber; }
    public String getEmergencyPhoneNumber() { return emergencyPhoneNumber; }
    public String getZipCode() { return zipCode; }
    public String getAddress() { return address; }
    public String getAddressDetail() { return addressDetail; }
    public Role getRole() { return role; }
    public UserStatus getStatus() { return status; }
    public LocalDateTime getCreatedAt() { return createdAt; }
}
