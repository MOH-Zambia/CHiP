package com.argusoft.imtecho.fhir.service;

import com.argusoft.imtecho.fhs.dto.ClientMemberDto;
import com.argusoft.imtecho.fhs.dto.HouseholdDto;
import com.argusoft.imtecho.fhs.dto.InteractionDto;
import com.argusoft.imtecho.fhs.dto.ReferralDto;
import org.hl7.fhir.r4.model.Bundle;

import java.util.List;

/**
 * Service interface for creating FHIR Bundles from various types of data transfer objects (DTOs).
 * Provides methods for generating FHIR Bundles for referrals, client members, households, and service interactions.
 */
public interface FhirService {

    /**
     * Creates FHIR Bundles for a list of referral data transfer objects.
     *
     * @param referrals List of ReferralDto objects containing referral information
     * @return List of Bundle objects representing the FHIR Bundles for the referrals
     */
    List<Bundle> createReferralBundles(List<ReferralDto> referrals);

    /**
     * Creates FHIR Bundles for a list of client member data transfer objects.
     *
     * @param clientMembers List of ClientMemberDto objects containing client member information
     * @return List of Bundle objects representing the FHIR Bundles for the client members
     */
    List<Bundle> createClientBundles(List<ClientMemberDto> clientMembers);

    /**
     * Creates FHIR Bundles for a list of household data transfer objects.
     *
     * @param households List of HouseholdDto objects containing household information
     * @return List of Bundle objects representing the FHIR Bundles for the households
     */
    List<Bundle> createHouseHoldBundles(List<HouseholdDto> households);

    /**
     * Creates FHIR Bundles for a list of service interaction data transfer objects.
     *
     * @param interactions List of InteractionDto objects containing service interaction information
     * @return List of Bundle objects representing the FHIR Bundles for the service interactions
     */
    List<Bundle> createServiceInteractionBundles(List<InteractionDto> interactions);
}
