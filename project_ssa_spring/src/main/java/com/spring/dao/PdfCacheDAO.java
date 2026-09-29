package com.spring.dao;

import com.spring.dto.PdfCacheVO;

public interface PdfCacheDAO {

    int insertPdfCacheRequest(PdfCacheVO pdfCache);

    PdfCacheVO selectLatestSuccessPdfCache(Long reportId);

    int updatePdfCacheSuccess(PdfCacheVO pdfCache);

    int updatePdfCacheFail(Long pdfCacheId);
}
