# docs

`edu.ssafy.com` 클론 프로젝트의 설계/요구사항/참조 문서 모음입니다.

최종 확인일: 2026-05-11

## 현재 구조

```text
docs/
├── README.md                         # 문서 인덱스
├── database/
│   ├── schema.sql                    # MySQL 8.x 기준 DB 스키마
│   └── tables.md                     # 테이블/엔티티 설명
├── design/
│   ├── reference-inventory.md        # 시각 참조 수집/보관 기준
│   └── screenshots/                  # 승인된 디자인 참조 이미지
│       ├── README.md
│       └── 01_...40_*.png
├── plans/
│   ├── software-design-plan.md       # Vue + Spring Boot 설계 계획
│   └── edu-ssafy-clone-plan.md       # 구현 진행 계획
└── requirements/
    ├── README.md                     # 요구사항 문서 인덱스
    ├── 01_프로젝트_개요.md
    ├── 02_상위_요구사항.md
    ├── 03_기능_요구사항.md
    ├── 04_비기능_요구사항.md
    ├── 05_요구사항_추적표.md
    └── 에듀싸피_클론_프로젝트_통합_문서.md
```

## 주요 문서

- [`../AGENTS.md`](../AGENTS.md): 저장소 작업 규칙과 구현 지침
- [`../DESIGN.md`](../DESIGN.md): 디자인 시스템과 UI 토큰 기준
- [`plans/software-design-plan.md`](./plans/software-design-plan.md): Vue + Spring Boot 풀스택 설계 계획
- [`plans/edu-ssafy-clone-plan.md`](./plans/edu-ssafy-clone-plan.md): 클론 코딩 전체 진행 계획
- [`database/schema.sql`](./database/schema.sql): MySQL 8.x 기준 DB 스키마
- [`database/tables.md`](./database/tables.md): 테이블/엔티티 설명
- [`design/reference-inventory.md`](./design/reference-inventory.md): 시각 참조 수집 및 안전 기준
- [`design/screenshots/README.md`](./design/screenshots/README.md): 스크린샷 보관 규칙과 현재 파일 목록
- [`requirements/README.md`](./requirements/README.md): 요구사항 문서 목록

## OMX 작업 산출물과의 관계

`.omx/`는 oh-my-codex v2의 실행 상태와 작업 계획을 저장한다. 일반 문서로 공유해야 하는 계획은 `docs/plans/`에 둔다.

현재 참고할 만한 OMX 계획 문서:

- [`../.omx/plans/first-deployment.md`](../.omx/plans/first-deployment.md)
- [`../.omx/plans/first-deployment-verification.md`](../.omx/plans/first-deployment-verification.md)
- [`../.omx/plans/edu-ssafy-clone-requirements.md`](../.omx/plans/edu-ssafy-clone-requirements.md)
