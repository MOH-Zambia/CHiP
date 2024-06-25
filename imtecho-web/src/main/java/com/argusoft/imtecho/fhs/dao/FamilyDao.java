/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.fhs.dao;

import com.argusoft.imtecho.dashboard.fhs.view.DisplayObject;
import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.familyqrcode.dto.FamilyQRCodeDto;
import com.argusoft.imtecho.fhs.dto.FhsVillagesDto;
import com.argusoft.imtecho.fhs.dto.FhwServiceStatusDto;
import com.argusoft.imtecho.fhs.dto.HouseholdDto;
import com.argusoft.imtecho.fhs.dto.StarPerformersOfTheDayDto;
import com.argusoft.imtecho.fhs.model.FamilyEntity;
import com.argusoft.imtecho.location.dto.LocationMasterDto;

import java.util.Date;
import java.util.List;

/**
 *
 * <p>
 * Define methods for family.
 * </p>
 *
 * @author prateek
 * @since 26/08/20 10:19 AM
 */
public interface FamilyDao extends GenericDao<FamilyEntity, Integer> {

    /**
     * Retrieves families by location ids and state.
     * @param locationIds List of location ids.
     * @param states List of states like verified, archived, merged etc.
     * @return Returns list of family details based on defined criteria.
     */
    List<FamilyEntity> retrieveFamiliesByLocationIdsAndState(List<Integer> locationIds, List<String> states);

    /**
     * Retrieves families by id of area.
     * @param locationIds List of location ids.
     * @param states List of states like verified, archived, merged etc.
     * @param lastUpDated Last updated date.
     * @return Returns list of family details based on defined criteria.
     */
    List<FamilyEntity> retrieveFamiliesByAreaIds(List<Integer> locationIds, List<String> states, Date lastUpDated);


    /**
     * Retrieves a list of households based on the provided criteria.
     *
     * @param facilityCode Facility code to filter households.
     * @param registrationStartDate (Optional) Start date for registration to filter households.
     * @param registrationEndDate (Optional) End date for registration to filter households.
     * @param householdId (Optional) Household ID to filter households.
     * @param zoneId (Optional) Zone ID to filter households.
     * @param cbvId (Optional) CBV ID to filter households.
     * @param includeMembers Flag to include members in the response.
     * @return A list of HouseholdDto objects that match the provided criteria.
     */
    List<HouseholdDto> getHouseholds(Integer facilityCode, Date registrationStartDate, Date registrationEndDate, String householdId, Integer zoneId, Integer cbvId, boolean includeMembers);


    /**
     * Retrieves families and it's member details.
     * @param locationId Id of location.
     * @param locationLevel Level of location.
     * @param userId Id of user.
     * @return Returns list of families and member details based on defined criteria.
     */
    List<DisplayObject> getFamiliesAndMembersForChildLocations(Integer locationId, Integer locationLevel, Integer userId);

    /**
     * Retrieves families and it's member by id of location.
     * @param locationId Id of location.
     * @param locationLevel Level of location.
     * @param userId Id of user.
     * @return Returns list of families and member details based on defined criteria.
     */
    List<DisplayObject> familiesAndMembersByLocationId(Integer locationId, Integer locationLevel, Integer userId);

//    /**
//     * Retrieves family based on it's state
//     * @param locationIds List of location ids.
//     * @param states List of states like verified, archived, merged etc.
//     * @param limit The number of data need to fetch.
//     * @param offset The number of data to skip before starting to fetch details.
//     * @return Returns list of families for FHSR verification.
//     */
//    List<FHSRVerificationDto> getFamiliesByStates(List<Integer> locationIds,
//                                                         List<String> states,
//                                                         Integer limit,
//                                                         Integer offset);

    /**
     * Retrieves family by family id.
     * @param familyId Id of family.
     * @return Returns details of family by id.
     */
    FamilyEntity retrieveFamilyByFamilyId(String familyId);

    /**
     * Retrieves family by family id.
     * @param uuid uuid of family.
     * @return Returns details of family by uuid.
     */
    FamilyEntity retrieveFamilyByUuid(String uuid);

    /**
     * Update family details.
     * @param familyEntity Family details.
     * @return Returns updated family.
     */
    FamilyEntity updateFamily(FamilyEntity familyEntity);

    /**
     * Retrieves fhs villages by id of user.
     * @param userId Id of user.
     * @return Returns list of fhs villages.
     */
    List<FhsVillagesDto> getFhsVillagesByUserId(Integer userId);

    /**
     * Retrieves best performance of the day list.
     * @return Returns star performance list.
     */
    List<StarPerformersOfTheDayDto> starPerformersOfTheDay();

    /**
     * Retrieves families by following defined criteria.
     * @param assignedPersonIds List of person ids.
     * @param isFamilyVerified Is family verified or not.
     * @param locationIds List of location ids.
     * @param states List of states.
     * @param lastUpdated Last updated date.
     * @return Returns list of family details.
     */
    List<FamilyEntity> getFamilies(List<Integer> assignedPersonIds, Boolean isFamilyVerified, List<Integer> locationIds, List<String> states, Date lastUpdated);

    /**
     * Add family details.
     * @param familyEntity Family details.
     * @return Returns added family details.
     */
    FamilyEntity createFamily(FamilyEntity familyEntity);

    /**
     * Retrieves families by list of family ids.
     * @param familyIds List of family ids.
     * @return Returns list of family.
     */
    List<FamilyEntity> retrieveFamiliesByFamilyIds(List<String> familyIds);

    /**
     * Retrieves FHW service report by id of user.
     * @param userId Id of user.
     * @return Returns list of FHW service status.
     */
    List<FhwServiceStatusDto> getFhwServiceReportByUserId(Integer userId);


    /**
     * Get list of verified families for gvk verification.
     * @return Returns list of verified families.
     */
//    List<GvkVerificationDisplayObject> getVerifiedFamilies();

    /**
     * Used to get list of families with atleast one member as archived for gvk
     * verification.
     * @return Returns list of families.
     */
//    List<GvkVerificationDisplayObject> getFamiliesWithArchivedMembers();

    /**
     * Used to get list of families with atleast one member as dead for gvk
     * verification.
     * @return Returns list of families.
     */
//    List<GvkVerificationDisplayObject> getFamiliesWithDeadMembers();

    /**
     * Retrieves assigned families by search text.
     * @param familyIds List of families ids.
     * @param locationId Id of location.
     * @param districtId Id of district.
     * @param userId Id of user.
     * @return Returns list of families.
     */
    List<FamilyEntity> getFamiliesToBeAssignedBySearchString(List<String> familyIds, Integer locationId, Integer districtId, Integer userId);

    /**
     * Retrieves list of families by location id.
     * @param locationId Id of location.
     * @param isArchivedFamily Is family archived or not.
     * @param isVerifiedFamily Is family verified or not.
     * @return Returns list of families.
     */
    List<FamilyEntity> getFamilyListByLocationId(Integer locationId, Boolean isArchivedFamily, Boolean isVerifiedFamily);

    /**
     * Update verified family location details.
     * @param loggedInUserId Logged in user id.
     * @param familyList List of families.
     * @param selectedMoveAnganwadiAreaId New anganwadi area id.
     * @param selectedMoveAshaAreaId New ASHA area id.
     */
    void updateVerifiedFamilyLocation(Integer loggedInUserId, List<String> familyList, Integer selectedMoveAnganwadiAreaId, Integer selectedMoveAshaAreaId);

//    /**
//     * Retrieves CFHCF families by states.
//     * @param locationIds List of location ids.
//     * @param limit The number of data need to fetch.
//     * @param offset The number of data to skip before starting to fetch details.
//     * @return Returns list of CFHC families.
//     */
//    List<CFHCVerificationDto> getCFHCFamiliesByStates(List<Integer> locationIds, Integer limit, Integer offset);

    List<FamilyQRCodeDto> getFamiliesForQRCode(Integer locationId, String fromDate, String toDate, Integer limit, Integer offset);

    FamilyQRCodeDto getFamilyDetailsForQRCode(String familyId);

    List<FamilyQRCodeDto> getFamiliesForQRCodeSewa(Integer locationId, String fromDate, String toDate, Integer limit, Integer offset);

    FamilyQRCodeDto getFamilyDetailsForQRCodeSewa(String familyId);

    LocationMasterDto getLgdCodeByFamilyIdAndParentType(String familyId,String parentLocationType);


}
