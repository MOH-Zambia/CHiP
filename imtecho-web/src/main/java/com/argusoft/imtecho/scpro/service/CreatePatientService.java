package com.argusoft.imtecho.scpro.service;

import com.argusoft.imtecho.scpro.dto.MemberDetailsDTO;
import com.argusoft.imtecho.scpro.dto.ReferralDTO;

public interface CreatePatientService {


    void createPatient(MemberDetailsDTO memberDetailsDTO);

    void getPatientStatus();

    void createReferral(ReferralDTO referralDTO);

    void getReferralStatus();

    void getPatientsFromImt();
}