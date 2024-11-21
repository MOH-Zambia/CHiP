package com.argusoft.imtecho.scpro.controller;

import com.argusoft.imtecho.scpro.dto.MemberDetailsDTO;
import com.argusoft.imtecho.scpro.dto.ReferralDTO;
import com.argusoft.imtecho.scpro.service.CreatePatientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/scpro")
public class SCProController {

    @Autowired
    CreatePatientService createPatientService;

    @PostMapping(value = "/createPatient")
   public void createPatient (@RequestBody MemberDetailsDTO memberDetailsDTO)
    {
        createPatientService.createPatient(memberDetailsDTO);
    }

    @GetMapping( value = "/getCreatedPatient/{requestId}")
    public void getCreatedPatient(@PathVariable String requestId ){
        createPatientService.getPatientStatus(requestId);
    }

    @PostMapping(value = "/createReferral")
            public void createReferral(@RequestBody ReferralDTO referralDTO){
        createPatientService.createReferral(referralDTO);
    }

    @GetMapping(value = "/getReferralStatus")
    public void getReferralStatus(@PathVariable String requestId){
        createPatientService.getReferralStatus(requestId);
    }

}
