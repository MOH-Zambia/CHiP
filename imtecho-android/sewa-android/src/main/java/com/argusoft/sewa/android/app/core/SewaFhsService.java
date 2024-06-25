/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.sewa.android.app.core;

import com.argusoft.sewa.android.app.databean.FamilyDataBean;
import com.argusoft.sewa.android.app.databean.FieldValueMobDataBean;
import com.argusoft.sewa.android.app.databean.MemberDataBean;
import com.argusoft.sewa.android.app.databean.NotificationMobDataBean;
import com.argusoft.sewa.android.app.databean.RchVillageProfileDataBean;
import com.argusoft.sewa.android.app.model.FamilyAvailabilityBean;
import com.argusoft.sewa.android.app.model.FamilyBean;
import com.argusoft.sewa.android.app.model.FhwServiceDetailBean;
import com.argusoft.sewa.android.app.model.ListValueBean;
import com.argusoft.sewa.android.app.model.LocationBean;
import com.argusoft.sewa.android.app.model.MemberBean;

import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * @author kunjan
 */
public interface SewaFhsService {

    List<FamilyAvailabilityBean> retrieveLockedFamilyDataBeansByVillage(String locationId, long limit, long offset);

    List<FamilyAvailabilityBean> searchLockedFamilyDataBeansByVillage(String search, String locationId, long limit, long offset);

    List<FamilyDataBean> retrieveFamilyDataBeansForCFHC(String locationId, boolean isReverification, long limit, long offset);
   
    List<FamilyDataBean> retrieveFamilyDataBeansForCFHCByVillage(String locationId, boolean isReverification, long limit, long offset);

    List<FamilyDataBean> searchFamilyDataBeansForCFHCByVillage(String search, String locationId, boolean isReverification, LinkedHashMap<String, String> qrData);

    List<FamilyDataBean> searchFamilyDataBeansForCFHCByVillageZambia(String search, String locationId, boolean isReverification, LinkedHashMap<String, String> qrData);

    List<FamilyDataBean> retrieveFamilyDataBeansForMergeFamily(String locationId, String search, long limit, long offset, LinkedHashMap<String, String> qrData);

    List<FamilyDataBean> retrieveFamilyDataBeansForFHSByArea(Long areaId, long limit, long offset);

    List<FamilyDataBean> searchFamilyDataBeansForFHSByArea(Long areaId, String search, LinkedHashMap<String, String> qrData);

    List<MemberDataBean> retrieveMemberDataBeansForDnhddAnemiaByFamilyId(String familyId);

    List<MemberDataBean> retrieveMemberDataBeansByFamily(String familyId);

    List<MemberDataBean> retrieveMembersWithin150mOfActiveMalariaCases(String locationId, String lat, String lng);

    Map<String, MemberDataBean> retrieveHeadMemberDataBeansByFamilyId(List<String> familyIds);

    FamilyDataBean retrieveFamilyDataBeanByFamilyId(String familyId);

    FamilyDataBean retrieveFamilyDataBeanByFamilyId(Long actualId);

    void markFamilyAsVerified(String familyId);

    void markFamilyAsCFHCVerified(String familyId);

    void markFamilyAsMigrated(String familyId);

    void markFamilyAsArchived(String familyId);

    List<LocationBean> getDistinctLocationsAssignedToUser();

    List<FhwServiceDetailBean> retrieveFhwServiceDetailBeansByVillageId(Integer locationId);

    List<MemberDataBean> retrieveMemberDataBeansExceptArchivedAndDeadByFamilyId(String familyId);

    List<MemberDataBean> retrieveMemberDataBeansExceptArchivedByFamilyIdForZambia(String familyId);

    void mergeFamilies(FamilyDataBean familyToBeExpanded, FamilyDataBean familyToBeMerged);

    Map<Long, MemberBean> retrieveMemberBeansMapByActualIds(List<Long> actualIds);

    List<MemberDataBean> retrieveMemberDataBeansByActualIds(List<Long> actualIds);

    String assignFamilyToUser(String locationId, FamilyDataBean familyDataBean);

    List<FieldValueMobDataBean> retrieveAnganwadiListFromSubcentreId(Integer subcentreId);

    Integer retrieveSubcenterIdFromAnganwadiId(Integer anganwadiId);

    RchVillageProfileDataBean getRchVillageProfileDataBean(String locationId);

    List<LocationBean> retrieveAshaAreaAssignedToUser(Integer villageId);

    List<MemberDataBean> retrieveEligibleCouplesByAshaArea(List<Integer> locationIds, Integer villageId, CharSequence searchString, long limit, long offset, LinkedHashMap<String, String> qrData);
    
    List<MemberDataBean> retrieveMembersForGbvZambia(List<Integer> locationIds, Integer villageId, CharSequence searchString, long limit, long offset);

    List<MemberDataBean> retrieveEligibleCouplesForZambia(List<Integer> locationIds, Integer villageId, CharSequence searchString, long limit, long offset, LinkedHashMap<String, String> qrData);
     List<MemberDataBean> retrievePregnantWomenByAshaArea(List<Integer> locationIds, boolean isHighRisk, List<Integer> villageIds, CharSequence searchString, long limit, long offset, LinkedHashMap<String, String> qrData);

    List<MemberDataBean> retrieveWPDWomenByAshaArea(List<Integer> locationIds, List<Integer> villageIds, CharSequence searchString, long limit, long offset, LinkedHashMap<String, String> qrData);

    List<MemberDataBean> retrievePncMothersByAshaArea(List<Integer> locationIds, Integer villageId, CharSequence searchString, long limit, long offset, LinkedHashMap<String, String> qrData);

    List<MemberDataBean> retrieveChildsBelow5YearsByAshaArea(List<Integer> locationIds, Boolean isHighRisk, List<Integer> villageIds, CharSequence s, long limit, long offset, LinkedHashMap<String, String> qrData);

     List<MemberDataBean> retrieveMembersByAshaArea(List<Integer> locationIds, Integer villageId, CharSequence searchString, long limit, long offset, LinkedHashMap<String, String> qrData);


    List<FamilyDataBean> retrieveFamilyDataBeansByAshaArea(List<Integer> locationIds, Integer villageId, CharSequence searchString, long limit, long offset, LinkedHashMap<String, String> qrData);

    MemberBean retrieveMemberBeanByActualId(Long memberId);

    MemberBean retrieveMemberBeanByUUID(String uuid);

    MemberBean retrieveMemberBeanByHealthId(String healthId);

    FamilyBean retrieveFamilyBeanByActualId(Long id);

    void markMemberAsMigrated(Long memberActualId);

    void markMemberAsDead(Long memberActualId);

    void updateMemberPregnantFlag(Long memberActualId, Boolean pregnantFlag);

    void updateMemberLmpDate(Long memberActualId, Date lmpDate);

    void updateFamily(FamilyBean familyBean);

    void deleteNotificationByMemberIdAndNotificationType(Long memberActualId, List<String> notificationTypes);

    void updateVaccinationGivenForChild(Long memberActualId, String vaccinationGiven);

    void updateVaccinationGivenForChild(String uniqueHealthId, String vaccinationGiven);

    void updateVaccinationGivenForChild(String uniqueHealthId, Map<String, String> dataMap);

    void markNotificationAsRead(NotificationMobDataBean notificationMobDataBean);

    String getChildrenCount(Long motherId, boolean total, boolean male, boolean female);

    MemberDataBean getLatestChildByMotherId(Long motherId);

    String getValueOfListValuesById(String id);

    String getConstOfListValueById(String id);

    Integer getIdOfListValueByConst(String constant);

    Map<String, String> retrieveAshaInfoByAreaId(String areaId);

    List<MemberDataBean> retrieveMemberListForRchRegister(List<Integer> locationIds, Integer villageId, CharSequence searchString, long limit, long offset, LinkedHashMap<String, String> qrData);

    List<MemberDataBean> retrieveHIVPositiveMembers(List<Integer> locationIds, Integer villageId, CharSequence searchString, long limit, long offset, LinkedHashMap<String, String> qrData);

    List<MemberDataBean> retrieveEMTCTMembers(List<Integer> locationIds, Integer villageId, CharSequence searchString, long limit, long offset, LinkedHashMap<String, String> qrData);

    List<MemberDataBean> retrieveMembersForTBScreening(List<Integer> locationIds, Integer villageId, CharSequence searchString, long limit, long offset, LinkedHashMap<String, String> qrData);

    List<MemberDataBean> retrieveMembersForMalariaScreening(List<Integer> locationIds, Integer villageId, CharSequence searchString, long limit, long offset, LinkedHashMap<String, String> qrData);

    List<MemberDataBean> retrievePositiveMembersForMalaria(List<Integer> locationIds, Integer villageId, CharSequence searchString, long limit, long offset, LinkedHashMap<String, String> qrData);

    List<MemberDataBean> retrieveMembersForHIVScreening(List<Integer> locationIds, Integer villageId, CharSequence searchString, long limit, long offset, LinkedHashMap<String, String> qrData);

    List<MemberDataBean> retrieveMembersForKnownScreening(List<Integer> locationIds, Integer villageId, CharSequence searchString, long limit, long offset, LinkedHashMap<String, String> qrData);

    List<MemberDataBean> retrieveMembersForChipScreening(List<Integer> locationIds, Integer villageId, CharSequence searchString, long limit, long offset, LinkedHashMap<String, String> qrData);

    long getMobileNumberCount(String mobileNumber);

    List<MemberBean> retrieveFamilyMembersContactListByMember(String familyId, String memberId);

    List<MemberDataBean> retrieveNewlyWedCouples(List<Integer> locationIds, Integer villageId, CharSequence searchString, long limit, long offset, LinkedHashMap<String, String> qrData);

    List<ListValueBean> retrieveListValues(String field);

    void markMemberBcgEligibleStatus(Long memberId);

    void markMemberBcgSurveyStatus(Long memberId);

    FamilyBean retrieveFamilyBeanByFamilyId(String familyId);
}
