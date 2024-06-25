package com.argusoft.imtecho.common.dao.impl;

import com.argusoft.imtecho.common.dao.QueryAnalysisDetailsDao;
import com.argusoft.imtecho.common.model.QueryAnalysisDetails;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import org.springframework.stereotype.Repository;

/**
 * Analysis of query if it returns more amount of data then expected
 */
@Repository
public class QueryAnalysisDetailsDaoImpl extends GenericDaoImpl<QueryAnalysisDetails, Integer> implements QueryAnalysisDetailsDao {
}
