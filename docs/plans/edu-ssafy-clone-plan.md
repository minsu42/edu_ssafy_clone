# edu.ssafy.com Clone Implementation Plan

최종 확인일: 2026-05-11

## 1. 목표

`edu.ssafy.com`의 핵심 사용자 경험을 독립적인 더미 데이터 기반 서비스로 재현한다. 첫 릴리스는 메인 대시보드와 최소 인증 흐름을 갖춘 로컬 실행 가능한 풀스택 클론을 목표로 한다.

## 2. 기준 문서

1. [`software-design-plan.md`](./software-design-plan.md) — 기술 스택, API, 프론트/백엔드 설계 기준
2. [`../../DESIGN.md`](../../DESIGN.md) — 디자인 시스템, 색상, 레이아웃, 컴포넌트 기준
3. [`../database/schema.sql`](../database/schema.sql), [`../database/tables.md`](../database/tables.md) — DB 스키마와 테이블 설명
4. [`../requirements/README.md`](../requirements/README.md) — 요구사항 문서 목록
5. [`../../.omx/plans/first-deployment.md`](../../.omx/plans/first-deployment.md) — OMX 작업 계획 원본
6. [`../../.omx/plans/first-deployment-verification.md`](../../.omx/plans/first-deployment-verification.md) — 검증 지도

## 3. 현재 저장소 상태

- 구현 스캐폴딩은 아직 없다.
- 문서/설계 산출물은 존재한다.
- 디자인 참조 스크린샷은 `docs/design/screenshots/`에 40개 PNG로 정리되어 있다.
- DB 스키마와 테이블 문서는 `docs/database/`에 존재한다.
- OMX 실행/검증 계획은 `.omx/plans/`에 존재하며, 이 문서는 그 내용을 일반 문서 영역인 `docs/plans/`로 연결한다.

## 4. 개발 순서

### 4.1 문서 기준 정렬

- `docs/README.md`, `AGENTS.md`, `docs/plans/*`의 실제 경로를 일치시킨다.
- 디자인 참조 목록과 실제 스크린샷 파일명을 동기화한다.
- 계획 문서와 검증 문서를 분리해 유지한다.

### 4.2 Frontend 스캐폴딩

- Vue 3 + Vite 프로젝트 생성
- Router/Pinia/Axios 기본 구성
- `tokens.css`, `global.css` 구성
- 공통 레이아웃 컴포넌트 생성
- Vitest/Vue Test Utils 기반 테스트 환경 구성

### 4.3 Backend 스캐폴딩

- Spring Boot 3.x 프로젝트 생성
- Web, JPA, Security, Validation, Test 구성
- 공통 응답/오류 형식 구현
- JWT 인증 최소 구조 구현
- 로컬 DB 설정과 더미 seed 데이터 준비

### 4.4 핵심 API 구현

- `POST /api/auth/login`
- `GET /api/dashboard/me`
- 대시보드 응답 DTO 구성
- 민감 정보 제외 검증

### 4.5 대시보드 UI 구현

- Header/GNB
- 사용자 요약
- 출석/포인트/레벨 카드
- 알림/공지
- 커리큘럼/Quest/학습자료/e-learning/커뮤니티 요약
- Footer와 플로팅 버튼
- 로딩/오류/빈 상태

### 4.6 통합과 검증

- 프론트엔드에서 백엔드 API 연동
- 로컬 실행 문서 작성
- 빌드/테스트 명령 검증
- 수동 스모크 테스트 기록

## 5. 릴리스 제외 범위

첫 릴리스에서는 다음을 제외한다.

- 실제 SSAFY 인증/데이터/내부 API 연동
- 실제 로고/저작권 이미지 포함
- 크롤링/자동화 수집
- 모든 하위 페이지의 완전 구현
- 운영 수준의 결제/메일/파일 업로드 인프라

## 6. 완료 기준

- 로컬에서 프론트엔드와 백엔드가 실행된다.
- 핵심 API 2개가 동작한다.
- 대시보드가 승인된 디자인 기준과 주요 화면 구조를 반영한다.
- 테스트/빌드/실행 명령이 문서화되어 있고 실제로 검증된다.
- 실제 SSAFY 개인정보/내부 콘텐츠/세션 정보가 저장소에 포함되지 않는다.
