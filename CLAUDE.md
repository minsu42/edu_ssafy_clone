# Edu-ssafy-com clone - Claude Context

edu.ssafy.com(에듀싸피) 클론 코딩 프로젝트. 멀티 에이전트 기반 하네스 프롬프팅 구조의 코드 생성 품질 검증이 실제 목적이며, 에듀싸피 서비스를 기능 단위로 구현한다.

## Commands

### Backend (`backend/`)

```bash
./gradlew bootRun                              # 개발 서버 실행
./gradlew build                                # 빌드 (테스트 포함)
./gradlew build -x test                        # 테스트 제외 빌드
./gradlew test                                 # 전체 테스트
./gradlew test --tests "com.ssafy.edu.XxxTest"  # 단일 테스트 클래스 실행
```

### Frontend (`frontend/`)

```bash
npm install       # 의존성 설치
npm run dev       # 개발 서버 실행
npm run build     # 프로덕션 빌드
npm run lint      # ESLint 검사
npm run test      # Vitest 단위 테스트 실행
```

## Architecture

### Monorepo 구조

```
edu_ssafy_clone/
├── backend/          # Spring Boot 애플리케이션
├── frontend/         # Vue 3 SPA
└── docs/
    ├── api/          # 도메인별 API 명세 (auth.md, ...)
    ├── database/     # schema.sql, table.md
    ├── design/       # edu_screnshot/ (화면 스크린샷 40장)
    ├── plan/         # 개발 계획서 (edu-ssafy-com-wise-goose.md)
    └── requirements/ # 기능/비기능 요구사항 문서
```

### Backend

Spring Boot 표준 레이어드 아키텍처: Controller → Service → Repository (JPA Entity). 도메인별 패키지로 구성한다.

### Frontend

Vue 3 Composition API + Pinia 상태관리. 페이지 단위 라우팅, 공통 레이아웃(GNB/LNB) 분리.

### Domain

| 식별자 | 도메인 | 주요 테이블 |
|--------|--------|-------------|
| FR-AUTH | 인증/계정 | `users`, `password_change_histories`, `refresh_tokens` |
| FR-DASHBOARD | 대시보드 | `user_stats`, `point_transactions`, `attendance_records` |
| FR-LECTURE | 강의실 | `courses`, `course_weeks`, `course_sessions`, `learning_contents`, `user_learning_progresses` |
| FR-QUEST | Quest/평가 | `course_tasks`, `user_task_results` |
| FR-COMMUNITY | 커뮤니티 | `boards`, `board_categories`, `board_posts`, `board_comments` |
| FR-NOTICE | 공지/알림 | `notifications`, `inquiries` |

## Stack

| Layer | Tech |
|-------|------|
| Backend | Spring Boot 4.0.6 (Java 21), Gradle, Spring Data JPA (Hibernate), MySQL 8.x |
| Frontend | Vue 3, Vite, TypeScript, Pinia, Vue Router, Vitest, MSW |

## Frontend UI Rules

- UI 구현 전 해당 화면의 `docs/design/edu_screnshot/` 스크린샷을 반드시 Read한다.
- 색상·타이포그래피·간격·border-radius 등 모든 스타일 값은 `docs/design/DESIGN.md` 토큰을 기준으로 한다.

## Hard Rules

- 기능 구현 전 반드시 `docs/design/edu_screnshot/` 스크린샷을 확인한다.
- DB 스키마는 `docs/database/schema.sql` 이 단일 기준이다. 임의로 컬럼·테이블을 추가하지 않는다.
- `users.role`: `STUDENT` | `ADMIN` | `OPERATOR` | `MENTOR`
- `users.status`: `ACTIVE` | `INACTIVE` | `WITHDRAWN`
- 파일 업로드는 `files` 테이블에 단일화 — `target_type` + `target_id` 로 대상 연결.
- 실제 SSAFY 계정·세션·내부 공지·파일은 샘플 데이터에 절대 포함하지 않는다.

## Reference

| 목적 | 경로 |
|------|------|
| DB 스키마 | `docs/database/schema.sql` |
| 테이블 명세 | `docs/database/table.md` |
| 화면 스크린샷 | `docs/design/edu_screnshot/` (파일명이 기능 설명) |
| 기능 요구사항 | `docs/requirements/03_기능_요구사항.md` |
| 비기능 요구사항 | `docs/requirements/04_비기능_요구사항.md` |
| 요구사항 추적표 | `docs/requirements/05_요구사항_추적표.md` |
| FR-AUTH API 명세 | `docs/api/auth.md` |
| 개발 계획서 | `docs/plan/edu-ssafy-com-wise-goose.md` |
| 진행관리 (현황·검증 요약) | `docs/plan/progress.md` |
| 페이즈 완료 보고서 | `docs/changes/{phase-id}-*.md` |
