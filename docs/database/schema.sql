-- Edu SSAFY Clone Schema
-- 기준 문서: docs/database/tables.md
-- Dialect: MySQL 8.x
-- 원칙: CMS성 메뉴/배너/운영 로그는 제외하고, 에듀싸피 클론 기능 구현에 필요한 도메인 테이블 중심으로 구성한다.

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS audit_logs;
DROP TABLE IF EXISTS password_change_histories;
DROP TABLE IF EXISTS user_agreements;
DROP TABLE IF EXISTS agreements;
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS inquiries;
DROP TABLE IF EXISTS survey_participants;
DROP TABLE IF EXISTS survey_questions;
DROP TABLE IF EXISTS course_tasks;
DROP TABLE IF EXISTS user_task_results;
DROP TABLE IF EXISTS surveys;
DROP TABLE IF EXISTS survey_categories;
DROP TABLE IF EXISTS user_activity_records;
DROP TABLE IF EXISTS user_learning_progresses;
DROP TABLE IF EXISTS user_content_interactions;
DROP TABLE IF EXISTS learning_contents;
DROP TABLE IF EXISTS learning_categories;
DROP TABLE IF EXISTS course_sessions;
DROP TABLE IF EXISTS course_weeks;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS board_comments;
DROP TABLE IF EXISTS board_posts;
DROP TABLE IF EXISTS board_categories;
DROP TABLE IF EXISTS boards;
DROP TABLE IF EXISTS user_bookmarks;
DROP TABLE IF EXISTS user_stats;
DROP TABLE IF EXISTS point_transactions;
DROP TABLE IF EXISTS attendance_appeals;
DROP TABLE IF EXISTS attendance_records;
DROP TABLE IF EXISTS education_calendar_days;
DROP TABLE IF EXISTS files;
DROP TABLE IF EXISTS users;

SET FOREIGN_KEY_CHECKS = 1;

-- ------------------------------------------------------------
-- 1. users
-- 서비스 사용자인 교육생, 관리자, 운영자, 멘토의 기본 계정 정보를 관리한다.
-- ------------------------------------------------------------
CREATE TABLE users (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '유저 식별자',
    email VARCHAR(255) NOT NULL COMMENT '로그인 ID로 사용하는 이메일',
    password VARCHAR(255) NOT NULL COMMENT '암호화된 비밀번호',
    name VARCHAR(100) NOT NULL COMMENT '유저 이름',
    student_no VARCHAR(50) NULL COMMENT '학번',
    generation INT NULL COMMENT 'SSAFY 기수',
    region VARCHAR(100) NULL COMMENT '소속 지역',
    class_no INT NULL COMMENT '소속 반 번호',
    profile_file_id BIGINT NULL COMMENT '프로필 이미지 파일 ID',
    phone_number VARCHAR(30) NULL COMMENT '휴대폰 번호',
    emergency_phone_number VARCHAR(30) NULL COMMENT '긴급연락처',
    zip_code VARCHAR(20) NULL COMMENT '우편번호',
    address VARCHAR(255) NULL COMMENT '기본 주소',
    address_detail VARCHAR(255) NULL COMMENT '상세 주소',
    role VARCHAR(30) NOT NULL DEFAULT 'STUDENT' COMMENT 'STUDENT, ADMIN, OPERATOR, MENTOR',
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE' COMMENT 'ACTIVE, INACTIVE, WITHDRAWN',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    PRIMARY KEY (id),
    UNIQUE KEY uk_users_email (email),
    UNIQUE KEY uk_users_student_no (student_no),
    KEY idx_users_generation_region_class (generation, region, class_no),
    KEY idx_users_role_status (role, status),
    CONSTRAINT chk_users_role CHECK (role IN ('STUDENT', 'ADMIN', 'OPERATOR', 'MENTOR')),
    CONSTRAINT chk_users_status CHECK (status IN ('ACTIVE', 'INACTIVE', 'WITHDRAWN'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='사용자';

-- ------------------------------------------------------------
-- 2. files
-- 게시글, 설문, 문의, 학습 콘텐츠 등에 연결되는 공통 파일 정보를 관리한다.
-- ------------------------------------------------------------
CREATE TABLE files (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '파일 식별자',
    original_name VARCHAR(255) NOT NULL COMMENT '원본 파일명',
    stored_name VARCHAR(255) NOT NULL COMMENT '서버에 저장된 파일명',
    file_url VARCHAR(500) NOT NULL COMMENT '파일 접근 URL',
    file_type VARCHAR(100) NULL COMMENT 'MIME 타입 또는 확장자',
    file_size BIGINT NULL COMMENT '파일 크기',
    uploaded_by_id BIGINT NULL COMMENT '업로드한 유저 ID',
    target_type VARCHAR(50) NULL COMMENT '파일 연결 대상 타입',
    target_id BIGINT NULL COMMENT '파일 연결 대상 ID',
    file_role VARCHAR(50) NOT NULL DEFAULT 'ATTACHMENT' COMMENT 'ATTACHMENT, EDITOR_IMAGE, THUMBNAIL, VIDEO_THUMBNAIL',
    sort_order INT NOT NULL DEFAULT 0 COMMENT '파일 노출 순서',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '업로드일',
    PRIMARY KEY (id),
    KEY idx_files_uploaded_by (uploaded_by_id),
    KEY idx_files_target (target_type, target_id),
    CONSTRAINT fk_files_uploaded_by FOREIGN KEY (uploaded_by_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT chk_files_target_type CHECK (target_type IS NULL OR target_type IN ('USER_PROFILE', 'BOARD_POST', 'BOARD_EDITOR_IMAGE', 'SURVEY', 'INQUIRY', 'COURSE_SESSION', 'LEARNING_CONTENT', 'AGREEMENT', 'ATTENDANCE_APPEAL', 'USER_ACTIVITY')),
    CONSTRAINT chk_files_file_role CHECK (file_role IN ('ATTACHMENT', 'EDITOR_IMAGE', 'THUMBNAIL', 'VIDEO_THUMBNAIL'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='파일';

ALTER TABLE users
    ADD CONSTRAINT fk_users_profile_file FOREIGN KEY (profile_file_id) REFERENCES files(id) ON DELETE SET NULL;

-- ------------------------------------------------------------
-- 3. courses
-- SSAFY 과정, 과목, 반 단위 교육 과정을 관리한다.
-- ------------------------------------------------------------
CREATE TABLE courses (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '과정/과목 식별자',
    title VARCHAR(200) NOT NULL COMMENT '과정 또는 과목명',
    description TEXT NULL COMMENT '과정 설명',
    generation INT NULL COMMENT 'SSAFY 기수',
    region VARCHAR(100) NULL COMMENT '운영 지역',
    class_no INT NULL COMMENT '반 번호',
    instructor_name VARCHAR(100) NULL COMMENT '대표 강사명',
    status VARCHAR(30) NOT NULL DEFAULT 'PLANNED' COMMENT 'PLANNED, OPEN, CLOSED',
    start_date DATE NULL COMMENT '과정 시작일',
    end_date DATE NULL COMMENT '과정 종료일',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    PRIMARY KEY (id),
    KEY idx_courses_generation_region_class (generation, region, class_no),
    KEY idx_courses_status (status),
    CONSTRAINT chk_courses_status CHECK (status IN ('PLANNED', 'OPEN', 'CLOSED'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='과정';

-- ------------------------------------------------------------
-- 4. education_calendar_days
-- 출결 집계 기준이 되는 교육일, 휴일, 행사일 같은 교육 달력을 관리한다.
-- ------------------------------------------------------------
CREATE TABLE education_calendar_days (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '교육일/휴일 달력 식별자',
    course_id BIGINT NULL COMMENT '대상 과정 ID',
    calendar_date DATE NOT NULL COMMENT '기준 날짜',
    day_type VARCHAR(30) NOT NULL COMMENT 'EDUCATION, HOLIDAY, VACATION, EVENT',
    is_education_day TINYINT(1) NOT NULL DEFAULT 1 COMMENT '출결 집계 포함 여부',
    title VARCHAR(200) NULL COMMENT '공가, 휴일, 행사명 등 표시명',
    description TEXT NULL COMMENT '상세 설명',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    PRIMARY KEY (id),
    UNIQUE KEY uk_calendar_course_date (course_id, calendar_date),
    KEY idx_calendar_date (calendar_date),
    CONSTRAINT fk_calendar_course FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    CONSTRAINT chk_calendar_day_type CHECK (day_type IN ('EDUCATION', 'HOLIDAY', 'VACATION', 'EVENT'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='교육 달력';

-- ------------------------------------------------------------
-- 5. attendance_records
-- 교육생의 일자별 입실, 퇴실, 지각, 결석 등 출결 기록을 관리한다.
-- ------------------------------------------------------------
CREATE TABLE attendance_records (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '출석 기록 식별자',
    user_id BIGINT NOT NULL COMMENT '출석 대상 유저 ID',
    course_id BIGINT NULL COMMENT '출석이 속한 과정 ID',
    calendar_day_id BIGINT NULL COMMENT '출석 기준 교육일 ID',
    attendance_date DATE NOT NULL COMMENT '출석 기준일',
    check_in_at DATETIME NULL COMMENT '입실/출석 체크 시간',
    check_out_at DATETIME NULL COMMENT '퇴실 체크 시간',
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING' COMMENT 'NORMAL, LATE, ABSENT, EARLY_LEAVE, OUTING, EXCUSED, PENDING',
    issue_types JSON NULL COMMENT '출결 이슈 목록',
    reason_status VARCHAR(30) NOT NULL DEFAULT 'NONE' COMMENT 'NONE, PENDING, APPROVED, REJECTED, UNEXCUSED',
    reason_text TEXT NULL COMMENT '출결 사유 또는 메모',
    check_in_type VARCHAR(30) NULL COMMENT 'QR, WEB, ADMIN 등 출석 체크 방식',
    check_out_type VARCHAR(30) NULL COMMENT 'QR, WEB, ADMIN 등 퇴실 체크 방식',
    note TEXT NULL COMMENT '운영자 메모 또는 예외 사유',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    PRIMARY KEY (id),
    UNIQUE KEY uk_attendance_user_date (user_id, attendance_date),
    KEY idx_attendance_course_date (course_id, attendance_date),
    KEY idx_attendance_status (status),
    KEY idx_attendance_calendar_day (calendar_day_id),
    CONSTRAINT fk_attendance_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_attendance_course FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE SET NULL,
    CONSTRAINT fk_attendance_calendar_day FOREIGN KEY (calendar_day_id) REFERENCES education_calendar_days(id) ON DELETE SET NULL,
    CONSTRAINT chk_attendance_status CHECK (status IN ('NORMAL', 'LATE', 'ABSENT', 'EARLY_LEAVE', 'OUTING', 'EXCUSED', 'PENDING')),
    CONSTRAINT chk_attendance_reason_status CHECK (reason_status IN ('NONE', 'PENDING', 'APPROVED', 'REJECTED', 'UNEXCUSED'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='출결 기록';

-- ------------------------------------------------------------
-- 6. attendance_appeals
-- 교육생이 제출한 출결 소명과 관리자의 승인/반려 결과를 관리한다.
-- ------------------------------------------------------------
CREATE TABLE attendance_appeals (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '출결 소명 식별자',
    attendance_record_id BIGINT NOT NULL COMMENT '소명 대상 출석 기록 ID',
    user_id BIGINT NOT NULL COMMENT '소명 신청자 ID',
    appeal_type VARCHAR(50) NOT NULL COMMENT 'LATE, EARLY_LEAVE, OUTING, ABSENCE, MISSING_CHECK_IN, MISSING_CHECK_OUT',
    reason TEXT NOT NULL COMMENT '소명 사유',
    attachment_file_id BIGINT NULL COMMENT '증빙 파일 ID',
    appeal_status VARCHAR(30) NOT NULL DEFAULT 'SUBMITTED' COMMENT 'SUBMITTED, APPROVED, REJECTED, CANCELLED',
    reviewed_by_id BIGINT NULL COMMENT '검토자 ID',
    reviewed_at DATETIME NULL COMMENT '검토 시간',
    review_comment TEXT NULL COMMENT '검토 의견 또는 반려 사유',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '신청일',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    PRIMARY KEY (id),
    KEY idx_attendance_appeals_record (attendance_record_id),
    KEY idx_attendance_appeals_user (user_id),
    KEY idx_attendance_appeals_status (appeal_status),
    KEY idx_attendance_appeals_reviewed_by (reviewed_by_id),
    KEY idx_attendance_appeals_file (attachment_file_id),
    CONSTRAINT fk_attendance_appeals_record FOREIGN KEY (attendance_record_id) REFERENCES attendance_records(id) ON DELETE CASCADE,
    CONSTRAINT fk_attendance_appeals_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_attendance_appeals_file FOREIGN KEY (attachment_file_id) REFERENCES files(id) ON DELETE SET NULL,
    CONSTRAINT fk_attendance_appeals_reviewed_by FOREIGN KEY (reviewed_by_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT chk_attendance_appeal_type CHECK (appeal_type IN ('LATE', 'EARLY_LEAVE', 'OUTING', 'ABSENCE', 'MISSING_CHECK_IN', 'MISSING_CHECK_OUT')),
    CONSTRAINT chk_attendance_appeal_status CHECK (appeal_status IN ('SUBMITTED', 'APPROVED', 'REJECTED', 'CANCELLED'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='출결 소명';

-- ------------------------------------------------------------
-- 7. point_transactions
-- 장학 포인트와 경험치의 적립, 차감, 조정 이력을 관리한다.
-- ------------------------------------------------------------
CREATE TABLE point_transactions (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '포인트/경험치 이력 식별자',
    user_id BIGINT NOT NULL COMMENT '대상 유저 ID',
    transaction_type VARCHAR(30) NOT NULL COMMENT 'EARN, USE, ADJUST, EXPIRE',
    point_amount INT NOT NULL DEFAULT 0 COMMENT '변동 장학 포인트',
    exp_amount INT NOT NULL DEFAULT 0 COMMENT '변동 경험치',
    reason VARCHAR(255) NULL COMMENT '변동 사유',
    target_type VARCHAR(100) NULL COMMENT '포인트 발생 대상 타입',
    target_id BIGINT NULL COMMENT '포인트 발생 대상 ID',
    created_by_id BIGINT NULL COMMENT '지급, 차감, 조정 처리 관리자 ID',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '발생일',
    PRIMARY KEY (id),
    KEY idx_point_transactions_user_created (user_id, created_at),
    KEY idx_point_transactions_type (transaction_type),
    KEY idx_point_transactions_created_by (created_by_id),
    KEY idx_point_transactions_target (target_type, target_id),
    CONSTRAINT fk_point_transactions_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_point_transactions_created_by FOREIGN KEY (created_by_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT chk_point_transaction_type CHECK (transaction_type IN ('EARN', 'USE', 'ADJUST', 'EXPIRE'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='포인트/경험치 이력';

-- ------------------------------------------------------------
-- 8. user_stats
-- 교육생별 현재 포인트, 경험치, 레벨, 출석률 같은 요약 통계를 관리한다.
-- ------------------------------------------------------------
CREATE TABLE user_stats (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '유저 통계 식별자',
    user_id BIGINT NOT NULL COMMENT '대상 유저 ID',
    scholarship_point INT NOT NULL DEFAULT 0 COMMENT '현재 장학 포인트',
    total_exp INT NOT NULL DEFAULT 0 COMMENT '누적 경험치',
    level_name VARCHAR(100) NULL COMMENT '현재 레벨명',
    level_no INT NOT NULL DEFAULT 1 COMMENT '현재 레벨 번호',
    attendance_rate DECIMAL(5,2) NULL COMMENT '출석률',
    completed_learning_count INT NOT NULL DEFAULT 0 COMMENT '완료한 학습 콘텐츠 수',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '통계 갱신일',
    PRIMARY KEY (id),
    UNIQUE KEY uk_user_stats_user (user_id),
    CONSTRAINT fk_user_stats_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='사용자 통계';

-- ------------------------------------------------------------
-- 9. user_bookmarks
-- 게시글, 학습 콘텐츠, 강의 세션 등 사용자의 통합 찜 목록을 관리한다.
-- ------------------------------------------------------------
CREATE TABLE user_bookmarks (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '통합 찜 식별자',
    user_id BIGINT NOT NULL COMMENT '찜한 유저 ID',
    target_type VARCHAR(50) NOT NULL COMMENT 'BOARD_POST, LEARNING_CONTENT, COURSE_SESSION, SURVEY, EXTERNAL_LINK',
    target_id BIGINT NOT NULL COMMENT '찜 대상 ID',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
    PRIMARY KEY (id),
    UNIQUE KEY uk_user_bookmarks_target (user_id, target_type, target_id),
    KEY idx_user_bookmarks_target (target_type, target_id),
    CONSTRAINT fk_user_bookmarks_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT chk_bookmark_target_type CHECK (target_type IN ('BOARD_POST', 'LEARNING_CONTENT', 'COURSE_SESSION', 'SURVEY', 'EXTERNAL_LINK'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='사용자 찜';

-- ------------------------------------------------------------
-- 10. boards
-- 공지사항, FAQ, 자유게시판, 학사규정 등 게시판의 기본 정보를 관리한다.
-- ------------------------------------------------------------
CREATE TABLE boards (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '게시판 식별자',
    name VARCHAR(100) NOT NULL COMMENT '게시판 이름',
    code VARCHAR(50) NOT NULL COMMENT '게시판 코드',
    board_type VARCHAR(50) NOT NULL COMMENT 'NORMAL, NOTICE, FAQ, ANONYMOUS, MENTORING, ACADEMIC_RULE, MEETUP_INFO, MEETUP_REVIEW, INQUIRY',
    description TEXT NULL COMMENT '게시판 설명',
    PRIMARY KEY (id),
    UNIQUE KEY uk_boards_code (code),
    KEY idx_boards_type (board_type),
    CONSTRAINT chk_boards_type CHECK (board_type IN ('NORMAL', 'NOTICE', 'FAQ', 'ANONYMOUS', 'MENTORING', 'ACADEMIC_RULE', 'MEETUP_INFO', 'MEETUP_REVIEW', 'INQUIRY'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='게시판';

-- ------------------------------------------------------------
-- 11. board_categories
-- 게시판 내부 분류를 관리한다.
-- ------------------------------------------------------------
CREATE TABLE board_categories (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '카테고리 식별자',
    board_id BIGINT NOT NULL COMMENT '소속 게시판 ID',
    name VARCHAR(100) NOT NULL COMMENT '카테고리명',
    code VARCHAR(50) NOT NULL COMMENT '카테고리 코드',
    PRIMARY KEY (id),
    UNIQUE KEY uk_board_categories_board_code (board_id, code),
    CONSTRAINT fk_board_categories_board FOREIGN KEY (board_id) REFERENCES boards(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='게시판 카테고리';

-- ------------------------------------------------------------
-- 12. board_posts
-- 게시판에 등록되는 실제 게시글과 조회수, 좋아요 수 등 화면 표시 정보를 관리한다.
-- ------------------------------------------------------------
CREATE TABLE board_posts (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '게시글 식별자',
    category_id BIGINT NOT NULL COMMENT '게시글 카테고리 ID',
    user_id BIGINT NULL COMMENT '실제 작성자 ID',
    title VARCHAR(255) NOT NULL COMMENT '게시글 제목',
    content_type VARCHAR(30) NOT NULL DEFAULT 'HTML' COMMENT 'TEXT, HTML, IMAGE, VIDEO, FAQ',
    content_text LONGTEXT NULL COMMENT '텍스트 본문 또는 검색용 텍스트',
    content_html LONGTEXT NULL COMMENT 'HTML 본문',
    content_json JSON NULL COMMENT '구조화된 본문 데이터',
    view_count INT NOT NULL DEFAULT 0 COMMENT '조회수',
    like_count INT NOT NULL DEFAULT 0 COMMENT '좋아요 수',
    comment_count INT NOT NULL DEFAULT 0 COMMENT '댓글 수',
    scrap_count INT NOT NULL DEFAULT 0 COMMENT '찜 수',
    has_attachment TINYINT(1) NOT NULL DEFAULT 0 COMMENT '첨부파일 여부',
    is_notice TINYINT(1) NOT NULL DEFAULT 0 COMMENT '상단 고정 여부',
    is_deleted TINYINT(1) NOT NULL DEFAULT 0 COMMENT '삭제 여부',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    PRIMARY KEY (id),
    KEY idx_board_posts_category_created (category_id, created_at),
    KEY idx_board_posts_user (user_id),
    KEY idx_board_posts_notice_created (is_notice, created_at),
    KEY idx_board_posts_deleted (is_deleted),
    FULLTEXT KEY ft_board_posts_title_text (title, content_text),
    CONSTRAINT fk_board_posts_category FOREIGN KEY (category_id) REFERENCES board_categories(id) ON DELETE CASCADE,
    CONSTRAINT fk_board_posts_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT chk_board_posts_content_type CHECK (content_type IN ('TEXT', 'HTML', 'IMAGE', 'VIDEO', 'FAQ'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='게시글';

-- ------------------------------------------------------------
-- 13. board_comments
-- 게시글 댓글과 대댓글을 관리한다.
-- ------------------------------------------------------------
CREATE TABLE board_comments (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '댓글 식별자',
    post_id BIGINT NOT NULL COMMENT '게시글 ID',
    user_id BIGINT NULL COMMENT '댓글 작성자 ID',
    parent_id BIGINT NULL COMMENT '부모 댓글 ID',
    content TEXT NOT NULL COMMENT '댓글 내용',
    is_deleted TINYINT(1) NOT NULL DEFAULT 0 COMMENT '삭제 여부',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    PRIMARY KEY (id),
    KEY idx_board_comments_post_created (post_id, created_at),
    KEY idx_board_comments_user (user_id),
    KEY idx_board_comments_parent (parent_id),
    CONSTRAINT fk_board_comments_post FOREIGN KEY (post_id) REFERENCES board_posts(id) ON DELETE CASCADE,
    CONSTRAINT fk_board_comments_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_board_comments_parent FOREIGN KEY (parent_id) REFERENCES board_comments(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='게시글 댓글';

-- ------------------------------------------------------------
-- 14. course_weeks
-- 과정의 주차별 커리큘럼 구간을 관리한다.
-- ------------------------------------------------------------
CREATE TABLE course_weeks (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '주차 식별자',
    course_id BIGINT NOT NULL COMMENT '소속 과정 ID',
    week_no INT NOT NULL COMMENT '과정 주차',
    title VARCHAR(200) NOT NULL COMMENT '주차 제목',
    start_date DATE NULL COMMENT '주차 시작일',
    end_date DATE NULL COMMENT '주차 종료일',
    sort_order INT NOT NULL DEFAULT 0 COMMENT '노출 순서',
    PRIMARY KEY (id),
    UNIQUE KEY uk_course_weeks_course_week (course_id, week_no),
    CONSTRAINT fk_course_weeks_course FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='과정 주차';

-- ------------------------------------------------------------
-- 15. course_sessions
-- 주차 안의 강의, 프로젝트, 라이브, 다시보기 같은 세션을 관리한다.
-- ------------------------------------------------------------
CREATE TABLE course_sessions (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '강의/커리큘럼 세션 식별자',
    course_id BIGINT NOT NULL COMMENT '소속 과정 ID',
    week_id BIGINT NULL COMMENT '소속 주차 ID',
    title VARCHAR(200) NOT NULL COMMENT '세션 제목',
    subtitle VARCHAR(255) NULL COMMENT '세션 부제 또는 상세명',
    session_type VARCHAR(50) NOT NULL COMMENT 'LECTURE, PROJECT, LIVE, REPLAY, CURRICULUM, SELF_STUDY',
    session_date DATE NULL COMMENT '세션 진행일',
    start_at DATETIME NULL COMMENT '시작 시간',
    end_at DATETIME NULL COMMENT '종료 시간',
    instructor_name VARCHAR(100) NULL COMMENT '강사명',
    location VARCHAR(200) NULL COMMENT '캠퍼스/강의실 정보',
    live_url VARCHAR(500) NULL COMMENT '라이브 강의 바로가기 URL',
    replay_url VARCHAR(500) NULL COMMENT '다시보기 URL',
    material_post_id BIGINT NULL COMMENT '연결된 교재/학습자료 게시글 ID',
    is_required TINYINT(1) NOT NULL DEFAULT 0 COMMENT '필수 학습 여부',
    sort_order INT NOT NULL DEFAULT 0 COMMENT '노출 순서',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    PRIMARY KEY (id),
    KEY idx_course_sessions_course_week (course_id, week_id),
    KEY idx_course_sessions_type (session_type),
    KEY idx_course_sessions_date (session_date),
    KEY idx_course_sessions_material_post (material_post_id),
    CONSTRAINT fk_course_sessions_course FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    CONSTRAINT fk_course_sessions_week FOREIGN KEY (week_id) REFERENCES course_weeks(id) ON DELETE SET NULL,
    CONSTRAINT fk_course_sessions_material_post FOREIGN KEY (material_post_id) REFERENCES board_posts(id) ON DELETE SET NULL,
    CONSTRAINT chk_course_sessions_type CHECK (session_type IN ('LECTURE', 'PROJECT', 'LIVE', 'REPLAY', 'CURRICULUM', 'SELF_STUDY'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='강의 세션';

-- ------------------------------------------------------------
-- 16. learning_categories
-- 이러닝 콘텐츠의 대분류, 중분류 같은 카테고리를 관리한다.
-- ------------------------------------------------------------
CREATE TABLE learning_categories (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '이러닝 카테고리 식별자',
    parent_id BIGINT NULL COMMENT '부모 카테고리 ID',
    name VARCHAR(100) NOT NULL COMMENT '카테고리명',
    code VARCHAR(50) NOT NULL COMMENT '카테고리 코드',
    category_type VARCHAR(30) NOT NULL COMMENT 'ROOT, MAJOR, MINOR',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    PRIMARY KEY (id),
    UNIQUE KEY uk_learning_categories_code (code),
    KEY idx_learning_categories_parent (parent_id),
    CONSTRAINT fk_learning_categories_parent FOREIGN KEY (parent_id) REFERENCES learning_categories(id) ON DELETE SET NULL,
    CONSTRAINT chk_learning_category_type CHECK (category_type IN ('ROOT', 'MAJOR', 'MINOR'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='이러닝 카테고리';

-- ------------------------------------------------------------
-- 17. learning_contents
-- 영상, e-book, 파일, 링크 등 개별 학습 콘텐츠를 관리한다.
-- ------------------------------------------------------------
CREATE TABLE learning_contents (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '이러닝/학습 콘텐츠 식별자',
    course_id BIGINT NULL COMMENT '연결 과정 ID',
    session_id BIGINT NULL COMMENT '연결 강의 세션 ID',
    category_id BIGINT NULL COMMENT '이러닝 카테고리 ID',
    title VARCHAR(255) NOT NULL COMMENT '콘텐츠 제목',
    description TEXT NULL COMMENT '콘텐츠 설명',
    content_type VARCHAR(50) NOT NULL COMMENT 'VIDEO, EBOOK, LINK, FILE, LIVE_REPLAY',
    thumbnail_file_id BIGINT NULL COMMENT '썸네일 파일 ID',
    content_url VARCHAR(500) NULL COMMENT '콘텐츠 접근 URL',
    duration_seconds INT NULL COMMENT '콘텐츠 길이',
    view_count INT NOT NULL DEFAULT 0 COMMENT '조회 또는 재생 수',
    like_count INT NOT NULL DEFAULT 0 COMMENT '좋아요 수',
    bookmark_count INT NOT NULL DEFAULT 0 COMMENT '찜하기 수',
    download_count INT NOT NULL DEFAULT 0 COMMENT '다운로드 수',
    is_required TINYINT(1) NOT NULL DEFAULT 0 COMMENT '필수 학습 여부',
    open_at DATETIME NULL COMMENT '공개 시간',
    close_at DATETIME NULL COMMENT '종료 시간',
    created_by_id BIGINT NULL COMMENT '등록자 ID',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    PRIMARY KEY (id),
    KEY idx_learning_contents_course (course_id),
    KEY idx_learning_contents_session (session_id),
    KEY idx_learning_contents_category (category_id),
    KEY idx_learning_contents_type_required (content_type, is_required),
    KEY idx_learning_contents_open_close (open_at, close_at),
    KEY idx_learning_contents_thumbnail (thumbnail_file_id),
    KEY idx_learning_contents_created_by (created_by_id),
    FULLTEXT KEY ft_learning_contents_title_description (title, description),
    CONSTRAINT fk_learning_contents_course FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE SET NULL,
    CONSTRAINT fk_learning_contents_session FOREIGN KEY (session_id) REFERENCES course_sessions(id) ON DELETE SET NULL,
    CONSTRAINT fk_learning_contents_category FOREIGN KEY (category_id) REFERENCES learning_categories(id) ON DELETE SET NULL,
    CONSTRAINT fk_learning_contents_thumbnail FOREIGN KEY (thumbnail_file_id) REFERENCES files(id) ON DELETE SET NULL,
    CONSTRAINT fk_learning_contents_created_by FOREIGN KEY (created_by_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT chk_learning_content_type CHECK (content_type IN ('VIDEO', 'EBOOK', 'LINK', 'FILE', 'LIVE_REPLAY'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='학습 콘텐츠';

-- ------------------------------------------------------------
-- 18. user_content_interactions
-- 이러닝 콘텐츠에 대한 재생, 좋아요, 다운로드 같은 사용자 상호작용을 관리한다.
-- ------------------------------------------------------------
CREATE TABLE user_content_interactions (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '유저 콘텐츠 상호작용 식별자',
    user_id BIGINT NOT NULL COMMENT '상호작용한 유저 ID',
    content_id BIGINT NOT NULL COMMENT '대상 학습 콘텐츠 ID',
    interaction_type VARCHAR(30) NOT NULL COMMENT 'VIEW, PLAY, LIKE, DOWNLOAD',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '상호작용 발생 시간',
    PRIMARY KEY (id),
    KEY idx_content_interactions_user_created (user_id, created_at),
    KEY idx_content_interactions_content_type (content_id, interaction_type),
    CONSTRAINT fk_content_interactions_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_content_interactions_content FOREIGN KEY (content_id) REFERENCES learning_contents(id) ON DELETE CASCADE,
    CONSTRAINT chk_content_interaction_type CHECK (interaction_type IN ('VIEW', 'PLAY', 'LIKE', 'DOWNLOAD'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='학습 콘텐츠 상호작용';

-- ------------------------------------------------------------
-- 19. user_learning_progresses
-- 사용자별 학습 진행률, 마지막 재생 위치, 완료 여부를 관리한다.
-- ------------------------------------------------------------
CREATE TABLE user_learning_progresses (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '유저 학습 진행 식별자',
    user_id BIGINT NOT NULL COMMENT '학습자 ID',
    content_id BIGINT NOT NULL COMMENT '학습 콘텐츠 ID',
    progress_status VARCHAR(30) NOT NULL DEFAULT 'NOT_STARTED' COMMENT 'NOT_STARTED, IN_PROGRESS, COMPLETED',
    progress_rate DECIMAL(5,2) NOT NULL DEFAULT 0.00 COMMENT '학습 진행률',
    last_position_seconds INT NOT NULL DEFAULT 0 COMMENT '마지막 재생 위치',
    started_at DATETIME NULL COMMENT '최초 학습 시작 시간',
    completed_at DATETIME NULL COMMENT '완료 시간',
    last_accessed_at DATETIME NULL COMMENT '마지막 접속 시간',
    PRIMARY KEY (id),
    UNIQUE KEY uk_learning_progress_user_content (user_id, content_id),
    KEY idx_learning_progress_content (content_id),
    KEY idx_learning_progress_status (progress_status),
    CONSTRAINT fk_learning_progress_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_learning_progress_content FOREIGN KEY (content_id) REFERENCES learning_contents(id) ON DELETE CASCADE,
    CONSTRAINT chk_learning_progress_status CHECK (progress_status IN ('NOT_STARTED', 'IN_PROGRESS', 'COMPLETED'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='학습 진행률';

-- ------------------------------------------------------------
-- 20. survey_categories
-- 설문, 과목평가, 간담회 신청, 이벤트 신청의 기본 분류를 관리한다.
-- ------------------------------------------------------------
CREATE TABLE survey_categories (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '설문 카테고리 식별자',
    name VARCHAR(100) NOT NULL COMMENT '카테고리명',
    code VARCHAR(50) NOT NULL COMMENT '카테고리 코드',
    description TEXT NULL COMMENT '카테고리 설명',
    PRIMARY KEY (id),
    UNIQUE KEY uk_survey_categories_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='설문 카테고리';

-- ------------------------------------------------------------
-- 21. surveys
-- 설문과 신청 폼의 기본 정보, 기간, 정원, 생성자를 관리한다.
-- ------------------------------------------------------------
CREATE TABLE surveys (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '설문/신청 식별자',
    category_id BIGINT NULL COMMENT '설문 카테고리 ID',
    title VARCHAR(255) NOT NULL COMMENT '설문 제목 또는 간담회 신청 제목',
    description TEXT NULL COMMENT '설문 설명',
    form_type VARCHAR(50) NOT NULL COMMENT 'SURVEY, SUBJECT_SURVEY, MEETUP_APPLICATION, EVENT_APPLICATION',
    open_at DATETIME NULL COMMENT '오픈 시간',
    close_at DATETIME NULL COMMENT '마감 시간',
    capacity INT NULL COMMENT '모집 정원',
    event_start_at DATETIME NULL COMMENT '간담회/이벤트 시작 시간',
    event_end_at DATETIME NULL COMMENT '간담회/이벤트 종료 시간',
    event_type VARCHAR(30) NULL COMMENT 'ONLINE, OFFLINE',
    linked_post_id BIGINT NULL COMMENT '신청자에게만 보여줄 게시글 ID',
    created_by_id BIGINT NULL COMMENT '설문 생성자 ID',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    PRIMARY KEY (id),
    KEY idx_surveys_category (category_id),
    KEY idx_surveys_form_type (form_type),
    KEY idx_surveys_open_close (open_at, close_at),
    KEY idx_surveys_linked_post (linked_post_id),
    KEY idx_surveys_created_by (created_by_id),
    CONSTRAINT fk_surveys_category FOREIGN KEY (category_id) REFERENCES survey_categories(id) ON DELETE SET NULL,
    CONSTRAINT fk_surveys_linked_post FOREIGN KEY (linked_post_id) REFERENCES board_posts(id) ON DELETE SET NULL,
    CONSTRAINT fk_surveys_created_by FOREIGN KEY (created_by_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT chk_surveys_form_type CHECK (form_type IN ('SURVEY', 'SUBJECT_SURVEY', 'MEETUP_APPLICATION', 'EVENT_APPLICATION')),
    CONSTRAINT chk_surveys_event_type CHECK (event_type IS NULL OR event_type IN ('ONLINE', 'OFFLINE'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='설문/신청';

-- ------------------------------------------------------------
-- 22. survey_questions
-- 설문이나 신청 폼에 포함되는 문항을 관리한다.
-- ------------------------------------------------------------
CREATE TABLE survey_questions (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '문항 식별자',
    survey_id BIGINT NOT NULL COMMENT '설문/신청 ID',
    question_no INT NOT NULL COMMENT '화면 표시용 문제번호',
    question_text TEXT NOT NULL COMMENT '질문 내용',
    question_type VARCHAR(50) NOT NULL COMMENT 'TEXT, SINGLE_CHOICE, MULTIPLE_CHOICE, SCORE',
    options JSON NULL COMMENT '객관식/복수선택/점수형 선택지',
    is_required TINYINT(1) NOT NULL DEFAULT 0 COMMENT '필수 응답 여부',
    sort_order INT NOT NULL DEFAULT 0 COMMENT '노출 순서',
    PRIMARY KEY (id),
    KEY idx_survey_questions_survey_order (survey_id, sort_order),
    CONSTRAINT fk_survey_questions_survey FOREIGN KEY (survey_id) REFERENCES surveys(id) ON DELETE CASCADE,
    CONSTRAINT chk_survey_question_type CHECK (question_type IN ('TEXT', 'SINGLE_CHOICE', 'MULTIPLE_CHOICE', 'SCORE'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='설문 문항';

-- ------------------------------------------------------------
-- 23. survey_participants
-- 설문 대상자, 응답 내용, 신청/선정/탈락 상태를 관리한다.
-- ------------------------------------------------------------
CREATE TABLE survey_participants (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '대상자/응답자 식별자',
    survey_id BIGINT NOT NULL COMMENT '대상 설문/신청 ID',
    user_id BIGINT NOT NULL COMMENT '대상 유저 또는 응답 유저 ID',
    answers JSON NULL COMMENT '문항 ID: 답변 형태의 응답 데이터',
    participant_status VARCHAR(30) NOT NULL DEFAULT 'TARGETED' COMMENT 'TARGETED, SUBMITTED, CANCELLED, SELECTED, REJECTED',
    submitted_at DATETIME NULL COMMENT '제출/신청 시간',
    cancelled_at DATETIME NULL COMMENT '취소 시간',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정 시간',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '대상자 등록 또는 최초 생성 시간',
    PRIMARY KEY (id),
    UNIQUE KEY uk_survey_participants_survey_user (survey_id, user_id),
    KEY idx_survey_participants_user (user_id),
    KEY idx_survey_participants_status (participant_status),
    CONSTRAINT fk_survey_participants_survey FOREIGN KEY (survey_id) REFERENCES surveys(id) ON DELETE CASCADE,
    CONSTRAINT fk_survey_participants_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT chk_survey_participant_status CHECK (participant_status IN ('TARGETED', 'SUBMITTED', 'CANCELLED', 'SELECTED', 'REJECTED'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='설문 대상자/참여자';

-- ------------------------------------------------------------
-- 24. course_tasks
-- Quest, 평가, 필수학습, 과제 같은 과정별 수행 항목을 관리한다.
-- ------------------------------------------------------------
CREATE TABLE course_tasks (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT 'Quest/평가/필수학습 식별자',
    course_id BIGINT NOT NULL COMMENT '연결 과정 ID',
    session_id BIGINT NULL COMMENT '연결 세션 ID',
    survey_id BIGINT NULL COMMENT '설문형 평가인 경우 연결 설문 ID',
    title VARCHAR(255) NOT NULL COMMENT 'Quest 또는 평가 제목',
    round_no INT NULL COMMENT '회차 번호',
    task_type VARCHAR(50) NOT NULL COMMENT 'QUEST, EVALUATION, SUBJECT_EVALUATION, MONTHLY_EVALUATION, REQUIRED_LEARNING, DAILY_ASSIGNMENT, ASSIGNMENT',
    description TEXT NULL COMMENT '안내 설명',
    open_at DATETIME NULL COMMENT '시작 시간',
    close_at DATETIME NULL COMMENT '마감 시간',
    total_score INT NULL COMMENT '총점',
    is_required TINYINT(1) NOT NULL DEFAULT 0 COMMENT '필수 여부',
    sort_order INT NOT NULL DEFAULT 0 COMMENT '노출 순서',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    PRIMARY KEY (id),
    KEY idx_course_tasks_course (course_id),
    KEY idx_course_tasks_session (session_id),
    KEY idx_course_tasks_survey (survey_id),
    KEY idx_course_tasks_type_open (task_type, open_at),
    CONSTRAINT fk_course_tasks_course FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    CONSTRAINT fk_course_tasks_session FOREIGN KEY (session_id) REFERENCES course_sessions(id) ON DELETE SET NULL,
    CONSTRAINT fk_course_tasks_survey FOREIGN KEY (survey_id) REFERENCES surveys(id) ON DELETE SET NULL,
    CONSTRAINT chk_course_task_type CHECK (task_type IN ('QUEST', 'EVALUATION', 'SUBJECT_EVALUATION', 'MONTHLY_EVALUATION', 'REQUIRED_LEARNING', 'DAILY_ASSIGNMENT', 'ASSIGNMENT'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='과정 수행 항목';

-- ------------------------------------------------------------
-- 25. user_task_results
-- 사용자별 Quest, 평가, 과제 결과와 점수, 제출 상태를 관리한다.
-- ------------------------------------------------------------
CREATE TABLE user_task_results (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '유저 Quest/평가 결과 식별자',
    task_id BIGINT NOT NULL COMMENT '대상 Quest/평가 ID',
    user_id BIGINT NOT NULL COMMENT '대상 유저 ID',
    result_status VARCHAR(30) NOT NULL DEFAULT 'SCHEDULED' COMMENT 'SCHEDULED, IN_PROGRESS, SUBMITTED, COMPLETED, PASSED, FAILED, CANCELLED, EXPIRED',
    score DECIMAL(6,2) NULL COMMENT '최종 취득 점수',
    original_score DECIMAL(6,2) NULL COMMENT '원점수',
    retake_score DECIMAL(6,2) NULL COMMENT '재평가 점수',
    attempt_count INT NOT NULL DEFAULT 0 COMMENT '응시 또는 제출 횟수',
    answer_data JSON NULL COMMENT '제출 답안 또는 결과 데이터',
    submitted_at DATETIME NULL COMMENT '제출 시간',
    completed_at DATETIME NULL COMMENT '완료 시간',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정 시간',
    PRIMARY KEY (id),
    UNIQUE KEY uk_task_results_task_user (task_id, user_id),
    KEY idx_task_results_user (user_id),
    KEY idx_task_results_status (result_status),
    CONSTRAINT fk_task_results_task FOREIGN KEY (task_id) REFERENCES course_tasks(id) ON DELETE CASCADE,
    CONSTRAINT fk_task_results_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT chk_task_result_status CHECK (result_status IN ('SCHEDULED', 'IN_PROGRESS', 'SUBMITTED', 'COMPLETED', 'PASSED', 'FAILED', 'CANCELLED', 'EXPIRED'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='과제/평가 결과';

-- ------------------------------------------------------------
-- 26. user_activity_records
-- 교육현황 화면에 표시할 SW 역량, SSAFY 활동, 외부 수상 기록을 관리한다.
-- ------------------------------------------------------------
CREATE TABLE user_activity_records (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '유저 활동/성과 기록 식별자',
    user_id BIGINT NOT NULL COMMENT '대상 유저 ID',
    activity_type VARCHAR(50) NOT NULL COMMENT 'SW_COMPETENCY, SSAFY_ACTIVITY, EXTERNAL_AWARD',
    title VARCHAR(200) NOT NULL COMMENT '역량 평가명, 활동명 또는 시상명',
    description TEXT NULL COMMENT '상세 내용',
    organization VARCHAR(200) NULL COMMENT '주관 기관, 평가 기관 또는 활동 조직',
    activity_date DATE NULL COMMENT '활동일 또는 수상일',
    result_text VARCHAR(255) NULL COMMENT 'SW 등급, 순위, 수상 결과 등 표시값',
    evidence_file_id BIGINT NULL COMMENT '증빙 파일 ID',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    PRIMARY KEY (id),
    KEY idx_activity_records_user_date (user_id, activity_date),
    KEY idx_activity_records_type (activity_type),
    KEY idx_activity_records_file (evidence_file_id),
    CONSTRAINT fk_activity_records_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_activity_records_file FOREIGN KEY (evidence_file_id) REFERENCES files(id) ON DELETE SET NULL,
    CONSTRAINT chk_activity_type CHECK (activity_type IN ('SW_COMPETENCY', 'SSAFY_ACTIVITY', 'EXTERNAL_AWARD'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='교육현황 기록';

-- ------------------------------------------------------------
-- 27. inquiries
-- 1:1 문의와 관리자 답변, 처리 상태를 관리한다.
-- ------------------------------------------------------------
CREATE TABLE inquiries (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '문의 식별자',
    user_id BIGINT NOT NULL COMMENT '문의 작성자 ID',
    category VARCHAR(100) NULL COMMENT '문의 유형',
    title VARCHAR(255) NOT NULL COMMENT '문의 제목',
    content TEXT NOT NULL COMMENT '문의 내용',
    status VARCHAR(30) NOT NULL DEFAULT 'WAITING' COMMENT 'WAITING, ANSWERED, CLOSED',
    answer_content TEXT NULL COMMENT '운영자 답변 내용',
    answered_by_id BIGINT NULL COMMENT '답변한 운영자 ID',
    answered_at DATETIME NULL COMMENT '답변일',
    is_deleted TINYINT(1) NOT NULL DEFAULT 0 COMMENT '삭제 여부',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '문의 등록일',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    PRIMARY KEY (id),
    KEY idx_inquiries_user_created (user_id, created_at),
    KEY idx_inquiries_status (status),
    KEY idx_inquiries_answered_by (answered_by_id),
    CONSTRAINT fk_inquiries_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_inquiries_answered_by FOREIGN KEY (answered_by_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT chk_inquiry_status CHECK (status IN ('WAITING', 'ANSWERED', 'CLOSED'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='1:1 문의';

-- ------------------------------------------------------------
-- 28. notifications
-- 사용자별 알림 내용, 읽음 여부, 이동 대상을 관리한다.
-- ------------------------------------------------------------
CREATE TABLE notifications (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '알림 식별자',
    sender_id BIGINT NULL COMMENT '보낸 사람 ID',
    receiver_id BIGINT NOT NULL COMMENT '받는 사람 ID',
    title VARCHAR(255) NOT NULL COMMENT '알림 제목',
    content TEXT NULL COMMENT '알림 내용',
    notification_type VARCHAR(50) NOT NULL COMMENT 'CLASS_NOTICE, USER_NOTICE, SYSTEM, QUEST, MENTORING, ATTENDANCE',
    target_type VARCHAR(100) NULL COMMENT '알림 클릭 시 이동할 대상 타입',
    target_id BIGINT NULL COMMENT '알림 클릭 시 이동할 대상 ID',
    is_important TINYINT(1) NOT NULL DEFAULT 0 COMMENT '필독/중요 알림 여부',
    metadata JSON NULL COMMENT '알림 부가 데이터',
    is_read TINYINT(1) NOT NULL DEFAULT 0 COMMENT '읽음 여부',
    read_at DATETIME NULL COMMENT '읽은 시간',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '보낸 시간',
    PRIMARY KEY (id),
    KEY idx_notifications_receiver_read_created (receiver_id, is_read, created_at),
    KEY idx_notifications_sender (sender_id),
    KEY idx_notifications_type (notification_type),
    KEY idx_notifications_target (target_type, target_id),
    CONSTRAINT fk_notifications_sender FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_notifications_receiver FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT chk_notification_type CHECK (notification_type IN ('CLASS_NOTICE', 'USER_NOTICE', 'SYSTEM', 'QUEST', 'MENTORING', 'ATTENDANCE'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='알림';

-- ------------------------------------------------------------
-- 29. agreements
-- 약관, 개인정보 동의, 운영원칙, 삭제기준 등 동의 항목을 관리한다.
-- ------------------------------------------------------------
CREATE TABLE agreements (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '동의 항목 식별자',
    category VARCHAR(50) NOT NULL COMMENT 'BOARD, SURVEY, MEETUP, EVENT, PRIVACY, MARKETING, ETC',
    target_type VARCHAR(50) NOT NULL DEFAULT 'GLOBAL' COMMENT 'BOARD_CATEGORY, SURVEY, GLOBAL',
    target_id BIGINT NULL COMMENT '동의 연결 대상 ID',
    title VARCHAR(255) NOT NULL COMMENT '동의 제목',
    content_html LONGTEXT NULL COMMENT '동의 내용 HTML',
    attachment_file_id BIGINT NULL COMMENT '첨부파일 ID',
    agreement_type VARCHAR(50) NOT NULL COMMENT 'TERMS, PRIVACY, OPERATION_RULE, DELETE_CRITERIA, MARKETING, ETC',
    version VARCHAR(50) NOT NULL COMMENT '동의 버전',
    is_required TINYINT(1) NOT NULL DEFAULT 0 COMMENT '필수 동의 여부',
    is_active TINYINT(1) NOT NULL DEFAULT 1 COMMENT '현재 사용 여부',
    sort_order INT NOT NULL DEFAULT 0 COMMENT '노출 순서',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    PRIMARY KEY (id),
    KEY idx_agreements_target (target_type, target_id),
    KEY idx_agreements_type_active (agreement_type, is_active),
    KEY idx_agreements_file (attachment_file_id),
    CONSTRAINT fk_agreements_file FOREIGN KEY (attachment_file_id) REFERENCES files(id) ON DELETE SET NULL,
    CONSTRAINT chk_agreement_category CHECK (category IN ('BOARD', 'SURVEY', 'MEETUP', 'EVENT', 'PRIVACY', 'MARKETING', 'ETC')),
    CONSTRAINT chk_agreement_target_type CHECK (target_type IN ('BOARD_CATEGORY', 'SURVEY', 'GLOBAL')),
    CONSTRAINT chk_agreement_type CHECK (agreement_type IN ('TERMS', 'PRIVACY', 'OPERATION_RULE', 'DELETE_CRITERIA', 'MARKETING', 'ETC'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='약관/동의';

-- ------------------------------------------------------------
-- 30. user_agreements
-- 사용자가 어떤 약관 버전에 언제 동의했는지 관리한다.
-- ------------------------------------------------------------
CREATE TABLE user_agreements (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '유저 동의 기록 식별자',
    agreement_id BIGINT NOT NULL COMMENT '동의한 항목 ID',
    user_id BIGINT NOT NULL COMMENT '동의한 유저 ID',
    agreed_version VARCHAR(50) NOT NULL COMMENT '유저가 동의한 버전',
    agreed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '동의 일시',
    ip_address VARCHAR(45) NULL COMMENT '동의 당시 IP',
    user_agent VARCHAR(500) NULL COMMENT '동의 당시 브라우저 정보',
    PRIMARY KEY (id),
    UNIQUE KEY uk_user_agreements_user_agreement_version (user_id, agreement_id, agreed_version),
    KEY idx_user_agreements_agreement (agreement_id),
    CONSTRAINT fk_user_agreements_agreement FOREIGN KEY (agreement_id) REFERENCES agreements(id) ON DELETE CASCADE,
    CONSTRAINT fk_user_agreements_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='사용자 동의 이력';

-- ------------------------------------------------------------
-- 31. password_change_histories
-- 사용자의 비밀번호 변경 이력을 최소 범위로 관리한다.
-- ------------------------------------------------------------
CREATE TABLE password_change_histories (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '비밀번호 변경 이력 식별자',
    user_id BIGINT NOT NULL COMMENT '비밀번호를 변경한 유저 ID',
    changed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '비밀번호 변경 시간',
    ip_address VARCHAR(45) NULL COMMENT '변경 요청 IP',
    user_agent VARCHAR(500) NULL COMMENT '변경 당시 브라우저 정보',
    PRIMARY KEY (id),
    KEY idx_password_histories_user_changed (user_id, changed_at),
    CONSTRAINT fk_password_histories_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='비밀번호 변경 이력';

-- ------------------------------------------------------------
-- 32. audit_logs
-- 관리자 페이지에서 발생한 주요 변경 행위를 기록한다.
-- ------------------------------------------------------------
CREATE TABLE audit_logs (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '로그 식별자',
    actor_id BIGINT NULL COMMENT '행위를 수행한 관리자 ID',
    action VARCHAR(30) NOT NULL COMMENT 'CREATE, UPDATE, DELETE, APPROVE, REJECT, ANSWER, SEND, ADJUST',
    target_type VARCHAR(100) NOT NULL COMMENT '대상 타입',
    target_id BIGINT NULL COMMENT '대상 ID',
    message VARCHAR(500) NULL COMMENT '로그 요약 메시지',
    ip_address VARCHAR(45) NULL COMMENT '요청 IP',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '로그 생성일',
    PRIMARY KEY (id),
    KEY idx_audit_logs_actor_created (actor_id, created_at),
    KEY idx_audit_logs_action_created (action, created_at),
    KEY idx_audit_logs_target (target_type, target_id),
    CONSTRAINT fk_audit_logs_actor FOREIGN KEY (actor_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT chk_audit_action CHECK (action IN ('CREATE', 'UPDATE', 'DELETE', 'APPROVE', 'REJECT', 'ANSWER', 'SEND', 'ADJUST'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='관리자 감사 로그';

-- ------------------------------------------------------------
-- Seed Data
-- 서비스 구조상 처음부터 있어야 하는 기본 데이터만 넣는다.
-- 아래 관리자 계정은 로컬 테스트용이며, 배포 전 삭제하거나 비밀번호를 반드시 변경한다.
-- ------------------------------------------------------------

-- 테스트 관리자 계정
-- 로그인 ID: admin
-- 초기 비밀번호 원문: 0000
-- password 값은 BCrypt 해시다.
INSERT INTO users (
    email,
    password,
    name,
    role,
    status,
    created_at,
    updated_at
) VALUES (
    'admin',
    '$2y$10$AHHy9pCT64EVMtlrAaQISuzbueIborjeIP1x8gPjynAVZHNHito2a',
    '관리자',
    'ADMIN',
    'ACTIVE',
    NOW(),
    NOW()
);

-- 기본 게시판
INSERT INTO boards (name, code, board_type, description) VALUES
('공지사항', 'notice', 'NOTICE', 'HELP DESK 공지사항'),
('FAQ', 'faq', 'FAQ', '자주 묻는 질문'),
('학사규정', 'rule', 'ACADEMIC_RULE', '학사규정 게시판'),
('자유게시판', 'free', 'NORMAL', '교육생 자유게시판'),
('익명게시판', 'anonymity', 'ANONYMOUS', '익명 게시판'),
('서류 제출 안내', 'doc-req', 'NOTICE', '서류 제출 안내 및 첨부파일 게시판'),
('멘토 현황', 'mento-state', 'MENTORING', '멘토 현황 게시판'),
('멘토 Q&A', 'mento-qna', 'MENTORING', '멘토 Q&A 게시판'),
('멘토링 공지사항', 'mento-notice', 'MENTORING', '멘토링 공지사항'),
('간담회 정보', 'meeting-info', 'MEETUP_INFO', '간담회 신청 및 결과 안내 게시판'),
('간담회 후기', 'mento-review', 'MEETUP_REVIEW', '간담회 후기 게시판');

-- 게시판 기본 카테고리
INSERT INTO board_categories (board_id, name, code)
SELECT id, '일반', 'GENERAL' FROM boards;

-- 자주 쓰는 설문/신청 카테고리
INSERT INTO survey_categories (name, code, description) VALUES
('일반 설문', 'SURVEY', '일반 만족도 조사, 의견 수렴 설문'),
('과목 설문', 'SUBJECT_SURVEY', '과목/강의 단위 설문'),
('간담회 신청', 'MEETUP', '간담회 신청 및 참석자 선정'),
('이벤트 신청', 'EVENT', '이벤트, 특강, 기타 신청 폼');

-- 기본 이러닝 카테고리
INSERT INTO learning_categories (parent_id, name, code, category_type) VALUES
(NULL, '전체', 'ROOT', 'ROOT'),
(NULL, '프로그래밍', 'PROGRAMMING', 'MAJOR'),
(NULL, '알고리즘', 'ALGORITHM', 'MAJOR'),
(NULL, '웹', 'WEB', 'MAJOR'),
(NULL, '데이터베이스', 'DATABASE', 'MAJOR'),
(NULL, 'CS', 'CS', 'MAJOR'),
(NULL, '인사/총무/HRD', 'HRD', 'MAJOR');

-- 기본 약관/동의 항목
INSERT INTO agreements (
    category,
    target_type,
    target_id,
    title,
    content_html,
    agreement_type,
    version,
    is_required,
    is_active,
    sort_order
) VALUES
('PRIVACY', 'GLOBAL', NULL, '개인정보 수집 및 이용 동의', '<p>개인정보 수집 및 이용 동의 내용을 입력하세요.</p>', 'PRIVACY', '1.0', 1, 1, 1),
('ETC', 'GLOBAL', NULL, '서비스 이용약관', '<p>서비스 이용약관 내용을 입력하세요.</p>', 'TERMS', '1.0', 1, 1, 2),
('MARKETING', 'GLOBAL', NULL, '광고성 정보 수신 동의', '<p>광고성 정보 수신 동의 내용을 입력하세요.</p>', 'MARKETING', '1.0', 0, 1, 3),
('BOARD', 'BOARD_CATEGORY', (SELECT bc.id FROM board_categories bc JOIN boards b ON b.id = bc.board_id WHERE b.code = 'anonymity' AND bc.code = 'GENERAL' LIMIT 1), '익명게시판 운영원칙', '<p>익명게시판 운영원칙 내용을 입력하세요.</p>', 'OPERATION_RULE', '1.0', 1, 1, 4),
('BOARD', 'GLOBAL', NULL, '게시물 삭제 기준', '<p>게시물 삭제 기준 내용을 입력하세요.</p>', 'DELETE_CRITERIA', '1.0', 0, 1, 5),
('ETC', 'GLOBAL', NULL, '교육생 서약서', '<p>교육생 서약서 내용을 입력하세요.</p>', 'TERMS', '1.0', 1, 1, 6);
