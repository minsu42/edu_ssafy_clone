package com.ssafy.edu.domain.auth.repository;

import com.ssafy.edu.TestcontainersConfiguration;
import com.ssafy.edu.domain.auth.entity.RefreshToken;
import com.ssafy.edu.domain.auth.entity.Role;
import com.ssafy.edu.domain.auth.entity.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Import;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@Import(TestcontainersConfiguration.class)
@Transactional
class RefreshTokenRepositoryTest {

    @Autowired RefreshTokenRepository refreshTokenRepository;
    @Autowired UserRepository userRepository;

    private long userId1;
    private long userId2;
    private long userId3;

    @BeforeEach
    void setUp() {
        userId1 = userRepository.save(new User("u1@test.com", "pw", "유저1", Role.STUDENT)).getId();
        userId2 = userRepository.save(new User("u2@test.com", "pw", "유저2", Role.STUDENT)).getId();
        userId3 = userRepository.save(new User("u3@test.com", "pw", "유저3", Role.STUDENT)).getId();
    }

    @Test
    void findByToken_존재하는_토큰_반환() {
        refreshTokenRepository.save(RefreshToken.of(userId1, "valid-token", 604800L));

        Optional<RefreshToken> result = refreshTokenRepository.findByToken("valid-token");

        assertThat(result).isPresent();
        assertThat(result.get().getUserId()).isEqualTo(userId1);
    }

    @Test
    void findByToken_없는_토큰_빈값_반환() {
        Optional<RefreshToken> result = refreshTokenRepository.findByToken("ghost-token");

        assertThat(result).isEmpty();
    }

    @Test
    void deleteByUserId_해당_유저_토큰_삭제() {
        refreshTokenRepository.save(RefreshToken.of(userId1, "token-a", 604800L));
        refreshTokenRepository.save(RefreshToken.of(userId1, "token-b", 604800L));
        refreshTokenRepository.save(RefreshToken.of(userId2, "token-other", 604800L));

        refreshTokenRepository.deleteByUserId(userId1);

        assertThat(refreshTokenRepository.findByToken("token-a")).isEmpty();
        assertThat(refreshTokenRepository.findByToken("token-b")).isEmpty();
        assertThat(refreshTokenRepository.findByToken("token-other")).isPresent();
    }

    @Test
    void deleteByUserId_없는_유저_예외없이_통과() {
        refreshTokenRepository.deleteByUserId(999L);
        // no exception expected
    }
}
