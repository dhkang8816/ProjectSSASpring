package com.spring.service;

import java.io.IOException;
import java.nio.file.Path;

@FunctionalInterface
public interface PatrolReportPdfRenderer {

    void render(String reportViewUrl, Path destination) throws IOException;
}
