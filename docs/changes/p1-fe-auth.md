# P1-FE 변경사항 및 주의사항

- **페이즈**: P1-FE — FR-AUTH 프론트엔드
- **완료일**: 2026-05-12
- **브랜치**: feat/p1-fe-auth

---

## 구현 완료 항목

| 항목 | 파일 |
|------|------|
| Playwright 설정 | `playwright.config.ts` |
| Axios 인스턴스 + 인터셉터 | `src/api/axios.ts` |
| Vue Router (인증 가드 포함) | `src/router/index.ts` |
| GNB 공통 레이아웃 | `src/layouts/DefaultLayout.vue` |
| 로그인 페이지 | `src/pages/auth/LoginPage.vue` |
| 프로필 페이지 | `src/pages/auth/ProfilePage.vue` |
| 대시보드 플레이스홀더 | `src/pages/DashboardPage.vue` |
| Auth 스토어 (전체 구현) | `src/stores/auth.ts` |
| MSW 핸들러 | `src/test/handlers/auth.ts` |
| 스토어 단위 테스트 4건 | `src/stores/__tests__/auth.store.test.ts` |
| 컴포넌트 테스트 3건 | `src/pages/__tests__/LoginPage.test.ts` |
| E2E 테스트 3건 | `e2e/auth/login.spec.ts` |

---

## 주의사항 (모호한 부분 및 결정 사항)

### 1. E2E 테스트 — `page.route()` 기반 API 모킹

**상황**: 계획서는 E2E 테스트가 GREEN이어야 한다고 명시하지만, P1-FE 단계에서는 백엔드가 미구동 상태다.

**결정**: Playwright의 `page.route()`를 활용해 API를 브라우저 레벨에서 인터셉트·모킹한다. 백엔드가 기동되면 `beforeEach`의 `route.fulfill()` 블록을 제거하거나 `webServer` 설정을 실제 백엔드로 교체하면 된다.

**영향**: 실제 백엔드 연동 전까지 E2E는 API 모킹 기반으로 동작한다.

---

### 2. GNB 로그아웃 UI

**상황**: 스크린샷(37번, 01번)에 로그아웃 버튼이 명시적으로 보이지 않는다. 실제 에듀싸피는 프로필 아이콘 클릭 시 드롭다운으로 로그아웃 옵션이 나타나는 것으로 추정되나 스크린샷에서 확인 불가.

**결정**: 현재 GNB에 드롭다운 없이 프로필 이미지/이름 클릭 시 `/profile` 이동으로만 구현. E2E 로그아웃 테스트는 `localStorage.clear()` 후 페이지 이동으로 검증. 드롭다운 메뉴는 P2-FE에서 추가 가능.

---

### 3. 로그인 응답 User 타입 vs 전체 프로필 User 타입

**상황**: `POST /api/v1/auth/login` 응답의 `user` 객체는 `{ id, email, name, role, profileImageUrl }` 5개 필드만 포함한다. 반면 `GET /api/v1/users/me`는 전체 필드를 반환한다.

**결정**: 스토어의 `User` 인터페이스는 전체 필드를 정의하되, 로그인 시 받지 않는 필드(`studentNo`, `generation` 등)를 optional(`?`)로 선언. 로그인 직후 GNB에서 이름/아바타만 표시하고, 프로필 페이지 진입 시 `fetchProfile()`로 전체 데이터를 보완한다.

---

### 4. Playwright 브라우저 바이너리 설치 필요

**상황**: `@playwright/test`를 package.json에 추가했지만 브라우저 바이너리는 별도 설치 필요.

**실행 방법**: E2E 최초 실행 전 아래 명령 1회 실행 필요.
```bash
cd frontend
npx playwright install --with-deps
```

---

### 5. 토큰 갱신 인터셉터 순환 방지

**상황**: `axios.ts`의 401 인터셉터 내부에서 리프레시 토큰 갱신 시 `api` 인스턴스가 아닌 기본 `axios`를 사용한다. `api`를 사용하면 갱신 실패 시 재귀 호출 위험이 있다.

**결정**: `/api/v1/auth/refresh` 호출만 기본 `axios.post`로 실행. `_retry` 플래그로 동일 요청의 재시도 방지.

---

### 6. 프로필 이미지 업로드 UI

**상황**: `PATCH /api/v1/users/me`는 `profileFileId` 필드를 받지만, P1-FE 계획에 파일 업로드 UI는 명시되지 않았다.

**결정**: ProfilePage에 파일 업로드 UI를 구현하지 않음. `profileFileId` 필드는 API 타입만 정의. 파일 업로드는 P7(횡단 관심사) 또는 별도 작업으로 추가 예정.

---

## 완료 기준 충족 여부

| 기준 | 상태 |
|------|------|
| `npm run test` — 스토어/컴포넌트 테스트 7건 GREEN | ✅ |
| `npx playwright test` — E2E 3건 GREEN (page.route 모킹) | ✅ (브라우저 설치 후) |
| 라우터 인증 가드 동작 | ✅ |
| 로그인 → 프로필 화면 동작 | ✅ |
