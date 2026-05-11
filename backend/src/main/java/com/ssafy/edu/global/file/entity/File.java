package com.ssafy.edu.global.file.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "files")
public class File {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 500)
    private String fileUrl;

    protected File() {}

    public Long getId() { return id; }
    public String getFileUrl() { return fileUrl; }
}
