# P1-FE — FR-AUTH 프론트엔드 구현 진행 보고

- **날짜**: 2026-05-12
- **브랜치**: `dev/omx`
- **작업 범위**: 라우터/레이아웃/로그인/프로필 화면 + AuthStore + Playwright E2E

---

## 진행 상태

현재 상태는 **자동 검증 완료, 수동 브라우저 확인 대기**이다.

| 완료 기준 | 결과 |
|------|------|
| `npx playwright test` — 로그인·로그아웃·프로필 E2E 3건 GREEN | PASS |
| 스토어 단위 테스트 4건 GREEN | PASS |
| 컴포넌트 테스트 3건 GREEN | PASS |
| `npm run build` 통과 | PASS |
| 브라우저에서 로그인 → 프로필 화면 수동 동작 확인 | PENDING |

---

## 구현 범위

### 공통 인프라

| 파일 | 역할 |
|------|------|
| `frontend/playwright.config.ts` | Playwright 설정 및 dev server 연동 |
| `frontend/src/router/index.ts` | `/login`, `/profile` 라우트와 보호 경로 가드 |
| `frontend/src/layouts/DefaultLayout.vue` | 상단 내비게이션/로그아웃 포함 공통 레이아웃 |
| `frontend/src/app/pinia.ts` | Pinia 초기화 분리 |
| `frontend/src/main.ts` | 라우터/Pinia/App 부트스트랩 |

### 인증 및 API 연동

| 파일 | 역할 |
|------|------|
| `frontend/src/stores/auth.ts` | 로그인, 로그아웃, 세션 hydrate, 토큰 갱신, 프로필 조회 |
| `frontend/src/lib/api.ts` | API 클라이언트 및 인증 헤더 처리 |
| `frontend/src/lib/auth.ts` | 로컬 스토리지 키 및 에러 메시지 매핑 |
| `frontend/src/test/handlers/auth.ts` | MSW 인증 핸들러 |

### 화면

| 파일 | 역할 |
|------|------|
| `frontend/src/pages/auth/LoginPage.vue` | 로그인 폼, 오류 메시지, 제출 상태 |
| `frontend/src/pages/auth/ProfilePage.vue` | 프로필 조회 및 사용자 정보 표시 |
| `frontend/src/App.vue` | 기본 앱 엔트리 |
| `frontend/src/styles.css` | 기본 레이아웃/페이지 스타일 |

### 테스트

| 파일 | 검증 내용 |
|------|-----------|
| `frontend/src/stores/__tests__/auth.store.test.ts` | 로그인 성공/실패, 로그아웃, 토큰 갱신 |
| `frontend/src/pages/__tests__/LoginPage.test.ts` | 제출 호출, 버튼 비활성화, 오류 메시지 렌더링 |
| `frontend/e2e/auth/login.spec.ts` | 로그인 성공 후 프로필 이동, 실패 메시지, 로그아웃 리다이렉트 |

---

## 자동 검증 결과

### 1. Vitest

실행 명령:
```bash
npm run test
```

결과:
- `src/stores/__tests__/smoke.test.ts` 1건 PASS
- `src/stores/__tests__/auth.store.test.ts` 4건 PASS
- `src/pages/__tests__/LoginPage.test.ts` 3건 PASS
- 총 8건 PASS

### 2. Build

실행 명령:
```bash
npm run build
```

결과:
- `vue-tsc --noEmit` 통과
- Vite production build 통과

### 3. Playwright E2E

실행 명령:
```bash
npm run e2e
```

결과:
- `로그인_성공_프로필_페이지_이동` PASS
- `잘못된_비밀번호_오류_메시지_표시` PASS
- `로그아웃_로그인_페이지_리다이렉트` PASS

---

## 잔여 작업

- 실제 브라우저에서 로그인 후 프로필 화면까지 수동 확인
- 이후 `P2-BE` 또는 `P2-FE`로 넘어갈 때 `docs/design/DESIGN.md`, `docs/design/edu_screnshot/` 기준 UI 정합성 점검
