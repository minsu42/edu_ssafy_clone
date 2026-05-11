---
version: alpha
name: edu-ssafy
description: "edu.ssafy.com(SSAFY 교육 포털)은 흰색 캔버스 위에 SSAFY 시그니처 블루를 핵심 인터랙션 컬러로 사용하는 기관형 교육 포털이다. 다크 네이비 GNB·푸터와 흰색 본문 영역의 명도 대비로 구조적 위계를 표현하며, 한국어 중심 sans-serif(Noto Sans KR)로 정보 밀도와 가독성을 동시에 확보한다. JOB·GIT·Meeting 세 가지 컬러 코딩된 유틸리티 버튼과 페이지 상단 다크 히어로 배너가 브랜드의 시각적 특징이다."

colors:
  primary: "#0064ff"
  primary-active: "#0050cc"
  primary-disabled: "#b3d0ff"
  ink: "#1a1a1a"
  body: "#333333"
  body-strong: "#111111"
  muted: "#666666"
  muted-soft: "#999999"
  hairline: "#e0e0e0"
  hairline-soft: "#f0f0f0"
  canvas: "#ffffff"
  surface-card: "#f5f7fa"
  surface-dark: "#1b1e2e"
  on-primary: "#ffffff"
  on-dark: "#ffffff"
  on-dark-soft: "#9ca3af"
  accent-teal: "#00b4d8"
  accent-green: "#28a745"
  accent-yellow: "#ffc107"
  accent-orange: "#ff6b35"
  danger: "#dc3545"
  success: "#28a745"
  warning: "#ffc107"

typography:
  display-md:
    fontFamily: "Noto Sans KR, Malgun Gothic, Apple SD Gothic Neo, sans-serif"
    fontSize: 24px
    fontWeight: 700
    lineHeight: 1.3
    letterSpacing: -0.3px
  title-lg:
    fontFamily: "Noto Sans KR, Malgun Gothic, Apple SD Gothic Neo, sans-serif"
    fontSize: 18px
    fontWeight: 600
    lineHeight: 1.4
    letterSpacing: 0
  title-md:
    fontFamily: "Noto Sans KR, Malgun Gothic, Apple SD Gothic Neo, sans-serif"
    fontSize: 16px
    fontWeight: 600
    lineHeight: 1.4
    letterSpacing: 0
  title-sm:
    fontFamily: "Noto Sans KR, Malgun Gothic, Apple SD Gothic Neo, sans-serif"
    fontSize: 14px
    fontWeight: 600
    lineHeight: 1.4
    letterSpacing: 0
  body-md:
    fontFamily: "Noto Sans KR, Malgun Gothic, Apple SD Gothic Neo, sans-serif"
    fontSize: 14px
    fontWeight: 400
    lineHeight: 1.6
    letterSpacing: 0
  body-sm:
    fontFamily: "Noto Sans KR, Malgun Gothic, Apple SD Gothic Neo, sans-serif"
    fontSize: 13px
    fontWeight: 400
    lineHeight: 1.55
    letterSpacing: 0
  caption:
    fontFamily: "Noto Sans KR, Malgun Gothic, Apple SD Gothic Neo, sans-serif"
    fontSize: 12px
    fontWeight: 400
    lineHeight: 1.4
    letterSpacing: 0
  button:
    fontFamily: "Noto Sans KR, Malgun Gothic, Apple SD Gothic Neo, sans-serif"
    fontSize: 13px
    fontWeight: 500
    lineHeight: 1
    letterSpacing: 0
  nav-link:
    fontFamily: "Noto Sans KR, Malgun Gothic, Apple SD Gothic Neo, sans-serif"
    fontSize: 14px
    fontWeight: 500
    lineHeight: 1
    letterSpacing: 0

rounded:
  xs: 2px
  sm: 4px
  md: 6px
  lg: 8px
  xl: 12px
  pill: 9999px

spacing:
  xxs: 4px
  xs: 8px
  sm: 12px
  md: 16px
  lg: 24px
  xl: 32px
  xxl: 48px
  section: 64px

components:
  gnb:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.ink}"
    typography: "{typography.nav-link}"
    height: 60px
  gnb-dark:
    backgroundColor: "{colors.surface-dark}"
    textColor: "{colors.on-dark}"
    typography: "{typography.nav-link}"
    height: 60px
  page-hero:
    backgroundColor: "{colors.surface-dark}"
    textColor: "{colors.on-dark}"
    typography: "{typography.display-md}"
    height: 120px
  sub-nav:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.muted}"
    typography: "{typography.nav-link}"
    height: 48px
  sub-nav-active:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.primary}"
    typography: "{typography.nav-link}"
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-primary}"
    typography: "{typography.button}"
    rounded: "{rounded.sm}"
    padding: 8px 16px
    height: 36px
  button-primary-active:
    backgroundColor: "{colors.primary-active}"
    textColor: "{colors.on-primary}"
    rounded: "{rounded.sm}"
  button-secondary:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.ink}"
    typography: "{typography.button}"
    rounded: "{rounded.sm}"
    padding: 8px 16px
    height: 36px
  button-pill-dark:
    backgroundColor: "{colors.surface-dark}"
    textColor: "{colors.on-dark}"
    typography: "{typography.button}"
    rounded: "{rounded.pill}"
    padding: 6px 14px
    height: 30px
  button-pill-teal:
    backgroundColor: "{colors.accent-teal}"
    textColor: "{colors.on-dark}"
    typography: "{typography.button}"
    rounded: "{rounded.pill}"
    padding: 6px 14px
    height: 30px
  button-pill-green:
    backgroundColor: "{colors.accent-green}"
    textColor: "{colors.on-dark}"
    typography: "{typography.button}"
    rounded: "{rounded.pill}"
    padding: 6px 14px
    height: 30px
  card:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.body}"
    typography: "{typography.body-md}"
    rounded: "{rounded.lg}"
    padding: 20px
  stat-card-yellow:
    backgroundColor: "{colors.accent-yellow}"
    textColor: "{colors.ink}"
    typography: "{typography.title-md}"
    rounded: "{rounded.lg}"
    padding: 16px
  fab:
    backgroundColor: "{colors.danger}"
    textColor: "{colors.on-dark}"
    rounded: "{rounded.pill}"
    size: 52px
  badge-status:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-primary}"
    typography: "{typography.caption}"
    rounded: "{rounded.pill}"
    padding: 3px 10px
  badge-count:
    backgroundColor: "{colors.danger}"
    textColor: "{colors.on-dark}"
    typography: "{typography.caption}"
    rounded: "{rounded.pill}"
    size: 18px
  text-input:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.body}"
    typography: "{typography.body-md}"
    rounded: "{rounded.sm}"
    padding: 8px 12px
    height: 40px
  select-input:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.body}"
    typography: "{typography.body-md}"
    rounded: "{rounded.sm}"
    padding: 8px 12px
    height: 40px
  textarea:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.body}"
    typography: "{typography.body-md}"
    rounded: "{rounded.sm}"
    padding: 12px
  pagination-active:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-primary}"
    typography: "{typography.caption}"
    rounded: "{rounded.pill}"
    size: 28px
  pagination-inactive:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.body}"
    typography: "{typography.caption}"
    rounded: "{rounded.pill}"
    size: 28px
  progress-step-completed:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-primary}"
    rounded: "{rounded.pill}"
    size: 32px
  progress-step-current:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.primary}"
    rounded: "{rounded.pill}"
    size: 32px
  progress-step-pending:
    backgroundColor: "{colors.hairline}"
    textColor: "{colors.muted}"
    rounded: "{rounded.pill}"
    size: 32px
  notification-badge:
    backgroundColor: "{colors.danger}"
    textColor: "{colors.on-dark}"
    typography: "{typography.caption}"
    rounded: "{rounded.pill}"
    size: 16px
  user-avatar:
    backgroundColor: "{colors.accent-teal}"
    textColor: "{colors.on-dark}"
    typography: "{typography.caption}"
    rounded: "{rounded.pill}"
    size: 32px
  board-list-item:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.body}"
    typography: "{typography.body-md}"
    padding: 14px 0
  footer:
    backgroundColor: "{colors.surface-dark}"
    textColor: "{colors.on-dark-soft}"
    typography: "{typography.caption}"
    padding: 32px 0
---

## Overview

edu.ssafy.com은 삼성 청년 소프트웨어 아카데미(SSAFY) 교육생을 위한 학습 포털이다. 디자인의 기조는 **기관 신뢰감** + **정보 효율성**이다. 흰색 캔버스(`{colors.canvas}`)를 기본 배경으로 삼고, 다크 네이비(`{colors.surface-dark}`) GNB와 푸터가 시각적 프레임을 형성한다. 각 페이지의 상단에는 사진 배경 위에 어두운 오버레이를 얹은 히어로 배너가 일관되게 등장하며, 페이지 제목을 흰색으로 중앙 배치한다.

핵심 인터랙션 컬러는 SSAFY 시그니처 블루(`{colors.primary}` — #0064ff)로, 활성 탭 언더라인·기본 버튼·링크에 집중적으로 사용한다. GNB 우측에는 세 가지 컬러 코딩된 유틸리티 버튼(JOB SSAFY 다크, SSAFY GIT 틸, Meeting! SSAFY 그린)이 항상 존재해 프로그램별 외부 서비스 진입점을 색으로 구분한다.

타이포그래피는 Noto Sans KR을 중심으로 단일 계열을 사용한다. 헤딩은 weight 600-700, 본문은 400으로 명확히 구분하며, 별도의 디스플레이용 serif를 사용하지 않아 정보 밀도가 높은 화면에서도 시각적 노이즈를 최소화한다.

**Key Characteristics:**

- 흰색 캔버스 + 다크 네이비 GNB/푸터의 명도 대비로 페이지 구조 표현
- SSAFY 블루(`{colors.primary}` — #0064ff) 단일 인터랙션 컬러 — 활성 탭·버튼에 집중
- 페이지마다 반복되는 다크 히어로 배너 (사진 오버레이 + 흰색 제목)
- 세 가지 컬러 유틸리티 버튼(다크/틸/그린)이 GNB 우측 고정
- 한국어 sans-serif 단일 계열 타이포그래피
- 섀도 없음 — 위계는 배경색 대비와 hairline 보더로만 표현
- 붉은 원형 FAB (플로팅 액션 버튼)이 콘텐츠 영역 하단 우측 고정

## Colors

### Brand & Interactive

- **Primary** (`{colors.primary}` — #0064ff): SSAFY 시그니처 블루. 활성 탭 언더라인, 기본 버튼 배경, 페이지네이션 활성, 진행 단계 완료 표시에 사용.
- **Primary Active** (`{colors.primary-active}` — #0050cc): 버튼 호버/프레스 시 primary의 어두운 변형.
- **Primary Disabled** (`{colors.primary-disabled}` — #b3d0ff): 비활성 primary 요소.

### Surface

- **Canvas** (`{colors.canvas}` — #ffffff): 모든 페이지의 기본 배경. 순백.
- **Surface Card** (`{colors.surface-card}` — #f5f7fa): 카드·섹션 구분용 미세 회색 배경.
- **Surface Dark** (`{colors.surface-dark}` — #1b1e2e): GNB(다크 변형)·페이지 히어로 배너·푸터. 포털 전체를 감싸는 다크 프레임.

### Text

- **Ink** (`{colors.ink}` — #1a1a1a): 강조 헤딩, 제목 등 최고 위계 텍스트.
- **Body Strong** (`{colors.body-strong}` — #111111): 가장 진한 본문 강조.
- **Body** (`{colors.body}` — #333333): 기본 본문 텍스트.
- **Muted** (`{colors.muted}` — #666666): 서브 레이블, 비활성 탭 텍스트, 날짜·메타 정보.
- **Muted Soft** (`{colors.muted-soft}` — #999999): 플레이스홀더, 최하위 보조 텍스트.
- **On Primary** (`{colors.on-primary}` — #ffffff): primary 배경 위 텍스트.
- **On Dark** (`{colors.on-dark}` — #ffffff): dark surface 위 기본 텍스트.
- **On Dark Soft** (`{colors.on-dark-soft}` — #9ca3af): 푸터 본문, dark surface 위 보조 텍스트.

### Border

- **Hairline** (`{colors.hairline}` — #e0e0e0): 카드·입력 필드·목록 구분선의 1px 보더.
- **Hairline Soft** (`{colors.hairline-soft}` — #f0f0f0): 같은 영역 내 더 희미한 구분선.

### Accent & Utility

- **Accent Teal** (`{colors.accent-teal}` — #00b4d8): "SSAFY GIT" 유틸리티 버튼. 개발 도구 진입점 구분색.
- **Accent Green** (`{colors.accent-green}` — #28a745): "Meeting! SSAFY" 버튼, 제출완료·성공 상태 배지. 완료/접속 의미.
- **Accent Yellow** (`{colors.accent-yellow}` — #ffc107): 출석체크 위젯, 활성 이벤트 강조. 주의 환기·현재 상태.
- **Accent Orange** (`{colors.accent-orange}` — #ff6b35): EXP·포인트 수치 표시용 강조색.
- **Danger** (`{colors.danger}` — #dc3545): 알림 뱃지(벨), 플로팅 액션 버튼(FAB), 마감 경고.
- **Success** (`{colors.success}` — #28a745): 제출완료 배지, 출결 정상 표시 (accent-green과 동일값).
- **Warning** (`{colors.warning}` — #ffc107): 경고 상태 (accent-yellow와 동일값).

## Typography

### Font Family

**Noto Sans KR**을 기본 폰트로, Windows 환경의 **Malgun Gothic**, macOS의 **Apple SD Gothic Neo**가 폴백을 담당한다. serif 계열을 사용하지 않으며 코드 블록도 별도 monospace를 정의하지 않는 정보 포털 특성상 단일 sans-serif 계열로 통일된다.

이 선택이 의도하는 바: 한국어 교육 포털에서 다양한 학습 콘텐츠·통계·표·목록이 동시에 나타나는 화면에서 serif나 복수 폰트는 시각적 노이즈를 만든다. 단일 sans-serif 계열은 정보 자체가 말하게 하고, weight 차이로만 위계를 만든다.

### Hierarchy

| Token | Size | Weight | Line Height | Letter Spacing | Use |
| ----- | ---- | ------ | ----------- | -------------- | --- |
| `{typography.display-md}` | 24px | 700 | 1.3 | -0.3px | 히어로 배너 페이지 제목 |
| `{typography.title-lg}` | 18px | 600 | 1.4 | 0 | 섹션 대제목, 카드 그룹 헤딩 |
| `{typography.title-md}` | 16px | 600 | 1.4 | 0 | 카드 제목, 서브 섹션 헤딩 |
| `{typography.title-sm}` | 14px | 600 | 1.4 | 0 | 목록 항목 제목, 강조 레이블 |
| `{typography.body-md}` | 14px | 400 | 1.6 | 0 | 기본 본문, 입력 필드 텍스트 |
| `{typography.body-sm}` | 13px | 400 | 1.55 | 0 | 보조 설명, 파일 안내 |
| `{typography.caption}` | 12px | 400 | 1.4 | 0 | 날짜, 작성자, 메타 정보, 배지 |
| `{typography.button}` | 13px | 500 | 1.0 | 0 | 모든 버튼 레이블 |
| `{typography.nav-link}` | 14px | 500 | 1.0 | 0 | GNB 메뉴, sub-nav 탭 |

### Principles

weight 600 이상은 헤딩에만 쓴다. 본문 강조는 color 변경(`{colors.body-strong}`)으로 처리하고 weight를 올리지 않는다. 버튼·nav-link의 weight 500은 인터랙티브 요소임을 시각적으로 구분하는 최소 신호다.

## Layout

### Spacing System

- **Base unit:** 4px
- **주요 토큰:** `{spacing.xs}` 8px · `{spacing.sm}` 12px · `{spacing.md}` 16px · `{spacing.lg}` 24px · `{spacing.xl}` 32px · `{spacing.section}` 64px
- **카드 내부 패딩:** `{spacing.xl}` (32px) 대형 카드, `{spacing.md}` (16px) 컴팩트 카드
- **목록 항목 상하 패딩:** 14px (board-list-item)
- **섹션 간격:** `{spacing.section}` (64px)

### Grid & Container

- **최대 콘텐츠 너비:** 약 1100–1200px, 중앙 정렬
- **홈 대시보드:** 2단 레이아웃 — 좌측 요약 위젯 열 + 우측 메인 콘텐츠 영역
- **목록 페이지:** 단일 컬럼 풀 너비
- **서브 탭 콘텐츠:** 상단 sub-nav + 하단 전체 너비 콘텐츠
- **폼 페이지:** 레이블-입력 2단 그리드 (레이블 고정 너비 ~120px)

### Whitespace Philosophy

정보 밀도가 높은 교육 포털 특성상 여백을 넉넉하게 쓰지 않는다. 섹션 간 구분은 hairline 보더와 배경색 변화로 처리하며, 대규모 여백보다 일관된 소단위 간격 적용을 우선한다.

## Elevation & Depth

| Level | Treatment | Use |
| ----- | --------- | --- |
| Flat | 배경색만 | GNB, 본문 섹션, sub-nav |
| Hairline | 1px `{colors.hairline}` 보더 | 입력 필드, 목록 구분, 카드 테두리 |
| Surface Card | `{colors.surface-card}` 배경 — 섀도 없음 | 서브 영역 카드, 테이블 헤더 |
| Dark Block | `{colors.surface-dark}` 배경 — 섀도 없음 | GNB, 히어로 배너, 푸터 |

섀도를 사용하지 않는다. 위계는 전적으로 배경색 대비로 표현된다. 다크 블록(GNB/히어로/푸터)이 페이지의 프레임을 형성하고, 그 안의 흰 캔버스가 콘텐츠 공간이 된다.

## Shapes

### Border Radius Scale

| Token | Value | Use |
| ----- | ----- | --- |
| `{rounded.xs}` | 2px | 미세 태그, 진행 표시 바 |
| `{rounded.sm}` | 4px | 기본 버튼, 입력 필드, select, textarea |
| `{rounded.md}` | 6px | 중형 버튼, 작은 카드 |
| `{rounded.lg}` | 8px | 일반 카드, 대시보드 위젯 |
| `{rounded.xl}` | 12px | 대형 콘텐츠 카드 |
| `{rounded.pill}` | 9999px | 유틸리티 버튼(JOB/GIT/Meeting), 배지, FAB, 페이지네이션 |

### Hero Banner

페이지 히어로는 사진 이미지 위에 어두운 오버레이(`rgba(0,0,0,0.5)` 추정)를 적용하고, 그 위에 흰색 페이지 제목을 중앙 배치한다. 사진은 페이지마다 다르지만 처리 방식은 동일하다. 높이 약 120px.

## Components

### GNB (전역 내비게이션)

**`gnb`** — 흰 배경, 높이 60px. 좌측에 Samsung SSAFY Academy 로고(삼성 다이아몬드 마크), 중앙-좌측에 수평 메뉴(마이캠퍼스·강의실·커뮤니티·HELP DESK·멘토링 게시판), 우측 클러스터에 알림 벨 + 프로필 드롭다운 + 3개 유틸리티 버튼.

**`gnb-dark`** — 동일 구조, 다크 배경 변형(`{colors.surface-dark}`). 스크롤 또는 특정 페이지에서 사용.

### 유틸리티 버튼 (GNB 우측)

3개의 pill 버튼이 GNB 우측 고정:
- **`button-pill-dark`** — "JOB SSAFY": 다크 배경, 취업 지원 서비스 진입
- **`button-pill-teal`** — "SSAFY GIT": 틸 배경, GitLab/코드 저장소 진입
- **`button-pill-green`** — "Meeting! SSAFY": 그린 배경, 화상회의 진입

이 세 버튼이 한 화면에 동시 존재하는 것이 에듀싸피 GNB의 가장 강한 시각적 특징이다.

### 페이지 히어로 배너

**`page-hero`** — 높이 120px. 사진 배경 + 다크 오버레이. 흰색 페이지 제목(`{typography.display-md}`) 중앙 배치. 모든 서브 페이지(강의실, 커뮤니티, HELP DESK 등)에 일관 적용.

### Sub-navigation 탭

**`sub-nav`** / **`sub-nav-active`** — 히어로 배너 바로 하단 고정 탭 행. 배경 흰색, 높이 48px. 비활성: `{colors.muted}` 텍스트, 보더 없음. 활성: `{colors.primary}` 텍스트 + 하단 primary 컬러 2px 언더라인.

### 버튼

**`button-primary`** — 블루 배경, 흰 텍스트. 학습 진입, 제출, 등록 등 핵심 액션. `{rounded.sm}` (4px), 패딩 8px×16px, 높이 36px.

**`button-secondary`** — 흰 배경, `{colors.hairline}` 1px 보더, 다크 텍스트. 취소, 보조 액션.

### FAB (플로팅 액션 버튼)

**`fab`** — 붉은 원형 버튼(`{colors.danger}`), 높이·너비 52px. 화면 우측 하단 고정. 대부분의 콘텐츠 페이지에 등장하며 빠른 글쓰기 또는 문의 작성 등의 주요 액션 트리거.

### 배지

**`badge-status`** — 블루 pill. "제출완료" 등 긍정적 상태 표시. `{typography.caption}`, 패딩 3px×10px.

**`badge-count`** — 레드 원형. 알림 수, 미확인 항목 카운트. 크기 18px.

### 입력 필드

**`text-input`** — 흰 배경, `{colors.hairline}` 1px 보더, `{rounded.sm}`. 높이 40px. 플레이스홀더 색 `{colors.muted-soft}`.

**`select-input`** — text-input과 동일 스타일, 우측 드롭다운 화살표 추가.

**`textarea`** — text-input과 동일 스타일, 자유 높이. 리치 텍스트 에디터가 붙는 경우 상단에 툴바 행 추가.

### 진행 단계 (Progress Steps)

**`progress-step-completed`** — 블루 원형 32px, 흰 체크/번호. 완료 단계.

**`progress-step-current`** — 흰 배경 + 블루 테두리 원형. 현재 단계.

**`progress-step-pending`** — 회색(`{colors.hairline}`) 배경 원형. 미완료 단계.

단계 간 연결선은 hairline 색.

### 목록 아이템 (게시판)

**`board-list-item`** — 흰 배경, 하단 hairline 구분선, 패딩 14px 0. 좌측 사용자 아바타(`{component.user-avatar}`) + 제목(`{typography.title-sm}`) + 우측 날짜·통계(`{typography.caption}`, `{colors.muted}`).

**`list-item-avatar`** — 녹색(`{colors.accent-green}`) 원형 36px. 사용자 이니셜 또는 아이콘.

### 페이지네이션

**`pagination-active`** — 블루 원형 28px, 흰 숫자. 현재 페이지.

**`pagination-inactive`** — 흰 원형 28px, 다크 텍스트. 이전/다음 페이지.

### 대시보드 위젯

**`stat-card-yellow`** — 노란 배경(`{colors.accent-yellow}`), 다크 텍스트. 출석체크·현재 이벤트 강조 위젯. `{rounded.lg}`.

**`card`** — 흰 배경, hairline 보더, `{rounded.lg}`. 커리큘럼·퀘스트·학습 통계 등 일반 콘텐츠 카드.

### 푸터

**`footer`** — 다크 배경(`{colors.surface-dark}`), 소프트 텍스트(`{colors.on-dark-soft}`). "이용약관 | 개인정보처리방침" 링크 + 저작권 문구. 패딩 32px.

## Do's and Don'ts

### Do

- 모든 인터랙티브 상태(활성 탭·버튼·링크)에 `{colors.primary}` 블루를 집중 사용한다.
- 페이지 최상단에 히어로 배너를 배치해 페이지 전환 맥락을 명확히 한다.
- GNB 우측 3개 유틸리티 버튼(다크/틸/그린)을 색 구분 그대로 유지한다. 이 색 조합이 에듀싸피임을 구분하는 브랜드 지문이다.
- 섀도 없이 배경색 대비와 hairline 보더만으로 위계를 표현한다.
- 폰트는 Noto Sans KR 단일 계열만 사용하며 weight로만 위계를 만든다.
- FAB는 항상 붉은 원형(`{colors.danger}`)으로, 화면 우측 하단에 고정한다.

### Don't

- 블루 이외의 색을 인터랙션 기본 컬러로 사용하지 않는다. 악센트 색(틸·그린·노란)은 각자 지정된 용도(유틸리티 버튼·상태 배지·위젯)에만 쓴다.
- serif 폰트나 복수 폰트 계열을 도입하지 않는다.
- 카드·컴포넌트에 그림자를 추가하지 않는다.
- 히어로 배너를 없애거나 다른 스타일(단색 배경 등)로 대체하지 않는다.
- 유틸리티 버튼의 색 조합을 바꾸지 않는다(JOB=다크, GIT=틸, Meeting=그린은 고정).
- 알림 배지와 FAB 외에 `{colors.danger}`를 긍정적 액션에 사용하지 않는다.

## Responsive Behavior

### Breakpoints (추정)

| Name | Width | Key Changes |
| ---- | ----- | ----------- |
| Mobile | < 768px | GNB 햄버거 메뉴, 유틸리티 버튼 축소/숨김, 단일 컬럼 레이아웃 |
| Tablet | 768–1024px | GNB 수평 유지, 2단 대시보드 → 1단 |
| Desktop | > 1024px | 전체 레이아웃, GNB 완전 전개 |

스크린샷은 데스크톱 기준이므로 모바일 대응은 추정값이다.

### Touch Targets

- `{component.button-primary}` 최소 36×36px (패딩 포함)
- `{component.fab}` 52×52px
- `{component.pagination-active/inactive}` 28×28px

## Iteration Guide

1. 컴포넌트 하나에 집중한다. `{component.sub-nav}`, `{component.board-list-item}` 등 YAML 키를 참조한다.
2. 모든 컴포넌트 속성에 raw hex 대신 `{colors.primary}` 형태의 토큰 참조를 사용한다.
3. 새 컬러 추가 없이 기존 토큰으로 해결한다. 비슷한 색이 필요하면 기존 accent 색을 재활용한다.
4. 히어로 배너 + sub-nav 구조는 강의실·커뮤니티·HELP DESK·멘토링 모든 섹션에 동일하게 적용한다.
5. 새 배지가 필요하면 `{component.badge-status}`(블루)와 `{component.badge-count}`(레드) 두 가지 패턴만 사용한다.

## Known Gaps

- **정확한 GNB 배경색 변형 조건**: GNB가 흰색/다크로 전환되는 조건(스크롤 임계값 등)이 스크린샷만으로는 불분명하다.
- **다크 히어로 배너 오버레이 정확 수치**: CSS `rgba` 값 미확인.
- **폰트 실제 로드 방식**: Google Fonts CDN 사용 여부, 서브셋 범위 미확인.
- **정확한 primary 블루 수치**: #0064ff는 시각 추정값. 실제 SSAFY 브랜드 가이드라인 확인 필요.
- **호버·포커스 상태**: 스크린샷 특성상 정적 상태만 포착됨.
- **다크모드**: 지원 여부 미확인. 모든 화면이 라이트모드 기준.
- **출결 상태 색 체계**: 출석(블루)/지각(노란?)/결석(레드) 정확한 구분 색 미확정.
- **애니메이션/전환 효과**: 탭 전환, 드롭다운 등의 트랜지션 타이밍 미확인.
