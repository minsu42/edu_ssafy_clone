package com.ssafy.edu.global.file.repository;

import com.ssafy.edu.global.file.entity.File;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FileRepository extends JpaRepository<File, Long> {
}
