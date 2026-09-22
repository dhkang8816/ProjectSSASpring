package com.spring.dao;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;
import com.spring.dto.VideoDroneMapVO;
import lombok.AllArgsConstructor;

@Repository
@AllArgsConstructor
public class VideoDroneMapDAOImpl implements VideoDroneMapDAO {
    
    private final SqlSession sqlSession;
    private static final String NAMESPACE = "VideoDrone-Mapper";

    @Override
    public List<VideoDroneMapVO> selectAllMappings() throws Exception {
        return sqlSession.selectList(NAMESPACE + ".selectAllMappings");
    }

    @Override
    public String getDroneIdBySource(String sourceKey) throws Exception {
        return sqlSession.selectOne(NAMESPACE + ".getDroneIdBySource", sourceKey);
    }

    @Override
    public void updateDroneMapping(VideoDroneMapVO vo) throws Exception {
        sqlSession.update(NAMESPACE + ".updateDroneMapping", vo);
    }
}
