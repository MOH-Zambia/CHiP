package com.argusoft.imtecho.migration.service.impl;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.common.util.SystemConstantUtil;
import com.argusoft.imtecho.dashboard.fhs.constants.FamilyHealthSurveyServiceConstants;
import com.argusoft.imtecho.event.dto.Event;
import com.argusoft.imtecho.event.service.EventHandler;
import com.argusoft.imtecho.exception.ImtechoMobileException;
import com.argusoft.imtecho.fhs.dao.FamilyDao;
import com.argusoft.imtecho.fhs.dao.FamilyStateDetailDao;
import com.argusoft.imtecho.fhs.dao.MemberDao;
import com.argusoft.imtecho.fhs.model.FamilyEntity;
import com.argusoft.imtecho.fhs.model.FamilyStateDetailEntity;
import com.argusoft.imtecho.fhs.model.MemberEntity;
import com.argusoft.imtecho.fhs.service.FamilyHealthSurveyService;
import com.argusoft.imtecho.location.dao.LocationMasterDao;
import com.argusoft.imtecho.migration.dao.FamilyMigrationEntityDao;
import com.argusoft.imtecho.migration.dto.FamilyMigrationDetailsDataBean;
import com.argusoft.imtecho.migration.dto.FamilyMigrationInConfirmationDataBean;
import com.argusoft.imtecho.migration.dto.FamilyMigrationOutDataBean;
import com.argusoft.imtecho.migration.dto.MigratedFamilyDataBean;
import com.argusoft.imtecho.migration.model.FamilyMigrationEntity;
import com.argusoft.imtecho.migration.model.MigrationEntity;
import com.argusoft.imtecho.migration.service.FamilyMigrationService;
import com.argusoft.imtecho.mobile.constants.MobileConstantUtil;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;
import com.argusoft.imtecho.notification.dao.NotificationTypeMasterDao;
import com.argusoft.imtecho.notification.dao.TechoNotificationMasterDao;
import com.argusoft.imtecho.notification.model.NotificationTypeMaster;
import com.argusoft.imtecho.notification.model.TechoNotificationMaster;
import com.argusoft.imtecho.notification.service.NotificationMasterService;
import com.argusoft.imtecho.rch.constants.RchConstants;
import com.argusoft.imtecho.rch.dao.AshaReportedEventDao;
import com.argusoft.imtecho.rch.model.AshaReportedEventMaster;
import com.argusoft.imtecho.rch.service.AshaReportedEventService;
import com.google.gson.Gson;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

/**
 * @author prateek on Aug 19, 2019
 */
@Service
@Transactional
public class FamilyMigrationServiceImpl implements FamilyMigrationService {

    @Autowired
    private FamilyMigrationEntityDao familyMigrationEntityDao;

    @Autowired
    private FamilyDao familyDao;

    @Autowired
    private MemberDao memberDao;

    @Autowired
    private EventHandler eventHandler;

    @Autowired
    private LocationMasterDao locationMasterDao;

    @Autowired
    private NotificationMasterService notificationMasterService;

    @Autowired
    private TechoNotificationMasterDao techoNotificationMasterDao;

    @Autowired
    private FamilyHealthSurveyService familyHealthSurveyService;

    @Autowired
    private FamilyStateDetailDao familyStateDetailDao;

    @Autowired
    private NotificationTypeMasterDao notificationTypeMasterDao;

    @Autowired
    private AshaReportedEventService ashaReportedEventService;

    @Autowired
    private AshaReportedEventDao ashaReportedEventDao;

    @Override
    public Integer storeFamilyMigrationOut(ParsedRecordBean parsedRecordBean, FamilyMigrationOutDataBean familyMigrationOutDataBean, UserMaster user) {
        Integer result;
        if (familyMigrationOutDataBean.getIsSplit() != null && familyMigrationOutDataBean.getIsSplit()) {
            if (familyMigrationOutDataBean.getIsCurrentLocation() != null && familyMigrationOutDataBean.getIsCurrentLocation()) {
                result = splitFamilyCurrentLocation(familyMigrationOutDataBean, user);
            } else if (familyMigrationOutDataBean.getOutOfState() != null && familyMigrationOutDataBean.getOutOfState()) {
                result = splitFamilyOutOfState(familyMigrationOutDataBean, user);
            } else if (familyMigrationOutDataBean.getLocationKnown() != null && familyMigrationOutDataBean.getLocationKnown()) {
                result = splitFamilyLocationKnown(familyMigrationOutDataBean, user);
            } else {
                // As discussed with Sethu sir, This scenario is discarded as the main family will know where the split family has migrated.
                throw new ImtechoMobileException("You cannot split and migrate a family with location not known.", 100);
            }
        } else if (familyMigrationOutDataBean.getOutOfState() != null && familyMigrationOutDataBean.getOutOfState()) {
            result = migrateFamilyOutOfState(familyMigrationOutDataBean, user);
        } else if (familyMigrationOutDataBean.getLocationKnown() != null && familyMigrationOutDataBean.getLocationKnown()) {
            result = migrateFamilyLocationKnown(familyMigrationOutDataBean, user);
        } else {
            result = migrateFamilyLocationNotKnown(familyMigrationOutDataBean, user);
        }
//        familyMigrationEntityDao.flush()
//        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.FAMILY_MIGRATION_OUT, result))

        if (parsedRecordBean.getNotificationId() != null && !parsedRecordBean.getNotificationId().equals("-1")) {
            TechoNotificationMaster notificationMaster = techoNotificationMasterDao.retrieveById(Integer.parseInt(parsedRecordBean.getNotificationId()));
            NotificationTypeMaster notificationTypeMaster = notificationTypeMasterDao.retrieveById(notificationMaster.getNotificationTypeId());
            if (notificationTypeMaster.getCode() != null &&
                    (notificationTypeMaster.getCode().equals(MobileConstantUtil.NOTIFICATION_FHW_FAMILY_MIGRATION)
                            || notificationTypeMaster.getCode().equals(MobileConstantUtil.NOTIFICATION_FHW_FAMILY_SPLIT))) {
                techoNotificationMasterDao.markNotificationAsCompleted(notificationMaster.getId(), user.getId());
                ashaReportedEventService.createReadOnlyNotificationForAsha(true, notificationTypeMaster.getCode(),
                        null, familyDao.retrieveById(familyMigrationOutDataBean.getFamilyId()), user);
            }

            if (notificationMaster.getRelatedId() != null && notificationMaster.getOtherDetails() != null &&
                    (notificationMaster.getOtherDetails().equals(MobileConstantUtil.ASHA_REPORT_FAMILY_MIGRATION)
                            || notificationMaster.getOtherDetails().equals(MobileConstantUtil.ASHA_REPORT_FAMILY_SPLIT))) {
                AshaReportedEventMaster eventMaster = ashaReportedEventDao.retrieveById(notificationMaster.getRelatedId());
                eventMaster.setAction(RchConstants.ASHA_REPORTED_EVENT_CONFIRMED);
                eventMaster.setActionOn(new Date(Long.parseLong(parsedRecordBean.getMobileDate())));
                eventMaster.setActionBy(user.getId());
                ashaReportedEventDao.update(eventMaster);
            }
        }

        return result;
    }

    private FamilyMigrationEntity getFamilyMigrationEntity(FamilyMigrationOutDataBean familyMigrationOutDataBean, FamilyEntity family, UserMaster user) {
        FamilyMigrationEntity familyMigrationEntity = new FamilyMigrationEntity();
        familyMigrationEntity.setOtherInformation(familyMigrationOutDataBean.getOtherInfo());
        familyMigrationEntity.setMobileData(new Gson().toJson(familyMigrationOutDataBean));
        familyMigrationEntity.setType(RchConstants.MIGRATION.MIGRATION_TYPE_OUT);
        familyMigrationEntity.setState(RchConstants.MIGRATION.MIGRATION_STATE_REPORTED);
        familyMigrationEntity.setReportedBy(user.getId());
        familyMigrationEntity.setReportedOn(new Date(familyMigrationOutDataBean.getReportedOn()));
        familyMigrationEntity.setFamilyId(family.getId());
        familyMigrationEntity.setLocationMigratedFrom(family.getLocationId());
        familyMigrationEntity.setAreaMigratedFrom(family.getAreaId());
        familyMigrationEntity.setReportedLocationId(family.getAreaId() != null ? family.getAreaId() : family.getLocationId());
        return familyMigrationEntity;
    }

    private Integer migrateFamilyOutOfState(FamilyMigrationOutDataBean familyMigrationOutDataBean, UserMaster user) {
        FamilyEntity family = familyDao.retrieveById(familyMigrationOutDataBean.getFamilyId());

        if (FamilyHealthSurveyServiceConstants.FHS_MIGRATED_CRITERIA_FAMILY_STATES.contains(family.getState())) {
            throw new ImtechoMobileException("Family is already migrated out.", 100);
        }

        FamilyMigrationEntity familyMigrationEntity = getFamilyMigrationEntity(familyMigrationOutDataBean, family, user);
        familyMigrationEntity.setIsSplitFamily(Boolean.FALSE);
        familyMigrationEntity.setIsCurrentLocation(Boolean.FALSE);
        familyMigrationEntity.setOutOfState(Boolean.TRUE);
        familyMigrationEntity.setMigratedLocationNotKnown(Boolean.TRUE);
        //confirm this migration
        familyMigrationEntity.setConfirmedOn(new Date());
        familyMigrationEntity.setConfirmedBy(user.getId());
        familyMigrationEntity.setState(RchConstants.MIGRATION.MIGRATION_STATE_CONFIRMED);
        familyMigrationEntityDao.create(familyMigrationEntity);

        //mark this family as migrated
        family.setState(FamilyHealthSurveyServiceConstants.FHS_FAMILY_STATE_MIGRATED_OUT_OF_STATE);
        familyDao.update(family);

        //send read only notification for migration out
        StringBuilder memberDet = new StringBuilder();
        List<MemberEntity> memberEntities = memberDao.retrieveMemberEntitiesByFamilyId(family.getFamilyId());
        for (MemberEntity memberEntity : memberEntities) {
            if (!FamilyHealthSurveyServiceConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES.contains(memberEntity.getState())) {
                memberDet.append(memberEntity.getUniqueHealthId())
                        .append(" - ")
                        .append(memberEntity.getFirstName())
                        .append(" ")
                        .append(memberEntity.getMiddleName())
                        .append(" ")
                        .append(memberEntity.getLastName())
                        .append("\n");
            }
        }

        String header = "Family Migration - " + family.getFamilyId();
        String sb = "Your request for Migration of family Out of State has been approved.\n\n"
                + "Family ID : "
                + family.getFamilyId()
                + "\n\n"
                + "Members migrated Out of State:\n"
                + memberDet.toString();
        createReadOnlyNotificationForMigration(family.getId(), family.getLocationId(), familyMigrationEntity.getId(), sb, header);

        return familyMigrationEntity.getId();
    }

    private Integer migrateFamilyLocationKnown(FamilyMigrationOutDataBean familyMigrationOutDataBean, UserMaster user) {
        FamilyEntity family = familyDao.retrieveById(familyMigrationOutDataBean.getFamilyId());

        if (FamilyHealthSurveyServiceConstants.FHS_MIGRATED_CRITERIA_FAMILY_STATES.contains(family.getState())) {
            throw new ImtechoMobileException("Family is already migrated.", 100);
        }

        FamilyMigrationEntity familyMigrationEntity = getFamilyMigrationEntity(familyMigrationOutDataBean, family, user);
        familyMigrationEntity.setIsSplitFamily(Boolean.FALSE);
        familyMigrationEntity.setIsCurrentLocation(Boolean.FALSE);
        familyMigrationEntity.setOutOfState(Boolean.FALSE);
        familyMigrationEntity.setMigratedLocationNotKnown(Boolean.FALSE);
        familyMigrationEntity.setLocationMigratedTo(familyMigrationOutDataBean.getToLocationId());
        familyMigrationEntityDao.create(familyMigrationEntity);

        //marking this family as migrated
        family.setState(FamilyHealthSurveyServiceConstants.FHS_FAMILY_STATE_MIGRATED);
        familyDao.update(family);

        //Creating member details string for showing member details for confirmation notification
        List<String> memberDetails = new ArrayList<>();
        List<MemberEntity> memberEntities = memberDao.retrieveMemberEntitiesByFamilyId(family.getFamilyId());
        for (MemberEntity memberEntity : memberEntities) {
            if (!FamilyHealthSurveyServiceConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES.contains(memberEntity.getState())) {
                memberDetails.add(memberEntity.getUniqueHealthId() + " - " + memberEntity.getFirstName() + " " + memberEntity.getMiddleName() + " " + memberEntity.getLastName());
            }
        }

        //Creating FamilyDetailsDataBean for showing family details for Confirmation Notification
        FamilyMigrationDetailsDataBean familyMigrationDetailsDataBean = new FamilyMigrationDetailsDataBean();
        familyMigrationDetailsDataBean.setFamilyId(family.getId());
        familyMigrationDetailsDataBean.setFamilyIdString(family.getFamilyId());
        familyMigrationDetailsDataBean.setLocationDetails(locationMasterDao.retrieveLocationHierarchyById(family.getLocationId()));
        if (family.getAreaId() != null) {
            familyMigrationDetailsDataBean.setAreaDetails(locationMasterDao.retrieveLocationHierarchyById(family.getAreaId()));
        }
        familyMigrationDetailsDataBean.setFhwDetails(
                user.getFirstName() + " " + user.getMiddleName() + " " + user.getLastName() + " (" + user.getContactNumber() + ")");
        familyMigrationDetailsDataBean.setMemberDetails(memberDetails);
        familyMigrationDetailsDataBean.setOtherInfo(familyMigrationOutDataBean.getOtherInfo());

        //Creating family migration confirmation notification for next FHW.
        TechoNotificationMaster techoNotificationMaster = new TechoNotificationMaster();
        techoNotificationMaster.setNotificationCode(null);
        techoNotificationMaster.setNotificationTypeId(
                notificationMasterService.retrieveByCode(MobileConstantUtil.FAMILY_MIGRATION_IN_CONFIRMATION).getId());
        techoNotificationMaster.setLocationId(familyMigrationEntity.getLocationMigratedTo());
        techoNotificationMaster.setOtherDetails(new Gson().toJson(familyMigrationDetailsDataBean));
        techoNotificationMaster.setScheduleDate(new Date());
        techoNotificationMaster.setState(TechoNotificationMaster.State.PENDING);
        techoNotificationMaster.setMigrationId(familyMigrationEntity.getId());
        techoNotificationMaster.setFamilyId(family.getId());
        techoNotificationMasterDao.create(techoNotificationMaster);

        return familyMigrationEntity.getId();
    }

    //Currently we are just marking this family as migrated as this migration should go to web for resolution
    private Integer migrateFamilyLocationNotKnown(FamilyMigrationOutDataBean familyMigrationOutDataBean, UserMaster user) {
        FamilyEntity family = familyDao.retrieveById(familyMigrationOutDataBean.getFamilyId());

        if (FamilyHealthSurveyServiceConstants.FHS_MIGRATED_CRITERIA_FAMILY_STATES.contains(family.getState())) {
            throw new ImtechoMobileException("Family is already migrated.", 100);
        }

        FamilyMigrationEntity familyMigrationEntity = getFamilyMigrationEntity(familyMigrationOutDataBean, family, user);
        familyMigrationEntity.setIsSplitFamily(Boolean.FALSE);
        familyMigrationEntity.setIsCurrentLocation(Boolean.FALSE);
        familyMigrationEntity.setOutOfState(Boolean.FALSE);
        familyMigrationEntity.setMigratedLocationNotKnown(Boolean.TRUE);
        familyMigrationEntityDao.create(familyMigrationEntity);

        //mark this family as migrated
        family.setState(FamilyHealthSurveyServiceConstants.FHS_FAMILY_STATE_MIGRATED_LFU);
        familyDao.update(family);

        return familyMigrationEntity.getId();
    }

    private Integer splitFamilyCurrentLocation(FamilyMigrationOutDataBean familyMigrationOutDataBean, UserMaster user) {
        FamilyEntity family = familyDao.retrieveById(familyMigrationOutDataBean.getFamilyId());
        FamilyMigrationEntity familyMigrationEntity = getFamilyMigrationEntity(familyMigrationOutDataBean, family, user);
        familyMigrationEntity.setIsSplitFamily(Boolean.TRUE);
        familyMigrationEntity.setIsCurrentLocation(Boolean.TRUE);
        familyMigrationEntity.setOutOfState(Boolean.FALSE);
        familyMigrationEntity.setMigratedLocationNotKnown(Boolean.FALSE);

        Map<String, FamilyEntity> map = createNewSplitFamily(familyMigrationEntity, family);

        Map.Entry<String, FamilyEntity> next = map.entrySet().iterator().next();
        String memberDetails = next.getKey();
        FamilyEntity splitFamily = next.getValue();

        familyMigrationEntity.setSplitFamilyId(splitFamily.getId());
        familyMigrationEntity.setLocationMigratedTo(family.getLocationId());
        familyMigrationEntity.setAreaMigratedTo(family.getAreaId());
        familyMigrationEntity.setState(RchConstants.MIGRATION.MIGRATION_STATE_CONFIRMED);
        familyMigrationEntity.setConfirmedBy(user.getId());
        familyMigrationEntity.setConfirmedOn(new Date());
        familyMigrationEntity.setMemberIds(StringUtils.join(familyMigrationOutDataBean.getMemberIds(), ','));
        familyMigrationEntityDao.create(familyMigrationEntity);

        if (familyMigrationOutDataBean.getNewHead() != null) {
            if (familyMigrationOutDataBean.getExistingHeadSelected() != null &&
                    familyMigrationOutDataBean.getExistingHeadSelected()) {
                family.setHeadOfFamily(familyMigrationOutDataBean.getNewHead());
                familyDao.update(family);

                //When head of the family will get split all the relation with hof will be wrong
                //so making relation with hof null
                List<MemberEntity> membersInTheFamily = memberDao.retrieveMemberEntitiesByFamilyId(family.getFamilyId());
                if (membersInTheFamily != null && !membersInTheFamily.isEmpty()){
                    for (MemberEntity member : membersInTheFamily) {
                        member.setRelationWithHof(null);
                        memberDao.update(member);
                    }
                }
            } else {
                splitFamily.setHeadOfFamily(familyMigrationOutDataBean.getNewHead());
                familyDao.update(splitFamily);
            }

            if (familyMigrationOutDataBean.getRelationWithHofMap() != null &&
                    !familyMigrationOutDataBean.getRelationWithHofMap().isEmpty()) {
                for (Map.Entry<String, String> relWithHof : familyMigrationOutDataBean.getRelationWithHofMap().entrySet()) {
                    MemberEntity memberEntity = memberDao.retrieveMemberById(Integer.parseInt(relWithHof.getKey()));
                    memberEntity.setRelationWithHof(relWithHof.getValue());
                    memberDao.update(memberEntity);
                }
            }

            MemberEntity memberEntity = memberDao.retrieveMemberById(familyMigrationOutDataBean.getNewHead());
            memberEntity.setFamilyHeadFlag(true);
            memberDao.update(memberEntity);
        }

        String header = "Family Split - " + family.getFamilyId();

        String sb = "Your request for split family in the same location has been approved."
                + "\n\nFamily split from : "
                + family.getFamilyId()
                + "\n\nNew split family details :"
                + "\nFamily ID - "
                + splitFamily.getFamilyId()
                + "\nMember Details\n"
                + memberDetails;
        createReadOnlyNotificationForMigration(family.getId(), family.getLocationId(), familyMigrationEntity.getId(), sb, header);

        return familyMigrationEntity.getId();
    }

    private Integer splitFamilyOutOfState(FamilyMigrationOutDataBean familyMigrationOutDataBean, UserMaster user) {
        FamilyEntity family = familyDao.retrieveById(familyMigrationOutDataBean.getFamilyId());
        FamilyMigrationEntity familyMigrationEntity = getFamilyMigrationEntity(familyMigrationOutDataBean, family, user);
        familyMigrationEntity.setIsSplitFamily(Boolean.TRUE);
        familyMigrationEntity.setIsCurrentLocation(Boolean.FALSE);
        familyMigrationEntity.setOutOfState(Boolean.TRUE);
        familyMigrationEntity.setMigratedLocationNotKnown(Boolean.TRUE);

        Map<String, FamilyEntity> map = createNewSplitFamily(familyMigrationEntity, family);
        Map.Entry<String, FamilyEntity> next = map.entrySet().iterator().next();
        String memberDet = next.getKey();
        FamilyEntity splitFamily = next.getValue();

        //Setting new split family id
        familyMigrationEntity.setMemberIds(StringUtils.join(familyMigrationOutDataBean.getMemberIds(), ','));
        familyMigrationEntity.setSplitFamilyId(splitFamily.getId());
        familyMigrationEntity.setConfirmedBy(user.getId());
        familyMigrationEntity.setConfirmedOn(new Date());
        familyMigrationEntity.setState(RchConstants.MIGRATION.MIGRATION_STATE_CONFIRMED);
        familyMigrationEntityDao.create(familyMigrationEntity);

        splitFamily.setState(FamilyHealthSurveyServiceConstants.FHS_FAMILY_STATE_MIGRATED_OUT_OF_STATE);
        familyDao.update(splitFamily);

        if (familyMigrationOutDataBean.getNewHead() != null) {
            if (familyMigrationOutDataBean.getExistingHeadSelected() != null &&
                    familyMigrationOutDataBean.getExistingHeadSelected()) {
                family.setHeadOfFamily(familyMigrationOutDataBean.getNewHead());
                familyDao.update(family);

                //When head of the family will get split all the relation with hof will be wrong
                //so making relation with hof null
                List<MemberEntity> membersInTheFamily = memberDao.retrieveMemberEntitiesByFamilyId(family.getFamilyId());
                if (membersInTheFamily != null && !membersInTheFamily.isEmpty()){
                    for (MemberEntity member : membersInTheFamily) {
                        member.setRelationWithHof(null);
                        memberDao.update(member);
                    }
                }
            } else {
                splitFamily.setHeadOfFamily(familyMigrationOutDataBean.getNewHead());
                familyDao.update(splitFamily);
            }

            if (familyMigrationOutDataBean.getRelationWithHofMap() != null &&
                    !familyMigrationOutDataBean.getRelationWithHofMap().isEmpty()) {
                for (Map.Entry<String, String> relWithHof : familyMigrationOutDataBean.getRelationWithHofMap().entrySet()) {
                    MemberEntity memberEntity = memberDao.retrieveMemberById(Integer.parseInt(relWithHof.getKey()));
                    memberEntity.setRelationWithHof(relWithHof.getValue());
                    memberDao.update(memberEntity);
                }
            }

            MemberEntity memberEntity = memberDao.retrieveMemberById(familyMigrationOutDataBean.getNewHead());
            memberEntity.setFamilyHeadFlag(true);
            memberDao.update(memberEntity);
        }

        String header = "Family Split - " + family.getFamilyId();

        String sb = "Your request for split family migration out of state has been approved."
                + "\n\nFamily split from : "
                + family.getFamilyId()
                + "\n\nNew split family details :"
                + "\nFamily ID - "
                + splitFamily.getFamilyId()
                + "\nMember Details\n"
                + memberDet;
        createReadOnlyNotificationForMigration(family.getId(), family.getLocationId(), familyMigrationEntity.getId(), sb, header);

        return familyMigrationEntity.getId();
    }

    private Integer splitFamilyLocationKnown(FamilyMigrationOutDataBean familyMigrationOutDataBean, UserMaster user) {
        FamilyEntity family = familyDao.retrieveById(familyMigrationOutDataBean.getFamilyId());
        FamilyMigrationEntity familyMigrationEntity = getFamilyMigrationEntity(familyMigrationOutDataBean, family, user);
        familyMigrationEntity.setIsSplitFamily(Boolean.TRUE);
        familyMigrationEntity.setIsCurrentLocation(Boolean.FALSE);
        familyMigrationEntity.setOutOfState(Boolean.FALSE);
        familyMigrationEntity.setMigratedLocationNotKnown(Boolean.FALSE);
        familyMigrationEntity.setLocationMigratedTo(familyMigrationOutDataBean.getToLocationId());

        Map<String, FamilyEntity> map = this.createNewSplitFamily(familyMigrationEntity, family);

        Map.Entry<String, FamilyEntity> next = map.entrySet().iterator().next();
        String memberDet = next.getKey();
        FamilyEntity splitFamily = next.getValue();

        //Setting new split family id
        familyMigrationEntity.setSplitFamilyId(splitFamily.getId());
        familyMigrationEntity.setMemberIds(StringUtils.join(familyMigrationOutDataBean.getMemberIds(), ','));
        familyMigrationEntityDao.create(familyMigrationEntity);

        splitFamily.setState(FamilyHealthSurveyServiceConstants.FHS_FAMILY_STATE_MIGRATED);
        familyDao.update(splitFamily);

        if (familyMigrationOutDataBean.getNewHead() != null) {
            if (familyMigrationOutDataBean.getExistingHeadSelected() != null &&
                    familyMigrationOutDataBean.getExistingHeadSelected()) {
                family.setHeadOfFamily(familyMigrationOutDataBean.getNewHead());
                familyDao.update(family);

                //When head of the family will get split all the relation with hof will be wrong
                //so making relation with hof null
                List<MemberEntity> membersInTheFamily = memberDao.retrieveMemberEntitiesByFamilyId(family.getFamilyId());
                if (membersInTheFamily != null && !membersInTheFamily.isEmpty()){
                    for (MemberEntity member : membersInTheFamily) {
                        member.setRelationWithHof(null);
                        memberDao.update(member);
                    }
                }
            } else {
                splitFamily.setHeadOfFamily(familyMigrationOutDataBean.getNewHead());
                familyDao.update(splitFamily);
            }

            if (familyMigrationOutDataBean.getRelationWithHofMap() != null &&
                    !familyMigrationOutDataBean.getRelationWithHofMap().isEmpty()) {
                for (Map.Entry<String, String> relWithHof : familyMigrationOutDataBean.getRelationWithHofMap().entrySet()) {
                    MemberEntity memberEntity = memberDao.retrieveMemberById(Integer.parseInt(relWithHof.getKey()));
                    memberEntity.setRelationWithHof(relWithHof.getValue());
                    memberDao.update(memberEntity);
                }
            }

            MemberEntity memberEntity = memberDao.retrieveMemberById(familyMigrationOutDataBean.getNewHead());
            memberEntity.setFamilyHeadFlag(true);
            memberDao.update(memberEntity);
        }

        List<String> memberDetails = new ArrayList<>();
        memberDetails.add(memberDet);
        FamilyMigrationDetailsDataBean familyMigrationDetailsDataBean = new FamilyMigrationDetailsDataBean();
        familyMigrationDetailsDataBean.setFamilyId(family.getId());
        familyMigrationDetailsDataBean.setFamilyIdString(family.getFamilyId());
        familyMigrationDetailsDataBean.setLocationDetails(locationMasterDao.retrieveLocationHierarchyById(family.getLocationId()));
        if (family.getAreaId() != null) {
            familyMigrationDetailsDataBean.setAreaDetails(locationMasterDao.retrieveLocationHierarchyById(family.getAreaId()));
        }
        familyMigrationDetailsDataBean.setFhwDetails(
                user.getFirstName() + " " + user.getMiddleName() + " " + user.getLastName() + " (" + user.getContactNumber() + ")");
        familyMigrationDetailsDataBean.setMemberDetails(memberDetails);
        familyMigrationDetailsDataBean.setOtherInfo(familyMigrationOutDataBean.getOtherInfo());

        TechoNotificationMaster techoNotificationMaster = new TechoNotificationMaster();
        techoNotificationMaster.setNotificationCode(null);
        techoNotificationMaster.setNotificationTypeId(
                notificationMasterService.retrieveByCode(MobileConstantUtil.FAMILY_MIGRATION_IN_CONFIRMATION).getId());
        techoNotificationMaster.setLocationId(familyMigrationEntity.getLocationMigratedTo());

        techoNotificationMaster.setOtherDetails(new Gson().toJson(familyMigrationDetailsDataBean));
        techoNotificationMaster.setScheduleDate(new Date());
        techoNotificationMaster.setState(TechoNotificationMaster.State.PENDING);
        techoNotificationMaster.setMigrationId(familyMigrationEntity.getId());
        techoNotificationMaster.setFamilyId(family.getId());
        techoNotificationMasterDao.create(techoNotificationMaster);

        return familyMigrationEntity.getId();
    }

    private Map<String, FamilyEntity> createNewSplitFamily(FamilyMigrationEntity familyMigrationEntity, FamilyEntity mainFamily) {
        FamilyMigrationOutDataBean outDataBean = new Gson().fromJson(familyMigrationEntity.getMobileData(), FamilyMigrationOutDataBean.class);
        FamilyEntity splitFamily = new FamilyEntity();
        splitFamily.setFamilyId(familyHealthSurveyService.generateFamilyId());
        splitFamily.setLocationId(mainFamily.getLocationId());
        splitFamily.setAreaId(mainFamily.getAreaId());
        splitFamily.setState(FamilyHealthSurveyServiceConstants.FHS_FAMILY_STATE_UNVERIFIED);
        splitFamily.setSplitFrom(mainFamily.getId());
        familyDao.createFamily(splitFamily);

        StringBuilder sb = new StringBuilder();
        for (Integer memberId : outDataBean.getMemberIds()) {
            MemberEntity memberEntity = memberDao.retrieveById(memberId);
            memberEntity.setFamilyId(splitFamily.getFamilyId());
            if (memberEntity.getFamilyHeadFlag() != null && memberEntity.getFamilyHeadFlag()) {
                splitFamily.setHeadOfFamily(memberId);
                familyDao.update(splitFamily);
            }
            memberEntity.setRelationWithHof(null);
            memberDao.update(memberEntity);
            sb.append(memberEntity.getUniqueHealthId())
                    .append(" - ")
                    .append(memberEntity.getFirstName())
                    .append(" ")
                    .append(memberEntity.getMiddleName())
                    .append(" ")
                    .append(memberEntity.getLastName())
                    .append("\n");
        }

        HashMap<String, FamilyEntity> map = new HashMap<>();
        map.put(sb.toString(), splitFamily);

        return map;
    }

    private void createReadOnlyNotificationForMigration(Integer familyId, Integer locationId, Integer migrationId, String otherDetails, String header) {
        TechoNotificationMaster notification = new TechoNotificationMaster();
        notification.setNotificationCode(null);
        notification.setNotificationTypeId(notificationMasterService.retrieveByCode("READ_ONLY").getId());
        notification.setState(TechoNotificationMaster.State.PENDING);
        notification.setScheduleDate(new Date());
        notification.setFamilyId(familyId);
        notification.setLocationId(locationId);
        notification.setMigrationId(migrationId);
        notification.setHeader(header);
        notification.setOtherDetails(otherDetails);
        techoNotificationMasterDao.create(notification);
    }

    @Override
    public Integer storeFamilyMigrationInConfirmation(FamilyMigrationInConfirmationDataBean familyMigrationInConfirmation, UserMaster user) {
        FamilyMigrationEntity familyMigrationEntity = familyMigrationEntityDao.retrieveById(familyMigrationInConfirmation.getMigrationId());

        if (familyMigrationEntity.getState().equals(RchConstants.MIGRATION.MIGRATION_STATE_CONFIRMED)) {
            techoNotificationMasterDao.markNotificationAsCompleted(familyMigrationInConfirmation.getNotificationId(), user.getId());
            throw new ImtechoMobileException("This migration has already been confirmed.", 100);
        }

        if (familyMigrationEntity.getState().equals(RchConstants.MIGRATION.MIGRATION_STATE_NOT_HAPPENED)) {
            techoNotificationMasterDao.markNotificationAsCompleted(familyMigrationInConfirmation.getNotificationId(), user.getId());
            throw new ImtechoMobileException("This migration has already been rejected.", 100);
        }

        if (familyMigrationEntity.getState().equals(RchConstants.MIGRATION.MIGRATION_STATE_NO_RESPONSE)) {
            techoNotificationMasterDao.markNotificationAsCompleted(familyMigrationInConfirmation.getNotificationId(), user.getId());
            throw new ImtechoMobileException("We got no response from you within 7 days. So this migration has been rejected.", 100);
        }

        if (familyMigrationEntity.getState().equals(RchConstants.MIGRATION.MIGRATION_STATE_REVERTED)) {
            techoNotificationMasterDao.markNotificationAsCompleted(familyMigrationInConfirmation.getNotificationId(), user.getId());
            throw new ImtechoMobileException("This migration has already been reverted.", 100);
        }

        if (!familyMigrationEntity.getState().equals(RchConstants.MIGRATION.MIGRATION_STATE_REPORTED)) {
            techoNotificationMasterDao.markNotificationAsCompleted(familyMigrationInConfirmation.getNotificationId(), user.getId());
            throw new ImtechoMobileException("This migration has already been marked completed.", 100);
        }

        if (familyMigrationInConfirmation.getHasMigrationHappened() != null && familyMigrationInConfirmation.getHasMigrationHappened()) {
            familyMigrationEntity.setAreaMigratedTo(familyMigrationInConfirmation.getAreaMigratedTo());
            familyMigrationEntity.setState(RchConstants.MIGRATION.MIGRATION_STATE_CONFIRMED);
            if (familyMigrationEntity.getIsSplitFamily() != null && familyMigrationEntity.getIsSplitFamily()) {
                confirmSplitFamilyMigration(familyMigrationEntity, user);
            } else {
                confirmFullFamilyMigration(familyMigrationEntity, user);
            }
        } else {
            familyMigrationEntity.setState(RchConstants.MIGRATION.MIGRATION_STATE_NOT_HAPPENED);
            if (familyMigrationEntity.getIsSplitFamily() != null && familyMigrationEntity.getIsSplitFamily()) {
                rejectSplitFamilyMigration(familyMigrationEntity, user);
            } else {
                rejectFullFamilyMigration(familyMigrationEntity, user);
            }
        }

        familyMigrationEntity.setConfirmedBy(user.getId());
        familyMigrationEntity.setConfirmedOn(new Date());

        techoNotificationMasterDao.markNotificationAsCompleted(familyMigrationInConfirmation.getNotificationId(), user.getId());

        familyMigrationEntityDao.update(familyMigrationEntity);
        familyMigrationEntityDao.flush();
        return familyMigrationEntity.getId();
    }

    private void confirmSplitFamilyMigration(FamilyMigrationEntity familyMigrationEntity, UserMaster user) {
        FamilyEntity family = familyDao.retrieveById(familyMigrationEntity.getFamilyId());

        FamilyEntity splitFamily = familyDao.retrieveById(familyMigrationEntity.getSplitFamilyId());
        splitFamily.setLocationId(familyMigrationEntity.getLocationMigratedTo());
        splitFamily.setAreaId(familyMigrationEntity.getAreaMigratedTo());
        splitFamily.setState(FamilyHealthSurveyServiceConstants.FHS_FAMILY_STATE_UNVERIFIED);
        familyDao.update(splitFamily);

        List<MemberEntity> memberEntities = memberDao.retrieveMemberEntitiesByFamilyId(splitFamily.getFamilyId());
        StringBuilder memberDetails = new StringBuilder();
        for (MemberEntity memberEntity : memberEntities) {
            if (!FamilyHealthSurveyServiceConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES.contains(memberEntity.getState())) {
                memberDetails.append(memberEntity.getUniqueHealthId())
                        .append(" - ")
                        .append(memberEntity.getFirstName())
                        .append(" ")
                        .append(memberEntity.getMiddleName())
                        .append(" ")
                        .append(memberEntity.getLastName());
            }
        }

        String header = "Family Split - " + family.getFamilyId();
        String sb = "Your request for split and migrate a family in another location has been approved."
                + "\n\nFamily split from : "
                + family.getFamilyId()
                + "\n\nNew split family details :"
                + "\nFamily ID - "
                + splitFamily.getFamilyId()
                + "\nMember Details\n"
                + memberDetails.toString()
                + "\nLocation migrated to : "
                + locationMasterDao.retrieveLocationHierarchyById(splitFamily.getLocationId())
                + "\nConfirmed by : "
                + user.getFirstName() + " " + user.getMiddleName() + " " + user.getLastName()
                + " (" + user.getContactNumber() + ")";
        createReadOnlyNotificationForMigration(family.getId(), family.getLocationId(), familyMigrationEntity.getId(), sb, header);
    }

    private void rejectSplitFamilyMigration(FamilyMigrationEntity familyMigrationEntity, UserMaster user) {
        FamilyMigrationOutDataBean familyMigrationOutDataBean = new Gson().fromJson(familyMigrationEntity.getMobileData(), FamilyMigrationOutDataBean.class);
        FamilyEntity family = familyDao.retrieveById(familyMigrationEntity.getFamilyId());

        FamilyEntity splitFamily = familyDao.retrieveById(familyMigrationEntity.getSplitFamilyId());
        splitFamily.setState(FamilyHealthSurveyServiceConstants.FHS_FAMILY_STATE_ARCHIVED);
        familyDao.update(splitFamily);

        List<MemberEntity> memberEntities = memberDao.retrieveMemberEntitiesByFamilyId(splitFamily.getFamilyId());
        Integer oldHeadId = null;
        StringBuilder memberDetails = new StringBuilder();
        for (MemberEntity memberEntity : memberEntities) {
            memberEntity.setFamilyId(family.getFamilyId());
            if (familyMigrationOutDataBean.getNewHead() != null && familyMigrationOutDataBean.getNewHead().equals(memberEntity.getId())) {
                memberEntity.setFamilyHeadFlag(false);
            }
            memberDao.update(memberEntity);

            if (memberEntity.getFamilyHeadFlag() != null && memberEntity.getFamilyHeadFlag()) {
                oldHeadId = memberEntity.getId();
            }
            memberDetails.append(memberEntity.getUniqueHealthId())
                    .append(" - ")
                    .append(memberEntity.getFirstName())
                    .append(" ")
                    .append(memberEntity.getMiddleName())
                    .append(" ")
                    .append(memberEntity.getLastName());
        }

        if (oldHeadId != null && !oldHeadId.equals(family.getHeadOfFamily())) {
            family.setHeadOfFamily(oldHeadId);
            familyDao.update(family);
        }

        String header = "Family Split - " + family.getFamilyId();
        String sb = "Your request for split and migrate a family in another location has been rejected."
                + "\n\nFamily split from : "
                + family.getFamilyId()
                + "\n\nNew split family details :"
                + "\nFamily ID - "
                + splitFamily.getFamilyId()
                + "\nMember Details\n"
                + memberDetails.toString()
                + "\nLocation migrated to : "
                + locationMasterDao.retrieveLocationHierarchyById(splitFamily.getLocationId())
                + "\nRejected by : "
                + user.getFirstName() + " " + user.getMiddleName() + " " + user.getLastName()
                + " (" + user.getContactNumber() + ")";
        createReadOnlyNotificationForMigration(family.getId(), family.getLocationId(), familyMigrationEntity.getId(), sb, header);
    }

    private void confirmFullFamilyMigration(FamilyMigrationEntity familyMigrationEntity, UserMaster user) {
        FamilyEntity family = familyDao.retrieveById(familyMigrationEntity.getFamilyId());

        FamilyStateDetailEntity familyStateDetailEntity = familyStateDetailDao.retrieveById(family.getCurrentState());

        family.setLocationId(familyMigrationEntity.getLocationMigratedTo());
        family.setAreaId(familyMigrationEntity.getAreaMigratedTo());
        family.setState(familyStateDetailEntity.getFromState());
        familyDao.update(family);

        List<MemberEntity> memberEntities = memberDao.retrieveMemberEntitiesByFamilyId(family.getFamilyId());
        StringBuilder memberDetails = new StringBuilder();
        for (MemberEntity memberEntity : memberEntities) {
            if (!FamilyHealthSurveyServiceConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES.contains(memberEntity.getState())) {
                memberDetails.append(memberEntity.getUniqueHealthId())
                        .append(" - ")
                        .append(memberEntity.getFirstName())
                        .append(" ")
                        .append(memberEntity.getMiddleName())
                        .append(" ")
                        .append(memberEntity.getLastName());
            }
        }

        String header = "Family Migration - " + family.getFamilyId();
        String sb = "Your request for migrate a family in another location has been approved."
                + "\nMigrated Family ID - "
                + family.getFamilyId()
                + "\nMember Details\n"
                + memberDetails.toString()
                + "\nLocation migrated to : "
                + locationMasterDao.retrieveLocationHierarchyById(family.getLocationId())
                + "\nConfirmed by : "
                + user.getFirstName() + " " + user.getMiddleName() + " " + user.getLastName()
                + " (" + user.getContactNumber() + ")";
        createReadOnlyNotificationForMigration(family.getId(), family.getLocationId(), familyMigrationEntity.getId(), sb, header);
    }

    private void rejectFullFamilyMigration(FamilyMigrationEntity familyMigrationEntity, UserMaster user) {
        FamilyEntity family = familyDao.retrieveById(familyMigrationEntity.getFamilyId());
        family.setState(familyStateDetailDao.retrieveById(family.getCurrentState()).getFromState());
        familyDao.update(family);

        List<MemberEntity> memberEntities = memberDao.retrieveMemberEntitiesByFamilyId(family.getFamilyId());
        StringBuilder memberDetails = new StringBuilder();
        for (MemberEntity memberEntity : memberEntities) {
            memberDetails.append(memberEntity.getUniqueHealthId())
                    .append(" - ")
                    .append(memberEntity.getFirstName())
                    .append(" ")
                    .append(memberEntity.getMiddleName())
                    .append(" ")
                    .append(memberEntity.getLastName());
        }

        String header = "Family Migration - " + family.getFamilyId();
        String sb = "Your request for migrate a family in another location has been rejected."
                + "\nMigrated Family ID - "
                + family.getFamilyId()
                + "\nMember Details\n"
                + memberDetails.toString()
                + "\nLocation migrated to : "
                + locationMasterDao.retrieveLocationHierarchyById(family.getLocationId())
                + "\nRejected by : "
                + user.getFirstName() + " " + user.getMiddleName() + " " + user.getLastName()
                + " (" + user.getContactNumber() + ")";
        createReadOnlyNotificationForMigration(family.getId(), family.getLocationId(), familyMigrationEntity.getId(), sb, header);
    }

    @Override
    public List<MigratedFamilyDataBean> retrieveMigrationByLocation(Integer userId) {
        return familyMigrationEntityDao.retrieveMigrationByLocation(userId);
    }

    @Override
    public Integer revertMigration(MigratedFamilyDataBean migratedFamilyDataBean, UserMaster user) {
        if (migratedFamilyDataBean != null) {
            FamilyMigrationEntity migrationEntity = familyMigrationEntityDao.retrieveById(migratedFamilyDataBean.getMigrationId());

            if (migrationEntity.getState().equals(RchConstants.MIGRATION.MIGRATION_STATE_REVERTED)) {
                throw new ImtechoMobileException("This migration has already been reverted.", 100);
            }

            if (migrationEntity.getState().equals(RchConstants.MIGRATION.MIGRATION_STATE_NOT_HAPPENED)) {
                throw new ImtechoMobileException("This migration has already been rejected by the other user.", 100);
            }

            if (migrationEntity.getState().equals(RchConstants.MIGRATION.MIGRATION_STATE_NO_RESPONSE)) {
                throw new ImtechoMobileException("This migration has already been rejected", 100);
            }

            migrationEntity.setState(RchConstants.MIGRATION.MIGRATION_STATE_REVERTED);

            familyMigrationEntityDao.update(migrationEntity);
            familyMigrationEntityDao.flush();
            eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.FAMILY_MIGRATION_REVERTED, migrationEntity.getId()));

            StringBuilder sb = new StringBuilder();
            sb.append("The migration of this family has been Reverted.");
            sb.append("\n").append("\n")
                    .append("Family ID : ")
                    .append(migratedFamilyDataBean.getFamilyIdString());

            if (migrationEntity.getLocationMigratedFrom() != null) {
                sb.append("\n")
                        .append("Location Migrated from : ")
                        .append(locationMasterDao.retrieveById(migrationEntity.getLocationMigratedFrom()).getName());
            }
            if (migrationEntity.getLocationMigratedTo() != null) {
                sb.append("\n")
                        .append("Location Migrated to : ")
                        .append(locationMasterDao.retrieveById(migrationEntity.getLocationMigratedTo()).getName());
            }

            StringBuilder header = new StringBuilder();
            header.append(migratedFamilyDataBean.getFamilyIdString())
                    .append("\n")
                    .append("Reverted Family Migration");

            TechoNotificationMaster techoNotificationMaster = new TechoNotificationMaster();
            techoNotificationMaster.setNotificationCode(null);
            techoNotificationMaster.setNotificationTypeId(notificationMasterService.retrieveByCode("READ_ONLY").getId());
            if (migratedFamilyDataBean.getIsOut() != null && migratedFamilyDataBean.getIsOut()) {
                if (migrationEntity.getLocationMigratedTo() == null) {
                    return migrationEntity.getId();
                }
                techoNotificationMaster.setLocationId(migrationEntity.getLocationMigratedTo());
            } else {
                if (migrationEntity.getLocationMigratedFrom() == null) {
                    return migrationEntity.getId();
                }
                techoNotificationMaster.setLocationId(migrationEntity.getLocationMigratedFrom());
            }
            techoNotificationMaster.setOtherDetails(sb.toString());
            techoNotificationMaster.setHeader(header.toString());
            techoNotificationMaster.setScheduleDate(new Date());
            techoNotificationMaster.setState(TechoNotificationMaster.State.PENDING);
            techoNotificationMaster.setMigrationId(migratedFamilyDataBean.getMigrationId());
            techoNotificationMaster.setFamilyId(migrationEntity.getFamilyId());
            techoNotificationMasterDao.create(techoNotificationMaster);
            return migrationEntity.getId();
        }
        return null;
    }

}
