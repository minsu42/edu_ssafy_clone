# edu-ssafy-clone

edu.ssafy.com(에듀싸피) 클론 코딩 프로젝트.

멀티 에이전트 기반 하네스 프롬프팅 구조의 코드 생성 품질 검증이 실제 목적이며, TDD 방식으로 도메인 단위 구현을 진행한다.

---

## 기술 스택

| Layer | Tech |
|-------|------|
| Backend | Spring Boot 4.0.6 (Java 21), Gradle, Spring Data JPA, MySQL 8.x |
| Frontend | Vue 3, Vite, TypeScript, Pinia, Vue Router |
| 인증 | JWT (Access 15분 + Refresh 7일) |
| 테스트 (BE) | JUnit 5, Mockito, Testcontainers, MockMvc, JaCoCo |
| 테스트 (FE) | Vitest, Vue Test Utils, MSW v2, Playwright |
| API 문서 | Swagger (springdoc-openapi 3) |

---

## 구현 현황

| 페이즈 | 내용 | 상태 |
|--------|------|------|
| P0 | 프로젝트 부트스트랩 (뼈대, 테스트 환경) | ✅ 완료 |
| D1 | FR-AUTH 요구사항 보완 + API 명세 | ✅ 완료 |
| P1-BE | FR-AUTH 백엔드 (JWT 인증, 44건 테스트, 커버리지 93%) | ✅ 완료 |
| P1-FE | FR-AUTH 프론트엔드 (로그인·프로필·GNB, E2E 포함) | ✅ 완료 |
| D2 | FR-DASHBOARD 문서화 | ⏳ 다음 단계 |
| P2 ~ P7 | 대시보드·강의실·Quest·커뮤니티·공지·통합 | ⬜ 미시작 |

---

## 로컬 실행 가이드

### 사전 요구사항

- Java 21
- Node.js 20+
- MySQL 8.x (또는 Docker)
- Docker (백엔드 테스트용 Testcontainers 실행에 필요)

### MySQL 설정

애플리케이션 실행 전 MySQL에 데이터베이스와 스키마를 생성한다.

```sql
CREATE DATABASE edu_ssafy CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

이후 `docs/database/schema.sql`을 실행해 전체 테이블을 생성한다.

```bash
mysql -u root -p edu_ssafy < docs/database/schema.sql
```

`backend/src/main/resources/application.yml`의 접속 정보를 환경에 맞게 수정한다.

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/edu_ssafy?useSSL=false&allowPublicKeyRetrieval=true&characterEncoding=UTF-8
    username: root
    password: your_password
```

### 백엔드 실행

```bash
cd backend
./gradlew bootRun
```

서버 기동 후 Swagger UI: http://localhost:8080/swagger-ui.html

### 프론트엔드 실행

```bash
cd frontend
npm install
npm run dev
```

개발 서버: http://localhost:5173

---

## 테스트 실행

### 백엔드 단위·통합 테스트

Docker가 실행 중이어야 한다 (Testcontainers가 MySQL 컨테이너를 자동 기동).

```bash
cd backend
./gradlew test
```

테스트 완료 후 JaCoCo 커버리지 리포트: `backend/build/reports/jacoco/test/html/index.html`

### 프론트엔드 단위 테스트 (Vitest + MSW)

```bash
cd frontend
npm run test
```

### E2E 테스트 (Playwright)

최초 1회 브라우저 바이너리 설치 필요:

```bash
cd frontend
npx playwright install --with-deps
```

E2E 실행:

```bash
npm run e2e
```

> E2E는 현재 `page.route()` 기반 API 모킹으로 동작한다. 백엔드 서버 없이도 실행 가능하다.

---

## 프로젝트 구조

```
edu_ssafy_clone/
├── backend/                          # Spring Boot 애플리케이션
│   └── src/
│       ├── main/java/com/ssafy/edu/
│       │   ├── global/               # 공통 (보안, 예외, 응답, JWT)
│       │   └── domain/               # 도메인별 패키지 (auth, dashboard, ...)
│       └── test/                     # JUnit / MockMvc / Testcontainers
├── frontend/                         # Vue 3 SPA
│   ├── e2e/                          # Playwright E2E 테스트
│   └── src/
│       ├── api/                      # Axios 인스턴스 + 인터셉터
│       ├── layouts/                  # GNB 공통 레이아웃
│       ├── pages/                    # 페이지 컴포넌트
│       ├── router/                   # Vue Router (인증 가드)
│       ├── stores/                   # Pinia 스토어
│       └── test/                     # MSW 핸들러, 테스트 설정
└── docs/
    ├── api/                          # 도메인별 API 명세
    ├── database/                     # schema.sql, table.md
    ├── design/edu_screnshot/         # UI 스크린샷 40장
    ├── plan/                         # 개발 계획서, 진행관리
    └── requirements/                 # 기능·비기능 요구사항, 추적표
```

---

## 개발 원칙

백엔드는 **Inside-Out TDD** (Repository → Service → Controller), 프론트엔드는 **Outside-In 더블 루프** (E2E RED → 스토어/컴포넌트 GREEN → E2E GREEN)를 따른다. 각 도메인은 문서화(Dx) 완료 후 구현(Px-BE → Px-FE) 순서로 진행한다.

자세한 계획·원칙은 [`docs/plan/edu-ssafy-com-wise-goose.md`](docs/plan/edu-ssafy-com-wise-goose.md), 진행 현황은 [`docs/plan/progress.md`](docs/plan/progress.md)를 참조한다.
