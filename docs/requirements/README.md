# 요구사항 문서

최종 확인일: 2026-05-11

Notion/원본 요구사항을 읽기 쉬운 Markdown 문서로 재구성한 폴더입니다. 구현 전 요구사항 확인과 추적에는 이 README와 아래 문서를 사용합니다.

## 문서 목록

1. [프로젝트 개요](./01_프로젝트_개요.md)
2. [상위 요구사항](./02_상위_요구사항.md)
3. [기능 요구사항](./03_기능_요구사항.md)
4. [비기능 요구사항](./04_비기능_요구사항.md)
5. [요구사항 추적표](./05_요구사항_추적표.md)
6. [통합 문서](./에듀싸피_클론_프로젝트_통합_문서.md)

## 사용 기준

- 1차 구현 범위와 기술 설계는 [`../plans/software-design-plan.md`](../plans/software-design-plan.md)를 우선 확인합니다.
- 구현 순서와 완료 기준은 [`../plans/edu-ssafy-clone-plan.md`](../plans/edu-ssafy-clone-plan.md)를 우선 확인합니다.
- 화면/디자인 기준은 [`../../DESIGN.md`](../../DESIGN.md)와 [`../design/reference-inventory.md`](../design/reference-inventory.md)를 함께 확인합니다.
- DB 구현은 [`../database/schema.sql`](../database/schema.sql)과 [`../database/tables.md`](../database/tables.md)를 기준으로 합니다.

## 정리 기준

- CSV/원본 표는 Markdown 표와 상세 항목으로 정리했습니다.
- 요구사항 문서는 구현 계획의 입력 자료이며, 구현 과정에서 범위가 확정되면 `docs/plans/`에 반영합니다.
- 실제 SSAFY 데이터, 계정, 세션, 내부 공지, 실제 파일은 요구사항/샘플 데이터에 포함하지 않습니다.
