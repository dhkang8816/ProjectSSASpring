package com.spring.util;


public final class RuntimeSettings {

    private RuntimeSettings() {
    }

    public static String text(String name, String defaultValue) {
        String value = System.getProperty(name);
        if (value == null || value.trim().isEmpty()) {
            value = System.getenv(name);
        }
        return (value == null || value.trim().isEmpty()) ? defaultValue : value.trim();
    }

    public static int positiveInt(String name, int defaultValue) {
        try {
            int value = Integer.parseInt(text(name, String.valueOf(defaultValue)));
            return value > 0 ? value : defaultValue;
        } catch (NumberFormatException ignored) {
            return defaultValue;
        }
    }

    public static boolean enabled(String name, boolean defaultValue) {
        String value = text(name, String.valueOf(defaultValue));
        if ("true".equalsIgnoreCase(value)) {
            return true;
        }
        if ("false".equalsIgnoreCase(value)) {
            return false;
        }
        return defaultValue;
    }
    
    public static String kakaoRestApiKey() {
        return text("KAKAO_REST_API_KEY", "");
    }
}
