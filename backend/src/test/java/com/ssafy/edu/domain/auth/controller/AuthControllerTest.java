package com.ssafy.edu.domain.auth.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.ssafy.edu.TestcontainersConfiguration;
import com.ssafy.edu.domain.auth.dto.request.LoginRequest;
import com.ssafy.edu.domain.auth.dto.request.RefreshRequest;
import com.ssafy.edu.domain.auth.dto.response.LoginResponse;
import com.ssafy.edu.domain.auth.dto.response.TokenResponse;
import com.ssafy.edu.domain.auth.service.AuthService;
import com.ssafy.edu.global.exception.ApiException;
import com.ssafy.edu.global.exception.ErrorCode;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.BDDMockito.given;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.springSecurity;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@Import(TestcontainersConfiguration.class)
class AuthControllerTest {

    @Autowired WebApplicationContext wac;

    @MockitoBean AuthService authService;

    private final ObjectMapper objectMapper = new ObjectMapper().registerModule(new JavaTimeModule());

    private MockMvc mockMvc;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.webAppContextSetup(wac)
                .apply(springSecurity())
                .build();
    }

    @Test
    void login_정상요청_200_반환() throws Exception {
        LoginResponse.LoginUserInfo userInfo = new LoginResponse.LoginUserInfo(1L, "hong@test.com", "홍길동", "STUDENT", null);
        given(authService.login(any())).willReturn(new LoginResponse("access", "refresh", userInfo));

        mockMvc.perform(post("/api/v1/auth/login")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(new LoginRequest("hong@test.com", "pass"))))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.accessToken").value("access"))
                .andExpect(jsonPath("$.data.user.email").value("hong@test.com"));
    }

    @Test
    void login_빈_이메일_400_반환() throws Exception {
        mockMvc.perform(post("/api/v1/auth/login")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(new LoginRequest("", "pass"))))
                .andExpect(status().isBadRequest());
    }

    @Test
    void login_잘못된_자격증명_401_반환() throws Exception {
        given(authService.login(any())).willThrow(new ApiException(ErrorCode.INVALID_CREDENTIALS));

        mockMvc.perform(post("/api/v1/auth/login")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(new LoginRequest("hong@test.com", "wrong"))))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.code").value("ERR-AUTH-001"));
    }

    @Test
    @WithMockUser
    void logout_인증_유저_204_반환() throws Exception {
        mockMvc.perform(post("/api/v1/auth/logout")
                        .with(csrf()))
                .andExpect(status().isNoContent());
    }

    @Test
    void refresh_정상요청_200_반환() throws Exception {
        given(authService.refresh(any())).willReturn(new TokenResponse("new-access", "new-refresh"));

        mockMvc.perform(post("/api/v1/auth/refresh")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(new RefreshRequest("old-refresh"))))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.accessToken").value("new-access"));
    }

    @Test
    void refresh_유효하지않은_토큰_401_반환() throws Exception {
        given(authService.refresh(any())).willThrow(new ApiException(ErrorCode.TOKEN_INVALID));

        mockMvc.perform(post("/api/v1/auth/refresh")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(new RefreshRequest("bad"))))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.code").value("ERR-AUTH-004"));
    }
}
