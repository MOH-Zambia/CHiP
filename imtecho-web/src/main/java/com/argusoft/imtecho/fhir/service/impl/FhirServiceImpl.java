package com.argusoft.imtecho.fhir.service.impl;

import com.argusoft.imtecho.fhir.mapper.FhirClientMapper;
import com.argusoft.imtecho.fhir.mapper.FhirHouseHoldMapper;
import com.argusoft.imtecho.fhir.mapper.FhirReferralMapper;
import com.argusoft.imtecho.fhir.mapper.FhirServiceInteractionMapper;
import com.argusoft.imtecho.fhir.service.FhirService;
import com.argusoft.imtecho.fhs.dto.ClientMemberDto;
import com.argusoft.imtecho.fhs.dto.HouseholdDto;
import com.argusoft.imtecho.fhs.dto.InteractionDto;
import com.argusoft.imtecho.fhs.dto.ReferralDto;
import org.hl7.fhir.r4.model.Bundle;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Implementation of method in FhirService.
 */

@Service
@Transactional
public class FhirServiceImpl implements FhirService {


    /**
     * {@inheritDoc}
     */
    @Override
    public List<Bundle> createReferralBundles(List<ReferralDto> referrals){
        return FhirReferralMapper.createBundles(referrals);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<Bundle> createClientBundles(List<ClientMemberDto> clientMembers){
        return FhirClientMapper.getPatientBundles(clientMembers);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<Bundle> createHouseHoldBundles(List<HouseholdDto> households) {
        return FhirHouseHoldMapper.getBundles(households);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<Bundle> createServiceInteractionBundles(List<InteractionDto> interactions) {
        return FhirServiceInteractionMapper.getBundles(interactions);
    }
}
