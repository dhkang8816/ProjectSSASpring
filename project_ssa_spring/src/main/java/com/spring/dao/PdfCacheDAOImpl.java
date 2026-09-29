package com.spring.dao;

import org.apache.ibatis.session.SqlSession;

import com.spring.dto.PdfCacheVO;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
public class PdfCacheDAOImpl implements PdfCacheDAO {

    private static final String NAMESPACE = "PdfCache-Mapper.";

    private final SqlSession sqlSession;

    @Override
    public int insertPdfCacheRequest(PdfCacheVO pdfCache) {
        return sqlSession.insert(NAMESPACE + "insertPdfCacheRequest", pdfCache);
    }

    @Override
    public PdfCacheVO selectLatestSuccessPdfCache(Long reportId) {
        return sqlSession.selectOne(NAMESPACE + "selectLatestSuccessPdfCache", reportId);
    }

    @Override
    public int updatePdfCacheSuccess(PdfCacheVO pdfCache) {
        return sqlSession.update(NAMESPACE + "updatePdfCacheSuccess", pdfCache);
    }

    @Override
    public int updatePdfCacheFail(Long pdfCacheId) {
        return sqlSession.update(NAMESPACE + "updatePdfCacheFail", pdfCacheId);
    }
}
