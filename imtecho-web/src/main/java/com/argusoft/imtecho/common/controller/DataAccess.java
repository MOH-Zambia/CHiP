package com.argusoft.imtecho.common.controller;


import com.argusoft.imtecho.common.service.ClientService;
import com.argusoft.imtecho.exception.DateValidationException;
import com.argusoft.imtecho.fhs.dto.ClientMemberDto;
import com.argusoft.imtecho.fhs.dto.HouseholdDto;
import com.argusoft.imtecho.fhs.dto.InteractionDto;
import com.argusoft.imtecho.fhs.dto.ReferralDto;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import java.util.Date;
import java.util.List;
import java.util.concurrent.TimeUnit;

/**
 * <p>Defines rest endpoint to retrieve client details</p>
 */

@RestController
@RequestMapping("/chipIntegration")
@Tag(name = "Chip Integration API", description = "APIs related to chip integration")
public class DataAccess {

    @Autowired
    private ClientService clientService;

    /**
     * Retrieve list of clients based on the provided parameters.
     *
     * @param facilityCode Facility code
     * @param registrationStartDate Start date for registration
     * @param registrationEndDate End date for registration
     * @param householdId (Optional) Household ID
     * @param zoneId (Optional) Zone ID
     * @param cbvId (Optional) CBV ID
     * @return ResponseEntity containing a list of MemberEntity objects
     */

    @GetMapping("/getClients")
    public ResponseEntity<List<ClientMemberDto>> getClients(
            @RequestParam Integer facilityCode,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date registrationStartDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date registrationEndDate,
            @RequestParam(required = false) String householdId,
            @RequestParam(required = false) Integer zoneId,
            @RequestParam(required = false) Integer cbvId
    ) {
        validateDates(registrationStartDate, registrationEndDate);
        List<ClientMemberDto> members = clientService.getMembers(facilityCode, registrationStartDate, registrationEndDate, householdId, zoneId, cbvId);
        return ResponseEntity.ok(members);
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
     * @param includeMembers Flag to include members in the response
     * @return ResponseEntity containing a list of HouseholdDTO objects
     */
    @GetMapping("/getHouseHolds")
    public ResponseEntity<List<HouseholdDto>> getHouseHolds(
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
        return ResponseEntity.ok(households);
    }

    /**
     * Retrieve list of referrals based on the provided parameters.
     *
     * @param facilityCode Facility code
     * @param serviceStartDate (Optional) Start date for service
     * @param serviceEndDate (Optional) End date for service
     * @param householdId (Optional) Household ID
     * @param zoneId (Optional) Zone ID
     * @param cbvId (Optional) CBV ID
     * @return ResponseEntity containing a list of Referral objects
     */
    @GetMapping("/getReferrals")
    public ResponseEntity<List<ReferralDto>> getReferrals(
            @RequestParam Integer facilityCode,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date serviceStartDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date serviceEndDate,
            @RequestParam(required = false) String householdId,
            @RequestParam(required = false) Integer zoneId,
            @RequestParam(required = false) Integer cbvId
    ) {
        if(serviceStartDate != null && serviceEndDate != null) {
            validateDates(serviceStartDate, serviceEndDate);
        }
        List<ReferralDto> referrals = clientService.getReferrals(facilityCode, serviceStartDate, serviceEndDate, householdId, zoneId, cbvId);
        return ResponseEntity.ok(referrals);
    }

    /**
     * Retrieve list of service interactions based on the provided parameters.
     *
     * @param memberId Member Id
     * @param serviceStartDate Start date for service
     * @param serviceEndDate End date for service
     * @return ResponseEntity containing a list of Interaction objects
     */
    @GetMapping("/getServiceInteractions")
    public ResponseEntity<InteractionDto> getServiceInteractions(
            @RequestParam Integer memberId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date serviceStartDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date serviceEndDate
    ) {
        validateDates(serviceStartDate, serviceEndDate);
        InteractionDto interactions = clientService.getInteractions(memberId, serviceStartDate, serviceEndDate);
        return ResponseEntity.ok(interactions);
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
