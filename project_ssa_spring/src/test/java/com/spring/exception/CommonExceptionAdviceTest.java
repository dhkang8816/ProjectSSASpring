package com.spring.exception;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertInstanceOf;
import static org.junit.jupiter.api.Assertions.assertNotNull;

import org.junit.jupiter.api.Test;
import org.springframework.dao.DataAccessResourceFailureException;
import org.springframework.http.ResponseEntity;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

class CommonExceptionAdviceTest {

    private final CommonExceptionAdvice advice = new CommonExceptionAdvice();

    @Test
    void droneNotFoundReturnsSafeJson404ForAjax() {
        MockHttpServletRequest request = ajaxRequest("/project_ssa_spring/drone/detail");

        ResponseEntity<?> response = assertInstanceOf(ResponseEntity.class,
                advice.handleDroneNotFound(new DroneNotFoundException("UNKNOWN"), request));
        ErrorResponseVO body = assertInstanceOf(ErrorResponseVO.class, response.getBody());

        assertEquals(404, response.getStatusCode().value());
        assertFalse(body.isSuccess());
        assertEquals("DRONE_NOT_FOUND", body.getCode());
        assertNotNull(body.getMessage());
    }

    @Test
    void externalApiFailureReturnsSafeJson502WithoutCauseText() {
        MockHttpServletRequest request = jsonRequest("/project_ssa_spring/yolo/environment/weather");

        ResponseEntity<?> response = assertInstanceOf(ResponseEntity.class,
                advice.handleExternalApi(new ExternalApiException("Open-Meteo",
                        "connection to private endpoint failed", new RuntimeException("secret")), request));
        ErrorResponseVO body = assertInstanceOf(ErrorResponseVO.class, response.getBody());

        assertEquals(502, response.getStatusCode().value());
        assertEquals("EXTERNAL_API_ERROR", body.getCode());
        assertFalse(body.getMessage().contains("private"));
        assertFalse(body.getMessage().contains("secret"));
    }

    @Test
    void dataAccessFailureReturnsSafeJson500() {
        MockHttpServletRequest request = jsonRequest("/project_ssa_spring/api/example");

        ResponseEntity<?> response = assertInstanceOf(ResponseEntity.class,
                advice.handleDatabaseException(new DataAccessResourceFailureException("ORA-99999"), request));
        ErrorResponseVO body = assertInstanceOf(ErrorResponseVO.class, response.getBody());

        assertEquals(500, response.getStatusCode().value());
        assertEquals("DATABASE_ERROR", body.getCode());
        assertFalse(body.getMessage().contains("ORA-"));
    }

    @Test
    void regularPageFailureUsesCommonErrorViewWithoutExceptionObject() {
        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/project_ssa_spring/drone/detail");

        ModelAndView response = assertInstanceOf(ModelAndView.class,
                advice.handleCommonException(new RuntimeException("internal path"), request));

        assertEquals("error/errorCommon", response.getViewName());
        assertEquals(500, response.getStatus().value());
        assertNotNull(response.getModel().get("errorMsg"));
        assertFalse(response.getModel().containsKey("exception"));
    }

    private MockHttpServletRequest ajaxRequest(String uri) {
        MockHttpServletRequest request = new MockHttpServletRequest("GET", uri);
        request.addHeader("X-Requested-With", "XMLHttpRequest");
        return request;
    }

    private MockHttpServletRequest jsonRequest(String uri) {
        MockHttpServletRequest request = new MockHttpServletRequest("GET", uri);
        request.setContextPath("/project_ssa_spring");
        request.addHeader("Accept", "application/json");
        return request;
    }
}
