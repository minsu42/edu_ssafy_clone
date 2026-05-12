# D2 — FR-DASHBOARD 문서화 완료 보고

- **날짜**: 2026-05-12
- **브랜치**: 현재 작업 브랜치
- **작업 범위**: 대시보드 요구사항 도출 + API 명세 + 추적표/진행현황 업데이트

---

## 완료 기준

| 기준 | 결과 |
|------|------|
| FR-DASHBOARD-* 4개 항목 정상/예외/비즈니스 규칙 기술 | PASS |
| `docs/api/dashboard.md` 4개 조회 API 명세 완료 | PASS |
| 요구사항 추적표 업데이트 | PASS |

---

## 변경 1 — FR-DASHBOARD 요구사항 도출 (`docs/requirements/03_기능_요구사항.md`)

참조 자료:
- `docs/design/edu_screnshot/01_home_dashboard.png`
- `docs/design/edu_screnshot/25_mycampus_level_points_dashboard.png`
- `docs/design/edu_screnshot/26_mycampus_attendance_status.png`
- `docs/design/edu_screnshot/40_attendance_detail_from_home_more.png`
- `docs/database/schema.sql`
- `docs/database/table.md`

추가한 요구사항:

| 식별자 | 요구사항명 | 핵심 내용 |
|--------|------------|-----------|
| FR-DASHBOARD-001 | 홈 대시보드 조회 | 레벨/포인트/출석률/미완료 학습 수 요약 |
| FR-DASHBOARD-002 | 이번 달 출결 현황 조회 | 월별 달력, 출결 상태, 월간 집계 |
| FR-DASHBOARD-003 | 포인트 적립/차감 이력 조회 | 페이지네이션, 최신순 이력, 현재 잔액 |
| FR-DASHBOARD-004 | 레벨 및 포인트 상세 통계 조회 | 누적 포인트/경험치 집계, 레벨 통계 |

각 항목에 입력, 정상 시나리오, 예외 시나리오, 비즈니스 규칙을 추가하고 상태를 `문서화 완료`로 반영했다.

---

## 변경 2 — API 명세 작성 (`docs/api/dashboard.md`) — 신규 생성

다음 4개 읽기 API를 명세했다.

| 메서드 | 경로 | 요구사항 |
|--------|------|----------|
| GET | `/api/v1/dashboard` | FR-DASHBOARD-001 |
| GET | `/api/v1/users/me/stats` | FR-DASHBOARD-004 |
| GET | `/api/v1/users/me/attendance?year=&month=` | FR-DASHBOARD-002 |
| GET | `/api/v1/users/me/points?page=&size=` | FR-DASHBOARD-003 |

각 엔드포인트에 대해:
- 인증 방식
- 요청 파라미터
- 응답 예시
- 응답 필드 테이블
- 오류 응답

을 모두 문서화했다.

---

## 변경 3 — 요구사항 추적표 업데이트 (`docs/requirements/05_요구사항_추적표.md`)

반영 내용:
- `D2` 페이즈 상태를 `✅ 완료`로 갱신
- `FR-DASHBOARD` 4개 항목의 요구사항/API 작성 상태 추가
- D2 산출물 목록 추가
- 이력에 D2 완료 기록 추가

---

## 변경 4 — 진행 현황 갱신 (`docs/plan/progress.md`)

반영 내용:
- 진행 현황 표에서 `D2`를 `✅ 완료`로 갱신
- 최종 업데이트 날짜 갱신
- D2 검증 요약 섹션 추가

---

## 검증

| 항목 | 결과 |
|------|------|
| 계획서 D2 정의와 산출물 일치 여부 점검 | PASS |
| 요구사항 ↔ API ↔ 추적표 링크 일관성 점검 | PASS |
| 문서 파일 존재 확인 (`docs/api/dashboard.md`, `docs/changes/d2-fr-dashboard-documentation.md`) | PASS |

문서화 페이즈이므로 자동 테스트는 수행하지 않았다.

---

## 다음 단계

**P2-BE — FR-DASHBOARD 백엔드 구현**

참조 문서:
- `docs/requirements/03_기능_요구사항.md`
- `docs/api/dashboard.md`

우선순위:
1. `DashboardService` 집계 규칙 테스트 작성
2. 출결/포인트 조회용 Repository 테스트 작성
3. 대시보드 조회 API Controller 테스트 작성
