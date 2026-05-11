# D1 — FR-AUTH 문서화 완료 보고

- **날짜**: 2026-05-11
- **브랜치**: `feat/p0-project-bootstrap`
- **작업 범위**: 요구사항 식별자 정비 + FR-AUTH 문서화 + schema.sql 보완

---

## 완료 기준

| 기준 | 결과 |
|------|------|
| FR-AUTH-* 8개 항목 정상/예외/비즈니스 규칙 기술 | PASS |
| `docs/api/auth.md` 7개 엔드포인트 + 1개 필터 명세 완료 | PASS |
| 요구사항 추적표 업데이트 | PASS |

---

## 변경 1 — 요구사항 식별자 전면 정비 (NFR → FR)

### 배경

기능 요구사항(로그인, 로그아웃 등)에 `NFR-` 접두사가 잘못 적용되어 있었다.
- `NFR`: Non-Functional Requirement (비기능 요구사항)
- `FR`: Functional Requirement (기능 요구사항)

`02_상위_요구사항.md`는 이미 `FR-AUTH`, `FR-DASHBOARD` 등 올바른 접두사를 사용 중이었으나,
하위 식별자(`NFR-AUTH-LOGIN-001` 등)가 불일치 상태였다.

### 변경 내용

| 변경 전 | 변경 후 |
|---------|---------|
| `NFR-AUTH-LOGIN-001` | `FR-AUTH-LOGIN-001` |
| `NFR-DASHBOARD-001` | `FR-DASHBOARD-001` |
| `NFR-LECTURE-001` | `FR-LECTURE-001` |
| `NFR-QUEST-001` | `FR-QUEST-001` |
| `NFR-COMMUNITY-001` | `FR-COMMUNITY-001` |
| `NFR-NOTICE-001` | `FR-NOTICE-001` |

> `NFR-SEC-AUTH-001` (비기능 요구사항 실제 식별자)은 유지.

### 수정 파일

| 파일 | 변경 내용 |
|------|-----------|
| `docs/requirements/03_기능_요구사항.md` | 식별자 전체 교체 |
| `docs/requirements/04_비기능_요구사항.md` | 기능 요구사항 참조 부분만 교체 |
| `docs/requirements/에듀싸피_클론_프로젝트_통합_문서.md` | 식별자 전체 교체 |
| `docs/plan/edu-ssafy-com-wise-goose.md` | 식별자 전체 교체, 표기 체계 업데이트 |
| `docs/changes/p0-project-bootstrap.md` | 식별자 교체 |

---

## 변경 2 — CLAUDE.md 스크린샷 경로 오타 수정

| 항목 | 변경 전 | 변경 후 |
|------|---------|---------|
| Hard Rules 경로 | `docs/design/edu_screenshot/` | `docs/design/edu_screnshot/` |
| Reference 경로 | `docs/design/edu_screenshot/` | `docs/design/edu_screnshot/` |
| Monorepo 구조 주석 | `edu_screenshot/` | `edu_screnshot/` |

실제 디렉토리명이 `edu_screnshot`이므로 문서를 실제 경로에 맞게 수정.

---

## 변경 3 — FR-AUTH 요구사항 보완 (`docs/requirements/03_기능_요구사항.md`)

기존 항목에 상세 내용 추가. 상태를 `시작전` → `문서화 완료`로 변경.

| 식별자 | 요구사항명 | 추가된 내용 |
|--------|------------|------------|
| FR-AUTH-LOGIN-001 | 로그인 | 입력, 정상/예외 시나리오, 비즈니스 규칙 |
| FR-AUTH-LOGOUT-001 | 로그아웃 | 입력, 정상/예외 시나리오, 비즈니스 규칙 |
| FR-AUTH-SESSION-001 | 세션 유지 및 토큰 갱신 | 입력, 정상/예외 시나리오, Rotation 규칙 |
| FR-AUTH-PROFILE-001 | 사용자 기본 정보 조회 | 정상/예외 시나리오, 비즈니스 규칙 |
| FR-AUTH-PROFILE-002 | 사용자 정보 수정 | 입력, 정상/예외 시나리오, 수정 불가 필드 |
| FR-AUTH-CREDENTIAL-001 | 비밀번호 변경 | 입력, 정상/예외 시나리오, 비밀번호 규칙 |
| FR-AUTH-STATUS-001 | 계정 상태 검증 | 정상/예외 시나리오, Filter 처리 규칙 |
| FR-AUTH-WITHDRAW-001 | 회원 탈퇴 | 정상/예외 시나리오, Soft Delete 규칙 |

---

## 변경 4 — API 명세 작성 (`docs/api/auth.md`) — 신규 생성

7개 엔드포인트 + 1개 필터 내부 처리 전체 명세.

| 엔드포인트 | 메서드 | 요구사항 |
|-----------|--------|----------|
| `/api/v1/auth/login` | POST | FR-AUTH-LOGIN-001 |
| `/api/v1/auth/logout` | POST | FR-AUTH-LOGOUT-001 |
| `/api/v1/auth/refresh` | POST | FR-AUTH-SESSION-001 |
| `/api/v1/users/me` | GET | FR-AUTH-PROFILE-001 |
| `/api/v1/users/me` | PATCH | FR-AUTH-PROFILE-002 |
| `/api/v1/users/me/password` | PUT | FR-AUTH-CREDENTIAL-001 |
| `/api/v1/users/me` | DELETE | FR-AUTH-WITHDRAW-001 |
| JwtAuthFilter 내부 | — | FR-AUTH-STATUS-001 |

각 엔드포인트에 요청 바디, 응답 필드, 오류 응답 전체 명세 포함.

---

## 변경 5 — schema.sql 보완 (`refresh_tokens` 테이블 추가)

### 배경

JWT는 Stateless이므로 서버가 발급한 토큰을 취소할 수 없다.
FR-AUTH 요구사항에서 아래 기능이 필요하며, 이를 위해 Refresh Token을 DB에 저장해야 한다.

| 요구사항 | 필요 이유 |
|----------|----------|
| FR-AUTH-LOGOUT-001 | 로그아웃 시 Refresh Token 즉시 무효화 |
| FR-AUTH-SESSION-001 | Refresh Token Rotation + 탈취 감지 |
| FR-AUTH-CREDENTIAL-001 | 비밀번호 변경 시 모든 Refresh Token 무효화 |
| FR-AUTH-WITHDRAW-001 | 탈퇴 시 모든 Refresh Token 삭제 |

### 추가된 테이블

```sql
CREATE TABLE refresh_tokens (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '토큰 식별자',
    user_id BIGINT NOT NULL COMMENT '토큰 소유자 유저 ID',
    token VARCHAR(500) NOT NULL COMMENT 'JWT Refresh Token 값',
    expires_at DATETIME NOT NULL COMMENT '토큰 만료 일시',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '토큰 발급 일시',
    PRIMARY KEY (id),
    UNIQUE KEY uk_refresh_tokens_token (token),
    KEY idx_refresh_tokens_user (user_id),
    CONSTRAINT fk_refresh_tokens_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='JWT Refresh Token';
```

---

## 변경 6 — 개발 관리 문서 업데이트

| 파일 | 변경 내용 |
|------|-----------|
| `docs/plan/edu-ssafy-com-wise-goose.md` | 진행 현황 표 추가 (P0 ✅, D1 ✅, P1 ⏳), D1 검증 결과 섹션 추가 |
| `docs/requirements/05_요구사항_추적표.md` | 페이즈별 현황 + FR-AUTH 항목별 추적 (요구사항/API/구현/테스트) + P1 체크리스트 |

---

## 다음 단계

**P1 — FR-AUTH 인증/계정 구현**

참조 문서: `docs/requirements/03_기능_요구사항.md`, `docs/api/auth.md`

- Repository 테스트 (`@DataJpaTest` + Testcontainers)
- Service 단위 테스트 (`@ExtendWith(MockitoExtension.class)`)
- Controller 테스트 (`@WebMvcTest`)
- Spring Security 통합 테스트 (`@SpringBootTest`)
- 프론트엔드 AuthStore + LoginForm 테스트
