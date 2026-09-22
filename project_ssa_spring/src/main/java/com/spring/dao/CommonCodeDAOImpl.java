package com.spring.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.session.SqlSession;
import com.spring.cmd.PageMaker; // 💡 PageMaker 임포트 추가
import com.spring.dto.CommonCodeVO;

import lombok.AllArgsConstructor;

@AllArgsConstructor
public class CommonCodeDAOImpl implements CommonCodeDAO {

    private final SqlSession sqlSession;

    private static final String NAMESPACE = "CommonCode-Mapper";

    @Override
    public List<CommonCodeVO> selectCommonCodeList(PageMaker pageMaker) throws Exception {
        return sqlSession.selectList(NAMESPACE + ".selectCommonCodeList", pageMaker);
    }
    
    @Override
    public List<CommonCodeVO> getCodeListByGroup(String grpCode) {
        return sqlSession.selectList("CommonCode-Mapper.selectCommonCodeListByGroup", grpCode);
    }

    @Override
    public int selectCommonCodeCount(PageMaker pageMaker) throws Exception {
        return sqlSession.selectOne(NAMESPACE + ".selectCommonCodeCount", pageMaker);
    }

    @Override
    public CommonCodeVO selectCommonCodeDetail(String grpCode, String code) throws Exception {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("grpCode", grpCode);
        paramMap.put("code", code);
        return sqlSession.selectOne(NAMESPACE + ".selectCommonCodeDetail", paramMap);
    }

    @Override
    public int insertCommonCode(CommonCodeVO ccVo) throws Exception {
        return sqlSession.insert(NAMESPACE + ".insertCommonCode", ccVo);
    }

    @Override
    public int updateCommonCode(CommonCodeVO ccVo) throws Exception {
        return sqlSession.update(NAMESPACE + ".updateCommonCode", ccVo);
    }

    @Override
    public int deleteCommonCode(String grpCode, String code) throws Exception {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("grpCode", grpCode);
        paramMap.put("code", code);
        return sqlSession.delete(NAMESPACE + ".deleteCommonCode", paramMap);
    }
}