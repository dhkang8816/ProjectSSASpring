package com.spring.util;

import java.io.File;
import java.io.IOException;
import java.util.Locale;
import java.util.UUID;

import org.springframework.web.multipart.MultipartFile;

import com.spring.exception.EmptyMultipartFileException;

public class MultipartFileUpload {

	private static final String[] ALLOWED_IMAGE_EXTENSIONS = { "jpg", "jpeg", "png" };

	public static String saveFile(String uploadPath, MultipartFile multi)
			throws EmptyMultipartFileException, IllegalStateException, IOException {

		if (multi == null || multi.isEmpty()) {
			throw new EmptyMultipartFileException();
		}
		String uuid = UUID.randomUUID().toString().replace("-", "");
		String fileName = uuid + "$$" + multi.getOriginalFilename();
		
		File storeFile = new File(uploadPath, fileName);
		if (!storeFile.getParentFile().exists()) {
			storeFile.getParentFile().mkdirs();
		}
		multi.transferTo(storeFile);

		return fileName;
	}

	public static String saveFile(String uploadPath, String oldFile, MultipartFile multi)
			throws EmptyMultipartFileException, IllegalStateException, IOException {
		String fileName = saveFile(uploadPath, multi);
		if (oldFile != null && !oldFile.isEmpty() && !oldFile.equals("noImage.jpg")) {
			File file = new File(uploadPath, oldFile);
			if (file.exists()) {
				file.delete();
			}
		}
		
		return fileName;
	}

	/**
	 * Stores an application image with a server-generated name.  This is kept
	 * separate from {@link #saveFile(String, MultipartFile)} so existing member
	 * upload file names remain fully compatible.
	 */
	public static String saveImageFile(String uploadPath, MultipartFile multi)
			throws EmptyMultipartFileException, IllegalStateException, IOException {

		if (multi == null || multi.isEmpty()) {
			throw new EmptyMultipartFileException();
		}

		String originalName = multi.getOriginalFilename();
		String extension = getExtension(originalName);
		if (!isAllowedImageExtension(extension) || !isAllowedImageContentType(multi.getContentType(), extension)) {
			throw new IllegalArgumentException("JPG, JPEG, PNG 이미지 파일만 등록할 수 있습니다.");
		}

		String fileName = UUID.randomUUID().toString().replace("-", "") + "." + extension;
		File uploadDirectory = new File(uploadPath).getCanonicalFile();
		if (!uploadDirectory.exists() && !uploadDirectory.mkdirs()) {
			throw new IOException("Unable to create upload directory.");
		}

		File storeFile = new File(uploadDirectory, fileName).getCanonicalFile();
		if (!storeFile.getParentFile().equals(uploadDirectory)) {
			throw new IOException("Invalid upload path.");
		}

		multi.transferTo(storeFile);
		return fileName;
	}

	private static String getExtension(String originalName) {
		if (originalName == null) {
			return "";
		}
		int lastDot = originalName.lastIndexOf('.');
		if (lastDot < 0 || lastDot == originalName.length() - 1) {
			return "";
		}
		return originalName.substring(lastDot + 1).toLowerCase(Locale.ROOT);
	}

	private static boolean isAllowedImageExtension(String extension) {
		for (String allowedExtension : ALLOWED_IMAGE_EXTENSIONS) {
			if (allowedExtension.equals(extension)) {
				return true;
			}
		}
		return false;
	}

	private static boolean isAllowedImageContentType(String contentType, String extension) {
		if (contentType == null) {
			return false;
		}

		String normalizedContentType = contentType.toLowerCase(Locale.ROOT);
		boolean jpeg = "jpg".equals(extension) || "jpeg".equals(extension);
		return (jpeg && ("image/jpeg".equals(normalizedContentType) || "image/jpg".equals(normalizedContentType)))
				|| ("png".equals(extension) && "image/png".equals(normalizedContentType));
	}
}
