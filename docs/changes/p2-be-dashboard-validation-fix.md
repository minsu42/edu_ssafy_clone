# P2-BE — Dashboard 검증 오류 수정 보고

- **날짜**: 2026-05-12
- **브랜치**: `dev/omx`
- **작업 범위**: Dashboard 컨트롤러 요청 파라미터 검증 실패 시 500 응답 문제 수정

---

## 문제 요약

백엔드 전체 테스트 재검증 과정에서 `DashboardControllerTest`의 아래 2개 테스트가 실패했다.

| 테스트 | 기대 | 실제 |
|------|------|------|
| `getAttendance_월_범위오류_400_반환()` | 400 | 500 |
| `getPoints_size_범위오류_400_반환()` | 400 | 500 |

---

## 원인 분석

- `DashboardController`에 클래스 레벨 `@Validated`가 선언되어 있었다.
- 이 설정 때문에 `@RequestParam`의 `@Min`, `@Max` 검증이 예상한 Spring MVC 요청 파라미터 검증 흐름과 다르게 method validation 예외 흐름으로 처리되었다.
- 해당 예외가 테스트 기대값인 `ERR-CMN-003` / `400 Bad Request`로 안정적으로 변환되지 못하면서 `500 Internal Server Error`가 반환되었다.

즉, 문제는 비즈니스 로직이 아니라 **컨트롤러 검증 진입점과 전역 예외 처리 연결**에 있었다.

---

## 수정 내용

### 1. DashboardController 정리

파일:
- `backend/src/main/java/com/ssafy/edu/domain/dashboard/controller/DashboardController.java`

변경:
- 클래스 레벨 `@Validated` 제거

효과:
- `@RequestParam` 제약조건 검증이 Spring MVC의 기본 핸들러 검증 흐름으로 처리되도록 정리

### 2. 전역 예외 처리 보강

파일:
- `backend/src/main/java/com/ssafy/edu/global/exception/GlobalExceptionHandler.java`

변경:
- `MethodValidationException` 처리 추가
- method validation 계열 예외 메시지 추출 공통 메서드 추가

효과:
- method validation 예외가 발생해도 일관되게 `ERR-CMN-003`과 `400 Bad Request`로 응답

---

## 검증 결과

### 타깃 테스트

실행 명령:
```bash
sg docker -c './gradlew test --tests com.ssafy.edu.domain.dashboard.controller.DashboardControllerTest --no-daemon'
```

결과:
- `DashboardControllerTest` 7건 PASS

### 전체 백엔드 테스트

실행 명령:
```bash
sg docker -c './gradlew test --no-daemon'
```

결과:
- 총 63건 PASS

---

## 영향 범위

- Dashboard API의 잘못된 쿼리 파라미터 입력 시 응답 코드가 500에서 400으로 정상화되었다.
- 전역 예외 처리기가 method validation 계열 예외에도 일관된 에러 응답을 제공하게 되었다.
- 기존 서비스/레포지토리/보안 통합 테스트에는 회귀가 없음을 전체 테스트로 확인했다.
