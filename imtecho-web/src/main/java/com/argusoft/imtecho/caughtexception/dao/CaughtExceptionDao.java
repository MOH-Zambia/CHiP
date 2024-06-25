package com.argusoft.imtecho.caughtexception.dao;

import com.argusoft.imtecho.caughtexception.model.CaughtExceptionEntity;
import com.argusoft.imtecho.database.common.GenericDao;

/**
 * <p>
 * Defines methods for caught exception dao
 * </p>
 *
 * @author dhruvil
 * @since 27/05/2023 5:45 pm
 */
public interface CaughtExceptionDao extends GenericDao<CaughtExceptionEntity, Integer> {

    public void save(CaughtExceptionEntity exception);

}

