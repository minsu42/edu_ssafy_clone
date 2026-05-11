# 2026-05-11 변경사항 정리

## 목적

Git push 전 현재 working tree의 변경사항을 한 곳에서 검토할 수 있도록 정리한다.

## 이번 작업의 핵심 산출물

이번 세션에서 `$ralplan` → `$ralph` 흐름으로 전체 API 명세서를 작성했다.

### 생성된 API 문서

| 파일 | 설명 |
|---|---|
| `docs/api/openapi.yaml` | OpenAPI 3.1 기반 전체 API 계약 원본 |
| `docs/api/API_SPEC.md` | 상위 요구사항별 사람이 읽기 쉬운 API 명세 |
| `docs/api/README.md` | API 문서 구조, 상태값, 공통 규약, 검증 방법 |

### API 명세 범위

- `FR-AUTH`: 로그인, 로그아웃, 현재 사용자, 프로필/비밀번호/탈퇴 planned API
- `FR-DASHBOARD`: 대시보드 통합 조회, 출결 요약, 포인트/EXP 요약
- `FR-NOTICE`: 공지 목록, 내 알림 목록, 알림 읽음 planned API
- `FR-LECTURE`: 과정/주차/강의 세션/학습 콘텐츠 planned API
- `FR-QUEST`: Quest 목록/상세/제출/결과 planned API
- `FR-COMMUNITY`: 게시판/게시글 planned API, 작성/댓글 deferred API
- `FR-EXTERNAL`: 외부 링크 메타데이터 planned API
- `FR-NAV`: 사용자별 내비게이션, app bootstrap planned API

### 구현 상태 구분

| 상태 | 의미 |
|---|---|
| `first-release` | 첫 배포 구현 및 테스트 대상 |
| `planned` | 전체 로드맵에는 포함하지만 후속 구현 전 재검토 대상 |
| `deferred` | 상위 요구사항은 있으나 첫 배포에서 명시적으로 제외 |

## 검증 결과

아래 검증은 `docs/api/openapi.yaml`을 대상으로 수행했다.

```text
OpenAPI parsed: 30 paths
Requirement coverage: FR-AUTH, FR-COMMUNITY, FR-DASHBOARD, FR-EXTERNAL, FR-LECTURE, FR-NAV, FR-NOTICE, FR-QUEST
First-release endpoints: 9
First-release success examples: PASS
Statuses: deferred, first-release, planned
OpenAPI 3.1 nullability: PASS
```

추가 검증:

- Architect review: `APPROVED`
- Ralph completion audit: `completion_audit_passed`
- Deslop pass: 변경 파일 한정 수행, 추가 수정 불필요

## 관련 OMX 산출물

| 파일 | 설명 |
|---|---|
| `.omx/plans/ralplan-full-api-spec.md` | API 명세 작성 계획 및 ADR |
| `.omx/context/full-api-spec-20260511T061549Z.md` | API 명세 작업 컨텍스트 스냅샷 |
| `.omx/logs/ralph-api-spec-completion-audit.md` | Ralph 완료 감사 기록 |

> `.omx/` 산출물은 로컬 작업 추적용이다. 커밋 포함 여부는 팀의 저장소 운영 규칙에 맞춰 결정한다.

## 현재 working tree의 기타 변경사항

이번 API 문서 생성 외에도 working tree에는 다음 종류의 변경이 함께 존재한다.

### 수정된 기존 문서

- `DESIGN.md`
- `docs/plans/edu-ssafy-clone-plan.md`
- `docs/plans/software-design-plan.md`

### 삭제로 표시된 기존 원본/정리 전 문서

- `docs/에듀싸피 클론 프로젝트 ...` 계열 원본 Markdown/CSV 파일들
- `docs/정리된_문서/...` 계열 정리 전 Markdown 문서들

### 신규/미추적 주요 항목

- `AGENTS.md`
- `.AGENTS.md.bkup`
- `.gitignore`
- `.codex/`
- `docs/README.md`
- `docs/api/`
- `docs/database/`
- `docs/design/`
- `docs/requirements/`
- `docs/changes/`

### Git 운영 전략 추가

- `AGENTS.md`에 GitHub Flow 기반 운영 전략을 추가했다.
- 핵심 원칙:
  - `main`은 항상 배포 가능한 단일 장기 브랜치로 유지한다.
  - 일반 작업은 `main`에 직접 커밋하지 않고 short-lived branch에서 진행한다.
  - PR은 작고 검증 가능한 단위로 만든다.
  - 커밋 메시지는 기존 Lore Commit Protocol을 따른다.
- 추가된 내용:
  - 브랜치 네이밍: `feature/`, `fix/`, `docs/`, `refactor/`, `chore/`
  - PR flow
  - sync/history hygiene
  - atomic commit 전략
  - 문서/API, 기능 구현, 버그 수정용 커밋 메시지 예시

### AGENTS.md 한국어화

- `AGENTS.md`의 주요 운영 지침을 한국어로 번역했다.
- OMX 런타임 마커, XML 태그, 명령어, 모델명, 코드 블록은 유지했다.
- 검증한 보존 항목:
  - `<!-- AUTONOMY DIRECTIVE — DO NOT REMOVE -->`
  - `<!-- OMX:GUIDANCE:OPERATING:START --> ... <!-- OMX:GUIDANCE:OPERATING:END -->`
  - `<!-- OMX:GUIDANCE:SPECIALIST-ROUTING:START --> ... <!-- OMX:GUIDANCE:SPECIALIST-ROUTING:END -->`
  - `<!-- OMX:MODELS:START --> ... <!-- OMX:MODELS:END -->`
  - 주요 XML 계약 태그

## Push 전 제안

1. **커밋을 나누는 것을 권장**
   - Commit 1: 프로젝트/OMX 설정 파일 (`AGENTS.md`, `.codex/`, `.gitignore` 등)
   - Commit 2: GitHub Flow 및 커밋 규칙 정리 (`AGENTS.md`, `docs/changes/`)
   - Commit 3: 기존 문서 정리 및 구조화 (`docs/requirements/`, `docs/database/`, `docs/design/`, `DESIGN.md`, `docs/plans/`)
   - Commit 4: API 명세 추가 (`docs/api/`, `docs/changes/`)

2. **삭제 파일 검토 필요**
   - 현재 다수의 기존 원본/정리 전 문서가 삭제 상태다.
   - 의도한 문서 구조 개편이면 그대로 커밋해도 되지만, 실수 삭제가 아닌지 push 전 확인하는 것이 좋다.

3. **API 명세 커밋 메시지 초안**

```text
Document API contract to guide first deployment implementation

Constraint: First release is limited to demo login and API-backed dashboard without real SSAFY integration or scraping.
Rejected: Markdown-only API docs | would not support OpenAPI validation or tooling.
Confidence: high
Scope-risk: narrow
Directive: Keep openapi.yaml and API_SPEC.md synchronized when API contracts change.
Tested: Parsed OpenAPI YAML; verified 30 paths, 8 FR requirement coverage, 9 first-release endpoints, response examples, status values, and OpenAPI 3.1 nullability.
Not-tested: No backend/frontend implementation tests exist yet for these contracts.
```

## 현재 변경사항 검토 명령

```sh
git status --short
git diff --stat
python3 - <<'PY'
from pathlib import Path
import yaml
text = Path('docs/api/openapi.yaml').read_text()
spec = yaml.safe_load(text)
print(spec['openapi'], len(spec['paths']))
PY
```
