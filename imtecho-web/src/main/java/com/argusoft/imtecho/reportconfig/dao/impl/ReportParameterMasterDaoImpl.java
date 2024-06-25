/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.reportconfig.dao.impl;

import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.reportconfig.dao.ReportParameterDao.ReportParameterMasterDao;
import com.argusoft.imtecho.reportconfig.model.ReportParameterMaster;
import org.springframework.stereotype.Repository;

/**
 *
 * <p>
 * Implementation of methods define in report parameter dao.
 * </p>
 *
 * @author vaishali
 * @since 26/08/20 10:19 AM
 */
@Repository
public class ReportParameterMasterDaoImpl
        extends GenericDaoImpl<ReportParameterMaster, Integer>
        implements ReportParameterMasterDao {
}
