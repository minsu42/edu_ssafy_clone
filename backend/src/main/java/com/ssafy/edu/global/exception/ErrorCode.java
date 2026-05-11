package com.ssafy.edu.global.exception;

import org.springframework.http.HttpStatus;

public enum ErrorCode {

    RESOURCE_NOT_FOUND("ERR-CMN-001", "리소스를 찾을 수 없습니다", HttpStatus.NOT_FOUND),
    ACCESS_DENIED("ERR-CMN-002", "접근 권한이 없습니다", HttpStatus.FORBIDDEN),
    INVALID_REQUEST("ERR-CMN-003", "잘못된 요청입니다", HttpStatus.BAD_REQUEST),

    INVALID_CREDENTIALS("ERR-AUTH-001", "이메일 또는 비밀번호가 올바르지 않습니다", HttpStatus.UNAUTHORIZED),
    ACCOUNT_INACTIVE("ERR-AUTH-002", "비활성 또는 탈퇴 계정입니다", HttpStatus.FORBIDDEN),
    TOKEN_EXPIRED("ERR-AUTH-003", "토큰이 만료되었습니다", HttpStatus.UNAUTHORIZED),
    TOKEN_INVALID("ERR-AUTH-004", "유효하지 않은 토큰입니다", HttpStatus.UNAUTHORIZED),
    PASSWORD_MISMATCH("ERR-AUTH-005", "현재 비밀번호가 올바르지 않습니다", HttpStatus.BAD_REQUEST),

    QUEST_CLOSED("ERR-QUEST-001", "Quest 제출 기간이 종료되었습니다", HttpStatus.BAD_REQUEST),
    QUEST_ALREADY_SUBMITTED("ERR-QUEST-002", "이미 제출된 Quest입니다", HttpStatus.CONFLICT),

    BOARD_NOT_FOUND("ERR-BOARD-001", "게시글을 찾을 수 없습니다", HttpStatus.NOT_FOUND),
    BOARD_ACCESS_DENIED("ERR-BOARD-002", "게시글 수정/삭제 권한이 없습니다", HttpStatus.FORBIDDEN),

    SURVEY_CLOSED("ERR-SURVEY-001", "설문이 마감되었습니다", HttpStatus.BAD_REQUEST),
    SURVEY_CAPACITY_EXCEEDED("ERR-SURVEY-002", "설문 정원이 초과되었습니다", HttpStatus.CONFLICT);

    private final String code;
    private final String message;
    private final HttpStatus status;

    ErrorCode(String code, String message, HttpStatus status) {
        this.code = code;
        this.message = message;
        this.status = status;
    }

    public String getCode() { return code; }
    public String getMessage() { return message; }
    public HttpStatus getStatus() { return status; }
}
