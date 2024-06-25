/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.mobile.service.impl;

import com.argusoft.imtecho.caughtexception.model.CaughtExceptionEntity;
import com.argusoft.imtecho.caughtexception.service.CaughtExceptionService;
import com.argusoft.imtecho.cfhc.dto.FamilyAvailabilityDataBean;
import com.argusoft.imtecho.cfhc.service.*;
import com.argusoft.imtecho.chip.service.*;
import com.argusoft.imtecho.common.dao.UserDao;
import com.argusoft.imtecho.common.dao.UserTokenDao;
import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.common.util.ConstantUtil;
import com.argusoft.imtecho.common.util.EmailUtil;
import com.argusoft.imtecho.common.util.SystemConstantUtil;
import com.argusoft.imtecho.course.service.QuestionSetAnswerService;
import com.argusoft.imtecho.exception.ImtechoMobileException;
import com.argusoft.imtecho.fhs.service.FamilyHealthSurveyService;
import com.argusoft.imtecho.migration.dto.*;
import com.argusoft.imtecho.migration.service.FamilyMigrationService;
import com.argusoft.imtecho.migration.service.MigrationService;
import com.argusoft.imtecho.mobile.constants.MobileConstantUtil;
import com.argusoft.imtecho.mobile.dao.BcgVaccinationSurveyDao;
import com.argusoft.imtecho.mobile.dto.AadharUpdationBean;
import com.argusoft.imtecho.mobile.dto.MobileNumberUpdationBean;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;
import com.argusoft.imtecho.mobile.dto.RecordStatusBean;
import com.argusoft.imtecho.mobile.model.SyncStatus;
import com.argusoft.imtecho.mobile.model.UserInputDuration;
import com.argusoft.imtecho.mobile.service.*;
import com.argusoft.imtecho.notification.model.TechoNotificationMaster;
import com.argusoft.imtecho.notification.service.TechoNotificationService;
import com.argusoft.imtecho.rch.dto.AshaEventRejectionDataBean;
import com.argusoft.imtecho.rch.dto.AshaReportedEventDataBean;
import com.argusoft.imtecho.rch.service.*;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import lombok.extern.java.Log;
import org.apache.commons.lang.exception.ExceptionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.util.*;
import java.util.logging.Level;

import static java.util.logging.Logger.getLogger;

/**
 * @author prateek
 */
@Service
public class FormSubmissionServiceImpl extends GenericSessionUtilService implements FormSubmissionService {

    @Autowired
    private MobileUtilService mobileUtilService;
    @Autowired
    private FamilyHealthSurveyService familyHealthSurveyService;
    @Autowired
    private CFHCService cfhcService;
    @Autowired
    private CamCFHCService camCFHCService;
    @Autowired
    private TechoNotificationService techoNotificationService;
    @Autowired
    private UserTokenDao userTokenDao;
    @Autowired
    private UserDao userDao;
    @Autowired
    private EmailUtil emailUtil;
    @Autowired
    private LmpFollowUpService lmpFollowUpService;
    @Autowired
    private AncService ancService;
    @Autowired
    private WpdService wpdService;
    @Autowired
    private PncService pncService;
    @Autowired
    private ChildService childService;
    @Autowired
    private RimService rimService;
    @Autowired
    private VaccineAdverseEffectService vaccineAdverseEffectService;
    @Autowired
    private MigrationService migrationService;
    @Autowired
    private MobileFhsService mobileFhsService;
    @Autowired
    private ImmunisationService immunisationService;
    @Autowired
    private AshaPncService ashaPncService;
    @Autowired
    private AshaChildService ashaChildService;
    @Autowired
    private AshaLmpFollowUpService ashaLmpFollowUpService;
    @Autowired
    private RchOtherFormsService rchOtherFormsService;
    @Autowired
    private AshaAncService ashaAncService;
    @Autowired
    private AshaAncMorbidityService ashaAncMorbidityService;
    @Autowired
    private AshaCsMorbidityService ashaCsMorbidityService;
    @Autowired
    private AshaPncMorbidityService ashaPncMorbidityService;
    @Autowired
    private FhwPregnancyConfirmationService pregnancyConfirmationService;
    @Autowired
    private FhwDeathConfirmationService deathConfirmationService;
    @Autowired
    private AshaReportedEventService ashaReportedEventService;
    @Autowired
    private FamilyMigrationService familyMigrationService;
    @Autowired
    private QuestionSetAnswerService questionSetAnswerService;
    @Autowired
    private FamilyFolderService familyFolderService;
    @Autowired
    private HouseHoldLineListService houseHoldLineListService;
    @Autowired
    private MobileHouseHoldLineListService mobileHouseHoldLineListService;
    @Autowired
    private CaughtExceptionService caughtExceptionService;
    @Autowired
    private FamilyAvailabilityService familyAvailabilityService;
    @Autowired
    private AdolescentHealthScreeningService adolescentHealthScreeningService;
    @Autowired
    private HivPositiveService hivPositiveService;
    @Autowired
    private StockManagementService stockManagementService;
    @Autowired
    private ChipMalariaScreeningService chipMalariaScreeningService;
    @Autowired
    private ChipTBScreeningService chipTBScreeningService;
    @Autowired
    private ChipCovidScreeningService chipCovidScreeningService;
    @Autowired
    private BcgVaccineService bcgVaccineService;
    @Autowired
    private GbvService gbvService;
    @Autowired
    BcgVaccinationSurveyDao bcgVaccinationSurveyDao;

    @Override
    public RecordStatusBean[] recordsEntryFromMobileToDBServer(String token, String[] records) {
        if (records == null) {
            return new RecordStatusBean[0];
        }

        UserMaster user = mobileFhsService.isUserTokenValid(token);
        if (ConstantUtil.DROP_TYPE == null) {
            Properties props = new Properties();
            try {
                props.load(getClass().getResourceAsStream("/build.properties"));
                updateDropTypeIfNull(props);
            } catch (IOException ex) {
                getLogger(FormSubmissionServiceImpl.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        if (user != null) {
            System.out.println("-----------------"+ Arrays.toString(records));
            return this.saveRecordEntryFromMobileToDB(records, user);
        }
        return new RecordStatusBean[0];
    }

    private static void updateDropTypeIfNull(Properties props) {
        ConstantUtil.DROP_TYPE = props.getProperty("deployType").trim();
    }

    public RecordStatusBean[] saveRecordEntryFromMobileToDB(String[] record, UserMaster user) {
        List<ParsedRecordBean> parsedRecordBeanList;
        List<ParsedRecordBean> pendingParsedRecordBeanList = new ArrayList<>();
        List<RecordStatusBean> recordStatusBeanList = new ArrayList<>();

        //  Parse String List to List of records which are not duplicate
        for (int i = 0; i < record.length; i++) {
            record[i] = this.filterAddress(record[i]);
            ParsedRecordBean parsedRecordBean = this.parseRecordStringToBean(record[i]);
            String sb = parsedRecordBean.getChecksum();

            if (!sb.substring(0, sb.length() - 13).equals(user.getUserName())) {
                continue;
            }

            SyncStatus syncStatus = mobileUtilService.retrieveSyncStatusById(parsedRecordBean.getChecksum());
            if (syncStatus != null && (syncStatus.getStatus().equalsIgnoreCase(MobileConstantUtil.SUCCESS_VALUE)
                    || syncStatus.getStatus().equalsIgnoreCase(MobileConstantUtil.ERROR_VALUE)
                    || syncStatus.getStatus().equalsIgnoreCase(MobileConstantUtil.HANDLED_ERROR_VALUE))) {
                RecordStatusBean recordStatusBean = new RecordStatusBean();
                recordStatusBean.setChecksum(parsedRecordBean.getChecksum());
                recordStatusBean.setStatus(syncStatus.getStatus());
                recordStatusBeanList.add(recordStatusBean);
            } else if (syncStatus != null && syncStatus.getStatus().equalsIgnoreCase(MobileConstantUtil.PENDING_VALUE)) {
//                RecordStatusBean recordStatusBean = new RecordStatusBean();
//                recordStatusBean.setChecksum(parsedRecordBean.getChecksum());
//                recordStatusBean.setStatus(syncStatus.getStatus());
//                recordStatusBeanList.add(recordStatusBean);
                syncStatus.setStatus(MobileConstantUtil.PROCESSING_VALUE);
                mobileUtilService.updateSyncStatus(syncStatus);
                pendingParsedRecordBeanList.add(parsedRecordBean); // remove this
            } else if (syncStatus != null && syncStatus.getStatus().equalsIgnoreCase(MobileConstantUtil.PROCESSING_VALUE)) {
                RecordStatusBean recordStatusBean = new RecordStatusBean();
                recordStatusBean.setChecksum(parsedRecordBean.getChecksum());
                recordStatusBean.setStatus(MobileConstantUtil.PENDING_VALUE);
                recordStatusBeanList.add(recordStatusBean);
            } else {

                /*
                 * Creating the the SyncStatus Entry Pending for New Record
                 */
                syncStatus = new SyncStatus();
                syncStatus.setDevice(MobileConstantUtil.ANDROID);
                syncStatus.setId(parsedRecordBean.getChecksum());
                syncStatus.setActionDate(new Date());
                syncStatus.setStatus(MobileConstantUtil.PROCESSING_VALUE);
                syncStatus.setRecordString(record[i]);
                syncStatus.setUserId(user.getId());
                mobileUtilService.createSyncStatus(syncStatus);

                pendingParsedRecordBeanList.add(parsedRecordBean);
            }
        }

        //  Put records on top which have absolute dependency Id
        pendingParsedRecordBeanList.sort(ParsedRecordBean.ParsedRecordBeanComparator.getComparator(ParsedRecordBean.ParsedRecordBeanComparator.SORT_RELATIVE_ID));

        boolean isPending;
        List<Integer> exceptionMemberIds = new ArrayList<>();
        do {
            parsedRecordBeanList = pendingParsedRecordBeanList;
            pendingParsedRecordBeanList = new ArrayList<>();
            isPending = Boolean.FALSE;
            for (ParsedRecordBean parsedRecordBean : parsedRecordBeanList) {
                Integer createdInstanceId = null;
                SyncStatus syncStatus;
                String errorMessage = null;
                String exception = null;
                Map<String, String> keyAndAnswerMap = this.generateKeyAndAnswerMapFromAnswerRecordString(parsedRecordBean.getAnswerRecord());
                syncStatus = mobileUtilService.retrieveSyncStatusById(parsedRecordBean.getChecksum());

                try {
                    if (parsedRecordBean.getRelativeId() != null && parsedRecordBean.getRelativeId().startsWith("l")) {
                        String syncId = parsedRecordBean.getRelativeId().substring(1);
                        SyncStatus status = mobileUtilService.retrieveSyncStatusById(syncId);
                        if (status != null && status.getStatus().equalsIgnoreCase(MobileConstantUtil.SUCCESS_VALUE)) {
                            createdInstanceId = this.findAnswerEntityAndSave(parsedRecordBean, user, keyAndAnswerMap, status.getRelativeId());
                        } else if (status != null && status.getStatus().equalsIgnoreCase(MobileConstantUtil.ERROR_VALUE)) {
                            errorMessage = "There is error in the related form. So this form cannot be submitted.";
                            createdInstanceId = -1000;
                        }
                    } else {
                        createdInstanceId = this.findAnswerEntityAndSave(parsedRecordBean, user, keyAndAnswerMap, null);
                    }
                    syncStatus = mobileUtilService.retrieveSyncStatusById(parsedRecordBean.getChecksum());
                } catch (ImtechoMobileException e) {
                    Integer memberId = null;
                    if (keyAndAnswerMap.get("-4") != null && !keyAndAnswerMap.get("-4").equalsIgnoreCase("null")) {
                        memberId = Integer.valueOf(keyAndAnswerMap.get("-4"));
                    } else {
                        if (keyAndAnswerMap.containsKey("-44") && keyAndAnswerMap.get("-44") != null
                                && !keyAndAnswerMap.get("-44").equalsIgnoreCase("null")) {
                            memberId = mobileHouseHoldLineListService.retrieveMemberByUuid(keyAndAnswerMap.get("-44")).getId();
                        }
                    }
                    if (memberId != null && memberId > 0) {
                        familyHealthSurveyService.updateMember(familyHealthSurveyService.retrieveMemberEntityByID(memberId), null, null);
                    }

                    if (parsedRecordBean.getNotificationId() != null && !parsedRecordBean.getNotificationId().isEmpty()
                            && Integer.parseInt(parsedRecordBean.getNotificationId()) != -1 && Integer.parseInt(parsedRecordBean.getNotificationId()) != 0) {
                        techoNotificationService.update(techoNotificationService.retrieveById(Integer.valueOf(parsedRecordBean.getNotificationId())));
                    }
                    createdInstanceId = -1000;
                    String errorString = "ERROR STRING - " + parsedRecordBean.getChecksum() + " - " + parsedRecordBean.getAnswerRecord();
                    getLogger(FormSubmissionServiceImpl.class.getName()).log(Level.SEVERE, errorString, e);
//                    emailUtil.sendExceptionEmail(e, parsedRecordBean)
                    errorMessage = e.getMessage();
                    Writer writer = new StringWriter();
                    PrintWriter printWriter = new PrintWriter(writer);
                    e.printStackTrace(printWriter);
                    exception = writer.toString();
                    getLogger(FormSubmissionServiceImpl.class.getName()).log(Level.SEVERE, null, e);
                } catch (Exception e) {
                    String errorString = "ERROR STRING - " + parsedRecordBean.getChecksum() + " - " + parsedRecordBean.getAnswerRecord();
                    getLogger(FormSubmissionServiceImpl.class.getName()).log(Level.SEVERE, errorString, e);
                    if (syncStatus.getMailSent() != null && !syncStatus.getMailSent()) {
                        saveException(e, parsedRecordBean, user);
                        syncStatus.setMailSent(Boolean.TRUE);
                    }
                    errorMessage = "System Exception";
                    Writer writer = new StringWriter();
                    PrintWriter printWriter = new PrintWriter(writer);
                    e.printStackTrace(printWriter);
                    exception = writer.toString();
                    getLogger(FormSubmissionServiceImpl.class.getName()).log(Level.SEVERE, null, e);
                }
                //  Prepare Record Status
                RecordStatusBean recordStatusBean = new RecordStatusBean();
                recordStatusBean.setChecksum(parsedRecordBean.getChecksum());

                if (createdInstanceId != null && createdInstanceId == -1000) {
                    recordStatusBean.setStatus(MobileConstantUtil.HANDLED_ERROR_VALUE);
                    recordStatusBean.setMessage(errorMessage);
                } else if (createdInstanceId != null && parsedRecordBean.getAbhaFailed() != null && parsedRecordBean.getAbhaFailed().equals(Boolean.TRUE)) {
                    recordStatusBean.setStatus(MobileConstantUtil.HANDLED_ERROR_VALUE);
                    if (parsedRecordBean.getGeneratedId() != null) {
                        recordStatusBean.setGeneratedId(parsedRecordBean.getGeneratedId());
                    }
                    if (parsedRecordBean.getMessage() != null) {
                        recordStatusBean.setMessage(parsedRecordBean.getMessage());
                    }
                } else if (createdInstanceId != null) {
                    recordStatusBean.setStatus(MobileConstantUtil.SUCCESS_VALUE);
                    if (parsedRecordBean.getAnswerEntity().equals(MobileConstantUtil.FAMILY_HEALTH_SURVEY)
                            || parsedRecordBean.getAnswerEntity().equals(MobileConstantUtil.FHS_MEMBER_UPDATE)
                            || parsedRecordBean.getAnswerEntity().equals(MobileConstantUtil.FHS_MEMBER_UPDATE_NEW)
                            || parsedRecordBean.getAnswerEntity().equals(MobileConstantUtil.CFHC)
                            || parsedRecordBean.getAnswerEntity().equals(MobileConstantUtil.CAM_FHS)
                            || parsedRecordBean.getAnswerEntity().equals(MobileConstantUtil.FAMILY_FOLDER)
                            || parsedRecordBean.getAnswerEntity().equals(MobileConstantUtil.HOUSE_HOLD_LINE_LIST)
                            || parsedRecordBean.getAnswerEntity().equals(MobileConstantUtil.HOUSE_HOLD_LINE_LIST_NEW)
                            || parsedRecordBean.getAnswerEntity().equals(MobileConstantUtil.FAMILY_FOLDER_MEMBER_UPDATE)
                            || parsedRecordBean.getAnswerEntity().equals(SystemConstantUtil.IDSP_NEW_FAMILY)
                            || parsedRecordBean.getAnswerEntity().equals(MobileConstantUtil.NCD_FHW_HEALTH_SCREENING)
                            || parsedRecordBean.getAnswerEntity().equals(SystemConstantUtil.SICKLE_CELL_ADD_FAMILY)
                            || parsedRecordBean.getAnswerEntity().equals(SystemConstantUtil.SICKLE_CELL_ADD_NEW_MEMBER)) {
                        if (parsedRecordBean.getGeneratedId() != null) {
                            recordStatusBean.setGeneratedId(parsedRecordBean.getGeneratedId());
                        }
                        if (parsedRecordBean.getMessage() != null) {
                            recordStatusBean.setMessage(parsedRecordBean.getMessage());
                        }
                    }
                } else {
                    recordStatusBean.setStatus(MobileConstantUtil.PENDING_VALUE);
                }
                recordStatusBeanList.add(recordStatusBean);

                //  If SyncStatus Exist then update otherwise create new entry
                if (syncStatus.getStatus() != null && createdInstanceId != null
                        && (syncStatus.getStatus().equalsIgnoreCase(MobileConstantUtil.PENDING_VALUE)
                        || syncStatus.getStatus().equalsIgnoreCase(MobileConstantUtil.VERIFICATION_PENDING))) {
                    UserInputDuration userInputDuration = new UserInputDuration();
                    userInputDuration.setDuration(Integer.parseInt(parsedRecordBean.getFormFillTime()));
                    userInputDuration.setByUser(user.getId());
                    userInputDuration.setFormType(parsedRecordBean.getAnswerEntity());
                    userInputDuration.setIsActive(Boolean.TRUE);
                    userInputDuration.setOnDate(new Date());
                    userInputDuration.setRelatedId(createdInstanceId);
                    userInputDuration.setMobileCreatedOnDate(new Date(Long.parseLong(parsedRecordBean.getMobileDate())));
                    mobileUtilService.createUserInputDuration(userInputDuration);
                }
                //  Update SyncStatus Entry
                syncStatus.setActionDate(new Date());

                if (parsedRecordBean.getMobileDate() != null) {
                    Date mobDate = new Date(Long.parseLong(parsedRecordBean.getMobileDate()));
                    syncStatus.setMobileDate(mobDate);
                }

                if (createdInstanceId != null && createdInstanceId == -1000) {
                    syncStatus.setStatus(MobileConstantUtil.ERROR_VALUE);
                    syncStatus.setErrorMessage(errorMessage);
                    syncStatus.setException(exception);
                } else if (createdInstanceId != null && Boolean.TRUE.equals(parsedRecordBean.getAbhaFailed())) {
                    syncStatus.setStatus(MobileConstantUtil.HANDLED_ERROR_VALUE);
                    syncStatus.setErrorMessage(recordStatusBean.getMessage());
                    syncStatus.setRelativeId(createdInstanceId);
                } else if (createdInstanceId != null) {
                    syncStatus.setStatus(MobileConstantUtil.SUCCESS_VALUE);
                    syncStatus.setRelativeId(createdInstanceId);
                } else {
                    syncStatus.setStatus(MobileConstantUtil.PENDING_VALUE);
                    syncStatus.setErrorMessage(errorMessage);
                    syncStatus.setException(exception);
                }

                mobileUtilService.updateSyncStatus(syncStatus);

            }
        } while (isPending);
        RecordStatusBean[] recordStatusBeans = new RecordStatusBean[recordStatusBeanList.size()];
        return recordStatusBeanList.toArray(recordStatusBeans);
    }

    private void saveException(Exception e, ParsedRecordBean parsedRecordBean, UserMaster user) {
        CaughtExceptionEntity exception = new CaughtExceptionEntity();
        if (user != null && user.getUserName() != null) {
            exception.setUsername(user.getUserName());
        }
        if (parsedRecordBean != null) {
            exception.setDataString(parsedRecordBean.toString());
        }
        if (e.getMessage() != null) {
            exception.setExceptionMsg(e.getMessage());
        } else {
            exception.setExceptionMsg("Exception Message not found for this record");
        }
        exception.setExceptionStackTrace(ExceptionUtils.getStackTrace(e));
        exception.setExceptionType("Mobile");
        caughtExceptionService.saveCaughtException(exception);
    }

    private String filterAddress(String addressIn) {
        if (addressIn != null && addressIn.length() > 0) {
            return addressIn.replace("@apos;", "'");
        } else {
            return addressIn;
        }
    }

    private ParsedRecordBean parseRecordStringToBean(String record) {
        String checksum;
        String mobileDate;
        String answerEntity;
        String customType;
        String relativeId;
        String formFillUpTime;
        String notificationId;
        String morbidityFrame;
        String answerRecord;

        int frameSize = record.split(MobileConstantUtil.CHECKSUM_AND_ENTITY_TYPE_SEPARATER).length;

        //  Parse Checksum
        int start = 0;
        int end = record.indexOf(MobileConstantUtil.CHECKSUM_AND_ENTITY_TYPE_SEPARATER);
        checksum = record.substring(start, end);

        if (frameSize >= 9) {
            //  Mobile Date
            start = end + 1;
            end = record.indexOf(MobileConstantUtil.CHECKSUM_AND_ENTITY_TYPE_SEPARATER, start);
            mobileDate = record.substring(start, end);
        } else {
            mobileDate = String.valueOf(new Date().getTime());
        }

        //  Parse Answer Entiry (Record Type e.g. EDP, ANC etc)
        start = end + 1;
        end = record.indexOf(MobileConstantUtil.CHECKSUM_AND_ENTITY_TYPE_SEPARATER, start);
        answerEntity = record.substring(start, end);

        //  Parse customType (Record is of e.g. Mother, Child or Other etc)
        start = end + 1;
        end = record.indexOf(MobileConstantUtil.CHECKSUM_AND_ENTITY_TYPE_SEPARATER, start);
        customType = record.substring(start, end);

        //  Parse Related Instance ID
        start = end + 1;
        end = record.indexOf(MobileConstantUtil.CHECKSUM_AND_ENTITY_TYPE_SEPARATER, start);
        relativeId = record.substring(start, end);

        //  Parse Form Creation Time
        start = end + 1;
        end = record.indexOf(MobileConstantUtil.CHECKSUM_AND_ENTITY_TYPE_SEPARATER, start);
        formFillUpTime = record.substring(start, end);

        //  Notification Id        
        start = end + 1;
        end = record.indexOf(MobileConstantUtil.CHECKSUM_AND_ENTITY_TYPE_SEPARATER, start);
        notificationId = record.substring(start, end);

        //  morbidityFrame
        start = end + 1;
        end = record.indexOf(MobileConstantUtil.CHECKSUM_AND_ENTITY_TYPE_SEPARATER, start);
        morbidityFrame = record.substring(start, end);

        //  Parse Actual Record data
        start = end + 1;
        end = record.length();
        answerRecord = record.substring(start, end);

        ParsedRecordBean parsedRecordBean = new ParsedRecordBean();
        parsedRecordBean.setChecksum(checksum);
        parsedRecordBean.setMobileDate(mobileDate);
        parsedRecordBean.setAnswerEntity(answerEntity);
        parsedRecordBean.setCustomType(customType);
        parsedRecordBean.setRelativeId(relativeId);
        parsedRecordBean.setFormFillTime(formFillUpTime);
        parsedRecordBean.setNotificationId(notificationId);
        parsedRecordBean.setMorbidityFrame(morbidityFrame);
        parsedRecordBean.setAnswerRecord(answerRecord);
        return parsedRecordBean;
    }

    private Integer findAnswerEntityAndSave(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap, Integer dependencyId) {
        Integer createdInstanceId = null;
        final String message = "message";

        Map<String, String> returnMap;
        switch (parsedRecordBean.getAnswerEntity()) {
            // FHS Forms
            case MobileConstantUtil.FAMILY_HEALTH_SURVEY:
                returnMap = familyHealthSurveyService.storeFamilyHealthSurveyForm(parsedRecordBean, user);
                createdInstanceId = Integer.valueOf(returnMap.get("createdInstanceId"));
                if (returnMap.get("familyId") != null) {
                    parsedRecordBean.setGeneratedId(returnMap.get("familyId"));
                }
                if (returnMap.get(message) != null) {
                    parsedRecordBean.setMessage(returnMap.get(message));
                }
                return createdInstanceId;

            case MobileConstantUtil.CFHC:
                returnMap = cfhcService.storeComprehensiveFamilyHealthCensusForm(parsedRecordBean, user);
                createdInstanceId = Integer.valueOf(returnMap.get("createdInstanceId"));
                if (returnMap.get("familyId") != null) {
                    parsedRecordBean.setGeneratedId(returnMap.get("familyId"));
                }
                if (returnMap.get(message) != null) {
                    parsedRecordBean.setMessage(returnMap.get(message));
                }
                return createdInstanceId;
            case MobileConstantUtil.CAM_FHS:
                returnMap = camCFHCService.storeComprehensiveFamilyHealthCensusForm(parsedRecordBean, user);
                createdInstanceId = Integer.valueOf(returnMap.get("createdInstanceId"));
                if (returnMap.get("familyId") != null) {
                    parsedRecordBean.setGeneratedId(returnMap.get("familyId"));
                }
                if (returnMap.get(message) != null) {
                    parsedRecordBean.setMessage(returnMap.get(message));
                }
                return createdInstanceId;
            case MobileConstantUtil.FAMILY_FOLDER:
                returnMap = familyFolderService.storeFamilyFolderForm(parsedRecordBean, user);
                createdInstanceId = Integer.valueOf(returnMap.get("createdInstanceId"));
                if (returnMap.get("familyId") != null) {
                    parsedRecordBean.setGeneratedId(returnMap.get("familyId"));
                }
                if (returnMap.get(message) != null) {
                    parsedRecordBean.setMessage(returnMap.get(message));
                }
                return createdInstanceId;
            case MobileConstantUtil.HOUSE_HOLD_LINE_LIST:
                returnMap = houseHoldLineListService.storeHouseHoldLineListForm(parsedRecordBean, user);
                createdInstanceId = Integer.valueOf(returnMap.get("createdInstanceId"));
                if (returnMap.get("familyId") != null) {
                    parsedRecordBean.setGeneratedId(returnMap.get("familyId"));
                }
                if (returnMap.get(message) != null) {
                    parsedRecordBean.setMessage(returnMap.get(message));
                }
                return createdInstanceId;
            case MobileConstantUtil.HOUSE_HOLD_LINE_LIST_NEW:
                returnMap = mobileHouseHoldLineListService.storeHouseHoldLineListForm(parsedRecordBean, user);
                createdInstanceId = Integer.valueOf(returnMap.get("createdInstanceId"));
                if (returnMap.get("familyId") != null) {
                    parsedRecordBean.setGeneratedId(returnMap.get("familyId"));
                }
                if (returnMap.get(message) != null) {
                    parsedRecordBean.setMessage(returnMap.get(message));
                }
                return createdInstanceId;
            case MobileConstantUtil.FAMILY_FOLDER_MEMBER_UPDATE:
                returnMap = familyFolderService.familyFolderMemberUpdateForm(parsedRecordBean, keyAndAnswerMap, user);
                createdInstanceId = Integer.valueOf(returnMap.get("createdInstanceId"));
                if (returnMap.get("memberId") != null) {
                    parsedRecordBean.setGeneratedId(returnMap.get("memberId"));
                }
                if (returnMap.get(message) != null) {
                    parsedRecordBean.setMessage(returnMap.get(message));
                }
                return createdInstanceId;

            case MobileConstantUtil.LOCKED_FAMILY:
                FamilyAvailabilityDataBean familyAvailabilityDataBean = new GsonBuilder()
                        .registerTypeAdapter(Date.class, MobileConstantUtil.jsonDateDeserializerStringFormat)
                        .create().fromJson(parsedRecordBean.getAnswerRecord(), FamilyAvailabilityDataBean.class);
                return familyAvailabilityService.storeFamilyAvailability(familyAvailabilityDataBean);

            case MobileConstantUtil.FHS_MEMBER_UPDATE:
                returnMap = familyHealthSurveyService.storeMemberUpdateFormZambia(parsedRecordBean, keyAndAnswerMap, user);

                createdInstanceId = Integer.valueOf(returnMap.get("createdInstanceId"));
                if (returnMap.get("memberId") != null) {
                    parsedRecordBean.setGeneratedId(returnMap.get("memberId"));
                }
                if (returnMap.get(message) != null) {
                    parsedRecordBean.setMessage(returnMap.get(message));
                }
                return createdInstanceId;
            case MobileConstantUtil.FHS_MEMBER_UPDATE_NEW:
                returnMap = mobileHouseHoldLineListService.storeMemberUpdateFormZambia(parsedRecordBean, user);
                createdInstanceId = Integer.valueOf(returnMap.get("createdInstanceId"));
                if (returnMap.get("memberId") != null) {
                    parsedRecordBean.setGeneratedId(returnMap.get("memberId"));
                }
                if (returnMap.get(message) != null) {
                    parsedRecordBean.setMessage(returnMap.get(message));
                }
                return createdInstanceId;
            case MobileConstantUtil.AADHAR_UPDATION:
                AadharUpdationBean aadharUpdationBean = new GsonBuilder()
                        .registerTypeAdapter(Date.class, MobileConstantUtil.jsonDateDeserializerStringFormat)
                        .create().fromJson(parsedRecordBean.getAnswerRecord(), AadharUpdationBean.class);
                return mobileFhsService.saveAadharUpdateDetails(aadharUpdationBean);
            case MobileConstantUtil.FHSR_PHONE_UPDATE:
                return rchOtherFormsService.storeFhsrPhoneVerificationForm(user, keyAndAnswerMap);

            case MobileConstantUtil.MOBILE_NUMBER_VERIFICATION:
                MobileNumberUpdationBean mobileNumberUpdationBean = new Gson().fromJson(parsedRecordBean.getAnswerRecord(), MobileNumberUpdationBean.class);
                return mobileFhsService.saveMobileNumberUpdateDetails(mobileNumberUpdationBean);
            case MobileConstantUtil.BCG_VACCINATION_SURVEY:
                return bcgVaccineService.storeBcgVaccinationSurveyForm(parsedRecordBean, keyAndAnswerMap, user);
            case MobileConstantUtil.BCG_ELIGIBLE:
                return bcgVaccineService.storeBcgEligibleForm(parsedRecordBean, keyAndAnswerMap, user);

            //FHW RCH Forms
            case MobileConstantUtil.LMP_FOLLOW_UP_VISIT:
                checkIfFormAlreadySubmitted(Integer.parseInt(parsedRecordBean.getNotificationId()));
                return lmpFollowUpService.storeLmpFollowUpForm(parsedRecordBean, keyAndAnswerMap);
            case MobileConstantUtil.OCR_LMPFU:
                return lmpFollowUpService.storeLmpFollowUpFormOCR(parsedRecordBean, keyAndAnswerMap);
            case MobileConstantUtil.ANC_VISIT:
                checkIfFormAlreadySubmitted(Integer.parseInt(parsedRecordBean.getNotificationId()));
                return ancService.storeAncVisitForm(parsedRecordBean, keyAndAnswerMap, user);
            case MobileConstantUtil.OCR_ANC:
                return ancService.storeAncVisitFormOCR(parsedRecordBean, keyAndAnswerMap, user);
            case MobileConstantUtil.WPD_VISIT:
                checkIfFormAlreadySubmitted(Integer.parseInt(parsedRecordBean.getNotificationId()));
                return wpdService.storeWpdVisitForm(parsedRecordBean, keyAndAnswerMap, user);
            case MobileConstantUtil.PNC_VISIT:
                checkIfFormAlreadySubmitted(Integer.parseInt(parsedRecordBean.getNotificationId()));
                return pncService.storePncVisitForm(parsedRecordBean, keyAndAnswerMap, user);
            case MobileConstantUtil.CHILD_SERVICES_VISIT:
                checkIfFormAlreadySubmitted(Integer.parseInt(parsedRecordBean.getNotificationId()));
                return childService.storeChildServiceForm(parsedRecordBean, keyAndAnswerMap, user);
            case MobileConstantUtil.REPRODUCTIVE_INFO_MODIFICATION_VISIT:
            case MobileConstantUtil.CAM_REPRODUCTIVE_INFO_MODIFICATION_VISIT:
                return rimService.storeRimVisitForm(parsedRecordBean, keyAndAnswerMap, user);
            case MobileConstantUtil.OCR_FAMILY_PLANNING:
                return rimService.storeRimVisitFormOCR(parsedRecordBean, keyAndAnswerMap, user);
            case MobileConstantUtil.FP_FOLLOW_UP:
                return rimService.storeFpFollowUpVisitForm(parsedRecordBean, keyAndAnswerMap, user);
            case MobileConstantUtil.VACCINE_ADVERSE_EFFECT_VISIT:
                return vaccineAdverseEffectService.storeVaccineAdverseEffectForm(parsedRecordBean, keyAndAnswerMap, user);
            case MobileConstantUtil.WPD_DISCHARGE_VISIT:
                checkIfFormAlreadySubmitted(Integer.parseInt(parsedRecordBean.getNotificationId()));
                return wpdService.storeWpdDischargeForm(parsedRecordBean, keyAndAnswerMap, user);
            case MobileConstantUtil.TT2_ALERT:
                checkIfFormAlreadySubmitted(Integer.parseInt(parsedRecordBean.getNotificationId()));
                return rchOtherFormsService.storeTT2AlertForm(parsedRecordBean, keyAndAnswerMap, user);
            case MobileConstantUtil.IRON_SUCROSE_ALERT:
                checkIfFormAlreadySubmitted(Integer.parseInt(parsedRecordBean.getNotificationId()));
                return rchOtherFormsService.storeIronSucroseForm(parsedRecordBean, keyAndAnswerMap, user);
            case SystemConstantUtil.FHW_PREG_CONF:
                checkIfFormAlreadySubmitted(Integer.parseInt(parsedRecordBean.getNotificationId()));
                return pregnancyConfirmationService.storePregnancyConfirmationForm(parsedRecordBean, keyAndAnswerMap, user);
            case SystemConstantUtil.FHW_DEATH_CONF:
                checkIfFormAlreadySubmitted(Integer.parseInt(parsedRecordBean.getNotificationId()));
                return deathConfirmationService.storeDeathConfirmationForm(parsedRecordBean, keyAndAnswerMap, user);
            case MobileConstantUtil.FHW_REPORTED_EVENT_REJECTION:
                checkIfFormAlreadySubmitted(Integer.parseInt(parsedRecordBean.getNotificationId()));
                AshaEventRejectionDataBean rejectionDataBean = new Gson().fromJson(parsedRecordBean.getAnswerRecord(), AshaEventRejectionDataBean.class);
                return ashaReportedEventService.storeAshaEventRejectionForm(parsedRecordBean, rejectionDataBean, user);

            //ASHA RCH Forms
            case MobileConstantUtil.ASHA_PNC_VISIT:
                return ashaPncService.storePncServiceVisitForm(parsedRecordBean, keyAndAnswerMap, user);
            case MobileConstantUtil.ASHA_CS_VISIT:
                return ashaChildService.storeChildServiceVisitForm(parsedRecordBean, keyAndAnswerMap, user);
            case MobileConstantUtil.ASHA_ANC_VISIT:
                return ashaAncService.storeAncServiceVisitForm(parsedRecordBean, keyAndAnswerMap, user);
            case MobileConstantUtil.ASHA_LMPFU_VISIT:
                return ashaLmpFollowUpService.storeAshaLmpFollowUpForm(parsedRecordBean, keyAndAnswerMap, user);
            case SystemConstantUtil.ASHA_ANC_MORBIDITY:
                return ashaAncMorbidityService.storeAshaAncMorbidity(parsedRecordBean, dependencyId, keyAndAnswerMap, user);
            case SystemConstantUtil.ASHA_CS_MORBIDITY:
                return ashaCsMorbidityService.storeAshaCsMorbidity(parsedRecordBean, dependencyId, keyAndAnswerMap, user);
            case SystemConstantUtil.ASHA_PNC_MORBIDITY:
                return ashaPncMorbidityService.storeAshaPncMorbidity(parsedRecordBean, dependencyId, keyAndAnswerMap, user);
            case MobileConstantUtil.ASHA_WPD_VISIT:
            case MobileConstantUtil.ASHA_REPORT_MEMBER_DELIVERY:
                return ashaReportedEventService.storeDeliveryReportedByAsha(parsedRecordBean, keyAndAnswerMap, user);
            case MobileConstantUtil.ASHA_REPORTED_EVENT:
                AshaReportedEventDataBean dataBean = new Gson().fromJson(parsedRecordBean.getAnswerRecord(), AshaReportedEventDataBean.class);
                return ashaReportedEventService.storeAshaReportedEvent(parsedRecordBean, dataBean, user);

            // Migration Forms
            case MobileConstantUtil.MIGRATION_IN:
                checkIfFormAlreadySubmitted(Integer.parseInt(parsedRecordBean.getNotificationId()));
                MigrationInDataBean migrationInDataBean = new Gson().fromJson(parsedRecordBean.getAnswerRecord(), MigrationInDataBean.class);
                return migrationService.createMigrationIn(migrationInDataBean, user);
            case MobileConstantUtil.MIGRATION_OUT:
                checkIfFormAlreadySubmitted(Integer.parseInt(parsedRecordBean.getNotificationId()));
                MigrationOutDataBean migrationOutDataBean = new Gson().fromJson(parsedRecordBean.getAnswerRecord(), MigrationOutDataBean.class);
                return migrationService.createMigrationOut(parsedRecordBean, migrationOutDataBean, user);
            case MobileConstantUtil.MIGRATION_IN_CONFIRMATION:
                checkIfFormAlreadySubmitted(Integer.parseInt(parsedRecordBean.getNotificationId()));
                MigrationInConfirmationDataBean inConfirmationDataBean = new Gson().fromJson(parsedRecordBean.getAnswerRecord(), MigrationInConfirmationDataBean.class);
                return migrationService.createMigrationInConfirmation(inConfirmationDataBean, user);
            case MobileConstantUtil.MIGRATION_OUT_CONFIRMATION:
                checkIfFormAlreadySubmitted(Integer.parseInt(parsedRecordBean.getNotificationId()));
                MigrationOutConfirmationDataBean outConfirmationDataBean = new Gson().fromJson(parsedRecordBean.getAnswerRecord(), MigrationOutConfirmationDataBean.class);
                return migrationService.createMigrationOutConfirmation(outConfirmationDataBean, user);
            case MobileConstantUtil.MIGRATION_REVERTED:
                MigratedMembersDataBean migratedMembersDataBean = new GsonBuilder()
                        .registerTypeAdapter(Date.class, MobileConstantUtil.jsonDateDeserializerStringFormat)
                        .create().fromJson(parsedRecordBean.getAnswerRecord(), MigratedMembersDataBean.class);
                return migrationService.revertMigration(migratedMembersDataBean, user);
            case MobileConstantUtil.FAMILY_MIGRATION_REVERTED:
                MigratedFamilyDataBean migratedFamilyDataBean = new GsonBuilder()
                        .registerTypeAdapter(Date.class, MobileConstantUtil.jsonDateDeserializerStringFormat)
                        .create().fromJson(parsedRecordBean.getAnswerRecord(), MigratedFamilyDataBean.class);
                return familyMigrationService.revertMigration(migratedFamilyDataBean, user);
            case MobileConstantUtil.FAMILY_MIGRATION_OUT_FORM:
                checkIfFormAlreadySubmitted(Integer.parseInt(parsedRecordBean.getNotificationId()));
                FamilyMigrationOutDataBean familyMigrationOutDataBean = new Gson().fromJson(parsedRecordBean.getAnswerRecord(), FamilyMigrationOutDataBean.class);
                return familyMigrationService.storeFamilyMigrationOut(parsedRecordBean, familyMigrationOutDataBean, user);
            case MobileConstantUtil.FAMILY_MIGRATION_IN_CONFIRMATION_FORM:
                checkIfFormAlreadySubmitted(Integer.parseInt(parsedRecordBean.getNotificationId()));
                FamilyMigrationInConfirmationDataBean familyMigrationInConfirmationDataBean = new Gson().fromJson(parsedRecordBean.getAnswerRecord(), FamilyMigrationInConfirmationDataBean.class);
                return familyMigrationService.storeFamilyMigrationInConfirmation(familyMigrationInConfirmationDataBean, user);
            case MobileConstantUtil.LMS_TEST:
                return questionSetAnswerService.storeQuestionSetAnswerForMobile(parsedRecordBean, user);
            case SystemConstantUtil.ADOLESCENT_HEALTH_SCREENING:
                return adolescentHealthScreeningService.storeQuestionSetAnswerForMobile(parsedRecordBean, user, keyAndAnswerMap);
            case SystemConstantUtil.HIV_POSITIVE:
                return hivPositiveService.storeHivPositiveForm(parsedRecordBean, keyAndAnswerMap, user);
            case SystemConstantUtil.OCR_HIV_POSITIVE:
                return hivPositiveService.storeHivPositiveFormOCR(parsedRecordBean, keyAndAnswerMap, user);
            case SystemConstantUtil.HIV_SCREENING:
                return hivPositiveService.storeHivScreeningForm(parsedRecordBean, keyAndAnswerMap, user);
            case SystemConstantUtil.OCR_CHILD_HIV_SCREENING:
            case SystemConstantUtil.OCR_ADULT_HIV_SCREENING:
                return hivPositiveService.storeHivScreeningFormOCR(parsedRecordBean, keyAndAnswerMap, user);
            case SystemConstantUtil.EMTCT:
                return hivPositiveService.storeAnswersForEMTCT(parsedRecordBean, keyAndAnswerMap, user);
            case SystemConstantUtil.OCR_EMTCT:
                return hivPositiveService.storeAnswersForEMTCTOCR(parsedRecordBean, keyAndAnswerMap, user);
            case SystemConstantUtil.STOCK_MANAGEMENT:
                return stockManagementService.storeSMForm(parsedRecordBean, user, keyAndAnswerMap);
            case SystemConstantUtil.HIV_SCREENING_FU:
                return hivPositiveService.storeHivScreeningFUForm(parsedRecordBean, keyAndAnswerMap, user);
            case SystemConstantUtil.KNOWN_POSITIVE:
                return hivPositiveService.storeAnswersForKnownPositive(parsedRecordBean, keyAndAnswerMap, user);
            case SystemConstantUtil.OCR_KNOWN_POSITIVE:
                return hivPositiveService.storeAnswersForKnownPositiveOCR(parsedRecordBean, keyAndAnswerMap, user);
            case SystemConstantUtil.ACTIVE_MALARIA:
                return chipMalariaScreeningService.storeActiveMalariaForm(parsedRecordBean, user, keyAndAnswerMap);
            case SystemConstantUtil.OCR_ACTIVE_MALARIA:
                return chipMalariaScreeningService.storeActiveMalariaFormFromOCR(parsedRecordBean, user, keyAndAnswerMap);
            case SystemConstantUtil.OCR_PASSIVE_MALARIA:
                return chipMalariaScreeningService.storePassiveMalariaFormOCR(parsedRecordBean, user, keyAndAnswerMap);
            case SystemConstantUtil.PASSIVE_MALARIA:
                return chipMalariaScreeningService.storePassiveMalariaForm(parsedRecordBean, user, keyAndAnswerMap);
            case SystemConstantUtil.ACTIVE_MALARIA_FOLLOW_UP:
                return chipMalariaScreeningService.storeActiveMalariaFormFollowUp(parsedRecordBean, user, keyAndAnswerMap);
            case SystemConstantUtil.MALARIA_NON_INDEX:
                return chipMalariaScreeningService.storeMalariaNonIndexForm(parsedRecordBean, user, keyAndAnswerMap);
            case SystemConstantUtil.MALARIA_INDEX:
                return chipMalariaScreeningService.storeMalariaIndexCaseForm(parsedRecordBean, user, keyAndAnswerMap);
            case SystemConstantUtil.INDEX_INVESTIGATION:
                return chipMalariaScreeningService.storeMalariaIndexInvestigationForm(parsedRecordBean, user, keyAndAnswerMap);
            case SystemConstantUtil.CHIP_TB:
                checkIfFormAlreadySubmitted(Integer.parseInt(parsedRecordBean.getNotificationId()));
                return chipTBScreeningService.storeTBForm(parsedRecordBean, user, keyAndAnswerMap);
            case SystemConstantUtil.OCR_TB_SCREENING:
                return chipTBScreeningService.storeTBFormOCR(parsedRecordBean, user, keyAndAnswerMap);
            case SystemConstantUtil.CHIP_TB_FOLLOW_UP:
                return chipTBScreeningService.storeTBFollowUpForm(parsedRecordBean, user, keyAndAnswerMap);
            case SystemConstantUtil.CHIP_COVID_SCREENING:
                return chipCovidScreeningService.storeCovidForm(parsedRecordBean, user, keyAndAnswerMap);
            case SystemConstantUtil.OCR_COVID_SCREENING:
                return chipCovidScreeningService.storeCovidFormOCR(parsedRecordBean, user, keyAndAnswerMap);
            case SystemConstantUtil.CHIP_GBV_SCREENING:
                return gbvService.storeGbvForm(parsedRecordBean, user, keyAndAnswerMap);
            default:
        }
        return createdInstanceId;
    }

    private void checkIfFormAlreadySubmitted(Integer notificationId) {
        if (notificationId != null && notificationId != -1 && notificationId != 0) {
            TechoNotificationMaster notificationMaster = techoNotificationService.retrieveById(notificationId);
            if (notificationMaster != null
                    && !notificationMaster.getState().equals(TechoNotificationMaster.State.PENDING)
                    && !notificationMaster.getState().equals(TechoNotificationMaster.State.RESCHEDULE)
                    && !notificationMaster.getState().equals(TechoNotificationMaster.State.MISSED)) {
                throw new ImtechoMobileException("This form has been discarded as it was already filled by the other user.", 100);
            }
        }
    }

    private Map<String, String> generateKeyAndAnswerMapFromAnswerRecordString(String recordString) {
        Map<String, String> keyAndAnswerMap = new HashMap<>();
        String[] keyAndAnswerSet = recordString.split(MobileConstantUtil.ANSWER_STRING_FIRST_SEPARATER);
        List<String> keyAndAnswerSetList = new ArrayList<>(Arrays.asList(keyAndAnswerSet));
        for (String aKeyAndAnswer : keyAndAnswerSetList) {
            String[] keyAnswerSplit = aKeyAndAnswer.split(MobileConstantUtil.ANSWER_STRING_SECOND_SEPARATER);
            if (keyAnswerSplit.length != 2) {
                continue;
            }
            keyAndAnswerMap.put(keyAnswerSplit[0], keyAnswerSplit[1]);
        }
        return keyAndAnswerMap;
    }


}
