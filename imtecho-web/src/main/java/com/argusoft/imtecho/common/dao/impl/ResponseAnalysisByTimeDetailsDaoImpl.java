package com.argusoft.imtecho.common.dao.impl;

import com.argusoft.imtecho.common.dao.ResponseAnalysisByTimeDetailsDao;
import com.argusoft.imtecho.common.model.ResponseAnalysisByTimeDetails;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import org.springframework.stereotype.Repository;

/**
 * Analysis of response if it takes more time then expected
 */
@Repository
public class ResponseAnalysisByTimeDetailsDaoImpl extends GenericDaoImpl<ResponseAnalysisByTimeDetails, Integer> implements ResponseAnalysisByTimeDetailsDao {
}
