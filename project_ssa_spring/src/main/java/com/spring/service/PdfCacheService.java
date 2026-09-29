package com.spring.service;

import java.nio.file.Path;

public interface PdfCacheService {

    Path getOrCreatePatrolReportPdf(Long reportId, String renderOrigin);

    boolean isValidInternalRenderToken(Long reportId, String token);
}
