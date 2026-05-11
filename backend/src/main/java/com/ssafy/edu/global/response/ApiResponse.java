package com.ssafy.edu.global.response;

import java.time.Instant;

public class ApiResponse<T> {

    private final boolean success;
    private final T data;
    private final String code;
    private final String message;
    private final Instant timestamp;

    private ApiResponse(boolean success, T data, String code, String message) {
        this.success = success;
        this.data = data;
        this.code = code;
        this.message = message;
        this.timestamp = Instant.now();
    }

    public static <T> ApiResponse<T> ok(T data) {
        return new ApiResponse<>(true, data, null, null);
    }

    public static ApiResponse<Void> error(String code, String message) {
        return new ApiResponse<>(false, null, code, message);
    }

    public boolean isSuccess() { return success; }
    public T getData() { return data; }
    public String getCode() { return code; }
    public String getMessage() { return message; }
    public Instant getTimestamp() { return timestamp; }
}
