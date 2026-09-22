package com.spring.service;

import java.util.List;

import com.spring.dto.EnvironmentVO;

public interface GeocodingService {

    List<EnvironmentVO> searchLocation(String keyword) throws Exception;

}