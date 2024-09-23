package com.argusoft.imtecho.fhir.controller;

import com.argusoft.imtecho.common.service.ClientService;
import com.argusoft.imtecho.exception.DateValidationException;
import com.argusoft.imtecho.fhir.service.FhirService;
import com.argusoft.imtecho.fhir.util.FhirUtil;
import com.argusoft.imtecho.fhs.dto.ClientMemberDto;
import com.argusoft.imtecho.fhs.dto.HouseholdDto;
import com.argusoft.imtecho.fhs.dto.InteractionDto;
import com.argusoft.imtecho.fhs.dto.ReferralDto;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.hl7.fhir.r4.model.Bundle;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.concurrent.TimeUnit;

/**
 * <p>Defines rest endpoint to retrieve details in FHIR format</p>
 */

@RestController
@RequestMapping("/chipIntegration/fhir")
@Tag(name = "Chip Integration API", description = "APIs related to chip integration")
public class FhirDataAccessController {

    @Autowired
    private ClientService clientService;

    @Autowired
    private FhirService fhirService;

    /**
     * Retrieve FHIR referrals based on the provided parameters.
     *
     * @param facilityCode Facility code
     * @param serviceStartDate (Optional) Start date for service
     * @param serviceEndDate (Optional) End date for service
     * @param householdId (Optional) Household ID
     * @param zoneId (Optional) Zone ID
     * @param cbvId (Optional) CBV ID
     * @return ResponseEntity containing a JSON string of FHIR Bundle objects for referrals
     */
    @GetMapping("/getFhirReferrals")
    public ResponseEntity<String> getReferralsFhir(
            @RequestParam Integer facilityCode,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date serviceStartDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date serviceEndDate,
            @RequestParam(required = false) String householdId,
            @RequestParam(required = false) Integer zoneId,
            @RequestParam(required = false) Integer cbvId
    ) {
        if (serviceStartDate != null && serviceEndDate != null) {
            validateDates(serviceStartDate, serviceEndDate);
        }
        List<ReferralDto> referrals = clientService.getReferrals(facilityCode, serviceStartDate, serviceEndDate, householdId, zoneId, cbvId);
        List<Bundle> bundles = fhirService.createReferralBundles(referrals);
        List<String> list = new ArrayList<>();

        for(Bundle bundle : bundles){
            String fhir = FhirUtil.getJsonStringResponse(bundle);
            list.add(fhir);
        }
        return ResponseEntity.ok().body(list.toString());
    }

    /**
     * Retrieve FHIR clients based on the provided parameters.
     *
     * @param facilityCode Facility code
     * @param registrationStartDate Start date for registration
     * @param registrationEndDate End date for registration
     * @param householdId (Optional) Household ID
     * @param zoneId (Optional) Zone ID
     * @param cbvId (Optional) CBV ID
     * @return ResponseEntity containing a JSON string of FHIR Bundle objects for clients
     */
    @GetMapping("/getClientsFhir")
    public ResponseEntity<String> getClientsFhir(
            @RequestParam Integer facilityCode,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date registrationStartDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date registrationEndDate,
            @RequestParam(required = false) String householdId,
            @RequestParam(required = false) Integer zoneId,
            @RequestParam(required = false) Integer cbvId
    ) {
        validateDates(registrationStartDate, registrationEndDate);
        List<ClientMemberDto> members = clientService.getMembers(facilityCode, registrationStartDate, registrationEndDate, householdId, zoneId, cbvId);
        List<Bundle> bundles = fhirService.createClientBundles(members);
        List<String> list = new ArrayList<>();
        for(Bundle bundle : bundles){
            String fhir = FhirUtil.getJsonStringResponse(bundle);
            list.add(fhir);
        }
        return ResponseEntity.ok(list.toString());
    }

    /**
     * Retrieve list of households based on the provided parameters.
     *
     * @param facilityCode Facility code
     * @param registrationStartDate (Optional) Start date for registration
     * @param registrationEndDate (Optional) End date for registration
     * @param householdId (Optional) Household ID
     * @param zoneId (Optional) Zone ID
     * @param cbvId (Optional) CBV ID
     * @param includeMembers Flag to include members in the household details
     * @return ResponseEntity containing a JSON string of FHIR Bundle objects for households
     */
    @GetMapping("/getHouseHolds")
    public ResponseEntity<String> getHouseHolds(
            @RequestParam Integer facilityCode,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date registrationStartDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date registrationEndDate,
            @RequestParam(required = false) String householdId,
            @RequestParam(required = false) Integer zoneId,
            @RequestParam(required = false) Integer cbvId,
            @RequestParam boolean includeMembers
    ) {
        if(registrationStartDate != null && registrationEndDate != null) {
            validateDates(registrationStartDate, registrationEndDate);
        }
        List<HouseholdDto> households = clientService.getHouseholds(facilityCode, registrationStartDate, registrationEndDate, householdId, zoneId, cbvId, includeMembers);
        List<Bundle> bundles = fhirService.createHouseHoldBundles(households);
        List<String> list = new ArrayList<>();
        for(Bundle bundle : bundles){
            String fhir = FhirUtil.getJsonStringResponse(bundle);
            list.add(fhir);
        }
        return ResponseEntity.ok(list.toString());
    }

    /**
     * Retrieve service interactions based on the provided parameters.
     *
     * @param facilityCode Facility code
     * @param serviceStartDate Start date for service
     * @param serviceEndDate End date for service
     * @param cbvId (Optional) CBV ID
     * @param householdId (Optional) Household ID
     * @param zoneId (Optional) Zone ID
     * @return ResponseEntity containing a JSON string of FHIR Bundle objects for service interactions
     */
    @GetMapping("/getServiceInteractions")
    public ResponseEntity<String> getServiceInteractions(
            @RequestParam Integer facilityCode,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date serviceStartDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date serviceEndDate,
            @RequestParam (required = false) Integer cbvId,
            @RequestParam (required = false) String householdId,
            @RequestParam (required = false) Integer zoneId
    ) {
        validateDates(serviceStartDate, serviceEndDate);
        List<InteractionDto> interactions = clientService.getInteractions(facilityCode, serviceStartDate, serviceEndDate, cbvId, householdId, zoneId);
        List<Bundle> bundles = fhirService.createServiceInteractionBundles(interactions);
        List<String> list = new ArrayList<>();
        for(Bundle bundle : bundles){
            list.add(FhirUtil.getJsonStringResponse(bundle));
        }
        return ResponseEntity.ok(list.toString());
    }

    /**
     * Validate the start and end dates.
     *
     * @param startDate Start date
     * @param endDate End date
     * @throws DateValidationException if the end date is before the start date or the difference exceeds 90 days
     */
    public static void validateDates(Date startDate, Date endDate) {
        if (endDate.before(startDate)) {
            throw new DateValidationException("End date cannot be earlier than start date.");
        }

        long diffInMillies = Math.abs(endDate.getTime() - startDate.getTime());
        long diffInDays = TimeUnit.DAYS.convert(diffInMillies, TimeUnit.MILLISECONDS);

        if (diffInDays > 90) {
            throw new DateValidationException("The difference between the two dates cannot exceed 90 days.");
        }
    }
}
