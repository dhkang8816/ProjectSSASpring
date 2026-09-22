package com.spring.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.dto.DiagnosticResultVO;
import com.spring.service.SystemDiagnosticsService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/admin/diagnostics")
@RequiredArgsConstructor
public class SystemDiagnosticsController {

    private final SystemDiagnosticsService systemDiagnosticsService;

    @GetMapping
    public String diagnosticsPage() {
        return "admin/diagnostics";
    }

    @GetMapping(value = "/all", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public ResponseEntity<List<DiagnosticResultVO>> diagnoseAll() {
        return ResponseEntity.ok(systemDiagnosticsService.diagnoseAll());
    }
}
