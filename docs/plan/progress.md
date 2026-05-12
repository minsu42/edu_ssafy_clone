# 에듀싸피 클론 — 진행관리

> 본 문서는 **진행 현황과 페이즈 검증 요약**만 다룬다.
> 계획·원칙·로드맵은 [`edu-ssafy-com-wise-goose.md`](./edu-ssafy-com-wise-goose.md) 참조.
> 페이즈별 **상세 검증 보고**는 [`docs/changes/`](../changes/) 디렉터리가 단일 출처(SSOT)다.

---

## 진행 현황

> 최종 업데이트: 2026-05-12 (P1-FE 완료, D2 다음 단계)

| 페이즈 | 유형 | 이름 | 상태 | 완료일 | 상세 보고 / 비고 |
|--------|------|------|------|--------|------------------|
| P0 | 구현 | 프로젝트 부트스트랩 | ✅ 완료 | 2026-05-11 | [`changes/p0-project-bootstrap.md`](../changes/p0-project-bootstrap.md) · `feat/p0-project-bootstrap` |
| D1 | 문서화 | FR-AUTH 요구사항 보완 + API 명세 | ✅ 완료 | 2026-05-11 | [`changes/d1-fr-auth-documentation.md`](../changes/d1-fr-auth-documentation.md) |
| P1-BE | 구현 | FR-AUTH 백엔드 | ✅ 완료 | 2026-05-12 | [`changes/p1-fr-auth-implementation.md`](../changes/p1-fr-auth-implementation.md) · `feat/p1-fr-auth` |
| P1-FE | 구현 | FR-AUTH 프론트엔드 | ✅ 완료 | 2026-05-12 | [`changes/p1-fe-auth.md`](../changes/p1-fe-auth.md) · `feat/p1-fe-auth` |
| D2 | 문서화 | FR-DASHBOARD 요구사항 도출 + API 명세 | ⏳ 다음 단계 | — | — |
| P2-BE | 구현 | FR-DASHBOARD 백엔드 | ⬜ 미시작 | — | — |
| P2-FE | 구현 | FR-DASHBOARD 프론트엔드 | ⬜ 미시작 | — | 대시보드 화면 + E2E |
| D3 | 문서화 | FR-LECTURE 요구사항 도출 + API 명세 | ⬜ 미시작 | — | — |
| P3-BE | 구현 | FR-LECTURE 백엔드 | ⬜ 미시작 | — | — |
| P3-FE | 구현 | FR-LECTURE 프론트엔드 | ⬜ 미시작 | — | 강의실·이러닝 화면 + E2E |
| D4 | 문서화 | FR-QUEST 요구사항 도출 + API 명세 | ⬜ 미시작 | — | — |
| P4-BE | 구현 | FR-QUEST 백엔드 | ⬜ 미시작 | — | — |
| P4-FE | 구현 | FR-QUEST 프론트엔드 | ⬜ 미시작 | — | Quest 화면 + E2E |
| D5 | 문서화 | FR-COMMUNITY 요구사항 도출 + API 명세 | ⬜ 미시작 | — | — |
| P5-BE | 구현 | FR-COMMUNITY 백엔드 | ⬜ 미시작 | — | — |
| P5-FE | 구현 | FR-COMMUNITY 프론트엔드 | ⬜ 미시작 | — | 커뮤니티 화면 + E2E |
| D6 | 문서화 | FR-NOTICE 요구사항 도출 + API 명세 | ⬜ 미시작 | — | — |
| P6-BE | 구현 | FR-NOTICE 백엔드 | ⬜ 미시작 | — | — |
| P6-FE | 구현 | FR-NOTICE 프론트엔드 | ⬜ 미시작 | — | 공지·알림 화면 + E2E |
| P7 | 구현 | 횡단 관심사 & 통합 시나리오 | ⬜ 미시작 | — | — |

---

## 검증 요약

> 각 페이즈 완료 기준은 계획서의 해당 섹션에서, 검증 상세는 `docs/changes/`의 보고서에서 확인한다. 본 절은 한눈 요약만 둔다.

### P0 — 프로젝트 부트스트랩 (2026-05-11)

| 완료 기준 | 결과 |
|-----------|------|
| `./gradlew test` — contextLoads() 통과 | ✅ PASS |
| `npm run test` — 빈 스토어 스모크 테스트 통과 | ✅ PASS |
| MySQL Testcontainers + schema.sql DDL 실행 | ✅ PASS |
| Swagger UI 초기화 (컨텍스트 로드 성공) | ✅ PASS |

상세: [`changes/p0-project-bootstrap.md`](../changes/p0-project-bootstrap.md)

### D1 — FR-AUTH 문서화 (2026-05-11)

| 완료 기준 | 결과 |
|-----------|------|
| FR-AUTH-* 8개 항목 정상/예외/비즈니스 규칙 기술 | ✅ PASS |
| `docs/api/auth.md` 7개 엔드포인트 + 1개 필터 명세 완료 | ✅ PASS |
| 요구사항 추적표 업데이트 | ✅ PASS |

상세: [`changes/d1-fr-auth-documentation.md`](../changes/d1-fr-auth-documentation.md)

### P1-BE — FR-AUTH 백엔드 (2026-05-12)

| 완료 기준 | 결과 |
|-----------|------|
| AuthService 라인 커버리지 80% 이상 | ✅ PASS — 93% (71/76 라인) |
| Auth 엔드포인트 MockMvc 테스트 존재 (API 명세 전체 커버) | ✅ PASS — AuthControllerTest 6건, UserControllerTest 7건 |
| JWT 발급/검증/갱신 통합 테스트 통과 | ✅ PASS — SecurityIntegrationTest 5건 |
| Repository 레이어 테스트 (Testcontainers) | ✅ PASS — UserRepositoryTest 6건, RefreshTokenRepositoryTest 4건 |
| `./gradlew test` 전체 통과 | ✅ PASS — 44건 GREEN (AuthService 8 + UserService 7 + AuthController 6 + UserController 7 + SecurityIntegration 5 + UserRepository 6 + RefreshTokenRepository 4 + contextLoads 1) |
| 실서버 API 동작 확인 | ✅ PASS — 로그인/로그아웃/토큰갱신/프로필 조회 수동 검증 |

상세: [`changes/p1-fr-auth-implementation.md`](../changes/p1-fr-auth-implementation.md)

### P1-FE — FR-AUTH 프론트엔드 (2026-05-12)

| 완료 기준 | 결과 |
|-----------|------|
| `npm run test` — smoke + 스토어 + 컴포넌트 8건 GREEN | ✅ PASS |
| 스토어 단위 테스트 4건 (로그인/실패/로그아웃/갱신) | ✅ PASS |
| 컴포넌트 테스트 3건 (LoginPage) | ✅ PASS |
| E2E 테스트 3건 작성 (page.route 모킹, 브라우저 설치 후 실행 가능) | ✅ 작성 완료 |
| 라우터 인증 가드 (미인증 → /login 리다이렉트) | ✅ 구현 완료 |
| Axios 인터셉터 (토큰 주입 + 401 시 자동 갱신) | ✅ 구현 완료 |
| GNB 레이아웃 (스크린샷 01/37 기반) | ✅ 구현 완료 |
| 로그인·프로필·대시보드 화면 | ✅ 구현 완료 |

상세: [`changes/p1-fe-auth.md`](../changes/p1-fe-auth.md)

---

## 운영 규칙

- 페이즈가 완료되면 본 문서의 **진행 현황 표**와 **검증 요약** 절을 함께 갱신한다.
- 신규 페이즈 보고서는 `docs/changes/{phase-id}-{slug}.md` 형식으로 추가하고 본 문서에서 링크만 건다.
- 계획·원칙·기술 결정 변경은 본 문서가 아니라 [`edu-ssafy-com-wise-goose.md`](./edu-ssafy-com-wise-goose.md)에 반영한다.
