package com.spring.controller;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.spring.util.RuntimeSettings;

@ControllerAdvice
public class NavigationModelAdvice {

    @ModelAttribute("discordInviteUrl")
    public String discordInviteUrl() {
        return RuntimeSettings.discordInviteUrl();
    }
}
