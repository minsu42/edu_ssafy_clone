# P0 — 프로젝트 부트스트랩 완료 보고

- **날짜**: 2026-05-11
- **브랜치**: `feat/p0-project-bootstrap`
- **스택**: Spring Boot 4.0.6 / Java 21 / Vue 3 + Vite

---

## 완료 기준

| 기준 | 결과 |
|------|------|
| `./gradlew test` — contextLoads() 통과 | PASS |
| `npm run test` — 빈 스토어 스모크 테스트 통과 | PASS |
| MySQL Testcontainers + schema.sql DDL 실행 | PASS |
| Swagger UI 초기화 (컨텍스트 로드 성공) | PASS |

---

## 생성 파일 목록

### 백엔드 (`backend/`)

| 파일 | 설명 |
|------|------|
| `build.gradle` | Spring Boot 4.0.6, Java 21, JJWT 0.12.6, springdoc 3.0.3, Testcontainers BOM 1.21.4, JaCoCo |
| `src/main/resources/application.yml` | 운영 설정 (datasource, JPA, Swagger, JWT) |
| `src/test/resources/application.yml` | 테스트 설정 (ddl-auto=none, schema.sql 자동 실행) |
| `global/config/SecurityConfig.java` | JWT Stateless, permitAll 경로 설정, BCrypt |
| `global/config/JpaConfig.java` | JPA Auditing 활성화 |
| `global/config/WebConfig.java` | CORS (localhost:5173) |
| `global/config/SwaggerConfig.java` | OpenAPI 3, Bearer Auth 스키마 |
| `global/exception/ErrorCode.java` | 14개 에러코드 (ERR-CMN, ERR-AUTH, ERR-QUEST, ERR-BOARD, ERR-SURVEY) |
| `global/exception/ApiException.java` | 커스텀 런타임 예외 |
| `global/exception/GlobalExceptionHandler.java` | @RestControllerAdvice, 유효성 검증 오류 처리 |
| `global/response/ApiResponse<T>.java` | 표준 응답 래퍼 |
| `global/response/PageResponse<T>.java` | 페이징 응답 래퍼 |
| `global/security/JwtProvider.java` | Access/Refresh 토큰 발급·검증 |
| `global/security/JwtAuthFilter.java` | OncePerRequestFilter, Bearer 파싱 |
| `global/security/CustomUserDetails.java` | userId, role 포함 UserDetails |
| `domain/{auth,dashboard,lecture,quest,community,notice}/` | 도메인 패키지 골격 |
| `test/.../TestcontainersConfiguration.java` | mysql:8.0, withReuse(true) |
| `test/.../EduApplicationTests.java` | contextLoads() 스모크 테스트 |

### 프론트엔드 (`frontend/`)

| 파일 | 설명 |
|------|------|
| `package.json` | Vue 3, Pinia, Vite, Vitest, MSW v2, @vue/test-utils |
| `vite.config.ts` | alias(@), dev proxy(/api → :8080) |
| `vitest.config.ts` | happy-dom, setupFiles |
| `src/test/setup.ts` | MSW server.listen/resetHandlers/close |
| `src/test/server.ts` | setupServer(handlers) |
| `src/test/handlers/index.ts` | 도메인별 핸들러 등록 진입점 |
| `src/stores/auth.ts` | AuthStore 초기 골격 (isAuthenticated, user, accessToken) |
| `src/stores/__tests__/smoke.test.ts` | 초기 상태 검증 스모크 테스트 |

---

## 주요 이슈 및 해결

| 이슈 | 해결 |
|------|------|
| Spring Initializr tar 추출 시 `--strip-components` 오적용 | 옵션 제거 후 재추출 |
| Testcontainers Docker API 버전 충돌 (요구 1.44, 전송 1.32) | BOM `1.20.x` → `1.21.4` 업그레이드 |
| springdoc Spring Boot 4.x 비호환 | `2.7.0` → `3.0.3` 교체 |
| Java 21 미설치 | `sudo apt-get install openjdk-21-jdk` 후 `JAVA_HOME` 지정 |
| HTTPS git push 인증 실패 | `gh auth login` + `gh auth setup-git`으로 해결 |

---

## 다음 단계

**D1 — FR-AUTH 문서화**
- `docs/api/auth.md` 8개 엔드포인트 명세 작성
- `docs/requirements/03_기능_요구사항.md` FR-AUTH-XXX 정상/예외 시나리오 추가
- `docs/requirements/05_요구사항_추적표.md` 업데이트
