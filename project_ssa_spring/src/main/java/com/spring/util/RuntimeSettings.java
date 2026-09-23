package com.spring.util;

import java.net.URI;


public final class RuntimeSettings {

    private static final String DEFAULT_DISCORD_INVITE_URL = "https://discord.gg/BGNDuq5Pm8";

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

    public static String discordInviteUrl() {
        String configuredUrl = text("SSA_DISCORD_INVITE_URL", DEFAULT_DISCORD_INVITE_URL);
        try {
            URI uri = URI.create(configuredUrl);
            String host = uri.getHost();
            boolean isDiscordHost = "discord.gg".equalsIgnoreCase(host)
                    || "www.discord.gg".equalsIgnoreCase(host)
                    || "discord.com".equalsIgnoreCase(host)
                    || "www.discord.com".equalsIgnoreCase(host);
            if ("https".equalsIgnoreCase(uri.getScheme()) && isDiscordHost) {
                return uri.toString();
            }
        } catch (IllegalArgumentException ignored) {
            // A malformed deployment setting must not render an unsafe sidebar link.
        }
        return DEFAULT_DISCORD_INVITE_URL;
    }
}
