package com.spring.service;

import com.spring.dto.SpaceWeatherStatusVO;

public interface SpaceWeatherService {

    SpaceWeatherStatusVO getCurrentSpaceWeather()
            throws Exception;
}