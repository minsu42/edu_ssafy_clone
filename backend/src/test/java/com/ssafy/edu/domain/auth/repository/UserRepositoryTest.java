package com.ssafy.edu.domain.auth.repository;

import com.ssafy.edu.TestcontainersConfiguration;
import com.ssafy.edu.domain.auth.entity.Role;
import com.ssafy.edu.domain.auth.entity.User;
import com.ssafy.edu.domain.auth.entity.UserStatus;
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
class UserRepositoryTest {

    @Autowired
    private UserRepository userRepository;

    private User savedUser(String email) {
        return userRepository.save(new User(email, "encoded-pw", "홍길동", Role.STUDENT));
    }

    @Test
    void findByEmail_존재하는_이메일_반환() {
        savedUser("hong@test.com");

        Optional<User> result = userRepository.findByEmail("hong@test.com");

        assertThat(result).isPresent();
        assertThat(result.get().getEmail()).isEqualTo("hong@test.com");
    }

    @Test
    void findByEmail_없는_이메일_빈값_반환() {
        Optional<User> result = userRepository.findByEmail("none@test.com");

        assertThat(result).isEmpty();
    }

    @Test
    void existsByEmail_존재하면_true() {
        savedUser("exist@test.com");

        assertThat(userRepository.existsByEmail("exist@test.com")).isTrue();
    }

    @Test
    void existsByEmail_없으면_false() {
        assertThat(userRepository.existsByEmail("no@test.com")).isFalse();
    }

    @Test
    void 신규_유저_기본_상태는_ACTIVE() {
        User user = savedUser("active@test.com");

        assertThat(user.getStatus()).isEqualTo(UserStatus.ACTIVE);
        assertThat(user.getRole()).isEqualTo(Role.STUDENT);
    }

    @Test
    void withdraw_호출_후_상태는_WITHDRAWN() {
        User user = savedUser("withdraw@test.com");
        user.withdraw();
        userRepository.save(user);

        User found = userRepository.findById(user.getId()).orElseThrow();
        assertThat(found.getStatus()).isEqualTo(UserStatus.WITHDRAWN);
    }
}
