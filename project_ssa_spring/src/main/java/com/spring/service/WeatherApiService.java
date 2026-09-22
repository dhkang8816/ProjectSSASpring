package com.spring.service;

import com.spring.dto.WeatherStatusVO;

public interface WeatherApiService {

    WeatherStatusVO getCurrentWeather(
            double latitude,
            double longitude,
            String timezone) throws Exception;
}