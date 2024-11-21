package com.argusoft.imtecho.scpro.service.Impl;

import com.argusoft.imtecho.scpro.dto.MemberDetailsDTO;
import com.argusoft.imtecho.scpro.dto.ReferralDTO;
import com.argusoft.imtecho.scpro.service.CreatePatientService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PathVariable;

@Service
@Transactional
public class CreatePatientServiceImpl implements CreatePatientService {
    @Override
    public void createPatient(MemberDetailsDTO memberDetailsDTO){
        System.out.println("First Name: " + memberDetailsDTO.getFirstName());
        System.out.println("Last Name: " + memberDetailsDTO.getLastName());
        System.out.println("Mother Name: " + memberDetailsDTO.getMotherName());
    }

    @Override
    public void getPatientStatus(String requestId)
    {
        System.out.println(requestId);
    }

    @Override
    public  void createReferral(ReferralDTO referralDTO){
        System.out.println("First Name: " + referralDTO.getReferredFrom());
    }
    @Override
    public void getReferralStatus( String requestId){

    }
}
