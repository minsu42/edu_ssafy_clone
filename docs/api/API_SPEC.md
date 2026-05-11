# Edu SSAFY Clone API Specification

## 1. 문서 목적

이 문서는 `edu_ssafy_clone`의 전체 API 계약을 상위 요구사항 기준으로 정리한다. 기계 판독 가능한 원본은 `docs/api/openapi.yaml`이며, 이 Markdown 문서는 기획·프론트엔드·백엔드 리뷰를 위한 설명 문서다.

첫 배포는 로그인과 메인 대시보드 경험에 집중한다. 강의실, Quest, 커뮤니티, 외부 링크 등은 전체 API catalog에 포함하되 `planned` 또는 `deferred` 상태로 표시한다.

## 2. 범위와 비범위

### 첫 배포 포함

- 데모/시드 사용자 로그인
- 토큰 기반 로그인 상태 확인
- 인증된 사용자만 접근 가능한 대시보드
- API 기반 대시보드 데이터
  - 사용자 요약
  - 공지/알림 요약
  - 출결 요약
  - 포인트/EXP 요약
  - 오늘 일정 요약 또는 빈 배열
- 사용자 권한/상태 기반 내비게이션

### 첫 배포 제외

- 실제 SSAFY 계정 연동
- 실제 `edu.ssafy.com` API 연동
- scraping/crawling
- 관리자 페이지
- 전체 MyCampus/강의실/Quest/커뮤니티 구현
- 게시글/댓글 작성 기능
- 파일 업로드/다운로드
- 실시간 알림

## 3. 공통 API 규약

| 항목 | 값 |
|---|---|
| Local base URL | `http://localhost:8080/api/v1` |
| 인증 방식 | JWT Bearer token |
| 인증 헤더 | `Authorization: Bearer <accessToken>` |
| Content-Type | `application/json` |
| 시간 형식 | ISO-8601 date-time |
| 날짜 형식 | ISO-8601 date |

### 3.1 응답 Envelope

성공:

```json
{
  "success": true,
  "data": {},
  "error": null,
  "meta": null
}
```

실패:

```json
{
  "success": false,
  "data": null,
  "error": {
    "code": "AUTH_UNAUTHORIZED",
    "message": "인증이 필요합니다.",
    "details": []
  },
  "meta": null
}
```

### 3.2 공통 오류 코드

| 코드 | HTTP | 설명 |
|---|---:|---|
| `VALIDATION_ERROR` | 400 | 요청 필드 검증 실패 |
| `AUTH_INVALID_CREDENTIALS` | 401 | 이메일/비밀번호 불일치 |
| `AUTH_UNAUTHORIZED` | 401 | 인증 필요 또는 토큰 만료 |
| `AUTH_FORBIDDEN` | 403 | 권한 없음 |
| `RESOURCE_NOT_FOUND` | 404 | 리소스 없음 |
| `CONFLICT` | 409 | 중복 또는 상태 충돌 |
| `INTERNAL_ERROR` | 500 | 서버 오류 |

### 3.3 Endpoint 상태값

| 상태 | 의미 |
|---|---|
| `first-release` | 첫 배포 구현 및 테스트 대상 |
| `planned` | 전체 제품 명세에 포함하지만 후속 구현 전 재검토 필요 |
| `deferred` | 요구사항은 존재하나 첫 배포에서 명시적으로 제외 |

## 4. 상위 요구사항별 Endpoint 요약

### FR-AUTH — 사용자 인증 및 계정 관리

| Method | Path | 상태 | 인증 | 설명 |
|---|---|---|---|---|
| POST | `/auth/login` | first-release | 불필요 | 이메일/비밀번호 로그인 |
| POST | `/auth/logout` | first-release | 필요 | 클라이언트 토큰 제거 기준 제공 |
| POST | `/auth/refresh` | planned | 불필요 | refresh token 기반 access token 갱신 |
| GET | `/auth/me` | first-release | 필요 | 현재 사용자 조회 |
| PATCH | `/users/me/profile` | planned | 필요 | 사용자 정보 수정 |
| PATCH | `/users/me/password` | planned | 필요 | 비밀번호 변경 |
| DELETE | `/users/me` | planned | 필요 | 계정 비활성화/탈퇴 |

### FR-DASHBOARD — 메인 대시보드 및 개인 학습 현황

| Method | Path | 상태 | 인증 | 설명 |
|---|---|---|---|---|
| GET | `/dashboard/me` | first-release | 필요 | 대시보드 통합 조회 |
| GET | `/dashboard/me/attendance-summary` | first-release | 필요 | 출결 요약 조회 |
| GET | `/dashboard/me/point-summary` | first-release | 필요 | 포인트/EXP 요약 조회 |

### FR-NOTICE — 공지 및 알림

| Method | Path | 상태 | 인증 | 설명 |
|---|---|---|---|---|
| GET | `/notices` | first-release | 필요 | 공지 목록 조회 |
| GET | `/notifications/me` | first-release | 필요 | 내 알림 목록 조회 |
| PATCH | `/notifications/me/{notificationId}/read` | planned | 필요 | 알림 읽음 처리 |

### FR-LECTURE — 강의실 및 학습 콘텐츠

| Method | Path | 상태 | 인증 | 설명 |
|---|---|---|---|---|
| GET | `/courses` | planned | 필요 | 과정/과목 목록 조회 |
| GET | `/courses/{courseId}` | planned | 필요 | 과정 상세 조회 |
| GET | `/courses/{courseId}/weeks` | planned | 필요 | 주차 목록 조회 |
| GET | `/course-sessions/{sessionId}` | planned | 필요 | 강의 세션 상세 조회 |
| GET | `/learning-contents` | planned | 필요 | 학습 콘텐츠 목록 조회 |
| PATCH | `/learning-contents/{contentId}/progress` | planned | 필요 | 학습 진행률 갱신 |

### FR-QUEST — Quest / 평가 관리

| Method | Path | 상태 | 인증 | 설명 |
|---|---|---|---|---|
| GET | `/quests` | planned | 필요 | Quest/과제 목록 조회 |
| GET | `/quests/{questId}` | planned | 필요 | Quest 상세 조회 |
| POST | `/quests/{questId}/submissions` | planned | 필요 | Quest 제출 |
| GET | `/quests/{questId}/result` | planned | 필요 | 내 Quest 결과 조회 |

### FR-COMMUNITY — 커뮤니티 및 게시판

| Method | Path | 상태 | 인증 | 설명 |
|---|---|---|---|---|
| GET | `/boards` | planned | 필요 | 게시판 목록 조회 |
| GET | `/boards/{boardCode}/posts` | planned | 필요 | 게시글 목록 조회 |
| GET | `/posts/{postId}` | planned | 필요 | 게시글 상세 조회 |
| POST | `/boards/{boardCode}/posts` | deferred | 필요 | 게시글 작성, 첫 배포 제외 |
| POST | `/posts/{postId}/comments` | deferred | 필요 | 댓글 작성, 첫 배포 제외 |

### FR-EXTERNAL — 외부 서비스 및 부가 연동

| Method | Path | 상태 | 인증 | 설명 |
|---|---|---|---|---|
| GET | `/external-links` | planned | 필요 | 외부 링크 카드 목록 조회 |

주의: 이 API는 단순 링크 메타데이터만 제공한다. 실제 외부 서비스 API 호출, 실제 SSAFY 연동, scraping/crawling은 금지한다.

### FR-NAV — 공통 UI 및 네비게이션

| Method | Path | 상태 | 인증 | 설명 |
|---|---|---|---|---|
| GET | `/navigation/me` | first-release | 필요 | 내 권한 기준 메뉴 구조 조회 |
| GET | `/app/bootstrap` | planned | 필요 | 앱 초기화 정보 통합 조회 |

## 5. First-release Endpoint 상세

### 5.1 POST `/auth/login`

- 요구사항: `FR-AUTH`, `NFR-AUTH-LOGIN-001`
- 상태: `first-release`
- 인증: 불필요
- 목적: 데모/시드 사용자가 로그인하고 access token을 받는다.

Request:

```json
{
  "email": "student@example.com",
  "password": "password123!"
}
```

Response `200`:

```json
{
  "success": true,
  "data": {
    "accessToken": "demo-access-token",
    "tokenType": "Bearer",
    "expiresIn": 3600,
    "user": {
      "id": 1,
      "email": "student@example.com",
      "name": "김싸피",
      "studentNo": "1100001",
      "generation": 12,
      "region": "서울",
      "classNo": 1,
      "role": "STUDENT",
      "status": "ACTIVE",
      "profileImageUrl": null
    }
  },
  "error": null,
  "meta": null
}
```

주요 오류:

| HTTP | code | 조건 |
|---:|---|---|
| 400 | `VALIDATION_ERROR` | 이메일 형식 또는 비밀번호 누락 |
| 401 | `AUTH_INVALID_CREDENTIALS` | 계정 없음 또는 비밀번호 불일치 |

### 5.2 POST `/auth/logout`

- 요구사항: `FR-AUTH`, `NFR-AUTH-LOGOUT-001`
- 상태: `first-release`
- 인증: 필요
- 목적: 토큰 기반 첫 배포에서 클라이언트가 저장된 token을 제거하도록 성공 응답을 제공한다.

Response `200`:

```json
{
  "success": true,
  "data": null,
  "error": null,
  "meta": null
}
```

### 5.3 POST `/auth/refresh`

- 요구사항: `FR-AUTH`, `NFR-AUTH-SESSION-001`
- 상태: `planned`
- 인증: 불필요, refresh token 요청 본문 사용
- 목적: access token 만료 후 재로그인 없이 token을 갱신한다.

첫 배포에서는 access token 기반 흐름만 구현해도 되며, refresh token 저장, 만료, 회전, 폐기 정책이 확정되기 전까지 이 API는 `planned`로 유지한다.

Request:

```json
{
  "refreshToken": "demo-refresh-token"
}
```

Response `200`: `LoginResponse` envelope와 동일한 형태를 사용한다.

### 5.4 GET `/auth/me`

- 요구사항: `FR-AUTH`, `NFR-AUTH-PROFILE-001`
- 상태: `first-release`
- 인증: 필요
- 목적: 현재 로그인 사용자의 기본 정보를 조회한다.

Response `200`: `CurrentUser` envelope

민감 정보 제외:

- password
- password change history
- audit log
- emergency phone number 등 첫 배포 화면에 필요 없는 개인 정보

### 5.5 GET `/dashboard/me`

- 요구사항: `FR-DASHBOARD`
- 상태: `first-release`
- 인증: 필요
- 목적: 로그인 후 메인 대시보드에 필요한 모든 요약 데이터를 한 번에 조회한다.

Response `200`의 `data` 구성:

| 필드 | 설명 | DB/도메인 근거 |
|---|---|---|
| `userSummary` | 사용자 이름, 기수, 지역, 반, 레벨 | `users`, `user_stats` |
| `noticeSummary` | 최신/중요 공지 요약 | `boards`, `board_posts` |
| `notificationSummary` | 읽지 않은 알림 및 최근 알림 | `notifications` |
| `attendanceSummary` | 출석률, 지각/결석/조퇴, 오늘 상태 | `attendance_records`, `user_stats` |
| `pointSummary` | 장학 포인트, EXP, 레벨 | `user_stats`, `point_transactions` |
| `todayScheduleSummary` | 오늘 강의/일정 카드 | `courses`, `course_sessions` |

### 5.6 GET `/dashboard/me/attendance-summary`

- 요구사항: `FR-DASHBOARD`
- 상태: `first-release`
- 인증: 필요
- 목적: 대시보드 출결 카드 또는 출결 상세 진입 전 요약을 단독으로 조회한다.

주요 필드:

| 필드 | 타입 | 설명 |
|---|---|---|
| `attendanceRate` | number | 출석률 |
| `normalCount` | integer | 정상 출석 횟수 |
| `lateCount` | integer | 지각 횟수 |
| `absentCount` | integer | 결석 횟수 |
| `earlyLeaveCount` | integer | 조퇴 횟수 |
| `todayStatus` | enum | 오늘 출결 상태 |
| `todayCheckInAt` | date-time/null | 오늘 입실 시간 |
| `todayCheckOutAt` | date-time/null | 오늘 퇴실 시간 |

### 5.7 GET `/dashboard/me/point-summary`

- 요구사항: `FR-DASHBOARD`
- 상태: `first-release`
- 인증: 필요
- 목적: 장학 포인트, EXP, 레벨 정보를 대시보드 카드에 표시한다.

주요 필드:

| 필드 | 타입 | 설명 |
|---|---|---|
| `scholarshipPoint` | integer | 현재 장학 포인트 |
| `totalExp` | integer | 누적 경험치 |
| `levelName` | string | 레벨명 |
| `levelNo` | integer | 레벨 번호 |
| `nextLevelExp` | integer/null | 다음 레벨 기준 EXP |

### 5.8 GET `/notices`

- 요구사항: `FR-NOTICE`
- 상태: `first-release`
- 인증: 필요
- 목적: 대시보드 공지 영역과 공지 목록 화면의 기초 데이터를 제공한다.

Query:

| 이름 | 타입 | 기본값 | 설명 |
|---|---|---:|---|
| `page` | integer | 0 | 페이지 번호 |
| `size` | integer | 20 | 페이지 크기 |

### 5.9 GET `/notifications/me`

- 요구사항: `FR-NOTICE`
- 상태: `first-release`
- 인증: 필요
- 목적: 내 알림 목록과 읽지 않은 알림 요약을 제공한다.

Query:

| 이름 | 타입 | 기본값 | 설명 |
|---|---|---:|---|
| `page` | integer | 0 | 페이지 번호 |
| `size` | integer | 20 | 페이지 크기 |
| `unreadOnly` | boolean | false | 읽지 않은 알림만 조회 |

### 5.10 GET `/navigation/me`

- 요구사항: `FR-NAV`
- 상태: `first-release`
- 인증: 필요
- 목적: 현재 사용자에게 표시할 메뉴 구조를 제공한다.

첫 배포에서는 후속 기능 메뉴를 `enabled: false`로 반환할 수 있다.

```json
{
  "success": true,
  "data": {
    "items": [
      {"key": "dashboard", "label": "홈", "path": "/dashboard", "enabled": true, "children": []},
      {"key": "classroom", "label": "강의실", "path": "/classroom", "enabled": false, "children": []}
    ]
  },
  "error": null,
  "meta": null
}
```

## 6. 핵심 DTO 요약

### LoginRequest

| 필드 | 타입 | 필수 | 설명 |
|---|---|---|---|
| `email` | string/email | Y | 로그인 ID |
| `password` | string | Y | 비밀번호 |

### CurrentUser

| 필드 | 타입 | 설명 |
|---|---|---|
| `id` | long | 유저 식별자 |
| `email` | string | 이메일 |
| `name` | string | 이름 |
| `studentNo` | string/null | 학번 |
| `generation` | integer/null | SSAFY 기수 |
| `region` | string/null | 지역 |
| `classNo` | integer/null | 반 번호 |
| `role` | enum | `STUDENT`, `ADMIN`, `OPERATOR`, `MENTOR` |
| `status` | enum | `ACTIVE`, `INACTIVE`, `WITHDRAWN` |
| `profileImageUrl` | string/null | 프로필 이미지 URL |

### Dashboard

| 필드 | 설명 |
|---|---|
| `userSummary` | 사용자 표시 정보 |
| `noticeSummary` | 공지 요약 |
| `notificationSummary` | 알림 요약 |
| `attendanceSummary` | 출결 요약 |
| `pointSummary` | 포인트/EXP 요약 |
| `todayScheduleSummary` | 오늘 일정 요약 배열 |

## 7. 구현 및 테스트 기준

### Backend 최소 테스트

- 로그인 성공: `POST /auth/login` returns 200 and token
- 로그인 실패: invalid credentials returns `AUTH_INVALID_CREDENTIALS`
- 인증 필요: token 없이 `/auth/me`, `/dashboard/me` 접근 시 401
- 현재 사용자 조회: password 등 민감 정보 미포함
- 대시보드 조회: `userSummary`, `noticeSummary`, `notificationSummary`, `attendanceSummary`, `pointSummary` 포함
- 공지/알림 목록: page meta와 배열 응답 반환
- 네비게이션 조회: dashboard 메뉴 enabled true

### Frontend 최소 테스트

- 로그인 폼이 API 계약의 `email`, `password`를 전송한다.
- 로그인 성공 시 token을 저장하고 dashboard로 이동한다.
- 인증 없이 dashboard 접근 시 login으로 redirect 또는 차단한다.
- dashboard 화면이 `/dashboard/me` 응답의 4대 핵심 카드(user/notice/attendance/point)를 렌더링한다.
- API 실패 시 사용자에게 오류 상태를 표시한다.

## 8. 변경 관리

- API 변경 시 `openapi.yaml`과 이 문서를 함께 수정한다.
- first-release endpoint의 request/response 변경은 frontend/backend 테스트를 함께 갱신한다.
- planned/deferred endpoint는 구현 착수 전 요구사항과 화면 흐름을 재검토한다.
- 실제 SSAFY 서비스와 연결하는 변경은 현재 제품 경계 밖이며 별도 승인 없이는 금지한다.
