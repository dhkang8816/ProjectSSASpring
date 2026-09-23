package com.spring.exception;

import java.sql.SQLException;

import org.mybatis.spring.MyBatisSystemException;
import org.springframework.dao.DataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.log4j.Log4j2;

/**
 * One safe error boundary for MVC and AJAX requests. Security filter failures
 * are intentionally handled by Spring Security's existing handlers.
 */
@Log4j2
@ControllerAdvice
public class CommonExceptionAdvice {

    /**
     * Handles ownership checks performed inside MVC controllers. Security-filter
     * authentication and authorization failures still use CustomDeniedHandler.
     */
    @ExceptionHandler(AccessDeniedException.class)
    public Object handleAccessDenied(AccessDeniedException e, HttpServletRequest request) {
        log.warn("Access denied by controller ownership check. requestUri={}", request.getRequestURI());
        return errorResponse(request, HttpStatus.FORBIDDEN, "ACCESS_DENIED", "접근 권한이 없습니다.");
    }

    @ExceptionHandler(MemberNotFoundException.class)
    public Object handleMemberNotFound(MemberNotFoundException e, HttpServletRequest request) {
        log.warn("Member not found. requestUri={}, memberId={}", request.getRequestURI(), e.getMemberId());
        return errorResponse(request, HttpStatus.NOT_FOUND, "MEMBER_NOT_FOUND", e.getMessage());
    }

    @ExceptionHandler(DroneNotFoundException.class)
    public Object handleDroneNotFound(DroneNotFoundException e, HttpServletRequest request) {
        log.warn("Drone not found. requestUri={}, droneId={}", request.getRequestURI(), e.getDroneId());
        return errorResponse(request, HttpStatus.NOT_FOUND, "DRONE_NOT_FOUND", e.getMessage());
    }

    @ExceptionHandler(DetectionNotFoundException.class)
    public Object handleDetectionNotFound(DetectionNotFoundException e, HttpServletRequest request) {
        log.warn("Detection log not found. requestUri={}, detectionLogId={}",
                request.getRequestURI(), e.getDetectionLogId());
        return errorResponse(request, HttpStatus.NOT_FOUND, "DETECTION_NOT_FOUND", e.getMessage());
    }

    @ExceptionHandler(InvalidRequestException.class)
    public Object handleInvalidRequest(InvalidRequestException e, HttpServletRequest request) {
        log.warn("Invalid request. requestUri={}", request.getRequestURI());
        return errorResponse(request, HttpStatus.BAD_REQUEST, "INVALID_REQUEST", e.getMessage());
    }

    @ExceptionHandler(ExternalApiException.class)
    public Object handleExternalApi(ExternalApiException e, HttpServletRequest request) {
        log.error("External API request failed. requestUri={}, service={}",
                request.getRequestURI(), e.getServiceName(), e);
        return errorResponse(request, HttpStatus.BAD_GATEWAY, "EXTERNAL_API_ERROR",
                "외부 서비스와 통신 중 오류가 발생했습니다.");
    }

    @ExceptionHandler(FlaskConnectionException.class)
    public Object handleFlaskConnection(FlaskConnectionException e, HttpServletRequest request) {
        log.error("Flask connection failed. requestUri={}", request.getRequestURI(), e);
        return errorResponse(request, HttpStatus.SERVICE_UNAVAILABLE, "FLASK_CONNECTION_ERROR",
                "YOLO 서버에 연결할 수 없습니다.");
    }

    @ExceptionHandler(SensorUnavailableException.class)
    public Object handleSensorUnavailable(SensorUnavailableException e, HttpServletRequest request) {
        log.warn("Sensor unavailable. requestUri={}", request.getRequestURI());
        return errorResponse(request, HttpStatus.SERVICE_UNAVAILABLE, "SENSOR_UNAVAILABLE",
                "센서 데이터를 가져올 수 없습니다.");
    }

    @ExceptionHandler({SnapshotException.class, FileUploadException.class, EmptyMultipartFileException.class})
    public Object handleFile(Exception e, HttpServletRequest request) {
        log.error("File operation failed. requestUri={}", request.getRequestURI(), e);
        return errorResponse(request, HttpStatus.BAD_REQUEST, "SNAPSHOT_ERROR",
                "파일을 처리하지 못했습니다. 다시 시도해 주세요.");
    }

    @ExceptionHandler({DataAccessException.class, MyBatisSystemException.class, SQLException.class})
    public Object handleDatabaseException(Exception e, HttpServletRequest request) {
        log.error("Database operation failed. requestUri={}", request.getRequestURI(), e);
        return errorResponse(request, HttpStatus.INTERNAL_SERVER_ERROR, "DATABASE_ERROR",
                "데이터 처리 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
    }

    @ExceptionHandler(Exception.class)
    public Object handleCommonException(Exception e, HttpServletRequest request) {
        log.error("Unexpected application error. requestUri={}", request.getRequestURI(), e);
        return errorResponse(request, HttpStatus.INTERNAL_SERVER_ERROR, "INTERNAL_ERROR",
                "요청을 처리하지 못했습니다. 잠시 후 다시 시도해 주세요.");
    }

    private Object errorResponse(HttpServletRequest request, HttpStatus status,
            String code, String message) {
        if (isAjaxRequest(request)) {
            return ResponseEntity.status(status).body(new ErrorResponseVO(code, message));
        }

        ModelAndView mav = new ModelAndView("error/errorCommon");
        mav.setStatus(status);
        mav.addObject("errorMsg", message);
        return mav;
    }

    private boolean isAjaxRequest(HttpServletRequest request) {
        String accept = request.getHeader("Accept");
        String requestedWith = request.getHeader("X-Requested-With");
        String requestUri = request.getRequestURI();

        return "XMLHttpRequest".equalsIgnoreCase(requestedWith)
                || (accept != null && accept.contains("application/json"))
                || requestUri.startsWith(request.getContextPath() + "/api/")
                || requestUri.startsWith(request.getContextPath() + "/yolo/environment/")
                || requestUri.startsWith(request.getContextPath() + "/admin/diagnostics/");
    }
}
