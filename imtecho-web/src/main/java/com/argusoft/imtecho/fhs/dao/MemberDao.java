/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.fhs.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.fhs.dto.*;
import com.argusoft.imtecho.fhs.model.MemberEntity;

import java.util.Date;
import java.util.List;
import java.util.Set;

/**
 *
 * <p>
 * Define methods for members.
 * </p>
 *
 * @author harsh
 * @since 26/08/20 10:19 AM
 */
public interface MemberDao extends GenericDao<MemberEntity, Integer> {

    /**
     * Retrieves member details by states.
     * @param locationIds List of location ids.
     * @param states List of states like archived, verified, unverified etc.
     * @param limit The number of data need to fetch.
     * @param offset The number of data to skip before starting to fetch details.
     * @return Returns list of members for FHSR verification.
     */
//    List<FHSRVerificationDto> getMembersByStates(List<Integer> locationIds,
//            List<String> states,
//            Integer limit,
//            Integer offset);

    /**
     * Update member of family.
     * @param memberEntity Entity of member.
     * @return Returns updated member.
     */
    MemberEntity updateMember(MemberEntity memberEntity);

    /**
     * Retrieves member by id.
     * @param id Id of member.
     * @return Returns member details by id.
     */
    MemberEntity retrieveMemberById(Integer id);

    /**
     * Retrieve a list of members based on the provided criteria.
     *
     * @param facilityCode          The facility code to filter members.
     * @param registrationStartDate The start date for registration to filter members.
     * @param registrationEndDate   The end date for registration to filter members.
     * @param householdId           (Optional) The household ID to filter members.
     * @param zoneId                (Optional) The zone ID to filter members.
     * @param cbvId                 (Optional) The CBV ID to filter members.
     * @return                      A list of MemberEntity objects that match the provided criteria.
     */
    List<ClientMemberDto> findMembers(Integer facilityCode, Date registrationStartDate, Date registrationEndDate, String householdId, Integer zoneId, Integer cbvId);

    /**
     * Retrieves member by unique Health id.
     * @param uniqueHealthId Unique Health id of member.
     * @return Returns member details by id.
     */
    MemberEntity retrieveMemberByUniqueHealthId(String  uniqueHealthId);
    MemberEntity retrieveMemberByUuid(String  uuid);

    /**
     * Retrieves member by unique health id and family id.
     * @param uniqueHealthId Unique health id.
     * @param familyId Family id.
     * @return Returns member details by defined params.
     */
    MemberEntity getMemberByUniqueHealthIdAndFamilyId(String uniqueHealthId, String familyId);

    /**
     * Retrieves list of member details for particular family.
     * @param familyId Id of family.
     * @return Returns list of members by family id.
     */
    List<MemberEntity> retrieveMemberEntitiesByFamilyId(String familyId);

    /**
     * Retrieves list of members ids by family id.
     * @param familyId Id of family.
     * @return Returns list of member ids.
     */
    List<Integer> retrieveMemberIdsByFamilyId(String familyId);


    /**
     * Search member by searching text.
     * @param searchString Search text.
     * @return Returns list of member by search text.
     */
    List<MemberEntity> searchMembers(String searchString);

    /**
     * Retrieves member by states, location ids, family ids, basic states, projection list.
     * @param states List of states like archived, verified, unverified etc.
     * @param locationIds List of location ids.
     * @param projectionList List of projections.
     * @param familyIds List of family ids.
     * @param lastUpdatedDate Last updated date.
     * @param basicStates List of basic states.
     * @return Returns list of member details based on defined criteria.
     */
    List<MemberEntity> getMembers(List<String> states, List<Integer> locationIds, List<String> projectionList, List<String> familyIds, Date lastUpdatedDate, List<String> basicStates);

    /**
     * Retrieves member details for ASHA.
     * @param states List of states.
     * @param locationIds List of location ids.
     * @param projectionList List of projections.
     * @param familyIds List of family ids.
     * @param lastUpdatedDate Last updated date.
     * @return Returns list of member details based on defined criteria.
     */
    List<MemberEntity> getMembersForAsha(List<String> states,
            List<Integer> locationIds,
            List<String> projectionList,
            List<String> familyIds,
            Date lastUpdatedDate);

    /**
     * Add new member details.
     * @param memberEntity Member details.
     * @return Returns newly added member details.
     */
    MemberEntity createMember(MemberEntity memberEntity);

    /**
     * Delete relation of diseases to particular member.
     * @param memberId Id of member.
     */
    void deleteDiseaseRelationsOfMember(Integer memberId);

    /**
     * Add relation of diseases to particular member.
     * @param memberId Id of member.
     * @param diseaseIds Id of disease.
     * @param diseaseType Type of disease.
     */
    void insertDiseaseRelationsOfMember(Integer memberId, Set<Integer> diseaseIds, String diseaseType);

    /**
     * Retrieves family id of member by unique health id.
     * @param uniqueHealthId Unique health id.
     * @return Returns family id of member.
     */
    String getFamilyIdByMemberUniqueHealthId(String uniqueHealthId);

    /**
     * Retrieves list of family ids by unique health ids.
     * @param uniqueHealthIds List of unique health ids.
     * @return Returns list of family ids.
     */
    List<String> getFamilyIdsByMemberUniqueHealthIds(List<String> uniqueHealthIds);

    /**
     * Retrieves child member details by its mother id.
     * @param motherId Id of mother.
     * @param noDeadMember Is mother dead or not.
     * @return Returns list of child members details by mother id.
     */
    List<MemberEntity> getChildMembersByMotherId(Integer motherId, Boolean noDeadMember);


    /**
     * Retrieve Member Details by memberId
     * @param memberId ID of imt_member
     * @return Returns Member Details
     */
    MemberDto retrieveDetailsByMemberId(Integer memberId);

    /**
     * Retrieve child details by mother id.
     * @param id Id of mother.
     * @return Returns list of children by mother id.
     */
    List<MemberEntity> retrieveChildDetails(Integer id);

    /**
     * Check if member already marked as dead or not.
     * @param memberId Member id.
     * @return Returns member already marked as dead or not
     */
    Boolean checkIfMemberAlreadyMarkedDead(Integer memberId);

    /**
     * Retrieves ASHA phone number by member id,
     * @param memberId Id of member.
     * @return Returns mobile number list of ASHA workers based on member id.
     */
    List<String> retrieveAshaPhoneNumberByMemberId(Integer memberId);

    /**
     * Retrieves member details by unique health id.
     * @param uniqueHealthId Unique health id.
     * @return Returns member details.
     */
    MemberInformationDto getMemberInfoByUniqueHealthId(String uniqueHealthId);

    /**
     * Retrieves pregnancy registration details by member id.
     * @param memberId Member id.
     * @return Returns list of pregnancy registration details.
     */
    List<PregnancyRegistrationDetailDto> getPregnancyRegistrationDetailByMemberId(Integer memberId);


    List<String> retrieveMembersOnStatus(Integer memberId);

    public List<String> retrieveMembersSC(Integer locId);

    /**
     * Retrieves members for migration based on aadhar number or health id.
     * @param byAadhar By aadhar or not.
     * @param aadhar Define aadhar number.
     * @param byHealthId By health id or not.
     * @param healthId Define health id.
     * @return Returns list of members based on define params.
     */
    List<MemberEntity> retrieveMemberForMigration(Boolean byAadhar, String aadhar, Boolean byHealthId, String healthId);

    /**
     * Retrieves children whom age is under 5 by mother id.
     * @param motherId Mother id.
     * @return Returns list of children by mother id.
     */
    List<MemberEntity> retrieveChildUnder5ByMotherId(Integer motherId);

    /**
     * Retrieves member by search text, search by like member id, family id, name etc.
     * @param searchString Search text.
     * @param searchBy Define search by like member id, family id, mobile number, name etc.
     * @param limit The number of data need to fetch.
     * @param offset The number of data to skip before starting to fetch details.
     * @return Returns list of members based on define params.
     */
    List<MemberDto> searchMembers(String searchString, String searchBy, Integer limit, Integer offset);

    /**
     * Update mother id of children by children ids.
     * @param motherId Id of mother.
     * @param childIds List of children ids.
     */
    void updateMotherIdInChildren(Integer motherId, List<Integer> childIds);

    /**
     * Retrieves members by family id list.
     * @param familyIds List of family ids.
     * @return Returns list of members based on define params.
     */
    List<MemberEntity> retrieveMembersByFamilyList(List<String> familyIds);

    /**
     * Retrieves members by phone number.
     * @param phoneNumber Phone number.
     * @param familyId Family id,
     * @return Returns list of members based on define params.
     */
    List<MemberEntity> retrieveMembersByPhoneNumber(String phoneNumber,String familyId);

    /**
     * Check if date of birth is unique or not.
     * @param familyId Family id.
     * @param mobileNumber Mobile number.
     * @return Returns date of birth is unique or not.
     */
    Boolean checkIfDOBIsUnique(String familyId,String mobileNumber);

    /**
     * Retrieves member details by family id for verification.
     * @param familyId Family id.
     * @param dob Date of birth.
     * @param aadharNumber Aadhar number.
     * @return Returns list of members for verification.
     */
    List<MemberEntity> verifyMemberDetailByFamilyId(String familyId, Long dob, String aadharNumber);

    /**
     * Delete mobile number for all family except verified family.
     * @param verifiedFamilyId Verified family id.
     * @param mobileNumber Mobile number.
     */
    void deleteMobileNumberInFamilyExceptVerifiedFamily(String verifiedFamilyId,String mobileNumber);

    /**
     * Get family head member details by family id.
     * @param familyId Family id.
     * @return Returns head of family details.
     */
    MemberEntity getFamilyHeadMemberDetail(String familyId);

    /**
     * Retrieves members by list of ids.
     * @param ids List of ids.
     * @return Returns list of members.
     */
    List<ElasticSearchMemberDto> retrieveMembersByIds(List<Integer> ids);

    /**
     * Retrieves members by first name.
     * @param quries First name of member.
     * @return Returns list of members.
     */
    List<ElasticSearchMemberDto> retrieveMembersByQuery(String quries);

    /**
     * Get members whom birth date is equal.
     * @param familyId Family id.
     * @param dob Date of birth.
     * @return Returns list of members.
     */
    List<MemberEntity> getEqualDobMembers(String familyId,String dob);

    /**
     * Retrieves member by family id and states.
     * @param familyId Family id.
     * @param states List of states.
     * @return Returns list of members.
     */
    List<MemberEntity> retriveMemberByFamilyIdAndStates(String familyId,List<String> states);

    /**
     * Check if death entry exists or not.
     * @param memberId Id of member.
     * @return Returns death entry exists or not.
     */
    boolean checkIfDeathEntryExists(Integer memberId);

    /**
     * Retrieves id by list value field key.
     * @param fieldKey Field key of list value.
     * @param value Value of list.
     * @return Returns result of list value key.
     */
    Integer retrieveIdOfListValuesByFieldKeyAndValue(String fieldKey, String value);


    String getFamilyIdByPhoneNumber(String hofMobileNumber, String mobileNumber);

    boolean checkSameNrcExists(String nrcNumber);
    boolean checkSamePassportExists(String nrcNumber);
    boolean checkSameBirthCertificateExists(String nrcNumber);

    /**
     * Retrieve list of referrals based on the provided parameters.
     *
     * @param facilityCode Facility code
     * @param serviceStartDate (Optional) Start date for filtering referrals based on the service date range.
     *                         If null, no lower bound date filter is applied.
     * @param serviceEndDate (Optional) End date for filtering referrals based on the service date range.
     *                       If null, no upper bound date filter is applied.
     * @param householdId (Optional) Household ID for filtering referrals. If null, no household filter is applied.
     * @param zoneId (Optional) Zone ID for filtering referrals. If null, no zone filter is applied.
     * @param cbvId (Optional) CBV (Community-Based Volunteer) ID for filtering referrals. If null, no CBV filter is applied.
     * @return List of ReferralDto objects that match the specified criteria.
     */
    List<ReferralDto> getReferral(Integer facilityCode, Date serviceStartDate, Date serviceEndDate, String householdId, Integer zoneId, Integer cbvId);

    /**
     * Retrieve list of malaria details based on the provided parameters.
     *
     * @param facilityCode Facility code
     * @param serviceStartDate Start date for filtering details based on the service date range.
     *                         If null, no lower bound date filter is applied.
     * @param serviceEndDate End date for filtering details based on the service date range.
     *                       If null, no upper bound date filter is applied.
     * @param cbvId (Optional) CBV (Community-Based Volunteer) ID for filtering details. If null, no CBV filter is applied.
     * @param householdId (Optional) Household ID for filtering details. If null, no household filter is applied.
     * @param zoneId (Optional) Zone ID for filtering details. If null, no zone filter is applied.
     * @return List of MalariaDto objects that match the specified criteria.
     */
    List<MalariaDto> getMalariaDetails(Integer facilityCode, Date serviceStartDate, Date serviceEndDate, Integer cbvId, String householdId, Integer zoneId);

    /**
     * Retrieve list of tuberculosis details based on the provided parameters.
     *
     * @param facilityCode Facility code
     * @param serviceStartDate Start date for filtering details based on the service date range.
     *                         If null, no lower bound date filter is applied.
     * @param serviceEndDate End date for filtering details based on the service date range.
     *                       If null, no upper bound date filter is applied.
     * @param cbvId (Optional) CBV (Community-Based Volunteer) ID for filtering details. If null, no CBV filter is applied.
     * @param householdId (Optional) Household ID for filtering details. If null, no household filter is applied.
     * @param zoneId (Optional) Zone ID for filtering details. If null, no zone filter is applied.
     * @return List of TuberculosisDto objects that match the specified criteria.
     */
    List<TuberculosisDto> getTuberculosisDetails(Integer facilityCode, Date serviceStartDate, Date serviceEndDate, Integer cbvId, String householdId, Integer zoneId);

    /**
     * Retrieve list of COVID-19 details based on the provided parameters.
     *
     * @param facilityCode Facility code
     * @param serviceStartDate Start date for filtering details based on the service date range.
     *                         If null, no lower bound date filter is applied.
     * @param serviceEndDate End date for filtering details based on the service date range.
     *                       If null, no upper bound date filter is applied.
     * @param cbvId (Optional) CBV (Community-Based Volunteer) ID for filtering details. If null, no CBV filter is applied.
     * @param householdId (Optional) Household ID for filtering details. If null, no household filter is applied.
     * @param zoneId (Optional) Zone ID for filtering details. If null, no zone filter is applied.
     * @return List of CovidDto objects that match the specified criteria.
     */
    List<CovidDto> getCovidDetails(Integer facilityCode, Date serviceStartDate, Date serviceEndDate, Integer cbvId, String householdId, Integer zoneId);

    /**
     * Retrieve list of HIV details based on the provided parameters.
     *
     * @param facilityCode Facility code
     * @param serviceStartDate Start date for filtering details based on the service date range.
     *                         If null, no lower bound date filter is applied.
     * @param serviceEndDate End date for filtering details based on the service date range.
     *                       If null, no upper bound date filter is applied.
     * @param cbvId (Optional) CBV (Community-Based Volunteer) ID for filtering details. If null, no CBV filter is applied.
     * @param householdId (Optional) Household ID for filtering details. If null, no household filter is applied.
     * @param zoneId (Optional) Zone ID for filtering details. If null, no zone filter is applied.
     * @return List of HivDto objects that match the specified criteria.
     */
    List<HivDto> getHivDetails(Integer facilityCode, Date serviceStartDate, Date serviceEndDate, Integer cbvId, String householdId, Integer zoneId);

    /**
     * Retrieve list of ANC (Antenatal Care) details based on the provided parameters.
     *
     * @param facilityCode Facility code
     * @param serviceStartDate Start date for filtering details based on the service date range.
     *                         If null, no lower bound date filter is applied.
     * @param serviceEndDate End date for filtering details based on the service date range.
     *                       If null, no upper bound date filter is applied.
     * @param cbvId (Optional) CBV (Community-Based Volunteer) ID for filtering details. If null, no CBV filter is applied.
     * @param householdId (Optional) Household ID for filtering details. If null, no household filter is applied.
     * @param zoneId (Optional) Zone ID for filtering details. If null, no zone filter is applied.
     * @return List of AncDto objects that match the specified criteria.
     */
    List<AncDto> getAncDetails(Integer facilityCode, Date serviceStartDate, Date serviceEndDate, Integer cbvId, String householdId, Integer zoneId);

    /**
     * Retrieve list of child service details based on the provided parameters.
     *
     * @param facilityCode Facility code
     * @param serviceStartDate Start date for filtering details based on the service date range.
     *                         If null, no lower bound date filter is applied.
     * @param serviceEndDate End date for filtering details based on the service date range.
     *                       If null, no upper bound date filter is applied.
     * @param cbvId (Optional) CBV (Community-Based Volunteer) ID for filtering details. If null, no CBV filter is applied.
     * @param householdId (Optional) Household ID for filtering details. If null, no household filter is applied.
     * @param zoneId (Optional) Zone ID for filtering details. If null, no zone filter is applied.
     * @return List of ChildServiceDto objects that match the specified criteria.
     */
    List<ChildServiceDto> getChildServiceDetails(Integer facilityCode, Date serviceStartDate, Date serviceEndDate, Integer cbvId, String householdId, Integer zoneId);

    /**
     * Retrieve list of PNC (Postnatal Care) child details based on the provided parameters.
     *
     * @param facilityCode Facility code
     * @param serviceStartDate Start date for filtering details based on the service date range.
     *                         If null, no lower bound date filter is applied.
     * @param serviceEndDate End date for filtering details based on the service date range.
     *                       If null, no upper bound date filter is applied.
     * @param cbvId (Optional) CBV (Community-Based Volunteer) ID for filtering details. If null, no CBV filter is applied.
     * @param householdId (Optional) Household ID for filtering details. If null, no household filter is applied.
     * @param zoneId (Optional) Zone ID for filtering details. If null, no zone filter is applied.
     * @return List of PncChildDetailsDto objects that match the specified criteria.
     */
    List<PncChildDetailsDto> getPncChildDetails(Integer facilityCode, Date serviceStartDate, Date serviceEndDate, Integer cbvId, String householdId, Integer zoneId);

    /**
     * Retrieve list of PNC (Postnatal Care) mother details based on the provided parameters.
     *
     * @param facilityCode Facility code
     * @param serviceStartDate Start date for filtering details based on the service date range.
     *                         If null, no lower bound date filter is applied.
     * @param serviceEndDate End date for filtering details based on the service date range.
     *                       If null, no upper bound date filter is applied.
     * @param cbvId (Optional) CBV (Community-Based Volunteer) ID for filtering details. If null, no CBV filter is applied.
     * @param householdId (Optional) Household ID for filtering details. If null, no household filter is applied.
     * @param zoneId (Optional) Zone ID for filtering details. If null, no zone filter is applied.
     * @return List of PncMotherDetailsDto objects that match the specified criteria.
     */
    List<PncMotherDetailsDto> getPncMotherDetails(Integer facilityCode, Date serviceStartDate, Date serviceEndDate, Integer cbvId, String householdId, Integer zoneId);

    /**
     * Retrieve list of WPD (Well-Child and Postpartum Care) mother details based on the provided parameters.
     *
     * @param facilityCode Facility code
     * @param serviceStartDate Start date for filtering details based on the service date range.
     *                         If null, no lower bound date filter is applied.
     * @param serviceEndDate End date for filtering details based on the service date range.
     *                       If null, no upper bound date filter is applied.
     * @param cbvId (Optional) CBV (Community-Based Volunteer) ID for filtering details. If null, no CBV filter is applied.
     * @param householdId (Optional) Household ID for filtering details. If null, no household filter is applied.
     * @param zoneId (Optional) Zone ID for filtering details. If null, no zone filter is applied.
     * @return List of WpdMotherDetailsDto objects that match the specified criteria.
     */
    List<WpdMotherDetailsDto> getWpdMotherDetails(Integer facilityCode, Date serviceStartDate, Date serviceEndDate, Integer cbvId, String householdId, Integer zoneId);

    /**
     * Retrieve list of WPD (Well-Child and Postpartum Care) child details based on the provided parameters.
     *
     * @param facilityCode Facility code
     * @param serviceStartDate Start date for filtering details based on the service date range.
     *                         If null, no lower bound date filter is applied.
     * @param serviceEndDate End date for filtering details based on the service date range.
     *                       If null, no upper bound date filter is applied.
     * @param cbvId (Optional) CBV (Community-Based Volunteer) ID for filtering details. If null, no CBV filter is applied.
     * @param householdId (Optional) Household ID for filtering details. If null, no household filter is applied.
     * @param zoneId (Optional) Zone ID for filtering details. If null, no zone filter is applied.
     * @return List of WpdChildDetailsDto objects that match the specified criteria.
     */
    List<WpdChildDetailsDto> getWpdChildDetails(Integer facilityCode, Date serviceStartDate, Date serviceEndDate, Integer cbvId, String householdId, Integer zoneId);


    }
