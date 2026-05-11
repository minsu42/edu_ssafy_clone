package com.ssafy.edu.domain.auth.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.ssafy.edu.TestcontainersConfiguration;
import com.ssafy.edu.domain.auth.dto.request.ChangePasswordRequest;
import com.ssafy.edu.domain.auth.dto.request.UpdateProfileRequest;
import com.ssafy.edu.domain.auth.dto.response.UserResponse;
import com.ssafy.edu.domain.auth.service.UserService;
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

import java.time.LocalDateTime;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.BDDMockito.given;
import static org.mockito.BDDMockito.willThrow;
import static org.mockito.Mockito.verify;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.springSecurity;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@Import(TestcontainersConfiguration.class)
class UserControllerTest {

    @Autowired WebApplicationContext wac;

    @MockitoBean UserService userService;

    private final ObjectMapper objectMapper = new ObjectMapper().registerModule(new JavaTimeModule());

    private MockMvc mockMvc;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.webAppContextSetup(wac)
                .apply(springSecurity())
                .build();
    }

    private UserResponse sampleUser() {
        return new UserResponse(1L, "hong@test.com", "홍길동", null, null, null, null,
                null, null, null, null, null, "STUDENT", "ACTIVE", null, LocalDateTime.now());
    }

    @Test
    @WithMockUser
    void getProfile_정상요청_200_반환() throws Exception {
        given(userService.getProfile(any())).willReturn(sampleUser());

        mockMvc.perform(get("/api/v1/users/me"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.email").value("hong@test.com"));
    }

    @Test
    void getProfile_미인증_401_반환() throws Exception {
        mockMvc.perform(get("/api/v1/users/me"))
                .andExpect(status().isUnauthorized());
    }

    @Test
    @WithMockUser
    void updateProfile_정상요청_200_반환() throws Exception {
        given(userService.updateProfile(any(), any())).willReturn(sampleUser());

        mockMvc.perform(patch("/api/v1/users/me")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(
                                new UpdateProfileRequest("새이름", null, null, null, null, null))))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.name").value("홍길동"));
    }

    @Test
    @WithMockUser
    void changePassword_정상요청_204_반환() throws Exception {
        mockMvc.perform(put("/api/v1/users/me/password")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(
                                new ChangePasswordRequest("current", "New@pass1"))))
                .andExpect(status().isNoContent());
    }

    @Test
    @WithMockUser
    void changePassword_패턴불일치_400_반환() throws Exception {
        mockMvc.perform(put("/api/v1/users/me/password")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(
                                new ChangePasswordRequest("current", "weak"))))
                .andExpect(status().isBadRequest());
    }

    @Test
    @WithMockUser
    void changePassword_현재비밀번호_불일치_400_반환() throws Exception {
        willThrow(new ApiException(ErrorCode.PASSWORD_MISMATCH))
                .given(userService).changePassword(any(), any(), any(), any());

        mockMvc.perform(put("/api/v1/users/me/password")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(
                                new ChangePasswordRequest("wrong", "New@pass1"))))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value("ERR-AUTH-005"));
    }

    @Test
    @WithMockUser
    void withdraw_정상요청_204_반환() throws Exception {
        mockMvc.perform(delete("/api/v1/users/me")
                        .with(csrf()))
                .andExpect(status().isNoContent());

        verify(userService).withdraw(any());
    }
}
