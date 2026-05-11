# table

# 최종 테이블 목록

```
users
files

attendance_records
attendance_appeals
education_calendar_days
point_transactions
user_stats
user_bookmarks
user_content_interactions

boards
board_categories
board_posts
board_comments

courses
course_weeks
course_sessions
learning_categories
learning_contents
user_learning_progresses
course_tasks
user_task_results
user_activity_records

survey_categories
surveys
survey_questions
survey_participants

inquiries
notifications

agreements
user_agreements
password_change_histories

audit_logs
```

> 설명: 서비스 사용자인 교육생, 관리자, 운영자, 멘토의 기본 계정 정보를 관리한다.
# User

| 필드명 | 타입 | 설명 |
| --- | --- | --- |
| id | Long | 유저 식별자 |
| email | String | 로그인 ID로 사용하는 이메일 |
| password | String | 암호화된 비밀번호 |
| name | String | 유저 이름 |
| studentNo | String | 학번 |
| generation | Integer | SSAFY 기수 |
| region | String | 소속 지역 |
| classNo | Integer | 소속 반 번호 |
| profileFile | FileResource | 프로필 이미지 파일 |
| phoneNumber | String | 휴대폰 번호 |
| emergencyPhoneNumber | String | 긴급연락처 |
| zipCode | String | 우편번호 |
| address | String | 기본 주소 |
| addressDetail | String | 상세 주소 |
| role | UserRole | 유저 권한 |
| status | UserStatus | 계정 상태 |
| createdAt | LocalDateTime | 생성일 |
| updatedAt | LocalDateTime | 수정일 |

> 설명: 게시글, 설문, 문의, 학습 콘텐츠 등에 연결되는 공통 파일 정보를 관리한다.
# FileResource

| 필드명 | 타입 | 설명 |
| --- | --- | --- |
| id | Long | 파일 식별자 |
| originalName | String | 원본 파일명 |
| storedName | String | 서버에 저장된 파일명 |
| fileUrl | String | 파일 접근 URL |
| fileType | String | MIME 타입 또는 확장자 |
| fileSize | Long | 파일 크기 |
| uploadedBy | User | 업로드한 유저 |
| targetType | FileTargetType | 파일 연결 대상 타입 |
| targetId | Long | 파일 연결 대상 ID |
| fileRole | FileRole | 파일 역할 |
| sortOrder | Integer | 파일 노출 순서 |
| createdAt | LocalDateTime | 업로드일 |


> 설명: 출결 집계 기준이 되는 교육일, 휴일, 행사일 같은 교육 달력을 관리한다.
# EducationCalendarDay

| 필드명 | 타입 | 설명 |
| --- | --- | --- |
| id | Long | 교육일/휴일 달력 식별자 |
| course | Course | 대상 과정 |
| calendarDate | LocalDate | 기준 날짜 |
| dayType | EducationDayType | 교육일, 휴일, 방학, 행사일 구분 |
| isEducationDay | Boolean | 출결 집계에 포함되는 교육일 여부 |
| title | String | 공가, 휴일, 행사명 등 표시명 |
| description | String | 상세 설명 |
| createdAt | LocalDateTime | 생성일 |
| updatedAt | LocalDateTime | 수정일 |

> 설명: 교육생의 일자별 입실, 퇴실, 지각, 결석 등 출결 기록을 관리한다.
# AttendanceRecord

| 필드명 | 타입 | 설명 |
| --- | --- | --- |
| id | Long | 출석 기록 식별자 |
| user | User | 출석 대상 유저 |
| course | Course | 출석이 속한 과정 |
| calendarDay | EducationCalendarDay | 출석 기준 교육일 |
| attendanceDate | LocalDate | 출석 기준일 |
| checkInAt | LocalDateTime | 입실/출석 체크 시간 |
| checkOutAt | LocalDateTime | 퇴실 체크 시간 |
| status | AttendanceStatus | 정상, 지각, 결석, 조퇴 등 대표 출석 상태 |
| issueTypes | List | 해당 일자에 발생한 지각, 조퇴, 외출, 결석 등 출결 이슈 목록 |
| reasonStatus | AttendanceReasonStatus | 사유 승인, 임의 처리, 소명 대기 등 사유 처리 상태 |
| reasonText | String | 출결 사유 또는 메모 |
| checkInType | String | QR, WEB, ADMIN 등 출석 체크 방식 |
| checkOutType | String | QR, WEB, ADMIN 등 퇴실 체크 방식 |
| note | String | 운영자 메모 또는 예외 사유 |
| createdAt | LocalDateTime | 생성일 |
| updatedAt | LocalDateTime | 수정일 |

> 설명: 교육생이 제출한 출결 소명과 관리자의 승인/반려 결과를 관리한다.
# AttendanceAppeal

| 필드명 | 타입 | 설명 |
| --- | --- | --- |
| id | Long | 출결 소명 식별자 |
| attendanceRecord | AttendanceRecord | 소명 대상 출석 기록 |
| user | User | 소명 신청자 |
| appealType | AttendanceIssueType | 소명 대상 이슈 유형 |
| reason | String | 소명 사유 |
| attachmentFile | FileResource | 증빙 파일 |
| appealStatus | AttendanceAppealStatus | 신청, 승인, 반려 등 처리 상태 |
| reviewedBy | User | 검토자 |
| reviewedAt | LocalDateTime | 검토 시간 |
| reviewComment | String | 검토 의견 또는 반려 사유 |
| createdAt | LocalDateTime | 신청일 |
| updatedAt | LocalDateTime | 수정일 |

> 설명: 장학 포인트와 경험치의 적립, 차감, 조정 이력을 관리한다.
# PointTransaction

| 필드명 | 타입 | 설명 |
| --- | --- | --- |
| id | Long | 포인트/경험치 이력 식별자 |
| user | User | 대상 유저 |
| transactionType | PointTransactionType | 적립, 사용, 조정, 만료 구분 |
| pointAmount | Integer | 변동 장학 포인트 |
| expAmount | Integer | 변동 경험치 |
| reason | String | 변동 사유 |
| targetType | String | 포인트가 발생한 대상 타입 |
| targetId | Long | 포인트가 발생한 대상 ID |
| createdBy | User | 지급, 차감, 조정 처리를 수행한 관리자 |
| createdAt | LocalDateTime | 발생일 |

> 설명: 교육생별 현재 포인트, 경험치, 레벨, 출석률 같은 요약 통계를 관리한다.
# UserStat

| 필드명 | 타입 | 설명 |
| --- | --- | --- |
| id | Long | 유저 통계 식별자 |
| user | User | 대상 유저 |
| scholarshipPoint | Integer | 현재 장학 포인트 |
| totalExp | Integer | 누적 경험치 |
| levelName | String | Silver, Gold 등 현재 레벨명 |
| levelNo | Integer | 현재 레벨 번호 |
| attendanceRate | Double | 출석률 |
| completedLearningCount | Integer | 완료한 학습 콘텐츠 수 |
| updatedAt | LocalDateTime | 통계 갱신일 |

> 설명: 게시글, 학습 콘텐츠, 강의 세션 등 사용자의 통합 찜 목록을 관리한다.
# UserBookmark

| 필드명 | 타입 | 설명 |
| --- | --- | --- |
| id | Long | 통합 찜 식별자 |
| user | User | 찜한 유저 |
| targetType | BookmarkTargetType | 게시글, 학습 콘텐츠, 강의 세션 등 찜 대상 타입 |
| targetId | Long | 찜 대상 ID |
| createdAt | LocalDateTime | 생성일 |

> 설명: 이러닝 콘텐츠에 대한 재생, 좋아요, 다운로드 같은 사용자 상호작용을 관리한다.
# UserContentInteraction

| 필드명 | 타입 | 설명 |
| --- | --- | --- |
| id | Long | 유저 콘텐츠 상호작용 식별자 |
| user | User | 상호작용한 유저 |
| content | LearningContent | 대상 학습 콘텐츠 |
| interactionType | ContentInteractionType | 재생, 좋아요, 다운로드 등 상호작용 유형 |
| createdAt | LocalDateTime | 상호작용 발생 시간 |

> 설명: 공지사항, FAQ, 자유게시판, 학사규정 등 게시판의 기본 정보를 관리한다.
# Board

| 필드명 | 타입 | 설명 |
| --- | --- | --- |
| id | Long | 게시판 식별자 |
| name | String | 게시판 이름 |
| code | String | OPEN, ANONYMOUS, NOTICE, FAQ 등 게시판 코드 |
| boardType | BoardType | 게시판 타입 |
| description | String | 게시판 설명 |

> 설명: 게시판 내부 분류를 관리한다.
# BoardCategory

| 필드명 | 타입 | 설명 |
| --- | --- | --- |
| id | Long | 카테고리 식별자 |
| board | Board | 소속 게시판 |
| name | String | 카테고리명 |
| code | String | FREE, STUDY, LEARNING 등 카테고리 코드 |

> 설명: 게시판에 등록되는 실제 게시글과 조회수, 좋아요 수 등 화면 표시 정보를 관리한다.
# BoardPost

| 필드명 | 타입 | 설명 |
| --- | --- | --- |
| id | Long | 게시글 식별자 |
| category | BoardCategory | 게시글이 속한 카테고리 |
| user | User | 실제 작성자 |
| title | String | 게시글 제목 |
| contentType | ContentType | 게시글 콘텐츠 타입 |
| contentText | String | 텍스트 본문 또는 검색용 텍스트 |
| contentHtml | String | HTML 본문 |
| contentJson | Map<String, Object> | 영상, FAQ 등 구조화된 본문 데이터 |
| viewCount | Integer | 조회수 |
| likeCount | Integer | 좋아요 수 |
| commentCount | Integer | 댓글 수 |
| scrapCount | Integer | 찜 수 |
| hasAttachment | Boolean | 첨부파일 여부 |
| isNotice | Boolean | 상단 고정 여부 |
| isDeleted | Boolean | 삭제 여부 |
| createdAt | LocalDateTime | 작성일 |
| updatedAt | LocalDateTime | 수정일 |

> 설명: 게시글 댓글과 대댓글을 관리한다.
# BoardComment

| 필드명 | 타입 | 설명 |
| --- | --- | --- |
| id | Long | 댓글 식별자 |
| post | BoardPost | 댓글이 달린 게시글 |
| user | User | 댓글 작성자 |
| parent | BoardComment | 대댓글인 경우 부모 댓글 |
| content | String | 댓글 내용 |
| isDeleted | Boolean | 삭제 여부 |
| createdAt | LocalDateTime | 작성일 |
| updatedAt | LocalDateTime | 수정일 |

> 설명: SSAFY 과정, 과목, 반 단위 교육 과정을 관리한다.
# Course

| 필드명 | 타입 | 설명 |
| --- | --- | --- |
| id | Long | 과정/과목 식별자 |
| title | String | Java, 관통 PJT 등 과정 또는 과목명 |
| description | String | 과정 설명 |
| generation | Integer | SSAFY 기수 |
| region | String | 운영 지역 |
| classNo | Integer | 반 번호 |
| instructorName | String | 대표 강사명 |
| status | CourseStatus | 예정, 진행중, 종료 상태 |
| startDate | LocalDate | 과정 시작일 |
| endDate | LocalDate | 과정 종료일 |
| createdAt | LocalDateTime | 생성일 |
| updatedAt | LocalDateTime | 수정일 |

> 설명: 과정의 주차별 커리큘럼 구간을 관리한다.
# CourseWeek

| 필드명 | 타입 | 설명 |
| --- | --- | --- |
| id | Long | 주차 식별자 |
| course | Course | 소속 과정 |
| weekNo | Integer | 과정 주차 |
| title | String | 주차 제목 |
| startDate | LocalDate | 주차 시작일 |
| endDate | LocalDate | 주차 종료일 |
| sortOrder | Integer | 노출 순서 |

> 설명: 주차 안의 강의, 프로젝트, 라이브, 다시보기 같은 세션을 관리한다.
# CourseSession

| 필드명 | 타입 | 설명 |
| --- | --- | --- |
| id | Long | 강의/커리큘럼 세션 식별자 |
| course | Course | 소속 과정 |
| week | CourseWeek | 소속 주차 |
| title | String | 세션 제목 |
| subtitle | String | 세션 부제 또는 상세명 |
| sessionType | CourseSessionType | 강의, 프로젝트, 라이브, 다시보기 등 세션 유형 |
| sessionDate | LocalDate | 세션 진행일 |
| startAt | LocalDateTime | 시작 시간 |
| endAt | LocalDateTime | 종료 시간 |
| instructorName | String | 강사명 |
| location | String | 캠퍼스/강의실 정보 |
| liveUrl | String | 라이브 강의 바로가기 URL |
| replayUrl | String | 다시보기 URL |
| materialPost | BoardPost | 연결된 교재/학습자료 게시글 |
| isRequired | Boolean | 필수 학습 여부 |
| sortOrder | Integer | 노출 순서 |
| createdAt | LocalDateTime | 생성일 |
| updatedAt | LocalDateTime | 수정일 |

> 설명: 이러닝 콘텐츠의 대분류, 중분류 같은 카테고리를 관리한다.
# LearningCategory

| 필드명 | 타입 | 설명 |
| --- | --- | --- |
| id | Long | 이러닝 카테고리 식별자 |
| parent | LearningCategory | 하위 카테고리인 경우 부모 카테고리 |
| name | String | IT, 인사·총무·HRD, 알고리즘 등 카테고리명 |
| code | String | IT, HRD, ALGORITHM 등 카테고리 코드 |
| categoryType | LearningCategoryType | 대분류, 중분류 등 카테고리 단계 |
| createdAt | LocalDateTime | 생성일 |
| updatedAt | LocalDateTime | 수정일 |

> 설명: 영상, e-book, 파일, 링크 등 개별 학습 콘텐츠를 관리한다.
# LearningContent

| 필드명 | 타입 | 설명 |
| --- | --- | --- |
| id | Long | 이러닝/학습 콘텐츠 식별자 |
| course | Course | 연결 과정 |
| session | CourseSession | 연결 강의 세션 |
| category | LearningCategory | 이러닝 카테고리 |
| title | String | 콘텐츠 제목 |
| description | String | 콘텐츠 설명 |
| contentType | LearningContentType | 영상, e-book, 파일, 링크 등 콘텐츠 유형 |
| thumbnailFile | FileResource | 썸네일 파일 |
| contentUrl | String | 콘텐츠 접근 URL |
| durationSeconds | Integer | 영상 등 콘텐츠 길이 |
| viewCount | Integer | 콘텐츠 조회 또는 재생 수 |
| likeCount | Integer | 좋아요 수 |
| bookmarkCount | Integer | 찜하기 수 |
| downloadCount | Integer | 파일 또는 교재 다운로드 수 |
| isRequired | Boolean | 필수 학습 여부 |
| openAt | LocalDateTime | 공개 시간 |
| closeAt | LocalDateTime | 종료 시간 |
| createdBy | User | 등록자 |
| createdAt | LocalDateTime | 생성일 |
| updatedAt | LocalDateTime | 수정일 |

> 설명: 사용자별 학습 진행률, 마지막 재생 위치, 완료 여부를 관리한다.
# UserLearningProgress

| 필드명 | 타입 | 설명 |
| --- | --- | --- |
| id | Long | 유저 학습 진행 식별자 |
| user | User | 학습자 |
| content | LearningContent | 학습 콘텐츠 |
| progressStatus | LearningProgressStatus | 미시작, 진행중, 완료 상태 |
| progressRate | Double | 학습 진행률 |
| lastPositionSeconds | Integer | 마지막 재생 위치 |
| startedAt | LocalDateTime | 최초 학습 시작 시간 |
| completedAt | LocalDateTime | 완료 시간 |
| lastAccessedAt | LocalDateTime | 마지막 접속 시간 |

> 설명: Quest, 평가, 필수학습, 과제 같은 과정별 수행 항목을 관리한다.
# CourseTask

| 필드명 | 타입 | 설명 |
| --- | --- | --- |
| id | Long | Quest/평가/필수학습 식별자 |
| course | Course | 연결 과정 |
| session | CourseSession | 연결 세션 |
| survey | Survey | 설문형 평가인 경우 연결 설문 |
| title | String | Quest 또는 평가 제목 |
| roundNo | Integer | 회차 번호 |
| taskType | CourseTaskType | Quest, 평가, 필수학습, 과제 구분 |
| description | String | 안내 설명 |
| openAt | LocalDateTime | 시작 시간 |
| closeAt | LocalDateTime | 마감 시간 |
| totalScore | Integer | 총점 |
| isRequired | Boolean | 필수 여부 |
| sortOrder | Integer | 노출 순서 |
| createdAt | LocalDateTime | 생성일 |
| updatedAt | LocalDateTime | 수정일 |

> 설명: 사용자별 Quest, 평가, 과제 결과와 점수, 제출 상태를 관리한다.
# UserTaskResult

| 필드명 | 타입 | 설명 |
| --- | --- | --- |
| id | Long | 유저 Quest/평가 결과 식별자 |
| task | CourseTask | 대상 Quest/평가 |
| user | User | 대상 유저 |
| resultStatus | TaskResultStatus | 예정, 진행중, 제출, 완료 등 상태 |
| score | Double | 최종 취득 점수 |
| originalScore | Double | 원점수 |
| retakeScore | Double | 재평가 점수 |
| attemptCount | Integer | 응시 또는 제출 횟수 |
| answerData | Map<String, Object> | 제출 답안 또는 결과 데이터 |
| submittedAt | LocalDateTime | 제출 시간 |
| completedAt | LocalDateTime | 완료 시간 |
| updatedAt | LocalDateTime | 수정 시간 |

> 설명: 교육현황 화면에 표시할 SW 역량, SSAFY 활동, 외부 수상 기록을 관리한다.
# UserActivityRecord

| 필드명 | 타입 | 설명 |
| --- | --- | --- |
| id | Long | 유저 활동/성과 기록 식별자 |
| user | User | 대상 유저 |
| activityType | UserActivityType | SW 역량 등급, SSAFY 활동, 외부 시상 등 기록 유형 |
| title | String | 역량 평가명, 활동명 또는 시상명 |
| description | String | 상세 내용 |
| organization | String | 주관 기관, 평가 기관 또는 활동 조직 |
| activityDate | LocalDate | 활동일 또는 수상일 |
| resultText | String | SW 등급, 순위, 수상 결과 등 표시값 |
| evidenceFile | FileResource | 증빙 파일 |
| createdAt | LocalDateTime | 생성일 |
| updatedAt | LocalDateTime | 수정일 |

> 설명: 설문, 과목평가, 간담회 신청, 이벤트 신청의 기본 분류를 관리한다.
# SurveyCategory

| 필드명 | 타입 | 설명 |
| --- | --- | --- |
| id | Long | 설문 카테고리 식별자 |
| name | String | 과목설문, 기타설문, 간담회 신청 등 |
| code | String | SUBJECT, ETC, MEETUP, EVENT 등 카테고리 코드 |
| description | String | 카테고리 설명 |

> 설명: 설문과 신청 폼의 기본 정보, 기간, 정원, 생성자를 관리한다.
# Survey

| 필드명 | 타입 | 설명 |
| --- | --- | --- |
| id | Long | 설문/신청 식별자 |
| category | SurveyCategory | 설문 카테고리 |
| title | String | 설문 제목 또는 간담회 신청 제목 |
| description | String | 설문 설명 |
| formType | FormType | 일반 설문, 과목 설문, 간담회 신청, 이벤트 신청 구분 |
| openAt | LocalDateTime | 오픈 시간 |
| closeAt | LocalDateTime | 마감 시간 |
| capacity | Integer | 간담회/이벤트 모집 정원 |
| eventStartAt | LocalDateTime | 간담회/이벤트 시작 시간 |
| eventEndAt | LocalDateTime | 간담회/이벤트 종료 시간 |
| eventType | EventType | 온라인/오프라인 구분 |
| linkedPost | BoardPost | 신청자에게만 보여줄 게시글 |
| createdBy | User | 설문 생성자 |
| createdAt | LocalDateTime | 생성일 |
| updatedAt | LocalDateTime | 수정일 |

> 설명: 설문이나 신청 폼에 포함되는 문항을 관리한다.
# SurveyQuestion

| 필드명 | 타입 | 설명 |
| --- | --- | --- |
| id | Long | 문항 식별자 |
| survey | Survey | 문항이 속한 설문/신청 |
| questionNo | Integer | 화면 표시용 문제번호 |
| questionText | String | 질문 내용 |
| questionType | QuestionType | 문항 타입 |
| options | List | 객관식/복수선택/점수형 선택지 |
| isRequired | Boolean | 필수 응답 여부 |
| sortOrder | Integer | 노출 순서 |

> 설명: 설문 대상자, 응답 내용, 신청/선정/탈락 상태를 관리한다.
# SurveyParticipant

| 필드명 | 타입 | 설명 |
| --- | --- | --- |
| id | Long | 대상자/응답자 식별자 |
| survey | Survey | 대상 설문/신청 |
| user | User | 대상 유저 또는 응답 유저 |
| answers | Map<String, Object> | `{문항ID: 답변}` 형태의 응답 데이터 |
| participantStatus | ParticipantStatus | 대상, 제출, 취소, 선정, 탈락 상태 |
| submittedAt | LocalDateTime | 제출/신청 시간 |
| cancelledAt | LocalDateTime | 취소 시간 |
| updatedAt | LocalDateTime | 수정 시간 |
| createdAt | LocalDateTime | 대상자 등록 또는 최초 생성 시간 |

> 설명: 1:1 문의와 관리자 답변, 처리 상태를 관리한다.
# Inquiry

| 필드명 | 타입 | 설명 |
| --- | --- | --- |
| id | Long | 문의 식별자 |
| user | User | 문의 작성자 |
| category | String | 문의 유형 |
| title | String | 문의 제목 |
| content | String | 문의 내용 |
| status | InquiryStatus | 문의 처리 상태 |
| answerContent | String | 운영자 답변 내용 |
| answeredBy | User | 답변한 운영자 |
| answeredAt | LocalDateTime | 답변일 |
| isDeleted | Boolean | 삭제 여부 |
| createdAt | LocalDateTime | 문의 등록일 |
| updatedAt | LocalDateTime | 수정일 |

> 설명: 사용자별 알림 내용, 읽음 여부, 이동 대상을 관리한다.
# Notification

| 필드명 | 타입 | 설명 |
| --- | --- | --- |
| id | Long | 알림 식별자 |
| sender | User | 보낸 사람 |
| receiver | User | 받는 사람 |
| title | String | 알림 제목 |
| content | String | 알림 내용 |
| notificationType | NotificationType | 알림 종류 |
| targetType | String | 알림 클릭 시 이동할 대상 타입 |
| targetId | Long | 알림 클릭 시 이동할 대상 ID |
| isImportant | Boolean | 필독/중요 알림 여부 |
| metadata | Map<String, Object> | 알림 부가 데이터 |
| isRead | Boolean | 읽음 여부 |
| readAt | LocalDateTime | 읽은 시간 |
| createdAt | LocalDateTime | 보낸 시간 |

> 설명: 약관, 개인정보 동의, 운영원칙, 삭제기준 등 동의 항목을 관리한다.
# Agreement

| 필드명 | 타입 | 설명 |
| --- | --- | --- |
| id | Long | 동의 항목 식별자 |
| category | AgreementCategoryType | 동의 분류 |
| targetType | AgreementTargetType | 동의가 연결되는 대상 타입 |
| targetId | Long | 동의가 연결되는 대상 ID |
| title | String | 동의 제목 |
| contentHtml | String | 동의 내용 HTML |
| attachmentFile | FileResource | 동의서, 운영원칙, 삭제기준 등과 연결된 첨부파일 |
| agreementType | AgreementType | 동의 유형 |
| version | String | 동의 버전 |
| isRequired | Boolean | 필수 동의 여부 |
| isActive | Boolean | 현재 사용 여부 |
| sortOrder | Integer | 노출 순서 |
| createdAt | LocalDateTime | 생성일 |
| updatedAt | LocalDateTime | 수정일 |

> 설명: 사용자가 어떤 약관 버전에 언제 동의했는지 관리한다.
# UserAgreement

| 필드명 | 타입 | 설명 |
| --- | --- | --- |
| id | Long | 유저 동의 기록 식별자 |
| agreement | Agreement | 동의한 항목 |
| user | User | 동의한 유저 |
| agreedVersion | String | 유저가 동의한 버전 |
| agreedAt | LocalDateTime | 동의 일시 |
| ipAddress | String | 동의 당시 IP |
| userAgent | String | 동의 당시 브라우저 정보 |

> 설명: 사용자의 비밀번호 변경 이력을 최소 범위로 관리한다.
# PasswordChangeHistory

| 필드명 | 타입 | 설명 |
| --- | --- | --- |
| id | Long | 비밀번호 변경 이력 식별자 |
| user | User | 비밀번호를 변경한 유저 |
| changedAt | LocalDateTime | 비밀번호 변경 시간 |
| ipAddress | String | 변경 요청 IP |
| userAgent | String | 변경 당시 브라우저 정보 |

> 설명: 관리자 페이지에서 발생한 주요 변경 행위를 기록한다.
# AuditLog

| 필드명 | 타입 | 설명 |
| --- | --- | --- |
| id | Long | 로그 식별자 |
| actor | User | 행위를 수행한 관리자 |
| action | AuditAction | 수행 액션 |
| targetType | String | 대상 타입 |
| targetId | Long | 대상 ID |
| message | String | 로그 요약 메시지 |
| ipAddress | String | 요청 IP |
| createdAt | LocalDateTime | 로그 생성일 |

# Enum 정리

| Enum 이름 | 값 | 설명 |
| --- | --- | --- |
| UserRole | STUDENT, ADMIN, OPERATOR, MENTOR | 사용자의 권한을 구분한다. 교육생은 `STUDENT`, 관리자 권한은 `ADMIN`, 운영 담당자는 `OPERATOR`, 멘토 역할을 가진 사용자는 `MENTOR`로 관리한다. |
| UserStatus | ACTIVE, INACTIVE, WITHDRAWN | 계정 상태를 나타낸다. 정상 사용 중인 계정은 `ACTIVE`, 비활성화된 계정은 `INACTIVE`, 탈퇴 처리된 계정은 `WITHDRAWN`으로 관리한다. |
| AttendanceStatus | NORMAL, LATE, ABSENT, EARLY_LEAVE, OUTING, EXCUSED, PENDING | 출석 상태를 나타낸다. 정상 출석, 지각, 결석, 조퇴, 외출, 공가/예외, 처리 대기 상태를 관리한다. |
| PointTransactionType | EARN, USE, ADJUST, EXPIRE | 장학 포인트/경험치 변동 유형을 구분한다. 적립, 사용, 운영자 조정, 만료를 관리한다. |
| BookmarkTargetType | BOARD_POST, LEARNING_CONTENT, COURSE_SESSION, SURVEY, EXTERNAL_LINK | 통합 찜 목록에서 찜할 수 있는 대상 유형을 구분한다. 게시글, 이러닝 콘텐츠, 강의 세션, 설문/신청, 외부 링크를 관리한다. |
| CourseStatus | PLANNED, OPEN, CLOSED | 과정 또는 과목의 운영 상태를 구분한다. 예정, 진행중, 종료 상태를 관리한다. |
| CourseSessionType | LECTURE, PROJECT, LIVE, REPLAY, CURRICULUM, SELF_STUDY | 강의/커리큘럼 세션 유형을 구분한다. 일반 강의, 프로젝트, 라이브, 다시보기, 주차별 커리큘럼, 자율학습을 관리한다. |
| LearningContentType | VIDEO, EBOOK, LINK, FILE, LIVE_REPLAY | 학습 콘텐츠 유형을 구분한다. 영상, e-book, 외부 링크, 파일 자료, 라이브 다시보기를 관리한다. |
| LearningProgressStatus | NOT_STARTED, IN_PROGRESS, COMPLETED | 유저별 학습 진행 상태를 나타낸다. 미시작, 진행중, 완료 상태를 관리한다. |
| ContentInteractionType | VIEW, PLAY, LIKE, DOWNLOAD | 학습 콘텐츠에 대해 사용자가 수행한 상호작용 유형을 구분한다. 조회, 재생, 좋아요, 다운로드를 관리한다. |
| CourseTaskType | QUEST, EVALUATION, SUBJECT_EVALUATION, MONTHLY_EVALUATION, REQUIRED_LEARNING, DAILY_ASSIGNMENT, ASSIGNMENT | 강의실의 Quest, 일반 평가, 과목평가, 월말평가, 필수학습, 데일리 과제, 일반 과제를 구분한다. |
| TaskResultStatus | SCHEDULED, IN_PROGRESS, SUBMITTED, COMPLETED, PASSED, FAILED, CANCELLED, EXPIRED | 유저별 Quest/평가 결과 상태를 나타낸다. 예정, 진행중, 제출, 완료, 합격, 불합격, 취소, 기한만료 상태를 관리한다. |
| EducationDayType | EDUCATION, HOLIDAY, VACATION, EVENT | 교육 달력의 날짜 유형을 구분한다. 교육일, 휴일, 방학, 행사일을 관리한다. |
| AttendanceIssueType | LATE, EARLY_LEAVE, OUTING, ABSENCE, MISSING_CHECK_IN, MISSING_CHECK_OUT | 출결 이슈 유형을 구분한다. 지각, 조퇴, 외출, 결석, 입실 누락, 퇴실 누락을 관리한다. |
| AttendanceReasonStatus | NONE, PENDING, APPROVED, REJECTED, UNEXCUSED | 출결 사유 처리 상태를 구분한다. 사유 없음, 소명 대기, 사유 승인, 반려, 임의 처리 상태를 관리한다. |
| AttendanceAppealStatus | SUBMITTED, APPROVED, REJECTED, CANCELLED | 출결 소명 처리 상태를 나타낸다. 제출, 승인, 반려, 취소 상태를 관리한다. |
| LearningCategoryType | ROOT, MAJOR, MINOR | 이러닝 카테고리 단계를 구분한다. 전체/대분류/소분류를 계층형으로 관리한다. |
| UserActivityType | SW_COMPETENCY, SSAFY_ACTIVITY, EXTERNAL_AWARD | 유저 교육현황의 SW 역량 등급, SSAFY 활동, 외부 시상 기록을 구분한다. |
| FileTargetType | USER_PROFILE, BOARD_POST, BOARD_EDITOR_IMAGE, SURVEY, INQUIRY, COURSE_SESSION, LEARNING_CONTENT, AGREEMENT, ATTENDANCE_APPEAL, USER_ACTIVITY | 파일이 어떤 대상에 연결되는지 구분한다. 프로필 이미지, 게시글 첨부파일, 게시글 에디터 이미지, 설문/간담회 신청 첨부파일, 1:1 문의 첨부파일, 강의 세션 자료, 이러닝 콘텐츠, 약관/동의서 첨부파일, 출결 소명 증빙, 활동/시상 증빙을 하나의 파일 엔티티에서 관리하기 위해 사용한다. |
| FileRole | ATTACHMENT, EDITOR_IMAGE, THUMBNAIL, VIDEO_THUMBNAIL | 파일의 역할을 구분한다. 일반 첨부파일, 에디터 본문 이미지, 썸네일, 영상 썸네일처럼 같은 파일이라도 화면에서 쓰이는 목적이 다를 때 사용한다. |
| BoardType | NORMAL, NOTICE, FAQ, ANONYMOUS, MENTORING, ACADEMIC_RULE, MEETUP_INFO, MEETUP_REVIEW, INQUIRY | 게시판의 큰 성격을 구분한다. 일반 게시판, 공지사항, FAQ, 익명 게시판, 멘토링 게시판, 학사규정, 간담회 정보, 간담회 후기, 1:1 문의용 게시판을 구분하는 데 사용한다. |
| ContentType | TEXT, HTML, IMAGE, VIDEO, FAQ | 게시글 콘텐츠의 종류를 구분한다. 단순 텍스트 글, HTML 에디터 글, 이미지 중심 글, 영상 글, FAQ 형식 글처럼 게시글이 어떤 형태의 내용을 가지는지 나타낸다. |
| FormType | SURVEY, SUBJECT_SURVEY, MEETUP_APPLICATION, EVENT_APPLICATION | 설문성 폼의 종류를 구분한다. 일반 설문, 과목 설문, 간담회 신청, 이벤트 신청을 같은 `Survey` 구조에서 처리하기 위해 사용한다. |
| EventType | ONLINE, OFFLINE | 간담회나 이벤트가 온라인으로 진행되는지 오프라인으로 진행되는지 구분한다. 설문이 아닌 신청형 폼에서 주로 사용한다. |
| QuestionType | TEXT, SINGLE_CHOICE, MULTIPLE_CHOICE, SCORE | 설문 문항의 입력 방식을 구분한다. 주관식, 단일 선택 객관식, 복수 선택 객관식, 점수형 문항을 관리하기 위해 사용한다. |
| ParticipantStatus | TARGETED, SUBMITTED, CANCELLED, SELECTED, REJECTED | 설문 대상자 또는 신청자의 상태를 나타낸다. 대상자로만 등록된 상태는 `TARGETED`, 응답 또는 신청 완료는 `SUBMITTED`, 취소는 `CANCELLED`, 간담회나 이벤트 선정은 `SELECTED`, 탈락은 `REJECTED`로 관리한다. |
| InquiryStatus | WAITING, ANSWERED, CLOSED | 1:1 문의 처리 상태를 나타낸다. 운영자 답변 전은 `WAITING`, 답변 완료는 `ANSWERED`, 문의 종료는 `CLOSED`로 관리한다. |
| NotificationType | CLASS_NOTICE, USER_NOTICE, SYSTEM, QUEST, MENTORING, ATTENDANCE | 알림 종류를 구분한다. 반 단위 알림은 `CLASS_NOTICE`, 특정 사용자에게 보내는 개인 알림은 `USER_NOTICE`, 시스템 자동 발송은 `SYSTEM`, Quest/평가 알림은 `QUEST`, 멘토링 알림은 `MENTORING`, 출석 알림은 `ATTENDANCE`로 관리한다. |
| AgreementCategoryType | BOARD, SURVEY, MEETUP, EVENT, PRIVACY, MARKETING, ETC | 동의 항목의 큰 분류를 나타낸다. 게시판 이용 동의, 설문 관련 동의, 간담회 동의, 이벤트 동의, 개인정보 동의, 마케팅 수신 동의, 기타 동의를 구분한다. |
| AgreementTargetType | BOARD_CATEGORY, SURVEY, GLOBAL | 동의 항목이 어떤 대상에 연결되는지 구분한다. 특정 게시판 카테고리에 필요한 동의는 `BOARD_CATEGORY`, 특정 설문/신청에 필요한 동의는 `SURVEY`, 서비스 전체에 적용되는 동의는 `GLOBAL`로 관리한다. |
| AgreementType | TERMS, PRIVACY, OPERATION_RULE, DELETE_CRITERIA, MARKETING, ETC | 동의 항목의 성격을 구분한다. 이용약관, 개인정보 수집 및 이용 동의, 운영원칙, 게시물 삭제 기준, 마케팅 수신 동의, 기타 동의 항목을 관리한다. |
| AuditAction | CREATE, UPDATE, DELETE, APPROVE, REJECT, ANSWER, SEND, ADJUST | 관리자 감사 로그에서 기록할 행위 종류를 나타낸다. 등록, 수정, 삭제, 승인, 반려, 문의 답변, 알림 발송, 포인트/경험치 조정 같은 주요 관리자 행위를 기록한다. |