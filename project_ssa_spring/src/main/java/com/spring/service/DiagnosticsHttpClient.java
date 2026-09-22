package com.spring.service;

import java.io.IOException;

/** Small injectable boundary so diagnostics tests never make real HTTP calls. */
@FunctionalInterface
interface DiagnosticsHttpClient {

    String get(String url) throws IOException;
}
