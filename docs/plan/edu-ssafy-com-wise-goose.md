# 에듀싸피 클론 TDD 기반 전체 개발 계획

## Context

edu.ssafy.com 클론 코딩 프로젝트. 멀티 에이전트 하네스 프롬프팅 구조의 코드 생성 품질 검증이 실제 목적이며, TDD 방식으로 기능 단위 구현을 진행한다. 백엔드(Spring Boot)/프론트엔드(Vue 3) 모두 코드가 없는 상태에서 시작하며, DB 설계(schema.sql 32개 테이블)와 UI 스크린샷(40장)이 기준 문서다.

---

## 개발 원칙

각 도메인은 반드시 다음 순서를 지킨다. 문서화 없이 구현에 진입하지 않는다.

```
[문서화]                             [구현 — TDD]
① 요구사항 도출 (NFR-XXX 작성)
② API 명세 작성 (엔드포인트/DTO)  →  ③ 테스트 작성 (RED)
③ 요구사항 추적표 업데이트         →  ④ 구현 (GREEN)
                                    →  ⑤ 리팩터 (REFACTOR)
```

---

## 기술 결정 사항

| 항목 | 결정 | 이유 |
|------|------|------|
| 인증 방식 | JWT (Access 15분 + Refresh 7일, DB 저장) | 스케일 아웃 대비, 강제 만료 지원 |
| 테스트 인프라 | Testcontainers + MySQL 8 | JSON 컬럼, FULLTEXT 인덱스, CHECK constraint가 H2 미지원 |
| API 버전 | `/api/v1/` 고정 프리픽스 | 현재 단일 버전 |
| 전역 오류 처리 | `@RestControllerAdvice` + `ApiException` + `ErrorCode` enum | `ERR-{도메인}-{번호}` 형식 |
| 프론트엔드 모킹 | MSW (Mock Service Worker) v2 | Vitest 환경에서 API 의존 없는 스토어 테스트 |
| API 명세 도구 | Swagger (springdoc-openapi) | 코드와 명세 동기화, 프론트 개발 계약 기준 |

---

## 전체 페이즈 로드맵

| 페이즈 | 유형 | 이름 | 추정 기간 | 누적 |
|--------|------|------|-----------|------|
| P0 | 구현 | 프로젝트 부트스트랩 | 2일 | 2일 |
| D1 | **문서화** | FR-AUTH 요구사항 보완 + API 명세 | 1일 | 3일 |
| P1 | 구현 | FR-AUTH 인증/계정 | 5일 | 8일 |
| D2 | **문서화** | FR-DASHBOARD 요구사항 도출 + API 명세 | 1일 | 9일 |
| P2 | 구현 | FR-DASHBOARD 대시보드 | 4일 | 13일 |
| D3 | **문서화** | FR-LECTURE 요구사항 도출 + API 명세 | 1일 | 14일 |
| P3 | 구현 | FR-LECTURE 강의실 & 이러닝 | 6일 | 20일 |
| D4 | **문서화** | FR-QUEST 요구사항 도출 + API 명세 | 1일 | 21일 |
| P4 | 구현 | FR-QUEST Quest/평가 | 4일 | 25일 |
| D5 | **문서화** | FR-COMMUNITY 요구사항 도출 + API 명세 | 1일 | 26일 |
| P5 | 구현 | FR-COMMUNITY 커뮤니티 | 5일 | 31일 |
| D6 | **문서화** | FR-NOTICE 요구사항 도출 + API 명세 | 1일 | 32일 |
| P6 | 구현 | FR-NOTICE 공지/알림 | 3일 | 35일 |
| P7 | 구현 | 횡단 관심사 & 통합 시나리오 | 3일 | 38일 |

**크리티컬 패스**: P0 → D1 → P1 → D3 → P3 → D4 → P4 → P7 (24일)

---

## 도메인 의존성 그래프

```
P0 (Bootstrap)
  └─ D1 → P1 (FR-AUTH)               ← 모든 도메인 기반. 가장 먼저 완료
              ├─ D2 → P2 (FR-DASHBOARD)
              ├─ D3 → P3 (FR-LECTURE)
              │          └─ D4 → P4 (FR-QUEST)
              ├─ D5 → P5 (FR-COMMUNITY)
              └─ D6 → P6 (FR-NOTICE)
                           └─ P7 (E2E)
```

---

## P0 — 프로젝트 부트스트랩 (2일)

### 목표
`./gradlew test`와 `npm run test`가 통과하는 "빈 뼈대" 생성. 문서화 없이 진입 가능한 유일한 페이즈.

### 백엔드 설정

**패키지 구조**: `com.ssafy.edu`
```
├── global/
│   ├── config/        # SecurityConfig, JpaConfig, WebConfig, SwaggerConfig
│   ├── exception/     # ApiException, GlobalExceptionHandler, ErrorCode
│   ├── response/      # ApiResponse<T>, PageResponse<T>
│   └── security/      # JwtProvider, JwtAuthFilter, CustomUserDetails
└── domain/
    ├── auth/
    ├── dashboard/
    ├── lecture/
    ├── quest/
    ├── community/
    └── notice/
```

**핵심 의존성** (`backend/build.gradle`):
```groovy
// 운영
implementation 'org.springframework.boot:spring-boot-starter-data-jpa'
implementation 'org.springframework.boot:spring-boot-starter-security'
implementation 'org.springframework.boot:spring-boot-starter-web'
implementation 'org.springframework.boot:spring-boot-starter-validation'
implementation 'io.jsonwebtoken:jjwt-api:0.12.x'
implementation 'org.springdoc:springdoc-openapi-starter-webmvc-ui:2.x'

// 테스트
testImplementation 'org.springframework.boot:spring-boot-starter-test'
testImplementation 'org.springframework.security:spring-security-test'
testImplementation 'org.testcontainers:junit-jupiter'
testImplementation 'org.testcontainers:mysql'
```

**Testcontainers 공유 설정** (`TestContainersConfiguration.java`):
```java
@TestConfiguration(proxyBeanMethods = false)
public class TestContainersConfiguration {
    @Bean @ServiceConnection
    MySQLContainer<?> mysqlContainer() {
        return new MySQLContainer<>("mysql:8.0").withReuse(true);
    }
}
```
`~/.testcontainers.properties`에 `testcontainers.reuse.enable=true` 추가

**보안 테스트 픽스처**:
- `WithMockSsafyUser` 커스텀 어노테이션 (userId, role 포함)
- `SecurityTestConfig` — 테스트용 permitAll CORS 설정

### 프론트엔드 설정

**핵심 devDependency** (`frontend/package.json`):
```json
"vitest": "^1.x", "@vue/test-utils": "^2.x",
"msw": "^2.x", "happy-dom": "^x", "@testing-library/vue": "^8.x"
```

**MSW 구조**:
```
src/test/
├── setup.ts       # server.listen() / server.close()
├── server.ts      # setupServer(...handlers)
└── handlers/      # 도메인별 핸들러 파일
```

### P0 완료 기준
- `./gradlew test` — 컨텍스트 로드 스모크 테스트 1건 통과
- `npm run test` — 빈 스토어 테스트 1건 통과
- MySQL Testcontainers가 `schema.sql` DDL 실행 성공
- Swagger UI (`/swagger-ui.html`) 접근 가능

---

## D1 — FR-AUTH 문서화 (1일)

### 목표
기존 요구사항을 보완하고 API 명세를 작성한다. P1 구현의 계약을 확정한다.

### 산출물 1: 요구사항 보완 (`docs/requirements/03_기능_요구사항.md`)

현재 NFR-AUTH-XXX 항목들에 아래를 추가한다:

- **입력값 / 전제조건** — 각 요구사항이 받아야 할 입력과 성립 조건
- **정상 시나리오** — 성공 케이스 흐름
- **예외 시나리오** — 실패 케이스 목록 (비활성 계정, 비밀번호 불일치 등)
- **비즈니스 규칙** — 예: "비밀번호는 8자 이상, 영문+숫자+특수문자 포함"

예시 (NFR-AUTH-LOGIN-001 보완):
```markdown
### NFR-AUTH-LOGIN-001. 로그인
- 입력: email(string), password(string)
- 정상: 이메일+비밀번호 일치 + ACTIVE 상태 → Access Token, Refresh Token 반환
- 예외:
  - 이메일 없음 → ERR-AUTH-001
  - 비밀번호 불일치 → ERR-AUTH-001 (보안상 이메일/비밀번호 오류를 구분하지 않음)
  - INACTIVE 상태 → ERR-AUTH-002
  - WITHDRAWN 상태 → ERR-AUTH-002
- 비즈니스 규칙: 로그인 성공 시 Refresh Token은 DB에 저장하고 기존 토큰을 무효화한다
```

### 산출물 2: API 명세 (`docs/api/auth.md`)

각 엔드포인트에 대해 다음을 명세한다:

```markdown
## POST /api/v1/auth/login

### 요청
| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| email | string | Y | 사용자 이메일 |
| password | string | Y | 비밀번호 |

### 응답 (200 OK)
| 필드 | 타입 | 설명 |
|------|------|------|
| data.accessToken | string | JWT Access Token (15분) |
| data.refreshToken | string | JWT Refresh Token (7일) |
| data.user.id | long | 사용자 ID |
| data.user.name | string | 이름 |
| data.user.role | string | STUDENT / ADMIN / OPERATOR / MENTOR |

### 오류 응답
| 상태코드 | code | 조건 |
|----------|------|------|
| 400 | ERR-CMN-003 | 이메일/비밀번호 필드 누락 |
| 401 | ERR-AUTH-001 | 이메일 또는 비밀번호 불일치 |
| 403 | ERR-AUTH-002 | 비활성/탈퇴 계정 |
```

### 산출물 3: 요구사항 추적표 업데이트 (`docs/requirements/05_요구사항_추적표.md`)

NFR-AUTH-XXX 항목들의 상태를 "문서화 완료"로 업데이트.

### D1 완료 기준
- 모든 NFR-AUTH-XXX 항목에 정상/예외 시나리오와 비즈니스 규칙이 기술됨
- `docs/api/auth.md` 파일에 8개 엔드포인트 전체 명세 완료
- 팀 내 리뷰(또는 자가 검토) 완료

---

## P1 — FR-AUTH 인증/계정 구현 (5일)

**참조 문서**: `docs/requirements/03_기능_요구사항.md`, `docs/api/auth.md`
**관련 테이블**: `users`, `password_change_histories`, `user_agreements`, `agreements`
**관련 스크린샷**: `37_profile_click_no_dropdown_notification_page.png`

### API 엔드포인트 (D1에서 확정)

| 요구사항 | 메서드 | 경로 |
|----------|--------|------|
| NFR-AUTH-LOGIN-001 | POST | `/api/v1/auth/login` |
| NFR-AUTH-LOGOUT-001 | POST | `/api/v1/auth/logout` |
| NFR-AUTH-SESSION-001 | POST | `/api/v1/auth/refresh` |
| NFR-AUTH-PROFILE-001 | GET | `/api/v1/users/me` |
| NFR-AUTH-PROFILE-002 | PATCH | `/api/v1/users/me` |
| NFR-AUTH-CREDENTIAL-001 | PUT | `/api/v1/users/me/password` |
| NFR-AUTH-STATUS-001 | (Security Filter 내부) | - |
| NFR-AUTH-WITHDRAW-001 | DELETE | `/api/v1/users/me` |

### 백엔드 TDD 사이클

#### Repository 테스트 (`@DataJpaTest` + Testcontainers)
```java
// UserRepositoryTest
// — 이메일로_활성_사용자_조회_성공
// — 탈퇴_계정_이메일_조회_빈결과
// — 중복_이메일_저장_예외발생
```

#### Service 단위 테스트 (`@ExtendWith(MockitoExtension.class)`)
```java
// AuthServiceTest — D1 요구사항의 정상/예외 시나리오를 1:1로 매핑
// — NFR-AUTH-LOGIN-001: 올바른_자격증명_로그인_토큰반환
// — NFR-AUTH-LOGIN-001: 비활성_계정_로그인_ERR_AUTH_002
// — NFR-AUTH-LOGIN-001: 잘못된_비밀번호_로그인_ERR_AUTH_001
// — NFR-AUTH-CREDENTIAL-001: 비밀번호_변경_성공_이력저장
// — NFR-AUTH-CREDENTIAL-001: 현재_비밀번호_불일치_변경실패
// — NFR-AUTH-WITHDRAW-001: 회원탈퇴_상태_WITHDRAWN_변경
```

설계 결정:
- `user.deactivate()`, `user.changePassword(encodedPw)` — 상태 변경은 엔티티 메서드에 위임
- Refresh Token을 인터페이스로 추상화해 Redis 전환 대비

#### Controller 테스트 (`@WebMvcTest`) — D1 API 명세 기준으로 작성
```java
// AuthControllerTest
// — POST /api/v1/auth/login: 유효_자격증명_200OK_토큰반환
// — POST /api/v1/auth/login: 이메일_누락_400_ERR_CMN_003
// — POST /api/v1/auth/login: 비활성_계정_403_ERR_AUTH_002
// — GET /api/v1/users/me: 비인증_401
```

#### Spring Security 통합 테스트 (`@SpringBootTest`)
```java
// SecurityIntegrationTest
// — 보호된_엔드포인트_토큰없음_401
// — 만료된_토큰_401_ERR_AUTH_003
// — 유효한_토큰_200
```

Security 구성:
- `JwtAuthFilter`: `OncePerRequestFilter`, `Authorization: Bearer` 파싱
- 공개 경로: `POST /api/v1/auth/login`, `POST /api/v1/auth/refresh`
- 역할별 접근: `@PreAuthorize("hasRole('ADMIN')")`

### 프론트엔드 TDD 사이클
```ts
// stores/__tests__/auth.store.test.ts — D1 API 명세의 응답 구조 기준
// — 로그인_성공_isAuthenticated_true_user_채워짐
// — 로그인_실패_ERR_AUTH_001_error_상태_설정
// — 로그아웃_user_token_초기화
// — 토큰_갱신_성공_accessToken_갱신

// components/__tests__/LoginForm.test.ts
// — 로그인_버튼_클릭_store.login_호출
// — 이메일_빈값_버튼_비활성화
// — ERR_AUTH_001_오류_메시지_표시
```

### P1 완료 기준
- AuthService 라인 커버리지 80% 이상
- 모든 Auth 엔드포인트 MockMvc 테스트 존재 (D1 API 명세 전체 커버)
- JWT 발급/검증/갱신 통합 테스트 통과
- AuthStore 상태 변이 100% 커버
- Swagger UI에서 Auth API 전체 확인 가능

---

## D2 — FR-DASHBOARD 문서화 (1일)

### 목표
대시보드 화면에서 필요한 데이터와 API를 도출한다.

### 참조 자료
- 스크린샷: `01_home_dashboard.png`, `25_mycampus_level_points_dashboard.png`, `26_mycampus_attendance_status.png`, `40_attendance_detail_from_home_more.png`
- DB 테이블: `user_stats`, `point_transactions`, `attendance_records`, `education_calendar_days`

### 산출물 1: 요구사항 도출 (`docs/requirements/03_기능_요구사항.md`에 추가)

스크린샷을 보며 다음 요구사항을 작성:
- NFR-DASHBOARD-001: 홈 대시보드 조회 (레벨, 포인트, 출석률, 미완료 Quest 수)
- NFR-DASHBOARD-002: 이번 달 출결 현황 조회 (달력 형태)
- NFR-DASHBOARD-003: 포인트 적립/차감 이력 조회 (페이징)
- NFR-DASHBOARD-004: 레벨 및 포인트 상세 통계 조회

각 항목에 정상/예외 시나리오, 비즈니스 규칙 포함.

### 산출물 2: API 명세 (`docs/api/dashboard.md`)

| 메서드 | 경로 | 요구사항 |
|--------|------|----------|
| GET | `/api/v1/dashboard` | NFR-DASHBOARD-001 |
| GET | `/api/v1/users/me/stats` | NFR-DASHBOARD-004 |
| GET | `/api/v1/users/me/attendance?year=&month=` | NFR-DASHBOARD-002 |
| GET | `/api/v1/users/me/points?page=&size=` | NFR-DASHBOARD-003 |

각 엔드포인트의 요청 파라미터, 응답 필드, 오류 응답 전체 명세.

---

## P2 — FR-DASHBOARD 대시보드 구현 (4일)

**참조 문서**: `docs/requirements/03_기능_요구사항.md` (NFR-DASHBOARD-XXX), `docs/api/dashboard.md`

### 백엔드 TDD 사이클
```java
// AttendanceRecordRepositoryTest
// — 사용자ID_연월_출결목록_조회
// — 날짜범위_결석일_카운트

// DashboardServiceTest — D2 요구사항의 비즈니스 규칙 기준
// — NFR-DASHBOARD-001: 대시보드_조회_stats_출결요약_미완료Quest수_합산반환
// — NFR-DASHBOARD-002: 출석률_교육일_대비_정상출석일_비율_계산
// — NFR-DASHBOARD-003: 신규사용자_포인트이력없음_빈목록_반환
```

### 프론트엔드 TDD 사이클
```ts
// DashboardStore — D2 API 명세의 응답 구조 기준
// — fetchDashboard_완료_stats_attendance_points_저장
// — 출석률_80미만_isAttendanceWarning_true

// useAttendanceCalendar
// — NORMAL_파란색_LATE_노란색_ABSENT_빨간색_클래스_반환
// — 이전달_버튼_클릭_선택월_1감소
```

---

## D3 — FR-LECTURE 문서화 (1일)

### 참조 자료
- 스크린샷: `02`, `04`, `12`, `13`, `14`, `15`, `27` 번
- DB 테이블: `courses`, `course_weeks`, `course_sessions`, `learning_categories`, `learning_contents`, `user_learning_progresses`, `user_content_interactions`

### 산출물 1: 요구사항 도출

- NFR-LECTURE-001: 주차별 커리큘럼 조회 (세션 목록 + 학습 진행률)
- NFR-LECTURE-002: 다시보기 목록 조회 (REPLAY 타입 세션)
- NFR-LECTURE-003: 필수학습 목록 조회 (is_required=true)
- NFR-LECTURE-004: 학습 진행률 업데이트
- NFR-LECTURE-005: 이러닝 카테고리 조회
- NFR-LECTURE-006: 이러닝 콘텐츠 목록 조회 (카테고리 필터 + 페이징)

비즈니스 규칙 예시:
- 진행률 95% 이상 → 자동으로 COMPLETED 전환
- COMPLETED 콘텐츠는 진행률 업데이트 무시
- 진행률 업데이트 시 user_content_interactions에 PLAY 이벤트 기록

### 산출물 2: API 명세 (`docs/api/lecture.md`)

| 메서드 | 경로 | 요구사항 |
|--------|------|----------|
| GET | `/api/v1/courses/{courseId}/weeks` | NFR-LECTURE-001 |
| GET | `/api/v1/courses/{courseId}/weeks/{weekId}/sessions` | NFR-LECTURE-001 |
| GET | `/api/v1/courses/{courseId}/replay` | NFR-LECTURE-002 |
| GET | `/api/v1/courses/{courseId}/required-contents` | NFR-LECTURE-003 |
| PUT | `/api/v1/contents/{contentId}/progress` | NFR-LECTURE-004 |
| GET | `/api/v1/elearning/categories` | NFR-LECTURE-005 |
| GET | `/api/v1/elearning/contents?categoryId=&page=` | NFR-LECTURE-006 |

---

## P3 — FR-LECTURE 강의실 & 이러닝 구현 (6일)

**참조 문서**: `docs/requirements/03_기능_요구사항.md` (NFR-LECTURE-XXX), `docs/api/lecture.md`
**관련 테이블**: `courses`, `course_weeks`, `course_sessions`, `learning_categories`, `learning_contents`, `user_learning_progresses`, `user_content_interactions`

### 백엔드 TDD 사이클
```java
// LectureServiceTest — D3 비즈니스 규칙 기준
// — NFR-LECTURE-001: 주차별_커리큘럼_진행률_포함_조회
// — NFR-LECTURE-002: 다시보기_REPLAY_타입만_반환
// — NFR-LECTURE-003: 필수학습_is_required_true_필터

// LearningProgressServiceTest
// — NFR-LECTURE-004: 첫학습_NOT_STARTED→IN_PROGRESS
// — NFR-LECTURE-004: 진행률_95퍼_이상_COMPLETED_자동전환
// — NFR-LECTURE-004: COMPLETED_콘텐츠_진행률_업데이트_무시
// — NFR-LECTURE-004: 진행률_업데이트_PLAY_이벤트_기록
```

**JSON 컬럼 처리**: `@Convert`로 `AttributeConverter<List<String>, String>` 구현

### 프론트엔드 TDD 사이클
```ts
// LectureStore — D3 API 명세 기준
// — fetchWeeklyCurriculum_주차_세션_진행률_저장
// — updateProgress_해당세션_progressRate_갱신

// useVideoPlayer
// — 30초마다_진행률_업데이트_API_호출
// — 영상_종료_진행률_100_업데이트
```

---

## D4 — FR-QUEST 문서화 (1일)

### 참조 자료
- 스크린샷: `03_quest_evaluation_list.png`, `38_classroom_quest_detail_completed.png`
- DB 테이블: `course_tasks`, `user_task_results`, `surveys`, `survey_questions`, `survey_participants`

### 산출물 1: 요구사항 도출

- NFR-QUEST-001: Quest 목록 조회 (진행중/마감/예정 상태 포함)
- NFR-QUEST-002: Quest 상세 조회 (사용자 제출 결과 포함)
- NFR-QUEST-003: Quest 제출
- NFR-QUEST-004: 설문/간담회 신청 조회
- NFR-QUEST-005: 설문/간담회 신청 제출

비즈니스 규칙 예시:
- 마감된 Quest 제출 → ERR-QUEST-001
- 이미 제출한 Quest 재제출 → ERR-QUEST-002
- Quest 완료 시 포인트 적립 이벤트 발행 (AFTER_COMMIT)
- 설문 정원 초과 시 → ERR-SURVEY-002

### 산출물 2: API 명세 (`docs/api/quest.md`)

| 메서드 | 경로 | 요구사항 |
|--------|------|----------|
| GET | `/api/v1/courses/{courseId}/tasks?type=QUEST` | NFR-QUEST-001 |
| GET | `/api/v1/courses/{courseId}/tasks/{taskId}` | NFR-QUEST-002 |
| POST | `/api/v1/tasks/{taskId}/submit` | NFR-QUEST-003 |
| GET | `/api/v1/surveys/{surveyId}` | NFR-QUEST-004 |
| POST | `/api/v1/surveys/{surveyId}/submit` | NFR-QUEST-005 |

---

## P4 — FR-QUEST Quest/평가 구현 (4일)

**참조 문서**: `docs/requirements/03_기능_요구사항.md` (NFR-QUEST-XXX), `docs/api/quest.md`

### 백엔드 TDD 사이클
```java
// QuestServiceTest — D4 비즈니스 규칙 기준
// — NFR-QUEST-003: Quest_제출_SUBMITTED_상태_변경_submitted_at_설정
// — NFR-QUEST-003: 마감_Quest_제출_ERR_QUEST_001
// — NFR-QUEST-003: 이미_제출된_Quest_재제출_ERR_QUEST_002
// — NFR-QUEST-003: Quest_완료_포인트_적립_이벤트_발행

// SurveyServiceTest
// — NFR-QUEST-005: 설문_제출_answers_JSON_저장
// — NFR-QUEST-005: 정원초과_간담회신청_ERR_SURVEY_002
// — NFR-QUEST-005: 마감후_설문제출_ERR_SURVEY_001
```

**이벤트 기반 포인트 적립**:
- `QuestCompletedEvent` → `ApplicationEventPublisher`
- `PointService`가 `@TransactionalEventListener(AFTER_COMMIT)` 처리

---

## D5 — FR-COMMUNITY 문서화 (1일)

### 참조 자료
- 스크린샷: `05`, `06`, `11`, `16`, `17`, `19`, `20`, `21`, `22`, `23`, `24`, `35` 번
- DB 테이블: `boards`, `board_categories`, `board_posts`, `board_comments`, `user_bookmarks`, `agreements`, `user_agreements`

### 산출물 1: 요구사항 도출

- NFR-COMMUNITY-001: 게시글 목록 조회 (페이징, 키워드 검색)
- NFR-COMMUNITY-002: 게시글 작성
- NFR-COMMUNITY-003: 게시글 상세 조회 (조회수 증가)
- NFR-COMMUNITY-004: 게시글 수정 (본인만 가능)
- NFR-COMMUNITY-005: 게시글 삭제 (소프트 삭제)
- NFR-COMMUNITY-006: 댓글 작성 (대댓글 포함)
- NFR-COMMUNITY-007: 게시글 찜/북마크 (토글)
- NFR-COMMUNITY-008: 익명 게시판 운영원칙 동의 확인/처리
- NFR-COMMUNITY-009: 멘토링 게시판 (board_type=MENTORING)
- NFR-COMMUNITY-010: 간담회 신청/후기 (survey_categories=MEETUP_APPLICATION)

비즈니스 규칙 예시:
- 익명 게시판 게시글의 authorName은 "익명"으로 반환
- 타인 게시글 수정/삭제 → ERR-BOARD-002
- 삭제는 is_deleted=true (물리 삭제 아님)
- 공지글(is_notice=true)은 목록 최상단 고정

### 산출물 2: API 명세 (`docs/api/community.md`)

| 메서드 | 경로 | 요구사항 |
|--------|------|----------|
| GET | `/api/v1/boards/{boardCode}/posts?page=&size=&keyword=` | NFR-COMMUNITY-001 |
| POST | `/api/v1/boards/{boardCode}/posts` | NFR-COMMUNITY-002 |
| GET | `/api/v1/posts/{postId}` | NFR-COMMUNITY-003 |
| PATCH | `/api/v1/posts/{postId}` | NFR-COMMUNITY-004 |
| DELETE | `/api/v1/posts/{postId}` | NFR-COMMUNITY-005 |
| POST | `/api/v1/posts/{postId}/comments` | NFR-COMMUNITY-006 |
| POST | `/api/v1/posts/{postId}/bookmark` | NFR-COMMUNITY-007 |
| GET | `/api/v1/agreements/{type}/consent` | NFR-COMMUNITY-008 |
| POST | `/api/v1/agreements/{type}/consent` | NFR-COMMUNITY-008 |

---

## P5 — FR-COMMUNITY 커뮤니티 구현 (5일)

**참조 문서**: `docs/requirements/03_기능_요구사항.md` (NFR-COMMUNITY-XXX), `docs/api/community.md`
(멘토링 게시판·Q&A·간담회는 board_type=MENTORING 및 survey_categories=MEETUP_APPLICATION으로 처리)

### 백엔드 TDD 사이클
```java
// BoardPostRepositoryTest
// — NFR-COMMUNITY-001: 공지글_상단고정_최신순_조회
// — NFR-COMMUNITY-001: 삭제된_게시글_목록_제외
// — NFR-COMMUNITY-001: FULLTEXT_키워드_게시글_조회
// — NFR-COMMUNITY-008: 익명게시판_authorName_마스킹

// BoardPostServiceTest
// — NFR-COMMUNITY-002: 게시글_작성_view_count_like_count_0초기화
// — NFR-COMMUNITY-003: 게시글_조회_view_count_1증가
// — NFR-COMMUNITY-004: 타인_게시글_수정_ERR_BOARD_002
// — NFR-COMMUNITY-005: 게시글_삭제_is_deleted_true_소프트삭제
// — NFR-COMMUNITY-008: 익명게시판_응답_authorName_익명

// BookmarkServiceTest
// — NFR-COMMUNITY-007: 찜_토글_이미찜한경우_취소
// — NFR-COMMUNITY-007: 찜_생성_scrap_count_증가
```

**FULLTEXT 검색**: `@Query` native query (MySQL 8 전용)

### 프론트엔드 TDD 사이클
```ts
// BoardStore — D5 API 명세 기준
// — fetchPosts_페이지네이션_메타데이터_포함_저장
// — createPost_성공_목록_앞에_추가
// — toggleBookmark_해당게시글_isBookmarked_반전

// AnonymousBoard 컴포넌트
// — NFR-COMMUNITY-008: 미동의_사용자_운영원칙_모달_표시
// — NFR-COMMUNITY-008: 동의_완료_게시글_목록_표시
```

---

## D6 — FR-NOTICE 문서화 (1일)

### 참조 자료
- 스크린샷: `07`, `09`, `10`, `33`, `36` 번
- DB 테이블: `notifications`, `inquiries`

### 산출물 1: 요구사항 도출

- NFR-NOTICE-001: 알림 목록 조회
- NFR-NOTICE-002: 미읽음 알림 수 조회 (GNB 뱃지)
- NFR-NOTICE-003: 알림 읽음 처리 (단건)
- NFR-NOTICE-004: 알림 전체 읽음 처리
- NFR-NOTICE-005: 1:1 문의 목록 조회 (본인 / 관리자 전체)
- NFR-NOTICE-006: 1:1 문의 등록
- NFR-NOTICE-007: 1:1 문의 답변 (ADMIN/OPERATOR만 가능)

비즈니스 규칙 예시:
- 타인 알림 읽음 처리 → ERR-CMN-002
- 문의 등록 초기 상태 → WAITING
- 관리자 답변 시 상태 → ANSWERED, answered_at 설정

### 산출물 2: API 명세 (`docs/api/notice.md`)

| 메서드 | 경로 | 요구사항 |
|--------|------|----------|
| GET | `/api/v1/notifications` | NFR-NOTICE-001 |
| GET | `/api/v1/notifications/unread-count` | NFR-NOTICE-002 |
| PATCH | `/api/v1/notifications/{id}/read` | NFR-NOTICE-003 |
| POST | `/api/v1/notifications/read-all` | NFR-NOTICE-004 |
| GET | `/api/v1/inquiries` | NFR-NOTICE-005 |
| POST | `/api/v1/inquiries` | NFR-NOTICE-006 |
| GET | `/api/v1/inquiries/{id}` | NFR-NOTICE-005 |
| PATCH | `/api/v1/inquiries/{id}/answer` | NFR-NOTICE-007 |

---

## P6 — FR-NOTICE 공지/알림 구현 (3일)

**참조 문서**: `docs/requirements/03_기능_요구사항.md` (NFR-NOTICE-XXX), `docs/api/notice.md`

### 백엔드 TDD 사이클
```java
// NotificationServiceTest — D6 비즈니스 규칙 기준
// — NFR-NOTICE-002: 미읽음_알림_수_조회
// — NFR-NOTICE-003: 알림_읽음처리_is_read_read_at_설정
// — NFR-NOTICE-003: 타인_알림_읽음처리_ERR_CMN_002
// — NFR-NOTICE-004: 전체_알림_읽음처리_unreadCount_0

// InquiryServiceTest
// — NFR-NOTICE-006: 문의_등록_WAITING_상태_초기화
// — NFR-NOTICE-007: 관리자_답변_ANSWERED_상태_answered_at_설정
// — NFR-NOTICE-005: 일반사용자_본인_문의만_조회
// — NFR-NOTICE-005: ADMIN_전체_문의_조회
```

---

## P7 — 횡단 관심사 & 통합 시나리오 (3일)

### 횡단 관심사 테스트
```java
// GlobalExceptionHandlerTest
// — ApiException_정의된_에러코드_HTTP상태_반환
// — @Valid_검증실패_400_필드별_오류목록_반환
// — 비인증_접근_401_ERR_CMN_002
// — 존재하지않는_엔드포인트_404_ERR_CMN_001

// FileServiceTest
// — 프로필이미지_업로드_files_테이블_저장
// — 허용되지않는_파일타입_예외발생

// AuditLogInterceptorTest
// — ADMIN_POST_요청_CREATE_audit_log_기록

// user_stats 동시성: @Version 낙관적 락 OR 원자적 UPDATE 쿼리
```

### 통합 시나리오 테스트 (`@SpringBootTest` + Testcontainers)
```java
// AuthFlowIntegrationTest
// — 로그인→프로필조회→비밀번호변경→로그아웃→토큰무효화_전체흐름

// QuestFlowIntegrationTest
// — Quest목록조회→상세조회→제출→결과확인_전체흐름
```

```ts
// tests/integration/auth.flow.test.ts
// — 로그인_성공_대시보드_라우팅
// — 비인증_보호경로_로그인_라우팅
```

---

## 표준 규격

### API 응답 구조
```json
// 성공
{ "success": true, "data": { ... } }

// 페이징
{ "success": true, "data": { "content": [...], "page": 0, "size": 20, "totalElements": 150 } }

// 오류
{ "success": false, "code": "ERR-AUTH-001", "message": "...", "timestamp": "..." }
```

### 에러 코드
```
ERR-AUTH-001: 이메일 또는 비밀번호 불일치
ERR-AUTH-002: 비활성/탈퇴 계정
ERR-AUTH-003: 토큰 만료
ERR-AUTH-004: 유효하지 않은 토큰
ERR-AUTH-005: 현재 비밀번호 불일치
ERR-QUEST-001: Quest 제출 기간 종료
ERR-QUEST-002: 이미 제출된 Quest
ERR-BOARD-001: 게시글 없음
ERR-BOARD-002: 게시글 수정/삭제 권한 없음
ERR-SURVEY-001: 설문 마감
ERR-SURVEY-002: 설문 정원 초과
ERR-CMN-001: 리소스 없음 (404)
ERR-CMN-002: 접근 권한 없음 (403)
ERR-CMN-003: 잘못된 요청 (400)
```

### 요구사항 식별자 체계
```
NFR-{도메인}-{기능}-{번호}
예: NFR-AUTH-LOGIN-001, NFR-LECTURE-004, NFR-COMMUNITY-008
```

### 테스트 네이밍 컨벤션
- **백엔드** `@DisplayName`: `NFR-XXX: {주어}_{조건}_{기대결과}` (한국어)
- **프론트엔드** `it()`: BDD 스타일 한국어

### 테스트 커버리지 목표
- 백엔드 Service 레이어: 라인 커버리지 80% 이상
- 백엔드 Controller: 모든 엔드포인트에 MockMvc 테스트 (API 명세 전체 커버)
- 프론트엔드 Pinia 스토어: 상태 변이 함수 100%

---

## 산출물 디렉터리 구조

```
docs/
├── requirements/
│   ├── 02_상위_요구사항.md
│   ├── 03_기능_요구사항.md     ← D1~D6에서 도메인별로 추가
│   ├── 04_비기능_요구사항.md
│   └── 05_요구사항_추적표.md   ← 각 D 페이즈 완료 후 업데이트
├── api/
│   ├── auth.md                 ← D1 산출물
│   ├── dashboard.md            ← D2 산출물
│   ├── lecture.md              ← D3 산출물
│   ├── quest.md                ← D4 산출물
│   ├── community.md            ← D5 산출물
│   └── notice.md               ← D6 산출물
├── database/
│   ├── schema.sql
│   └── table.md
├── design/
│   ├── DESIGN.md
│   └── edu_screnshot/
└── plan/
    └── edu-ssafy-com-wise-goose.md   ← 이 문서
```

---

## 잠재적 도전 과제

| 과제 | 대응 |
|------|------|
| Testcontainers 속도 | `withReuse(true)` + `@Rollback`, `@DirtiesContext` 최소화 |
| JSON 컬럼 | `AttributeConverter<List<String>, String>` + Testcontainers 필수 |
| FULLTEXT 인덱스 | `@Query` native query, Testcontainers에서만 테스트 |
| user_stats 동시성 | `@Version` 낙관적 락 또는 원자적 UPDATE 쿼리 |
| 익명 게시판 마스킹 | Service에서 authorName 덮어쓰기, 단위 테스트 명시 |
| Vue Router + Pinia 통합 | `createTestingPinia` + `createMemoryHistory()` |

---

## 검증 방법 (페이즈별)

| 페이즈 | 검증 방법 |
|--------|----------|
| D1~D6 | 요구사항 정상/예외 시나리오 누락 없음 확인, API 명세 리뷰 |
| P0 | `./gradlew test` 그린, `npm run test` 그린, Swagger UI 접근 |
| P1~P6 | `./gradlew test --tests "*.{domain}.*"` 그린, Swagger UI 해당 도메인 확인, 스크린샷과 UI 비교 |
| P7 | `./gradlew test` 전체 그린, Jacoco 커버리지 임계값 통과 |
