package com.argusoft.imtecho.cfhc.dao;

import com.argusoft.imtecho.cfhc.model.MemberCFHCEntity;
import com.argusoft.imtecho.database.common.GenericDao;

import java.util.List;

/**
 * <p>Defines database methods for Community First Health Co-op survey</p>
 *
 * @author rahul
 * @since 25/08/20 4:30 PM
 */

public interface MemberCFHCDao extends GenericDao<MemberCFHCEntity, Long> {

    /**
     * Returns list of MemberCFHCEntity based on given familyId
     *
     * @param familyId family id
     * @return A list of MemberCFHCEntity
     */
    List<MemberCFHCEntity> retrieveMemberCFHCEntitiesByFamilyId(Integer familyId);

    MemberCFHCEntity retrieveMemberCFHCEntitiesByMemberId(Integer id);
}
