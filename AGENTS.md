# Repository Guidelines

## 프로젝트 구조 및 모듈 구성
이 저장소는 두 개의 애플리케이션으로 구성됩니다.
- `frontend/`: Vite 기반의 Vue 3 + TypeScript 앱입니다. 주요 소스 코드는 `frontend/src/`, 공통 테스트 설정은 `frontend/src/test/`, 스토어 테스트는 `frontend/src/stores/__tests__/`에 위치합니다.
- `backend/`: Java 21 기반의 Spring Boot 서비스입니다. 애플리케이션 코드는 `backend/src/main/java/com/ssafy/edu/`, 설정 파일은 `backend/src/main/resources/`, 테스트 코드는 `backend/src/test/`에 위치합니다.

특정 기능이 프론트엔드와 백엔드를 모두 변경해야 하는 경우가 아니라면, 각 변경은 해당 모듈 범위 안에서 유지하세요.

## 빌드, 테스트, 개발 명령어
명령어는 해당 모듈 디렉터리에서 실행하세요.

### Frontend
- `npm install`: 의존성을 설치합니다.
- `npm run dev`: Vite 개발 서버를 실행합니다.
- `npm run build`: `vue-tsc`로 타입 검사를 수행한 뒤 프로덕션 빌드를 생성합니다.
- `npm run test`: Vitest를 1회 실행합니다.
- `npm run test:watch`: 테스트를 watch 모드로 실행합니다.
- `npm run lint`: `.vue`, `.ts` 파일에 대해 ESLint를 실행합니다.

### Backend
- `./gradlew bootRun`: Spring Boot 앱을 로컬에서 실행합니다.
- `./gradlew build`: 백엔드를 컴파일하고, 테스트한 뒤 패키징합니다.
- `./gradlew test`: JUnit 5 테스트를 실행하고 JaCoCo XML 커버리지 결과를 생성합니다.

## 코딩 스타일 및 네이밍 규칙
프론트엔드는 TypeScript를 사용하며, 들여쓰기는 2칸, Vue 컴포넌트는 `PascalCase`, 변수와 함수는 `camelCase`를 사용하세요. 테스트는 관련 코드와 가까운 `__tests__/` 아래에 둡니다.

백엔드는 표준 Java 관례를 따르며, 들여쓰기는 4칸, 클래스는 `PascalCase`, 메서드와 필드는 `camelCase`, 패키지명은 `com.ssafy.edu` 하위 규칙을 유지하세요.

모듈은 작고 목적이 분명하게 유지하고, 새 패턴을 도입하기 전에는 기존 네이밍과 구조를 우선 따르세요.

## 테스트 가이드라인
프론트엔드 테스트는 Vitest, Testing Library, Happy DOM, MSW를 사용합니다. 테스트 파일 이름은 `*.test.ts` 형식을 따르세요.

백엔드 테스트는 JUnit 5, Spring Boot Test, Spring Security Test, Testcontainers를 사용합니다. 테스트 패키지 구조는 `backend/src/test/java/` 아래에서 운영 코드 구조를 그대로 반영하세요.

기능 추가나 버그 수정 시 테스트를 함께 추가하거나 갱신하세요. API 경계를 넘는 변경이라면 프론트엔드와 백엔드를 모두 검증해야 합니다.

## 커밋 및 Pull Request 가이드라인
기존 히스토리에서 사용 중인 Conventional Commit 스타일(`feat:`, `fix:`, `docs:`)을 따르세요. 예: `feat: add auth token refresh flow`.

PR에는 다음 내용을 포함하세요.
- 변경 사항 요약
- 관련 이슈 또는 작업 링크(있는 경우)
- 테스트 근거 (`npm run test`, `./gradlew test`)
- 사용자에게 보이는 변경의 경우 스크린샷 또는 API 예시

PR은 빠르게 리뷰할 수 있도록 가능한 한 작게 유지하세요.

## 보안 및 설정 팁
비밀값은 커밋하지 마세요. 푸시 전에 `backend/src/main/resources/application.yml` 및 테스트 설정 파일을 다시 확인하세요. 로컬 자격 증명과 서비스 엔드포인트는 환경별 override 설정을 우선 사용하세요.
