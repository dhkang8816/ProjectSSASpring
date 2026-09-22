package com.spring.exception;

public class DroneNotFoundException extends RuntimeException {

	private static final long serialVersionUID = 1L;

    private final String droneId;

    public DroneNotFoundException(String droneId) {
        super("드론 정보를 찾을 수 없습니다.");
        this.droneId = droneId;
    }

    public String getDroneId() {
        return droneId;
    }
}
