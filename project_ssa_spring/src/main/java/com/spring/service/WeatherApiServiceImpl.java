package com.spring.service;

import java.net.URI;
import java.util.Map;

import org.springframework.web.client.RestTemplate;
import org.springframework.web.client.RestClientException;
import org.springframework.web.util.UriComponentsBuilder;

import com.spring.dto.WeatherStatusVO;
import com.spring.exception.ExternalApiException;
import com.spring.exception.InvalidRequestException;

public class WeatherApiServiceImpl implements WeatherApiService {

    private static final String WEATHER_URL =
            "https://api.open-meteo.com/v1/forecast";

    private final RestTemplate restTemplate;


    public WeatherApiServiceImpl() {
        this.restTemplate = new RestTemplate();
    }


    @Override
    @SuppressWarnings("unchecked")
    public WeatherStatusVO getCurrentWeather(
            double latitude,
            double longitude,
            String timezone) throws Exception {

        if (!Double.isFinite(latitude) || !Double.isFinite(longitude)) {
            throw new InvalidRequestException("유효하지 않은 관제지역 좌표입니다.");
        }

        if (timezone == null || timezone.trim().isEmpty()) {
            timezone = "Asia/Seoul";
        }


        URI uri = UriComponentsBuilder
                .fromUriString(WEATHER_URL)

                .queryParam("latitude", latitude)
                .queryParam("longitude", longitude)

                .queryParam(
                        "current",
                        "temperature_2m,"
                      + "relative_humidity_2m,"
                      + "weather_code,"
                      + "wind_speed_10m,"
                      + "shortwave_radiation,"
                      + "direct_normal_irradiance,"
                      + "diffuse_radiation"
                )

                /*
                 * m/s로 바로 반환받는다.
                 */
                .queryParam("wind_speed_unit", "ms")

                .queryParam("timezone", timezone)

                .build()
                .encode()
                .toUri();


        Map<String, Object> response;
        try {
            response = restTemplate.getForObject(uri, Map.class);
        } catch (RestClientException e) {
            throw new ExternalApiException("Open-Meteo",
                    "Open-Meteo request failed.", e);
        }


        if (response == null) {
            throw new ExternalApiException("Open-Meteo",
                    "Open-Meteo returned an empty response.", null);
        }


        Object currentObj = response.get("current");

        if (!(currentObj instanceof Map)) {
            throw new ExternalApiException("Open-Meteo",
                    "Open-Meteo returned an invalid response.", null);
        }


        Map<String, Object> current =
                (Map<String, Object>) currentObj;


        Integer weatherCode =
                getInteger(current.get("weather_code"));


        return WeatherStatusVO.builder()

                .temperature(
                        getDouble(current.get("temperature_2m"))
                )

                .humidity(
                        getDouble(current.get("relative_humidity_2m"))
                )

                .windSpeed(
                        getDouble(current.get("wind_speed_10m"))
                )

                .weatherCode(weatherCode)

                .weatherCondition(
                        getWeatherCondition(weatherCode)
                )

                /*
                 * Solar Radiation
                 */
                .ghi(
                        getDouble(current.get("shortwave_radiation"))
                )

                .dni(
                        getDouble(
                                current.get(
                                        "direct_normal_irradiance"
                                )
                        )
                )

                .dhi(
                        getDouble(current.get("diffuse_radiation"))
                )

                .weatherTime(
                        getString(current.get("time"))
                )

                .build();
    }


    private Double getDouble(Object value) {

        if (value == null) {
            return 0.0;
        }

        if (value instanceof Number) {
            return ((Number) value).doubleValue();
        }

        try {
            return Double.parseDouble(
                    String.valueOf(value)
            );

        } catch (NumberFormatException e) {
            return 0.0;
        }
    }


    private Integer getInteger(Object value) {

        if (value == null) {
            return null;
        }

        if (value instanceof Number) {
            return ((Number) value).intValue();
        }

        try {
            return Integer.parseInt(
                    String.valueOf(value)
            );

        } catch (NumberFormatException e) {
            return null;
        }
    }


    private String getString(Object value) {

        if (value == null) {
            return null;
        }

        return String.valueOf(value);
    }


    /*
     * Open-Meteo WMO Weather Code
     */
    private String getWeatherCondition(Integer code) {

        if (code == null) {
            return "UNKNOWN";
        }

        switch (code) {

        case 0:
            return "맑음";

        case 1:
            return "대체로 맑음";

        case 2:
            return "부분 흐림";

        case 3:
            return "흐림";

        case 45:
        case 48:
            return "안개";

        case 51:
        case 53:
        case 55:
            return "이슬비";

        case 56:
        case 57:
            return "어는 이슬비";

        case 61:
        case 63:
        case 65:
            return "비";

        case 66:
        case 67:
            return "어는 비";

        case 71:
        case 73:
        case 75:
        case 77:
            return "눈";

        case 80:
        case 81:
        case 82:
            return "소나기";

        case 85:
        case 86:
            return "눈 소나기";

        case 95:
            return "뇌우";

        case 96:
        case 99:
            return "우박 동반 뇌우";

        default:
            return "UNKNOWN";
        }
    }
}
