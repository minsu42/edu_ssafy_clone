---
version: alpha
name: SSAFY Edu Portal
description: 삼성 청년 SW·AI 아카데미 교육 포털의 화이트 기반 카드형 대시보드 디자인 시스템. 선명한 SSAFY 블루와 옐로우를 강조색으로 쓰고 직각형 카드, 얇은 라인, 상단 탭 중심 내비게이션을 사용한다.
colors:
  primary: "#3396F4"
  primary-accessible: "#0067B8"
  primary-dark: "#3271A8"
  primary-link: "#3C90E2"
  navy: "#1F3448"
  navy-deep: "#20282D"
  accent-yellow: "#FFE651"
  accent-yellow-strong: "#FFD923"
  accent-green: "#3FCE32"
  success-green: "#0B7F0B"
  accent-purple: "#9767FF"
  accent-pink: "#F23FA0"
  alert-red: "#EC2C54"
  text-primary: "#24282B"
  text-strong: "#1F2328"
  text-secondary: "#4F5A66"
  text-muted: "#6E7C8C"
  text-light: "#9DA1A4"
  border: "#CED0D2"
  border-light: "#DCE3EA"
  bg-page: "#FFFFFF"
  bg-soft: "#F9F9F9"
  bg-panel: "#FCFCFC"
  bg-blue-soft: "#D8ECFF"
  bg-card-subtle: "#F3F8FC"
  bg-nav-muted: "#E9EEF1"
  bg-disabled: "#F4F7FA"
  quick-red: "#F04438"
  pass-blue: "#3396F4"
  fail-red: "#EC2C54"
  completed: "#8FA0B2"
typography:
  body:
    fontFamily: Noto Sans, Roboto, Malgun Gothic, dotum, Helvetica Neue, Arial, sans-serif
    fontSize: 16px
    fontWeight: 300
    lineHeight: 1.5
  nav:
    fontFamily: Noto Sans, Roboto, Malgun Gothic, dotum, Helvetica Neue, Arial, sans-serif
    fontSize: 16px
    fontWeight: 300
    lineHeight: 1.4
  page-title:
    fontFamily: Noto Sans, Roboto, Malgun Gothic, dotum, Helvetica Neue, Arial, sans-serif
    fontSize: 30px
    fontWeight: 400
    lineHeight: 1.35
  section-title:
    fontFamily: Noto Sans, Roboto, Malgun Gothic, dotum, Helvetica Neue, Arial, sans-serif
    fontSize: 24px
    fontWeight: 500
    lineHeight: 1.4
  card-title:
    fontFamily: Noto Sans, Roboto, Malgun Gothic, dotum, Helvetica Neue, Arial, sans-serif
    fontSize: 22px
    fontWeight: 300
    lineHeight: 1.4
  body-sm:
    fontFamily: Noto Sans, Roboto, Malgun Gothic, dotum, Helvetica Neue, Arial, sans-serif
    fontSize: 14px
    fontWeight: 300
    lineHeight: 1.5
  list-title:
    fontFamily: Noto Sans, Roboto, Malgun Gothic, dotum, Helvetica Neue, Arial, sans-serif
    fontSize: 20px
    fontWeight: 500
    lineHeight: 1.45
  meta:
    fontFamily: Noto Sans, Roboto, Malgun Gothic, dotum, Helvetica Neue, Arial, sans-serif
    fontSize: 12px
    fontWeight: 300
    lineHeight: 1.4
  number-lg:
    fontFamily: Roboto, Noto Sans, Arial, sans-serif
    fontSize: 32px
    fontWeight: 400
    lineHeight: 1.3
  display-number:
    fontFamily: Roboto, Noto Sans, Arial, sans-serif
    fontSize: 38px
    fontWeight: 300
    lineHeight: 1.2
rounded:
  none: 0px
  xs: 2px
  sm: 3px
  md: 4px
  pill: 40px
  circle: 999px
spacing:
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 40px
  xxl: 60px
  section: 100px
  container-x: 40px
  list-gap: 20px
components:
  button-outline-blue:
    backgroundColor: "#FFFFFF"
    textColor: "{colors.primary-link}"
    rounded: "{rounded.none}"
    padding: 8px
  button-outline-green:
    backgroundColor: "#FFFFFF"
    textColor: "{colors.success-green}"
    rounded: "{rounded.none}"
    padding: 8px
  button-primary:
    backgroundColor: "{colors.primary-accessible}"
    textColor: "#FFFFFF"
    rounded: "{rounded.none}"
    padding: 16px
  header:
    backgroundColor: "#FFFFFF"
    textColor: "{colors.text-primary}"
    height: 102px
    padding: 20px
  hero:
    backgroundColor: "rgba(31,52,72,0.48)"
    textColor: "#FFFFFF"
    height: 152px
    padding: 40px
  tab-active:
    backgroundColor: "{colors.primary}"
    textColor: "#FFFFFF"
    height: 56px
    padding: 16px
  tab-inactive:
    backgroundColor: "{colors.navy}"
    textColor: "#D8E1EA"
    height: 56px
    padding: 16px
  local-tab-active:
    backgroundColor: "#FFFFFF"
    textColor: "{colors.text-primary}"
    height: 48px
    padding: 12px
  card-default:
    backgroundColor: "#FFFFFF"
    textColor: "{colors.text-primary}"
    rounded: "{rounded.none}"
    padding: 24px
  dashboard-attendance:
    backgroundColor: "{colors.accent-yellow}"
    textColor: "{colors.text-primary}"
    rounded: "{rounded.none}"
    padding: 40px
  dashboard-status:
    backgroundColor: "{colors.primary}"
    textColor: "#FFFFFF"
    rounded: "{rounded.none}"
    padding: 32px
  status-scheduled:
    backgroundColor: "#FFFFFF"
    textColor: "{colors.primary}"
    rounded: "{rounded.circle}"
    size: 78px
  status-completed:
    backgroundColor: "{colors.completed}"
    textColor: "#FFFFFF"
    rounded: "{rounded.circle}"
    size: 78px
  badge-category:
    backgroundColor: "{colors.primary}"
    textColor: "#FFFFFF"
    rounded: "{rounded.pill}"
    height: 26px
    padding: 8px
  list-card:
    backgroundColor: "#FFFFFF"
    textColor: "{colors.text-primary}"
    rounded: "{rounded.none}"
    padding: 28px
  schedule-card:
    backgroundColor: "{colors.bg-card-subtle}"
    textColor: "{colors.text-primary}"
    rounded: "{rounded.md}"
    padding: 24px
  search-field:
    backgroundColor: "#FFFFFF"
    textColor: "{colors.text-secondary}"
    rounded: "{rounded.none}"
    height: 44px
  pagination-active:
    backgroundColor: "{colors.primary}"
    textColor: "#FFFFFF"
    rounded: "{rounded.none}"
    size: 36px
  floating-quick:
    backgroundColor: "{colors.quick-red}"
    textColor: "#FFFFFF"
    rounded: "{rounded.circle}"
    size: 48px
  footer:
    backgroundColor: "{colors.navy-deep}"
    textColor: "{colors.text-light}"
    padding: 40px
---

## Overview

SSAFY Edu Portal은 기업 교육 플랫폼에 가까운 정보 중심 UI다. `docs/design/screenshots/`의 참조 화면은 대부분 1326px 폭 캡처이며, 실제 본문은 좌우 40px 여백을 둔 약 1200~1240px 중앙 컨테이너로 보인다. 전체 화면은 흰색 배경과 중앙 컨테이너를 기본으로 하며, 주요 정보는 카드·타임라인·리스트로 묶는다. 디자인 키워드는 `clean dashboard`, `flat card`, `institutional education`, `high-contrast blue accents`, `minimal radius`다.

핵심 방향:

- 기본 배경은 흰색으로 유지하고, 정보 그룹은 얇은 회색 라인과 넓은 여백으로 구분한다.
- SSAFY 블루는 활성 메뉴, 링크, 날짜, 주요 수치, 진행 상태에 반복 사용한다.
- 출석·포인트처럼 즉시 확인해야 하는 정보에는 강한 옐로우를 사용한다.
- 카드는 대부분 직각형이며 큰 라운드를 쓰지 않는다.
- 상단 글로벌 내비게이션 + 히어로 배너 + 가로형 2차 탭이 주요 페이지 구조다.
- 홈 대시보드는 히어로 없이 요약 카드부터 시작하고, 하위 페이지는 히어로 이미지 위 어두운 오버레이와 중앙 제목을 사용한다.
- 게시판, 설문, Quest/평가, 학습자료는 테이블보다 큰 행 카드 또는 가로 리스트를 선호한다.
- 대부분의 참조 화면 우측 중단에는 붉은 원형 빠른 액션 버튼이 고정되어 있다.

## Colors

- **Primary Blue (`#3396F4`)**: 메인 브랜드/상태 색상. 스크린샷 기준 활성 탭, 대시보드 상태 카드, 날짜, 링크, 현재 위치, 페이지네이션 활성 상태에 사용한다.
- **Primary Dark (`#3271A8`)**: SSAFY GIT 바로가기처럼 블루 블록의 어두운 변형에 사용한다.
- **Primary Link (`#3C90E2`)**: 작은 outline 버튼, 링크 텍스트, 흰 배경 위의 파란 텍스트에 사용한다. 접근성 대비가 필요한 작은 텍스트에는 `primary-accessible`을 대체 사용한다.
- **Navy (`#1F3448`)**: 히어로 하단 2차 탭의 비활성 배경. 흰색/연회색 텍스트와 함께 사용한다.
- **Navy Deep (`#20282D`)**: 푸터 배경. 콘텐츠와 페이지 끝을 명확히 분리한다.
- **Accent Yellow (`#FFE651`)**: 메인 대시보드 출석 카드 배경과 파란 카드 안의 포인트 숫자 강조에 사용한다.
- **Accent Green (`#3FCE32`)**: Meeting SSAFY 바로가기와 일부 일정 액션/카테고리 색상에 사용한다.
- **Purple/Pink (`#9767FF`, `#F23FA0`)**: 강의실 일정 카테고리(코딩과정, 프로젝트) 및 범례용 보조 색상이다.
- **Completed (`#8FA0B2`)**: 완료 상태 원형 배지, 비활성/완료 상태를 차분하게 표현한다.
- **Text Primary (`#24282B`)**: 기본 본문 및 메뉴 텍스트.
- **Text Secondary/Muted (`#4F5A66`, `#6E7C8C`)**: 메타 정보, 날짜 보조 텍스트, 테이블 설명에 사용한다.
- **Border (`#CED0D2`, `#DCE3EA`)**: 카드, 테이블, 셀렉트, 리스트 구분선.
- **Soft Background (`#F9F9F9`, `#FCFCFC`, `#F3F8FC`, `#D8ECFF`)**: 테이블 헤더, 일정 카드, 빈 상태, 내부 패널에 사용한다.
- **Quick Red (`#F04438`)**: 하위 페이지 우측의 원형 빠른 액션 버튼에 사용한다.
- **Alert Red (`#EC2C54`)**: 알림 배지와 FAIL 배지에 사용한다.

블루와 옐로우는 채도가 높으므로 동시에 넓게 쓰지 않는다. 큰 영역 하나만 강한 색으로 만들고, 주변은 흰색·회색으로 절제한다.

## Typography

기본 폰트는 `Noto Sans`, `Roboto`, `맑은 고딕`, `dotum`, `Helvetica Neue`, `Arial`, `sans-serif` 계열이다. 한국어 UI에 맞는 고딕체이며, 전체적으로 가볍고 평면적인 인상을 준다.

- **Body**: 16px, weight 300~400. SSAFY 포털 대부분의 기본 텍스트는 얇은 굵기지만 목록 제목과 메뉴는 400 이상으로 읽힌다.
- **Navigation**: 16px, weight 300. 헤더 메뉴는 과하게 굵지 않고 간결하다.
- **Section Title**: 24px, weight 500. `주차별 커리큘럼`, `Quest/평가`, `학습자료` 같은 섹션 제목에 사용한다.
- **Card Title**: 22px, weight 300~500. 대시보드 카드 제목 및 출석 카드 제목에 사용한다.
- **List Title**: 20~22px, weight 500. Quest/평가, 설문, 학습자료 목록 제목에 사용한다.
- **Meta**: 12~14px, weight 300. 날짜, 조회수, 설명, 테이블 부가 정보에 사용한다.
- **Numbers**: Roboto 우선. 날짜 `05. 10`은 32px/400, 포인트·EXP 같은 핵심 수치는 32~38px로 크게 표현한다.

텍스트 위계는 굵기보다 색상, 크기, 위치로 만든다. 제목도 지나치게 굵게 만들지 말고 500 전후로 유지한다.

## Layout

### Global Structure

공통 페이지 구조는 다음 순서를 따른다.

1. 흰색 글로벌 헤더
2. 메뉴별 히어로 배너 또는 메인 대시보드 요약 영역
3. 진한 네이비 배경의 2차 가로 탭
4. 1200px 내외 중앙 정렬 본문
5. 다크 차콜 푸터

### Container

- 기본 컨테이너 폭: 1200px 내외. 1326px 캡처 기준 좌우 40px 여백과 1246px 내외 본문 폭으로 보인다.
- 본문 좌우 여백: 40px 내외.
- 하위 페이지 히어로 다음 첫 콘텐츠까지 여백: 60~70px.
- 큰 섹션 간격: 80~100px.
- 카드 내부 여백: 20~40px.
- 메인 대시보드는 2컬럼, 3컬럼, 카드 리스트를 혼합한다.

### Header

- 높이: 약 102px.
- 배경: 흰색.
- 좌측: SSAFY 로고.
- 중앙: `마이캠퍼스`, `강의실`, `커뮤니티`, `HELP DESK`, `멘토링 게시판`.
- 우측: 알림, 사용자 정보, `JOB SSAFY`, `SSAFY GIT`, `Meeting! SSAFY` 컬러 블록.
- 활성 상위 메뉴는 블루 텍스트로 표시한다.
- 외부 바로가기 블록은 헤더 높이를 꽉 채우는 직사각형이며 폭은 약 94~96px다.

### Hero + Secondary Tabs

마이캠퍼스, 강의실, 커뮤니티 페이지는 배경 이미지가 있는 히어로 영역 중앙에 흰색 페이지 제목을 배치하고, 바로 아래에 네이비 2차 탭을 붙인다.

- 히어로 높이: 약 152px.
- 배경 이미지는 페이지별로 다르지만 반드시 어두운 오버레이를 씌워 제목 대비를 확보한다. 실제 사이트 이미지를 그대로 커밋하지 않는다.
- 제목: 28~32px, white, center aligned.
- 탭 높이: 약 58px.
- 활성 탭: Primary Blue 배경 + white 텍스트.
- 비활성 탭: Dark Navy 배경 + light gray 텍스트.
- 탭은 동일 너비로 분할하고 세로 구분선을 둔다.

### Main Dashboard Layout

메인 홈은 다음 블록으로 구성한다.

- 상단: 출석 카드 약 32% + 장학포인트/알림 블루 카드 약 68%. 카드 높이는 약 250px.
- 중단: 하나의 큰 흰색 컨테이너 안에서 주차별 커리큘럼 약 2/3 + Quest/평가 약 1/3. Quest 영역은 옅은 회색 배경으로 분리한다.
- 하단: 학습자료 캐러셀 + 학습중 이러닝 빈 상태.
- 커뮤니티 요약: SSAFYcial + 자유게시판 2컬럼 리스트.
- 우측 하단: `e-book` 플로팅 버튼. 하위 페이지 우측 중단에는 붉은 원형 빠른 액션 버튼을 둔다.

### Tables and Lists

- 테이블은 세로선보다 가로 구분선을 중심으로 한다.
- 테이블 헤더는 연한 회색 배경, 본문 행은 흰색 배경.
- 게시판/설문/Quest 목록은 1px 라인 카드형 행을 사용한다.
- 학습자료 목록은 좌측 썸네일(약 320x180) + 우측 제목/메타/통계 구조를 사용한다.
- 긴 텍스트는 말줄임 처리한다.

## Elevation & Depth

SSAFY Edu Portal은 대체로 flat UI다. 그림자는 선택적으로만 사용한다.

- 대부분 카드: shadow 없음, 1px gray border.
- 큰 대시보드 컨테이너: `rgba(0,0,0,0.22) 14px 6px 48px -5px` 수준의 넓고 흐린 그림자를 사용할 수 있다.
- 빈 상태 카드: `rgba(0,0,0,0.12) 0 5px 25px 0` 수준의 부드러운 그림자를 사용할 수 있다.
- 그림자는 레이어를 과하게 만들기보다 큰 섹션을 배경에서 살짝 띄우는 용도로만 사용한다.

## Shapes

- 기본 카드와 버튼은 `0px` radius에 가깝다.
- 작은 보조 버튼은 0~2px radius.
- 셀렉트/입력 요소는 사각형에 가까운 형태.
- 상태 배지는 원형 또는 캡슐형이다.
- 알림 숫자는 작은 원형 배지.
- 학습 카테고리 배지는 `40px` 이상 pill radius를 사용한다.
- 학기 진행 상태, 설문 예정/완료 상태는 78~120px 원형 배지를 사용한다.

큰 라운드 카드나 현대적 SaaS풍 16~24px radius는 피한다.

## Components

### Header Navigation

흰 배경의 102px 헤더. 메뉴는 가운데 정렬된 텍스트 링크이며, 활성 메뉴는 블루 컬러로 표시한다. 오른쪽 바로가기 3개는 헤더 높이를 채우는 블록이다.

- `JOB SSAFY`: `#E9EEF1` 배경, 어두운 텍스트.
- `SSAFY GIT`: `#3271A8` 계열 배경, 흰 텍스트.
- `Meeting! SSAFY`: `#3FCE32` 배경, 흰 텍스트.
- 알림 배지: `#EC2C54` 배경, white 텍스트, 원형.

### Dashboard Attendance Card

출석 카드는 강한 옐로우 배경의 직각형 카드다.

- 배경: `#FFE651`.
- 제목: 22px, dark text.
- 날짜: Roboto 32px, Primary Blue.
- 요일: 22px, Primary Blue.
- 안내 박스: white background, blue text, 직각형.

### Dashboard Status Card

장학포인트/레벨/알림 카드는 Primary Blue 배경의 넓은 카드다.

- 배경: `#3396F4`.
- 텍스트: white.
- 포인트/레벨 강조: yellow.
- 내부 구분선: white alpha 또는 옅은 blue.
- 알림 리스트의 `필독` 라벨은 yellow로 강조한다.

### Section Card

주차별 커리큘럼, Quest/평가 같은 큰 섹션은 흰색 배경, 1px `#CED0D2` border, 넓은 padding을 사용한다. 필요 시 넓고 흐린 그림자로 본문에서 분리한다.

### Secondary Tab Navigation

히어로 하단의 탭은 페이지별 하위 메뉴다.

- Active: Primary Blue background + white text.
- Inactive: Dark Navy background + light gray text.
- Equal width columns.
- 1px translucent vertical divider.

마이캠퍼스 탭 예: `레벨&장학포인트`, `출석현황`, `학습중 이러닝`, `찜한 목록`, `SSAFY e-book`, `서류제출`, `교육생 서약서`, `교육현황`.

강의실 탭 예: `내강의 다시보기`, `전체강의 다시보기`, `주차별 커리큘럼`, `Quest/평가`, `필수학습`, `학습자료`.

커뮤니티 탭 예: `설문조사`, `열린 게시판`, `익명 게시판`, `우리반 보기`.

### Semester Timeline

강의실의 학기 진행 상태는 가로 타임라인 원형 노드로 표현한다.

- 진행중: Primary Blue filled circle + white text/icon.
- 예정: white background + Primary Blue border + blue text/icon.
- 노드 사이: Primary Blue 1px line.
- 원 크기: 약 120px.

### View Toggle

주간/월간 전환은 segmented control로 만든다.

- 활성: Primary Blue 배경, white 텍스트.
- 비활성: white 배경, gray text, light gray border.
- 버튼 높이: 약 48px.
- 동일 너비 버튼이 붙어 있는 형태.

### Week Slider

주차 선택 슬라이더는 가로 리스트와 양쪽 원형 이동 버튼으로 구성한다.

- 활성 주차: Primary Blue text + 2px underline + 상단 날짜 범위.
- 비활성 주차: light gray text.
- 슬라이더 상하단: light gray divider.
- 이전/다음: 연한 회색 원형 icon button.

### Schedule Timeline Card

강의실 일정은 세로 타임라인으로 표시한다.

- 좌측: 날짜 Primary Blue, 시간 muted gray.
- 중앙: light gray vertical line + blue marker.
- 우측: light blue-gray schedule card.
- 카드 내부: category dot/label, 트랙명, 강의명, 강사/강의실, 액션 버튼.
- `코딩과정`: purple.
- `프로젝트`: pink.
- `알고리즘`: green.
- `기타`: sky/blue.

### Outline Action Buttons

작은 액션 버튼은 outline 중심이다.

- 공통: white background, 1px border, 32~36px height, 12~14px text, 직각.
- `교재`: blue border/text.
- `강의 다시보기`: green border/text.
- hover 시 배경만 아주 옅게 채운다.

### Survey/List Card

커뮤니티 설문조사는 카드형 리스트다.

- 카드: white background, 1px `#DCE3EA` border, 130~140px height, 넉넉한 padding.
- 구조: 상태 배지 / 제목+기간 / 유형 / 상태 정보.
- 예정: white circle + blue border + blue text.
- 완료: `#8FA0B2` filled circle + white text.
- 제목: 18~20px, text strong.
- 기간/메타: 13px, muted gray.

### Quest/Evaluation List Card

Quest/평가 목록은 높이 120~140px의 넓은 행 카드 반복 구조다.

- 카드: white background, 1px `#DCE3EA` border, 직각형.
- 좌측: `평가` 또는 `Quest` 유형 텍스트 + 상태 원형 배지.
- 예정: white circle + Primary Blue border + blue text.
- 완료: `#8FA0B2` filled circle + white text.
- 중앙: 제목, 일정, 획득 가능 경험치.
- 우측: 시험기간 또는 채점/제출 상태, 점수, PASS/FAIL pill.
- PASS: blue pill, FAIL: alert red pill.

### Learning Resource List

학습자료 페이지는 카드 그리드보다 세로 리스트를 사용한다.

- 행 높이: 썸네일 포함 약 180~210px.
- 좌측 썸네일: 약 320px x 180px, 원본 이미지는 쓰지 않고 더미 교육 콘텐츠 이미지로 대체한다.
- 우측: 20~22px 제목, 카테고리 breadcrumb, 설명, 조회/좋아요/찜 메타.
- `교재` 배지는 red outline pill로 작게 붙인다.
- 행 사이에는 `#DCE3EA` 가로 구분선을 둔다.

### Search and Filter Bar

학습자료/FAQ/문의 화면은 단순한 중앙 검색바와 우측 필터를 사용한다.

- 검색 input 높이: 약 44px, 폭 460px 내외.
- 검색 버튼: Primary Blue 또는 disabled gray 배경, 직각형, 폭 90px 내외.
- 셀렉트: white background, 1px light gray border, 34~36px height.
- 로컬 카테고리 탭은 흰 배경 텍스트 탭이며 활성 탭 아래에 Primary Blue 2px underline을 둔다.

### Pagination

페이지네이션은 목록 하단 중앙에 배치한다.

- 버튼 크기: 약 36px square.
- 활성 페이지: Primary Blue background + white text.
- 비활성: white background + light gray border + dark gray text.
- 이동 불가: very light gray text/border.

### Forms and Filters

필터 셀렉트는 과한 커스텀보다 기본 폼에 가까운 단순 스타일이다.

- 배경: white.
- 테두리: light gray.
- 높이: 34px 내외.
- 텍스트: gray.
- 우측 chevron icon.

### Table

마이캠퍼스 경험치/장학포인트 테이블은 가로선 중심이다.

- Header: very light gray background, gray text, 18px 내외 vertical padding.
- Body: white rows, light gray bottom border.
- Value column: blue text, 우측 정렬.
- Category: blue pill badge, white text, 26px height.

### Empty State

학습중 이러닝처럼 데이터가 없을 때는 흰 카드 중앙에 연한 회색 아이콘과 텍스트를 둔다.

- 카드: white, soft shadow.
- 아이콘/텍스트: light gray.
- 문구: `학습중 이러닝이 없습니다` 같은 단문.

### Footer

푸터는 어두운 차콜 배경으로 페이지를 마무리한다.

- 배경: `#20282D`.
- 텍스트: muted gray.
- 링크: gray, 개인정보처리방침 등 중요 링크는 blue.
- 높이: 약 160px.

### Floating e-book Button

메인 대시보드 우측 하단에는 고정형 `e-book` 버튼을 둔다.

- 배경: Primary Blue.
- 텍스트/아이콘: white.
- 형태: 직사각형 탭, 작은 삼각형 장식 가능.
- 페이지 스크롤 중에도 빠른 접근 가능한 액션으로 유지한다.

### Floating Quick Action Button

대부분의 하위 페이지 우측 중단에는 붉은 원형 빠른 액션 버튼이 떠 있다.

- 위치: viewport right에서 약 70~90px, 콘텐츠 중단 높이.
- 크기: 48px 내외 원형.
- 배경: `#F04438`, icon white.
- 그림자: `rgba(0,0,0,0.18) 0 4px 12px`.
- 홈 대시보드의 e-book 버튼과 동시에 과하게 강조하지 않는다.

## Do's and Don'ts

### Do

- 흰색 배경과 얇은 회색 라인을 기본으로 삼는다.
- 활성 상태, 날짜, 현재 위치, 링크는 Primary Blue로 일관되게 표시한다.
- 출석/포인트처럼 주목도가 필요한 영역만 Yellow로 강하게 강조한다.
- 카드와 버튼은 대부분 직각으로 유지한다.
- 상위 메뉴는 헤더, 하위 메뉴는 네이비 가로 탭으로 분리한다.
- 일정/설문/과제 상태는 원형 배지로 빠르게 인지되게 한다.
- 게시판, 설문, Quest/평가 목록은 넓은 여백의 행 카드형 리스트로 표현한다.
- 수치와 날짜에는 Roboto 계열을 우선 적용한다.

### Don't

- 큰 border-radius, glassmorphism, gradient-heavy SaaS 스타일을 적용하지 않는다.
- 불필요하게 많은 그림자를 쓰지 않는다.
- 블루, 옐로우, 그린을 한 영역에서 모두 강하게 쓰지 않는다.
- 페이지 내비게이션을 좌측 사이드바 중심으로 재구성하지 않는다. 이 포털은 상단 탭 중심이다.
- 테이블이나 목록에 두꺼운 세로선을 넣지 않는다.
- 완료/비활성 상태에 Primary Blue를 과하게 사용하지 않는다. 회청색과 연회색으로 낮춘다.
- 텍스트 굵기를 과도하게 올리지 않는다. 실제 UI는 weight 300~500 중심이다.
