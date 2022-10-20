package com.ssafy.dokcho2.dto.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum ErrorCode {
    USER_NOT_FOUND(404, "U001", "회원 정보를 찾을 수 없습니다."),
    DUPLICATE_EMAIL(400, "U002", "이미 존재하는 이메일입니다."),
    DUPLICATE_NICKNAME(400, "U003", "이미 존재하는 닉네임입니다."),
    DUPLICATE_USERNAME(400, "U004", "이미 존재하는 계정입니다."),
    INVALID_PARAMETER(400, "X001", "잘못된 요청입니다."),
    MISSION_NOT_FOUND(404, "M001", "미션 정보를 찾을 수 없습니다.");

    private final int status;
    private final String code;
    private final String message;
}
