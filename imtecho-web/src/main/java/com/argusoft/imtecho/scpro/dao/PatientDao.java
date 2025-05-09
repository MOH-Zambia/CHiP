package com.argusoft.imtecho.scpro.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.scpro.dto.MemberDetailsDTO;
import com.argusoft.imtecho.scpro.dto.ReferralNrcDTO;
import com.argusoft.imtecho.scpro.model.PatientData;

import java.util.List;

public interface PatientDao extends GenericDao<PatientData,Long> {
    // public void create(PatientData abcd);
    List<ReferralNrcDTO> getPatientId();

    void setNUPN(String nupn, String nrc);

    List<MemberDetailsDTO> getPatientsFromImt();

    void updateSyncDate(String requestId);
}
