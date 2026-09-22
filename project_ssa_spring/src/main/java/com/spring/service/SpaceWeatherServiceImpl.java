package com.spring.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.client.RestTemplate;

import com.spring.dto.SpaceWeatherStatusVO;

public class SpaceWeatherServiceImpl implements SpaceWeatherService {

    private static final String SOLAR_WIND_SPEED_URL =
            "https://services.swpc.noaa.gov/products/summary/solar-wind-speed.json";

    private static final String SOLAR_WIND_MAG_URL =
            "https://services.swpc.noaa.gov/products/summary/solar-wind-mag-field.json";

    private static final String KP_INDEX_URL =
            "https://services.swpc.noaa.gov/products/noaa-planetary-k-index.json";

    private static final String NOAA_SCALES_URL =
            "https://services.swpc.noaa.gov/products/noaa-scales.json";


    private final RestTemplate restTemplate;


    public SpaceWeatherServiceImpl() {
        this.restTemplate = new RestTemplate();
    }


    @Override
    public SpaceWeatherStatusVO getCurrentSpaceWeather()
            throws Exception {

        Double solarWindSpeed = 0.0;
        Double bz = 0.0;
        Double kp = 0.0;

        String gScale = "G0";
        String rScale = "R0";
        String sScale = "S0";

        String solarWindTime = null;
        String kpTime = null;
        String scaleTime = null;


        try {

        	Object response =
        	        restTemplate.getForObject(
        	                SOLAR_WIND_SPEED_URL,
        	                Object.class
        	        );

        	if (response instanceof List<?>) {

        	    List<?> list = (List<?>) response;

        	    if (!list.isEmpty()
        	            && list.get(0) instanceof Map<?, ?>) {

        	        Map<?, ?> data =
        	                (Map<?, ?>) list.get(0);

        	        solarWindSpeed =
        	                getDouble(
        	                        data.get("proton_speed")
        	                );

        	        solarWindTime =
        	                getString(
        	                        data.get("time_tag")
        	                );
        	    }
        	}

        } catch (Exception e) {

        }


        try {

        	Object response =
        	        restTemplate.getForObject(
        	                SOLAR_WIND_MAG_URL,
        	                Object.class
        	        );

        	if (response instanceof List<?>) {

        	    List<?> list = (List<?>) response;

        	    if (!list.isEmpty()
        	            && list.get(0) instanceof Map<?, ?>) {

        	        Map<?, ?> data =
        	                (Map<?, ?>) list.get(0);

        	        bz =
        	                getDouble(
        	                        data.get("bz_gsm")
        	                );

        	        if (solarWindTime == null) {
        	            solarWindTime =
        	                    getString(
        	                            data.get("time_tag")
        	                    );
        	        }
        	    }
        	}

        } catch (Exception e) {

        }

        try {

            Object response =
                    restTemplate.getForObject(
                            KP_INDEX_URL,
                            Object.class
                    );

            KpResult kpResult =
                    extractLatestKp(response);

            if (kpResult != null) {

                kp = kpResult.kp;
                kpTime = kpResult.time;
            }

        } catch (Exception e) {

        }

        try {

            Object response =
                    restTemplate.getForObject(
                            NOAA_SCALES_URL,
                            Object.class
                    );

            if (response instanceof Map<?, ?>) {

                Map<?, ?> root =
                        (Map<?, ?>) response;

                Object currentObj =
                        root.get("0");

                if (!(currentObj instanceof Map<?, ?>)) {
                    currentObj = root.get("-1");
                }


                if (currentObj instanceof Map<?, ?>) {

                    Map<?, ?> current =
                            (Map<?, ?>) currentObj;


                    gScale = extractScale(
                            current.get("G"),
                            "G"
                    );

                    rScale = extractScale(
                            current.get("R"),
                            "R"
                    );

                    sScale = extractScale(
                            current.get("S"),
                            "S"
                    );


                    String date =
                            getString(
                                    current.get("DateStamp")
                            );

                    String time =
                            getString(
                                    current.get("TimeStamp")
                            );


                    if (date != null && time != null) {

                        scaleTime =
                                date + " " + time;

                    } else if (time != null) {

                        scaleTime = time;

                    } else {

                        scaleTime = date;
                    }
                }
            }

        } catch (Exception e) {

        }

        return SpaceWeatherStatusVO.builder()

                .solarWindSpeed(solarWindSpeed)

                .bz(bz)

                .kp(kp)

                .gScale(gScale)

                .rScale(rScale)

                .sScale(sScale)

                .solarWindTime(solarWindTime)

                .kpTime(kpTime)

                .scaleTime(scaleTime)

                .build();
    }

    private String extractScale(
            Object scaleObject,
            String prefix) {

        if (!(scaleObject instanceof Map<?, ?>)) {
            return prefix + "0";
        }


        Map<?, ?> scaleMap =
                (Map<?, ?>) scaleObject;


        String scale =
                getString(
                        scaleMap.get("Scale")
                );


        if (scale == null
                || scale.trim().isEmpty()) {

            return prefix + "0";
        }


        return prefix + scale.trim();
    }

    private KpResult extractLatestKp(
            Object response) {

        if (!(response instanceof List<?>)) {
            return null;
        }


        List<?> list =
                (List<?>) response;


        if (list.isEmpty()) {
            return null;
        }

        KpResult latest = null;


        for (Object item : list) {

            if (!(item instanceof Map<?, ?>)) {
                continue;
            }


            Map<?, ?> row =
                    (Map<?, ?>) item;


            Double kp =
                    getNullableDouble(
                            row.get("Kp")
                    );


            String time =
                    getString(
                            row.get("time_tag")
                    );


            if (kp == null) {
                continue;
            }

            if (latest == null) {

                latest =
                        new KpResult(
                                kp,
                                time
                        );

            } else if (time != null
                    && (latest.time == null
                    || time.compareTo(latest.time) > 0)) {

                latest =
                        new KpResult(
                                kp,
                                time
                        );
            }
        }


        if (latest != null) {
            return latest;
        }

        for (int i = list.size() - 1; i >= 0; i--) {

            Object item =
                    list.get(i);


            if (!(item instanceof List<?>)) {
                continue;
            }


            List<?> row =
                    (List<?>) item;


            if (row.size() < 2) {
                continue;
            }


            String time =
                    getString(
                            row.get(0)
                    );


            Double kp =
                    getNullableDouble(
                            row.get(1)
                    );


            if (kp != null) {

                return new KpResult(
                        kp,
                        time
                );
            }
        }


        return null;
    }


    private Double getDouble(
            Object value) {

        Double result =
                getNullableDouble(value);

        return result == null
                ? 0.0
                : result;
    }


    private Double getNullableDouble(
            Object value) {

        if (value == null) {
            return null;
        }


        if (value instanceof Number) {

            return ((Number) value)
                    .doubleValue();
        }


        try {

            return Double.parseDouble(
                    String.valueOf(value)
                            .trim()
            );

        } catch (NumberFormatException e) {

            return null;
        }
    }


    private String getString(
            Object value) {

        if (value == null) {
            return null;
        }


        String result =
                String.valueOf(value)
                        .trim();


        return result.isEmpty()
                ? null
                : result;
    }

    private static class KpResult {

        private final Double kp;
        private final String time;


        private KpResult(
                Double kp,
                String time) {

            this.kp = kp;
            this.time = time;
        }
    }
    
    
}