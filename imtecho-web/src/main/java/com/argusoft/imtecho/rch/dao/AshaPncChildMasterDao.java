package com.argusoft.imtecho.rch.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.rch.model.AshaPncChildMaster;

/**
 *
 * <p>
 * Define methods for ASHA pnc child master.
 * </p>
 *
 * @author prateek
 * @since 26/08/20 10:19 AM
 */
public interface AshaPncChildMasterDao extends GenericDao<AshaPncChildMaster, Integer> {

    /**
     * Retrieves pnc child master details by pnc master id and member id.
     * @param pncMasterId Pnc master id.
     * @param memberId Member id.
     * @return Returns ASHA pnc child master details.
     */
    AshaPncChildMaster retrievePncChildMasterByPncMasterIdAndMemberId(Integer pncMasterId, Integer memberId);
}
