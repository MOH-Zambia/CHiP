/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.migration.service.impl;

import com.argusoft.imtecho.common.dao.UserDao;
import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.common.util.ImtechoUtil;
import com.argusoft.imtecho.common.util.SystemConstantUtil;
import com.argusoft.imtecho.dashboard.fhs.constants.FamilyHealthSurveyServiceConstants;
import com.argusoft.imtecho.event.dto.Event;
import com.argusoft.imtecho.event.service.EventHandler;
import com.argusoft.imtecho.exception.ImtechoMobileException;
import com.argusoft.imtecho.fhs.dao.FamilyDao;
import com.argusoft.imtecho.fhs.dao.MemberDao;
import com.argusoft.imtecho.fhs.dto.MemberDto;
import com.argusoft.imtecho.fhs.model.FamilyEntity;
import com.argusoft.imtecho.fhs.model.MemberEntity;
import com.argusoft.imtecho.fhs.service.FamilyHealthSurveyService;
import com.argusoft.imtecho.location.dao.LocationMasterDao;
import com.argusoft.imtecho.location.model.LocationMaster;
import com.argusoft.imtecho.migration.dao.MigrationEntityDao;
import com.argusoft.imtecho.migration.dto.*;
import com.argusoft.imtecho.migration.model.MigrationEntity;
import com.argusoft.imtecho.migration.service.MigrationService;
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
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

/**
 * @author kunjan
 */
@Service
@Transactional
public class MigrationServiceImpl implements MigrationService {

    @Autowired
    private FamilyHealthSurveyService familyHealthSurveyService;

    @Autowired
    private NotificationMasterService notificationMasterService;

    @Autowired
    private MigrationEntityDao migrationEntityDao;

    @Autowired
    private TechoNotificationMasterDao techoNotificationMasterDao;

    @Autowired
    private NotificationTypeMasterDao notificationTypeMasterDao;

    @Autowired
    private MemberDao memberDao;

    @Autowired
    private FamilyDao familyDao;

    @Autowired
    private UserDao userDao;

    @Autowired
    private LocationMasterDao locationMasterDao;

    @Autowired
    private EventHandler eventHandler;

    @Autowired
    private AshaReportedEventService ashaReportedEventService;

    @Autowired
    private AshaReportedEventDao ashaReportedEventDao;

    @Override
    public List<MigratedMembersDataBean> retrieveMigrationDetailsDataBean(Integer userId) {
        return migrationEntityDao.retrieveMigrationByLocation(userId);
    }

    @Override
    public Integer revertMigration(MigratedMembersDataBean migratedMembersDataBean, UserMaster user) {
        if (migratedMembersDataBean != null) {
            MigrationEntity migrationEntity = migrationEntityDao.retrieveById(migratedMembersDataBean.getMigrationId());

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

            migrationEntityDao.update(migrationEntity);
            migrationEntityDao.flush();
            eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.MIGRATION_REVERTED, migrationEntity.getId()));

            StringBuilder sb = new StringBuilder();
            sb.append("The migration of this member has been Reverted.");
            sb.append("\n").append("\n")
                    .append("Name : ")
                    .append(migratedMembersDataBean.getName())
                    .append("\n")
                    .append("Member ID : ")
                    .append(migratedMembersDataBean.getHealthId());

            if (migratedMembersDataBean.getFamilyMigratedFrom() != null) {
                sb.append("\n")
                        .append("Family Migrated from : ")
                        .append(migratedMembersDataBean.getFamilyMigratedFrom());
            }
            if (migratedMembersDataBean.getFamilyMigratedTo() != null) {
                sb.append("\n")
                        .append("Family Migrated to : ")
                        .append(migratedMembersDataBean.getFamilyMigratedTo());
            }
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
            header.append(migratedMembersDataBean.getHealthId())
                    .append(" - ")
                    .append(migratedMembersDataBean.getName())
                    .append("\n")
                    .append("Reverted Migration");

            TechoNotificationMaster techoNotificationMaster = new TechoNotificationMaster();
            techoNotificationMaster.setNotificationCode(null);
            techoNotificationMaster.setNotificationTypeId(notificationMasterService.retrieveByCode("READ_ONLY").getId());
            if (migratedMembersDataBean.getIsOut() != null && migratedMembersDataBean.getIsOut()) {
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
            techoNotificationMaster.setMigrationId(migratedMembersDataBean.getMigrationId());
            techoNotificationMaster.setMemberId(migrationEntity.getMemberId());
            techoNotificationMasterDao.create(techoNotificationMaster);
            return migrationEntity.getId();
        }
        return null;
    }

    @Override
    public Integer createMigrationIn(MigrationInDataBean migrationInDataBean, UserMaster user) {
        MigrationEntity migrationEntity = new MigrationEntity();
        migrationEntity.setMobileData(new Gson().toJson(migrationInDataBean));
        migrationEntity.setType(RchConstants.MIGRATION.MIGRATION_TYPE_IN);
        migrationEntity.setState(RchConstants.MIGRATION.MIGRATION_STATE_REPORTED);
        migrationEntity.setReportedBy(user.getId());
        migrationEntity.setReportedOn(new Date(migrationInDataBean.getReportedOn()));

        MemberEntity memberEntity = null;

        if (migrationInDataBean.getOutOfState() != null && migrationInDataBean.getOutOfState()) {
            migrationEntity.setOutOfState(Boolean.TRUE);
            migrationEntity.setIsTemporary(Boolean.TRUE);
            migrationEntity.setMigratedLocationNotKnown(Boolean.TRUE);

            if (migrationInDataBean.getStayingWithFamily() != null && migrationInDataBean.getStayingWithFamily()) {
                FamilyEntity familyTo = familyDao.retrieveById(migrationInDataBean.getFamilyId());

                migrationEntity.setFamilyMigratedTo(familyTo.getFamilyId());
                migrationEntity.setLocationMigratedTo(familyTo.getLocationId());
                migrationEntity.setAreaMigratedTo(familyTo.getAreaId());
                migrationEntity.setNoFamilyFlag(Boolean.FALSE);
            } else {
                FamilyEntity familyTo = familyHealthSurveyService.createTemporaryFamily(migrationInDataBean.getVillageId(),
                        migrationInDataBean.getAreaId());

                migrationEntity.setFamilyMigratedTo(familyTo.getFamilyId());
                migrationEntity.setLocationMigratedTo(migrationInDataBean.getVillageId());
                migrationEntity.setAreaMigratedTo(migrationInDataBean.getAreaId());
                migrationEntity.setNoFamilyFlag(Boolean.TRUE);
            }

            memberEntity = this.createTemporaryMemberFromMigrationInDataBean(migrationInDataBean, migrationEntity.getFamilyMigratedTo());
            migrationEntity.setMemberId(memberEntity.getId());
            migrationEntity.setState(RchConstants.MIGRATION.MIGRATION_STATE_CONFIRMED);
            migrationEntity.setConfirmedOn(new Date());
            migrationEntity.setConfirmedBy(user.getId());
        } else {
            migrationEntity.setOutOfState(Boolean.FALSE);
            migrationEntity.setNearestLocId(migrationInDataBean.getNearestLocId());
            migrationEntity.setVillageName(migrationInDataBean.getVillageName());

            if (migrationInDataBean.getFhwOrAshaName() != null && !migrationInDataBean.getFhwOrAshaName().isEmpty()) {
                migrationEntity.setFhwOrAshaName(migrationInDataBean.getFhwOrAshaName());
            }
            if (migrationInDataBean.getFhwOrAshaPhone() != null && !migrationInDataBean.getFhwOrAshaPhone().isEmpty()) {
                migrationEntity.setFhwOrAshaPhone(migrationInDataBean.getFhwOrAshaPhone());
            }

            //Search Member By Health ID
            if (memberEntity == null && migrationInDataBean.getHealthId() != null && !migrationInDataBean.getHealthId().isEmpty()) {
                List<MemberEntity> memberEntitysByHealthId
                        = memberDao.retrieveMemberForMigration(false, null, true, migrationInDataBean.getHealthId());
                if (memberEntitysByHealthId != null && memberEntitysByHealthId.size() == 1) {
                    memberEntity = memberEntitysByHealthId.get(0);
                }
            }

            if (memberEntity != null) {
                migrationEntity.setMemberId(memberEntity.getId());

                List<MemberEntity> childrens = memberDao.retrieveChildUnder5ByMotherId(memberEntity.getId());
                if (childrens != null && !childrens.isEmpty()) {
                    migrationEntity.setHasChildren(Boolean.TRUE);
                }

                FamilyEntity familyFrom = familyDao.retrieveFamilyByFamilyId(memberEntity.getFamilyId());

                migrationEntity.setFamilyMigratedFrom(familyFrom.getFamilyId());
                migrationEntity.setLocationMigratedFrom(familyFrom.getLocationId());
                migrationEntity.setAreaMigratedFrom(familyFrom.getAreaId());

                migrationEntity.setIsTemporary(Boolean.FALSE);
                migrationEntity.setMigratedLocationNotKnown(Boolean.FALSE);
            } else {
                migrationEntity.setIsTemporary(Boolean.TRUE);
                migrationEntity.setMigratedLocationNotKnown(Boolean.TRUE);
            }

            if (migrationInDataBean.getStayingWithFamily() != null && migrationInDataBean.getStayingWithFamily()) {
                FamilyEntity familyTo = familyDao.retrieveById(migrationInDataBean.getFamilyId());

                migrationEntity.setFamilyMigratedTo(familyTo.getFamilyId());
                migrationEntity.setLocationMigratedTo(familyTo.getLocationId());
                migrationEntity.setAreaMigratedTo(familyTo.getAreaId());
                migrationEntity.setNoFamilyFlag(Boolean.FALSE);
            } else {
                migrationEntity.setLocationMigratedTo(migrationInDataBean.getVillageId());
                migrationEntity.setAreaMigratedTo(migrationInDataBean.getAreaId());
                migrationEntity.setNoFamilyFlag(Boolean.TRUE);
            }
        }

        migrationEntityDao.create(migrationEntity);
        migrationEntityDao.flush();
//        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.MIGRATION_IN, migrationEntity.getId()));

        if (memberEntity != null && migrationEntity.getOutOfState()) {
            StringBuilder sb = new StringBuilder();
            sb.append("Your request for Migration In has been approved.");
            sb.append("\n").append("\n")
                    .append("Name : ")
                    .append(memberEntity.getFirstName())
                    .append(" ")
                    .append(memberEntity.getMiddleName())
                    .append(" ")
                    .append(memberEntity.getLastName())
                    .append("\n")
                    .append("Member ID : ")
                    .append(memberEntity.getUniqueHealthId())
                    .append("\n")
                    .append("Family Migrated to : ")
                    .append(memberEntity.getFamilyId())
                    .append("\n")
                    .append("Location Migrated to : ")
                    .append(locationMasterDao.retrieveById(migrationEntity.getLocationMigratedTo()).getName());

            StringBuilder header = new StringBuilder();
            header.append(memberEntity.getUniqueHealthId())
                    .append(" - ")
                    .append(memberEntity.getFirstName())
                    .append(" ")
                    .append(memberEntity.getMiddleName())
                    .append(" ")
                    .append(memberEntity.getLastName())
                    .append("\n")
                    .append("Approved Migration");

            TechoNotificationMaster approveNotification = new TechoNotificationMaster();
            approveNotification.setNotificationCode(null);
            approveNotification.setNotificationTypeId(notificationMasterService.retrieveByCode("READ_ONLY").getId());
            approveNotification.setLocationId(migrationEntity.getLocationMigratedTo());

            approveNotification.setOtherDetails(sb.toString());
            approveNotification.setHeader(header.toString());
            approveNotification.setScheduleDate(new Date());
            approveNotification.setState(TechoNotificationMaster.State.PENDING);
            approveNotification.setMigrationId(migrationEntity.getId());
            approveNotification.setMemberId(migrationEntity.getMemberId());
            techoNotificationMasterDao.create(approveNotification);
        }

        if (memberEntity != null && !migrationEntity.getOutOfState() && !migrationEntity.getIsTemporary()) {
            MigrationDetailsDataBean migrationDetailsDataBean = new MigrationDetailsDataBean();
            migrationDetailsDataBean.setMemberId(memberEntity.getId());
            migrationDetailsDataBean.setHealthId(memberEntity.getUniqueHealthId());
            migrationDetailsDataBean.setFirstName(memberEntity.getFirstName());
            migrationDetailsDataBean.setMiddleName(memberEntity.getMiddleName());
            migrationDetailsDataBean.setLastName(memberEntity.getLastName());
            migrationDetailsDataBean.setFamilyId(migrationEntity.getFamilyMigratedFrom());
            migrationDetailsDataBean.setLocationDetails(locationMasterDao.retrieveById(migrationEntity.getLocationMigratedTo()).getName());
            migrationDetailsDataBean.setFhwName(user.getFirstName() + " " + user.getMiddleName() + " " + user.getLastName());
            migrationDetailsDataBean.setFhwPhoneNumber(user.getContactNumber());
            migrationDetailsDataBean.setOtherInfo(migrationEntity.getOtherInfo());

            TechoNotificationMaster techoNotificationMaster = new TechoNotificationMaster();
            techoNotificationMaster.setNotificationCode(null);
            techoNotificationMaster.setNotificationTypeId(notificationMasterService.retrieveByCode("MO").getId());
            techoNotificationMaster.setLocationId(migrationEntity.getLocationMigratedFrom());

            techoNotificationMaster.setOtherDetails(new Gson().toJson(migrationDetailsDataBean));
            techoNotificationMaster.setScheduleDate(new Date());
            techoNotificationMaster.setState(TechoNotificationMaster.State.PENDING);
            techoNotificationMaster.setMigrationId(migrationEntity.getId());
            techoNotificationMaster.setMemberId(migrationEntity.getMemberId());
            techoNotificationMasterDao.create(techoNotificationMaster);
        }

        return migrationEntity.getId();
    }

    private MemberEntity createTemporaryMemberFromMigrationInDataBean(MigrationInDataBean migrationInDataBean, String familyId) {
        MemberEntity memberEntity = new MemberEntity();
        memberEntity.setFirstName(migrationInDataBean.getFirstname());
        memberEntity.setMiddleName(migrationInDataBean.getMiddleName());
        memberEntity.setLastName(migrationInDataBean.getLastName());
        memberEntity.setGender(migrationInDataBean.getGender());
        memberEntity.setDob(new Date(migrationInDataBean.getDob()));
        memberEntity.setMobileNumber(migrationInDataBean.getPhoneNumber());
        if (migrationInDataBean.getBankAccountNumber() != null && !migrationInDataBean.getBankAccountNumber().isEmpty()) {
            memberEntity.setAccountNumber(migrationInDataBean.getBankAccountNumber());
        }
        if (migrationInDataBean.getIfscCode() != null && !migrationInDataBean.getIfscCode().isEmpty()) {
            memberEntity.setIfsc(migrationInDataBean.getIfscCode());
        }
        memberEntity.setState(FamilyHealthSurveyServiceConstants.FHS_MEMBER_STATE_TEMPORARY);
        memberEntity.setUniqueHealthId(familyHealthSurveyService.generateMemberUniqueHealthId());
        memberEntity.setFamilyId(familyId);
        if (migrationInDataBean.getIsPregnant() != null) {
            memberEntity.setIsPregnantFlag(migrationInDataBean.getIsPregnant());
            if (migrationInDataBean.getIsPregnant()) {
                memberEntity.setMaritalStatus(memberDao.retrieveIdOfListValuesByFieldKeyAndValue("1002", "MARRIED"));
            }
        } else {
            memberEntity.setIsPregnantFlag(false);
        }
        if (migrationInDataBean.getLmp() != null) {
            Date lmp = new Date(migrationInDataBean.getLmp());
            Calendar instance = Calendar.getInstance();
            instance.setTimeInMillis(migrationInDataBean.getReportedOn());
            instance.add(Calendar.DAY_OF_MONTH, -28);
            if (ImtechoUtil.clearTimeFromDate(lmp).after(ImtechoUtil.clearTimeFromDate(instance.getTime()))) {
                throw new ImtechoMobileException("LMP Date can't be within last 28 days of service date(Reported on)", 100);
            }
            memberEntity.setLmpDate(lmp);
        }

        memberDao.create(memberEntity);
        return memberEntity;
    }

    @Override
    public Integer createMigrationOut(ParsedRecordBean parsedRecordBean, MigrationOutDataBean migrationOutDataBean, UserMaster user) {
        MemberEntity memberEntity = memberDao.retrieveById(migrationOutDataBean.getMemberId());

        if (FamilyHealthSurveyServiceConstants.FHS_MIGRATED_CRITERIA_MEMBER_STATES.contains(memberEntity.getState())) {
            throw new ImtechoMobileException("Member is already migrated out.", 100);
        }

        if (migrationEntityDao.checkIfMigrationOutAlreadyReported(memberEntity.getId())) {
            throw new ImtechoMobileException("A migration for this member is already reported.", 100);
        }

        FamilyEntity familyEntity = familyDao.retrieveById(migrationOutDataBean.getFromFamilyId());

        MigrationEntity migrationEntity = new MigrationEntity();
        migrationEntity.setMobileData(new Gson().toJson(migrationOutDataBean));
        migrationEntity.setType(RchConstants.MIGRATION.MIGRATION_TYPE_OUT);
        migrationEntity.setState(RchConstants.MIGRATION.MIGRATION_STATE_REPORTED);
        migrationEntity.setReportedBy(user.getId());
        migrationEntity.setReportedOn(new Date(migrationOutDataBean.getReportedOn()));
        migrationEntity.setMemberId(memberEntity.getId());
        migrationEntity.setFamilyMigratedFrom(familyEntity.getFamilyId());
        migrationEntity.setLocationMigratedFrom(familyEntity.getLocationId());
        migrationEntity.setAreaMigratedFrom(familyEntity.getAreaId());
        migrationEntity.setOtherInfo(migrationOutDataBean.getOtherInfo());
        migrationEntity.setIsTemporary(Boolean.FALSE);
        migrationEntity.setNoFamilyFlag(Boolean.FALSE);

        if (migrationOutDataBean.getChildrensUnder5() != null && !migrationOutDataBean.getChildrensUnder5().isEmpty()) {
            migrationEntity.setChildren(new HashSet<>(migrationOutDataBean.getChildrensUnder5()));
        }

        if (migrationOutDataBean.getOutOfState()) {
            migrationEntity.setOutOfState(Boolean.TRUE);
            migrationEntity.setMigratedLocationNotKnown(Boolean.TRUE);
            if (migrationOutDataBean.getMigratedToStateName() != null) {
                migrationEntity.setMigratedToStateName(migrationOutDataBean.getMigratedToStateName());
            }
        } else {
            migrationEntity.setOutOfState(Boolean.FALSE);
            if (migrationOutDataBean.getLocationknown()) {
                migrationEntity.setMigratedLocationNotKnown(Boolean.FALSE);
                migrationEntity.setLocationMigratedTo(migrationOutDataBean.getToLocationId());
            } else {
                migrationEntity.setMigratedLocationNotKnown(Boolean.TRUE);
            }
        }

        migrationEntityDao.create(migrationEntity);
        migrationEntityDao.flush();
        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.MIGRATION_OUT, migrationEntity.getId()));

        if (parsedRecordBean.getNotificationId() != null && !parsedRecordBean.getNotificationId().equals("-1")) {
            TechoNotificationMaster notificationMaster = techoNotificationMasterDao.retrieveById(Integer.parseInt(parsedRecordBean.getNotificationId()));
            if (notificationMaster != null) {
                NotificationTypeMaster notificationTypeMaster = notificationTypeMasterDao.retrieveById(notificationMaster.getNotificationTypeId());
                if (notificationTypeMaster.getCode() != null && notificationTypeMaster.getCode().equals(MobileConstantUtil.NOTIFICATION_FHW_MEMBER_MIGRATION)) {
                    ashaReportedEventService.createReadOnlyNotificationForAsha(true, MobileConstantUtil.NOTIFICATION_FHW_MEMBER_MIGRATION,
                            memberEntity, familyEntity, user);
                }

                if (notificationMaster.getRelatedId() != null && notificationMaster.getOtherDetails() != null
                        && notificationMaster.getOtherDetails().equals(MobileConstantUtil.ASHA_REPORT_MEMBER_DEATH)) {
                    AshaReportedEventMaster eventMaster = ashaReportedEventDao.retrieveById(notificationMaster.getRelatedId());
                    eventMaster.setAction(RchConstants.ASHA_REPORTED_EVENT_CONFIRMED);
                    eventMaster.setActionOn(new Date(Long.parseLong(parsedRecordBean.getMobileDate())));
                    eventMaster.setActionBy(user.getId());
                    ashaReportedEventDao.update(eventMaster);
                }
            }
        }

        if (!migrationEntity.getOutOfState()
                && !migrationEntity.getMigratedLocationNotKnown()
                && migrationEntity.getLocationMigratedTo() != null) {
            MigrationDetailsDataBean migrationDetailsDataBean = new MigrationDetailsDataBean();
            migrationDetailsDataBean.setMemberId(memberEntity.getId());
            migrationDetailsDataBean.setHealthId(memberEntity.getUniqueHealthId());
            migrationDetailsDataBean.setFamilyId(memberEntity.getFamilyId());
            migrationDetailsDataBean.setFirstName(memberEntity.getFirstName());
            migrationDetailsDataBean.setMiddleName(memberEntity.getMiddleName());
            migrationDetailsDataBean.setLastName(memberEntity.getLastName());
            migrationDetailsDataBean.setFhwName(user.getFirstName() + " " + user.getMiddleName() + " " + user.getLastName());
            migrationDetailsDataBean.setFhwPhoneNumber(user.getContactNumber());
            migrationDetailsDataBean.setLocationDetails(locationMasterDao.retrieveById(migrationEntity.getLocationMigratedFrom()).getName());
            migrationDetailsDataBean.setOtherInfo(migrationEntity.getOtherInfo());

            if (migrationEntity.getChildren() != null && !migrationEntity.getChildren().isEmpty()) {
                List<MemberEntity> children = memberDao.retriveByIds("id", new ArrayList<>(migrationEntity.getChildren()));
                int count = 1;
                StringBuilder sb = new StringBuilder();
                for (MemberEntity child : children) {
                    if (count != 1) {
                        sb.append("\n");
                    }
                    sb.append(count)
                            .append(". ")
                            .append(child.getFirstName())
                            .append(" ")
                            .append(child.getMiddleName())
                            .append(" ")
                            .append(child.getLastName());
                    count++;
                }
                migrationDetailsDataBean.setChildDetails(sb.toString());
            }

            TechoNotificationMaster techoNotificationMaster = new TechoNotificationMaster();
            techoNotificationMaster.setNotificationCode(null);
            techoNotificationMaster.setNotificationTypeId(notificationMasterService.retrieveByCode("MI").getId());
            techoNotificationMaster.setLocationId(migrationEntity.getLocationMigratedTo());

            techoNotificationMaster.setOtherDetails(new Gson().toJson(migrationDetailsDataBean));
            techoNotificationMaster.setScheduleDate(new Date());
            techoNotificationMaster.setState(TechoNotificationMaster.State.PENDING);
            techoNotificationMaster.setMigrationId(migrationEntity.getId());
            techoNotificationMaster.setMemberId(migrationEntity.getMemberId());
            techoNotificationMasterDao.create(techoNotificationMaster);
        }

        return migrationEntity.getId();
    }

    @Override
    public Integer createMigrationOutConfirmation(MigrationOutConfirmationDataBean migrationOutConfirmation, UserMaster user) {
        MigrationEntity migrationEntity = migrationEntityDao.retrieveById(migrationOutConfirmation.getMigrationId());

        if (migrationEntity.getState().equals(RchConstants.MIGRATION.MIGRATION_STATE_CONFIRMED)) {
            techoNotificationMasterDao.markNotificationAsCompleted(migrationOutConfirmation.getNotificationId(), user.getId());
            throw new ImtechoMobileException("This migration has already been confirmed.", 100);
        }

        if (migrationEntity.getState().equals(RchConstants.MIGRATION.MIGRATION_STATE_NOT_HAPPENED)) {
            techoNotificationMasterDao.markNotificationAsCompleted(migrationOutConfirmation.getNotificationId(), user.getId());
            throw new ImtechoMobileException("This migration has already been rejected.", 100);
        }

        if (migrationEntity.getState().equals(RchConstants.MIGRATION.MIGRATION_STATE_NO_RESPONSE)) {
            techoNotificationMasterDao.markNotificationAsCompleted(migrationOutConfirmation.getNotificationId(), user.getId());
            throw new ImtechoMobileException("We got no response from you within 7 days. So this migration has been confirmed.", 100);
        }

        if (migrationEntity.getState().equals(RchConstants.MIGRATION.MIGRATION_STATE_REVERTED)) {
            techoNotificationMasterDao.markNotificationAsCompleted(migrationOutConfirmation.getNotificationId(), user.getId());
            throw new ImtechoMobileException("This migration has already been reverted.", 100);
        }

        if (!migrationEntity.getState().equals(RchConstants.MIGRATION.MIGRATION_STATE_REPORTED)) {
            techoNotificationMasterDao.markNotificationAsCompleted(migrationOutConfirmation.getNotificationId(), user.getId());
            throw new ImtechoMobileException("This migration has already been marked completed.", 100);
        }

        if (!migrationOutConfirmation.getHasMigrationHappened()) {
            migrationEntity.setState(RchConstants.MIGRATION.MIGRATION_STATE_NOT_HAPPENED);
        } else {
            migrationEntity.setState(RchConstants.MIGRATION.MIGRATION_STATE_CONFIRMED);
            if (migrationEntity.getFamilyMigratedTo() == null) {
                FamilyEntity temporaryFamily = familyHealthSurveyService.createTemporaryFamily(migrationEntity.getLocationMigratedTo(),
                        migrationEntity.getAreaMigratedTo());
                migrationEntity.setFamilyMigratedTo(temporaryFamily.getFamilyId());
            }
        }
        migrationEntity.setConfirmedBy(user.getId());
        migrationEntity.setConfirmedOn(new Date());
        migrationEntity.setStatus("COMPLETED");

        techoNotificationMasterDao.markNotificationAsCompleted(migrationOutConfirmation.getNotificationId(), user.getId());

        migrationEntityDao.update(migrationEntity);
        migrationEntityDao.flush();
        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.MIGRATION_OUT_CONFIRMATION, migrationEntity.getId()));

        MemberEntity memberEntity = memberDao.retrieveById(migrationEntity.getMemberId());
        StringBuilder sb = new StringBuilder();
        if (migrationEntity.getState().equals(RchConstants.MIGRATION.MIGRATION_STATE_NOT_HAPPENED)) {
            sb.append("Your request for Migration In has been rejected.");
        } else {
            sb.append("Your request for Migration In has been approved.");
        }
        sb.append("\n").append("\n")
                .append("Name : ")
                .append(memberEntity.getFirstName())
                .append(" ")
                .append(memberEntity.getMiddleName())
                .append(" ")
                .append(memberEntity.getLastName())
                .append("\n")
                .append("Member ID : ")
                .append(memberEntity.getUniqueHealthId())
                .append("\n")
                .append("Family Migrated from : ")
                .append(migrationEntity.getFamilyMigratedFrom());

        if (migrationEntity.getFamilyMigratedTo() != null) {
            sb.append("\n")
                    .append("Family Migrated to : ")
                    .append(migrationEntity.getFamilyMigratedTo());
        }

        sb.append("\n")
                .append("Location migrated from : ")
                .append(locationMasterDao.retrieveById(migrationEntity.getLocationMigratedFrom()).getName())
                .append("\n")
                .append("FHW Name : ")
                .append(user.getFirstName())
                .append(" ")
                .append(user.getMiddleName())
                .append(" ")
                .append(user.getLastName())
                .append("\n")
                .append("FHW Contact : ")
                .append(user.getContactNumber());

        StringBuilder header = new StringBuilder();
        header.append(memberEntity.getUniqueHealthId())
                .append(" - ")
                .append(memberEntity.getFirstName())
                .append(" ")
                .append(memberEntity.getMiddleName())
                .append(" ")
                .append(memberEntity.getLastName());

        if (migrationEntity.getState().equals(RchConstants.MIGRATION.MIGRATION_STATE_NOT_HAPPENED)) {
            header.append("\n")
                    .append("Rejected Migration");
        } else {
            header.append("\n")
                    .append("Approved Migration");
        }

        TechoNotificationMaster rejectNotification = new TechoNotificationMaster();
        rejectNotification.setNotificationCode(null);
        rejectNotification.setNotificationTypeId(notificationMasterService.retrieveByCode("READ_ONLY").getId());
        rejectNotification.setLocationId(migrationEntity.getLocationMigratedTo());

        rejectNotification.setHeader(header.toString());
        rejectNotification.setOtherDetails(sb.toString());
        rejectNotification.setScheduleDate(new Date());
        rejectNotification.setState(TechoNotificationMaster.State.PENDING);
        rejectNotification.setMigrationId(migrationEntity.getId());
        rejectNotification.setMemberId(migrationEntity.getMemberId());
        techoNotificationMasterDao.create(rejectNotification);

        return migrationEntity.getId();
    }

    @Override
    public Integer createMigrationInConfirmation(MigrationInConfirmationDataBean migrationInConfirmation, UserMaster user) {
        MigrationEntity migrationEntity = migrationEntityDao.retrieveById(migrationInConfirmation.getMigrationId());

        if (migrationEntity.getState().equals(RchConstants.MIGRATION.MIGRATION_STATE_CONFIRMED)) {
            techoNotificationMasterDao.markNotificationAsCompleted(migrationInConfirmation.getNotificationId(), user.getId());
            throw new ImtechoMobileException("This migration has already been confirmed.", 100);
        }

        if (migrationEntity.getState().equals(RchConstants.MIGRATION.MIGRATION_STATE_NOT_HAPPENED)) {
            techoNotificationMasterDao.markNotificationAsCompleted(migrationInConfirmation.getNotificationId(), user.getId());
            throw new ImtechoMobileException("This migration has already been rejected.", 100);
        }

        if (migrationEntity.getState().equals(RchConstants.MIGRATION.MIGRATION_STATE_NO_RESPONSE)) {
            techoNotificationMasterDao.markNotificationAsCompleted(migrationInConfirmation.getNotificationId(), user.getId());
            throw new ImtechoMobileException("We got no response from you within 7 days. So this migration has been rejected.", 100);
        }

        if (migrationEntity.getState().equals(RchConstants.MIGRATION.MIGRATION_STATE_REVERTED)) {
            techoNotificationMasterDao.markNotificationAsCompleted(migrationInConfirmation.getNotificationId(), user.getId());
            throw new ImtechoMobileException("This migration has already been reverted.", 100);
        }

        if (!migrationEntity.getState().equals(RchConstants.MIGRATION.MIGRATION_STATE_REPORTED)) {
            techoNotificationMasterDao.markNotificationAsCompleted(migrationInConfirmation.getNotificationId(), user.getId());
            throw new ImtechoMobileException("This migration has already been marked completed.", 100);
        }

        if (migrationInConfirmation.getHasMigrationHappened() != null && migrationInConfirmation.getHasMigrationHappened()) {
            FamilyEntity familyEntity = familyDao.retrieveById(migrationInConfirmation.getFamilyMigratedTo());
            migrationEntity.setFamilyMigratedTo(familyEntity.getFamilyId());
            migrationEntity.setLocationMigratedTo(familyEntity.getLocationId());
            migrationEntity.setAreaMigratedTo(familyEntity.getAreaId());
            migrationEntity.setState(RchConstants.MIGRATION.MIGRATION_STATE_CONFIRMED);
        } else {
            migrationEntity.setState(RchConstants.MIGRATION.MIGRATION_STATE_NOT_HAPPENED);
        }

        migrationEntity.setConfirmedBy(user.getId());
        migrationEntity.setConfirmedOn(new Date());
        migrationEntity.setStatus("COMPLETED");

        TechoNotificationMaster techoNotificationMaster = techoNotificationMasterDao.retrieveById(migrationInConfirmation.getNotificationId());
        techoNotificationMaster.setState(TechoNotificationMaster.State.COMPLETED);
        techoNotificationMasterDao.update(techoNotificationMaster);

        migrationEntityDao.update(migrationEntity);
        migrationEntityDao.flush();
        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.MIGRATION_IN_CONFIRMATION, migrationEntity.getId()));

        MemberEntity memberEntity = memberDao.retrieveById(migrationEntity.getMemberId());
        StringBuilder sb = new StringBuilder();
        if (migrationEntity.getState().equals(RchConstants.MIGRATION.MIGRATION_STATE_NOT_HAPPENED)) {
            sb.append("Your request for Migration Out has been rejected.");
        } else {
            sb.append("Your request for Migration Out has been approved.");
        }
        sb.append("\n").append("\n")
                .append("Name : ")
                .append(memberEntity.getFirstName())
                .append(" ")
                .append(memberEntity.getMiddleName())
                .append(" ")
                .append(memberEntity.getLastName())
                .append("\n")
                .append("Member ID : ")
                .append(memberEntity.getUniqueHealthId())
                .append("\n")
                .append("Family Migrated from : ")
                .append(migrationEntity.getFamilyMigratedFrom());

        if (migrationEntity.getFamilyMigratedTo() != null) {
            sb.append("\n")
                    .append("Family Migrated to : ")
                    .append(migrationEntity.getFamilyMigratedTo());
        }

        if (migrationEntity.getLocationMigratedTo() != null) {
            sb.append("\n")
                    .append("Location migrated to : ")
                    .append(locationMasterDao.retrieveById(migrationEntity.getLocationMigratedTo()).getName());
        }

        sb.append("\n")
                .append("FHW Name : ")
                .append(user.getFirstName())
                .append(" ")
                .append(user.getMiddleName())
                .append(" ")
                .append(user.getLastName())
                .append("\n")
                .append("FHW Contact : ")
                .append(user.getContactNumber());

        StringBuilder header = new StringBuilder();
        header.append(memberEntity.getUniqueHealthId())
                .append(" - ")
                .append(memberEntity.getFirstName())
                .append(" ")
                .append(memberEntity.getMiddleName())
                .append(" ")
                .append(memberEntity.getLastName());

        if (migrationEntity.getState().equals(RchConstants.MIGRATION.MIGRATION_STATE_NOT_HAPPENED)) {
            header.append("\n")
                    .append("Rejected Migration");
        } else {
            header.append("\n")
                    .append("Approved Migration");
        }

        TechoNotificationMaster rejectNotification = new TechoNotificationMaster();
        rejectNotification.setNotificationCode(null);
        rejectNotification.setNotificationTypeId(notificationMasterService.retrieveByCode("READ_ONLY").getId());
        rejectNotification.setLocationId(migrationEntity.getLocationMigratedFrom());

        rejectNotification.setHeader(header.toString());
        rejectNotification.setOtherDetails(sb.toString());
        rejectNotification.setScheduleDate(new Date());
        rejectNotification.setState(TechoNotificationMaster.State.PENDING);
        rejectNotification.setMigrationId(migrationEntity.getId());
        rejectNotification.setMemberId(migrationEntity.getMemberId());
        techoNotificationMasterDao.create(rejectNotification);
        return migrationEntity.getId();
    }

//    @Override
//    public void cronForCreatingTemporaryMember() {
//        List<MigrationEntity> migrationEntitys = migrationEntityDao.retrieveMigrationForCreatingTemporaryMembers(true);
//
//        for (MigrationEntity migrationEntity : migrationEntitys) {
//            String mobileData = migrationEntity.getMobileData();
//            MigrationInDataBean migrationInDataBean = new Gson().fromJson(mobileData, MigrationInDataBean.class);
//            if (migrationEntity.getFamilyMigratedTo() == null) {
//                FamilyEntity temporaryFamily = familyHealthSurveyService.createTemporaryFamily(migrationEntity.getLocationMigratedTo(),
//                        migrationEntity.getAreaMigratedTo());
//                migrationEntity.setFamilyMigratedTo(temporaryFamily.getFamilyId());
//            }
//
//            MemberEntity memberEntity = this.createTemporaryMemberFromMigrationInDataBean(migrationInDataBean, migrationEntity.getFamilyMigratedTo());
//
//            migrationEntity.setMemberId(memberEntity.getId());
//            migrationEntity.setState(RchConstants.MIGRATION.MIGRATION_STATE_CONFIRMED);
//            migrationEntity.setConfirmedBy(null);
//            migrationEntity.setConfirmedOn(new Date());
//            migrationEntity.setStatus("COMPLETED");
//
//            StringBuilder sb = new StringBuilder();
//            sb.append("Your request for Migration In has been approved.");
//            sb.append("\n").append("\n")
//                    .append("Name : ")
//                    .append(memberEntity.getFirstName())
//                    .append(" ")
//                    .append(memberEntity.getMiddleName())
//                    .append(" ")
//                    .append(memberEntity.getLastName())
//                    .append("\n")
//                    .append("Member ID : ")
//                    .append(memberEntity.getUniqueHealthId())
//                    .append("\n")
//                    .append("Family Migrated to : ")
//                    .append(memberEntity.getFamilyId())
//                    .append("\n")
//                    .append("Location Migrated to : ")
//                    .append(locationMasterDao.retrieveById(migrationEntity.getLocationMigratedTo()).getName());
//
//            StringBuilder header = new StringBuilder();
//            header.append(memberEntity.getUniqueHealthId())
//                    .append(" - ")
//                    .append(memberEntity.getFirstName())
//                    .append(" ")
//                    .append(memberEntity.getMiddleName())
//                    .append(" ")
//                    .append(memberEntity.getLastName())
//                    .append("\n")
//                    .append("Approved Migration");
//
//            TechoNotificationMaster approveNotification = new TechoNotificationMaster();
//            approveNotification.setNotificationCode(null);
//            approveNotification.setNotificationTypeId(notificationMasterService.retrieveByCode("READ_ONLY").getId());
//            approveNotification.setLocationId(migrationEntity.getLocationMigratedTo());
//
//            approveNotification.setHeader(header.toString());
//            approveNotification.setOtherDetails(sb.toString());
//            approveNotification.setScheduleDate(new Date());
//            approveNotification.setState(TechoNotificationMaster.State.PENDING);
//            approveNotification.setMigrationId(migrationEntity.getId());
//            approveNotification.setMemberId(migrationEntity.getMemberId());
//            techoNotificationMasterDao.create(approveNotification);
//        }
//
//        migrationEntityDao.updateAll(migrationEntitys);
//    }

    @Override
    public void cronForMigrationOutWithNoResponse() {
        List<MigrationEntity> migrationEntitys = migrationEntityDao.retrieveMigrationOutWithNoResponse();
        for (MigrationEntity migrationEntity : migrationEntitys) {
            List<TechoNotificationMaster> techoNotificationMasters = techoNotificationMasterDao.retrieveNotificationForMigration(
                    migrationEntity.getMemberId(), migrationEntity.getId(),
                    notificationMasterService.retrieveByCode("MI").getId(),
                    TechoNotificationMaster.State.PENDING);
            for (TechoNotificationMaster techoNotificationMaster : techoNotificationMasters) {
                techoNotificationMaster.setState(TechoNotificationMaster.State.MARK_AS_NO_RESPONSE);
                techoNotificationMasterDao.update(techoNotificationMaster);
            }

            migrationEntity.setState(RchConstants.MIGRATION.MIGRATION_STATE_NO_RESPONSE);
            migrationEntity.setConfirmedBy(null);
            migrationEntity.setConfirmedOn(new Date());
            migrationEntity.setStatus("COMPLETED");
            migrationEntityDao.update(migrationEntity);
            migrationEntityDao.flush();
            eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.MIGRATION_IN_CONFIRMATION, migrationEntity.getId()));

            MemberEntity memberEntity = memberDao.retrieveById(migrationEntity.getMemberId());
            StringBuilder sb = new StringBuilder();
            sb.append("Your request for Migration Out has been reverted due to no response from the other FHW.");
            sb.append("\n").append("\n")
                    .append("Name : ")
                    .append(memberEntity.getFirstName())
                    .append(" ")
                    .append(memberEntity.getMiddleName())
                    .append(" ")
                    .append(memberEntity.getLastName())
                    .append("\n")
                    .append("Member ID : ")
                    .append(memberEntity.getUniqueHealthId());

            if (migrationEntity.getFamilyMigratedFrom() != null) {
                sb.append("\n")
                        .append("Family Migrated from : ")
                        .append(migrationEntity.getFamilyMigratedFrom());
            }

            if (migrationEntity.getFamilyMigratedTo() != null) {
                sb.append("\n")
                        .append("Family Migrated to : ")
                        .append(migrationEntity.getFamilyMigratedTo());
            }

            if (migrationEntity.getLocationMigratedFrom() != null) {
                LocationMaster locationMigratedFrom = locationMasterDao.retrieveById(migrationEntity.getLocationMigratedFrom());
                if (locationMigratedFrom != null) {
                    sb.append("\n")
                            .append("Location migrated from : ")
                            .append(locationMigratedFrom.getName());
                }
            }

            if (migrationEntity.getLocationMigratedTo() != null) {
                LocationMaster locationMigratedTo = locationMasterDao.retrieveById(migrationEntity.getLocationMigratedTo());
                if (locationMigratedTo != null) {

                    sb.append("\n")
                            .append("Location migrated to : ")
                            .append(locationMigratedTo.getName());
                }
            }

            StringBuilder header = new StringBuilder();
            header.append(memberEntity.getUniqueHealthId())
                    .append(" - ")
                    .append(memberEntity.getFirstName())
                    .append(" ")
                    .append(memberEntity.getMiddleName())
                    .append(" ")
                    .append(memberEntity.getLastName())
                    .append("\n")
                    .append("Reverted Migration");

            TechoNotificationMaster rejectNotification = new TechoNotificationMaster();
            rejectNotification.setNotificationCode(null);
            rejectNotification.setNotificationTypeId(notificationMasterService.retrieveByCode("READ_ONLY").getId());
            rejectNotification.setLocationId(migrationEntity.getLocationMigratedFrom());

            rejectNotification.setHeader(header.toString());
            rejectNotification.setOtherDetails(sb.toString());
            rejectNotification.setScheduleDate(new Date());
            rejectNotification.setState(TechoNotificationMaster.State.PENDING);
            rejectNotification.setMigrationId(migrationEntity.getId());
            rejectNotification.setMemberId(migrationEntity.getMemberId());
            techoNotificationMasterDao.create(rejectNotification);
            migrationEntityDao.commit();
            migrationEntityDao.begin();
        }
    }

//    @Override
//    public void cronForMigrationInWithNoResponse() {
//        List<MigrationEntity> migrationEntitys = migrationEntityDao.retrieveMigrationInWithNoResponse();
//
//        for (MigrationEntity migrationEntity : migrationEntitys) {
//            List<TechoNotificationMaster> techoNotificationMasters = techoNotificationMasterDao.retrieveNotificationForMigration(
//                    migrationEntity.getMemberId(), migrationEntity.getId(),
//                    notificationMasterService.retrieveByCode("MO").getId(),
//                    TechoNotificationMaster.State.PENDING);
//            for (TechoNotificationMaster techoNotificationMaster : techoNotificationMasters) {
//                techoNotificationMaster.setState(TechoNotificationMaster.State.MARK_AS_NO_RESPONSE);
//                techoNotificationMasterDao.update(techoNotificationMaster);
//            }
//
//            migrationEntity.setState(RchConstants.MIGRATION.MIGRATION_STATE_NO_RESPONSE);
//            if (migrationEntity.getFamilyMigratedTo() == null) {
//                FamilyEntity temporaryFamily = familyHealthSurveyService.createTemporaryFamily(migrationEntity.getLocationMigratedTo(),
//                        migrationEntity.getAreaMigratedTo());
//                migrationEntity.setFamilyMigratedTo(temporaryFamily.getFamilyId());
//            }
//            migrationEntity.setConfirmedBy(null);
//            migrationEntity.setConfirmedOn(new Date());
//            migrationEntity.setStatus("COMPLETED");
//            migrationEntityDao.update(migrationEntity);
//            migrationEntityDao.flush();
//            eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.MIGRATION_OUT_CONFIRMATION, migrationEntity.getId()));
//
//            MemberEntity memberEntity = memberDao.retrieveById(migrationEntity.getMemberId());
//            StringBuilder sb = new StringBuilder();
//            sb.append("Your request for Migration In has been approved.");
//            sb.append("\n").append("\n")
//                    .append("Name : ")
//                    .append(memberEntity.getFirstName())
//                    .append(" ")
//                    .append(memberEntity.getMiddleName())
//                    .append(" ")
//                    .append(memberEntity.getLastName())
//                    .append("\n")
//                    .append("Member ID : ")
//                    .append(memberEntity.getUniqueHealthId());
//
//            if (migrationEntity.getFamilyMigratedFrom() != null) {
//                sb.append("\n")
//                        .append("Family Migrated from : ")
//                        .append(migrationEntity.getFamilyMigratedFrom());
//            }
//
//            if (migrationEntity.getFamilyMigratedTo() != null) {
//                sb.append("\n")
//                        .append("Family Migrated to : ")
//                        .append(migrationEntity.getFamilyMigratedTo());
//            }
//
//            if (migrationEntity.getLocationMigratedFrom() != null) {
//                sb.append("\n")
//                        .append("Location migrated from : ")
//                        .append(locationMasterDao.retrieveById(migrationEntity.getLocationMigratedFrom()).getName());
//            }
//
//            if (migrationEntity.getLocationMigratedTo() != null) {
//                sb.append("\n")
//                        .append("Location migrated to : ")
//                        .append(locationMasterDao.retrieveById(migrationEntity.getLocationMigratedTo()).getName());
//            }
//
//            StringBuilder header = new StringBuilder();
//            header.append(memberEntity.getUniqueHealthId())
//                    .append(" - ")
//                    .append(memberEntity.getFirstName())
//                    .append(" ")
//                    .append(memberEntity.getMiddleName())
//                    .append(" ")
//                    .append(memberEntity.getLastName())
//                    .append("\n")
//                    .append("Approved Migration");
//
//            TechoNotificationMaster rejectNotification = new TechoNotificationMaster();
//            rejectNotification.setNotificationCode(null);
//            rejectNotification.setNotificationTypeId(notificationMasterService.retrieveByCode("READ_ONLY").getId());
//            rejectNotification.setLocationId(migrationEntity.getLocationMigratedTo());
//
//            rejectNotification.setHeader(header.toString());
//            rejectNotification.setOtherDetails(sb.toString());
//            rejectNotification.setScheduleDate(new Date());
//            rejectNotification.setState(TechoNotificationMaster.State.PENDING);
//            rejectNotification.setMigrationId(migrationEntity.getId());
//            rejectNotification.setMemberId(migrationEntity.getMemberId());
//            techoNotificationMasterDao.create(rejectNotification);
//            migrationEntityDao.commit();
//            migrationEntityDao.begin();
//        }
//    }

    @Override
    public List<MemberDto> retrieveSimilarMembers(Integer migrationId) {
//        MigrationEntity migrationEntity = migrationEntityDao.retrieveById(migrationId);
        return migrationEntityDao.retrieveSimilarMembersFound(migrationId);

    }

    //    @Override
//    public void fetchNUpdateMemberAnalytics() {
//        List<MigrationEntity> retrieveMigrationInMembers = migrationEntityDao.retrieveMigrationInMembers(true);
//        for (MigrationEntity migrationEntity : retrieveMigrationInMembers) {
//            List<Integer> retrieveSimilarMembers = migrationEntityDao.retrieveSimilarMemberIds(migrationEntity);
//            for (Integer memberId : retrieveSimilarMembers) {
//                MigrationInMemberAnalytics memberAnalytics = new MigrationInMemberAnalytics();
//                memberAnalytics.setMemberId(memberId);
//                memberAnalytics.setMigrationId(migrationEntity.getId());
//                memberAnalytics.setState("ACTIVE");
//                memberAnalyticsDao.save(memberAnalytics);
//
//            }
//            migrationEntity.setSimilarMemberVerified(Boolean.TRUE);
//            migrationEntityDao.update(migrationEntity);
//        }
//    }
    @Override
    public List<MigrationEntity> retrieveMigratedInMembers() {
        return migrationEntityDao.retrieveMigrationInMembers(false);
    }

    @Override
    public void confirmMember(MemberDto memberDto, Integer migrationId) {

        MigrationEntity retrieveById = migrationEntityDao.retrieveById(migrationId);
        UserMaster user = userDao.retrieveUserByRoleCodeNLocation(retrieveById.getLocationMigratedTo(), "FHW");
        retrieveById.setMemberId(memberDto.getId());
        retrieveById.setFamilyMigratedFrom(memberDto.getFamilyId());
        retrieveById.setLocationMigratedFrom(memberDto.getLocationId());
        if (memberDto.getAreaId() != null && !memberDto.getAreaId().isEmpty()) {
            retrieveById.setAreaMigratedTo(Integer.parseInt(memberDto.getAreaId()));
        }
//        retrieveById.setAreaMigratedFrom(memberEntity.getAreaId());
        retrieveById.setIsTemporary(Boolean.FALSE);
        retrieveById.setMigratedLocationNotKnown(Boolean.FALSE);
        migrationEntityDao.update(retrieveById);
        MigrationDetailsDataBean migrationDetailsDataBean = new MigrationDetailsDataBean();
        migrationDetailsDataBean.setMemberId(retrieveById.getMemberId());
        migrationDetailsDataBean.setHealthId(memberDto.getUniqueHealthId());
        migrationDetailsDataBean.setFirstName(memberDto.getFirstName());
        migrationDetailsDataBean.setMiddleName(memberDto.getMiddleName());
        migrationDetailsDataBean.setLastName(memberDto.getLastName());
        migrationDetailsDataBean.setFamilyId(retrieveById.getFamilyMigratedFrom());
        migrationDetailsDataBean.setLocationDetails(locationMasterDao.retrieveById(retrieveById.getLocationMigratedTo()).getName());
        migrationDetailsDataBean.setFhwName(user.getFirstName() + " " + user.getMiddleName() + " " + user.getLastName());
        migrationDetailsDataBean.setFhwPhoneNumber(user.getContactNumber());
        migrationDetailsDataBean.setOtherInfo(retrieveById.getOtherInfo());

        TechoNotificationMaster techoNotificationMaster = new TechoNotificationMaster();
        techoNotificationMaster.setNotificationCode(null);
        techoNotificationMaster.setNotificationTypeId(notificationMasterService.retrieveByCode("MO").getId());
        techoNotificationMaster.setLocationId(retrieveById.getLocationMigratedFrom());

        techoNotificationMaster.setOtherDetails(new Gson().toJson(migrationDetailsDataBean));
        techoNotificationMaster.setScheduleDate(new Date());
        techoNotificationMaster.setState(TechoNotificationMaster.State.PENDING);
        techoNotificationMaster.setMigrationId(retrieveById.getId());
        techoNotificationMaster.setMemberId(retrieveById.getMemberId());
        techoNotificationMasterDao.create(techoNotificationMaster);

    }

    @Override
    public void createTemporaryMember(Integer migrationId) {
        MigrationEntity migrationEntity = migrationEntityDao.retrieveById(migrationId);
        MigrationInDataBean migrationInDataBean = new Gson().fromJson(migrationEntity.getMobileData(), MigrationInDataBean.class);
        if (migrationEntity.getFamilyMigratedTo() == null) {
            FamilyEntity temporaryFamily = familyHealthSurveyService.createTemporaryFamily(migrationEntity.getLocationMigratedTo(),
                    migrationEntity.getAreaMigratedTo());
            migrationEntity.setFamilyMigratedTo(temporaryFamily.getFamilyId());
        }

        MemberEntity temporaryMember = createTemporaryMemberFromMigrationInDataBean(migrationInDataBean, migrationEntity.getFamilyMigratedTo());

        migrationEntity.setMemberId(temporaryMember.getId());
        migrationEntity.setState(RchConstants.MIGRATION.MIGRATION_STATE_CONFIRMED);
        migrationEntityDao.update(migrationEntity);

        TechoNotificationMaster approveNotification = new TechoNotificationMaster();
        approveNotification.setNotificationCode(null);
        approveNotification.setNotificationTypeId(notificationMasterService.retrieveByCode("READ_ONLY").getId());
        approveNotification.setLocationId(migrationEntity.getLocationMigratedTo());

        StringBuilder sb = new StringBuilder();
        sb.append("Your request for Migration In has been approved.");
        sb.append("\n").append("\n")
                .append("Name : ")
                .append(temporaryMember.getFirstName())
                .append(" ")
                .append(temporaryMember.getMiddleName())
                .append(" ")
                .append(temporaryMember.getLastName())
                .append("\n")
                .append("Member ID : ")
                .append(temporaryMember.getUniqueHealthId())
                .append("\n")
                .append("Family Migrated to : ")
                .append(temporaryMember.getFamilyId())
                .append("\n")
                .append("Location Migrated to : ")
                .append(locationMasterDao.retrieveById(migrationEntity.getLocationMigratedTo()).getName());

        StringBuilder header = new StringBuilder();
        header.append(temporaryMember.getUniqueHealthId())
                .append(" - ")
                .append(temporaryMember.getFirstName())
                .append(" ")
                .append(temporaryMember.getMiddleName())
                .append(" ")
                .append(temporaryMember.getLastName())
                .append("\n")
                .append("Approved Migration");

        approveNotification.setHeader(header.toString());
        approveNotification.setOtherDetails(sb.toString());
        approveNotification.setScheduleDate(new Date());
        approveNotification.setState(TechoNotificationMaster.State.PENDING);
        approveNotification.setMigrationId(migrationEntity.getId());
        approveNotification.setMemberId(migrationEntity.getMemberId());
        techoNotificationMasterDao.create(approveNotification);

    }

    @Override
    public void createTemporaryMemberForMigrationInWithoutPhoneNumber() {
        List<MigrationEntity> migrationEntitys = migrationEntityDao.retrieveMigrationInWithoutPhoneNumber();
        System.out.println("Total Migration In without phone number : " + migrationEntitys.size());

        for (MigrationEntity migrationEntity : migrationEntitys) {
            String mobileData = migrationEntity.getMobileData();
            MigrationInDataBean migrationInDataBean = new Gson().fromJson(mobileData, MigrationInDataBean.class);
            if (migrationEntity.getFamilyMigratedTo() == null) {
                FamilyEntity temporaryFamily = familyHealthSurveyService.createTemporaryFamily(migrationEntity.getLocationMigratedTo(),
                        migrationEntity.getAreaMigratedTo());
                migrationEntity.setFamilyMigratedTo(temporaryFamily.getFamilyId());
            }

            MemberEntity memberEntity = this.createTemporaryMemberFromMigrationInDataBean(migrationInDataBean, migrationEntity.getFamilyMigratedTo());

            migrationEntity.setMemberId(memberEntity.getId());
            migrationEntity.setState(RchConstants.MIGRATION.MIGRATION_STATE_CONFIRMED);
            migrationEntity.setConfirmedBy(null);
            migrationEntity.setConfirmedOn(new Date());
            migrationEntity.setStatus("COMPLETED");

            StringBuilder sb = new StringBuilder();
            sb.append("Your request for Migration In has been approved.");
            sb.append("\n").append("\n")
                    .append("Name : ")
                    .append(memberEntity.getFirstName())
                    .append(" ")
                    .append(memberEntity.getMiddleName())
                    .append(" ")
                    .append(memberEntity.getLastName())
                    .append("\n")
                    .append("Member ID : ")
                    .append(memberEntity.getUniqueHealthId())
                    .append("\n")
                    .append("Family Migrated to : ")
                    .append(memberEntity.getFamilyId())
                    .append("\n")
                    .append("Location Migrated to : ")
                    .append(locationMasterDao.retrieveById(migrationEntity.getLocationMigratedTo()).getName());

            StringBuilder header = new StringBuilder();
            header.append(memberEntity.getUniqueHealthId())
                    .append(" - ")
                    .append(memberEntity.getFirstName())
                    .append(" ")
                    .append(memberEntity.getMiddleName())
                    .append(" ")
                    .append(memberEntity.getLastName())
                    .append("\n")
                    .append("Approved Migration");

            TechoNotificationMaster approveNotification = new TechoNotificationMaster();
            approveNotification.setNotificationCode(null);
            approveNotification.setNotificationTypeId(notificationMasterService.retrieveByCode("READ_ONLY").getId());
            approveNotification.setLocationId(migrationEntity.getLocationMigratedTo());

            approveNotification.setHeader(header.toString());
            approveNotification.setOtherDetails(sb.toString());
            approveNotification.setScheduleDate(new Date());
            approveNotification.setState(TechoNotificationMaster.State.PENDING);
            approveNotification.setMigrationId(migrationEntity.getId());
            approveNotification.setMemberId(migrationEntity.getMemberId());
            techoNotificationMasterDao.create(approveNotification);
        }

        migrationEntityDao.updateAll(migrationEntitys);
    }
}
