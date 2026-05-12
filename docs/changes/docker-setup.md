# Docker 로컬 실행 환경 구성

- **날짜**: 2026-05-12
- **브랜치**: `main`

---

## 목적

Java 21 미설치 환경에서도 `docker compose up --build` 한 명령으로 mysql / backend / frontend를 로컬에서 실행할 수 있도록 Docker 환경을 구성한다.

---

## 변경 파일 목록

| 파일 | 작업 | 설명 |
|------|------|------|
| `docker-compose.yml` | 신규 | mysql · backend · frontend 3개 서비스 오케스트레이션 |
| `backend/Dockerfile` | 신규 | eclipse-temurin:21-jdk multi-stage 빌드 → JRE 런타임 |
| `frontend/Dockerfile` | 신규 | node:24-alpine Vite dev 서버 |
| `backend/src/main/resources/application.yml` | 수정 | DB 접속 정보를 env var로 변경 (`${DB_HOST:localhost}` 등) |
| `frontend/vite.config.ts` | 수정 | `host: '0.0.0.0'` 추가, proxy target env var 처리 |
| `CLAUDE.md` | 수정 | Frontend UI Rules 섹션 추가 (스크린샷·DESIGN.md 참조 의무) |

---

## 주요 결정 사항

### 포트 매핑

| 서비스 | 호스트 포트 | 컨테이너 포트 |
|--------|-------------|---------------|
| mysql | 3307 | 3306 |
| backend | 8080 | 8080 |
| frontend | 5173 | 5173 |

> MySQL 호스트 포트를 3307로 설정 — 로컬에 MySQL 8이 이미 3306을 점유하고 있어 충돌 방지.

### 기동 순서 보장

mysql healthcheck(`mysqladmin ping`) 통과 후 backend가 기동되도록 `depends_on.condition: service_healthy` 설정.

### 로컬 개발 기본값 유지

`application.yml`의 env var는 기본값을 포함하므로 (`${DB_HOST:localhost}`) Docker 없이 직접 실행할 때도 동작한다.

### 테스트는 호스트에서 실행

Testcontainers는 호스트 Docker 소켓을 직접 사용하므로 컨테이너 내부에서 `./gradlew test` 실행은 지원하지 않는다. 테스트는 호스트 환경에서 별도로 실행한다.

---

## 실행 방법

```bash
docker compose up --build
```

- 프론트엔드: http://localhost:5173
- 백엔드 Swagger: http://localhost:8080/swagger-ui.html

데이터 초기화:
```bash
docker compose down -v
```
