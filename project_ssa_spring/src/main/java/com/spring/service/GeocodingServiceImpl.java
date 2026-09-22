package com.spring.service;

import java.net.URI;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.spring.dto.EnvironmentVO;
import com.spring.exception.ExternalApiException;
import com.spring.exception.InvalidRequestException;
import com.spring.util.RuntimeSettings;

/** Converts Kakao Local keyword-search results to {@link EnvironmentVO}. */
public class GeocodingServiceImpl implements GeocodingService {

    private static final String KAKAO_LOCAL_URL =
            "https://dapi.kakao.com/v2/local/search/keyword.json";
    private static final int SEARCH_RESULT_SIZE = 10;

    private final RestTemplate restTemplate;

    public GeocodingServiceImpl() {
        this.restTemplate = new RestTemplate();
    }

    @Override
    public List<EnvironmentVO> searchLocation(String keyword) throws Exception {
        if (keyword == null || keyword.trim().isEmpty()) {
            throw new InvalidRequestException("검색어를 입력해 주세요.");
        }

        String apiKey = RuntimeSettings.kakaoRestApiKey();
        if (apiKey.isEmpty()) {
            throw new ExternalApiException("Kakao Local API",
                    "Kakao Local API is not configured.", null);
        }

        URI uri = UriComponentsBuilder.fromUriString(KAKAO_LOCAL_URL)
                .queryParam("query", keyword.trim())
                .queryParam("size", SEARCH_RESULT_SIZE)
                .build()
                .encode()
                .toUri();

        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "KakaoAK " + apiKey);
        HttpEntity<Void> request = new HttpEntity<>(headers);

        try {
            ResponseEntity<Map<String, Object>> response = restTemplate.exchange(
                    uri,
                    HttpMethod.GET,
                    request,
                    new ParameterizedTypeReference<Map<String, Object>>() { });
            Map<String, Object> body = response.getBody();
            Object documents = body == null ? null : body.get("documents");
            if (!(documents instanceof List<?>)) {
                throw new ExternalApiException("Kakao Local API",
                        "Kakao Local API returned an invalid response.", null);
            }
            return toEnvironmentList((List<?>) documents);
        } catch (ExternalApiException e) {
            throw e;
        } catch (RestClientException e) {
            throw new ExternalApiException("Kakao Local API",
                    "Kakao Local API request failed.", e);
        }
    }

    @SuppressWarnings("unchecked")
    private List<EnvironmentVO> toEnvironmentList(List<?> documents) {
        List<EnvironmentVO> resultList = new ArrayList<>();
        for (Object document : documents) {
            if (!(document instanceof Map<?, ?>)) {
                continue;
            }
            Map<String, Object> item = (Map<String, Object>) document;
            Double longitude = parseCoordinate(item.get("x"));
            Double latitude = parseCoordinate(item.get("y"));
            if (longitude == null || latitude == null) {
                continue;
            }

            String placeName = getString(item.get("place_name"));
            String address = firstNonBlank(
                    getString(item.get("road_address_name")),
                    getString(item.get("address_name")),
                    placeName);

            EnvironmentVO environment = new EnvironmentVO();
            environment.setLocationName(firstNonBlank(placeName, address));
            environment.setAddress(address);
            environment.setLatitude(latitude);
            environment.setLongitude(longitude);
            environment.setTimezone("Asia/Seoul");
            resultList.add(environment);
        }
        return resultList;
    }

    private Double parseCoordinate(Object value) {
        String text = getString(value);
        if (text == null || text.trim().isEmpty()) {
            return null;
        }
        try {
            return Double.parseDouble(text.trim());
        } catch (NumberFormatException ignored) {
            return null;
        }
    }

    private String firstNonBlank(String... values) {
        for (String value : values) {
            if (value != null && !value.trim().isEmpty()) {
                return value.trim();
            }
        }
        return "";
    }

    private String getString(Object value) {
        return value == null ? null : String.valueOf(value);
    }
}
