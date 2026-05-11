# edu_ssafy_clone 소프트웨어 설계 계획서

최종 확인일: 2026-05-11


> 본 문서는 `edu.ssafy.com` 교육 포털의 메인 대시보드를 시작점으로, Spring Boot 백엔드와 Vue 프론트엔드를 사용해 풀스택 클론 프로젝트를 구현하기 위한 설계 계획서다.
>
> 디자인 기준: `DESIGN.md`
> 구현 목표: 실제 서비스와 거의 100%에 가까운 화면 구조, 정보 배치, 색상, 인터랙션 재현
> 1차 구현 범위: 메인 대시보드

## 0. 현재 저장소 상태

- 현재 저장소는 문서/설계 산출물 중심이며, 실제 `frontend/`, `backend/`, `package.json`, `build.gradle` 스캐폴딩은 아직 없다.
- 일반 문서 인덱스는 `docs/README.md`를 기준으로 한다.
- 시각 참조는 `docs/design/screenshots/`의 40개 PNG와 `docs/design/reference-inventory.md`를 기준으로 한다.
- DB 기준은 `docs/database/schema.sql` 및 `docs/database/tables.md`이다.
- OMX 실행 계획과 검증 지도는 `.omx/plans/first-deployment.md`, `.omx/plans/first-deployment-verification.md`에 있다.

---

## 1. 문서 개요

### 1.1 목적

본 계획서는 `edu_ssafy_clone` 프로젝트의 요구사항, 화면 구조, 데이터 모델, API, 프론트엔드/백엔드 아키텍처, 구현 순서, 검증 기준을 정의한다.

### 1.2 대상 독자

- 프론트엔드 개발자
- 백엔드 개발자
- DB 설계자
- QA 담당자
- 프로젝트 리뷰어

### 1.3 기술 스택

| 영역 | 기술 |
|---|---|
| Frontend | Vue 3, Vite, Vue Router, Pinia, Axios, CSS Modules 또는 SCSS |
| Backend | Java 17+, Spring Boot 3.x, Spring Web, Spring Data JPA, Spring Security |
| Database | MySQL 또는 MariaDB |
| ORM | JPA/Hibernate |
| API Style | REST API, JSON |
| Auth | JWT 기반 인증, 추후 OAuth 확장 가능 |
| Build | Gradle, npm |
| Test | JUnit 5, Spring Boot Test, Vitest, Vue Test Utils |

---

## 2. 프로젝트 목표 및 범위

### 2.1 최종 목표

SSAFY 교육 포털의 주요 사용자 경험을 풀스택 구조로 재현한다. 단순 정적 클론이 아니라, 백엔드 API와 DB를 통해 사용자 정보, 출석, 장학포인트, 알림, 커리큘럼, Quest/평가, 학습자료를 동적으로 조회할 수 있도록 구현한다.

### 2.2 1차 구현 범위: 메인 대시보드

메인 대시보드는 다음 영역을 포함한다.

1. 공통 헤더/GNB
2. 사용자 요약 정보
3. 출석 카드
4. 장학포인트/EXP/레벨 카드
5. 공지/알림 목록
6. 주차별 커리큘럼 요약
7. Quest/평가 요약
8. 학습자료 요약
9. 학습중 이러닝 빈 상태 또는 목록
10. 커뮤니티 요약
11. 푸터
12. e-book 플로팅 버튼

### 2.3 제외 범위

1차 구현에서는 다음 항목을 제외한다.

- 실제 SSAFY 로그인 연동
- 실제 교육생 데이터 연동
- 실시간 알림 WebSocket
- 관리자 페이지
- 파일 업로드/다운로드 상세 구현
- 결제, 외부 시스템 연동

단, 추후 확장을 고려해 DB와 API 구조는 분리해 설계한다.

---

## 3. 요구사항 정의

## 3.1 기능 요구사항

### FR-001. 사용자 로그인

- 사용자는 이메일/비밀번호로 로그인할 수 있다.
- 로그인 성공 시 JWT access token을 발급한다.
- 프론트엔드는 토큰을 저장하고 이후 API 요청에 포함한다.

### FR-002. 메인 대시보드 조회

- 로그인한 사용자는 메인 대시보드 데이터를 조회할 수 있다.
- 대시보드 API는 화면 초기 렌더링에 필요한 핵심 데이터를 한 번에 제공한다.
- 포함 데이터:
  - 사용자 기본 정보
  - 출석 상태
  - 장학포인트
  - EXP/레벨
  - 알림 목록
  - 주차별 커리큘럼
  - Quest/평가
  - 학습자료
  - 학습중 이러닝
  - 커뮤니티 게시글 요약

### FR-003. 출석 정보 표시

- 오늘 날짜, 요일, 출석 상태를 표시한다.
- 출석 상태는 `미출석`, `출석완료`, `지각`, `결석`으로 구분한다.
- 1차 구현에서는 조회만 제공한다.

### FR-004. 장학포인트/EXP/레벨 표시

- 사용자의 누적 장학포인트를 표시한다.
- 사용자의 EXP와 현재 레벨을 표시한다.
- 포인트/EXP는 숫자 강조 스타일로 표시한다.

### FR-005. 알림/공지 표시

- 대시보드 상단 카드에 최근 알림을 표시한다.
- 필독 알림은 별도 라벨로 강조한다.
- 알림 클릭 시 상세 페이지로 이동할 수 있도록 라우팅 구조를 준비한다.

### FR-006. 주차별 커리큘럼 표시

- 현재 주차 또는 선택된 주차의 학습 일정을 표시한다.
- 일정은 날짜, 시간, 카테고리, 제목, 강사/강의실 정보를 포함한다.

### FR-007. Quest/평가 표시

- 진행 예정/진행 중/완료된 평가 목록을 표시한다.
- 평가 상태와 마감일을 표시한다.

### FR-008. 학습자료 표시

- 최근 등록된 학습자료 목록을 표시한다.
- 자료명, 카테고리, 등록일을 표시한다.

### FR-009. 커뮤니티 요약 표시

- SSAFYcial, 자유게시판 등 주요 게시판의 최신 글을 표시한다.
- 제목, 작성자, 작성일, 조회수를 표시한다.

### FR-010. 공통 레이아웃

- 모든 페이지는 Header, Main Container, Footer 구조를 따른다.
- 메인 대시보드는 `DESIGN.md`의 레이아웃과 색상 토큰을 우선 적용한다.

## 3.2 비기능 요구사항

### NFR-001. UI 유사도

- 디자인 토큰, 색상, 간격, 카드 구조는 `DESIGN.md`를 기준으로 한다.
- 메인 대시보드의 데스크톱 화면은 원본과 거의 동일한 배치를 목표로 한다.

### NFR-002. 응답 성능

- 메인 대시보드 API 응답 시간은 로컬 기준 300ms 이내를 목표로 한다.
- 대시보드 첫 렌더링에 필요한 API 호출 수는 최소화한다.

### NFR-003. 유지보수성

- 프론트엔드는 페이지, 컴포넌트, API 모듈, 스토어를 분리한다.
- 백엔드는 Controller, Service, Repository, Entity, DTO를 분리한다.

### NFR-004. 확장성

- 메인 대시보드 이후 마이캠퍼스, 강의실, 커뮤니티 페이지를 추가할 수 있도록 도메인을 분리한다.

### NFR-005. 보안

- 비밀번호는 BCrypt로 해싱한다.
- 인증이 필요한 API는 JWT 검증을 거친다.
- 민감 데이터는 응답 DTO에 포함하지 않는다.

---

## 4. 시스템 아키텍처

## 4.1 전체 구조

```text
[Vue Client]
    |
    | HTTPS / REST JSON
    v
[Spring Boot API Server]
    |
    | JPA
    v
[MySQL or MariaDB]
```

## 4.2 프론트엔드 구조

```text
frontend/
  src/
    app/
      router/
      stores/
    assets/
    components/
      common/
      dashboard/
      layout/
    pages/
      DashboardPage.vue
      LoginPage.vue
    services/
      apiClient.ts
      dashboardApi.ts
      authApi.ts
    styles/
      tokens.css
      global.css
    types/
```

### 주요 원칙

- API 호출은 `services` 계층에 둔다.
- 화면 상태는 Pinia store에 둔다.
- 카드, 탭, 배지, 리스트는 재사용 컴포넌트로 분리한다.
- 디자인 토큰은 `DESIGN.md`를 CSS 변수로 변환한다.

## 4.3 백엔드 구조

```text
backend/
  src/main/java/com/example/edussafy/
    auth/
    user/
    dashboard/
    attendance/
    point/
    curriculum/
    quest/
    material/
    community/
    notification/
    global/
      config/
      error/
      security/
      response/
```

### 주요 원칙

- 도메인 단위 패키지 구조를 사용한다.
- Entity와 응답 DTO를 분리한다.
- 대시보드 화면 전용 응답은 `DashboardSummaryResponse`로 묶는다.
- 공통 예외 응답 형식을 정의한다.

---

## 5. ERD 정의

## 5.1 핵심 엔티티

상세 DB 기준은 `docs/database/schema.sql`과 `docs/database/tables.md`를 우선한다. 설계상 주요 도메인은 다음과 같다.

```text
users, files, courses, education_calendar_days,
attendance_records, attendance_appeals,
point_transactions, user_stats,
user_bookmarks, user_content_interactions,
boards, board_categories, board_posts, board_comments,
course_weeks, course_sessions,
learning_categories, learning_contents, user_learning_progresses,
course_tasks, user_task_results, user_activity_records,
survey_categories, surveys, survey_questions, survey_participants,
inquiries, notifications, agreements, user_agreements,
password_change_histories, audit_logs
```

대시보드 1차 구현에서는 위 전체 모델 중 사용자, 출석, 포인트/통계, 커리큘럼, 과제/평가, 학습 콘텐츠, 게시판, 알림 영역을 우선 사용한다.

## 5.2 관계 정의

관계 정의는 `docs/database/schema.sql`의 FK를 기준으로 한다. 대표 관계는 다음과 같다.

```text
users 1 : N attendance_records
users 1 : N point_transactions
users 1 : 1 user_stats
users 1 : N user_learning_progresses
users 1 : N board_posts
boards 1 : N board_posts
courses 1 : N course_weeks
course_weeks 1 : N course_sessions
learning_categories 1 : N learning_contents
course_tasks 1 : N user_task_results
```

알림, 커리큘럼, 학습자료는 1차 구현에서 더미/seed 데이터로 제공하고, 추후 교육생별 권한/반/트랙 기준 필터링이 필요하면 매핑 테이블 또는 조건 컬럼을 추가한다.

## 5.3 상태 Enum

```text
AttendanceStatus
- NOT_CHECKED
- PRESENT
- LATE
- ABSENT

PointType
- EARN
- DEDUCT

QuestStatus
- SCHEDULED
- IN_PROGRESS
- COMPLETED

ELearningStatus
- NOT_STARTED
- IN_PROGRESS
- COMPLETED

BoardType
- SSAFYCIAL
- FREE
- ANONYMOUS
- CLASS
```

---

## 6. API 명세서

## 6.1 공통 응답 형식

```json
{
  "success": true,
  "data": {},
  "error": null
}
```

오류 응답:

```json
{
  "success": false,
  "data": null,
  "error": {
    "code": "AUTH_001",
    "message": "인증이 필요합니다."
  }
}
```

## 6.2 인증 API

### POST /api/auth/login

설명: 로그인 후 JWT 토큰을 발급한다.

Request:

```json
{
  "email": "student@example.com",
  "password": "password1234"
}
```

Response:

```json
{
  "success": true,
  "data": {
    "accessToken": "jwt-token",
    "tokenType": "Bearer",
    "user": {
      "id": 1,
      "name": "김싸피",
      "campus": "서울",
      "className": "서울 1반",
      "track": "Java"
    }
  },
  "error": null
}
```

## 6.3 대시보드 API

### GET /api/dashboard/me

설명: 로그인한 사용자의 메인 대시보드 데이터를 조회한다.

Header:

```text
Authorization: Bearer {accessToken}
```

Response:

```json
{
  "success": true,
  "data": {
    "user": {
      "id": 1,
      "name": "김싸피",
      "campus": "서울",
      "className": "서울 1반",
      "track": "Java",
      "generation": 12
    },
    "attendance": {
      "date": "2026-05-10",
      "dayOfWeek": "SUN",
      "status": "NOT_CHECKED",
      "message": "아직 출석 전입니다."
    },
    "pointSummary": {
      "scholarshipPoint": 1200,
      "level": 5,
      "exp": 3400,
      "requiredExp": 5000
    },
    "notifications": [
      {
        "id": 1,
        "title": "필독 공지사항입니다.",
        "category": "NOTICE",
        "required": true,
        "publishedAt": "2026-05-10T09:00:00"
      }
    ],
    "curriculums": [
      {
        "id": 1,
        "weekNo": 1,
        "date": "2026-05-10",
        "startTime": "09:00",
        "endTime": "18:00",
        "category": "코딩과정",
        "title": "Spring Boot 기본",
        "instructor": "홍길동",
        "classroom": "서울 1반"
      }
    ],
    "quests": [
      {
        "id": 1,
        "title": "Java 월말평가",
        "questType": "TEST",
        "status": "SCHEDULED",
        "dueAt": "2026-05-20T23:59:59"
      }
    ],
    "materials": [
      {
        "id": 1,
        "title": "Spring Boot 교안",
        "category": "교재",
        "createdAt": "2026-05-10T10:00:00"
      }
    ],
    "eLearnings": [],
    "communityPosts": [
      {
        "id": 1,
        "boardType": "FREE",
        "title": "자유게시판 최신글",
        "authorName": "김싸피",
        "viewCount": 10,
        "createdAt": "2026-05-10T12:00:00"
      }
    ]
  },
  "error": null
}
```

## 6.4 세부 조회 API

| Method | Endpoint | 설명 |
|---|---|---|
| GET | /api/users/me | 내 정보 조회 |
| GET | /api/attendance/me/today | 오늘 출석 조회 |
| GET | /api/points/me | 내 장학포인트 내역 조회 |
| GET | /api/curriculums | 커리큘럼 목록 조회 |
| GET | /api/quests | Quest/평가 목록 조회 |
| GET | /api/materials | 학습자료 목록 조회 |
| GET | /api/e-learnings/me | 학습중 이러닝 목록 조회 |
| GET | /api/boards/{boardType}/posts | 게시판 글 목록 조회 |
| GET | /api/notifications | 알림 목록 조회 |

---

## 7. 화면 설계

## 7.1 메인 대시보드 레이아웃

`DESIGN.md` 기준으로 다음 구조를 따른다.

```text
Header
  - Logo
  - GNB: 마이캠퍼스 / 강의실 / 커뮤니티 / HELP DESK / 멘토링 게시판
  - 알림 / 사용자 정보 / JOB SSAFY / SSAFY GIT / Meeting! SSAFY

Main Dashboard
  Row 1
    - AttendanceCard
    - StatusSummaryCard

  Row 2
    - WeeklyCurriculumSection
    - QuestSummarySection

  Row 3
    - LearningMaterialCarousel
    - ELearningSection

  Row 4
    - SSAFYcialList
    - FreeBoardList

FloatingEBookButton
Footer
```

## 7.2 주요 컴포넌트

| 컴포넌트 | 역할 |
|---|---|
| AppHeader | 공통 상단 메뉴 |
| AppFooter | 공통 푸터 |
| DashboardPage | 메인 대시보드 페이지 |
| AttendanceCard | 오늘 출석 정보 표시 |
| StatusSummaryCard | 포인트/레벨/알림 표시 |
| CurriculumCard | 주차별 커리큘럼 표시 |
| QuestCard | 평가 목록 표시 |
| MaterialCarousel | 학습자료 표시 |
| EmptyLearningCard | 학습중 이러닝 빈 상태 표시 |
| BoardPreviewList | 게시판 요약 목록 |
| FloatingEBookButton | e-book 고정 버튼 |

## 7.3 디자인 적용 기준

- 기본 컨테이너 폭: 1200px 내외
- Header 높이: 약 102px
- 기본 배경: `#FFFFFF`
- Primary Blue: `#3396F4`, 접근성 필요 시 `#0067B8`
- Accent Yellow: `#FFE651`
- 카드 radius: 0px 중심
- 카드 구분: 1px gray border 또는 제한적 shadow
- 텍스트: Noto Sans, Roboto, Malgun Gothic 계열

---

## 8. 데이터 흐름

## 8.1 초기 렌더링 흐름

```text
1. 사용자가 로그인한다.
2. 프론트엔드는 accessToken을 저장한다.
3. DashboardPage 진입 시 GET /api/dashboard/me 호출한다.
4. 응답 데이터를 Pinia store에 저장한다.
5. 각 카드 컴포넌트는 store 또는 props로 데이터를 받아 렌더링한다.
6. API 실패 시 공통 ErrorState를 표시한다.
```

## 8.2 프론트엔드 상태 구조 예시

```ts
interface DashboardState {
  loading: boolean;
  error: string | null;
  user: UserSummary | null;
  attendance: AttendanceSummary | null;
  pointSummary: PointSummary | null;
  notifications: NotificationSummary[];
  curriculums: CurriculumSummary[];
  quests: QuestSummary[];
  materials: LearningMaterialSummary[];
  eLearnings: ELearningSummary[];
  communityPosts: CommunityPostSummary[];
}
```

---

## 9. 백엔드 설계

## 9.1 Controller 계층

```text
AuthController
DashboardController
UserController
AttendanceController
PointController
CurriculumController
QuestController
MaterialController
CommunityController
NotificationController
```

## 9.2 Service 계층

```text
DashboardService
- getMyDashboard(userId)

AuthService
- login(email, password)

AttendanceService
- getTodayAttendance(userId)

PointService
- getPointSummary(userId)

CurriculumService
- getCurrentWeekCurriculums(userId)

QuestService
- getDashboardQuests(userId)
```

## 9.3 Repository 계층

```text
UserRepository
AttendanceRecordRepository
PointTransactionRepository
UserStatRepository
NotificationRepository
CourseRepository
CourseWeekRepository
CourseSessionRepository
CourseTaskRepository
UserTaskResultRepository
LearningCategoryRepository
LearningContentRepository
UserLearningProgressRepository
BoardRepository
BoardPostRepository
BoardCommentRepository
```

## 9.4 DTO 설계 원칙

- Entity를 API 응답에 직접 노출하지 않는다.
- 대시보드 응답은 화면 기준 DTO로 구성한다.
- 날짜/시간은 ISO-8601 문자열로 반환한다.
- Enum은 영문 코드로 반환하고, 프론트엔드에서 한글 라벨로 매핑한다.

---

## 10. 프론트엔드 설계

## 10.1 라우팅

```text
/              -> DashboardPage
/login         -> LoginPage
/my-campus     -> MyCampusPage, 추후 구현
/classroom     -> ClassroomPage, 추후 구현
/community     -> CommunityPage, 추후 구현
/help-desk     -> HelpDeskPage, 추후 구현
```

## 10.2 API 모듈

```ts
// services/dashboardApi.ts
export async function getMyDashboard() {
  return apiClient.get('/api/dashboard/me');
}
```

## 10.3 컴포넌트 분리 기준

- 레이아웃 컴포넌트: 위치와 구조 담당
- 도메인 컴포넌트: 대시보드 데이터 표시 담당
- 공통 컴포넌트: 버튼, 배지, 카드, 빈 상태 담당
- 페이지 컴포넌트: API 호출과 컴포넌트 조립 담당

## 10.4 스타일 관리

```text
styles/
  tokens.css       // DESIGN.md 토큰 변환
  global.css       // reset, body, typography
  layout.css       // container, grid
  components.css   // 공통 카드/버튼/배지
```

---

## 11. 구현 순서

## Phase 0. 프로젝트 초기 세팅

1. Spring Boot 프로젝트 생성
2. Vue 3 + Vite 프로젝트 생성
3. 프론트/백엔드 디렉터리 구조 정리
4. DB 연결 설정
5. 공통 코드 스타일 설정

## Phase 1. 디자인 시스템 적용

1. `DESIGN.md` 색상 토큰을 CSS 변수로 변환
2. 공통 폰트/여백/카드/버튼 스타일 작성
3. Header/Footer 정적 구현
4. 1200px 기준 메인 컨테이너 구현

## Phase 2. 백엔드 기본 구조 구현

1. User Entity 작성
2. 인증 API 작성
3. JWT 인증 필터 작성
4. Dashboard 관련 Entity 작성
5. 더미 seed 데이터 작성
6. Dashboard 통합 조회 API 작성

## Phase 3. 메인 대시보드 프론트 구현

1. DashboardPage 생성
2. 대시보드 API 모듈 생성
3. Pinia dashboard store 생성
4. AttendanceCard 구현
5. StatusSummaryCard 구현
6. CurriculumSection 구현
7. QuestSection 구현
8. MaterialSection 구현
9. ELearningSection 구현
10. CommunityPreviewSection 구현
11. FloatingEBookButton 구현

## Phase 4. 연동 및 검증

1. 로그인 후 대시보드 API 호출 확인
2. 각 카드에 실제 API 응답 매핑
3. 로딩/에러/빈 상태 처리
4. 데스크톱 기준 화면 유사도 검증
5. 테스트 코드 작성
6. QA 체크리스트 수행

---

## 12. 테스트 계획

## 12.1 백엔드 테스트

| 테스트 | 대상 |
|---|---|
| 단위 테스트 | Service 로직 |
| Repository 테스트 | JPA 쿼리 |
| Controller 테스트 | API 요청/응답 |
| Security 테스트 | 인증/인가 |

주요 테스트 케이스:

- 로그인 성공/실패
- 인증 없이 대시보드 조회 실패
- 인증 후 대시보드 조회 성공
- 출석 데이터가 없을 때 기본 상태 반환
- 학습중 이러닝이 없을 때 빈 배열 반환

## 12.2 프론트엔드 테스트

| 테스트 | 대상 |
|---|---|
| 컴포넌트 테스트 | 카드 렌더링 |
| Store 테스트 | 대시보드 상태 변경 |
| API Mock 테스트 | 성공/실패 응답 |
| 시각 검증 | 원본 유사도 |

주요 테스트 케이스:

- 대시보드 로딩 상태 표시
- API 성공 시 카드 데이터 표시
- API 실패 시 에러 상태 표시
- 빈 이러닝 목록일 때 빈 상태 문구 표시
- 필독 알림 라벨 표시

---

## 13. QA 체크리스트

## 13.1 UI 유사도

- [ ] Header 높이와 메뉴 배치가 기준과 일치하는가
- [ ] Primary Blue, Accent Yellow 색상이 일관되게 적용되었는가
- [ ] 카드 radius가 과하게 둥글지 않은가
- [ ] 대시보드 상단 2컬럼 배치가 기준과 일치하는가
- [ ] 포인트/EXP 숫자 강조가 기준과 일치하는가
- [ ] 리스트/카드 간격이 원본과 유사한가
- [ ] 푸터가 다크 차콜 배경으로 구현되었는가

## 13.2 기능 검증

- [ ] 로그인 성공 시 토큰이 저장되는가
- [ ] 대시보드 진입 시 API가 호출되는가
- [ ] 인증 실패 시 로그인 화면으로 이동하는가
- [ ] 데이터가 없을 때 빈 상태가 표시되는가
- [ ] 게시글/공지 클릭 라우팅이 동작하는가

## 13.3 코드 품질

- [ ] Entity와 DTO가 분리되어 있는가
- [ ] API 응답 형식이 통일되어 있는가
- [ ] Vue 컴포넌트가 지나치게 커지지 않았는가
- [ ] 공통 스타일이 중복 작성되지 않았는가
- [ ] 테스트가 주요 흐름을 커버하는가

---

## 14. 리스크 및 대응 방안

| 리스크 | 설명 | 대응 |
|---|---|---|
| 원본 사이트 접근 제한 | 실제 화면 확인이 어려울 수 있음 | 확보된 캡처와 `DESIGN.md` 기준으로 구현 |
| UI 유사도 부족 | 디테일 차이가 발생할 수 있음 | 픽셀 단위 비교 체크리스트 운영 |
| API 과분리 | 초기 화면 로딩 API가 많아질 수 있음 | `/api/dashboard/me` 통합 조회 제공 |
| DB 설계 과도화 | 1차 범위보다 복잡해질 수 있음 | 메인 대시보드 필요한 테이블부터 구현 |
| 인증 구현 지연 | 화면 구현 속도가 늦어질 수 있음 | 초기에는 mock token 또는 seed user 사용 가능 |

---

## 15. 산출물

1. 요구사항 정의서
2. ERD
3. API 명세서
4. 화면 설계서
5. 프론트엔드 컴포넌트 구조
6. 백엔드 패키지 구조
7. 테스트 계획서
8. QA 체크리스트
9. 구현 계획서

---

## 16. 1차 마일스톤

## Milestone 1. 대시보드 정적 화면 완성

- Header/Footer 구현
- 대시보드 카드 레이아웃 구현
- `DESIGN.md` 기반 스타일 적용
- 더미 데이터 렌더링

## Milestone 2. 백엔드 API 완성

- DB 테이블 생성
- seed 데이터 작성
- 로그인 API 구현
- 대시보드 통합 API 구현

## Milestone 3. 프론트/백 연동

- 로그인 연동
- 대시보드 API 연동
- 로딩/에러/빈 상태 처리
- QA 체크리스트 1차 통과

## Milestone 4. 유사도 개선

- 원본 대비 간격/색상/폰트 조정
- 카드/리스트/배지 디테일 보정
- 데스크톱 기준 최종 검수

---

## 17. 다음 작업 우선순위

1. `frontend`, `backend` 프로젝트 생성
2. DB 스키마 초안 작성
3. `DESIGN.md` 토큰을 CSS 변수로 변환
4. 메인 대시보드 정적 Vue 컴포넌트 구현
5. Spring Boot 대시보드 통합 API 구현
6. 프론트와 API 연동
7. 유사도 QA 진행
