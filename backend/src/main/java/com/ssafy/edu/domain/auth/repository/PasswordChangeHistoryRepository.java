package com.ssafy.edu.domain.auth.repository;

import com.ssafy.edu.domain.auth.entity.PasswordChangeHistory;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PasswordChangeHistoryRepository extends JpaRepository<PasswordChangeHistory, Long> {
}
