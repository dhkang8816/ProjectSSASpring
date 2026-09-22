package com.spring.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.List;

import javax.sql.DataSource;

import org.junit.jupiter.api.Test;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.spring.dto.DiagnosticResultVO;
import com.spring.dto.EnvironmentVO;

class SystemDiagnosticsServiceTest {

    @Test
    void diagnoseAllUsesReadOnlyBoundariesAndSummarizesHealthyCachedServices() throws Exception {
        DataSource dataSource = mock(DataSource.class);
        Connection connection = mock(Connection.class);
        Statement statement = mock(Statement.class);
        ResultSet resultSet = mock(ResultSet.class);
        EnvironmentService environmentService = mock(EnvironmentService.class);

        when(dataSource.getConnection()).thenReturn(connection);
        when(connection.createStatement()).thenReturn(statement);
        when(statement.executeQuery("SELECT 1 FROM DUAL")).thenReturn(resultSet);
        when(resultSet.next()).thenReturn(true);
        when(environmentService.getEnvironment()).thenReturn(EnvironmentVO.builder()
                .latitude(37.5665).longitude(126.9780).timezone("Asia/Seoul").build());

        String flaskHealth = "{" 
                + "\"sources\":{\"video_1\":{\"running\":true}},"
                + "\"sensor\":{\"sensorOnline\":true,\"workerRunning\":true},"
                + "\"buzzer\":{\"enabled\":true,\"workerRunning\":true},"
                + "\"discord\":{\"configured\":true,\"workerRunning\":true}" 
                + "}";
        DiagnosticsHttpClient httpClient = url -> url.endsWith("/health") ? flaskHealth : "{}";
        SystemDiagnosticsService service = new SystemDiagnosticsService(
                dataSource, environmentService, new ObjectMapper(), httpClient);

        List<DiagnosticResultVO> results = service.diagnoseAll();

        assertEquals(10, results.size());
        assertEquals("PASS", find(results, "oracle").getStatus());
        assertEquals("PASS", find(results, "yolo").getStatus());
        assertEquals("PASS", find(results, "sensor").getStatus());
        assertEquals("PASS", find(results, "buzzer").getStatus());
        assertEquals("PASS", find(results, "discord").getStatus());
        verify(statement).executeQuery("SELECT 1 FROM DUAL");
        verify(environmentService).getEnvironment();
    }

    @Test
    void diagnoseAllMarksDependentServicesFailedWhenFlaskHealthIsUnavailable() throws Exception {
        DataSource dataSource = mock(DataSource.class);
        Connection connection = mock(Connection.class);
        Statement statement = mock(Statement.class);
        ResultSet resultSet = mock(ResultSet.class);
        EnvironmentService environmentService = mock(EnvironmentService.class);

        when(dataSource.getConnection()).thenReturn(connection);
        when(connection.createStatement()).thenReturn(statement);
        when(statement.executeQuery(anyString())).thenReturn(resultSet);
        when(resultSet.next()).thenReturn(true);
        when(environmentService.getEnvironment()).thenReturn(null);

        SystemDiagnosticsService service = new SystemDiagnosticsService(
                dataSource, environmentService, new ObjectMapper(), url -> {
                    if (url.endsWith("/health")) {
                        throw new java.io.IOException("Flask offline");
                    }
                    return "{}";
                });

        List<DiagnosticResultVO> results = service.diagnoseAll();

        assertEquals("FAIL", find(results, "flask").getStatus());
        assertEquals("FAIL", find(results, "yolo").getStatus());
        assertEquals("FAIL", find(results, "sensor").getStatus());
        assertEquals("WARN", find(results, "weather").getStatus());
        assertTrue(find(results, "flask").getMessage().contains("연결"));
    }

    private DiagnosticResultVO find(List<DiagnosticResultVO> results, String id) {
        return results.stream().filter(result -> id.equals(result.getId())).findFirst().orElseThrow();
    }
}
