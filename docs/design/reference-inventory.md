# Visual Reference Inventory

최종 확인일: 2026-05-11

## Purpose

이 문서는 `edu.ssafy.com` 클론의 화면 유사도를 검증하기 위한 시각 참조 목록과 안전 기준을 정의한다. 현재 저장소에는 `docs/design/screenshots/` 아래에 40개의 PNG 참조 이미지가 있다.

## Safety boundary

- 실제 서비스에 대한 자동 로그인, 스크래핑, 크롤링, 대량 요청을 하지 않는다.
- 실제 SSAFY 개인정보, 내부 공지, 실제 파일, 세션/쿠키/토큰 값을 저장소에 포함하지 않는다.
- 스크린샷에 민감 정보가 포함될 수 있으면 먼저 제거/마스킹한 뒤 저장한다.
- 실제 SSAFY 로고/저작권 이미지는 구현 코드에 그대로 포함하지 않는다.
- 구현 시에는 placeholder, 재현 가능한 더미 에셋, 더미 한국어 콘텐츠를 사용한다.

## Current reference set

현재 승인된 참조 파일은 다음과 같다.

| No. | File | Screen/area |
|---:|---|---|
| 01 | `01_home_dashboard.png` | 홈 대시보드 |
| 02 | `02_classroom_weekly_curriculum.png` | 클래스룸 주차별 커리큘럼 |
| 03 | `03_quest_evaluation_list.png` | Quest/평가 목록 |
| 04 | `04_learning_resources.png` | 학습자료 |
| 05 | `05_community_survey.png` | 커뮤니티 설문 |
| 06 | `06_open_board.png` | 열린 게시판 |
| 07 | `07_helpdesk_notice.png` | Help Desk 공지 |
| 08 | `08_helpdesk_faq_empty.png` | Help Desk FAQ 빈 상태 |
| 09 | `09_helpdesk_inquiry_empty.png` | Help Desk 문의 빈 상태 |
| 10 | `10_helpdesk_inquiry_form.png` | Help Desk 문의 작성 폼 |
| 11 | `11_mentoring_story_board.png` | 멘토링 스토리 게시판 |
| 12 | `12_classroom_curriculum_week_toggle_attempt.png` | 클래스룸 주차 토글 |
| 13 | `13_classroom_my_lecture_replay.png` | 내 강의 다시보기 |
| 14 | `14_classroom_all_lecture_replay.png` | 전체 강의 다시보기 |
| 15 | `15_classroom_required_learning_empty.png` | 필수 학습 빈 상태 |
| 16 | `16_community_anonymous_board.png` | 익명 게시판 |
| 17 | `17_community_class_roster.png` | 반 명단 |
| 18 | `18_helpdesk_academic_rules.png` | 학사 규정 |
| 19 | `19_mentoring_qna_board.png` | 멘토링 Q&A 게시판 |
| 20 | `20_mentoring_notice_board.png` | 멘토링 공지 게시판 |
| 21 | `21_mentoring_meetup_apply.png` | 밋업 신청 |
| 22 | `22_mentoring_meetup_info_empty.png` | 밋업 정보 빈 상태 |
| 23 | `23_mentoring_meetup_review_board.png` | 밋업 후기 게시판 |
| 24 | `24_mentoring_meetup_review_write_form.png` | 밋업 후기 작성 폼 |
| 25 | `25_mycampus_level_points_dashboard.png` | My Campus 레벨/포인트 대시보드 |
| 26 | `26_mycampus_attendance_status.png` | My Campus 출석 현황 |
| 27 | `27_mycampus_learning_elearning_empty.png` | My Campus e-learning 빈 상태 |
| 28 | `28_mycampus_bookmarks_empty.png` | My Campus 북마크 빈 상태 |
| 29 | `29_mycampus_document_submission_empty.png` | 서류 제출 빈 상태 |
| 30 | `30_mycampus_document_submission_write_form.png` | 서류 제출 작성 폼 |
| 31 | `31_mycampus_student_pledge_list.png` | 교육생 서약서 목록 |
| 32 | `32_mycampus_education_status.png` | 교육 현황 |
| 33 | `33_helpdesk_notice_detail.png` | Help Desk 공지 상세 |
| 34 | `34_helpdesk_academic_rules_expanded_attendance.png` | 출석 규정 확장 상태 |
| 35 | `35_community_open_board_write_form.png` | 열린 게시판 작성 폼 |
| 36 | `36_notification_inbox.png` | 알림함 |
| 37 | `37_profile_click_no_dropdown_notification_page.png` | 프로필 클릭/알림 페이지 |
| 38 | `38_classroom_quest_detail_completed.png` | 완료된 Quest 상세 |
| 39 | `39_mycampus_ebook_403_forbidden.png` | e-book 403 상태 |
| 40 | `40_attendance_detail_from_home_more.png` | 홈 더보기에서 진입한 출석 상세 |

## First-release visual priorities

첫 구현에서는 전체 40개 화면을 모두 구현하지 않고, 다음 순서로 참고한다.

1. `01_home_dashboard.png` — 메인 대시보드 최우선
2. `25_mycampus_level_points_dashboard.png`, `26_mycampus_attendance_status.png` — 포인트/레벨/출석 카드 참고
3. `02_classroom_weekly_curriculum.png`, `03_quest_evaluation_list.png`, `04_learning_resources.png` — 대시보드 요약 영역 참고
4. `36_notification_inbox.png`, `07_helpdesk_notice.png` — 공지/알림 목록 스타일 참고
5. 나머지 화면 — 2차 이후 하위 페이지 확장 시 참고

## Redaction checklist

새 참조 이미지를 추가하기 전 다음 항목을 제거하거나 더미 값으로 대체한다.

- 실명, 이메일, 교육생 번호, 전화번호, 프로필 사진, 식별 가능한 반/기수 정보
- 실제 공지, 과제, 커리큘럼, 파일명, 내부 URL, 메시지
- 브라우저 주소창의 세션 파라미터 또는 비공개 경로
- 쿠키, 토큰, 개발자도구, 패스워드 매니저, 알림 팝업
- 타 교육생/강사/운영자의 개인정보

## Fallback order for implementation

시각 자료가 부족하거나 민감 정보 문제로 사용할 수 없는 경우 다음 순서로 구현 기준을 삼는다.

1. `docs/design/screenshots/`의 승인된 참조 이미지
2. `DESIGN.md`의 디자인 토큰과 레이아웃 규칙
3. `docs/plans/software-design-plan.md`
4. `docs/plans/edu-ssafy-clone-plan.md`
5. 재현 가능한 placeholder 자산과 더미 한국어 콘텐츠
