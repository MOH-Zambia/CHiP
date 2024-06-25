package com.argusoft.imtecho.mobile.dao.impl;

import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.mobile.dao.SohChartConfigurationDao;
import com.argusoft.imtecho.mobile.model.SohChartConfiguration;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
@Transactional
public class SohChartConfigurationDaoImpl extends GenericDaoImpl<SohChartConfiguration, Integer> implements SohChartConfigurationDao {
}
