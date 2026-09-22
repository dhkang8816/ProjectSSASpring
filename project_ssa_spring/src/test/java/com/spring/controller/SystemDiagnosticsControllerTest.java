package com.spring.controller;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.http.ResponseEntity;

import com.spring.dto.DiagnosticResultVO;
import com.spring.service.SystemDiagnosticsService;

class SystemDiagnosticsControllerTest {

    @Test
    void diagnosticsEndpointReturnsServiceResultsWithoutStartingAnyAction() {
        SystemDiagnosticsService service = mock(SystemDiagnosticsService.class);
        List<DiagnosticResultVO> expected = List.of(
                new DiagnosticResultVO("spring", "Spring MVC", "PASS", "ok", 1, "2026-09-22T00:00:00Z"));
        when(service.diagnoseAll()).thenReturn(expected);
        SystemDiagnosticsController controller = new SystemDiagnosticsController(service);

        ResponseEntity<List<DiagnosticResultVO>> response = controller.diagnoseAll();

        assertEquals(200, response.getStatusCode().value());
        assertEquals(expected, response.getBody());
        verify(service).diagnoseAll();
    }
}
