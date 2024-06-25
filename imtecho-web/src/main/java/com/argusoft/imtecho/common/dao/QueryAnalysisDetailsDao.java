package com.argusoft.imtecho.common.dao;

import com.argusoft.imtecho.common.model.QueryAnalysisDetails;
import com.argusoft.imtecho.database.common.GenericDao;

/**
 * Analysis of query if it returns more amount of data then expected
 */
public interface QueryAnalysisDetailsDao extends GenericDao<QueryAnalysisDetails, Integer> {
}
