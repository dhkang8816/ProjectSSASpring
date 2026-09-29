package com.spring.dto;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class PdfCacheVO {

    private Long pdfCacheId;
    private String pdfFilePath;
    private String generationStatus;
    private Date pdfDate;
    private Long reportId;
}
