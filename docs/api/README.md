# API Documentation

이 디렉터리는 `edu_ssafy_clone`의 API 계약을 관리한다.

## 산출물

| 파일 | 목적 |
|---|---|
| `openapi.yaml` | OpenAPI 3.1 기반 기계 판독 가능 API 원본 |
| `API_SPEC.md` | 요구사항별 사람이 읽기 쉬운 API 명세서 |
| `README.md` | 명세 규칙, 상태값, 검증 방법 |

## 기준 범위

첫 배포는 로그인과 API 기반 메인 대시보드를 구현한다.

- 포함: 로그인, 로그아웃 계약, 현재 사용자 조회, 대시보드 통합 조회, 출결 요약, 포인트/EXP 요약, 공지/알림 요약, 사용자별 내비게이션
- 제외: 실제 SSAFY 계정/API 연동, `edu.ssafy.com` scraping/crawling, 관리자 기능, 파일 업로드/다운로드, 실시간 알림, 전체 강의실/Quest/커뮤니티 구현

## Endpoint 상태값

| 상태 | 의미 |
|---|---|
| `first-release` | 첫 배포에서 구현하고 테스트할 API |
| `planned` | 전체 제품 로드맵에는 포함하지만 첫 배포 이후 재검토할 API |
| `deferred` | 상위 요구사항에는 있으나 첫 배포에서 명시적으로 제외된 API |

OpenAPI에서는 각 operation의 `x-status` 확장 필드로 상태를 기록한다.

## 공통 규약

- Base URL: `http://localhost:8080`
- API prefix: `/api/v1`
- 인증: JWT Bearer token
- 인증 헤더: `Authorization: Bearer <accessToken>`
- 토큰 갱신: `POST /api/v1/auth/refresh`로 planned 상태에 문서화한다. 첫 배포에서는 access token 흐름만 구현해도 된다.
- 응답 envelope:

```json
{
  "success": true,
  "data": {},
  "error": null,
  "meta": null
}
```

오류 응답:

```json
{
  "success": false,
  "data": null,
  "error": {
    "code": "AUTH_UNAUTHORIZED",
    "message": "인증이 필요합니다.",
    "details": []
  },
  "meta": null
}
```

## 요구사항 추적

상위 요구사항은 `docs/requirements/02_상위_요구사항.md`를 따른다.

| 요구사항 | API tag |
|---|---|
| FR-AUTH | Auth, Users |
| FR-DASHBOARD | Dashboard |
| FR-LECTURE | Lecture |
| FR-QUEST | Quest |
| FR-COMMUNITY | Community |
| FR-NOTICE | Notice |
| FR-EXTERNAL | External |
| FR-NAV | Navigation |

## 검증 방법

Python과 PyYAML이 있는 환경:

```sh
python - <<'PY'
from pathlib import Path
import yaml
spec = yaml.safe_load(Path('docs/api/openapi.yaml').read_text())
required = ['openapi', 'info', 'servers', 'paths', 'components']
missing = [key for key in required if key not in spec]
assert not missing, missing
print(f"OpenAPI parsed: {len(spec['paths'])} paths")
PY
```

PyYAML이 없는 환경에서는 Ruby Psych 또는 Node YAML parser로 동일하게 파싱한다.

## 명세 변경 원칙

1. `openapi.yaml`과 `API_SPEC.md`를 함께 갱신한다.
2. 신규 endpoint에는 `x-requirement-id`와 `x-status`를 기록한다.
3. first-release endpoint에는 성공/실패 응답 예시를 유지한다.
4. 실제 SSAFY 서비스 연동이나 scraping을 추가하지 않는다.
