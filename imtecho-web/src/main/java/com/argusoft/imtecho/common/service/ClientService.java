package com.argusoft.imtecho.common.service;

import com.argusoft.imtecho.fhs.dto.ClientMemberDto;
import com.argusoft.imtecho.fhs.dto.HouseholdDto;
import com.argusoft.imtecho.fhs.dto.InteractionDto;
import com.argusoft.imtecho.fhs.dto.ReferralDto;

import java.util.Date;
import java.util.List;

/**
 * <p>Defines methods to retrieve client details based on various criteria.</p>
 */
public interface ClientService {

    /**
     * Retrieve a list of members based on the provided criteria.
     *
     * @param facilityCode The facility code to filter members
     * @param registrationStartDate The start date for registration to filter members
     * @param registrationEndDate The end date for registration to filter members
     * @param householdId (Optional) The household ID to filter members
     * @param zoneId (Optional) The zone ID to filter members
     * @param cbvId (Optional) The CBV ID to filter members
     * @return A list of MemberEntity objects that match the provided criteria
     */
    List<ClientMemberDto> getMembers(Integer facilityCode, Date registrationStartDate, Date registrationEndDate, String householdId, Integer zoneId, Integer cbvId);


    /**
     * Retrieve a list of households based on the provided criteria.
     *
     * @param facilityCode The facility code to filter households
     * @param registrationStartDate (Optional) The start date for registration to filter households
     * @param registrationEndDate (Optional) The end date for registration to filter households
     * @param householdId (Optional) The household ID to filter households
     * @param zoneId (Optional) The zone ID to filter households
     * @param cbvId (Optional) The CBV ID to filter households
     * @param includeMembers Flag to include members in the response
     * @return A list of HouseholdDto objects that match the provided criteria
     */
    List<HouseholdDto> getHouseholds(Integer facilityCode, Date registrationStartDate, Date registrationEndDate, String householdId, Integer zoneId, Integer cbvId, boolean includeMembers);

    /**
     * Retrieve list of referrals based on the provided parameters.
     *
     * @param facilityCode Facility code
     * @param serviceStartDate (Optional) Start date for service
     * @param serviceEndDate (Optional) End date for service
     * @param householdId (Optional) Household ID
     * @param zoneId (Optional) Zone ID
     * @param cbvId (Optional) CBV ID
     * @return List of ReferralDto objects matching the criteria
     */
    List<ReferralDto> getReferrals(Integer facilityCode, Date serviceStartDate, Date serviceEndDate, String householdId, Integer zoneId, Integer cbvId);

    /**
     * Retrieve list of interaction details based on the provided parameters.
     *
     * @param facilityCode Facility code
     * @param serviceStartDate Start date for filtering details based on the service date range.
     *                         If null, no lower bound date filter is applied.
     * @param serviceEndDate End date for filtering details based on the service date range.
     *                       If null, no upper bound date filter is applied.
     * @param cbvId (Optional) CBV (Community-Based Volunteer) ID for filtering details. If null, no CBV filter is applied.
     * @param householdId (Optional) Household ID for filtering details. If null, no household filter is applied.
     * @param zoneId (Optional) Zone ID for filtering details. If null, no zone filter is applied.
     * @return List of InteractionDto objects that match the specified criteria.
     */
    List<InteractionDto> getInteractions(Integer facilityCode, Date serviceStartDate, Date serviceEndDate, Integer cbvId, String householdId, Integer zoneId);
}
