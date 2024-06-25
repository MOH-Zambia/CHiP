package com.argusoft.sewa.android.app.core.impl;

import com.argusoft.sewa.android.app.constants.FhsConstants;
import com.argusoft.sewa.android.app.constants.FieldNameConstants;
import com.argusoft.sewa.android.app.constants.FormConstants;
import com.argusoft.sewa.android.app.constants.NotificationConstants;
import com.argusoft.sewa.android.app.constants.RchConstants;
import com.argusoft.sewa.android.app.core.NotificationService;
import com.argusoft.sewa.android.app.databean.MemberAdditionalInfoDataBean;
import com.argusoft.sewa.android.app.databean.NotificationMobDataBean;
import com.argusoft.sewa.android.app.db.DBConnection;
import com.argusoft.sewa.android.app.model.FamilyBean;
import com.argusoft.sewa.android.app.model.LocationBean;
import com.argusoft.sewa.android.app.model.MemberBean;
import com.argusoft.sewa.android.app.model.NotificationBean;
import com.argusoft.sewa.android.app.transformer.SewaTransformer;
import com.argusoft.sewa.android.app.util.Log;
import com.argusoft.sewa.android.app.util.UtilBean;
import com.google.gson.Gson;
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.stmt.QueryBuilder;
import com.j256.ormlite.stmt.Where;

import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.EBean;
import org.androidannotations.ormlite.annotations.OrmLiteDao;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@EBean(scope = EBean.Scope.Singleton)
public class NotificationServiceImpl implements NotificationService {

    @Bean
    SewaServiceImpl sewaService;
    @Bean
    SewaServiceRestClientImpl sewaServiceRestClient;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<NotificationBean, Integer> notificationBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<LocationBean, Integer> locationBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<MemberBean, Integer> memberBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<FamilyBean, Integer> familyBeanDao;

    private static final String TAG = "NotificationServiceImpl";
    private final SewaTransformer sewaTransformer = SewaTransformer.getInstance();
    private static List<String> pendingStates = new ArrayList<>();
    private static final String OBR_OF_DON_IS_NULL_DON_ASC = "dateOfNotification IS NULL, dateOfNotification ASC";

    static {
        pendingStates.add(NotificationConstants.NOTIFICATION_STATE_PENDING);
        pendingStates.add(NotificationConstants.NOTIFICATION_STATE_RESCHEDULE);
    }

    @Override
    public List<NotificationMobDataBean> retrieveNotificationsForUser(List<Integer> villageIds, List<Integer> areaIds,
                                                                      String notificationCode, CharSequence searchString,
                                                                      long limit, long offset,
                                                                      LinkedHashMap<String, String> qrData) throws SQLException {

        if (areaIds == null) {
            areaIds = new ArrayList<>();
        }

        if (areaIds.isEmpty() && villageIds != null && !villageIds.isEmpty()) {
            areaIds = new ArrayList<>();
            List<LocationBean> areas = locationBeanDao.queryBuilder().selectColumns(FieldNameConstants.ACTUAL_I_D)
                    .where().in(FieldNameConstants.PARENT, villageIds).query();
            for (LocationBean locationBean : areas) {
                areaIds.add(locationBean.getActualID());
            }
        }

        List<Integer> finalLocationIds = new LinkedList<>();
        if (villageIds != null && !villageIds.isEmpty()) {
            finalLocationIds.addAll(villageIds);
        }
        if (!areaIds.isEmpty()) {
            finalLocationIds.addAll(areaIds);
        }

        List<NotificationBean> finalNotificationBeans = new ArrayList<>();
        switch (notificationCode) {
            case NotificationConstants.FHW_NOTIFICATION_TT2:
            case NotificationConstants.FHW_NOTIFICATION_WORK_PLAN_FOR_DELIVERY:
            case NotificationConstants.FHW_NOTIFICATION_ANC:
            case FormConstants.ASHA_ANC:
                finalNotificationBeans.addAll(getPregnantWomenNotifications(finalLocationIds, notificationCode, searchString, limit, offset, qrData));
                break;
            case NotificationConstants.FHW_NOTIFICATION_LMP_FOLLOW_UP:
            case NotificationConstants.FHW_NOTIFICATION_DISCHARGE:
            case NotificationConstants.FHW_NOTIFICATION_PNC:
            case FormConstants.ASHA_PNC:
            case FormConstants.ASHA_LMPFU:
                finalNotificationBeans.addAll(getEligibleCoupleNotificationsZambia(finalLocationIds, notificationCode, searchString, limit, offset, qrData));
                break;
            case NotificationConstants.FHW_NOTIFICATION_CHILD_SERVICES:
                finalNotificationBeans.addAll(getChildrenNotifications(finalLocationIds, notificationCode, searchString, limit, offset, qrData));
                break;
            case FormConstants.GERIATRICS_MEDICATION_ALERT:
                finalNotificationBeans.addAll(getGeriartricsMemberNotifications(finalLocationIds, notificationCode, searchString, limit, offset, qrData));
                break;
            case NotificationConstants.NOTIFICATION_TB_FOLLOW_UP:
                finalNotificationBeans.addAll(getTBFollowUpNotifications(finalLocationIds, notificationCode, searchString, limit, offset, qrData));
                break;
            case NotificationConstants.NOTIFICATION_ACTIVE_MALARIA:
                finalNotificationBeans.addAll(getMalariaFollowUpNotifications(finalLocationIds, notificationCode, searchString, limit, offset, qrData));
                break;
            case NotificationConstants.NOTIFICATION_HIV_NEGATIVE_FOLLOWUP_VISIT:
                finalNotificationBeans.addAll(getHivNegativeFollowUpNotifications(finalLocationIds, notificationCode, searchString, limit, offset, qrData));
                break;
            default:
                finalNotificationBeans.addAll(getDefaultNotifications(finalLocationIds, notificationCode, limit, offset));
                break;
        }

        List<NotificationMobDataBean> notificationMobDataBeans = new ArrayList<>();
        return sewaTransformer.convertNotificationModelToNotificationDataBean(finalNotificationBeans, notificationMobDataBeans);
    }

    private List<NotificationBean> getMalariaFollowUpNotifications(List<Integer> finalLocationIds, String notificationCode, CharSequence searchString,
                                                                   long limit, long offset, LinkedHashMap<String, String> qrData) throws SQLException {
        QueryBuilder<FamilyBean, Integer> familyQB = familyBeanDao.queryBuilder();
        familyQB.where().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES);

        QueryBuilder<MemberBean, Integer> memberQB = memberBeanDao.queryBuilder()
                .join(FieldNameConstants.FAMILY_ID, FieldNameConstants.FAMILY_ID, familyQB);

        Where<MemberBean, Integer> where = memberQB.where();
        if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                qrData.containsKey(FieldNameConstants.FAMILY_ID))
            searchString = qrData.get(FieldNameConstants.FAMILY_ID);

        if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                Objects.equals(FieldNameConstants.IS_QR_FOR_ABHA, "true")) {
            where.and(
                    where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                    where.eq(FieldNameConstants.RDT_STATUS, RchConstants.TEST_POSITIVE),
                    where.or(
                            where.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + qrData.get(FieldNameConstants.UNIQUE_HEALTH_ID) + "%"),
                            where.like(FieldNameConstants.FAMILY_ID, "%" + qrData.get(FieldNameConstants.FAMILY_ID) + "%")
                    )
            );
        } else if (searchString != null) {
            where.and(
                    where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                    where.eq(FieldNameConstants.RDT_STATUS, RchConstants.TEST_POSITIVE),
                    where.or(
                            where.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + searchString + "%"),   //Search By UniqueHealthId
                            where.like(FieldNameConstants.FIRST_NAME, "%" + searchString + "%"),         //Search By FirstName
                            where.like(FieldNameConstants.MIDDLE_NAME, "%" + searchString + "%"),       //Search By MiddleName
                            where.like(FieldNameConstants.LAST_NAME, "%" + searchString + "%"),         //Search By LastName
                            where.like(FieldNameConstants.FAMILY_ID, "%" + searchString + "%"),          //Search By FamilyId
                            where.like(FieldNameConstants.MOBILE_NUMBER, "%" + searchString + "%"),       //Search By MobileNumber
                            where.like(FieldNameConstants.NRC_NUMBER, "%" + searchString + "%"),    //Search by nrc
                            where.like(FieldNameConstants.HEALTH_ID, "%" + searchString + "%"),      //Search By HealthId
                            where.like(FieldNameConstants.SEARCH_STRING, "%" + searchString + "%")       //Search By HealthId      //Search By HealthId
                    )
            );
        } else {
            where.and(
                    where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                    where.eq(FieldNameConstants.RDT_STATUS, RchConstants.TEST_POSITIVE)
            );
        }

        QueryBuilder<NotificationBean, Integer> notificationQB = notificationBeanDao.queryBuilder();
        Where<NotificationBean, Integer> notificationWhere = notificationQB.join(FieldNameConstants.MEMBER_ID, FieldNameConstants.ACTUAL_ID, memberQB)
                .limit(limit).offset(offset)
                .orderByRaw(OBR_OF_DON_IS_NULL_DON_ASC)
                .orderBy(FieldNameConstants.BENEFICIARY_NAME, true)
                .where();

        if (finalLocationIds.isEmpty()) {
            notificationWhere.and(
                    notificationWhere.eq(FieldNameConstants.NOTIFICATION_CODE, notificationCode),
                    notificationWhere.le(FieldNameConstants.SCHEDULED_DATE, UtilBean.endOfDay(new Date())),
                    notificationWhere.in(FieldNameConstants.STATE, pendingStates)
            );
        } else {
            notificationWhere.and(
                    notificationWhere.in(FieldNameConstants.LOCATION_ID, finalLocationIds),
                    notificationWhere.eq(FieldNameConstants.NOTIFICATION_CODE, notificationCode),
                    notificationWhere.le(FieldNameConstants.SCHEDULED_DATE, UtilBean.endOfDay(new Date())),
                    notificationWhere.in(FieldNameConstants.STATE, pendingStates)
            );
        }

        return notificationQB.query();
    }

    private List<NotificationBean> getHivNegativeFollowUpNotifications(List<Integer> finalLocationIds, String notificationCode, CharSequence searchString,
                                                                       long limit, long offset, LinkedHashMap<String, String> qrData) throws SQLException {
        QueryBuilder<FamilyBean, Integer> familyQB = familyBeanDao.queryBuilder();
        familyQB.where().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES);

        QueryBuilder<MemberBean, Integer> memberQB = memberBeanDao.queryBuilder()
                .join(FieldNameConstants.FAMILY_ID, FieldNameConstants.FAMILY_ID, familyQB);

        Where<MemberBean, Integer> where = memberQB.where();
        if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                qrData.containsKey(FieldNameConstants.FAMILY_ID))
            searchString = qrData.get(FieldNameConstants.FAMILY_ID);

        if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                Objects.equals(FieldNameConstants.IS_QR_FOR_ABHA, "true")) {
            where.and(
                    where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                    where.eq(FieldNameConstants.IS_HIV_POSITIVE, RchConstants.TEST_NEGATIVE),
                    where.or(
                            where.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + qrData.get(FieldNameConstants.UNIQUE_HEALTH_ID) + "%"),
                            where.like(FieldNameConstants.FAMILY_ID, "%" + qrData.get(FieldNameConstants.FAMILY_ID) + "%")
                    )
            );
        } else if (searchString != null) {
            where.and(
                    where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                    where.eq(FieldNameConstants.IS_HIV_POSITIVE, RchConstants.TEST_NEGATIVE),
                    where.or(
                            where.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + searchString + "%"),   //Search By UniqueHealthId
                            where.like(FieldNameConstants.FIRST_NAME, "%" + searchString + "%"),         //Search By FirstName
                            where.like(FieldNameConstants.MIDDLE_NAME, "%" + searchString + "%"),       //Search By MiddleName
                            where.like(FieldNameConstants.LAST_NAME, "%" + searchString + "%"),         //Search By LastName
                            where.like(FieldNameConstants.FAMILY_ID, "%" + searchString + "%"),          //Search By FamilyId
                            where.like(FieldNameConstants.MOBILE_NUMBER, "%" + searchString + "%"),       //Search By MobileNumber
                            where.like(FieldNameConstants.NRC_NUMBER, "%" + searchString + "%"),    //Search by nrc
                            where.like(FieldNameConstants.HEALTH_ID, "%" + searchString + "%"),      //Search By HealthId
                            where.like(FieldNameConstants.SEARCH_STRING, "%" + searchString + "%")       //Search By HealthId      //Search By HealthId
                    )
            );
        } else {
            where.and(
                    where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                    where.eq(FieldNameConstants.IS_HIV_POSITIVE, RchConstants.TEST_NEGATIVE)
            );
        }

        QueryBuilder<NotificationBean, Integer> notificationQB = notificationBeanDao.queryBuilder();
        Where<NotificationBean, Integer> notificationWhere = notificationQB.join(FieldNameConstants.MEMBER_ID, FieldNameConstants.ACTUAL_ID, memberQB)
                .limit(limit).offset(offset)
                .orderByRaw(OBR_OF_DON_IS_NULL_DON_ASC)
                .orderBy(FieldNameConstants.BENEFICIARY_NAME, true)
                .where();

        if (finalLocationIds.isEmpty()) {
            notificationWhere.and(
                    notificationWhere.eq(FieldNameConstants.NOTIFICATION_CODE, notificationCode),
                    notificationWhere.le(FieldNameConstants.SCHEDULED_DATE, UtilBean.endOfDay(new Date())),
                    notificationWhere.in(FieldNameConstants.STATE, pendingStates)
            );
        } else {
            notificationWhere.and(
                    notificationWhere.in(FieldNameConstants.LOCATION_ID, finalLocationIds),
                    notificationWhere.eq(FieldNameConstants.NOTIFICATION_CODE, notificationCode),
                    notificationWhere.le(FieldNameConstants.SCHEDULED_DATE, UtilBean.endOfDay(new Date())),
                    notificationWhere.in(FieldNameConstants.STATE, pendingStates)
            );
        }

        return notificationQB.query();
    }


    private List<NotificationBean> getTBFollowUpNotifications(List<Integer> finalLocationIds, String notificationCode, CharSequence searchString,
                                                              long limit, long offset, LinkedHashMap<String, String> qrData) throws SQLException {
        QueryBuilder<FamilyBean, Integer> familyQB = familyBeanDao.queryBuilder();
        familyQB.where().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES);

        QueryBuilder<MemberBean, Integer> memberQB = memberBeanDao.queryBuilder()
                .join(FieldNameConstants.FAMILY_ID, FieldNameConstants.FAMILY_ID, familyQB);

        Where<MemberBean, Integer> where = memberQB.where();
        if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                qrData.containsKey(FieldNameConstants.FAMILY_ID))
            searchString = qrData.get(FieldNameConstants.FAMILY_ID);

        if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                Objects.equals(FieldNameConstants.IS_QR_FOR_ABHA, "true")) {
            where.and(
                    where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                    where.eq(FieldNameConstants.IS_TB_SUSPECTED, Boolean.TRUE),
                    where.eq(FieldNameConstants.IS_TB_CURED, Boolean.FALSE),
                    where.or(
                            where.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + qrData.get(FieldNameConstants.UNIQUE_HEALTH_ID) + "%"),
                            where.like(FieldNameConstants.FAMILY_ID, "%" + qrData.get(FieldNameConstants.FAMILY_ID) + "%")
                    )
            );
        } else if (searchString != null) {
            where.and(
                    where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                    where.eq(FieldNameConstants.IS_TB_SUSPECTED, Boolean.TRUE),
                    where.eq(FieldNameConstants.IS_TB_CURED, Boolean.FALSE),
                    where.or(
                            where.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + searchString + "%"),   //Search By UniqueHealthId
                            where.like(FieldNameConstants.FIRST_NAME, "%" + searchString + "%"),         //Search By FirstName
                            where.like(FieldNameConstants.MIDDLE_NAME, "%" + searchString + "%"),       //Search By MiddleName
                            where.like(FieldNameConstants.LAST_NAME, "%" + searchString + "%"),         //Search By LastName
                            where.like(FieldNameConstants.FAMILY_ID, "%" + searchString + "%"),          //Search By FamilyId
                            where.like(FieldNameConstants.MOBILE_NUMBER, "%" + searchString + "%"),       //Search By MobileNumber
                            where.like(FieldNameConstants.NRC_NUMBER, "%" + searchString + "%"),    //Search by nrc
                            where.like(FieldNameConstants.HEALTH_ID, "%" + searchString + "%"),      //Search By HealthId
                            where.like(FieldNameConstants.SEARCH_STRING, "%" + searchString + "%")       //Search By HealthId       //Search By HealthId
                    )
            );
        } else {
            where.and(
                    where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                    where.eq(FieldNameConstants.IS_TB_SUSPECTED, Boolean.TRUE),
                    where.eq(FieldNameConstants.IS_TB_CURED, Boolean.FALSE)
            );
        }

        QueryBuilder<NotificationBean, Integer> notificationQB = notificationBeanDao.queryBuilder();
        Where<NotificationBean, Integer> notificationWhere = notificationQB.join(FieldNameConstants.MEMBER_ID, FieldNameConstants.ACTUAL_ID, memberQB)
                .limit(limit).offset(offset)
                .orderByRaw(OBR_OF_DON_IS_NULL_DON_ASC)
                .orderBy(FieldNameConstants.BENEFICIARY_NAME, true)
                .where();

        if (finalLocationIds.isEmpty()) {
            notificationWhere.and(
                    notificationWhere.eq(FieldNameConstants.NOTIFICATION_CODE, notificationCode),
                    notificationWhere.le(FieldNameConstants.SCHEDULED_DATE, UtilBean.endOfDay(new Date())),
                    notificationWhere.in(FieldNameConstants.STATE, pendingStates)
            );
        } else {
            notificationWhere.and(
                    notificationWhere.in(FieldNameConstants.LOCATION_ID, finalLocationIds),
                    notificationWhere.eq(FieldNameConstants.NOTIFICATION_CODE, notificationCode),
                    notificationWhere.le(FieldNameConstants.SCHEDULED_DATE, UtilBean.endOfDay(new Date())),
                    notificationWhere.in(FieldNameConstants.STATE, pendingStates)
            );
        }

        return notificationQB.query();
    }


    private List<NotificationBean> getEligibleCoupleNotificationsZambia(List<Integer> locationIds, String notificationCode, CharSequence searchString,
                                                                        long limit, long offset, LinkedHashMap<String, String> qrData) throws SQLException {

        QueryBuilder<FamilyBean, Integer> familyQB = familyBeanDao.queryBuilder();
        familyQB.where().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES);

        QueryBuilder<MemberBean, Integer> memberQB = memberBeanDao.queryBuilder()
                .join(FieldNameConstants.FAMILY_ID, FieldNameConstants.FAMILY_ID, familyQB);

        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.YEAR, -15);
        Date dateBefore18Years = calendar.getTime();
        calendar.add(Calendar.YEAR, -34);
        Date dateBefore45Years = calendar.getTime();

        Where<MemberBean, Integer> where = memberQB.where();
        if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                qrData.containsKey(FieldNameConstants.FAMILY_ID))
            searchString = qrData.get(FieldNameConstants.FAMILY_ID);

        if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                Objects.equals(FieldNameConstants.IS_QR_FOR_ABHA, "true")) {
            where.and(
                    where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                    where.eq(FieldNameConstants.GENDER, "F"),
                    where.and(
                            where.isNotNull(FieldNameConstants.DOB),
                            where.le(FieldNameConstants.DOB, dateBefore18Years),
                            where.ge(FieldNameConstants.DOB, dateBefore45Years)
                    ),
                    where.or(
                            where.isNull(FieldNameConstants.IS_PREGNANT_FLAG),
                            where.eq(FieldNameConstants.IS_PREGNANT_FLAG, Boolean.FALSE)
                    ),
                    where.or(
                            where.isNull(FieldNameConstants.MENOPAUSE_ARRIVED),
                            where.eq(FieldNameConstants.MENOPAUSE_ARRIVED, Boolean.FALSE)
                    ),
                    where.or(
                            where.isNull(FieldNameConstants.HYSTERECTOMY_DONE),
                            where.eq(FieldNameConstants.HYSTERECTOMY_DONE, Boolean.FALSE)
                    ),
                    where.or(
                            where.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + qrData.get(FieldNameConstants.UNIQUE_HEALTH_ID) + "%"),
                            where.like(FieldNameConstants.FAMILY_ID, "%" + qrData.get(FieldNameConstants.FAMILY_ID) + "%")
                    )
            );
        } else if (searchString != null) {
            where.and(
                    where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                    where.eq(FieldNameConstants.GENDER, "F"),
                    where.and(
                            where.isNotNull(FieldNameConstants.DOB),
                            where.le(FieldNameConstants.DOB, dateBefore18Years),
                            where.ge(FieldNameConstants.DOB, dateBefore45Years)
                    ),
                    where.or(
                            where.isNull(FieldNameConstants.IS_PREGNANT_FLAG),
                            where.eq(FieldNameConstants.IS_PREGNANT_FLAG, Boolean.FALSE)
                    ),
                    where.or(
                            where.isNull(FieldNameConstants.MENOPAUSE_ARRIVED),
                            where.eq(FieldNameConstants.MENOPAUSE_ARRIVED, Boolean.FALSE)
                    ),
                    where.or(
                            where.isNull(FieldNameConstants.HYSTERECTOMY_DONE),
                            where.eq(FieldNameConstants.HYSTERECTOMY_DONE, Boolean.FALSE)
                    ),
                    where.or(
                            where.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + searchString + "%"),   //Search By UniqueHealthId
                            where.like(FieldNameConstants.FIRST_NAME, "%" + searchString + "%"),         //Search By FirstName
                            where.like(FieldNameConstants.MIDDLE_NAME, "%" + searchString + "%"),       //Search By MiddleName
                            where.like(FieldNameConstants.LAST_NAME, "%" + searchString + "%"),         //Search By LastName
                            where.like(FieldNameConstants.FAMILY_ID, "%" + searchString + "%"),          //Search By FamilyId
                            where.like(FieldNameConstants.MOBILE_NUMBER, "%" + searchString + "%"),       //Search By MobileNumber
                            where.like(FieldNameConstants.NRC_NUMBER, "%" + searchString + "%"),      //Search By HealthId
                            where.like(FieldNameConstants.SEARCH_STRING, "%" + searchString + "%")       //Search By HealthId
                    )
            );
        } else {
            where.and(
                    where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                    where.eq(FieldNameConstants.GENDER, "F"),
                    where.and(
                            where.isNotNull(FieldNameConstants.DOB),
                            where.le(FieldNameConstants.DOB, dateBefore18Years),
                            where.ge(FieldNameConstants.DOB, dateBefore45Years)
                    ),
                    where.or(
                            where.isNull(FieldNameConstants.IS_PREGNANT_FLAG),
                            where.eq(FieldNameConstants.IS_PREGNANT_FLAG, Boolean.FALSE)
                    ),
                    where.or(
                            where.isNull(FieldNameConstants.MENOPAUSE_ARRIVED),
                            where.eq(FieldNameConstants.MENOPAUSE_ARRIVED, Boolean.FALSE)
                    ),
                    where.or(
                            where.isNull(FieldNameConstants.HYSTERECTOMY_DONE),
                            where.eq(FieldNameConstants.HYSTERECTOMY_DONE, Boolean.FALSE)
                    )
            );
        }

        QueryBuilder<NotificationBean, Integer> notificationQB = notificationBeanDao.queryBuilder();
        Where<NotificationBean, Integer> notificationWhere = notificationQB.join(FieldNameConstants.MEMBER_ID, FieldNameConstants.ACTUAL_ID, memberQB)
                .limit(limit).offset(offset)
                .orderByRaw(OBR_OF_DON_IS_NULL_DON_ASC)
                .orderBy(FieldNameConstants.BENEFICIARY_NAME, true)
                .where();
        if (locationIds.isEmpty()) {
            notificationWhere.and(
                    notificationWhere.eq(FieldNameConstants.NOTIFICATION_CODE, notificationCode),
                    notificationWhere.in(FieldNameConstants.STATE, pendingStates),
                    notificationWhere.le(FieldNameConstants.SCHEDULED_DATE, UtilBean.endOfDay(new Date())),
                    notificationWhere.or(
                            notificationWhere.gt(FieldNameConstants.EXPIRY_DATE, UtilBean.endOfDay(new Date())),
                            notificationWhere.isNull(FieldNameConstants.EXPIRY_DATE)
                    )
            );
        } else {
            notificationWhere.and(
                    notificationWhere.in(FieldNameConstants.LOCATION_ID, locationIds),
                    notificationWhere.eq(FieldNameConstants.NOTIFICATION_CODE, notificationCode),
                    notificationWhere.in(FieldNameConstants.STATE, pendingStates),
                    notificationWhere.le(FieldNameConstants.SCHEDULED_DATE, UtilBean.endOfDay(new Date())),
                    notificationWhere.or(
                            notificationWhere.gt(FieldNameConstants.EXPIRY_DATE, UtilBean.endOfDay(new Date())),
                            notificationWhere.isNull(FieldNameConstants.EXPIRY_DATE)
                    )
            );
        }

        return notificationQB.query();
    }

    private List<NotificationBean> getPregnantWomenNotifications(List<Integer> locationIds, String notificationCode, CharSequence searchString,
                                                                 long limit, long offset, LinkedHashMap<String, String> qrData) throws SQLException {

        QueryBuilder<FamilyBean, Integer> familyQB = familyBeanDao.queryBuilder();
        familyQB.where().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES);

        QueryBuilder<MemberBean, Integer> memberQB = memberBeanDao.queryBuilder()
                .join(FieldNameConstants.FAMILY_ID, FieldNameConstants.FAMILY_ID, familyQB);

        Where<MemberBean, Integer> where = memberQB.where();

        if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                qrData.containsKey(FieldNameConstants.FAMILY_ID))
            searchString = qrData.get(FieldNameConstants.FAMILY_ID);

        if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                Objects.equals(FieldNameConstants.IS_QR_FOR_ABHA, "true")) {
            where.and(
                    where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                    where.eq(FieldNameConstants.IS_PREGNANT_FLAG, Boolean.TRUE),
                    where.or(
                            where.like(FieldNameConstants.HEALTH_ID, "%" + qrData.get(FieldNameConstants.HEALTH_ID) + "%"),
                            where.like(FieldNameConstants.HEALTH_ID_NUMBER, "%" + qrData.get(FieldNameConstants.HEALTH_ID_NUMBER) + "%")
                    ),
                    where.or(
                            where.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + qrData.get(FieldNameConstants.UNIQUE_HEALTH_ID) + "%"),
                            where.like(FieldNameConstants.FAMILY_ID, "%" + qrData.get(FieldNameConstants.FAMILY_ID) + "%")
                    )
            );
        } else if (searchString != null) {
            where.and(
                    where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                    where.eq(FieldNameConstants.IS_PREGNANT_FLAG, Boolean.TRUE),
                    where.isNotNull(FieldNameConstants.CUR_PREGNANT_DETAILED_ID),
                    where.or(
                            where.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + searchString + "%"),   //Search By UniqueHealthId
                            where.like(FieldNameConstants.FIRST_NAME, "%" + searchString + "%"),         //Search By FirstName
                            where.like(FieldNameConstants.MIDDLE_NAME, "%" + searchString + "%"),       //Search By MiddleName
                            where.like(FieldNameConstants.LAST_NAME, "%" + searchString + "%"),         //Search By LastName
                            where.like(FieldNameConstants.FAMILY_ID, "%" + searchString + "%"),          //Search By FamilyId
                            where.like(FieldNameConstants.MOBILE_NUMBER, "%" + searchString + "%"),       //Search By MobileNumber
                            where.like(FieldNameConstants.NRC_NUMBER, "%" + searchString + "%"),    //Search by nrc
                            where.like(FieldNameConstants.HEALTH_ID, "%" + searchString + "%"),      //Search By HealthId
                            where.like(FieldNameConstants.SEARCH_STRING, "%" + searchString + "%")       //Search By HealthId      //Search By HealthId
                    )
            );
        } else {
            where.and(
                    where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                    where.eq(FieldNameConstants.IS_PREGNANT_FLAG, Boolean.TRUE),
                    where.isNotNull(FieldNameConstants.CUR_PREGNANT_DETAILED_ID)
            );
        }

        QueryBuilder<NotificationBean, Integer> notificationQB = notificationBeanDao.queryBuilder();
        Where<NotificationBean, Integer> notificationWhere = notificationQB.join(FieldNameConstants.MEMBER_ID, FieldNameConstants.ACTUAL_ID, memberQB)
                .limit(limit).offset(offset)
                .orderByRaw(OBR_OF_DON_IS_NULL_DON_ASC)
                .orderBy(FieldNameConstants.BENEFICIARY_NAME, true)
                .where();
        if (locationIds.isEmpty()) {
            notificationWhere.and(
                    notificationWhere.eq(FieldNameConstants.NOTIFICATION_CODE, notificationCode),
                    notificationWhere.in(FieldNameConstants.STATE, pendingStates),
                    notificationWhere.le(FieldNameConstants.SCHEDULED_DATE, UtilBean.endOfDay(new Date())),
                    notificationWhere.or(
                            notificationWhere.gt(FieldNameConstants.EXPIRY_DATE, UtilBean.endOfDay(new Date())),
                            notificationWhere.isNull(FieldNameConstants.EXPIRY_DATE)
                    )
            );
        } else {
            notificationWhere.and(
                    notificationWhere.in(FieldNameConstants.LOCATION_ID, locationIds),
                    notificationWhere.eq(FieldNameConstants.NOTIFICATION_CODE, notificationCode),
                    notificationWhere.in(FieldNameConstants.STATE, pendingStates),
                    notificationWhere.le(FieldNameConstants.SCHEDULED_DATE, UtilBean.endOfDay(new Date())),
                    notificationWhere.or(
                            notificationWhere.gt(FieldNameConstants.EXPIRY_DATE, UtilBean.endOfDay(new Date())),
                            notificationWhere.isNull(FieldNameConstants.EXPIRY_DATE)
                    )
            );
        }

        return notificationQB.query();
    }

    private List<NotificationBean> getChildrenNotifications(List<Integer> locationIds, String notificationCode, CharSequence searchString,
                                                            long limit, long offset, LinkedHashMap<String, String> qrData) throws SQLException {

        QueryBuilder<FamilyBean, Integer> familyQB = familyBeanDao.queryBuilder();
        familyQB.where().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES);

        QueryBuilder<MemberBean, Integer> memberQB = memberBeanDao.queryBuilder()
                .join(FieldNameConstants.FAMILY_ID, FieldNameConstants.FAMILY_ID, familyQB);

        Calendar dobCalender = Calendar.getInstance();
        dobCalender.add(Calendar.YEAR, -5);
        UtilBean.clearTimeFromDate(dobCalender);

        Where<MemberBean, Integer> memberWhere = memberQB.where();
        if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                qrData.containsKey(FieldNameConstants.FAMILY_ID))
            searchString = qrData.get(FieldNameConstants.FAMILY_ID);

        if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                Objects.equals(FieldNameConstants.IS_QR_FOR_ABHA, "true")) {
            memberWhere.and(
                    memberWhere.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                    memberWhere.ge(FieldNameConstants.DOB, dobCalender.getTime()),
                    memberWhere.or(
                            memberWhere.like(FieldNameConstants.HEALTH_ID, "%" + qrData.get(FieldNameConstants.HEALTH_ID) + "%"),
                            memberWhere.like(FieldNameConstants.HEALTH_ID_NUMBER, "%" + qrData.get(FieldNameConstants.HEALTH_ID_NUMBER) + "%")
                    ),
                    memberWhere.or(
                            memberWhere.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + qrData.get(FieldNameConstants.UNIQUE_HEALTH_ID) + "%"),
                            memberWhere.like(FieldNameConstants.FAMILY_ID, "%" + qrData.get(FieldNameConstants.FAMILY_ID) + "%")
                    )
            );
        } else if (searchString != null) {
            memberWhere.and(
                    memberWhere.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                    memberWhere.ge(FieldNameConstants.DOB, dobCalender.getTime()),
                    memberWhere.or(
                            memberWhere.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + searchString + "%"),   //Search By UniqueHealthId
                            memberWhere.like(FieldNameConstants.FIRST_NAME, "%" + searchString + "%"),         //Search By FirstName
                            memberWhere.like(FieldNameConstants.MIDDLE_NAME, "%" + searchString + "%"),       //Search By MiddleName
                            memberWhere.like(FieldNameConstants.LAST_NAME, "%" + searchString + "%"),         //Search By LastName
                            memberWhere.like(FieldNameConstants.FAMILY_ID, "%" + searchString + "%"),          //Search By FamilyId
                            memberWhere.like(FieldNameConstants.MOBILE_NUMBER, "%" + searchString + "%"),       //Search By MobileNumber
                            memberWhere.like(FieldNameConstants.NRC_NUMBER, "%" + searchString + "%"),    //Search by nrc
                            memberWhere.like(FieldNameConstants.HEALTH_ID, "%" + searchString + "%"),      //Search By HealthId
                            memberWhere.like(FieldNameConstants.SEARCH_STRING, "%" + searchString + "%")       //Search By HealthId       //Search By HealthId
                    )
            );
        } else {
            memberWhere.and(
                    memberWhere.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                    memberWhere.ge(FieldNameConstants.DOB, dobCalender.getTime())
            );
        }

        QueryBuilder<NotificationBean, Integer> notificationQB = notificationBeanDao.queryBuilder();
        Where<NotificationBean, Integer> notificationWhere = notificationQB.join(FieldNameConstants.MEMBER_ID, FieldNameConstants.ACTUAL_ID, memberQB)
                .limit(limit).offset(offset)
                .orderByRaw(OBR_OF_DON_IS_NULL_DON_ASC)
                .orderBy(FieldNameConstants.BENEFICIARY_NAME, true)
                .where();
        if (locationIds.isEmpty()) {
            notificationWhere.and(
                    notificationWhere.eq(FieldNameConstants.NOTIFICATION_CODE, notificationCode),
                    notificationWhere.le(FieldNameConstants.SCHEDULED_DATE, UtilBean.endOfDay(new Date())),
                    notificationWhere.in(FieldNameConstants.STATE, pendingStates),
                    notificationWhere.or(
                            notificationWhere.gt(FieldNameConstants.EXPIRY_DATE, UtilBean.endOfDay(new Date())),
                            notificationWhere.isNull(FieldNameConstants.EXPIRY_DATE)
                    )
            );
        } else {
            notificationWhere.and(
                    notificationWhere.in(FieldNameConstants.LOCATION_ID, locationIds),
                    notificationWhere.eq(FieldNameConstants.NOTIFICATION_CODE, notificationCode),
                    notificationWhere.le(FieldNameConstants.SCHEDULED_DATE, UtilBean.endOfDay(new Date())),
                    notificationWhere.in(FieldNameConstants.STATE, pendingStates),
                    notificationWhere.or(
                            notificationWhere.gt(FieldNameConstants.EXPIRY_DATE, UtilBean.endOfDay(new Date())),
                            notificationWhere.isNull(FieldNameConstants.EXPIRY_DATE)
                    )
            );
        }

        return notificationQB.query();
    }

    private List<NotificationBean> getGeriartricsMemberNotifications(List<Integer> locationIds, String notificationCode, CharSequence searchString,
                                                                     long limit, long offset, LinkedHashMap<String, String> qrData) throws SQLException {

        QueryBuilder<FamilyBean, Integer> familyQB = familyBeanDao.queryBuilder();
        familyQB.where().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES);

        QueryBuilder<MemberBean, Integer> memberQB = memberBeanDao.queryBuilder()
                .join(FieldNameConstants.FAMILY_ID, FieldNameConstants.FAMILY_ID, familyQB);

        Calendar dobCalender = Calendar.getInstance();
        dobCalender.add(Calendar.YEAR, -60);
        UtilBean.clearTimeFromDate(dobCalender);

        Where<MemberBean, Integer> memberWhere = memberQB.where();
        if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                qrData.containsKey(FieldNameConstants.FAMILY_ID))
            searchString = qrData.get(FieldNameConstants.FAMILY_ID);

        if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                Objects.equals(FieldNameConstants.IS_QR_FOR_ABHA, "true")) {
            memberWhere.and(
                    memberWhere.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                    memberWhere.le(FieldNameConstants.DOB, dobCalender.getTime()),
                    memberWhere.or(
                            memberWhere.like(FieldNameConstants.HEALTH_ID, "%" + qrData.get(FieldNameConstants.HEALTH_ID) + "%"),
                            memberWhere.like(FieldNameConstants.HEALTH_ID_NUMBER, "%" + qrData.get(FieldNameConstants.HEALTH_ID_NUMBER) + "%")
                    )
            );
        } else if (searchString != null) {
            memberWhere.and(
                    memberWhere.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                    memberWhere.le(FieldNameConstants.DOB, dobCalender.getTime()),
                    memberWhere.or(
                            memberWhere.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + searchString + "%"),
                            memberWhere.like(FieldNameConstants.FIRST_NAME, "%" + searchString + "%"),
                            memberWhere.like(FieldNameConstants.FAMILY_ID, "%" + searchString + "%"),
                            memberWhere.like(FieldNameConstants.MOBILE_NUMBER, "%" + searchString + "%"),
                            memberWhere.like(FieldNameConstants.HEALTH_ID, "%" + searchString + "%")
                    )
            );
        } else {
            memberWhere.and(
                    memberWhere.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                    memberWhere.le(FieldNameConstants.DOB, dobCalender.getTime())
            );
        }

        QueryBuilder<NotificationBean, Integer> notificationQB = notificationBeanDao.queryBuilder();
        Where<NotificationBean, Integer> notificationWhere = notificationQB.join(FieldNameConstants.MEMBER_ID, FieldNameConstants.ACTUAL_ID, memberQB)
                .limit(limit).offset(offset)
                .orderByRaw(OBR_OF_DON_IS_NULL_DON_ASC)
                .orderBy(FieldNameConstants.BENEFICIARY_NAME, true)
                .where();
        if (locationIds.isEmpty()) {
            notificationWhere.and(
                    notificationWhere.eq(FieldNameConstants.NOTIFICATION_CODE, notificationCode),
                    notificationWhere.le(FieldNameConstants.SCHEDULED_DATE, UtilBean.endOfDay(new Date())),
                    notificationWhere.in(FieldNameConstants.STATE, pendingStates),
                    notificationWhere.or(
                            notificationWhere.gt(FieldNameConstants.EXPIRY_DATE, UtilBean.endOfDay(new Date())),
                            notificationWhere.isNull(FieldNameConstants.EXPIRY_DATE)
                    )
            );
        } else {
            notificationWhere.and(
                    notificationWhere.in(FieldNameConstants.LOCATION_ID, locationIds),
                    notificationWhere.eq(FieldNameConstants.NOTIFICATION_CODE, notificationCode),
                    notificationWhere.le(FieldNameConstants.SCHEDULED_DATE, UtilBean.endOfDay(new Date())),
                    notificationWhere.in(FieldNameConstants.STATE, pendingStates),
                    notificationWhere.or(
                            notificationWhere.gt(FieldNameConstants.EXPIRY_DATE, UtilBean.endOfDay(new Date())),
                            notificationWhere.isNull(FieldNameConstants.EXPIRY_DATE)
                    )
            );
        }

        return notificationQB.query();
    }

    private List<NotificationBean> getDefaultNotifications(List<Integer> locationIds, String notificationCode,
                                                           long limit, long offset) throws SQLException {
        QueryBuilder<NotificationBean, Integer> notificationQB = notificationBeanDao.queryBuilder();
        Where<NotificationBean, Integer> notificationWhere = notificationQB.limit(limit).offset(offset)
                .orderByRaw(OBR_OF_DON_IS_NULL_DON_ASC)
                .orderBy(FieldNameConstants.BENEFICIARY_NAME, true)
                .where();
        if (locationIds.isEmpty()) {
            notificationWhere.and(
                    notificationWhere.eq(FieldNameConstants.NOTIFICATION_CODE, notificationCode),
                    notificationWhere.le(FieldNameConstants.SCHEDULED_DATE, UtilBean.endOfDay(new Date())),
                    notificationWhere.in(FieldNameConstants.STATE, pendingStates),
                    notificationWhere.or(
                            notificationWhere.gt(FieldNameConstants.EXPIRY_DATE, UtilBean.endOfDay(new Date())),
                            notificationWhere.isNull(FieldNameConstants.EXPIRY_DATE)
                    )
            );
        } else {
            notificationWhere.and(
                    notificationWhere.in(FieldNameConstants.LOCATION_ID, locationIds),
                    notificationWhere.eq(FieldNameConstants.NOTIFICATION_CODE, notificationCode),
                    notificationWhere.le(FieldNameConstants.SCHEDULED_DATE, UtilBean.endOfDay(new Date())),
                    notificationWhere.in(FieldNameConstants.STATE, pendingStates),
                    notificationWhere.or(
                            notificationWhere.gt(FieldNameConstants.EXPIRY_DATE, UtilBean.endOfDay(new Date())),
                            notificationWhere.isNull(FieldNameConstants.EXPIRY_DATE)
                    )
            );
        }

        return notificationQB.query();
    }

    @Override
    public Map<String, Integer> retrieveCountForNotificationType(List<Integer> villageIds, List<Integer> areaIds) {
        try {
            if (areaIds == null) {
                areaIds = new ArrayList<>();
            }

            if (areaIds.isEmpty() && villageIds != null && !villageIds.isEmpty()) {
                areaIds = new ArrayList<>();
                List<LocationBean> areas = locationBeanDao.queryBuilder().selectColumns(FieldNameConstants.ACTUAL_ID)
                        .where().in(FieldNameConstants.PARENT, villageIds).query();
                for (LocationBean locationBean : areas) {
                    areaIds.add(locationBean.getActualID());
                }
            }

            List<Integer> finalLocationIds = new LinkedList<>();

            if (villageIds != null && !villageIds.isEmpty()) {
                finalLocationIds.addAll(villageIds);
            }
            if (!areaIds.isEmpty()) {
                finalLocationIds.addAll(areaIds);
            }

            List<NotificationBean> notificationBeans;
            QueryBuilder<NotificationBean, Integer> notificationQB = notificationBeanDao.queryBuilder();
            Where<NotificationBean, Integer> where = notificationQB.selectColumns(FieldNameConstants.NOTIFICATION_CODE, FieldNameConstants.MEMBER_ID)
                    .where();
            if (finalLocationIds.isEmpty()) {
                where.and(
                        where.in(FieldNameConstants.STATE, pendingStates),
                        where.le(FieldNameConstants.SCHEDULED_DATE, UtilBean.endOfDay(new Date())),
                        where.or(
                                where.gt(FieldNameConstants.EXPIRY_DATE, UtilBean.endOfDay(new Date())),
                                where.isNull(FieldNameConstants.EXPIRY_DATE)
                        )
                );
            } else {
                where.and(
                        where.in(FieldNameConstants.LOCATION_ID, finalLocationIds),
                        where.in(FieldNameConstants.STATE, pendingStates),
                        where.le(FieldNameConstants.SCHEDULED_DATE, UtilBean.endOfDay(new Date())),
                        where.or(
                                where.gt(FieldNameConstants.EXPIRY_DATE, UtilBean.endOfDay(new Date())),
                                where.isNull(FieldNameConstants.EXPIRY_DATE)
                        )
                );
            }
            notificationBeans = notificationQB.query();

            Integer lmpfuCount = 0;
            Integer ancCount = 0;
            Integer wpdCount = 0;
            Integer pncCount = 0;
            Integer csCount = 0;
            Integer miCount = 0;
            Integer moCount = 0;
            Integer familyMigrationInCount = 0;
            Integer dischargeCount = 0;
            Integer samScreeningCount = 0;
            Integer appetiteCount = 0;
            Integer readOnlyCount = 0;
            Integer ashaLmpfuCount = 0;
            Integer ashaPNCCount = 0;
            Integer ashaCSCount = 0;
            Integer ashaAncCount = 0;
            Integer ashaReadOnlyCount = 0;
            Integer awwCsCount = 0;
            Integer ashaSamScreeningCount = 0;
            Integer samScreeningRefCount = 0;
            Integer cmamCompletionSamScreeningCount = 0;
            Integer ashaCmamCount = 0;
            Integer gmaCount = 0;
            Integer tsaCount = 0;
            Integer clinicVisitCount = 0;
            Integer homeVisitCount = 0;
            Integer clinicCvcVisitCount = 0;
            Integer homeCvcVisitCount = 0;
            Integer retinopathyCount = 0;
            Integer ecgCount = 0;
            Integer fpFollowUpCount = 0;
            Integer cmamForConfirmedSamCount = 0;
            Integer cmamForConfirmedMamCount = 0;
            Integer cmamFollowUpCount = 0;
            Integer tbFollowUpCount = 0;
            Integer activeMalariaCount = 0;
            Integer hivNegativeCount = 0;

            for (NotificationBean bean : notificationBeans) {
                if (bean.getNotificationCode().equals(NotificationConstants.FHW_NOTIFICATION_MIGRATION_IN)) {
                    miCount++;
                    continue;
                }
                if (bean.getNotificationCode().equals(NotificationConstants.FHW_NOTIFICATION_MIGRATION_OUT)) {
                    moCount++;
                    continue;
                }
                if (bean.getNotificationCode().equals(NotificationConstants.FHW_NOTIFICATION_READ_ONLY)) {
                    readOnlyCount++;
                    continue;
                }
                if (bean.getNotificationCode().equals(NotificationConstants.ASHA_NOTIFICATION_READ_ONLY)) {
                    ashaReadOnlyCount++;
                    continue;
                }

                if (bean.getNotificationCode().equals(NotificationConstants.FHW_NOTIFICATION_FAMILY_MIGRATION_IN)) {
                    familyMigrationInCount++;
                    continue;
                }

                if (bean.getNotificationCode().equals(NotificationConstants.NOTIFICATION_NCD_RETINOPATHY_TEST)) {
                    retinopathyCount++;
                    continue;
                }
                if (bean.getNotificationCode().equals(NotificationConstants.NOTIFICATION_NCD_ECG_TEST)) {
                    ecgCount++;
                    continue;
                }

                if (bean.getNotificationCode().equals(NotificationConstants.NOTIFICATION_FP_FOLLOW_UP_VISIT)) {
                    fpFollowUpCount++;
                    continue;
                }

                if (bean.getMemberId() == null) {
                    continue;
                }

                MemberBean memberBean = memberBeanDao.queryBuilder().selectColumns(FieldNameConstants.IS_PREGNANT_FLAG,
                                FieldNameConstants.FAMILY_ID,
                                FieldNameConstants.STATE,
                                FieldNameConstants.DOB,
                                FieldNameConstants.IS_HIV_POSITIVE,
                                FieldNameConstants.HYSTERECTOMY_DONE,
                                FieldNameConstants.MENOPAUSE_ARRIVED,
                                FieldNameConstants.ADDITIONAL_INFO)
                        .where().eq(FieldNameConstants.ACTUAL_ID, bean.getMemberId()).queryForFirst();
                if (memberBean == null || FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES.contains(memberBean.getState())) {
                    continue;
                }

                FamilyBean familyBean = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.STATE)
                        .where().eq(FieldNameConstants.FAMILY_ID, memberBean.getFamilyId()).queryForFirst();
                if (familyBean == null || !FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES.contains(familyBean.getState())) {
                    continue;
                }

                Calendar calendar = Calendar.getInstance();
                calendar.add(Calendar.YEAR, -5);
                Date before5Years = calendar.getTime();
                calendar = Calendar.getInstance();
                calendar.add(Calendar.YEAR, -60);
                Date before60Years = calendar.getTime();
                MemberAdditionalInfoDataBean memberAdditionalInfoDataBean = new Gson().fromJson(memberBean.getAdditionalInfo(), MemberAdditionalInfoDataBean.class);
                switch (bean.getNotificationCode()) {
                    case NotificationConstants.FHW_NOTIFICATION_LMP_FOLLOW_UP:
                        if ((memberBean.getHysterectomyDone() == null || Boolean.FALSE.equals(memberBean.getHysterectomyDone()))
                                && (memberBean.getMenopauseArrived() == null || Boolean.FALSE.equals(memberBean.getMenopauseArrived()))
                                && (memberBean.getIsPregnantFlag() == null || Boolean.FALSE.equals(memberBean.getIsPregnantFlag()))) {
                            lmpfuCount++;
                        }
                        break;
                    case NotificationConstants.FHW_NOTIFICATION_ANC:
                        if (memberBean.getIsPregnantFlag() != null && Boolean.TRUE.equals(memberBean.getIsPregnantFlag())) {
                            ancCount++;
                        }
                        break;
                    case NotificationConstants.FHW_NOTIFICATION_WORK_PLAN_FOR_DELIVERY:
                        if (memberBean.getIsPregnantFlag() != null && Boolean.TRUE.equals(memberBean.getIsPregnantFlag())) {
                            wpdCount++;
                        }
                        break;
                    case NotificationConstants.FHW_NOTIFICATION_PNC:
                        if (memberBean.getIsPregnantFlag() == null || Boolean.FALSE.equals(memberBean.getIsPregnantFlag())) {
                            pncCount++;
                        }
                        break;
                    case NotificationConstants.FHW_NOTIFICATION_CHILD_SERVICES:
                        if (memberBean.getDob() != null && memberBean.getDob().after(before5Years)) {
                            csCount++;
                        }
                        break;
                    case NotificationConstants.FHW_NOTIFICATION_DISCHARGE:
                        if (memberBean.getIsPregnantFlag() == null || Boolean.FALSE.equals(memberBean.getIsPregnantFlag())) {
                            dischargeCount++;
                        }
                        break;
                    case NotificationConstants.FHW_NOTIFICATION_SAM_SCREENING:
                        if (memberBean.getDob() != null && memberBean.getDob().after(before5Years)) {
                            samScreeningCount++;
                        }
                        break;
                    case NotificationConstants.FHW_NOTIFICATION_APPETITE:
                        if (memberBean.getDob() != null && memberBean.getDob().after(before5Years)) {
                            appetiteCount++;
                        }
                        break;
                    case FormConstants.FHW_SAM_SCREENING_REF:
                        if (memberBean.getDob() != null && memberBean.getDob().after(before5Years)) {
                            samScreeningRefCount++;
                        }
                        break;
                    case FormConstants.CMAM_FOLLOWUP:
                        if (memberBean.getDob() != null && memberBean.getDob().after(before5Years)) {
                            ashaCmamCount++;
                        }
                        break;
                    case FormConstants.FHW_MONTHLY_SAM_SCREENING:
                        if (memberBean.getDob() != null && memberBean.getDob().after(before5Years)) {
                            cmamCompletionSamScreeningCount++;
                        }
                        break;
                    case FormConstants.ASHA_SAM_SCREENING:
                        if (memberBean.getDob() != null && memberBean.getDob().after(before5Years)) {
                            ashaSamScreeningCount++;
                        }
                        break;
                    case FormConstants.ASHA_LMPFU:
                        if (memberBean.getIsPregnantFlag() == null || Boolean.FALSE.equals(memberBean.getIsPregnantFlag())) {
                            ashaLmpfuCount++;
                        }
                        break;
                    case FormConstants.ASHA_ANC:
                        if (memberBean.getIsPregnantFlag() != null && Boolean.TRUE.equals(memberBean.getIsPregnantFlag())) {
                            ashaAncCount++;
                        }
                        break;
                    case FormConstants.ASHA_PNC:
                        if (memberBean.getIsPregnantFlag() == null || Boolean.FALSE.equals(memberBean.getIsPregnantFlag())) {
                            ashaPNCCount++;
                        }
                        break;
                    case FormConstants.ASHA_CS:
                        if (memberBean.getDob() != null && memberBean.getDob().after(before5Years)) {
                            ashaCSCount++;
                        }
                        break;
                    case FormConstants.TECHO_AWW_CS:
                        if (memberBean.getDob() != null && memberBean.getDob().after(before5Years)) {
                            awwCsCount++;
                        }
                        break;
                    case FormConstants.GERIATRICS_MEDICATION_ALERT:
                        if (memberBean.getDob() != null && memberBean.getDob().after(before60Years)) {
                            gmaCount++;
                        }
                        break;
                    case NotificationConstants.NOTIFICATION_ACTIVE_MALARIA:
                        if (memberAdditionalInfoDataBean != null && memberAdditionalInfoDataBean.getRdtStatus() != null && memberAdditionalInfoDataBean.getRdtStatus().equalsIgnoreCase("POSITIVE")) {
                            activeMalariaCount++;
                            continue;
                        }
                        break;
                    case NotificationConstants.NOTIFICATION_TB_FOLLOW_UP:
                        if (memberAdditionalInfoDataBean != null
                                && memberAdditionalInfoDataBean.getTbSuspected() != null
                                && memberAdditionalInfoDataBean.getTbSuspected()
                                && memberAdditionalInfoDataBean.getTbCured() != null
                                && !memberAdditionalInfoDataBean.getTbCured()) {
                            tbFollowUpCount++;
                            continue;
                        }
                        break;
                    case NotificationConstants.NOTIFICATION_HIV_NEGATIVE_FOLLOWUP_VISIT:
                        if (memberBean.getIsHivPositive() != null && memberBean.getIsHivPositive().equalsIgnoreCase(RchConstants.TEST_NEGATIVE)) {
                            hivNegativeCount++;
                            continue;
                        }
                        break;

                    default:
                }
            }

            // For NCD Weekly Visits
            List<String> notificationCode = new ArrayList<>();
            notificationCode.add(NotificationConstants.NOTIFICATION_NCD_CLINIC_VISIT);
            notificationCode.add(NotificationConstants.NOTIFICATION_NCD_HOME_VISIT);
            notificationCode.add(FormConstants.NCD_CVC_CLINIC);
            notificationCode.add(FormConstants.NCD_CVC_HOME);
            List<NotificationBean> ncdNotificationBeans;
            if (finalLocationIds.isEmpty()) {
                ncdNotificationBeans = notificationBeanDao.queryBuilder().selectColumns(FieldNameConstants.NOTIFICATION_CODE, FieldNameConstants.MEMBER_ID, FieldNameConstants.SCHEDULED_DATE)
                        .where().in(FieldNameConstants.STATE, pendingStates)
                        .and().in(FieldNameConstants.NOTIFICATION_CODE, notificationCode)
                        .query();
            } else {
                ncdNotificationBeans = notificationBeanDao.queryBuilder().selectColumns(FieldNameConstants.NOTIFICATION_CODE, FieldNameConstants.MEMBER_ID, FieldNameConstants.SCHEDULED_DATE)
                        .where().in(FieldNameConstants.LOCATION_ID, finalLocationIds)
                        .and().in(FieldNameConstants.STATE, pendingStates)
                        .and().in(FieldNameConstants.NOTIFICATION_CODE, notificationCode)
                        .query();
            }
            for (NotificationBean notificationBean : ncdNotificationBeans) {
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(notificationBean.getScheduledDate());
                calendar.add(Calendar.DATE, -7);
                Date before7Days = calendar.getTime();
                if (new Date().after(before7Days)) {
                    if (notificationBean.getNotificationCode().equals(NotificationConstants.NOTIFICATION_NCD_CLINIC_VISIT)) {
                        clinicVisitCount++;
                        continue;
                    }

                    if (notificationBean.getNotificationCode().equals(NotificationConstants.NOTIFICATION_NCD_HOME_VISIT)) {
                        homeVisitCount++;
                        continue;
                    }
                    if (notificationBean.getNotificationCode().equals(FormConstants.NCD_CVC_CLINIC)) {
                        clinicCvcVisitCount++;
                        continue;
                    }

                    if (notificationBean.getNotificationCode().equals(FormConstants.NCD_CVC_HOME)) {
                        homeCvcVisitCount++;
                        continue;
                    }
                }
            }

            Map<String, Integer> hashMap = new HashMap<>();
            hashMap.put(NotificationConstants.FHW_NOTIFICATION_LMP_FOLLOW_UP, lmpfuCount);
            hashMap.put(NotificationConstants.FHW_NOTIFICATION_ANC, ancCount);
            hashMap.put(NotificationConstants.FHW_NOTIFICATION_WORK_PLAN_FOR_DELIVERY, wpdCount);
            hashMap.put(NotificationConstants.FHW_NOTIFICATION_DISCHARGE, dischargeCount);
            hashMap.put(NotificationConstants.FHW_NOTIFICATION_PNC, pncCount);
            hashMap.put(NotificationConstants.FHW_NOTIFICATION_CHILD_SERVICES, csCount);
            hashMap.put(NotificationConstants.FHW_NOTIFICATION_SAM_SCREENING, samScreeningCount);
            hashMap.put(FormConstants.FHW_SAM_SCREENING_REF, samScreeningRefCount);
            hashMap.put(NotificationConstants.FHW_NOTIFICATION_APPETITE, appetiteCount);
            hashMap.put(FormConstants.FHW_MONTHLY_SAM_SCREENING, cmamCompletionSamScreeningCount);
            hashMap.put(FormConstants.CMAM_FOLLOWUP, ashaCmamCount);
            hashMap.put(NotificationConstants.FHW_NOTIFICATION_MIGRATION_IN, miCount);
            //hashMap.put(NotificationConstants.FHW_NOTIFICATION_MIGRATION_OUT, moCount);
            hashMap.put(NotificationConstants.FHW_NOTIFICATION_FAMILY_MIGRATION_IN, familyMigrationInCount);
            hashMap.put(FormConstants.ASHA_SAM_SCREENING, ashaSamScreeningCount);
            hashMap.put(FormConstants.ASHA_PNC, ashaPNCCount);
            hashMap.put(FormConstants.ASHA_CS, ashaCSCount);
            hashMap.put(FormConstants.ASHA_ANC, ashaAncCount);
            hashMap.put(FormConstants.ASHA_LMPFU, ashaLmpfuCount);
            hashMap.put(NotificationConstants.FHW_NOTIFICATION_READ_ONLY, readOnlyCount);
            hashMap.put(NotificationConstants.ASHA_NOTIFICATION_READ_ONLY, ashaReadOnlyCount);
            hashMap.put(FormConstants.TECHO_AWW_CS, awwCsCount);
            hashMap.put(NotificationConstants.FHW_NOTIFICATION_GERIATRICS_MEDICATION, gmaCount);
            hashMap.put(NotificationConstants.FHW_NOTIFICATION_TRAVELLERS_SCREENING, tsaCount);
            hashMap.put(NotificationConstants.NOTIFICATION_NCD_CLINIC_VISIT, clinicVisitCount);
            hashMap.put(NotificationConstants.NOTIFICATION_NCD_HOME_VISIT, homeVisitCount);
            hashMap.put(FormConstants.NCD_CVC_CLINIC, clinicCvcVisitCount);
            hashMap.put(FormConstants.NCD_CVC_HOME, homeCvcVisitCount);
            hashMap.put(NotificationConstants.NOTIFICATION_NCD_RETINOPATHY_TEST, retinopathyCount);
            hashMap.put(NotificationConstants.NOTIFICATION_NCD_ECG_TEST, ecgCount);

            hashMap.put(NotificationConstants.CMAM_FOR_CONFIRMED_MAM, cmamForConfirmedMamCount);
            hashMap.put(NotificationConstants.CMAM_FOR_CONFIRMED_SAM, cmamForConfirmedSamCount);
            hashMap.put(NotificationConstants.CMAM_FOLLOWUP, cmamFollowUpCount);
            hashMap.put(NotificationConstants.NOTIFICATION_TB_FOLLOW_UP, tbFollowUpCount);
            hashMap.put(NotificationConstants.NOTIFICATION_ACTIVE_MALARIA, activeMalariaCount);
            hashMap.put(NotificationConstants.NOTIFICATION_FP_FOLLOW_UP_VISIT, fpFollowUpCount);
            hashMap.put(NotificationConstants.NOTIFICATION_HIV_NEGATIVE_FOLLOWUP_VISIT, hivNegativeCount);

            return hashMap;
        } catch (SQLException e) {
            android.util.Log.e(getClass().getSimpleName(), null, e);
        }
        return new HashMap<>();
    }

    @Override
    public Map<String, Integer> retrieveCountForAshaReportedEventNotificationType(List<Integer> villageIds, List<Integer> areaIds) {
        try {
            if (areaIds == null) {
                areaIds = new ArrayList<>();
            }

            if (areaIds.isEmpty() && villageIds != null && !villageIds.isEmpty()) {
                areaIds = new ArrayList<>();
                List<LocationBean> areas = locationBeanDao.queryBuilder().selectColumns(FieldNameConstants.ACTUAL_ID)
                        .where().in(FieldNameConstants.PARENT, villageIds).query();
                for (LocationBean locationBean : areas) {
                    areaIds.add(locationBean.getActualID());
                }
            }

            List<Long> finalLocationIds = new LinkedList<>();
            if (villageIds != null && !villageIds.isEmpty()) {
                for (Integer locationId : villageIds) {
                    finalLocationIds.add(Long.valueOf(locationId));
                }
            }
            if (!areaIds.isEmpty()) {
                for (Integer locationId : areaIds) {
                    finalLocationIds.add(Long.valueOf(locationId));
                }
            }

            List<NotificationBean> notificationBeans;
            if (finalLocationIds.isEmpty()) {
                notificationBeans = notificationBeanDao.queryBuilder()
                        .selectColumns(FieldNameConstants.NOTIFICATION_CODE, FieldNameConstants.MEMBER_ID, FieldNameConstants.FAMILY_ID)
                        .where().in(FieldNameConstants.STATE, pendingStates)
                        .and().in(FieldNameConstants.NOTIFICATION_CODE, NotificationConstants.ASHA_REPORTED_EVENT_NOTIFICATIONS)
                        .and().le(FieldNameConstants.SCHEDULED_DATE, UtilBean.endOfDay(new Date())).query();
            } else {
                notificationBeans = notificationBeanDao.queryBuilder()
                        .selectColumns(FieldNameConstants.NOTIFICATION_CODE, FieldNameConstants.MEMBER_ID, FieldNameConstants.FAMILY_ID)
                        .where().in(FieldNameConstants.LOCATION_ID, finalLocationIds)
                        .and().in(FieldNameConstants.STATE, pendingStates)
                        .and().in(FieldNameConstants.NOTIFICATION_CODE, NotificationConstants.ASHA_REPORTED_EVENT_NOTIFICATIONS)
                        .and().le(FieldNameConstants.SCHEDULED_DATE, UtilBean.endOfDay(new Date())).query();
            }

            Integer pregConfCount = 0;
            Integer deliveryConfCount = 0;
            Integer deathConfCount = 0;
            Integer memberMigrationCount = 0;
            Integer familyMigrationCount = 0;
            Integer familySplitCount = 0;

            for (NotificationBean bean : notificationBeans) {
                MemberBean memberBean;
                FamilyBean familyBean;

                switch (bean.getNotificationCode()) {
                    case NotificationConstants.NOTIFICATION_FHW_PREGNANCY_CONF:
                        if (bean.getMemberId() != null) {
                            memberBean = memberBeanDao.queryBuilder().selectColumns(FieldNameConstants.STATE)
                                    .where().eq(FieldNameConstants.ACTUAL_ID, bean.getMemberId()).queryForFirst();
                            if (memberBean != null) {
                                pregConfCount++;
                            }
                        }
                        break;

                    case NotificationConstants.NOTIFICATION_FHW_DELIVERY_CONF:
                        if (bean.getMemberId() != null) {
                            memberBean = memberBeanDao.queryBuilder().selectColumns(FieldNameConstants.STATE)
                                    .where().eq(FieldNameConstants.ACTUAL_ID, bean.getMemberId()).queryForFirst();
                            if (memberBean != null) {
                                deliveryConfCount++;
                            }
                        }
                        break;

                    case NotificationConstants.NOTIFICATION_FHW_DEATH_CONF:
                        if (bean.getMemberId() != null) {
                            memberBean = memberBeanDao.queryBuilder().selectColumns(FieldNameConstants.STATE)
                                    .where().eq(FieldNameConstants.ACTUAL_ID, bean.getMemberId()).queryForFirst();
                            if (memberBean != null) {
                                deathConfCount++;
                            }
                        }
                        break;

                    case NotificationConstants.NOTIFICATION_FHW_MEMBER_MIGRATION:
                        if (bean.getMemberId() != null) {
                            memberBean = memberBeanDao.queryBuilder().selectColumns(FieldNameConstants.STATE)
                                    .where().eq(FieldNameConstants.ACTUAL_ID, bean.getMemberId()).queryForFirst();
                            if (memberBean != null) {
                                memberMigrationCount++;
                            }
                        }
                        break;

                    case NotificationConstants.NOTIFICATION_FHW_FAMILY_MIGRATION:
                        if (bean.getFamilyId() != null) {
                            familyBean = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.STATE)
                                    .where().eq(FieldNameConstants.ACTUAL_ID, bean.getFamilyId()).queryForFirst();
                            if (familyBean != null) {
                                familyMigrationCount++;
                            }
                        }
                        break;

                    case NotificationConstants.NOTIFICATION_FHW_FAMILY_SPLIT:
                        if (bean.getFamilyId() != null) {
                            familyBean = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.STATE)
                                    .where().eq(FieldNameConstants.ACTUAL_ID, bean.getFamilyId()).queryForFirst();
                            if (familyBean != null) {
                                familySplitCount++;
                            }
                        }
                        break;

                    default:
                }
            }

            Map<String, Integer> hashMap = new HashMap<>();
            hashMap.put(NotificationConstants.NOTIFICATION_FHW_PREGNANCY_CONF, pregConfCount);
            hashMap.put(NotificationConstants.NOTIFICATION_FHW_DELIVERY_CONF, deliveryConfCount);
            hashMap.put(NotificationConstants.NOTIFICATION_FHW_DEATH_CONF, deathConfCount);
            hashMap.put(NotificationConstants.NOTIFICATION_FHW_MEMBER_MIGRATION, memberMigrationCount);
            hashMap.put(NotificationConstants.NOTIFICATION_FHW_FAMILY_MIGRATION, familyMigrationCount);
            hashMap.put(NotificationConstants.NOTIFICATION_FHW_FAMILY_SPLIT, familySplitCount);

            return hashMap;
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return new HashMap<>();
    }

    @Override
    public Map<String, Integer> retrieveCountForOtherServicesNotificationType(List<Integer> villageIds, List<Integer> areaIds) {
        try {
            if (areaIds == null) {
                areaIds = new ArrayList<>();
            }

            if (areaIds.isEmpty() && villageIds != null && !villageIds.isEmpty()) {
                List<LocationBean> areas = locationBeanDao.queryBuilder().selectColumns(FieldNameConstants.ACTUAL_ID)
                        .where().in(FieldNameConstants.PARENT, villageIds).query();
                for (LocationBean locationBean : areas) {
                    areaIds.add(locationBean.getActualID());
                }
            }

            List<Long> finalLocationIds = new LinkedList<>();
            if (villageIds != null && !villageIds.isEmpty()) {
                for (Integer locationId : villageIds) {
                    finalLocationIds.add(Long.valueOf(locationId));
                }
            }
            if (!areaIds.isEmpty()) {
                for (Integer locationId : areaIds) {
                    finalLocationIds.add(Long.valueOf(locationId));
                }
            }

            List<String> notificationTypes = new ArrayList<>();
            notificationTypes.add(NotificationConstants.FHW_NOTIFICATION_TT2);
            notificationTypes.add(NotificationConstants.FHW_NOTIFICATION_IRON_SUCROSE);

            List<NotificationBean> notificationBeans;
            if (finalLocationIds.isEmpty()) {
                notificationBeans = notificationBeanDao.queryBuilder().selectColumns(FieldNameConstants.NOTIFICATION_CODE, FieldNameConstants.MEMBER_ID)
                        .where().in(FieldNameConstants.STATE, pendingStates)
                        .and().in(FieldNameConstants.NOTIFICATION_CODE, notificationTypes)
                        .and().le(FieldNameConstants.SCHEDULED_DATE, UtilBean.endOfDay(new Date())).query();
            } else {
                notificationBeans = notificationBeanDao.queryBuilder().selectColumns(FieldNameConstants.NOTIFICATION_CODE, FieldNameConstants.MEMBER_ID)
                        .where().in(FieldNameConstants.LOCATION_ID, finalLocationIds)
                        .and().in(FieldNameConstants.STATE, pendingStates)
                        .and().in(FieldNameConstants.NOTIFICATION_CODE, notificationTypes)
                        .and().le(FieldNameConstants.SCHEDULED_DATE, UtilBean.endOfDay(new Date())).query();
            }

            Integer tt2Count = 0;
            Integer ironSucroseCount = 0;

            for (NotificationBean bean : notificationBeans) {
                if (bean.getMemberId() == null) {
                    continue;
                }

                MemberBean memberBean = memberBeanDao.queryBuilder().selectColumns(FieldNameConstants.IS_PREGNANT_FLAG, FieldNameConstants.FAMILY_ID, FieldNameConstants.STATE, FieldNameConstants.DOB)
                        .where().eq(FieldNameConstants.ACTUAL_ID, bean.getMemberId()).queryForFirst();
                if (memberBean == null || FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES.contains(memberBean.getState())) {
                    continue;
                }

                FamilyBean familyBean = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.STATE)
                        .where().eq(FieldNameConstants.FAMILY_ID, memberBean.getFamilyId()).queryForFirst();
                if (familyBean == null || !FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES.contains(familyBean.getState())) {
                    continue;
                }

                switch (bean.getNotificationCode()) {
                    case NotificationConstants.FHW_NOTIFICATION_TT2:
                        tt2Count++;
                        break;
                    case NotificationConstants.FHW_NOTIFICATION_IRON_SUCROSE:
                        ironSucroseCount++;
                        break;
                    default:
                }
            }

            Map<String, Integer> hashMap = new HashMap<>();
            hashMap.put(NotificationConstants.FHW_NOTIFICATION_TT2, tt2Count);
            hashMap.put(NotificationConstants.FHW_NOTIFICATION_IRON_SUCROSE, ironSucroseCount);

            return hashMap;
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return new HashMap<>();
    }

    @Override
    public Boolean checkIfThereArePendingNotificationsForMember(Long memberId, String notificationCode) {
        if (memberId != null) {
            try {
                long count = notificationBeanDao.queryBuilder()
                        .where().eq(FieldNameConstants.NOTIFICATION_CODE, notificationCode)
                        .and().in(FieldNameConstants.STATE, pendingStates)
                        .and().eq(FieldNameConstants.MEMBER_ID, memberId).countOf();

                if (count > 0) {
                    return true;
                }
            } catch (SQLException e) {
                Log.e(TAG, null, e);
            }
        }
        return false;
    }

    @Override
    public Integer getVillageIdFromAshaArea(Integer areaId) {
        try {
            LocationBean villageBean = locationBeanDao.queryBuilder().selectColumns(FieldNameConstants.PARENT)
                    .where().eq(FieldNameConstants.ACTUAL_I_D, areaId).queryForFirst();
            return villageBean.getParent();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Map<String, Integer> retrieveCountForDnhddNutritionNotifications(List<Integer> villageIds, List<Integer> areaIds) {
        try {
            if (areaIds == null) {
                areaIds = new ArrayList<>();
            }

            if (areaIds.isEmpty() && villageIds != null && !villageIds.isEmpty()) {
                areaIds = new ArrayList<>();
                List<LocationBean> areas = locationBeanDao.queryBuilder().selectColumns(FieldNameConstants.ACTUAL_ID)
                        .where().in(FieldNameConstants.PARENT, villageIds).query();
                for (LocationBean locationBean : areas) {
                    areaIds.add(locationBean.getActualID());
                }
            }

            List<Long> finalLocationIds = new LinkedList<>();
            if (villageIds != null && !villageIds.isEmpty()) {
                for (Integer locationId : villageIds) {
                    finalLocationIds.add(Long.valueOf(locationId));
                }
            }
            if (!areaIds.isEmpty()) {
                for (Integer locationId : areaIds) {
                    finalLocationIds.add(Long.valueOf(locationId));
                }
            }

            List<NotificationBean> notificationBeans;
            if (finalLocationIds.isEmpty()) {
                notificationBeans = notificationBeanDao.queryBuilder()
                        .selectColumns(FieldNameConstants.NOTIFICATION_CODE, FieldNameConstants.MEMBER_ID, FieldNameConstants.FAMILY_ID)
                        .where().in(FieldNameConstants.STATE, pendingStates)
                        .and().in(FieldNameConstants.NOTIFICATION_CODE, NotificationConstants.DNHDD_SAM_NOTIFICATIONS)
                        .and().le(FieldNameConstants.SCHEDULED_DATE, UtilBean.endOfDay(new Date())).query();
            } else {
                notificationBeans = notificationBeanDao.queryBuilder()
                        .selectColumns(FieldNameConstants.NOTIFICATION_CODE, FieldNameConstants.MEMBER_ID, FieldNameConstants.FAMILY_ID)
                        .where().in(FieldNameConstants.STATE, pendingStates)
                        .and().in(FieldNameConstants.LOCATION_ID, finalLocationIds)
                        .and().in(FieldNameConstants.NOTIFICATION_CODE, NotificationConstants.DNHDD_SAM_NOTIFICATIONS)
                        .and().le(FieldNameConstants.SCHEDULED_DATE, UtilBean.endOfDay(new Date())).query();
            }

            Integer suspectedSamCount = 0;
            Integer suspectedMamCount = 0;
            Integer samScreeningCount = 0;
            Integer cmamForConfirmedSamCount = 0;
            Integer cmamForConfirmedMamCount = 0;
            Integer cmamFollowUpCount = 0;
            Integer cmamCompletionSamScreeningCount = 0;

            for (NotificationBean bean : notificationBeans) {

                MemberBean memberBean = memberBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID, FieldNameConstants.STATE, FieldNameConstants.DOB)
                        .where().eq(FieldNameConstants.ACTUAL_ID, bean.getMemberId()).queryForFirst();
                if (memberBean == null || FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES.contains(memberBean.getState())) {
                    continue;
                }

                FamilyBean familyBean = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.STATE)
                        .where().eq(FieldNameConstants.FAMILY_ID, memberBean.getFamilyId()).queryForFirst();
                if (familyBean == null || !FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES.contains(familyBean.getState())) {
                    continue;
                }

                Calendar calendar = Calendar.getInstance();
                calendar.add(Calendar.YEAR, -6);
                Date before6Years = calendar.getTime();

                switch (bean.getNotificationCode()) {
                    case NotificationConstants.FHW_NOTIFICATION_SAM_SCREENING:
                        if (memberBean.getDob() != null && memberBean.getDob().after(before6Years)) {
                            samScreeningCount++;
                        }
                        break;

                    case NotificationConstants.SUSPECTED_MAM_FROM_ASHA:
                        if (memberBean.getDob() != null && memberBean.getDob().after(before6Years)) {
                            suspectedMamCount++;
                        }
                        break;

                    case NotificationConstants.SUSPECTED_SAM_FROM_ASHA:
                        if (memberBean.getDob() != null && memberBean.getDob().after(before6Years)) {
                            suspectedSamCount++;
                        }
                        break;

                    case NotificationConstants.CMAM_FOR_CONFIRMED_MAM:
                        if (memberBean.getDob() != null && memberBean.getDob().after(before6Years)) {
                            cmamForConfirmedMamCount++;
                        }
                        break;

                    case NotificationConstants.CMAM_FOR_CONFIRMED_SAM:
                        if (memberBean.getDob() != null && memberBean.getDob().after(before6Years)) {
                            cmamForConfirmedSamCount++;
                        }
                        break;

                    case NotificationConstants.CMAM_FOLLOWUP:
                        if (memberBean.getDob() != null && memberBean.getDob().after(before6Years)) {
                            cmamFollowUpCount++;
                        }
                        break;

                    case FormConstants.FHW_MONTHLY_SAM_SCREENING:
                        if (memberBean.getDob() != null && memberBean.getDob().after(before6Years)) {
                            cmamCompletionSamScreeningCount++;
                        }
                        break;

                    default:
                }
            }

            Map<String, Integer> hashMap = new HashMap<>();
            hashMap.put(NotificationConstants.FHW_NOTIFICATION_SAM_SCREENING, samScreeningCount);
            hashMap.put(NotificationConstants.SUSPECTED_MAM_FROM_ASHA, suspectedMamCount);
            hashMap.put(NotificationConstants.SUSPECTED_SAM_FROM_ASHA, suspectedSamCount);
            hashMap.put(NotificationConstants.CMAM_FOR_CONFIRMED_MAM, cmamForConfirmedMamCount);
            hashMap.put(NotificationConstants.CMAM_FOR_CONFIRMED_SAM, cmamForConfirmedSamCount);
            hashMap.put(NotificationConstants.CMAM_FOLLOWUP, cmamFollowUpCount);
            hashMap.put(FormConstants.FHW_MONTHLY_SAM_SCREENING, cmamCompletionSamScreeningCount);

            return hashMap;

        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }

        return new HashMap<>();
    }
}
