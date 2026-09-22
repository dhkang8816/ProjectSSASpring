package com.spring.mapper;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.io.InputStream;
import java.nio.charset.StandardCharsets;

import org.junit.jupiter.api.Test;

class FlightHistoryMapperXmlTest {

    @Test
    void insertUsesOracleSequenceInsteadOfMaxPlusOne() throws Exception {
        try (InputStream stream = getClass().getClassLoader()
                .getResourceAsStream("com/spring/mybatis/mappers/FlightHistory-Mapper.xml")) {
            assertTrue(stream != null, "FlightHistory mapper must be available on the test classpath");

            String mapperXml = new String(stream.readAllBytes(), StandardCharsets.UTF_8);
            assertTrue(mapperXml.contains("SEQ_FLIGHT_HISTORY.NEXTVAL"));
            assertFalse(mapperXml.contains("MAX(FLIGHT_ID)"));
            assertTrue(mapperXml.contains("START_BATTERY_PERCENT"));
            assertTrue(mapperXml.contains("END_BATTERY_PERCENT"));
            assertTrue(mapperXml.contains("BATTERY_CONSUMPTION"));
        }
    }
}
