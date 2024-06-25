package com.argusoft.imtecho.common.dao.impl;

import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.common.model.ThirdPartyRequestLogModel;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import com.argusoft.imtecho.common.dao.ThirdPartyRequestLogDao;

/**
 *
 * <p>
 * Defines Database Logic for Third party API Log
 * </p>
 *
 * @author ashish
 * @since 02/09/2020 04:40
 *
 */
@Repository
@Transactional
public class ThirdPartyRequestLogDaoImpl extends GenericDaoImpl<ThirdPartyRequestLogModel, Integer> implements ThirdPartyRequestLogDao {

}
