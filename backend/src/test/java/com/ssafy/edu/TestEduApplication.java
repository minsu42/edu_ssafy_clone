package com.ssafy.edu;

import org.springframework.boot.SpringApplication;

public class TestEduApplication {

	public static void main(String[] args) {
		SpringApplication.from(EduApplication::main).with(TestcontainersConfiguration.class).run(args);
	}

}
