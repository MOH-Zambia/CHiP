package com.argusoft.imtecho.scpro.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.scpro.dto.ReferralDTO;
import com.argusoft.imtecho.scpro.dto.ReferralNupnDTO;
import com.argusoft.imtecho.scpro.dto.StoredReferralDTO;
import com.argusoft.imtecho.scpro.model.PatientData;
import com.argusoft.imtecho.scpro.model.ReferralData;
import java.util.List;

public interface ReferralDao extends GenericDao<ReferralData,Long> {
    List<ReferralNupnDTO>getReferredIds();

    void updateSyncDate(String requestId);

    List<StoredReferralDTO>getStoredReferredPatinets();

    void updateStoredReferral(Integer id );
}
