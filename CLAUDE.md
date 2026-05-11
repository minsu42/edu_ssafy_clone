# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 프로젝트 개요

edu.ssafy.com(에듀싸피) 클론 코딩 프로젝트. 멀티 에이전트 기반 하네스 프롬프팅 구조의 코드 생성 품질 검증이 실제 목적이며, 에듀싸피 서비스를 기능 단위로 구현한다.

## 기술 스택

- **백엔드**: Spring Boot (Java 17+), Gradle, Spring Data JPA (Hibernate), MySQL 8.x
- **프론트엔드**: Vue 3, Vite, Pinia
- **저장소 구조**: 모노레포 — `backend/`, `frontend/` 디렉터리로 분리

## 주요 명령어

### 백엔드 (`backend/`)

```bash
./gradlew bootRun               # 개발 서버 실행
./gradlew build                 # 빌드 (테스트 포함)
./gradlew build -x test         # 테스트 제외 빌드
./gradlew test                  # 전체 테스트
./gradlew test --tests "com.example.XxxTest" # 단일 테스트 클래스 실행
```

### 프론트엔드 (`frontend/`)

```bash
npm install       # 의존성 설치
npm run dev       # 개발 서버 실행
npm run build     # 프로덕션 빌드
npm run lint      # ESLint 검사
```

## 아키텍처

### 모노레포 구조

```
edussafy_clone/
├── backend/          # Spring Boot 애플리케이션
├── frontend/         # Vue 3 SPA
└── docs/
    ├── database/     # schema.sql, table.md (DB 설계 기준)
    ├── design/       # edu_screenshot/ (화면 기준 스크린샷)
    └── requirements/ # 기능/비기능 요구사항 문서
```

### 백엔드 레이어

Spring Boot 표준 레이어드 아키텍처: Controller → Service → Repository (JPA Entity). 도메인별 패키지로 구성한다.

### 프론트엔드 구조

Vue 3 Composition API + Pinia 상태관리. 페이지 단위 라우팅, 공통 레이아웃(GNB/LNB) 분리.

## 도메인 구조

상위 요구사항 식별자 기준으로 도메인을 구분한다:

| 식별자 | 도메인 | 주요 테이블 |
|--------|--------|-------------|
| FR-AUTH | 인증/계정 | `users`, `password_change_histories`, `user_agreements` |
| FR-DASHBOARD | 대시보드 | `user_stats`, `point_transactions`, `attendance_records` |
| FR-LECTURE | 강의실 | `courses`, `course_weeks`, `course_sessions`, `learning_contents`, `user_learning_progresses` |
| FR-QUEST | Quest/평가 | `course_tasks`, `user_task_results` |
| FR-COMMUNITY | 커뮤니티 | `boards`, `board_categories`, `board_posts`, `board_comments` |
| FR-NOTICE | 공지/알림 | `notifications`, `inquiries` |

## DB 설계 기준

- 스키마 정의: `docs/database/schema.sql` (MySQL 8.x dialect)
- 테이블 명세: `docs/database/table.md`
- `users.role`: `STUDENT`, `ADMIN`, `OPERATOR`, `MENTOR`
- `users.status`: `ACTIVE`, `INACTIVE`, `WITHDRAWN`
- 파일 업로드는 `files` 테이블에 단일화, `target_type` + `target_id` 로 대상 연결

## 화면 기준

`docs/design/edu_screenshot/` 에 40장의 스크린샷이 있다. 기능 구현 전 해당 화면을 반드시 확인한다. 파일명이 기능을 설명한다 (예: `01_home_dashboard.png`, `03_quest_evaluation_list.png`).

## 요구사항 문서 위치

- 기능 요구사항: `docs/requirements/03_기능_요구사항.md`
- 비기능 요구사항: `docs/requirements/04_비기능_요구사항.md`
- 요구사항 추적: `docs/requirements/05_요구사항_추적표.md`
- 실제 SSAFY 계정·세션·내부 공지·파일은 샘플 데이터에 포함하지 않는다.
