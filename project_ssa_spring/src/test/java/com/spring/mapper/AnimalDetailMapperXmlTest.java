package com.spring.mapper;

import static org.junit.jupiter.api.Assertions.assertTrue;

import java.io.InputStream;
import java.nio.charset.StandardCharsets;

import org.junit.jupiter.api.Test;

class AnimalDetailMapperXmlTest {

    @Test
    void animalPictureIsMappedForReadInsertAndModify() throws Exception {
        try (InputStream stream = getClass().getClassLoader()
                .getResourceAsStream("com/spring/mybatis/mappers/AnimalDetail-Mapper.xml")) {
            assertTrue(stream != null, "Animal detail mapper must be available on the test classpath");

            String mapperXml = new String(stream.readAllBytes(), StandardCharsets.UTF_8);
            assertTrue(mapperXml.contains("property=\"animalPicture\" column=\"ANIMAL_PICTURE\""));
            assertTrue(mapperXml.contains("ANIMAL_STATUS, ANIMAL_PICTURE"));
            assertTrue(mapperXml.contains("NVL(#{animalPicture, jdbcType=VARCHAR}, 'noImage.jpg')"));
            assertTrue(mapperXml.contains("ANIMAL_PICTURE = NVL(#{animalPicture, jdbcType=VARCHAR}, 'noImage.jpg')"));
        }
    }
}
