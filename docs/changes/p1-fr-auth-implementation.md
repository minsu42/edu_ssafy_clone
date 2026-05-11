# P1 — FR-AUTH 구현 완료 보고

- **날짜**: 2026-05-12
- **브랜치**: `feat/p1-fr-auth`
- **커밋**: `afe8996`

---

## 완료 기준

| 기준 | 결과 |
|------|------|
| FR-AUTH-* 8개 요구사항 구현 | PASS |
| `./gradlew test` — 44개 테스트 전부 통과 | PASS |
| 서비스 레이어 단위 테스트 (Mock) | PASS |
| 컨트롤러 레이어 슬라이스 테스트 (MockMvc) | PASS |
| 레포지토리 레이어 통합 테스트 (Testcontainers) | PASS |
| E2E 통합 테스트 (Testcontainers) | PASS |

---

## 테스트 결과 (44개)

| 클래스 | 테스트 수 | 결과 |
|--------|-----------|------|
| `AuthServiceTest` | 8 | ✅ |
| `UserServiceTest` | 7 | ✅ |
| `AuthControllerTest` | 6 | ✅ |
| `UserControllerTest` | 7 | ✅ |
| `SecurityIntegrationTest` | 5 | ✅ |
| `UserRepositoryTest` | 6 | ✅ |
| `RefreshTokenRepositoryTest` | 4 | ✅ |
| `EduApplicationTests` (contextLoads) | 1 | ✅ |

---

## 요구사항별 테스트 커버리지

| 식별자 | 커버하는 테스트 |
|--------|----------------|
| FR-AUTH-LOGIN-001 | `login_정상_로그인_토큰_반환`, `login_이메일_없으면_INVALID_CREDENTIALS`, `login_비밀번호_불일치_INVALID_CREDENTIALS`, `login_비활성_계정_ACCOUNT_INACTIVE`, `login_정상요청_200_반환`, `login_빈_이메일_400_반환`, `login_잘못된_자격증명_401_반환`, `로그인_후_액세스토큰으로_프로필_조회` |
| FR-AUTH-LOGOUT-001 | `logout_리프레시토큰_삭제`, `logout_인증_유저_204_반환`, `로그아웃_정상_처리` |
| FR-AUTH-SESSION-001 | `refresh_유효한_토큰_새_토큰_반환`, `refresh_유효하지않은_토큰_TOKEN_INVALID`, `refresh_DB에없는_토큰_TOKEN_INVALID`, `refresh_정상요청_200_반환`, `refresh_유효하지않은_토큰_401_반환`, `refresh_토큰으로_새토큰_발급` |
| FR-AUTH-PROFILE-001 | `getProfile_정상_조회`, `getProfile_없는_유저_RESOURCE_NOT_FOUND`, `getProfile_정상요청_200_반환`, `getProfile_미인증_401_반환`, `로그인_후_액세스토큰으로_프로필_조회` |
| FR-AUTH-PROFILE-002 | `updateProfile_이름만_변경`, `updateProfile_없는_파일ID_RESOURCE_NOT_FOUND`, `updateProfile_정상요청_200_반환` |
| FR-AUTH-CREDENTIAL-001 | `changePassword_정상_변경_후_리프레시토큰_삭제`, `changePassword_현재비밀번호_불일치_PASSWORD_MISMATCH`, `changePassword_정상요청_204_반환`, `changePassword_패턴불일치_400_반환`, `changePassword_현재비밀번호_불일치_400_반환` |
| FR-AUTH-STATUS-001 | `login_비활성_계정_ACCOUNT_INACTIVE`, `탈퇴_계정_액세스토큰_사용시_401`, `토큰없이_보호된_API_접근시_401` (JwtAuthFilter 경로) |
| FR-AUTH-WITHDRAW-001 | `withdraw_상태_WITHDRAWN으로_변경`, `withdraw_정상요청_204_반환` |

---

## 생성 파일 목록

### Backend — 도메인

| 파일 | 설명 |
|------|------|
| `domain/auth/entity/User.java` | 사용자 엔티티 |
| `domain/auth/entity/Role.java` | 역할 enum (STUDENT, ADMIN, OPERATOR, MENTOR) |
| `domain/auth/entity/UserStatus.java` | 상태 enum (ACTIVE, INACTIVE, WITHDRAWN) |
| `domain/auth/entity/PasswordChangeHistory.java` | 비밀번호 변경 이력 엔티티 |
| `domain/auth/entity/RefreshToken.java` | 리프레시 토큰 엔티티 |
| `domain/auth/repository/UserRepository.java` | 사용자 JPA 레포지토리 |
| `domain/auth/repository/PasswordChangeHistoryRepository.java` | 비밀번호 이력 레포지토리 |
| `domain/auth/repository/RefreshTokenRepository.java` | 리프레시 토큰 레포지토리 |
| `domain/auth/service/AuthService.java` | 로그인/로그아웃/토큰 갱신 서비스 |
| `domain/auth/service/UserService.java` | 프로필 조회/수정/비밀번호 변경/탈퇴 서비스 |
| `domain/auth/controller/AuthController.java` | `/api/auth/**` 엔드포인트 |
| `domain/auth/controller/UserController.java` | `/api/users/**` 엔드포인트 |
| `domain/auth/dto/request/LoginRequest.java` | 로그인 요청 DTO |
| `domain/auth/dto/request/RefreshRequest.java` | 토큰 갱신 요청 DTO |
| `domain/auth/dto/request/UpdateProfileRequest.java` | 프로필 수정 요청 DTO |
| `domain/auth/dto/request/ChangePasswordRequest.java` | 비밀번호 변경 요청 DTO |
| `domain/auth/dto/response/LoginResponse.java` | 로그인 응답 DTO |
| `domain/auth/dto/response/TokenResponse.java` | 토큰 갱신 응답 DTO |
| `domain/auth/dto/response/UserResponse.java` | 사용자 정보 응답 DTO |

### Backend — 글로벌

| 파일 | 설명 |
|------|------|
| `global/security/JwtProvider.java` | JWT 생성/검증 (access 15분, refresh 7일) |
| `global/security/JwtAuthFilter.java` | OncePerRequestFilter — 토큰 인증 + 계정 상태 검증 |
| `global/config/SecurityConfig.java` | Spring Security 설정 (퍼블릭/보호 경로 분리) |
| `global/response/ApiResponse.java` | 공통 응답 래퍼 |
| `global/file/entity/File.java` | 파일 엔티티 (files 테이블) |
| `global/file/repository/FileRepository.java` | 파일 레포지토리 |

### Backend — 테스트

| 파일 | 설명 |
|------|------|
| `TestcontainersConfiguration.java` | MySQL Testcontainers 공통 설정 |
| `domain/auth/service/AuthServiceTest.java` | AuthService Mock 단위 테스트 (8개) |
| `domain/auth/service/UserServiceTest.java` | UserService Mock 단위 테스트 (7개) |
| `domain/auth/controller/AuthControllerTest.java` | AuthController MockMvc 슬라이스 테스트 (6개) |
| `domain/auth/controller/UserControllerTest.java` | UserController MockMvc 슬라이스 테스트 (7개) |
| `domain/auth/repository/UserRepositoryTest.java` | UserRepository Testcontainers 통합 테스트 (6개) |
| `domain/auth/repository/RefreshTokenRepositoryTest.java` | RefreshTokenRepository Testcontainers 통합 테스트 (4개) |
| `domain/auth/SecurityIntegrationTest.java` | 전체 흐름 E2E 통합 테스트 (5개) |
