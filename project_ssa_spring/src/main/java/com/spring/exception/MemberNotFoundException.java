package com.spring.exception;

public class MemberNotFoundException extends RuntimeException {

	private static final long serialVersionUID = 1L;

    private final String memberId;

    public MemberNotFoundException(String memberId) {
        super("회원 정보를 찾을 수 없습니다.");
        this.memberId = memberId;
    }

    public String getMemberId() {
        return memberId;
    }
}
