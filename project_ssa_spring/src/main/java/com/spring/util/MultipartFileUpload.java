package com.spring.util;

import java.io.File;
import java.io.IOException;
import java.util.UUID;
import org.springframework.web.multipart.MultipartFile;
import com.spring.exception.EmptyMultipartFileException;

public class MultipartFileUpload {

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
}
