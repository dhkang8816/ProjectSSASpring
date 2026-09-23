package com.spring.util;

import static org.junit.jupiter.api.Assertions.assertArrayEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.nio.file.Files;
import java.nio.file.Path;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;
import org.springframework.mock.web.MockMultipartFile;

class MultipartFileUploadTest {

    @TempDir
    Path temporaryDirectory;

    @Test
    void savesAllowedImageWithServerGeneratedFileName() throws Exception {
        byte[] imageBytes = { 1, 2, 3 };
        MockMultipartFile image = new MockMultipartFile(
                "pictureFile", "../../dog.jpg", "image/jpeg", imageBytes);

        String savedName = MultipartFileUpload.saveImageFile(temporaryDirectory.toString(), image);

        assertTrue(savedName.matches("^[0-9a-f]{32}\\.jpg$"));
        assertArrayEquals(imageBytes, Files.readAllBytes(temporaryDirectory.resolve(savedName)));
    }

    @Test
    void rejectsNonImageExtensionAndContentType() {
        MockMultipartFile executable = new MockMultipartFile(
                "pictureFile", "script.exe", "application/octet-stream", new byte[] { 1 });

        assertThrows(IllegalArgumentException.class,
                () -> MultipartFileUpload.saveImageFile(temporaryDirectory.toString(), executable));
    }
}
