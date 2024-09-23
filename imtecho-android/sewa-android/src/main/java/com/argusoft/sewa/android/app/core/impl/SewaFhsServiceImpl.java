/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.sewa.android.app.core.impl;

import android.content.Context;

import com.argusoft.sewa.android.app.constants.FhsConstants;
import com.argusoft.sewa.android.app.constants.FieldNameConstants;
import com.argusoft.sewa.android.app.constants.LabelConstants;
import com.argusoft.sewa.android.app.constants.RchConstants;
import com.argusoft.sewa.android.app.constants.RelatedPropertyNameConstants;
import com.argusoft.sewa.android.app.core.SewaFhsService;
import com.argusoft.sewa.android.app.databean.FamilyDataBean;
import com.argusoft.sewa.android.app.databean.FieldValueMobDataBean;
import com.argusoft.sewa.android.app.databean.LocationDetailDataBean;
import com.argusoft.sewa.android.app.databean.MemberDataBean;
import com.argusoft.sewa.android.app.databean.NotificationMobDataBean;
import com.argusoft.sewa.android.app.databean.RchVillageProfileDataBean;
import com.argusoft.sewa.android.app.databean.WorkerDetailDataBean;
import com.argusoft.sewa.android.app.db.DBConnection;
import com.argusoft.sewa.android.app.model.AnnouncementBean;
import com.argusoft.sewa.android.app.model.AnswerBean;
import com.argusoft.sewa.android.app.model.FamilyAvailabilityBean;
import com.argusoft.sewa.android.app.model.FamilyBean;
import com.argusoft.sewa.android.app.model.FhwServiceDetailBean;
import com.argusoft.sewa.android.app.model.LabelBean;
import com.argusoft.sewa.android.app.model.ListValueBean;
import com.argusoft.sewa.android.app.model.LocationBean;
import com.argusoft.sewa.android.app.model.LocationMasterBean;
import com.argusoft.sewa.android.app.model.LoggerBean;
import com.argusoft.sewa.android.app.model.LoginBean;
import com.argusoft.sewa.android.app.model.MemberBean;
import com.argusoft.sewa.android.app.model.MemberPregnancyStatusBean;
import com.argusoft.sewa.android.app.model.MergedFamiliesBean;
import com.argusoft.sewa.android.app.model.MigratedMembersBean;
import com.argusoft.sewa.android.app.model.NotificationBean;
import com.argusoft.sewa.android.app.model.QuestionBean;
import com.argusoft.sewa.android.app.model.RchVillageProfileBean;
import com.argusoft.sewa.android.app.model.ReadNotificationsBean;
import com.argusoft.sewa.android.app.model.VersionBean;
import com.argusoft.sewa.android.app.restclient.RestHttpException;
import com.argusoft.sewa.android.app.transformer.SewaTransformer;
import com.argusoft.sewa.android.app.util.GlobalTypes;
import com.argusoft.sewa.android.app.util.Log;
import com.argusoft.sewa.android.app.util.UtilBean;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.stmt.DeleteBuilder;
import com.j256.ormlite.stmt.QueryBuilder;
import com.j256.ormlite.stmt.Where;

import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.EBean;
import org.androidannotations.annotations.RootContext;
import org.androidannotations.ormlite.annotations.OrmLiteDao;

import java.lang.reflect.Type;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

/**
 * @author kunjan
 */
@EBean(scope = EBean.Scope.Singleton)
public class SewaFhsServiceImpl implements SewaFhsService {

    private static final String TAG = "SewaFhsServiceImpl";

    @Bean
    SewaServiceRestClientImpl sewaServiceRestClient;
    @Bean
    SewaServiceImpl sewaService;

    @RootContext
    Context context;

    @OrmLiteDao(helper = DBConnection.class)
    Dao<FamilyBean, Integer> familyBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<MemberBean, Integer> memberBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<LocationBean, Integer> locationBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<FhwServiceDetailBean, Integer> fhwServiceDetailBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<VersionBean, Integer> versionBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<MergedFamiliesBean, Integer> mergedFamiliesBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<LoggerBean, Integer> loggerBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<NotificationBean, Integer> notificationBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<QuestionBean, Integer> questionBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<AnswerBean, Integer> answerBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<LabelBean, Integer> labelBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<LoginBean, Integer> loginBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<ListValueBean, Integer> listValueBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<AnnouncementBean, Integer> announcementBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<RchVillageProfileBean, Integer> rchVillageProfileBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<LocationMasterBean, Integer> locationMasterBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<MigratedMembersBean, Integer> migratedMembersBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<ReadNotificationsBean, Integer> readNotificationsBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<MemberPregnancyStatusBean, Integer> memberPregnancyStatusBeanDao;

    @OrmLiteDao(helper = DBConnection.class)
    Dao<FamilyAvailabilityBean, Integer> familyAvailabilityBeanDao;

    @Override
    public List<FamilyAvailabilityBean> retrieveLockedFamilyDataBeansByVillage(String locationId, long limit, long offset) {
        List<FamilyAvailabilityBean> familyDataBeans = new ArrayList<>();

        try {
            Where<FamilyAvailabilityBean, Integer> familyWhere = familyAvailabilityBeanDao.queryBuilder()
                    .limit(limit).offset(offset)
                    .where();
            familyWhere.and(
                    familyWhere.eq(FieldNameConstants.LOCATION_ID, locationId),
                    familyWhere.isNull(FieldNameConstants.FAMILY_ID),
                    familyWhere.or(
                            familyWhere.eq(FieldNameConstants.AVAILABILITY_STATUS, FhsConstants.FAMILY_TEMP_LOCKED),
                            familyWhere.eq(FieldNameConstants.AVAILABILITY_STATUS, FhsConstants.FAMILY_PERM_LOCKED)
                    )
            );
            familyDataBeans.addAll(familyWhere.query());
        } catch (Exception ex) {
            Log.e(TAG, null, ex);
        }
        return familyDataBeans;
    }

    @Override
    public List<FamilyAvailabilityBean> searchLockedFamilyDataBeansByVillage(String search, String locationId, long limit, long offset) {
        List<FamilyAvailabilityBean> familyDataBeans = new ArrayList<>();

        try {
            Where<FamilyAvailabilityBean, Integer> where = familyAvailabilityBeanDao.queryBuilder().limit(limit).offset(offset)
                    .where();
            where.and(
                    where.eq(FieldNameConstants.LOCATION_ID, locationId),
                    where.or(
                            where.like(RelatedPropertyNameConstants.HOUSE_NUMBER, "%" + search + "%"),
                            where.like(RelatedPropertyNameConstants.ADDRESS_1, "%" + search + "%"),
                            where.like(RelatedPropertyNameConstants.ADDRESS_2, "%" + search + "%")
                    ),
                    where.isNull(FieldNameConstants.FAMILY_ID),
                    where.or(
                            where.eq(FieldNameConstants.AVAILABILITY_STATUS, FhsConstants.FAMILY_TEMP_LOCKED),
                            where.eq(FieldNameConstants.AVAILABILITY_STATUS, FhsConstants.FAMILY_PERM_LOCKED)
                    )
            );
            familyDataBeans.addAll(where.query());
        } catch (Exception ex) {
            Log.e(TAG, null, ex);
        }
        return familyDataBeans;
    }

    public List<FamilyDataBean> retrieveFamilyDataBeansForCFHC(String locationId, boolean isReverification, long limit, long offset) {
        List<FamilyDataBean> familyDataBeans = new ArrayList<>();

        List<String> verifiedFamilyStates = new ArrayList<>();
        verifiedFamilyStates.addAll(FhsConstants.FHS_VERIFIED_CRITERIA_FAMILY_STATES);
        verifiedFamilyStates.addAll(FhsConstants.FHS_NEW_CRITERIA_FAMILY_STATES);
        verifiedFamilyStates.add(FhsConstants.FHS_FAMILY_STATE_UNVERIFIED);
        verifiedFamilyStates.add(FhsConstants.FHS_FAMILY_STATE_ORPHAN);

        try {
            List<FamilyBean> familyBeans = new ArrayList<>();
            if (isReverification) {
                familyBeans.addAll(familyBeanDao.queryBuilder().limit(limit).offset(offset)
                        .selectColumns(FieldNameConstants.FAMILY_ID, FieldNameConstants.STATE)
                        .where().eq(FieldNameConstants.AREA_ID, locationId)
                        .and().in(FieldNameConstants.STATE, FhsConstants.CFHC_IN_REVERIFICATION_FAMILY_STATES)
                        .query());
            } else {
                QueryBuilder<MemberBean, Integer> memberQB = memberBeanDao.queryBuilder();
                memberQB.where().notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES);
                familyBeans.addAll(familyBeanDao.queryBuilder()
                        .join(FieldNameConstants.FAMILY_ID, FieldNameConstants.FAMILY_ID, memberQB)
                        .limit(limit).offset(offset).selectColumns(FieldNameConstants.FAMILY_ID, FieldNameConstants.STATE).distinct()
                        .orderBy(FieldNameConstants.UPDATED_ON, true)
                        .where().eq(FieldNameConstants.AREA_ID, locationId)
                        .and().in(FieldNameConstants.STATE, verifiedFamilyStates).query());
            }

            for (FamilyBean bean : familyBeans) {
                familyDataBeans.add(new FamilyDataBean(bean, retrieveMemberDataBeansByFamily(bean.getFamilyId())));
            }
        } catch (Exception ex) {
            Log.e(TAG, null, ex);
        }
        return familyDataBeans;
    }

    @Override
    public List<FamilyDataBean> retrieveFamilyDataBeansForCFHCByVillage(String locationId, boolean isReverification, long limit, long offset) {
        List<FamilyDataBean> familyDataBeans = new ArrayList<>();

        List<String> verifiedFamilyStates = new ArrayList<>();
        verifiedFamilyStates.addAll(FhsConstants.FHS_VERIFIED_CRITERIA_FAMILY_STATES);
        verifiedFamilyStates.addAll(FhsConstants.FHS_NEW_CRITERIA_FAMILY_STATES);
        verifiedFamilyStates.add(FhsConstants.FHS_FAMILY_STATE_UNVERIFIED);
        verifiedFamilyStates.add(FhsConstants.FHS_FAMILY_STATE_ORPHAN);
        verifiedFamilyStates.removeAll(FhsConstants.CFHC_FAMILY_STATES);

        try {
            List<FamilyBean> familyBeans = new ArrayList<>();
            if (isReverification) {
                familyBeans.addAll(familyBeanDao.queryBuilder().limit(limit).offset(offset)
                        .selectColumns(FieldNameConstants.FAMILY_ID, FieldNameConstants.STATE)
                        .where().eq(FieldNameConstants.AREA_ID, locationId)
                        .and().in(FieldNameConstants.STATE, FhsConstants.CFHC_IN_REVERIFICATION_FAMILY_STATES)
                        .query());
            } else {
                QueryBuilder<MemberBean, Integer> memberQB = memberBeanDao.queryBuilder();
                memberQB.where().notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES);
                familyBeans.addAll(familyBeanDao.queryBuilder()
                        .join(FieldNameConstants.FAMILY_ID, FieldNameConstants.FAMILY_ID, memberQB)
                        .limit(limit).offset(offset).selectColumns(FieldNameConstants.FAMILY_ID, FieldNameConstants.STATE).distinct()
                        .orderBy(FieldNameConstants.UPDATED_ON, true)
                        .where().eq(FieldNameConstants.AREA_ID, locationId)
                        .and().in(FieldNameConstants.STATE, verifiedFamilyStates).query());
            }

            for (FamilyBean bean : familyBeans) {
                familyDataBeans.add(new FamilyDataBean(bean, retrieveMemberDataBeansByFamily(bean.getFamilyId())));
            }
        } catch (Exception ex) {
            Log.e(TAG, null, ex);
        }
        return familyDataBeans;
    }

    @Override
    public List<FamilyDataBean> searchFamilyDataBeansForCFHCByVillage(String search, String locationId, boolean isReverification,
                                                                      LinkedHashMap<String, String> qrData) {
        List<FamilyDataBean> familyDataBeans = new ArrayList<>();

        List<String> verifiedFamilyStates = new ArrayList<>();
        verifiedFamilyStates.addAll(FhsConstants.FHS_VERIFIED_CRITERIA_FAMILY_STATES);
        verifiedFamilyStates.addAll(FhsConstants.FHS_NEW_CRITERIA_FAMILY_STATES);
        verifiedFamilyStates.add(FhsConstants.FHS_FAMILY_STATE_UNVERIFIED);
        verifiedFamilyStates.add(FhsConstants.FHS_FAMILY_STATE_ORPHAN);
        if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                qrData.containsKey(FieldNameConstants.FAMILY_ID))
            search = qrData.get(FieldNameConstants.FAMILY_ID);
        try {
            Set<FamilyBean> familyBeans = new HashSet<>();

            //Fetching families based on search string (familyId)
            if (isReverification) {
                Where<FamilyBean, Integer> where = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID, FieldNameConstants.STATE)
                        .where();
                where.and(
                        where.like(FieldNameConstants.FAMILY_ID, "%" + search + "%"),
                        where.or(
                                where.eq(FieldNameConstants.AREA_ID, locationId),
                                where.eq(FieldNameConstants.LOCATION_ID, locationId)
                        ),
                        where.in(FieldNameConstants.STATE, FhsConstants.CFHC_IN_REVERIFICATION_FAMILY_STATES)
                );
                familyBeans.addAll(new ArrayList<>(where.query()));
            } else {
                List<String> familyIds = new ArrayList<>();
                Where<FamilyBean, Integer> where = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID, FieldNameConstants.STATE)
                        .where();
                where.and(
                        where.or(
                                where.eq(FieldNameConstants.AREA_ID, locationId),
                                where.eq(FieldNameConstants.LOCATION_ID, locationId)
                        ),
                        where.in(FieldNameConstants.STATE, verifiedFamilyStates)
                );
                for (FamilyBean familyBean : where.query()) {
                    familyIds.add(familyBean.getFamilyId());
                }

                // Search By familyId
                where = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID, FieldNameConstants.STATE)
                        .where();
                where.and(
                        where.like(FieldNameConstants.FAMILY_ID, "%" + search + "%"),
                        where.or(
                                where.eq(FieldNameConstants.AREA_ID, locationId),
                                where.eq(FieldNameConstants.LOCATION_ID, locationId)
                        ),
                        where.in(FieldNameConstants.STATE, verifiedFamilyStates)
                );
                List<FamilyBean> familyBeansBySearch = where.query();

                familyBeansBySearch.addAll(familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID)
                        .where().like(FieldNameConstants.ADDRESS, "%" + search + "%")
                        .and().notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_FAMILY_STATES)
                        .and().in(FieldNameConstants.FAMILY_ID, familyIds).query());

                // Search By Member uniqueHealthId
                Set<MemberBean> memberBeansBySearch = new HashSet<>();
                memberBeansBySearch.addAll(memberBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID)
                        .where().like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + search + "%")
                        .and().notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES)
                        .and().in(FieldNameConstants.FAMILY_ID, familyIds).query());

                // Search By Member firstName
                memberBeansBySearch.addAll(memberBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID)
                        .where().like(FieldNameConstants.FIRST_NAME, "%" + search + "%")
                        .and().notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES)
                        .and().in(FieldNameConstants.FAMILY_ID, familyIds).query());

                // Search By Member middleName
                memberBeansBySearch.addAll(memberBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID)
                        .where().like(FieldNameConstants.MIDDLE_NAME, "%" + search + "%")
                        .and().notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES)
                        .and().in(FieldNameConstants.FAMILY_ID, familyIds).query());

                // Search By Member lastName
                memberBeansBySearch.addAll(memberBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID)
                        .where().like(FieldNameConstants.LAST_NAME, "%" + search + "%")
                        .and().notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES)
                        .and().in(FieldNameConstants.FAMILY_ID, familyIds).query());

                // Search By NRC
                memberBeansBySearch.addAll(memberBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID)
                        .where().like(FieldNameConstants.NRC_NUMBER, "%" + search + "%")
                        .and().notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES)
                        .and().in(FieldNameConstants.FAMILY_ID, familyIds).query());


                // Search By Member mobileNumber
                memberBeansBySearch.addAll(memberBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID)
                        .where().like(FieldNameConstants.MOBILE_NUMBER, "%" + search + "%")
                        .and().notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES)
                        .and().in(FieldNameConstants.FAMILY_ID, familyIds).query());

                memberBeansBySearch.addAll(memberBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID)
                        .where().like(FieldNameConstants.SEARCH_STRING, "%" + search + "%")
                        .and().notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES)
                        .and().in(FieldNameConstants.FAMILY_ID, familyIds).query());

                List<String> familyIdsBySearch = new ArrayList<>();
                for (FamilyBean familyBean : familyBeansBySearch) {
                    familyIdsBySearch.add(familyBean.getFamilyId());
                }

                for (MemberBean memberBean : memberBeansBySearch) {
                    if (!familyIdsBySearch.contains(memberBean.getFamilyId())) {
                        familyIdsBySearch.add(memberBean.getFamilyId());
                    }
                }

                where = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID, FieldNameConstants.STATE)
                        .where();
                where.and(
                        where.in(FieldNameConstants.FAMILY_ID, familyIdsBySearch),
                        where.or(
                                where.eq(FieldNameConstants.AREA_ID, locationId),
                                where.eq(FieldNameConstants.LOCATION_ID, locationId)
                        )
                );
                familyBeans.addAll(where.query());
            }

            for (FamilyBean aFamily : familyBeans) {
                familyDataBeans.add(new FamilyDataBean(aFamily, retrieveMemberDataBeansByFamily(aFamily.getFamilyId())));
            }

        } catch (Exception ex) {
            Log.e(TAG, null, ex);
        }
        return familyDataBeans;
    }

    @Override
    public List<FamilyDataBean> searchFamilyDataBeansForCFHCByVillageZambia(String search, String locationId, boolean isReverification,
                                                                            LinkedHashMap<String, String> qrData) {
        List<FamilyDataBean> familyDataBeans = new ArrayList<>();

        List<String> verifiedFamilyStates = new ArrayList<>();
        verifiedFamilyStates.addAll(FhsConstants.FHS_VERIFIED_CRITERIA_FAMILY_STATES);
        verifiedFamilyStates.addAll(FhsConstants.FHS_NEW_CRITERIA_FAMILY_STATES);
        verifiedFamilyStates.add(FhsConstants.FHS_FAMILY_STATE_UNVERIFIED);
        verifiedFamilyStates.add(FhsConstants.FHS_FAMILY_STATE_ORPHAN);
        if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                qrData.containsKey(FieldNameConstants.FAMILY_ID))
            search = qrData.get(FieldNameConstants.FAMILY_ID);
        try {
            Set<FamilyBean> familyBeans = new HashSet<>();

            //Fetching families based on search string (familyId)
            if (isReverification) {
                Where<FamilyBean, Integer> where = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID, FieldNameConstants.UUID, FieldNameConstants.STATE)
                        .where();
                where.and(
                        where.like(FieldNameConstants.FAMILY_ID, "%" + search + "%"),
                        where.or(
                                where.eq(FieldNameConstants.AREA_ID, locationId),
                                where.eq(FieldNameConstants.LOCATION_ID, locationId)
                        ),
                        where.in(FieldNameConstants.STATE, FhsConstants.CFHC_IN_REVERIFICATION_FAMILY_STATES)
                );
                familyBeans.addAll(new ArrayList<>(where.query()));
            } else {
                List<String> familyIds = new ArrayList<>();
                List<String> uuids = new ArrayList<>();
                Where<FamilyBean, Integer> where = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID, FieldNameConstants.UUID, FieldNameConstants.STATE)
                        .where();
                where.and(
                        where.or(
                                where.eq(FieldNameConstants.AREA_ID, locationId),
                                where.eq(FieldNameConstants.LOCATION_ID, locationId)
                        ),
                        where.in(FieldNameConstants.STATE, verifiedFamilyStates)
                );

                for (FamilyBean familyBean : where.query()) {
                    if (familyBean.getFamilyId().contains("TMP")) {
                        uuids.add(familyBean.getUuid());
                    } else {
                        familyIds.add(familyBean.getFamilyId());
                    }
                }

                // Search By familyId
                where = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID, FieldNameConstants.STATE)
                        .where();
                where.and(
                        where.like(FieldNameConstants.FAMILY_ID, "%" + search + "%"),
                        where.or(
                                where.eq(FieldNameConstants.AREA_ID, locationId),
                                where.eq(FieldNameConstants.LOCATION_ID, locationId)
                        ),
                        where.in(FieldNameConstants.STATE, verifiedFamilyStates)

                );
                List<FamilyBean> familyBeansBySearch = where.query();

                Where<FamilyBean, Integer> familyWhere = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID, FieldNameConstants.UUID).where();
                familyBeansBySearch.addAll(
                        familyWhere.and(
                                familyWhere.like(FieldNameConstants.ADDRESS, "%" + search + "%"),
                                familyWhere.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_FAMILY_STATES),
                                familyWhere.or(
                                        familyWhere.in(FieldNameConstants.FAMILY_ID, familyIds),
                                        familyWhere.in(FieldNameConstants.UUID, uuids))
                        ).query());

                // Search By Member uniqueHealthId
                Set<MemberBean> memberBeansBySearch = new HashSet<>();
                Where<MemberBean, Integer> uniqueHealthIdWhere = memberBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID, FieldNameConstants.MEMBERS_FAMILY_UUID, FieldNameConstants.FAMILY_ID).where();
                memberBeansBySearch.addAll(
                        uniqueHealthIdWhere.and(
                                uniqueHealthIdWhere.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + search + "%"),
                                uniqueHealthIdWhere.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES_FOR_ZAMBIA),
                                uniqueHealthIdWhere.or(
                                        uniqueHealthIdWhere.in(FieldNameConstants.FAMILY_ID, familyIds),
                                        uniqueHealthIdWhere.in(FieldNameConstants.MEMBERS_FAMILY_UUID, uuids)
                                )
                        ).query());


                // Search By Member firstName
                Where<MemberBean, Integer> firstNameWhere = memberBeanDao.queryBuilder().selectColumns(FieldNameConstants.FIRST_NAME, FieldNameConstants.MEMBERS_FAMILY_UUID, FieldNameConstants.FAMILY_ID).where();
                memberBeansBySearch.addAll(
                        firstNameWhere.and(
                                firstNameWhere.like(FieldNameConstants.FIRST_NAME, "%" + search + "%"),
                                firstNameWhere.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES_FOR_ZAMBIA),
                                firstNameWhere.or(
                                        firstNameWhere.in(FieldNameConstants.FAMILY_ID, familyIds),
                                        firstNameWhere.in(FieldNameConstants.MEMBERS_FAMILY_UUID, uuids)
                                )
                        ).query());

                // Search By Member middleName
                Where<MemberBean, Integer> middleNameWhere = memberBeanDao.queryBuilder().selectColumns(FieldNameConstants.MIDDLE_NAME, FieldNameConstants.MEMBERS_FAMILY_UUID, FieldNameConstants.FAMILY_ID).where();
                memberBeansBySearch.addAll(middleNameWhere.and(
                        middleNameWhere.like(FieldNameConstants.MIDDLE_NAME, "%" + search + "%"),
                        middleNameWhere.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES_FOR_ZAMBIA),
                        middleNameWhere.or(
                                middleNameWhere.in(FieldNameConstants.FAMILY_ID, familyIds),
                                middleNameWhere.in(FieldNameConstants.MEMBERS_FAMILY_UUID, uuids)
                        )
                ).query());

                // Search By Member lastName
                Where<MemberBean, Integer> lastNameWhere = memberBeanDao.queryBuilder().selectColumns(FieldNameConstants.LAST_NAME, FieldNameConstants.MEMBERS_FAMILY_UUID, FieldNameConstants.FAMILY_ID).where();
                memberBeansBySearch.addAll(lastNameWhere.and(
                        lastNameWhere.like(FieldNameConstants.LAST_NAME, "%" + search + "%"),
                        lastNameWhere.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES_FOR_ZAMBIA),
                        lastNameWhere.or(
                                lastNameWhere.in(FieldNameConstants.FAMILY_ID, familyIds),
                                lastNameWhere.in(FieldNameConstants.MEMBERS_FAMILY_UUID, uuids)
                        )
                ).query());

                // Search By NRC
                Where<MemberBean, Integer> nrcWhere = memberBeanDao.queryBuilder().selectColumns(FieldNameConstants.NRC_NUMBER, FieldNameConstants.MEMBERS_FAMILY_UUID, FieldNameConstants.FAMILY_ID).where();
                memberBeansBySearch.addAll(nrcWhere.and(
                        nrcWhere.like(FieldNameConstants.NRC_NUMBER, "%" + search + "%"),
                        nrcWhere.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES_FOR_ZAMBIA),
                        nrcWhere.or(
                                nrcWhere.in(FieldNameConstants.FAMILY_ID, familyIds),
                                nrcWhere.in(FieldNameConstants.MEMBERS_FAMILY_UUID, uuids)
                        )
                ).query());


                // Search By Member mobileNumber
                Where<MemberBean, Integer> mobWhere = memberBeanDao.queryBuilder().selectColumns(FieldNameConstants.MOBILE_NUMBER, FieldNameConstants.MEMBERS_FAMILY_UUID, FieldNameConstants.FAMILY_ID).where();
                memberBeansBySearch.addAll(mobWhere.and(
                        mobWhere.like(FieldNameConstants.MOBILE_NUMBER, "%" + search + "%"),
                        mobWhere.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES_FOR_ZAMBIA),
                        mobWhere.or(
                                mobWhere.in(FieldNameConstants.FAMILY_ID, familyIds),
                                mobWhere.in(FieldNameConstants.MEMBERS_FAMILY_UUID, uuids)
                        )
                ).query());

                Where<MemberBean, Integer> searchStringWhere = memberBeanDao.queryBuilder().selectColumns(FieldNameConstants.SEARCH_STRING, FieldNameConstants.MEMBERS_FAMILY_UUID, FieldNameConstants.FAMILY_ID).where();
                memberBeansBySearch.addAll(searchStringWhere.and(
                        searchStringWhere.like(FieldNameConstants.SEARCH_STRING, "%" + search + "%"),
                        searchStringWhere.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES_FOR_ZAMBIA),
                        searchStringWhere.or(
                                searchStringWhere.in(FieldNameConstants.FAMILY_ID, familyIds),
                                searchStringWhere.in(FieldNameConstants.MEMBERS_FAMILY_UUID, uuids)
                        )
                ).query());

                List<String> familyIdsBySearch = new ArrayList<>();
                List<String> familyUuidBySearch = new ArrayList<>();
                for (FamilyBean familyBean : familyBeansBySearch) {
                    if (familyBean.getFamilyId() == null) {
                        familyUuidBySearch.add(familyBean.getUuid());
                    }
                }

                for (MemberBean memberBean : memberBeansBySearch) {
                    if (!familyIdsBySearch.contains(memberBean.getFamilyId())) {
                        if (memberBean.getFamilyId() != null) {
                            familyIdsBySearch.add(memberBean.getFamilyId());
                        }
                    }
                    if (!familyUuidBySearch.contains(memberBean.getFamilyUuid())) {
                        if (memberBean.getFamilyUuid() != null) {
                            familyUuidBySearch.add(memberBean.getFamilyUuid());
                        }
                    }
                }

                where = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID, FieldNameConstants.UUID, FieldNameConstants.STATE)
                        .where();
                where.and(
                        where.or(
                                where.in(FieldNameConstants.FAMILY_ID, familyIdsBySearch),
                                where.in(FieldNameConstants.UUID, familyUuidBySearch)
                        ),
                        where.or(
                                where.eq(FieldNameConstants.AREA_ID, locationId),
                                where.eq(FieldNameConstants.LOCATION_ID, locationId)
                        )
                );
                familyBeans.addAll(where.query());
            }

            for (FamilyBean aFamily : familyBeans) {
                familyDataBeans.add(new FamilyDataBean(aFamily, retrieveMemberDataBeansByFamily(aFamily.getFamilyId())));
            }

        } catch (Exception ex) {
            Log.e(TAG, null, ex);
        }
        return familyDataBeans;
    }

    public List<FamilyDataBean> retrieveFamilyDataBeansForMergeFamily(String locationId, String search, long limit, long offset, LinkedHashMap<String, String> qrData) {
        List<String> verifiedFamilyStates = new ArrayList<>();
        verifiedFamilyStates.addAll(FhsConstants.FHS_VERIFIED_CRITERIA_FAMILY_STATES);
        verifiedFamilyStates.addAll(FhsConstants.FHS_NEW_CRITERIA_FAMILY_STATES);
        verifiedFamilyStates.add(FhsConstants.FHS_FAMILY_STATE_UNVERIFIED);
        verifiedFamilyStates.add(FhsConstants.FHS_FAMILY_STATE_ORPHAN);
        verifiedFamilyStates.addAll(FhsConstants.CFHC_IN_REVERIFICATION_FAMILY_STATES);

        if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                qrData.containsKey(FieldNameConstants.FAMILY_ID))
            search = qrData.get(FieldNameConstants.FAMILY_ID);

        try {
            QueryBuilder<MemberBean, Integer> memberQB = memberBeanDao.queryBuilder();
            memberQB.where().notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES);
            Where<FamilyBean, Integer> where = familyBeanDao.queryBuilder()
                    .join(FieldNameConstants.FAMILY_ID, FieldNameConstants.FAMILY_ID, memberQB)
                    .limit(limit).offset(offset).selectColumns(FieldNameConstants.FAMILY_ID, FieldNameConstants.STATE).distinct()
                    .orderBy(FieldNameConstants.UPDATED_ON, true)
                    .where().eq(FieldNameConstants.LOCATION_ID, locationId)
                    .and().in(FieldNameConstants.STATE, verifiedFamilyStates);

            if (search != null && !search.isEmpty()) {
                where = where.and().like(FieldNameConstants.FAMILY_ID, "%" + search + "%");
            }

            List<FamilyBean> query = where.query();
            List<FamilyDataBean> familyDataBeans = new ArrayList<>();
            ArrayList<MemberDataBean> memberDataBeans = new ArrayList<>();
            for (FamilyBean bean : query) {
                familyDataBeans.add(new FamilyDataBean(bean, memberDataBeans));
            }
            return familyDataBeans;
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return new ArrayList<>();
    }

    @Override
    public List<FamilyDataBean> retrieveFamilyDataBeansForFHSByArea(Long areaId, long limit, long offset) {
        List<FamilyDataBean> familyDataBeans = new ArrayList<>();

        List<String> verifiedFamilyStates = new ArrayList<>(FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES);
        verifiedFamilyStates.remove(FhsConstants.FHS_FAMILY_STATE_TEMPORARY);

        try {
            QueryBuilder<MemberBean, Integer> memberQB = memberBeanDao.queryBuilder();
            memberQB.where().notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES);
            List<FamilyBean> familyBeans = familyBeanDao.queryBuilder()
                    .join(FieldNameConstants.FAMILY_ID, FieldNameConstants.FAMILY_ID, memberQB)
                    .limit(limit).offset(offset).selectColumns(FieldNameConstants.FAMILY_ID, FieldNameConstants.STATE).distinct()
                    .orderBy(FieldNameConstants.UPDATED_ON, true)
                    .where().eq(FieldNameConstants.AREA_ID, areaId)
                    .and().in(FieldNameConstants.STATE, verifiedFamilyStates).query();

            ArrayList<MemberDataBean> memberDataBeans = new ArrayList<>();
            for (FamilyBean bean : familyBeans) {
                familyDataBeans.add(new FamilyDataBean(bean, memberDataBeans));
            }
        } catch (Exception ex) {
            Log.e(TAG, null, ex);
        }
        return familyDataBeans;
    }

    @Override
    public List<FamilyDataBean> searchFamilyDataBeansForFHSByArea(Long areaId, String search, LinkedHashMap<String, String> qrData) {
        List<FamilyDataBean> familyDataBeans = new ArrayList<>();

        List<String> validFamilyStates = new ArrayList<>(FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES);
        validFamilyStates.remove(FhsConstants.FHS_FAMILY_STATE_TEMPORARY);

        try {
            //Fetching families based on search string (familyId)
            List<String> familyIds = new ArrayList<>();
            for (FamilyBean familyBean : familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID)
                    .where().eq(FieldNameConstants.AREA_ID, areaId)
                    .and().in(FieldNameConstants.STATE, validFamilyStates).query()) {
                familyIds.add(familyBean.getFamilyId());
            }

            // Search By familyId
            if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") && qrData.containsKey(FieldNameConstants.FAMILY_ID))
                search = qrData.get(FieldNameConstants.FAMILY_ID);
            List<FamilyBean> familyBeansBySearch = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID)
                    .where().like(FieldNameConstants.FAMILY_ID, "%" + search + "%")
                    .and().eq(FieldNameConstants.AREA_ID, areaId)
                    .and().in(FieldNameConstants.STATE, validFamilyStates).query();

            // Search By Member uniqueHealthId
            Set<MemberBean> memberBeansBySearch = new HashSet<>();
            memberBeansBySearch.addAll(memberBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID)
                    .where().like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + search + "%")
                    .and().notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES)
                    .and().in(FieldNameConstants.FAMILY_ID, familyIds).query());

            // Search By Member firstName
            memberBeansBySearch.addAll(memberBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID)
                    .where().like(FieldNameConstants.FIRST_NAME, "%" + search + "%")
                    .and().notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES)
                    .and().in(FieldNameConstants.FAMILY_ID, familyIds).query());

            // Search By Member mobileNumber
            memberBeansBySearch.addAll(memberBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID)
                    .where().like(FieldNameConstants.MOBILE_NUMBER, "%" + search + "%")
                    .and().notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES)
                    .and().in(FieldNameConstants.FAMILY_ID, familyIds).query());

            List<String> familyIdsBySearch = new ArrayList<>();
            for (FamilyBean familyBean : familyBeansBySearch) {
                familyIdsBySearch.add(familyBean.getFamilyId());
            }

            for (MemberBean memberBean : memberBeansBySearch) {
                if (!familyIdsBySearch.contains(memberBean.getFamilyId())) {
                    familyIdsBySearch.add(memberBean.getFamilyId());
                }
            }

            List<FamilyBean> familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID, FieldNameConstants.STATE)
                    .where().in(FieldNameConstants.FAMILY_ID, familyIdsBySearch)
                    .and().eq(FieldNameConstants.AREA_ID, areaId).query();

            ArrayList<MemberDataBean> memberDataBeans = new ArrayList<>();
            for (FamilyBean aFamily : familyBeans) {
                familyDataBeans.add(new FamilyDataBean(aFamily, memberDataBeans));
            }

        } catch (Exception ex) {
            Log.e(TAG, null, ex);
        }
        return familyDataBeans;
    }

    @Override
    public List<MemberDataBean> retrieveMemberDataBeansForDnhddAnemiaByFamilyId(String familyId) {
        List<MemberDataBean> memberDataBeans = new ArrayList<>();
        Calendar instance = Calendar.getInstance();
        instance.add(Calendar.MONTH, -6);
        Date sixMonthBefore = instance.getTime();

        instance.add(Calendar.MONTH, 6);
        instance.add(Calendar.YEAR, -49);
        Date fourtyNineYrBefore = instance.getTime();

        instance.add(Calendar.YEAR, 30);
        Date nineteenYrBefore = instance.getTime();

        try {
            List<MemberBean> memberBeans = new ArrayList<>(memberBeanDao.queryBuilder()
                    .orderBy(FieldNameConstants.FAMILY_HEAD_FLAG, Boolean.FALSE)
                    .where().eq(FieldNameConstants.FAMILY_ID, familyId)
                    .and().le(FieldNameConstants.DOB, sixMonthBefore)
                    .and().ge(FieldNameConstants.DOB, fourtyNineYrBefore).query());

            if (!memberBeans.isEmpty()) {
                for (MemberBean bean : memberBeans) {
                    if (!(bean.getGender() != null && bean.getGender().equalsIgnoreCase(GlobalTypes.MALE)
                            && bean.getDob().before(nineteenYrBefore)))
                        memberDataBeans.add(new MemberDataBean(bean));
                }
            }

        } catch (SQLException ex) {
            Log.e(TAG, null, ex);
        }
        return memberDataBeans;
    }

    @Override
    public List<MemberDataBean> retrieveMemberDataBeansByFamily(String familyId) {
        List<MemberDataBean> memberDataBeans = new ArrayList<>();
        try {
            List<MemberBean> memberBeans = new ArrayList<>(memberBeanDao.queryBuilder()
                    .orderBy(FieldNameConstants.FAMILY_HEAD_FLAG, Boolean.FALSE)
                    .where().eq(FieldNameConstants.FAMILY_ID, familyId).query());
            for (MemberBean bean : memberBeans) {
                memberDataBeans.add(new MemberDataBean(bean));
            }
        } catch (SQLException ex) {
            Log.e(TAG, null, ex);
        }
        return memberDataBeans;
    }

    @Override
    public List<MemberDataBean> retrieveMembersWithin150mOfActiveMalariaCases(String locationId, String lat, String lng) {
        List<MemberDataBean> memberDataBeans = new ArrayList<>();
        List<String> familyIds = new ArrayList<>();
        try {
            QueryBuilder<MemberBean, Integer> memberQB = memberBeanDao.queryBuilder();
            Where<MemberBean, Integer> where = memberBeanDao.queryBuilder().where();
            where.and(
                    where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                    where.or(
                            where.isNull(FieldNameConstants.RDT_STATUS),
                            where.ne(FieldNameConstants.RDT_STATUS, RchConstants.TEST_POSITIVE)
                    )
            ).query();

            List<FamilyBean> familyBeans = new ArrayList<>(familyBeanDao.queryBuilder()
                    .join(FieldNameConstants.FAMILY_ID, FieldNameConstants.FAMILY_ID, memberQB)
                    .selectColumns(FieldNameConstants.FAMILY_ID,
                            FieldNameConstants.STATE,
                            FieldNameConstants.LATITUDE,
                            FieldNameConstants.LONGITUDE,
                            FieldNameConstants.AREA_ID)
                    .where().eq(FieldNameConstants.AREA_ID, locationId)
                    .and().notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_FAMILY_STATES).query());

            for (FamilyBean bean : familyBeans) {
                double distance = calculateDistance(Double.parseDouble(lat), Double.parseDouble(lng),
                        Double.parseDouble(bean.getLatitude()), Double.parseDouble(bean.getLongitude()));
                if (distance <= (double) 150) {
                    if (!familyIds.contains(bean.getFamilyId())) {
                        memberDataBeans.addAll(retrieveMemberDataBeansByFamily(bean.getFamilyId()));
                        familyIds.add(bean.getFamilyId());
                    }
                }
            }
        } catch (Exception ex) {
            Log.e(TAG, null, ex);
        }
        return memberDataBeans;
    }

    public static double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
        double R = 6371000; // Earth radius in meters

        double dLat = Math.toRadians(lat2 - lat1);
        double dLng = Math.toRadians(lng2 - lng1);

        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
                Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2)) *
                        Math.sin(dLng / 2) * Math.sin(dLng / 2);

        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

        return R * c;
    }

    @Override
    public FamilyDataBean retrieveFamilyDataBeanByFamilyId(String familyId) {
        try {
            FamilyBean familyBean = familyBeanDao.queryBuilder().where().eq(FieldNameConstants.FAMILY_ID, familyId).queryForFirst();
            ArrayList<MemberDataBean> memberDataBeans = new ArrayList<>();
            return new FamilyDataBean(familyBean, memberDataBeans);
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return null;
    }

    @Override
    public FamilyDataBean retrieveFamilyDataBeanByFamilyId(Long actualId) {
        try {
            FamilyBean familyBean = familyBeanDao.queryBuilder().where().eq(FieldNameConstants.ACTUAL_I_D, actualId).queryForFirst();
            ArrayList<MemberDataBean> memberDataBeans = new ArrayList<>();
            return new FamilyDataBean(familyBean, memberDataBeans);
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return null;
    }

    @Override
    public void markFamilyAsVerified(String familyId) {
        try {
            List<FamilyBean> family = familyBeanDao.queryForEq(FieldNameConstants.FAMILY_ID, familyId);
            FamilyBean familyBean = family.get(0);
            familyBean.setIsVerifiedFlag(Boolean.TRUE);
            familyBean.setReverificationFlag(Boolean.FALSE);
            familyBean.setState(FhsConstants.FHS_FAMILY_STATE_VERIFIED);
            familyBeanDao.update(familyBean);
        } catch (SQLException ex) {
            Log.e(TAG, null, ex);
        }

    }

    @Override
    public void markFamilyAsCFHCVerified(String familyId) {
        try {
            List<FamilyBean> family = familyBeanDao.queryForEq(FieldNameConstants.FAMILY_ID, familyId);
            FamilyBean familyBean = family.get(0);
            familyBean.setIsVerifiedFlag(Boolean.TRUE);
            familyBean.setReverificationFlag(Boolean.FALSE);
            familyBean.setState(FhsConstants.CFHC_FAMILY_STATE_VERIFIED_LOCAL);
            familyBeanDao.update(familyBean);
        } catch (SQLException ex) {
            Log.e(TAG, null, ex);
        }
    }

    @Override
    public void markFamilyAsMigrated(String familyId) {
        try {
            List<FamilyBean> family = familyBeanDao.queryForEq(FieldNameConstants.FAMILY_ID, familyId);
            FamilyBean familyBean = family.get(0);
            familyBean.setIsVerifiedFlag(Boolean.TRUE);
            familyBean.setReverificationFlag(Boolean.FALSE);
            familyBean.setState(FhsConstants.FHS_FAMILY_STATE_MIGRATED);
            familyBeanDao.update(familyBean);
        } catch (SQLException ex) {
            Log.e(TAG, null, ex);
        }

    }

    @Override
    public void markFamilyAsArchived(String familyId) {
        try {
            List<FamilyBean> family = familyBeanDao.queryForEq(FieldNameConstants.FAMILY_ID, familyId);
            FamilyBean familyBean = family.get(0);
            familyBean.setIsVerifiedFlag(Boolean.TRUE);
            familyBean.setReverificationFlag(Boolean.FALSE);
            familyBean.setState(FhsConstants.FHS_FAMILY_STATE_ARCHIVED);
            familyBeanDao.update(familyBean);
        } catch (SQLException ex) {
            Log.e(TAG, null, ex);
        }

    }

    @Override
    public List<LocationBean> getDistinctLocationsAssignedToUser() {
        if (SewaTransformer.loginBean.getVillageCode() == null || SewaTransformer.loginBean.getVillageCode().isEmpty()) {
            return new ArrayList<>();
        }
        List<Integer> locationIdsAssignedToUser = new ArrayList<>();
        for (String id : SewaTransformer.loginBean.getVillageCode().split(":")) {
            locationIdsAssignedToUser.add(Integer.valueOf(id));
        }
        List<LocationBean> locations = new ArrayList<>();
        try {
            locations = locationBeanDao.queryBuilder().where().in(FieldNameConstants.ACTUAL_I_D, locationIdsAssignedToUser).query(); //all villages
        } catch (SQLException ex) {
            Log.e(TAG, null, ex);
        }
        return locations;
    }

    @Override
    public Map<String, MemberDataBean> retrieveHeadMemberDataBeansByFamilyId(List<String> familyIds) {
        Map<String, MemberDataBean> headMembersMap = new HashMap<>();
        Map<String, List<MemberBean>> mapOfMembersWithFamilyWithoutHeadsIdAsKey = new HashMap<>();
        List<MemberBean> memberBeans;
        List<MemberBean> membersOfFamiliesWithoutHeads;
        Set<String> familyIdsWithoutHead = new HashSet<>();
        try {
            memberBeans = new ArrayList<>(memberBeanDao.queryBuilder()
                    .selectColumns(FieldNameConstants.FAMILY_ID, FieldNameConstants.FIRST_NAME,
                            FieldNameConstants.UNIQUE_HEALTH_ID,
                            FieldNameConstants.MOBILE_NUMBER,
                            FieldNameConstants.MIDDLE_NAME, FieldNameConstants.LAST_NAME,
                            FieldNameConstants.GRAND_FATHER_NAME, FieldNameConstants.MARITAL_STATUS,
                            FieldNameConstants.GENDER,
                            FieldNameConstants.DOB,
                            FieldNameConstants.MOBILE_NUMBER)
                    .where().in(FieldNameConstants.FAMILY_ID, familyIds)
                    .and().eq(FieldNameConstants.FAMILY_HEAD_FLAG, Boolean.TRUE).query());
            for (MemberBean bean : memberBeans) {
                headMembersMap.put(bean.getFamilyId(), new MemberDataBean(bean));
            }

            for (String familyId : familyIds) {
                MemberDataBean get = headMembersMap.get(familyId);
                if (get == null) {
                    familyIdsWithoutHead.add(familyId);
                }
            }
            membersOfFamiliesWithoutHeads = memberBeanDao.queryBuilder()
                    .selectColumns(FieldNameConstants.FAMILY_ID, FieldNameConstants.FIRST_NAME,
                            FieldNameConstants.MIDDLE_NAME, FieldNameConstants.LAST_NAME,
                            FieldNameConstants.UNIQUE_HEALTH_ID,
                            FieldNameConstants.MOBILE_NUMBER,
                            FieldNameConstants.GRAND_FATHER_NAME, FieldNameConstants.MARITAL_STATUS, FieldNameConstants.GENDER, FieldNameConstants.DOB)
                    .where().in(FieldNameConstants.FAMILY_ID, familyIdsWithoutHead).query();
            for (MemberBean memberBean : membersOfFamiliesWithoutHeads) {
                List<MemberBean> members = mapOfMembersWithFamilyWithoutHeadsIdAsKey.get(memberBean.getFamilyId());
                if (members == null) {
                    members = new ArrayList<>();
                    mapOfMembersWithFamilyWithoutHeadsIdAsKey.put(memberBean.getFamilyId(), members);
                }
                members.add(memberBean);
            }

            for (String familyId : familyIds) {
                MemberDataBean head = null;

                if (mapOfMembersWithFamilyWithoutHeadsIdAsKey.get(familyId) == null) {
                    continue;
                }
                //search for any male married member
                List<MemberBean> tmpMemberBeans = mapOfMembersWithFamilyWithoutHeadsIdAsKey.get(familyId);
                if (tmpMemberBeans != null) {
                    for (MemberBean memberBean : tmpMemberBeans) {
                        if (memberBean.getMaritalStatus() != null && memberBean.getMaritalStatus().equals("629")
                                && memberBean.getGender() != null && memberBean.getGender().equals("M")) {
                            head = new MemberDataBean(memberBean);
                        }
                    }

                    //search for any male member
                    if (head == null) {
                        for (MemberBean memberBean : tmpMemberBeans) {
                            if (memberBean.getGender() != null && memberBean.getGender().equals("M")) {
                                head = new MemberDataBean(memberBean);
                            }
                        }
                    }

                    //search for any female member
                    if (head == null) {
                        for (MemberBean memberBean : tmpMemberBeans) {
                            if (memberBean.getGender() != null && memberBean.getGender().equals("F")) {
                                head = new MemberDataBean(memberBean);
                            }
                        }
                    }
                }

                if (head != null) {
                    headMembersMap.put(familyId, head);
                }
            }

        } catch (SQLException ex) {
            Log.e(TAG, null, ex);
        }

        return headMembersMap;
    }

    @Override
    public List<FhwServiceDetailBean> retrieveFhwServiceDetailBeansByVillageId(Integer locationId) {
        if (locationId != null) {
            try {
                return fhwServiceDetailBeanDao.queryBuilder().where().eq(FieldNameConstants.LOCATION_ID, locationId).query();
            } catch (SQLException e) {
                Log.e(TAG, null, e);
            }
        } else {
            try {
                return fhwServiceDetailBeanDao.queryForAll();
            } catch (SQLException e) {
                Log.e(TAG, null, e);
            }
        }
        return new ArrayList<>();
    }

    @Override
    public List<MemberDataBean> retrieveMemberDataBeansExceptArchivedAndDeadByFamilyId(String familyId) {
        List<MemberBean> memberBeans = new ArrayList<>();
        List<MemberDataBean> memberDataBeans = new ArrayList<>();

        try {
            memberBeans = memberBeanDao.queryBuilder().where().eq(FieldNameConstants.FAMILY_ID, familyId)
                    .and().notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES).query();
        } catch (SQLException ex) {
            Log.e(TAG, null, ex);
        }
        for (MemberBean bean : memberBeans) {
            memberDataBeans.add(new MemberDataBean(bean));
        }
        return memberDataBeans;
    }

    @Override
    public List<MemberDataBean> retrieveMemberDataBeansExceptArchivedByFamilyIdForZambia(String familyId) {
        List<MemberBean> memberBeans = new ArrayList<>();
        List<MemberDataBean> memberDataBeans = new ArrayList<>();

        try {
            memberBeans = memberBeanDao.queryBuilder().where().eq(FieldNameConstants.FAMILY_ID, familyId)
                    .and().notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES_FOR_ZAMBIA).query();
        } catch (SQLException ex) {
            Log.e(TAG, null, ex);
        }
        for (MemberBean bean : memberBeans) {
            memberDataBeans.add(new MemberDataBean(bean));
        }
        return memberDataBeans;
    }

    @Override
    public void mergeFamilies(FamilyDataBean familyToBeExpanded, FamilyDataBean familyToBeMerged) {
        try {
            MergedFamiliesBean mergedFamiliesBean = new MergedFamiliesBean(familyToBeMerged.getFamilyId(), familyToBeExpanded.getFamilyId(), false);
            mergedFamiliesBeanDao.create(mergedFamiliesBean);
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
    }

    @Override
    public Map<Long, MemberBean> retrieveMemberBeansMapByActualIds(List<Long> actualIds) {
        Map<Long, MemberBean> mapOfMemberBeans = new HashMap<>();
        try {
            List<String> stringActualIds = new ArrayList<>();
            for (Long actualId : actualIds) {
                stringActualIds.add(actualId.toString());
            }

            List<MemberBean> memberBeans = memberBeanDao.queryBuilder().where().in(FieldNameConstants.ACTUAL_ID, stringActualIds).query();

            for (MemberBean memberBean : memberBeans) {
                mapOfMemberBeans.put(Long.valueOf(memberBean.getActualId()), memberBean);
            }
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return mapOfMemberBeans;
    }

    public List<MemberDataBean> retrieveMemberDataBeansByActualIds(List<Long> actualIds) {
        List<MemberDataBean> memberDataBeans = new ArrayList<>();
        try {
            List<String> stringActualIds = new ArrayList<>();
            for (Long actualId : actualIds) {
                stringActualIds.add(actualId.toString());
            }
            List<MemberBean> memberBeans = memberBeanDao.queryBuilder().where().in(FieldNameConstants.ACTUAL_ID, stringActualIds).query();
            for (MemberBean memberBean : memberBeans) {
                memberDataBeans.add(new MemberDataBean(memberBean));
            }
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return memberDataBeans;
    }

    @Override
    public String assignFamilyToUser(String locationId, FamilyDataBean familyDataBean) {
        try {
            FamilyDataBean familyDataBean1 = sewaServiceRestClient.assignFamilyToUser(locationId, familyDataBean.getFamilyId());
            List<MemberBean> memberBeansToCreate = new ArrayList<>();

            if (familyDataBean1 != null) {
                DeleteBuilder<FamilyBean, Integer> familyBeanDeleteBuilder = familyBeanDao.deleteBuilder();
                familyBeanDeleteBuilder.where().eq(FieldNameConstants.FAMILY_ID, familyDataBean1.getFamilyId());
                familyBeanDeleteBuilder.delete();

                DeleteBuilder<MemberBean, Integer> memberBeanDeleteBuilder = memberBeanDao.deleteBuilder();
                memberBeanDeleteBuilder.where().eq(FieldNameConstants.FAMILY_ID, familyDataBean1.getFamilyId());
                memberBeanDeleteBuilder.delete();

                List<MemberDataBean> memberDataBeans = familyDataBean1.getMembers();
                if (memberDataBeans != null && !memberDataBeans.isEmpty()) {
                    for (MemberDataBean memberDataBean : memberDataBeans) {
                        memberBeansToCreate.add(new MemberBean(memberDataBean));
                    }
                }
                memberBeanDao.create(memberBeansToCreate);
                familyBeanDao.create(new FamilyBean(familyDataBean1));
                return UtilBean.getMyLabel(LabelConstants.FAMILY_ASSIGNED_SUCCESSFULLY);
            }
            return UtilBean.getMyLabel(LabelConstants.NETWORK_ERROR_WHILE_ASSIGNING_FAMILY);
        } catch (RestHttpException e) {
            Log.e(TAG, null, e);
            return UtilBean.getMyLabel(LabelConstants.THERE_WAS_ERROR_ASSIGNING_FAMILY);
        } catch (SQLException e) {
            Log.e(TAG, null, e);
            return UtilBean.getMyLabel(LabelConstants.ERROR_WHILE_STORING_ASSIGNED_FAMILY);
        }
    }

    @Override
    public List<FieldValueMobDataBean> retrieveAnganwadiListFromSubcentreId(Integer subcentreId) {
        List<FieldValueMobDataBean> anganwadisUnderSubcenter = new ArrayList<>();
        List<Integer> listOfVillageIds = new ArrayList<>();
        try {
            List<LocationBean> villageList = locationBeanDao.queryBuilder().where().eq(FieldNameConstants.PARENT, subcentreId).query();
            for (LocationBean village : villageList) {
                listOfVillageIds.add(village.getActualID());
            }
            List<LocationBean> anganwadiList = locationBeanDao.queryBuilder().where().in(FieldNameConstants.PARENT, listOfVillageIds)
                    .and().eq("level", 8).query();
            for (LocationBean locationBean2 : anganwadiList) {
                FieldValueMobDataBean fieldValueMobDataBean = new FieldValueMobDataBean();
                fieldValueMobDataBean.setIdOfValue(locationBean2.getActualID());
                fieldValueMobDataBean.setValue(locationBean2.getName());
                anganwadisUnderSubcenter.add(fieldValueMobDataBean);
            }
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return anganwadisUnderSubcenter;
    }

    @Override
    public Integer retrieveSubcenterIdFromAnganwadiId(Integer anganwadiId) {
        try {
            if (anganwadiId != null) {
                LocationBean anganwadi = locationBeanDao.queryBuilder().where().eq(FieldNameConstants.ACTUAL_I_D, anganwadiId).queryForFirst();
                if (anganwadi != null) {
                    LocationBean village = locationBeanDao.queryBuilder().where().eq(FieldNameConstants.ACTUAL_I_D, anganwadi.getParent()).queryForFirst();
                    if (village != null) {
                        return village.getParent();
                    }
                }
            }
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return null;
    }

    @Override
    public RchVillageProfileDataBean getRchVillageProfileDataBean(String locationId) {
        String aadharNumber = "123456789879";
        String mobileNumber = "9876543210";
        RchVillageProfileDataBean rchVillageProfileDataBean = new RchVillageProfileDataBean();
        LocationDetailDataBean village = new LocationDetailDataBean();
        village.setId(Integer.valueOf(locationId));
        village.setName("ઉનાવા");
        village.setLocType("V");

        WorkerDetailDataBean asha1 = new WorkerDetailDataBean();
        asha1.setName("Anjanaben Patel");
        asha1.setAadharNumber(aadharNumber);
        asha1.setMobileNumber(mobileNumber);
        asha1.setUserId(12345L);

        WorkerDetailDataBean asha2 = new WorkerDetailDataBean();
        asha2.setName("Gitaben Raval");
        asha2.setAadharNumber(aadharNumber);
        asha2.setMobileNumber(mobileNumber);
        asha2.setUserId(12346L);

        WorkerDetailDataBean anm = new WorkerDetailDataBean();
        anm.setName("Lata Solanki");
        anm.setAadharNumber(aadharNumber);
        anm.setMobileNumber(mobileNumber);
        anm.setUserId(12347L);

        WorkerDetailDataBean fhw = new WorkerDetailDataBean();
        fhw.setName("Pritiben Shah");
        fhw.setAadharNumber(aadharNumber);
        fhw.setMobileNumber(mobileNumber);
        fhw.setUserId(12348L);

        WorkerDetailDataBean mphw = new WorkerDetailDataBean();
        mphw.setName("Alpaben Patel");
        mphw.setAadharNumber(aadharNumber);
        mphw.setMobileNumber(mobileNumber);
        mphw.setUserId(12349L);

        rchVillageProfileDataBean.setState(village);
        rchVillageProfileDataBean.setDistrict(village);
        rchVillageProfileDataBean.setBlock(village);
        rchVillageProfileDataBean.setChc(village);
        rchVillageProfileDataBean.setPhc(village);
        rchVillageProfileDataBean.setSubCentre(village);
        rchVillageProfileDataBean.setVillage(village);

        rchVillageProfileDataBean.setTotalPopulation(15000);
        rchVillageProfileDataBean.setTotalEligibleCouple(1000);
        rchVillageProfileDataBean.setPregnantWomenCount(300);
        rchVillageProfileDataBean.setInfantChildCount(500);

        List<WorkerDetailDataBean> ashaList = new ArrayList<>();
        ashaList.add(asha1);
        ashaList.add(asha2);

        rchVillageProfileDataBean.setAshaDetail(ashaList);
        rchVillageProfileDataBean.setAnmDetail(anm);
        rchVillageProfileDataBean.setFhwDetail(fhw);
        rchVillageProfileDataBean.setMphwDetail(mphw);

        rchVillageProfileDataBean.setNearbyHospitalDetail("Civil Hospital, GH Road, Sector-12, Gandhinagar 7923221931");
        rchVillageProfileDataBean.setFruDetail("FRU Details 7878564234");
        rchVillageProfileDataBean.setAmbulanceNumber("8965465465");
        rchVillageProfileDataBean.setTransportationNumber("9594852316");
        rchVillageProfileDataBean.setNationalCallCentreNumber("9876854612");
        rchVillageProfileDataBean.setHelplineNumber("7965481236");

        return rchVillageProfileDataBean;

    }

    @Override
    public List<LocationBean> retrieveAshaAreaAssignedToUser(Integer villageId) {
        List<LocationBean> ashaAreaList = new ArrayList<>();
        try {
            ashaAreaList = locationBeanDao.queryBuilder().where().eq(FieldNameConstants.LEVEL, 7)
                    .and().eq(FieldNameConstants.PARENT, villageId).query();
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return ashaAreaList;
    }

    @Override
    public List<MemberDataBean> retrieveEligibleCouplesByAshaArea(List<Integer> locationIds, Integer villageId, CharSequence searchString, long limit, long offset,
                                                                  LinkedHashMap<String, String> qrData) {
        List<MemberDataBean> memberDataBeans = new ArrayList<>();

        try {
            List<String> familyIds = new ArrayList<>();
            List<FamilyBean> familyBeans;

            if (locationIds != null && !locationIds.isEmpty()) {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .in(FieldNameConstants.AREA_ID, locationIds)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            } else {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .eq(FieldNameConstants.LOCATION_ID, villageId)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            }

            for (FamilyBean familyBean : familyBeans) {
                familyIds.add(familyBean.getFamilyId());
            }

            if (!familyIds.isEmpty()) {
                List<MemberBean> memberBeans;
                Calendar calendar = Calendar.getInstance();
                calendar.add(Calendar.YEAR, -15);
                Date dateBefore18Years = calendar.getTime();
                calendar.add(Calendar.YEAR, -34);
                Date dateBefore45Years = calendar.getTime();
                Where<MemberBean, Integer> where = memberBeanDao.queryBuilder().limit(limit).offset(offset).where();
                if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                        qrData.containsKey(FieldNameConstants.FAMILY_ID))
                    searchString = qrData.get(FieldNameConstants.FAMILY_ID);
                if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                        Objects.equals(qrData.get(FieldNameConstants.IS_QR_FOR_ABHA), "true")) {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.eq(FieldNameConstants.GENDER, "F"),
                            where.eq(FieldNameConstants.MARITAL_STATUS, "629"),
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
                                    where.like(FieldNameConstants.HEALTH_ID, "%" + qrData.get(FieldNameConstants.HEALTH_ID) + "%"),      //Search By HealthId
                                    where.like(FieldNameConstants.HEALTH_ID_NUMBER, "%" + qrData.get(FieldNameConstants.HEALTH_ID_NUMBER) + "%")      //Search By HealthIdNumber
                            )
                    ).query();
                } else if (searchString != null) {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.eq(FieldNameConstants.GENDER, "F"),
                            where.eq(FieldNameConstants.MARITAL_STATUS, "629"),
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
                                    where.like(FieldNameConstants.FIRST_NAME, "%" + searchString + "%"),        //Search By FirstName
                                    where.like(FieldNameConstants.MIDDLE_NAME, "%" + searchString + "%"),       //Search By MiddleName
                                    where.like(FieldNameConstants.LAST_NAME, "%" + searchString + "%"),         //Search By LastName
                                    where.like(FieldNameConstants.FAMILY_ID, "%" + searchString + "%"),         //Search By FamilyId
                                    where.like(FieldNameConstants.MOBILE_NUMBER, "%" + searchString + "%"),      //Search By MobileNumber
                                    where.like(FieldNameConstants.HEALTH_ID, "%" + searchString + "%"),      //Search By HealthId
                                    where.like(FieldNameConstants.PASSPORT_NUMBER, "%" + searchString + "%")
                            )
                    ).query();
                } else {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.eq(FieldNameConstants.GENDER, "F"),
                            where.eq(FieldNameConstants.MARITAL_STATUS, "629"),
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
                    ).query();
                }

                Calendar cal = Calendar.getInstance();
                cal.add(Calendar.MONTH, -3);

                Calendar cal1 = Calendar.getInstance();
                cal1.add(Calendar.YEAR, -3);

                List<MemberDataBean> membersWithChildCountMoreThan2 = new ArrayList<>();
                List<MemberDataBean> membersWithLastDeliveryDateLessThan3Years = new ArrayList<>();
                List<MemberDataBean> eligibleCouples = new ArrayList<>();

                for (MemberBean memberBean : memberBeans) {
                    if (memberBean.getGender() != null && memberBean.getGender().equals(GlobalTypes.FEMALE)
                            && memberBean.getMaritalStatus() != null && memberBean.getMaritalStatus().equals("629")
                            && memberBean.getDob() != null && memberBean.getDob().after(dateBefore45Years) && memberBean.getDob().before(dateBefore18Years)
                            && (memberBean.getIsPregnantFlag() == null || !memberBean.getIsPregnantFlag())
                            && (memberBean.getMenopauseArrived() == null || !memberBean.getMenopauseArrived())
                            && (memberBean.getHysterectomyDone() == null || !memberBean.getHysterectomyDone())
                            && (memberBean.getLastMethodOfContraception() == null
                            || (!memberBean.getLastMethodOfContraception().equals(RchConstants.FEMALE_STERILIZATION)
                            && !memberBean.getLastMethodOfContraception().equals(RchConstants.MALE_STERILIZATION))
                            || (memberBean.getFpInsertOperateDate() != null && memberBean.getFpInsertOperateDate().after(cal.getTime())))) {
                        long childCount = memberBeanDao.queryBuilder().where().eq(FieldNameConstants.MOTHER_ID, memberBean.getActualId()).countOf();
                        if (childCount > 2) {
                            membersWithChildCountMoreThan2.add(new MemberDataBean(memberBean));
                        } else if (memberBean.getLastDeliveryDate() != null && memberBean.getLastDeliveryDate().after(cal1.getTime())) {
                            membersWithLastDeliveryDateLessThan3Years.add(new MemberDataBean(memberBean));
                        } else {
                            eligibleCouples.add(new MemberDataBean(memberBean));
                        }
                    }
                }

                memberDataBeans.addAll(membersWithChildCountMoreThan2);
                memberDataBeans.addAll(membersWithLastDeliveryDateLessThan3Years);
                memberDataBeans.addAll(eligibleCouples);
            }
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return memberDataBeans;
    }

    @Override
    public List<MemberDataBean> retrieveMembersForGbvZambia(List<Integer> locationIds, Integer villageId, CharSequence searchString, long limit, long offset) {
        List<MemberDataBean> memberDataBeans = new ArrayList<>();
        try {
            List<String> familyIds = new ArrayList<>();
            List<FamilyBean> familyBeans;

            if (locationIds != null && !locationIds.isEmpty()) {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .in(FieldNameConstants.AREA_ID, locationIds)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            } else {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .eq(FieldNameConstants.LOCATION_ID, villageId)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            }

            for (FamilyBean familyBean : familyBeans) {
                familyIds.add(familyBean.getFamilyId());
            }
            if (familyIds != null) {
                List<MemberBean> memberBeans;
                Calendar calendar = Calendar.getInstance();
                UtilBean.clearTimeFromDate(calendar);
                calendar.add(Calendar.YEAR, -15);
                Date dateBefore15Years = calendar.getTime();
                Where<MemberBean, Integer> where = memberBeanDao.queryBuilder().limit(limit).offset(offset).where();
                if (searchString != null) {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.or(
                                    where.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + searchString + "%"),   //Search By UniqueHealthId
                                    where.like(FieldNameConstants.FIRST_NAME, "%" + searchString + "%"),        //Search By FirstName
                                    where.like(FieldNameConstants.MIDDLE_NAME, "%" + searchString + "%"),       //Search By MiddleName
                                    where.like(FieldNameConstants.LAST_NAME, "%" + searchString + "%"),         //Search By LastName
                                    where.like(FieldNameConstants.FAMILY_ID, "%" + searchString + "%"),         //Search By FamilyId
                                    where.like(FieldNameConstants.NRC_NUMBER, "%" + searchString + "%"),            //Search by nrc
                                    where.like(FieldNameConstants.MOBILE_NUMBER, "%" + searchString + "%"),    //Search By HealthId
                                    where.like(FieldNameConstants.SEARCH_STRING, "%" + searchString + "%"),
                                    where.like(FieldNameConstants.PASSPORT_NUMBER, "%" + searchString + "%")
                            )
                    ).query();
                } else {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES)
                    ).query();
                }
                for (MemberBean memberBean : memberBeans) {
                    memberDataBeans.add(new MemberDataBean(memberBean));
                }

            }
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }

        return memberDataBeans;
    }

    @Override
    public List<MemberDataBean> retrieveEligibleCouplesForZambia
            (List<Integer> locationIds, Integer villageId, CharSequence searchString, long limit,
             long offset,
             LinkedHashMap<String, String> qrData) {
        List<MemberDataBean> memberDataBeans = new ArrayList<>();

        try {
            List<String> familyIds = new ArrayList<>();
            List<FamilyBean> familyBeans;

            if (locationIds != null && !locationIds.isEmpty()) {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .in(FieldNameConstants.AREA_ID, locationIds)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            } else {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .eq(FieldNameConstants.LOCATION_ID, villageId)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            }

            for (FamilyBean familyBean : familyBeans) {
                familyIds.add(familyBean.getFamilyId());
            }

            if (!familyIds.isEmpty()) {
                List<MemberBean> memberBeans;
                Calendar calendar = Calendar.getInstance();
                calendar.add(Calendar.YEAR, -15);
                Date dateBefore18Years = calendar.getTime();
                calendar.add(Calendar.YEAR, -100);
                Date dateBefore45Years = calendar.getTime();
                Where<MemberBean, Integer> where = memberBeanDao.queryBuilder().limit(limit).offset(offset).where();
                if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                        qrData.containsKey(FieldNameConstants.FAMILY_ID))
                    searchString = qrData.get(FieldNameConstants.FAMILY_ID);
                if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                        Objects.equals(qrData.get(FieldNameConstants.IS_QR_FOR_ABHA), "true")) {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.or(
                                    where.eq(FieldNameConstants.GENDER, "M"),
                                    where.eq(FieldNameConstants.GENDER, "F")
                            ),
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
                    ).query();
                } else if (searchString != null) {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.or(
                                    where.eq(FieldNameConstants.GENDER, "M"),
                                    where.eq(FieldNameConstants.GENDER, "F")
                            ),
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
                                    where.like(FieldNameConstants.FIRST_NAME, "%" + searchString + "%"),        //Search By FirstName
                                    where.like(FieldNameConstants.MIDDLE_NAME, "%" + searchString + "%"),       //Search By MiddleName
                                    where.like(FieldNameConstants.LAST_NAME, "%" + searchString + "%"),         //Search By LastName
                                    where.like(FieldNameConstants.FAMILY_ID, "%" + searchString + "%"),         //Search By FamilyId
                                    where.like(FieldNameConstants.NRC_NUMBER, "%" + searchString + "%"),            //Search by nrc
                                    where.like(FieldNameConstants.MOBILE_NUMBER, "%" + searchString + "%"),    //Search By HealthId
                                    where.like(FieldNameConstants.SEARCH_STRING, "%" + searchString + "%"),
                                    where.like(FieldNameConstants.PASSPORT_NUMBER, "%" + searchString + "%")
                            )
                    ).query();
                } else {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.or(
                                    where.eq(FieldNameConstants.GENDER, "M"),
                                    where.eq(FieldNameConstants.GENDER, "F")
                            ),
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
                    ).query();
                }

                Calendar cal = Calendar.getInstance();
                cal.add(Calendar.MONTH, -3);

                Calendar cal1 = Calendar.getInstance();
                cal1.add(Calendar.YEAR, -3);

                List<MemberDataBean> membersWithChildCountMoreThan2 = new ArrayList<>();
                List<MemberDataBean> membersWithLastDeliveryDateLessThan3Years = new ArrayList<>();
                List<MemberDataBean> eligibleCouples = new ArrayList<>();

                for (MemberBean memberBean : memberBeans) {
                    if (memberBean.getGender() != null
                            && memberBean.getDob() != null && memberBean.getDob().after(dateBefore45Years) && memberBean.getDob().before(dateBefore18Years)
                            && (memberBean.getIsPregnantFlag() == null || !memberBean.getIsPregnantFlag())
                            && (memberBean.getMenopauseArrived() == null || !memberBean.getMenopauseArrived())
                            && (memberBean.getHysterectomyDone() == null || !memberBean.getHysterectomyDone())
                            && (memberBean.getLastMethodOfContraception() == null
                            || (!memberBean.getLastMethodOfContraception().equals(RchConstants.FEMALE_STERILIZATION) && !memberBean.getLastMethodOfContraception().equals(RchConstants.MALE_STERILIZATION))
                            || (memberBean.getFpInsertOperateDate() != null && memberBean.getFpInsertOperateDate().after(cal.getTime())))) {
                        long childCount = 0;
                        if (memberBean.getActualId() != null) {
                            childCount = memberBeanDao.queryBuilder().where().eq(FieldNameConstants.MOTHER_ID, memberBean.getActualId()).countOf();
                        }
                        if (childCount > 2) {
                            membersWithChildCountMoreThan2.add(new MemberDataBean(memberBean));
                        } else if (memberBean.getLastDeliveryDate() != null && memberBean.getLastDeliveryDate().after(cal1.getTime())) {
                            membersWithLastDeliveryDateLessThan3Years.add(new MemberDataBean(memberBean));
                        } else {
                            eligibleCouples.add(new MemberDataBean(memberBean));
                        }
                    }
                }

                memberDataBeans.addAll(membersWithChildCountMoreThan2);
                memberDataBeans.addAll(membersWithLastDeliveryDateLessThan3Years);
                memberDataBeans.addAll(eligibleCouples);
            }
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return memberDataBeans;
    }

    @Override
    public List<MemberDataBean> retrievePregnantWomenByAshaArea(List<Integer> locationIds,
                                                                boolean isHighRisk, List<Integer> villageIds,
                                                                CharSequence searchString, long limit, long offset, LinkedHashMap<
            String, String> qrData) {
        List<MemberDataBean> memberDataBeans = new ArrayList<>();

        try {
            List<String> familyIds = new ArrayList<>();
            List<FamilyBean> familyBeans;

            if (locationIds != null && !locationIds.isEmpty()) {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID, FieldNameConstants.UUID).where()
                        .in(FieldNameConstants.AREA_ID, locationIds)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            } else {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID, FieldNameConstants.UUID).where()
                        .in(FieldNameConstants.LOCATION_ID, villageIds)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            }

            for (FamilyBean familyBean : familyBeans) {
                familyIds.add(familyBean.getFamilyId());
            }

            if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                    qrData.containsKey(FieldNameConstants.FAMILY_ID))
                searchString = qrData.get(FieldNameConstants.FAMILY_ID);

            if (!familyIds.isEmpty()) {
                List<MemberBean> memberBeans;
                Where<MemberBean, Integer> where = memberBeanDao.queryBuilder().limit(limit).offset(offset).orderBy(FieldNameConstants.EDD, true).where();
                if (isHighRisk) {
                    if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                            Objects.equals(qrData.get(FieldNameConstants.IS_QR_FOR_ABHA), "true")) {
                        memberBeans = where.and(
                                where.in(FieldNameConstants.FAMILY_ID, familyIds),
                                where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                                where.eq(FieldNameConstants.IS_PREGNANT_FLAG, Boolean.TRUE),
                                where.eq(FieldNameConstants.IS_HIGH_RISK_CASE, Boolean.TRUE),
                                where.or(
                                        where.like(FieldNameConstants.HEALTH_ID, "%" + qrData.get(FieldNameConstants.HEALTH_ID) + "%"),  //Search By UniqueHealthId
                                        where.like(FieldNameConstants.HEALTH_ID_NUMBER, "%" + qrData.get(FieldNameConstants.HEALTH_ID_NUMBER) + "%")     //Search By HealthId
                                )
                        ).query();
                    } else if (searchString != null) {
                        memberBeans = where.and(
                                where.in(FieldNameConstants.FAMILY_ID, familyIds),
                                where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                                where.eq(FieldNameConstants.IS_PREGNANT_FLAG, Boolean.TRUE),
                                where.eq(FieldNameConstants.IS_HIGH_RISK_CASE, Boolean.TRUE),
                                where.or(
                                        where.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + searchString + "%"),  //Search By UniqueHealthId
                                        where.like(FieldNameConstants.FIRST_NAME, "%" + searchString + "%"),       //Search By FirstName
                                        where.like(FieldNameConstants.MIDDLE_NAME, "%" + searchString + "%"),       //Search By MiddleName
                                        where.like(FieldNameConstants.LAST_NAME, "%" + searchString + "%"),         //Search By LastName
                                        where.like(FieldNameConstants.FAMILY_ID, "%" + searchString + "%"),        //Search By FamilyId
                                        where.like(FieldNameConstants.MOBILE_NUMBER, "%" + searchString + "%"),   //Search By MobileNumber
                                        where.like(FieldNameConstants.NRC_NUMBER, "%" + searchString + "%"),    //Search by nrc
                                        where.like(FieldNameConstants.HEALTH_ID, "%" + searchString + "%"),     //Search By HealthId
                                        where.like(FieldNameConstants.SEARCH_STRING, "%" + searchString + "%"),
                                        where.like(FieldNameConstants.PASSPORT_NUMBER, "%" + searchString + "%")
                                )
                        ).query();
                    } else {
                        memberBeans = where.and(
                                where.in(FieldNameConstants.FAMILY_ID, familyIds),
                                where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                                where.eq(FieldNameConstants.IS_HIGH_RISK_CASE, Boolean.TRUE),
                                where.eq(FieldNameConstants.IS_PREGNANT_FLAG, Boolean.TRUE)
                        ).query();
                    }
                } else {
                    if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                            Objects.equals(qrData.get(FieldNameConstants.IS_QR_FOR_ABHA), "true")) {
                        memberBeans = where.and(
                                where.in(FieldNameConstants.FAMILY_ID, familyIds),
                                where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                                where.eq(FieldNameConstants.IS_PREGNANT_FLAG, Boolean.TRUE),
                                where.or(
                                        where.like(FieldNameConstants.HEALTH_ID, "%" + qrData.get(FieldNameConstants.HEALTH_ID) + "%"),  //Search By UniqueHealthId
                                        where.like(FieldNameConstants.HEALTH_ID_NUMBER, "%" + qrData.get(FieldNameConstants.HEALTH_ID_NUMBER) + "%")     //Search By HealthId
                                )
                        ).query();
                    } else if (searchString != null) {
                        memberBeans = where.and(
                                where.in(FieldNameConstants.FAMILY_ID, familyIds),
                                where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                                where.eq(FieldNameConstants.IS_PREGNANT_FLAG, Boolean.TRUE),
                                where.or(
                                        where.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + searchString + "%"),  //Search By UniqueHealthId
                                        where.like(FieldNameConstants.FIRST_NAME, "%" + searchString + "%"),       //Search By FirstName
                                        where.like(FieldNameConstants.MIDDLE_NAME, "%" + searchString + "%"),       //Search By MiddleName
                                        where.like(FieldNameConstants.LAST_NAME, "%" + searchString + "%"),         //Search By LastName
                                        where.like(FieldNameConstants.FAMILY_ID, "%" + searchString + "%"),        //Search By FamilyId
                                        where.like(FieldNameConstants.MOBILE_NUMBER, "%" + searchString + "%"), //Search By MobileNumber
                                        where.like(FieldNameConstants.NRC_NUMBER, "%" + searchString + "%"),    //Search by nrc
                                        where.like(FieldNameConstants.HEALTH_ID, "%" + searchString + "%"),     //Search By HealthId
                                        where.like(FieldNameConstants.SEARCH_STRING, "%" + searchString + "%"),
                                        where.like(FieldNameConstants.PASSPORT_NUMBER, "%" + searchString + "%")
                                )
                        ).query();
                    } else {
                        memberBeans = where.and(
                                where.in(FieldNameConstants.FAMILY_ID, familyIds),
                                where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                                where.eq(FieldNameConstants.GENDER, GlobalTypes.FEMALE),
                                where.eq(FieldNameConstants.IS_PREGNANT_FLAG, Boolean.TRUE)
                        ).query();
                    }
                }

                List<MemberDataBean> membersWithEddNotNull = new ArrayList<>();
                List<MemberDataBean> membersWithEddNull = new ArrayList<>();

                for (MemberBean memberBean : memberBeans) {
                    if (memberBean.getGender() != null && memberBean.getGender().equals(GlobalTypes.FEMALE)
                            && Boolean.TRUE.equals(memberBean.getIsPregnantFlag())) {
                        if (memberBean.getEdd() != null) {
                            membersWithEddNotNull.add(new MemberDataBean(memberBean));
                        } else {
                            membersWithEddNull.add(new MemberDataBean(memberBean));
                        }
                    }
                }

                memberDataBeans.addAll(membersWithEddNotNull);
                memberDataBeans.addAll(membersWithEddNull);
            }
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return memberDataBeans;
    }

    @Override
    public List<MemberDataBean> retrieveWPDWomenByAshaArea
            (List<Integer> locationIds, List<Integer> villageIds, CharSequence searchString,
             long limit, long offset,
             LinkedHashMap<String, String> qrData) {
        List<MemberDataBean> memberDataBeans = new ArrayList<>();

        try {
            List<String> familyIds = new ArrayList<>();
            List<FamilyBean> familyBeans;

            if (locationIds != null && !locationIds.isEmpty()) {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .in(FieldNameConstants.AREA_ID, locationIds)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            } else {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .in(FieldNameConstants.LOCATION_ID, villageIds)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            }

            for (FamilyBean familyBean : familyBeans) {
                familyIds.add(familyBean.getFamilyId());
            }

            if (!familyIds.isEmpty()) {
                List<MemberBean> memberBeans;
                Where<MemberBean, Integer> where = memberBeanDao.queryBuilder().limit(limit).offset(offset).orderBy(FieldNameConstants.EDD, true).where();

                Calendar cal = Calendar.getInstance();
                cal.add(Calendar.DATE, 15);
                if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                        qrData.containsKey(FieldNameConstants.FAMILY_ID))
                    searchString = qrData.get(FieldNameConstants.FAMILY_ID);
                if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                        Objects.equals(qrData.get(FieldNameConstants.IS_QR_FOR_ABHA), "true")) {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.eq(FieldNameConstants.IS_PREGNANT_FLAG, Boolean.TRUE),
                            where.le(FieldNameConstants.EDD, cal.getTime()),
                            where.or(
                                    where.like(FieldNameConstants.HEALTH_ID, "%" + qrData.get(FieldNameConstants.HEALTH_ID) + "%"),     //Search By HealthId
                                    where.like(FieldNameConstants.HEALTH_ID_NUMBER, "%" + qrData.get(FieldNameConstants.HEALTH_ID_NUMBER) + "%")     //Search By HealthIdNumber
                            )
                    ).query();
                } else if (searchString != null) {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.eq(FieldNameConstants.IS_PREGNANT_FLAG, Boolean.TRUE),
                            where.le(FieldNameConstants.EDD, cal.getTime()),
                            where.or(
                                    where.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + searchString + "%"),  //Search By UniqueHealthId
                                    where.like(FieldNameConstants.FIRST_NAME, "%" + searchString + "%"),       //Search By FirstName
                                    where.like(FieldNameConstants.FAMILY_ID, "%" + searchString + "%"),        //Search By FamilyId
                                    where.like(FieldNameConstants.MOBILE_NUMBER, "%" + searchString + "%"),
                                    where.like(FieldNameConstants.NRC_NUMBER, "%" + searchString + "%"),    //Search By MobileNumber
                                    where.like(FieldNameConstants.HEALTH_ID, "%" + searchString + "%"),    //Search By HealthId
                                    where.like(FieldNameConstants.PASSPORT_NUMBER, "%" + searchString + "%")
                            )
                    ).query();
                } else {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.eq(FieldNameConstants.IS_PREGNANT_FLAG, Boolean.TRUE),
                            where.le(FieldNameConstants.EDD, cal.getTime())
                    ).query();
                }

                List<MemberDataBean> membersWithEddNotNull = new ArrayList<>();
                List<MemberDataBean> membersWithEddNull = new ArrayList<>();

                for (MemberBean memberBean : memberBeans) {
                    if (memberBean.getGender() != null && memberBean.getGender().equals(GlobalTypes.FEMALE)
                            && Boolean.TRUE.equals(memberBean.getIsPregnantFlag())) {
                        if (memberBean.getEdd() != null) {
                            membersWithEddNotNull.add(new MemberDataBean(memberBean));
                        } else {
                            membersWithEddNull.add(new MemberDataBean(memberBean));
                        }
                    }
                }

                memberDataBeans.addAll(membersWithEddNotNull);
                memberDataBeans.addAll(membersWithEddNull);
            }
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return memberDataBeans;
    }

    @Override
    public List<MemberDataBean> retrievePncMothersByAshaArea
            (List<Integer> locationIds, Integer villageId, CharSequence searchString, long limit,
             long offset,
             LinkedHashMap<String, String> qrData) {
        List<MemberDataBean> memberDataBeans = new ArrayList<>();

        try {
            List<String> familyIds = new ArrayList<>();
            List<FamilyBean> familyBeans;

            if (locationIds != null && !locationIds.isEmpty()) {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .in(FieldNameConstants.AREA_ID, locationIds)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            } else {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .eq(FieldNameConstants.LOCATION_ID, villageId)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            }

            for (FamilyBean familyBean : familyBeans) {
                familyIds.add(familyBean.getFamilyId());
            }

            if (!familyIds.isEmpty()) {
                List<MemberBean> memberBeans;
                Where<MemberBean, Integer> where = memberBeanDao.queryBuilder().limit(limit).offset(offset).where();
                Calendar instance = Calendar.getInstance();
                instance.add(Calendar.DATE, -60);

                if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                        qrData.containsKey(FieldNameConstants.FAMILY_ID))
                    searchString = qrData.get(FieldNameConstants.FAMILY_ID);
                if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                        Objects.equals(qrData.get(FieldNameConstants.IS_QR_FOR_ABHA), "true")) {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.ge(FieldNameConstants.LAST_DELIVERY_DATE, instance.getTime()),
                            where.or(
                                    where.like(FieldNameConstants.HEALTH_ID, "%" + qrData.get(FieldNameConstants.HEALTH_ID) + "%"),     //Search By HealthId
                                    where.like(FieldNameConstants.HEALTH_ID_NUMBER, "%" + qrData.get(FieldNameConstants.HEALTH_ID_NUMBER) + "%")     //Search By HealthIdNumber
                            )
                    ).query();
                } else if (searchString != null) {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.ge(FieldNameConstants.LAST_DELIVERY_DATE, instance.getTime()),
                            where.or(
                                    where.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + searchString + "%"),  //Search By UniqueHealthId
                                    where.like(FieldNameConstants.FIRST_NAME, "%" + searchString + "%"),       //Search By FirstName
                                    where.like(FieldNameConstants.MIDDLE_NAME, "%" + searchString + "%"),       //Search By MiddleName
                                    where.like(FieldNameConstants.LAST_NAME, "%" + searchString + "%"),         //Search By LastName
                                    where.like(FieldNameConstants.FAMILY_ID, "%" + searchString + "%"),        //Search By FamilyId
                                    where.like(FieldNameConstants.MOBILE_NUMBER, "%" + searchString + "%"), //Search By MobileNumber
                                    where.like(FieldNameConstants.NRC_NUMBER, "%" + searchString + "%"),    //Search by nrc
                                    where.like(FieldNameConstants.HEALTH_ID, "%" + searchString + "%"),     //Search By HealthId
                                    where.like(FieldNameConstants.SEARCH_STRING, "%" + searchString + "%"),
                                    where.like(FieldNameConstants.PASSPORT_NUMBER, "%" + searchString + "%")
                            )
                    ).query();
                } else {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.ge(FieldNameConstants.LAST_DELIVERY_DATE, instance.getTime())
                    ).query();
                }

                for (MemberBean memberBean : memberBeans) {
                    if (memberBean.getLastDeliveryDate() != null && memberBean.getLastDeliveryDate().after(instance.getTime())) {
                        memberDataBeans.add(new MemberDataBean(memberBean));
                    }
                }

            }
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return memberDataBeans;
    }

    @Override
    public List<MemberDataBean> retrieveChildsBelow5YearsByAshaArea
            (List<Integer> locationIds, Boolean isHighRisk, List<Integer> villageIds,
             CharSequence searchString, long limit, long offset, LinkedHashMap<
                    String, String> qrData) {
        List<MemberDataBean> memberDataBeans = new ArrayList<>();

        try {
            List<String> familyIds = new ArrayList<>();
            List<FamilyBean> familyBeans;

            if (locationIds != null && !locationIds.isEmpty()) {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .in(FieldNameConstants.AREA_ID, locationIds)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            } else {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .in(FieldNameConstants.LOCATION_ID, villageIds)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            }

            for (FamilyBean familyBean : familyBeans) {
                familyIds.add(familyBean.getFamilyId());
            }
            if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                    qrData.containsKey(FieldNameConstants.FAMILY_ID))
                searchString = qrData.get(FieldNameConstants.FAMILY_ID);
            if (!familyIds.isEmpty()) {
                List<MemberBean> memberBeans;
                Calendar calendar = Calendar.getInstance();
                calendar.add(Calendar.YEAR, -5);
                Where<MemberBean, Integer> where = memberBeanDao.queryBuilder().limit(limit).offset(offset).orderBy(FieldNameConstants.DOB, false).where();
                if (isHighRisk != null && isHighRisk) {
                    if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                            Objects.equals(qrData.get(FieldNameConstants.IS_QR_FOR_ABHA), "true")) {
                        memberBeans = where.and(
                                where.in(FieldNameConstants.FAMILY_ID, familyIds),
                                where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                                where.ge(FieldNameConstants.DOB, calendar.getTime()),
                                where.eq(FieldNameConstants.IS_HIGH_RISK_CASE, Boolean.TRUE),
                                where.or(
                                        where.like(FieldNameConstants.HEALTH_ID, "%" + qrData.get(FieldNameConstants.HEALTH_ID) + "%"),       //Search By MobileNumber
                                        where.like(FieldNameConstants.HEALTH_ID_NUMBER, "%" + qrData.get(FieldNameConstants.HEALTH_ID_NUMBER) + "%")       //Search By HealthIdNumber
                                )
                        ).query();
                    } else if (searchString != null) {
                        memberBeans = where.and(
                                where.in(FieldNameConstants.FAMILY_ID, familyIds),
                                where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                                where.ge(FieldNameConstants.DOB, calendar.getTime()),
                                where.eq(FieldNameConstants.IS_HIGH_RISK_CASE, Boolean.TRUE),
                                where.or(where.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + searchString + "%"),   //Search By UniqueHealthId
                                        where.like(FieldNameConstants.FIRST_NAME, "%" + searchString + "%"),         //Search By FirstName
                                        where.like(FieldNameConstants.MIDDLE_NAME, "%" + searchString + "%"),       //Search By MiddleName
                                        where.like(FieldNameConstants.LAST_NAME, "%" + searchString + "%"),         //Search By LastName
                                        where.like(FieldNameConstants.FAMILY_ID, "%" + searchString + "%"),          //Search By FamilyId
                                        where.like(FieldNameConstants.MOBILE_NUMBER, "%" + searchString + "%"),       //Search By MobileNumber
                                        where.like(FieldNameConstants.NRC_NUMBER, "%" + searchString + "%"),    //Search by nrc
                                        where.like(FieldNameConstants.HEALTH_ID, "%" + searchString + "%"),       //Search By HealthId,
                                        where.like(FieldNameConstants.SEARCH_STRING, "%" + searchString + "%"),
                                        where.like(FieldNameConstants.PASSPORT_NUMBER, "%" + searchString + "%")
                                )
                        ).query();
                    } else {
                        memberBeans = where.and(
                                where.in(FieldNameConstants.FAMILY_ID, familyIds),
                                where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                                where.ge(FieldNameConstants.DOB, calendar.getTime()),
                                where.eq(FieldNameConstants.IS_HIGH_RISK_CASE, Boolean.TRUE)
                        ).query();
                    }
                } else {
                    if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                            Objects.equals(qrData.get(FieldNameConstants.IS_QR_FOR_ABHA), "true")) {
                        memberBeans = where.and(
                                where.in(FieldNameConstants.FAMILY_ID, familyIds),
                                where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                                where.ge(FieldNameConstants.DOB, calendar.getTime()),
                                where.or(
                                        where.like(FieldNameConstants.HEALTH_ID, "%" + qrData.get(FieldNameConstants.HEALTH_ID) + "%"),       //Search By HealthId
                                        where.like(FieldNameConstants.HEALTH_ID_NUMBER, "%" + qrData.get(FieldNameConstants.HEALTH_ID_NUMBER) + "%")       //Search By HealthIdNumber
                                )
                        ).query();
                    } else if (searchString != null) {
                        memberBeans = where.and(
                                where.in(FieldNameConstants.FAMILY_ID, familyIds),
                                where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                                where.ge(FieldNameConstants.DOB, calendar.getTime()),
                                where.or(where.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + searchString + "%"),   //Search By UniqueHealthId
                                        where.like(FieldNameConstants.FIRST_NAME, "%" + searchString + "%"),         //Search By
                                        where.like(FieldNameConstants.MIDDLE_NAME, "%" + searchString + "%"),       //Search By MiddleName
                                        where.like(FieldNameConstants.LAST_NAME, "%" + searchString + "%"),         //Search By LastName
                                        where.like(FieldNameConstants.FAMILY_ID, "%" + searchString + "%"),          //Search By FamilyId
                                        where.like(FieldNameConstants.MOBILE_NUMBER, "%" + searchString + "%"),       //Search By MobileNumber
                                        where.like(FieldNameConstants.NRC_NUMBER, "%" + searchString + "%"),    //Search by nrc
                                        where.like(FieldNameConstants.HEALTH_ID, "%" + searchString + "%"),       //Search By HealthId
                                        where.like(FieldNameConstants.SEARCH_STRING, "%" + searchString + "%"),
                                        where.like(FieldNameConstants.PASSPORT_NUMBER, "%" + searchString + "%")
                                )
                        ).query();
                    } else {
                        memberBeans = where.and(
                                where.in(FieldNameConstants.FAMILY_ID, familyIds),
                                where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                                where.ge(FieldNameConstants.DOB, calendar.getTime())
                        ).query();
                    }
                }

                for (MemberBean memberBean : memberBeans) {
                    if (memberBean.getDob() != null && memberBean.getDob().after(calendar.getTime())) {
                        memberDataBeans.add(new MemberDataBean(memberBean));
                    }
                }
            }
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return memberDataBeans;
    }

    @Override
    public List<MemberDataBean> retrieveMembersByAshaArea(List<Integer> locationIds, Integer
            villageId, CharSequence searchString, long limit, long offset,
                                                          LinkedHashMap<String, String> qrData) {
        List<MemberDataBean> memberDataBeans = new ArrayList<>();

        try {
            List<String> familyIds = new ArrayList<>();
            List<FamilyBean> familyBeans;

            if (locationIds != null && !locationIds.isEmpty()) {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .in(FieldNameConstants.AREA_ID, locationIds)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            } else {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .eq(FieldNameConstants.LOCATION_ID, villageId)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            }

            for (FamilyBean familyBean : familyBeans) {
                familyIds.add(familyBean.getFamilyId());
            }

            if (!familyIds.isEmpty()) {
                List<MemberBean> memberBeans;
                Where<MemberBean, Integer> where = memberBeanDao.queryBuilder().limit(limit).offset(offset).where();
                if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                        qrData.containsKey(FieldNameConstants.FAMILY_ID))
                    searchString = qrData.get(FieldNameConstants.FAMILY_ID);
                if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                        Objects.equals(qrData.get(FieldNameConstants.IS_QR_FOR_ABHA), "true")) {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.or(
                                    where.like(FieldNameConstants.HEALTH_ID, "%" + qrData.get(FieldNameConstants.HEALTH_ID) + "%"),      //Search By HealthId
                                    where.like(FieldNameConstants.HEALTH_ID_NUMBER, "%" + qrData.get(FieldNameConstants.HEALTH_ID_NUMBER) + "%")        //Search By HealthIdNumber
                            )
                    ).query();
                } else if (searchString != null) {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.or(where.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + searchString + "%"),    //Search By UniqueHealthId
                                    where.like(FieldNameConstants.FIRST_NAME, "%" + searchString + "%"),          //Search By FirstName
                                    where.like(FieldNameConstants.MIDDLE_NAME, "%" + searchString + "%"),       //Search By MiddleName
                                    where.like(FieldNameConstants.LAST_NAME, "%" + searchString + "%"),         //Search By LastName
                                    where.like(FieldNameConstants.FAMILY_ID, "%" + searchString + "%"),           //Search By FamilyId
                                    where.like(FieldNameConstants.MOBILE_NUMBER, "%" + searchString + "%"),      //Search By MobileNumber
                                    where.like(FieldNameConstants.HEALTH_ID, "%" + searchString + "%"),      //Search By HealthId
                                    where.like(FieldNameConstants.SEARCH_STRING, "%" + searchString + "%"),
                                    where.like(FieldNameConstants.PASSPORT_NUMBER, "%" + searchString + "%")
                            )
                    ).query();
                } else {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES)
                    ).query();
                }
                for (MemberBean memberBean : memberBeans) {
                    memberDataBeans.add(new MemberDataBean(memberBean));
                }
            }
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return memberDataBeans;
    }


    @Override
    public List<FamilyDataBean> retrieveFamilyDataBeansByAshaArea
            (List<Integer> locationIds, Integer villageId, CharSequence searchString, long limit,
             long offset, LinkedHashMap<String, String> qrData) {
        List<FamilyDataBean> familyDataBeans = new ArrayList<>();

        if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                qrData.containsKey(FieldNameConstants.FAMILY_ID))
            searchString = qrData.get(FieldNameConstants.FAMILY_ID);
        try {
            List<FamilyBean> familyBeans;

            if (locationIds != null && !locationIds.isEmpty()) {
                QueryBuilder<MemberBean, Integer> memberQB = memberBeanDao.queryBuilder();
                Where<MemberBean, Integer> where = memberQB.where();
                where.and(
                        where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                        where.or(
                                where.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + searchString + "%"),
                                where.like(FieldNameConstants.FIRST_NAME, "%" + searchString + "%"),
                                where.like(FieldNameConstants.MIDDLE_NAME, "%" + searchString + "%"),
                                where.like(FieldNameConstants.LAST_NAME, "%" + searchString + "%"),
                                where.like(FieldNameConstants.FAMILY_ID, "%" + searchString + "%"),
                                where.like(FieldNameConstants.MOBILE_NUMBER, "%" + searchString + "%"),
                                where.like(FieldNameConstants.HEALTH_ID, "%" + searchString + "%"),
                                where.like(FieldNameConstants.SEARCH_STRING, "%" + searchString + "%")
                        )
                );
                familyBeans = familyBeanDao.queryBuilder().limit(limit).offset(offset)
                        .join(FieldNameConstants.FAMILY_ID, FieldNameConstants.FAMILY_ID, memberQB).distinct().where()
                        .in(FieldNameConstants.AREA_ID, locationIds)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            } else {
                QueryBuilder<MemberBean, Integer> memberQB = memberBeanDao.queryBuilder();
                Where<MemberBean, Integer> where = memberQB.where();
                where.and(
                        where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                        where.or(
                                where.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + searchString + "%"),
                                where.like(FieldNameConstants.FIRST_NAME, "%" + searchString + "%"),
                                where.like(FieldNameConstants.MIDDLE_NAME, "%" + searchString + "%"),
                                where.like(FieldNameConstants.LAST_NAME, "%" + searchString + "%"),
                                where.like(FieldNameConstants.FAMILY_ID, "%" + searchString + "%"),
                                where.like(FieldNameConstants.MOBILE_NUMBER, "%" + searchString + "%"),
                                where.like(FieldNameConstants.HEALTH_ID, "%" + searchString + "%"),
                                where.like(FieldNameConstants.SEARCH_STRING, "%" + searchString + "%")
                        )
                );
                familyBeans = familyBeanDao.queryBuilder().limit(limit).offset(offset)
                        .join(FieldNameConstants.FAMILY_ID, FieldNameConstants.FAMILY_ID, memberQB).distinct().where()
                        .in(FieldNameConstants.AREA_ID, villageId)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            }

            for (FamilyBean familyBean : familyBeans) {
                familyDataBeans.add(new FamilyDataBean(familyBean, null));
            }
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return familyDataBeans;
    }

    @Override
    public MemberBean retrieveMemberBeanByActualId(Long id) {
        try {
            return memberBeanDao.queryBuilder().where().eq(FieldNameConstants.ACTUAL_ID, id).queryForFirst();
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return null;
    }

    @Override
    public MemberBean retrieveMemberBeanByUUID(String uuid) {
        try {
            return memberBeanDao.queryBuilder().where().eq(FieldNameConstants.MEMBER_UUID, uuid).queryForFirst();
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return null;
    }


    @Override
    public MemberBean retrieveMemberBeanByHealthId(String healthId) {
        try {
            return memberBeanDao.queryBuilder().where().eq(FieldNameConstants.UNIQUE_HEALTH_ID, healthId).queryForFirst();
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return null;
    }

    @Override
    public FamilyBean retrieveFamilyBeanByActualId(Long id) {
        try {
            return familyBeanDao.queryBuilder().where().eq(FieldNameConstants.ACTUAL_ID, id).queryForFirst();
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return null;
    }

    @Override
    public void markMemberAsMigrated(Long memberActualId) {
        try {
            MemberBean memberBean = memberBeanDao.queryBuilder().where().eq(FieldNameConstants.ACTUAL_ID, memberActualId).queryForFirst();
            memberBean.setState(FhsConstants.FHS_MEMBER_STATE_MIGRATED);
            memberBeanDao.update(memberBean);
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
    }

    @Override
    public void markMemberAsDead(Long memberActualId) {
        try {
            MemberBean memberBean = memberBeanDao.queryBuilder().where().eq(FieldNameConstants.ACTUAL_ID, memberActualId).queryForFirst();
            memberBean.setState(FhsConstants.FHS_MEMBER_STATE_DEAD);
            memberBeanDao.update(memberBean);
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
    }

    @Override
    public void updateMemberPregnantFlag(Long memberActualId, Boolean pregnantFlag) {
        try {
            MemberBean memberBean = memberBeanDao.queryBuilder().where().eq(FieldNameConstants.ACTUAL_ID, memberActualId).queryForFirst();
            memberBean.setIsPregnantFlag(pregnantFlag);
            memberBeanDao.update(memberBean);
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
    }

    @Override
    public void updateMemberLmpDate(Long memberActualId, Date lmpDate) {
        try {
            MemberBean memberBean = memberBeanDao.queryBuilder().where().eq(FieldNameConstants.ACTUAL_ID, memberActualId).queryForFirst();
            memberBean.setLmpDate(lmpDate);
            memberBeanDao.update(memberBean);
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
    }

    @Override
    public void updateFamily(FamilyBean familyBean) {
        try {
            familyBeanDao.update(familyBean);
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
    }

    @Override
    public void deleteNotificationByMemberIdAndNotificationType(Long
                                                                        memberActualId, List<String> notificationTypes) {
        try {
            DeleteBuilder<NotificationBean, Integer> notificationBeanDeleteBuilder = notificationBeanDao.deleteBuilder();
            if (notificationTypes != null && !notificationTypes.isEmpty()) {
                notificationBeanDeleteBuilder.where().eq(FieldNameConstants.MEMBER_ID, memberActualId)
                        .and().in(FieldNameConstants.NOTIFICATION_CODE, notificationTypes);
            } else {
                notificationBeanDeleteBuilder.where().eq(FieldNameConstants.MEMBER_ID, memberActualId);
            }
            notificationBeanDeleteBuilder.delete();
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
    }

    @Override
    public void updateVaccinationGivenForChild(Long memberActualId, String vaccinationGiven) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat(GlobalTypes.DATE_DD_MM_YYYY_FORMAT, Locale.getDefault());
            MemberBean child = memberBeanDao.queryBuilder().where().eq(FieldNameConstants.ACTUAL_ID, memberActualId).queryForFirst();
            StringBuilder stringBuilder = new StringBuilder();
            String immunisationGiven = child.getImmunisationGiven();
            String[] split = vaccinationGiven.split("-");
            if (immunisationGiven != null && immunisationGiven.length() > 0) {
                stringBuilder.append(immunisationGiven);
            }
            for (String string : split) {
                if (string != null && string.contains("/")) {
                    String[] split1 = string.split("/");
                    if (split1[1].equals("T")) {
                        if (stringBuilder.length() > 0) {
                            stringBuilder.append(",");
                        }
                        stringBuilder.append(split1[0].trim());
                        stringBuilder.append("#");
                        stringBuilder.append(sdf.format(new Date(Long.parseLong(split1[2]))));
                    }
                }
            }
            child.setImmunisationGiven(stringBuilder.toString());
            memberBeanDao.update(child);
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
    }

    @Override
    public void updateVaccinationGivenForChild(String uniqueHealthId, String vaccinationGiven) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat(GlobalTypes.DATE_DD_MM_YYYY_FORMAT, Locale.getDefault());
            MemberBean child = memberBeanDao.queryBuilder().where().eq(FieldNameConstants.UNIQUE_HEALTH_ID, uniqueHealthId).queryForFirst();
            StringBuilder stringBuilder = new StringBuilder();
            String immunisationGiven = child.getImmunisationGiven();
            String[] split = vaccinationGiven.split("-");
            if (immunisationGiven != null && immunisationGiven.length() > 0) {
                stringBuilder.append(immunisationGiven);
            }
            for (String string : split) {
                if (string != null && string.contains("/")) {
                    String[] split1 = string.split("/");
                    if (split1[1].equals("T")) {
                        if (stringBuilder.length() > 0) {
                            stringBuilder.append(",");
                        }
                        stringBuilder.append(split1[0].trim());
                        stringBuilder.append("#");
                        stringBuilder.append(sdf.format(new Date(Long.parseLong(split1[2]))));
                    }
                }
            }
            child.setImmunisationGiven(stringBuilder.toString());
            memberBeanDao.update(child);
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
    }

    public void updateVaccinationGivenForChild(String
                                                       uniqueHealthId, Map<String, String> dataMap) {
        try {
            StringBuilder stringBuilder = new StringBuilder();
            // Format pattern for date
            SimpleDateFormat sdf = new SimpleDateFormat(GlobalTypes.DATE_DD_MM_YYYY_FORMAT, Locale.getDefault());
            MemberBean child = null;
            child = memberBeanDao.queryBuilder().where().eq(FieldNameConstants.UNIQUE_HEALTH_ID, uniqueHealthId).queryForFirst();
            for (Map.Entry<String, String> entry : dataMap.entrySet()) {
                String key = entry.getKey();
                String value = entry.getValue();

                // Convert timestamp to date string
                String formattedDate = sdf.format(new Date(Long.parseLong(value)));

                // Append to the result string
                stringBuilder.append(key).append("#").append(formattedDate).append(",");
            }

            // Remove the last comma
            if (stringBuilder.length() > 0) {
                stringBuilder.deleteCharAt(stringBuilder.length() - 1);
            }
            child.setImmunisationGiven(stringBuilder.toString());
            memberBeanDao.update(child);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void markNotificationAsRead(NotificationMobDataBean notificationMobDataBean) {
        try {
            ReadNotificationsBean readNotificationsBean = new ReadNotificationsBean();
            readNotificationsBean.setNotificationId(notificationMobDataBean.getId());
            readNotificationsBeanDao.create(readNotificationsBean);
            sewaService.deleteNotificationByNotificationId(notificationMobDataBean.getId());
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
    }

    @Override
    public String getChildrenCount(Long motherId, boolean total, boolean male, boolean female) {
        List<String> invalidStates = new ArrayList<>();
        invalidStates.addAll(FhsConstants.FHS_ARCHIVED_CRITERIA_MEMBER_STATES);
        invalidStates.addAll(FhsConstants.FHS_DEAD_CRITERIA_MEMBER_STATES);

        try {
            if (total) {
                return String.valueOf(memberBeanDao.queryBuilder().where().eq(FieldNameConstants.MOTHER_ID, motherId)
                        .and().ne(FieldNameConstants.ACTUAL_ID, motherId)
                        .and().notIn(FieldNameConstants.STATE, invalidStates).countOf());
            } else if (male) {
                return String.valueOf(memberBeanDao.queryBuilder().where().eq(FieldNameConstants.MOTHER_ID, motherId)
                        .and().ne(FieldNameConstants.ACTUAL_ID, motherId)
                        .and().eq(FieldNameConstants.GENDER, "M")
                        .and().notIn(FieldNameConstants.STATE, invalidStates).countOf());
            } else if (female) {
                return String.valueOf(memberBeanDao.queryBuilder().where().eq(FieldNameConstants.MOTHER_ID, motherId)
                        .and().ne(FieldNameConstants.ACTUAL_ID, motherId)
                        .and().eq(FieldNameConstants.GENDER, "F")
                        .and().notIn(FieldNameConstants.STATE, invalidStates).countOf());
            }
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return null;
    }

    @Override
    public MemberDataBean getLatestChildByMotherId(Long motherId) {
        List<String> invalidStates = new ArrayList<>();
        invalidStates.addAll(FhsConstants.FHS_ARCHIVED_CRITERIA_MEMBER_STATES);
        invalidStates.addAll(FhsConstants.FHS_DEAD_CRITERIA_MEMBER_STATES);

        MemberDataBean memberDataBean = null;
        try {
            MemberBean latestChild = memberBeanDao.queryBuilder().orderBy(FieldNameConstants.DOB, false)
                    .where().eq(FieldNameConstants.MOTHER_ID, motherId)
                    .and().ne(FieldNameConstants.ACTUAL_ID, motherId)
                    .and().notIn(FieldNameConstants.STATE, invalidStates).queryForFirst();

            if (latestChild != null) {
                memberDataBean = new MemberDataBean(latestChild);
            }
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return memberDataBean;
    }

    @Override
    public String getValueOfListValuesById(String id) {
        if (id != null) {
            try {
                ListValueBean bean = listValueBeanDao.queryBuilder()
                        .where().eq(FieldNameConstants.ID_OF_VALUE, id).queryForFirst();
                if (bean != null) {
                    return bean.getValue();
                }
            } catch (SQLException e) {
                Log.e(TAG, null, e);
            }
        }
        return null;
    }

    @Override
    public String getConstOfListValueById(String id) {
        if (id != null) {
            try {
                ListValueBean bean = listValueBeanDao.queryBuilder()
                        .where().eq(FieldNameConstants.ID_OF_VALUE, id).queryForFirst();
                if (bean != null) {
                    return bean.getConstant();
                }
            } catch (SQLException e) {
                Log.e(TAG, null, e);
            }
        }
        return null;
    }

    @Override
    public Integer getIdOfListValueByConst(String constant) {
        if (constant != null) {
            try {
                ListValueBean bean = listValueBeanDao.queryBuilder()
                        .where().eq(FieldNameConstants.CONSTANT, constant).queryForFirst();
                if (bean != null) {
                    return bean.getIdOfValue();
                }
            } catch (SQLException e) {
                Log.e(TAG, null, e);
            }
        }
        return null;
    }

    @Override
    public Map<String, String> retrieveAshaInfoByAreaId(String areaId) {
        if (areaId != null) {
            try {
                LocationMasterBean locationMasterBean = locationMasterBeanDao.queryBuilder().where().eq(FieldNameConstants.ACTUAL_I_D, areaId).queryForFirst();
                if (locationMasterBean != null) {
                    String fhwDetailString = locationMasterBean.getFhwDetailString();
                    if (fhwDetailString != null) {
                        Type type = new TypeToken<List<Map<String, String>>>() {
                        }.getType();
                        List<Map<String, String>> fhwDetailMapList = new Gson().fromJson(fhwDetailString, type);
                        return fhwDetailMapList.get(0);
                    }
                }
            } catch (SQLException e) {
                Log.e(TAG, null, e);
            }
        }
        return null;
    }

    @Override
    public List<MemberDataBean> retrieveMemberListForRchRegister
            (List<Integer> locationIds, Integer villageId, CharSequence searchString, long limit,
             long offset,
             LinkedHashMap<String, String> qrData) {
        List<MemberDataBean> memberDataBeans = new ArrayList<>();

        try {
            List<String> familyIds = new ArrayList<>();
            List<FamilyBean> familyBeans;

            if (locationIds != null && !locationIds.isEmpty()) {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .in(FieldNameConstants.AREA_ID, locationIds)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            } else {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .eq(FieldNameConstants.LOCATION_ID, villageId)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            }

            for (FamilyBean familyBean : familyBeans) {
                familyIds.add(familyBean.getFamilyId());
            }

            if (!familyIds.isEmpty()) {
                List<MemberBean> memberBeans;
                Where<MemberBean, Integer> where = memberBeanDao.queryBuilder().limit(limit).offset(offset).where();
                Calendar instance = Calendar.getInstance();
                instance.add(Calendar.YEAR, -5);
                Date before5Years = instance.getTime();
                instance = Calendar.getInstance();
                instance.add(Calendar.YEAR, -15);
                Date before15Years = instance.getTime();
                instance = Calendar.getInstance();
                instance.add(Calendar.YEAR, -49);
                Date before49Years = instance.getTime();
                if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") && qrData.containsKey(FieldNameConstants.FAMILY_ID))
                    searchString = qrData.get(FieldNameConstants.FAMILY_ID);
                if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                        Objects.equals(qrData.get(FieldNameConstants.IS_QR_FOR_ABHA), "true")) {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.or(
                                    where.ge(FieldNameConstants.DOB, before5Years),
                                    where.and(
                                            where.le(FieldNameConstants.DOB, before15Years),
                                            where.ge(FieldNameConstants.DOB, before49Years),
                                            where.eq(FieldNameConstants.GENDER, "F"),
                                            where.eq(FieldNameConstants.MARITAL_STATUS, "629")
                                    )
                            ),
                            where.or(
                                    where.like(FieldNameConstants.HEALTH_ID, "%" + qrData.get(FieldNameConstants.HEALTH_ID) + "%"),     //Search By HealthId
                                    where.like(FieldNameConstants.HEALTH_ID_NUMBER, "%" + qrData.get(FieldNameConstants.HEALTH_ID_NUMBER) + "%")     //Search By HealthIdNumber
                            )
                    ).query();
                } else if (searchString != null) {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.or(
                                    where.ge(FieldNameConstants.DOB, before5Years),
                                    where.and(
                                            where.le(FieldNameConstants.DOB, before15Years),
                                            where.ge(FieldNameConstants.DOB, before49Years),
                                            where.eq(FieldNameConstants.GENDER, "F"),
                                            where.eq(FieldNameConstants.MARITAL_STATUS, "629")
                                    )
                            ),
                            where.or(
                                    where.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + searchString + "%"),  //Search By UniqueHealthId
                                    where.like(FieldNameConstants.FIRST_NAME, "%" + searchString + "%"),       //Search By FirstName
                                    where.like(FieldNameConstants.FAMILY_ID, "%" + searchString + "%"),        //Search By FamilyId
                                    where.like(FieldNameConstants.MOBILE_NUMBER, "%" + searchString + "%"),     //Search By MobileNumber
                                    where.like(FieldNameConstants.HEALTH_ID, "%" + searchString + "%"),     //Search By HealthId
                                    where.like(FieldNameConstants.SEARCH_STRING, "%" + searchString + "%"),
                                    where.like(FieldNameConstants.PASSPORT_NUMBER, "%" + searchString + "%")
                            )
                    ).query();
                } else {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.or(
                                    where.ge(FieldNameConstants.DOB, before5Years),
                                    where.and(
                                            where.le(FieldNameConstants.DOB, before15Years),
                                            where.ge(FieldNameConstants.DOB, before49Years),
                                            where.eq(FieldNameConstants.GENDER, "F"),
                                            where.eq(FieldNameConstants.MARITAL_STATUS, "629")
                                    )
                            )
                    ).query();
                }

                for (MemberBean memberBean : memberBeans) {
                    memberDataBeans.add(new MemberDataBean(memberBean));
                }
            }
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return memberDataBeans;
    }

    @Override
    public List<MemberDataBean> retrieveHIVPositiveMembers
            (List<Integer> locationIds, Integer villageId, CharSequence searchString, long limit,
             long offset, LinkedHashMap<String, String> qrData) {
        List<MemberDataBean> memberDataBeans = new ArrayList<>();

        try {
            List<String> familyIds = new ArrayList<>();
            List<FamilyBean> familyBeans;

            if (locationIds != null && !locationIds.isEmpty()) {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .in(FieldNameConstants.AREA_ID, locationIds)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            } else {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .eq(FieldNameConstants.LOCATION_ID, villageId)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            }

            for (FamilyBean familyBean : familyBeans) {
                familyIds.add(familyBean.getFamilyId());
            }
            if (qrData != null && Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                    qrData.containsKey(FieldNameConstants.FAMILY_ID))
                searchString = qrData.get(FieldNameConstants.FAMILY_ID);

            if (!familyIds.isEmpty()) {
                List<MemberBean> memberBeans;
                Where<MemberBean, Integer> where = memberBeanDao.queryBuilder().limit(limit).offset(offset).orderBy(FieldNameConstants.DOB, false).where();

                if (qrData != null && Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                        Objects.equals(qrData.get(FieldNameConstants.IS_QR_FOR_ABHA), "true")) {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.eq(FieldNameConstants.GENDER, GlobalTypes.FEMALE),
                            where.eq(FieldNameConstants.IS_PREGNANT_FLAG, Boolean.TRUE),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.like(FieldNameConstants.IS_HIV_POSITIVE, "%POSITIVE%"),
                            where.like(FieldNameConstants.FAMILY_ID, "%" + qrData.get(FieldNameConstants.FAMILY_ID) + "%")     //Search By HealthId
                    ).query();
                } else if (searchString != null) {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.eq(FieldNameConstants.GENDER, GlobalTypes.FEMALE),
                            where.eq(FieldNameConstants.IS_PREGNANT_FLAG, Boolean.TRUE),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.like(FieldNameConstants.IS_HIV_POSITIVE, "%POSITIVE%"),
                            where.or(where.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + searchString + "%"),   //Search By UniqueHealthId
                                    where.like(FieldNameConstants.FIRST_NAME, "%" + searchString + "%"),         //Search By FirstName
                                    where.like(FieldNameConstants.MIDDLE_NAME, "%" + searchString + "%"),       //Search By MiddleName
                                    where.like(FieldNameConstants.LAST_NAME, "%" + searchString + "%"),         //Search By LastName
                                    where.like(FieldNameConstants.FAMILY_ID, "%" + searchString + "%"),          //Search By FamilyId
                                    where.like(FieldNameConstants.MOBILE_NUMBER, "%" + searchString + "%"),       //Search By MobileNumber
                                    where.like(FieldNameConstants.NRC_NUMBER, "%" + searchString + "%"),    //Search by nrc
                                    where.like(FieldNameConstants.HEALTH_ID, "%" + searchString + "%"),       //Search By HealthId,
                                    where.like(FieldNameConstants.SEARCH_STRING, "%" + searchString + "%"),
                                    where.like(FieldNameConstants.PASSPORT_NUMBER, "%" + searchString + "%")
                            )
                    ).query();
                } else {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.eq(FieldNameConstants.GENDER, GlobalTypes.FEMALE),
                            where.eq(FieldNameConstants.IS_PREGNANT_FLAG, Boolean.TRUE),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.like(FieldNameConstants.IS_HIV_POSITIVE, "%POSITIVE%")
                    ).query();
                }


                for (MemberBean memberBean : memberBeans) {
                    memberDataBeans.add(new MemberDataBean(memberBean));
                }
            }
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return memberDataBeans;
    }

    @Override
    public List<MemberDataBean> retrieveEMTCTMembers(List<Integer> locationIds, Integer
            villageId, CharSequence searchString, long limit, long offset, LinkedHashMap<
            String, String> qrData) {
        List<MemberDataBean> memberDataBeans = new ArrayList<>();

        try {
            List<String> familyIds = new ArrayList<>();
            List<String> hivPositiveMotherIds = new ArrayList<>();
            List<String> hivPositiveMotherUUIDs = new ArrayList<>();
            List<FamilyBean> familyBeans;

            if (locationIds != null && !locationIds.isEmpty()) {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .in(FieldNameConstants.AREA_ID, locationIds)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            } else {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .eq(FieldNameConstants.LOCATION_ID, villageId)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            }

            for (FamilyBean familyBean : familyBeans) {
                familyIds.add(familyBean.getFamilyId());
            }
            if (qrData != null && Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                    qrData.containsKey(FieldNameConstants.FAMILY_ID))
                searchString = qrData.get(FieldNameConstants.FAMILY_ID);

            if (!familyIds.isEmpty()) {
                Calendar calendar = Calendar.getInstance();
                calendar.add(Calendar.YEAR, -1);
                List<MemberBean> memberBeans;
                Where<MemberBean, Integer> where = memberBeanDao.queryBuilder().limit(limit).offset(offset).orderBy(FieldNameConstants.DOB, false).where();

                if (qrData != null && Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                        Objects.equals(qrData.get(FieldNameConstants.IS_QR_FOR_ABHA), "true")) {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.eq(FieldNameConstants.GENDER, "F"),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.like(FieldNameConstants.IS_HIV_POSITIVE, "%POSITIVE%"),
                            where.like(FieldNameConstants.FAMILY_ID, "%" + qrData.get(FieldNameConstants.FAMILY_ID) + "%")     //Search By HealthId
                    ).query();
                } else if (searchString != null) {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.eq(FieldNameConstants.GENDER, "F"),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.like(FieldNameConstants.IS_HIV_POSITIVE, "%POSITIVE%"),
                            where.or(where.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + searchString + "%"),   //Search By UniqueHealthId
                                    where.like(FieldNameConstants.FIRST_NAME, "%" + searchString + "%"),         //Search By FirstName
                                    where.like(FieldNameConstants.MIDDLE_NAME, "%" + searchString + "%"),       //Search By MiddleName
                                    where.like(FieldNameConstants.LAST_NAME, "%" + searchString + "%"),         //Search By LastName
                                    where.like(FieldNameConstants.FAMILY_ID, "%" + searchString + "%"),          //Search By FamilyId
                                    where.like(FieldNameConstants.MOBILE_NUMBER, "%" + searchString + "%"),       //Search By MobileNumber
                                    where.like(FieldNameConstants.NRC_NUMBER, "%" + searchString + "%"),    //Search by nrc
                                    where.like(FieldNameConstants.HEALTH_ID, "%" + searchString + "%"),       //Search By HealthId,
                                    where.like(FieldNameConstants.SEARCH_STRING, "%" + searchString + "%"),
                                    where.like(FieldNameConstants.PASSPORT_NUMBER, "%" + searchString + "%")
                            )
                    ).query();
                } else {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.eq(FieldNameConstants.GENDER, "F"),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.like(FieldNameConstants.IS_HIV_POSITIVE, "%POSITIVE%")
                    ).query();
                }

                for (MemberBean memberBean : memberBeans) {
                    if (memberBean.getActualId() != null) {
                        hivPositiveMotherIds.add(memberBean.getActualId());
                    } else {
                        hivPositiveMotherUUIDs.add(memberBean.getMemberUuid());
                    }
                }

                Where<MemberBean, Integer> whereForChild = memberBeanDao.queryBuilder().where();
                List<MemberBean> allChildrenOfMother = whereForChild.and(
                        whereForChild.or(
                                whereForChild.in(FieldNameConstants.MOTHER_ID, hivPositiveMotherIds),
                                whereForChild.in(FieldNameConstants.MOTHER_UUID, hivPositiveMotherUUIDs)
                        ),
                        whereForChild.ge(FieldNameConstants.DOB, calendar.getTime()),
                        whereForChild.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES)
                ).query();
                memberDataBeans.addAll(convertToMemberDataBeanList(allChildrenOfMother));


            }
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return memberDataBeans;
    }

    public List<MemberDataBean> convertToMemberDataBeanList(List<MemberBean> memberBeans) {
        List<MemberDataBean> memberDataBeans = new ArrayList<>();
        for (MemberBean memberBean : memberBeans) {
            MemberDataBean memberDataBean = new MemberDataBean(memberBean);
            memberDataBeans.add(memberDataBean);
        }
        return memberDataBeans;
    }

    @Override
    public List<MemberDataBean> retrieveMembersForTBScreening
            (List<Integer> locationIds, Integer villageId, CharSequence searchString, long limit,
             long offset, LinkedHashMap<String, String> qrData) {
        List<MemberDataBean> memberDataBeans = new ArrayList<>();

        try {
            List<String> familyIds = new ArrayList<>();
            List<FamilyBean> familyBeans;

            if (locationIds != null && !locationIds.isEmpty()) {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .in(FieldNameConstants.AREA_ID, locationIds)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            } else {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .eq(FieldNameConstants.LOCATION_ID, villageId)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            }

            for (FamilyBean familyBean : familyBeans) {
                familyIds.add(familyBean.getFamilyId());
            }
            if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                    qrData.containsKey(FieldNameConstants.FAMILY_ID))
                searchString = qrData.get(FieldNameConstants.FAMILY_ID);

            if (!familyIds.isEmpty()) {
                List<MemberBean> memberBeans;
                Where<MemberBean, Integer> where = memberBeanDao.queryBuilder().limit(limit).offset(offset).orderBy(FieldNameConstants.DOB, false).where();

                if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                        Objects.equals(qrData.get(FieldNameConstants.IS_QR_FOR_ABHA), "true")) {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.or(
                                    where.isNull(FieldNameConstants.IS_TB_CURED),
                                    where.eq(FieldNameConstants.IS_TB_CURED, Boolean.TRUE)
                            ),
                            where.or(
                                    where.isNull(FieldNameConstants.IS_TB_SUSPECTED),
                                    where.eq(FieldNameConstants.IS_TB_SUSPECTED, Boolean.FALSE)
                            ),
                            where.like(FieldNameConstants.FAMILY_ID, "%" + qrData.get(FieldNameConstants.FAMILY_ID) + "%")
                    ).query();
                } else if (searchString != null) {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.or(
                                    where.isNull(FieldNameConstants.IS_TB_CURED),
                                    where.eq(FieldNameConstants.IS_TB_CURED, Boolean.TRUE)
                            ),
                            where.or(
                                    where.isNull(FieldNameConstants.IS_TB_SUSPECTED),
                                    where.eq(FieldNameConstants.IS_TB_SUSPECTED, Boolean.FALSE)
                            ),
                            where.or(where.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + searchString + "%"),   //Search By UniqueHealthId
                                    where.like(FieldNameConstants.FIRST_NAME, "%" + searchString + "%"),         //Search By FirstName
                                    where.like(FieldNameConstants.MIDDLE_NAME, "%" + searchString + "%"),       //Search By MiddleName
                                    where.like(FieldNameConstants.LAST_NAME, "%" + searchString + "%"),         //Search By LastName
                                    where.like(FieldNameConstants.FAMILY_ID, "%" + searchString + "%"),          //Search By FamilyId
                                    where.like(FieldNameConstants.MOBILE_NUMBER, "%" + searchString + "%"),       //Search By MobileNumber
                                    where.like(FieldNameConstants.NRC_NUMBER, "%" + searchString + "%"),    //Search by nrc
                                    where.like(FieldNameConstants.HEALTH_ID, "%" + searchString + "%"),       //Search By HealthId,
                                    where.like(FieldNameConstants.SEARCH_STRING, "%" + searchString + "%"),
                                    where.like(FieldNameConstants.PASSPORT_NUMBER, "%" + searchString + "%")
                            )
                    ).query();
                } else {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.or(
                                    where.isNull(FieldNameConstants.IS_TB_CURED),
                                    where.eq(FieldNameConstants.IS_TB_CURED, Boolean.TRUE)
                            ),
                            where.or(
                                    where.isNull(FieldNameConstants.IS_TB_SUSPECTED),
                                    where.eq(FieldNameConstants.IS_TB_SUSPECTED, Boolean.FALSE)
                            )
                    ).query();
                }


                for (MemberBean memberBean : memberBeans) {
                    memberDataBeans.add(new MemberDataBean(memberBean));
                }
            }
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return memberDataBeans;
    }

    @Override
    public List<MemberDataBean> retrieveMembersForMalariaScreening
            (List<Integer> locationIds, Integer villageId, CharSequence searchString, long limit,
             long offset, LinkedHashMap<String, String> qrData) {
        List<MemberDataBean> memberDataBeans = new ArrayList<>();

        try {
            List<String> familyIds = new ArrayList<>();
            List<FamilyBean> familyBeans;

            if (locationIds != null && !locationIds.isEmpty()) {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .in(FieldNameConstants.AREA_ID, locationIds)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            } else {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .eq(FieldNameConstants.LOCATION_ID, villageId)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            }

            for (FamilyBean familyBean : familyBeans) {
                familyIds.add(familyBean.getFamilyId());
            }
            if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                    qrData.containsKey(FieldNameConstants.FAMILY_ID))
                searchString = qrData.get(FieldNameConstants.FAMILY_ID);

            if (!familyIds.isEmpty()) {
                List<MemberBean> memberBeans;
                Where<MemberBean, Integer> where = memberBeanDao.queryBuilder().limit(limit).offset(offset).orderBy(FieldNameConstants.DOB, false).where();

                if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                        Objects.equals(qrData.get(FieldNameConstants.IS_QR_FOR_ABHA), "true")) {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.or(
                                    where.isNull(FieldNameConstants.RDT_STATUS),
                                    where.eq(FieldNameConstants.RDT_STATUS, RchConstants.TEST_NOT_DONE),
                                    where.eq(FieldNameConstants.RDT_STATUS, RchConstants.TEST_NEGATIVE)
                            ),
                            where.like(FieldNameConstants.FAMILY_ID, "%" + qrData.get(FieldNameConstants.FAMILY_ID) + "%")
                    ).query();
                } else if (searchString != null) {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.or(
                                    where.isNull(FieldNameConstants.RDT_STATUS),
                                    where.eq(FieldNameConstants.RDT_STATUS, RchConstants.TEST_NOT_DONE),
                                    where.eq(FieldNameConstants.RDT_STATUS, RchConstants.TEST_NEGATIVE)
                            ),
                            where.or(
                                    where.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + searchString + "%"),   //Search By UniqueHealthId
                                    where.like(FieldNameConstants.FIRST_NAME, "%" + searchString + "%"),         //Search By FirstName
                                    where.like(FieldNameConstants.MIDDLE_NAME, "%" + searchString + "%"),       //Search By MiddleName
                                    where.like(FieldNameConstants.LAST_NAME, "%" + searchString + "%"),         //Search By LastName
                                    where.like(FieldNameConstants.FAMILY_ID, "%" + searchString + "%"),          //Search By FamilyId
                                    where.like(FieldNameConstants.MOBILE_NUMBER, "%" + searchString + "%"),       //Search By MobileNumber
                                    where.like(FieldNameConstants.NRC_NUMBER, "%" + searchString + "%"),    //Search by nrc
                                    where.like(FieldNameConstants.HEALTH_ID, "%" + searchString + "%"),       //Search By HealthId,
                                    where.like(FieldNameConstants.SEARCH_STRING, "%" + searchString + "%"),
                                    where.like(FieldNameConstants.PASSPORT_NUMBER, "%" + searchString + "%")
                            )
                    ).query();
                } else {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.or(
                                    where.isNull(FieldNameConstants.RDT_STATUS),
                                    where.eq(FieldNameConstants.RDT_STATUS, RchConstants.TEST_NOT_DONE),
                                    where.eq(FieldNameConstants.RDT_STATUS, RchConstants.TEST_NEGATIVE)
                            )
                    ).query();
                }


                for (MemberBean memberBean : memberBeans) {
                    memberDataBeans.add(new MemberDataBean(memberBean));
                }
            }
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return memberDataBeans;
    }

    @Override
    public List<MemberDataBean> retrievePositiveMembersForMalaria
            (List<Integer> locationIds, Integer villageId, CharSequence searchString, long limit,
             long offset, LinkedHashMap<String, String> qrData) {
        List<MemberDataBean> memberDataBeans = new ArrayList<>();

        try {
            List<String> familyIds = new ArrayList<>();
            List<FamilyBean> familyBeans;

            if (locationIds != null && !locationIds.isEmpty()) {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .in(FieldNameConstants.AREA_ID, locationIds)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            } else {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .eq(FieldNameConstants.LOCATION_ID, villageId)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            }

            for (FamilyBean familyBean : familyBeans) {
                familyIds.add(familyBean.getFamilyId());
            }
            if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                    qrData.containsKey(FieldNameConstants.FAMILY_ID))
                searchString = qrData.get(FieldNameConstants.FAMILY_ID);

            if (!familyIds.isEmpty()) {
                List<MemberBean> memberBeans;
                Where<MemberBean, Integer> where = memberBeanDao.queryBuilder().limit(limit).offset(offset).orderBy(FieldNameConstants.DOB, false).where();

                if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                        Objects.equals(qrData.get(FieldNameConstants.IS_QR_FOR_ABHA), "true")) {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.or(
                                    where.isNotNull(FieldNameConstants.RDT_STATUS),
                                    where.eq(FieldNameConstants.RDT_STATUS, RchConstants.TEST_POSITIVE)
                            ),
                            where.like(FieldNameConstants.FAMILY_ID, "%" + qrData.get(FieldNameConstants.FAMILY_ID) + "%")
                    ).query();
                } else if (searchString != null) {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.or(
                                    where.isNotNull(FieldNameConstants.RDT_STATUS),
                                    where.eq(FieldNameConstants.RDT_STATUS, RchConstants.TEST_POSITIVE)
                            ),
                            where.or(
                                    where.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + searchString + "%"),   //Search By UniqueHealthId
                                    where.like(FieldNameConstants.FIRST_NAME, "%" + searchString + "%"),         //Search By FirstName
                                    where.like(FieldNameConstants.MIDDLE_NAME, "%" + searchString + "%"),       //Search By MiddleName
                                    where.like(FieldNameConstants.LAST_NAME, "%" + searchString + "%"),         //Search By LastName
                                    where.like(FieldNameConstants.FAMILY_ID, "%" + searchString + "%"),          //Search By FamilyId
                                    where.like(FieldNameConstants.MOBILE_NUMBER, "%" + searchString + "%"),       //Search By MobileNumber
                                    where.like(FieldNameConstants.NRC_NUMBER, "%" + searchString + "%"),    //Search by nrc
                                    where.like(FieldNameConstants.HEALTH_ID, "%" + searchString + "%"),       //Search By HealthId,
                                    where.like(FieldNameConstants.SEARCH_STRING, "%" + searchString + "%"),
                                    where.like(FieldNameConstants.PASSPORT_NUMBER, "%" + searchString + "%")
                            )
                    ).query();
                } else {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.or(
                                    where.isNotNull(FieldNameConstants.RDT_STATUS),
                                    where.eq(FieldNameConstants.RDT_STATUS, RchConstants.TEST_POSITIVE)
                            )
                    ).query();
                }


                for (MemberBean memberBean : memberBeans) {
                    memberDataBeans.add(new MemberDataBean(memberBean));
                }
            }
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return memberDataBeans;
    }

    @Override
    public List<MemberDataBean> retrieveMembersForHIVScreening
            (List<Integer> locationIds, Integer villageId, CharSequence searchString, long limit,
             long offset, LinkedHashMap<String, String> qrData) {
        List<MemberDataBean> memberDataBeans = new ArrayList<>();

        try {
            List<String> familyIds = new ArrayList<>();
            List<FamilyBean> familyBeans;

            if (locationIds != null && !locationIds.isEmpty()) {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .in(FieldNameConstants.AREA_ID, locationIds)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            } else {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .eq(FieldNameConstants.LOCATION_ID, villageId)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            }

            for (FamilyBean familyBean : familyBeans) {
                familyIds.add(familyBean.getFamilyId());
            }
            if (qrData != null && Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                    qrData.containsKey(FieldNameConstants.FAMILY_ID))
                searchString = qrData.get(FieldNameConstants.FAMILY_ID);

            if (!familyIds.isEmpty()) {
                List<MemberBean> memberBeans;
                Where<MemberBean, Integer> where = memberBeanDao.queryBuilder().limit(limit).offset(offset).orderBy(FieldNameConstants.DOB, false).where();

                if (qrData != null && Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                        Objects.equals(qrData.get(FieldNameConstants.IS_QR_FOR_ABHA), "true")) {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.or(
                                    where.isNull(FieldNameConstants.IS_HIV_POSITIVE),
                                    where.eq(FieldNameConstants.IS_HIV_POSITIVE, RchConstants.TEST_NOT_DONE),
                                    where.eq(FieldNameConstants.IS_HIV_POSITIVE, RchConstants.TEST_NEGATIVE)
                            ),
                            where.like(FieldNameConstants.FAMILY_ID, "%" + qrData.get(FieldNameConstants.FAMILY_ID) + "%")
                    ).query();
                } else if (searchString != null) {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.or(
                                    where.isNull(FieldNameConstants.IS_HIV_POSITIVE),
                                    where.eq(FieldNameConstants.IS_HIV_POSITIVE, RchConstants.TEST_NOT_DONE),
                                    where.eq(FieldNameConstants.IS_HIV_POSITIVE, RchConstants.TEST_NEGATIVE)
                            ),
                            where.or(
                                    where.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + searchString + "%"),   //Search By UniqueHealthId
                                    where.like(FieldNameConstants.FIRST_NAME, "%" + searchString + "%"),         //Search By FirstName
                                    where.like(FieldNameConstants.MIDDLE_NAME, "%" + searchString + "%"),       //Search By MiddleName
                                    where.like(FieldNameConstants.LAST_NAME, "%" + searchString + "%"),         //Search By LastName
                                    where.like(FieldNameConstants.FAMILY_ID, "%" + searchString + "%"),          //Search By FamilyId
                                    where.like(FieldNameConstants.MOBILE_NUMBER, "%" + searchString + "%"),       //Search By MobileNumber
                                    where.like(FieldNameConstants.NRC_NUMBER, "%" + searchString + "%"),    //Search by nrc
                                    where.like(FieldNameConstants.HEALTH_ID, "%" + searchString + "%"),       //Search By HealthId,
                                    where.like(FieldNameConstants.SEARCH_STRING, "%" + searchString + "%"),
                                    where.like(FieldNameConstants.PASSPORT_NUMBER, "%" + searchString + "%")
                            )
                    ).query();
                } else {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.or(
                                    where.isNull(FieldNameConstants.IS_HIV_POSITIVE),
                                    where.eq(FieldNameConstants.IS_HIV_POSITIVE, RchConstants.TEST_NOT_DONE),
                                    where.eq(FieldNameConstants.IS_HIV_POSITIVE, RchConstants.TEST_NEGATIVE)
                            )
                    ).query();
                }


                for (MemberBean memberBean : memberBeans) {
                    memberDataBeans.add(new MemberDataBean(memberBean));
                }
            }
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return memberDataBeans;
    }


    @Override
    public List<MemberDataBean> retrieveMembersForKnownScreening
            (List<Integer> locationIds, Integer villageId, CharSequence searchString, long limit,
             long offset, LinkedHashMap<String, String> qrData) {
        List<MemberDataBean> memberDataBeans = new ArrayList<>();

        try {
            List<String> familyIds = new ArrayList<>();
            List<FamilyBean> familyBeans;

            if (locationIds != null && !locationIds.isEmpty()) {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .in(FieldNameConstants.AREA_ID, locationIds)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            } else {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .eq(FieldNameConstants.LOCATION_ID, villageId)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            }

            for (FamilyBean familyBean : familyBeans) {
                familyIds.add(familyBean.getFamilyId());
            }
            if (qrData != null && Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                    qrData.containsKey(FieldNameConstants.FAMILY_ID))
                searchString = qrData.get(FieldNameConstants.FAMILY_ID);

            if (!familyIds.isEmpty()) {
                List<MemberBean> memberBeans;
                Where<MemberBean, Integer> where = memberBeanDao.queryBuilder().limit(limit).offset(offset).orderBy(FieldNameConstants.DOB, false).where();

                if (qrData != null && Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                        Objects.equals(qrData.get(FieldNameConstants.IS_QR_FOR_ABHA), "true")) {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.or(
                                    where.isNull(FieldNameConstants.IS_PREGNANT_FLAG),
                                    where.eq(FieldNameConstants.IS_PREGNANT_FLAG, Boolean.FALSE)
                            ),
                            where.and(
                                    where.isNotNull(FieldNameConstants.IS_HIV_POSITIVE),
                                    where.eq(FieldNameConstants.IS_HIV_POSITIVE, RchConstants.TEST_POSITIVE)
                            ),
                            where.like(FieldNameConstants.FAMILY_ID, "%" + qrData.get(FieldNameConstants.FAMILY_ID) + "%")
                    ).query();
                } else if (searchString != null) {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.or(
                                    where.isNull(FieldNameConstants.IS_PREGNANT_FLAG),
                                    where.eq(FieldNameConstants.IS_PREGNANT_FLAG, Boolean.FALSE)
                            ),
                            where.and(
                                    where.isNotNull(FieldNameConstants.IS_HIV_POSITIVE),
                                    where.eq(FieldNameConstants.IS_HIV_POSITIVE, RchConstants.TEST_POSITIVE)
                            ),
                            where.or(
                                    where.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + searchString + "%"),   //Search By UniqueHealthId
                                    where.like(FieldNameConstants.FIRST_NAME, "%" + searchString + "%"),         //Search By FirstName
                                    where.like(FieldNameConstants.MIDDLE_NAME, "%" + searchString + "%"),       //Search By MiddleName
                                    where.like(FieldNameConstants.LAST_NAME, "%" + searchString + "%"),         //Search By LastName
                                    where.like(FieldNameConstants.FAMILY_ID, "%" + searchString + "%"),          //Search By FamilyId
                                    where.like(FieldNameConstants.MOBILE_NUMBER, "%" + searchString + "%"),       //Search By MobileNumber
                                    where.like(FieldNameConstants.NRC_NUMBER, "%" + searchString + "%"),    //Search by nrc
                                    where.like(FieldNameConstants.HEALTH_ID, "%" + searchString + "%"),       //Search By HealthId,
                                    where.like(FieldNameConstants.SEARCH_STRING, "%" + searchString + "%"),
                                    where.like(FieldNameConstants.PASSPORT_NUMBER, "%" + searchString + "%")
                            )
                    ).query();
                } else {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.or(
                                    where.isNull(FieldNameConstants.IS_PREGNANT_FLAG),
                                    where.eq(FieldNameConstants.IS_PREGNANT_FLAG, Boolean.FALSE)
                            ),
                            where.and(
                                    where.isNotNull(FieldNameConstants.IS_HIV_POSITIVE),
                                    where.eq(FieldNameConstants.IS_HIV_POSITIVE, RchConstants.TEST_POSITIVE)
                            )
                    ).query();
                }


                for (MemberBean memberBean : memberBeans) {
                    memberDataBeans.add(new MemberDataBean(memberBean));
                }
            }
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return memberDataBeans;
    }


    @Override
    public List<MemberDataBean> retrieveMembersForChipScreening
            (List<Integer> locationIds, Integer villageId, CharSequence searchString, long limit,
             long offset, LinkedHashMap<String, String> qrData) {
        List<MemberDataBean> memberDataBeans = new ArrayList<>();

        try {
            List<String> familyIds = new ArrayList<>();
            List<FamilyBean> familyBeans;

            if (locationIds != null && !locationIds.isEmpty()) {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .in(FieldNameConstants.AREA_ID, locationIds)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            } else {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .eq(FieldNameConstants.LOCATION_ID, villageId)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            }

            for (FamilyBean familyBean : familyBeans) {
                familyIds.add(familyBean.getFamilyId());
            }
            if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                    qrData.containsKey(FieldNameConstants.FAMILY_ID))
                searchString = qrData.get(FieldNameConstants.FAMILY_ID);

            if (!familyIds.isEmpty()) {
                List<MemberBean> memberBeans;
                Calendar calendar = Calendar.getInstance();
                calendar.add(Calendar.YEAR, -12);
                Where<MemberBean, Integer> where = memberBeanDao.queryBuilder().limit(limit).offset(offset).orderBy(FieldNameConstants.DOB, false).where();
                if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                        Objects.equals(qrData.get(FieldNameConstants.IS_QR_FOR_ABHA), "true")) {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.lt(FieldNameConstants.DOB, calendar.getTime())
                    ).query();
                } else if (searchString != null) {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.lt(FieldNameConstants.DOB, calendar.getTime()),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.or(where.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + searchString + "%"),   //Search By UniqueHealthId
                                    where.like(FieldNameConstants.FIRST_NAME, "%" + searchString + "%"),         //Search By FirstName
                                    where.like(FieldNameConstants.MIDDLE_NAME, "%" + searchString + "%"),       //Search By MiddleName
                                    where.like(FieldNameConstants.LAST_NAME, "%" + searchString + "%"),         //Search By LastName
                                    where.like(FieldNameConstants.FAMILY_ID, "%" + searchString + "%"),          //Search By FamilyId
                                    where.like(FieldNameConstants.MOBILE_NUMBER, "%" + searchString + "%"),       //Search By MobileNumber
                                    where.like(FieldNameConstants.NRC_NUMBER, "%" + searchString + "%"),    //Search by nrc
                                    where.like(FieldNameConstants.HEALTH_ID, "%" + searchString + "%"),       //Search By HealthId,
                                    where.like(FieldNameConstants.SEARCH_STRING, "%" + searchString + "%"),
                                    where.like(FieldNameConstants.PASSPORT_NUMBER, "%" + searchString + "%")
                            )
                    ).query();
                } else {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.lt(FieldNameConstants.DOB, calendar.getTime())
                    ).query();
                }


                for (MemberBean memberBean : memberBeans) {
                    memberDataBeans.add(new MemberDataBean(memberBean));
                }
            }
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return memberDataBeans;
    }

    public List<MemberDataBean> retrieveMembersForPhoneVerificationByFhsr(Long locationId, String searchString, long limit, long offset, LinkedHashMap<
            String, String> qrData) {
        List<MemberDataBean> memberDataBeans = new ArrayList<>();

        try {
            List<FamilyBean> familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                    .in(FieldNameConstants.AREA_ID, locationId)
                    .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();

            List<String> familyIds = new ArrayList<>();
            for (FamilyBean familyBean : familyBeans) {
                familyIds.add(familyBean.getFamilyId());
            }


            if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                    qrData.containsKey(FieldNameConstants.FAMILY_ID))
                searchString = qrData.get(FieldNameConstants.FAMILY_ID);

            if (!familyIds.isEmpty()) {
                List<MemberBean> memberBeans;
                Where<MemberBean, Integer> where = memberBeanDao.queryBuilder().limit(limit).offset(offset).orderBy(FieldNameConstants.EDD, true).where();

                if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                        Objects.equals(FieldNameConstants.IS_QR_FOR_ABHA, "true")) {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.eq(FieldNameConstants.IS_PREGNANT_FLAG, Boolean.TRUE),
                            where.or(
                                    where.isNull(FieldNameConstants.FHSR_PHONE_VERIFIED),
                                    where.eq(FieldNameConstants.FHSR_PHONE_VERIFIED, Boolean.FALSE)
                            ),
                            where.or(
                                    where.like(FieldNameConstants.HEALTH_ID, "%" + qrData.get(FieldNameConstants.HEALTH_ID) + "%"),
                                    where.like(FieldNameConstants.HEALTH_ID_NUMBER, "%" + qrData.get(FieldNameConstants.HEALTH_ID_NUMBER) + "%")
                            )
                    ).query();
                } else if (searchString != null) {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.eq(FieldNameConstants.IS_PREGNANT_FLAG, Boolean.TRUE),
                            where.or(
                                    where.isNull(FieldNameConstants.FHSR_PHONE_VERIFIED),
                                    where.eq(FieldNameConstants.FHSR_PHONE_VERIFIED, Boolean.FALSE)
                            ),
                            where.or(
                                    where.like(FieldNameConstants.UNIQUE_HEALTH_ID, "%" + searchString + "%"),  //Search By UniqueHealthId
                                    where.like(FieldNameConstants.FIRST_NAME, "%" + searchString + "%"),       //Search By FirstName
                                    where.like(FieldNameConstants.FAMILY_ID, "%" + searchString + "%"),        //Search By FamilyId
                                    where.like(FieldNameConstants.MOBILE_NUMBER, "%" + searchString + "%"), //Search By MobileNumber
                                    where.like(FieldNameConstants.PASSPORT_NUMBER, "%" + searchString + "%")
                            )
                    ).query();
                } else {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.eq(FieldNameConstants.IS_PREGNANT_FLAG, Boolean.TRUE),
                            where.or(
                                    where.isNull(FieldNameConstants.FHSR_PHONE_VERIFIED),
                                    where.eq(FieldNameConstants.FHSR_PHONE_VERIFIED, Boolean.FALSE)
                            )
                    ).query();
                }

                List<MemberDataBean> membersWithEddNotNull = new ArrayList<>();
                List<MemberDataBean> membersWithEddNull = new ArrayList<>();

                for (MemberBean memberBean : memberBeans) {
                    if (memberBean.getGender() != null && memberBean.getGender().equals(GlobalTypes.FEMALE)
                            && Boolean.TRUE.equals(memberBean.getIsPregnantFlag())) {
                        if (memberBean.getEdd() != null) {
                            membersWithEddNotNull.add(new MemberDataBean(memberBean));
                        } else {
                            membersWithEddNull.add(new MemberDataBean(memberBean));
                        }
                    }
                }

                memberDataBeans.addAll(membersWithEddNotNull);
                memberDataBeans.addAll(membersWithEddNull);
            }
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return memberDataBeans;
    }

    @Override
    public long getMobileNumberCount(String mobileNumber) {
        long count = 0;
        try {
            Set<String> hashSet = new HashSet<>();
            List<MemberBean> members = memberBeanDao.queryBuilder().where().eq(FieldNameConstants.MOBILE_NUMBER, mobileNumber).query();
            for (MemberBean member : members) {
                hashSet.add(member.getFamilyId());
            }
            count = hashSet.size();
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return count;
    }

    public MemberPregnancyStatusBean retrievePregnancyStatusBeanByMemberId(Long memberId) {
        try {
            return memberPregnancyStatusBeanDao.queryBuilder().where().eq(FieldNameConstants.MEMBER_ID, memberId).queryForFirst();
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return null;
    }

    @Override
    public List<MemberBean> retrieveFamilyMembersContactListByMember(String familyId, String
            memberId) {
        try {
            return memberBeanDao.queryBuilder().selectColumns(FieldNameConstants.FIRST_NAME, FieldNameConstants.MIDDLE_NAME,
                            FieldNameConstants.LAST_NAME, FieldNameConstants.MOBILE_NUMBER)
                    .where().eq(FieldNameConstants.FAMILY_ID, familyId)
                    .and().isNotNull(FieldNameConstants.MOBILE_NUMBER)
                    .and().notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES)
                    .and().ne(FieldNameConstants.ACTUAL_ID, memberId).query();
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
        return new ArrayList<>();
    }

    @Override
    public List<MemberDataBean> retrieveNewlyWedCouples(List<Integer> locationIds, Integer
            villageId, CharSequence searchString, long limit, long offset, LinkedHashMap<
            String, String> qrData) {
        List<MemberDataBean> memberDataBeans = new ArrayList<>();

        try {
            List<String> familyIds = new ArrayList<>();
            List<FamilyBean> familyBeans;

            if (locationIds != null && !locationIds.isEmpty()) {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .in(FieldNameConstants.AREA_ID, locationIds)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            } else {
                familyBeans = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where()
                        .eq(FieldNameConstants.LOCATION_ID, villageId)
                        .and().in(FieldNameConstants.STATE, FhsConstants.FHS_ACTIVE_CRITERIA_FAMILY_STATES).query();
            }

            for (FamilyBean familyBean : familyBeans) {
                familyIds.add(familyBean.getFamilyId());
            }

            if (!familyIds.isEmpty()) {
                List<MemberBean> memberBeans;
                Calendar calendar = Calendar.getInstance();
                calendar.add(Calendar.YEAR, -15);
                Date dateBefore18Years = calendar.getTime();
                calendar.add(Calendar.YEAR, -34);
                Date dateBefore45Years = calendar.getTime();
                calendar = Calendar.getInstance();
                UtilBean.clearTimeFromDate(calendar);
                calendar.add(Calendar.YEAR, -1);
                Date dateBefore1Year = calendar.getTime();
                Where<MemberBean, Integer> where = memberBeanDao.queryBuilder().limit(limit).offset(offset).where();
                if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                        qrData.containsKey(FieldNameConstants.FAMILY_ID))
                    searchString = qrData.get(FieldNameConstants.FAMILY_ID);
                if (Objects.equals(qrData.get(FieldNameConstants.IS_QR_SCAN), "true") &&
                        Objects.equals(qrData.get(FieldNameConstants.IS_QR_FOR_ABHA), "true")) {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.eq(FieldNameConstants.GENDER, "F"),
                            where.eq(FieldNameConstants.MARITAL_STATUS, "629"),
                            where.and(
                                    where.isNotNull(FieldNameConstants.DATE_OF_WEDDING),
                                    where.ge(FieldNameConstants.DATE_OF_WEDDING, dateBefore1Year)
                            ),
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
                                    where.like(FieldNameConstants.HEALTH_ID, "%" + qrData.get(FieldNameConstants.HEALTH_ID) + "%"),      //Search By HealthId
                                    where.like(FieldNameConstants.HEALTH_ID_NUMBER, "%" + qrData.get(FieldNameConstants.HEALTH_ID_NUMBER) + "%")      //Search By HealthIdNumber
                            )
                    ).query();
                } else if (searchString != null) {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.eq(FieldNameConstants.GENDER, "F"),
                            where.eq(FieldNameConstants.MARITAL_STATUS, "629"),
                            where.and(
                                    where.isNotNull(FieldNameConstants.DATE_OF_WEDDING),
                                    where.ge(FieldNameConstants.DATE_OF_WEDDING, dateBefore1Year)
                            ),
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
                                    where.like(FieldNameConstants.FIRST_NAME, "%" + searchString + "%"),        //Search By FirstName
                                    where.like(FieldNameConstants.MIDDLE_NAME, "%" + searchString + "%"),       //Search By MiddleName
                                    where.like(FieldNameConstants.LAST_NAME, "%" + searchString + "%"),         //Search By LastName
                                    where.like(FieldNameConstants.FAMILY_ID, "%" + searchString + "%"),         //Search By FamilyId
                                    where.like(FieldNameConstants.MOBILE_NUMBER, "%" + searchString + "%"),     //Search By MobileNumber
                                    where.like(FieldNameConstants.NRC_NUMBER, "%" + searchString + "%"),    //Search by nrc
                                    where.like(FieldNameConstants.HEALTH_ID, "%" + searchString + "%"),
                                    where.like(FieldNameConstants.SEARCH_STRING, "%" + searchString + "%"),
                                    where.like(FieldNameConstants.PASSPORT_NUMBER, "%" + searchString + "%")
                            )
                    ).query();
                } else {
                    memberBeans = where.and(
                            where.in(FieldNameConstants.FAMILY_ID, familyIds),
                            where.notIn(FieldNameConstants.STATE, FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES),
                            where.eq(FieldNameConstants.GENDER, "F"),
                            where.eq(FieldNameConstants.MARITAL_STATUS, "629"),
                            where.and(
                                    where.isNotNull(FieldNameConstants.DATE_OF_WEDDING),
                                    where.ge(FieldNameConstants.DATE_OF_WEDDING, dateBefore1Year)
                            ),
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
                    ).query();
                }
                Calendar cal = Calendar.getInstance();
                cal.add(Calendar.MONTH, -3);

                Calendar cal1 = Calendar.getInstance();
                cal1.add(Calendar.YEAR, -3);

                List<MemberDataBean> membersWithChildCountMoreThan2 = new ArrayList<>();
                List<MemberDataBean> membersWithLastDeliveryDateLessThan3Years = new ArrayList<>();
                List<MemberDataBean> eligibleCouples = new ArrayList<>();

                for (MemberBean memberBean : memberBeans) {
                    if (memberBean.getGender() != null && memberBean.getGender().equals(GlobalTypes.FEMALE)
                            && memberBean.getMaritalStatus() != null && memberBean.getMaritalStatus().equals("629")
                            && memberBean.getDob() != null && memberBean.getDob().after(dateBefore45Years) && memberBean.getDob().before(dateBefore18Years)
                            && (memberBean.getIsPregnantFlag() == null || !memberBean.getIsPregnantFlag())
                            && (memberBean.getMenopauseArrived() == null || !memberBean.getMenopauseArrived())
                            && (memberBean.getHysterectomyDone() == null || !memberBean.getHysterectomyDone())
                            && (memberBean.getLastMethodOfContraception() == null
                            || (!memberBean.getLastMethodOfContraception().equals(RchConstants.FEMALE_STERILIZATION)
                            && !memberBean.getLastMethodOfContraception().equals(RchConstants.MALE_STERILIZATION))
                            || (memberBean.getFpInsertOperateDate() != null && memberBean.getFpInsertOperateDate().after(cal.getTime())))) {
                        long childCount = memberBeanDao.queryBuilder().where().eq(FieldNameConstants.MOTHER_ID, memberBean.getActualId()).countOf();
                        if (childCount > 2) {
                            membersWithChildCountMoreThan2.add(new MemberDataBean(memberBean));
                        } else if (memberBean.getLastDeliveryDate() != null && memberBean.getLastDeliveryDate().after(cal1.getTime())) {
                            membersWithLastDeliveryDateLessThan3Years.add(new MemberDataBean(memberBean));
                        } else {
                            eligibleCouples.add(new MemberDataBean(memberBean));
                        }
                    }
                }

                memberDataBeans.addAll(membersWithChildCountMoreThan2);
                memberDataBeans.addAll(membersWithLastDeliveryDateLessThan3Years);
                memberDataBeans.addAll(eligibleCouples);

            }
        } catch (SQLException e) {
            android.util.Log.e(TAG, null, e);
        }
        return memberDataBeans;
    }

    @Override
    public List<ListValueBean> retrieveListValues(String field) {
        List<ListValueBean> listValueBean = null;
        try {
            listValueBean = listValueBeanDao.queryForEq(FieldNameConstants.Field, field);
        } catch (Exception throwables) {
            throwables.printStackTrace();
        }
        return listValueBean;
    }

    public void markMemberBcgEligibleStatus(Long memberId) {
        try {
            MemberBean memberBean = memberBeanDao.queryBuilder().where().eq(FieldNameConstants.ACTUAL_ID, memberId).queryForFirst();
            memberBean.setBcgEligibleFilled(true);
            memberBeanDao.update(memberBean);
        } catch (SQLException ex) {
            Log.e(TAG, null, ex);
        }
    }

    public void markMemberBcgSurveyStatus(Long memberId) {
        try {
            MemberBean memberBean = memberBeanDao.queryBuilder().where().eq(FieldNameConstants.ACTUAL_ID, memberId).queryForFirst();
            memberBean.setBcgSurveyStatus(true);
            memberBeanDao.update(memberBean);
        } catch (SQLException ex) {
            Log.e(TAG, null, ex);
        }
    }

    @Override
    public FamilyBean retrieveFamilyBeanByFamilyId(String familyId) {
        try {
            if (familyId != null) {
                return familyBeanDao.queryBuilder().where().eq(FieldNameConstants.FAMILY_ID, familyId).queryForFirst();
            }
            return null;
        } catch (SQLException e) {
            Log.e(getClass().getSimpleName(), null, e);
        }
        return null;
    }
}
