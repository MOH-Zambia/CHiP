package com.argusoft.sewa.android.app.util;

import static org.androidannotations.annotations.EBean.Scope.Singleton;

import android.content.SharedPreferences;

import com.argusoft.sewa.android.app.BuildConfig;
import com.argusoft.sewa.android.app.constants.FhsConstants;
import com.argusoft.sewa.android.app.constants.FieldNameConstants;
import com.argusoft.sewa.android.app.constants.FormConstants;
import com.argusoft.sewa.android.app.constants.FullFormConstants;
import com.argusoft.sewa.android.app.constants.LabelConstants;
import com.argusoft.sewa.android.app.constants.RchConstants;
import com.argusoft.sewa.android.app.constants.RelatedPropertyNameConstants;
import com.argusoft.sewa.android.app.core.impl.HealthInfrastructureServiceImpl;
import com.argusoft.sewa.android.app.core.impl.ImmunisationServiceImpl;
import com.argusoft.sewa.android.app.core.impl.SewaFhsServiceImpl;
import com.argusoft.sewa.android.app.databean.FamilyDataBean;
import com.argusoft.sewa.android.app.databean.MemberAdditionalInfoDataBean;
import com.argusoft.sewa.android.app.databean.MemberDataBean;
import com.argusoft.sewa.android.app.databean.MorbidityDataBean;
import com.argusoft.sewa.android.app.databean.NotificationMobDataBean;
import com.argusoft.sewa.android.app.databean.OptionDataBean;
import com.argusoft.sewa.android.app.datastructure.SharedStructureData;
import com.argusoft.sewa.android.app.db.DBConnection;
import com.argusoft.sewa.android.app.exception.DataException;
import com.argusoft.sewa.android.app.model.FamilyBean;
import com.argusoft.sewa.android.app.model.HealthInfrastructureBean;
import com.argusoft.sewa.android.app.model.ListValueBean;
import com.argusoft.sewa.android.app.model.LocationBean;
import com.argusoft.sewa.android.app.model.LocationMasterBean;
import com.argusoft.sewa.android.app.model.MemberBean;
import com.argusoft.sewa.android.app.model.StockInventoryBean;
import com.argusoft.sewa.android.app.model.VersionBean;
import com.argusoft.sewa.android.app.morbidities.constants.MorbiditiesConstant;
import com.argusoft.sewa.android.app.transformer.SewaTransformer;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import com.google.gson.reflect.TypeToken;
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.stmt.Where;
import com.j256.ormlite.table.TableUtils;

import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.EBean;
import org.androidannotations.ormlite.annotations.OrmLiteDao;

import java.lang.reflect.Type;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.StringTokenizer;

@EBean(scope = Singleton)
public class FormMetaDataUtil {

    @OrmLiteDao(helper = DBConnection.class)
    public Dao<ListValueBean, Integer> listValueBeanDao;

    @OrmLiteDao(helper = DBConnection.class)
    public Dao<FamilyBean, Integer> familyBeanDao;

    @OrmLiteDao(helper = DBConnection.class)
    public Dao<MemberBean, Integer> memberBeanDao;

    @OrmLiteDao(helper = DBConnection.class)
    public Dao<LocationBean, Integer> locationBeanDao;

    @OrmLiteDao(helper = DBConnection.class)
    Dao<VersionBean, Integer> versionBeanDao;

    @OrmLiteDao(helper = DBConnection.class)
    Dao<HealthInfrastructureBean, Integer> healthInfrastructureBeanDao;

    @OrmLiteDao(helper = DBConnection.class)
    public Dao<LocationMasterBean, Integer> locationMasterBeanDao;


    @OrmLiteDao(helper = DBConnection.class)
    public Dao<StockInventoryBean, Integer> stockInventoryBeanDao;

    @Bean
    public ImmunisationServiceImpl immunisationService;

    @Bean
    public SewaFhsServiceImpl fhsService;

    @Bean
    HealthInfrastructureServiceImpl healthInfrastructureService;

    private static List<String> invalidStates = new ArrayList<>();

    static {
        invalidStates.addAll(FhsConstants.FHS_ARCHIVED_CRITERIA_MEMBER_STATES);
        invalidStates.addAll(FhsConstants.FHS_DEAD_CRITERIA_MEMBER_STATES);
    }


    public void setMetaDataForRchFormByFormType(String formType, String memberActualId, String familyId, NotificationMobDataBean selectedNotification, SharedPreferences sharedPref, String memberUuid) {

        SharedStructureData.relatedPropertyHashTable.clear();
        SharedStructureData.membersUnderTwenty.clear();
        SharedStructureData.selectedHealthInfra = null;
        SharedStructureData.highRiskConditions.clear();

        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MEMBER_ID, memberActualId);

        String userRole = SewaTransformer.loginBean.getUserRole();
        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.USER_ROLE,
                userRole != null && !userRole.isEmpty() ? userRole : "Not available");
        MemberBean memberBean;
        if (memberActualId != null) {
            memberBean = fhsService.retrieveMemberBeanByActualId(Long.valueOf(memberActualId));
        } else {
            memberBean = fhsService.retrieveMemberBeanByUUID(memberUuid);
        }
        FamilyDataBean familyDataBean;
        if (familyId != null) {
            familyDataBean = fhsService.retrieveFamilyDataBeanByFamilyId(familyId);
        } else {
            familyDataBean = fhsService.retrieveFamilyDataBeanByFamilyId(memberBean.getFamilyId());
        }
        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.FAMILY_ID, memberBean.getFamilyId());

        if (familyDataBean == null) {
            // Here family should never be null, So we are clearing family table.
            try {
                TableUtils.clearTable(familyBeanDao.getConnectionSource(), FamilyBean.class);
            } catch (SQLException e) {
                Log.e(getClass().getName(), null, e);
            }
            throw new DataException("Data Exception", 1);
        }

        SharedPreferences.Editor editor = sharedPref.edit();
        editor.clear().apply();
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.getDefault());

        editor.putString(RelatedPropertyNameConstants.MEMBER_ACTUAL_ID, memberBean.getActualId());
        editor.putString(RelatedPropertyNameConstants.CUR_PREG_REG_DET_ID, String.valueOf(memberBean.getCurPregRegDetId()));
        editor.putString(RelatedPropertyNameConstants.FAMILY_ID, familyDataBean.getId());

        if (selectedNotification != null) {
            editor.putString(RelatedPropertyNameConstants.LOCATION_ID, String.valueOf(selectedNotification.getLocationId()));
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LOCATION_ID, String.valueOf(selectedNotification.getLocationId()));
        } else {
            if (familyDataBean.getAreaId() != null) {
                editor.putString(RelatedPropertyNameConstants.LOCATION_ID, familyDataBean.getAreaId());
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LOCATION_ID, familyDataBean.getAreaId());
            } else {
                editor.putString(RelatedPropertyNameConstants.LOCATION_ID, familyDataBean.getLocationId());
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LOCATION_ID, familyDataBean.getLocationId());
            }
        }

        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.DAY_OF_MONTH, cal.getActualMinimum(Calendar.DAY_OF_MONTH));
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MONTH_START, String.valueOf(cal.getTimeInMillis()));
        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MEMBER_ID_AND_NAME,
                memberBean.getUniqueHealthId() + " / " + UtilBean.getMemberFullName(memberBean));

        SharedStructureData.currentRchMemberBean = memberBean;
        SharedStructureData.currentRchFamilyDataBean = familyDataBean;

        if (selectedNotification != null) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.NOTIFICATION_ID, String.valueOf(selectedNotification.getId()));
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.VISIT_NUMBER, selectedNotification.getCustomField());
        }

        HealthInfrastructureBean healthInfraBean = healthInfrastructureService.retrieveHealthInfrastructureAssignedToUser(SewaTransformer.loginBean.getUserID());

        if (healthInfraBean != null) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IS_DEFAULT_HEALTH_INFRA_ASSIGNED, "1");
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.USER_ASSIGNED_HEALTH_INFRA_ID, String.valueOf(healthInfraBean.getActualId()));
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.USER_ASSIGNED_HEALTH_INFRA_NAME, String.valueOf(healthInfraBean.getName()));
        } else {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IS_DEFAULT_HEALTH_INFRA_ASSIGNED, "2");
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.USER_ASSIGNED_HEALTH_INFRA_ID, null);
        }

        if (memberUuid != null && !memberUuid.isEmpty()) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MEMBER_UUID, memberUuid);
            System.out.println("UUID WHEN FORM OPENS " + formType + " ==" + memberUuid);
        }
//
//        if (memberUuid == null && !memberUuid.isEmpty()) {
//            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MEMBER_UUID, memberUuid);
//        }

        if (familyDataBean.getUuid() != null && !familyDataBean.getUuid().isEmpty()) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.UUID, familyDataBean.getUuid());
        }

        if (familyDataBean.getAreaId() != null) {
            try {
                LocationMasterBean locationMasterBean = locationMasterBeanDao.queryBuilder().where().
                        eq(FieldNameConstants.ACTUAL_I_D, familyDataBean.getAreaId()).queryForFirst();
                if (locationMasterBean != null) {
                    String fhwDetailString = locationMasterBean.getFhwDetailString();
                    if (fhwDetailString != null) {
                        Type type = new TypeToken<List<Map<String, String>>>() {
                        }.getType();
                        List<Map<String, String>> fhwDetailMapList = new Gson().fromJson(fhwDetailString, type);
                        Map<String, String> fhwDetailMap = fhwDetailMapList.get(0);
                        if (fhwDetailMap.get("mobileNumber") != null) {
                            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.ASHA_INFO, fhwDetailMap.get("name") + " (" + fhwDetailMap.get("mobileNumber") + ")");
                        } else {
                            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.ASHA_INFO, fhwDetailMap.get("name") + " / " + LabelConstants.NOT_AVAILABLE);
                        }
                    }
                }
            } catch (SQLException e) {
                Log.e(getClass().getSimpleName(), null, e);
            }
        }

        if (familyDataBean.getAnganwadiId() != null) {
            try {
                LocationBean anganwadi = locationBeanDao.queryBuilder().where()
                        .eq(FieldNameConstants.ACTUAL_I_D, familyDataBean.getAnganwadiId())
                        .and().eq("level", 8).queryForFirst();
                if (anganwadi != null && anganwadi.getName() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.ANGANWADI_ID, anganwadi.getName());
                }
            } catch (SQLException e) {
                Log.e(getClass().getSimpleName(), null, e);
            }
        }

        if (familyDataBean.getHouseNumber() != null && !familyDataBean.getHouseNumber().isEmpty()) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.HOUSEHOLD_NUMBER, familyDataBean.getHouseNumber());
        }

        if (familyDataBean.getLatitude() != null && familyDataBean.getLongitude() != null) {
            String plusCode = UtilBean.convertLatLngToPlusCode(Double.parseDouble(familyDataBean.getLatitude()), Double.parseDouble(familyDataBean.getLongitude()), 10);
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.GPS_LOCATION, plusCode);
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LATITUDE, familyDataBean.getLatitude());
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LONGITUDE, familyDataBean.getLongitude());
        }

        if (familyDataBean.getAnganwadiUpdateFlag() != null && familyDataBean.getAnganwadiUpdateFlag()) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.UPDATE_FAMILY_ANGANWADI, "yes");
        }


        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.FAMILY_ACTUAL_ID, familyDataBean.getId());
        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.UNIQUE_HEALTH_ID, memberBean.getUniqueHealthId());
        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MEMBER_NAME, UtilBean.getMemberFullName(memberBean));
        if (memberBean.getLmpDate() != null &&
                (formType.equalsIgnoreCase(FormConstants.TECHO_FHW_ANC) || formType.equalsIgnoreCase(FormConstants.ASHA_ANC))) {
            String lmp = "LMP:" + sdf.format(memberBean.getLmpDate()) + " , ";

            Calendar calendar = Calendar.getInstance();
            calendar.setTime(memberBean.getLmpDate());
            calendar.add(Calendar.DATE, 281);
            String edd = LabelConstants.EDD + ":" + sdf.format(calendar.getTime());

            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.SUB_TITLE_DETAILS, lmp + edd);
        }

        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.NAME_OF_BENEFICIARY, UtilBean.getMemberFullName(memberBean));

        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.VISIT_DATE, String.valueOf(new Date().getTime()));
        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MEMBER_ACTUAL_ID, memberBean.getActualId());

        if (memberBean.getMobileNumber() != null) {
            String mob = null;
            if (memberBean.getMobileNumber().contains("F/")) {
                mob = memberBean.getMobileNumber().replace("F/", "");
            } else if (memberBean.getMobileNumber().contains("T")) {
                mob = memberBean.getMobileNumber().replace("T", "");
            } else if (!memberBean.getMobileNumber().isEmpty()) {
                mob = memberBean.getMobileNumber();
            }
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.PHONE_NUMBER, mob);
        }

        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.ADDRESS, UtilBean.getFamilyFullAddress(familyDataBean));
        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.BENEFICIARY_NAME_FOR_LOG,
                UtilBean.getMemberFullName(memberBean) + "(" + memberBean.getUniqueHealthId() + ")"); //for showing purpose...in worklog
        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.GENDER,
                UtilBean.getGenderLabelFromValue(memberBean.getGender()));
        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MARITAL_STATUS,
                UtilBean.getNotAvailableIfNull(fhsService.getValueOfListValuesById(memberBean.getMaritalStatus())));

        if (memberBean.getDob() != null) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.DOB, String.valueOf(memberBean.getDob().getTime()));
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.DOB_DISPLAY, sdf.format(memberBean.getDob()));
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.AGE_DISPLAY, UtilBean.getAgeDisplayOnGivenDate(memberBean.getDob(), new Date()));
            List<MemberDataBean> memberDataBeans = fhsService.retrieveMemberDataBeansByFamily(familyId != null ? familyId : memberBean.getFamilyUuid());
            if (memberDataBeans != null && !memberDataBeans.isEmpty()) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.NUMBER_OF_MEMBERS, String.valueOf(memberDataBeans.size()));
            }
        }

        if (memberBean.getAncVisitDates() != null && !memberBean.getAncVisitDates().isEmpty()) {
            String lastAncVisitDate = UtilBean.getLastStringFromCommaSeparatedString(memberBean.getAncVisitDates());
            Date lastAncDate;
            try {
                lastAncDate = sdf.parse(lastAncVisitDate);
            } catch (ParseException e) {
                throw new RuntimeException(e);
            }
            if (lastAncDate != null) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LAST_ANC_VISIT_DATE, String.valueOf(lastAncDate.getTime()));
            }
        }

        if (memberBean.getLmpDate() != null) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LAST_LMP, sdf.format(memberBean.getLmpDate()));
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LMP_DATE, String.valueOf(memberBean.getLmpDate().getTime()));
            Integer diffInDays = UtilBean.getNumberOfDays(memberBean.getLmpDate(), new Date());

            if (diffInDays >= 0 && diffInDays < 92) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.ANC_VISIT_NUMBER, "1");
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CURRENT_TRIMESTER, "1");
            } else if (diffInDays >= 92 && diffInDays < 190) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.ANC_VISIT_NUMBER, "2");
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CURRENT_TRIMESTER, "2");
            } else if (diffInDays >= 190 && diffInDays < 252) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.ANC_VISIT_NUMBER, "3");
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CURRENT_TRIMESTER, "3");
            } else {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.ANC_VISIT_NUMBER, "4");
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CURRENT_TRIMESTER, "4");
            }


            Calendar calendar = Calendar.getInstance();
            calendar.setTime(memberBean.getLmpDate());
            calendar.add(Calendar.DATE, 281);
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.EDD, sdf.format(calendar.getTime()));
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LMP_DATE_DISPLAY, sdf.format(memberBean.getLmpDate()));
        }

        if (memberBean.getLastDeliveryDate() != null) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LAST_DELIVERY_DATE, String.valueOf(memberBean.getLastDeliveryDate().getTime()));
        }

        if (memberBean.getLastDeliveryOutcome() != null) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LAST_DELIVERY_OUTCOME, memberBean.getLastDeliveryOutcome());
        }

        if (memberBean.getGender() != null && memberBean.getGender().equals(GlobalTypes.FEMALE)) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.ANS_12, "2");
        } else {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.ANS_12, "1");
        }

        if (memberBean.getIsPregnantFlag() != null && memberBean.getIsPregnantFlag()) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IS_PREGNANT, "1");
        } else {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IS_PREGNANT, "2");
        }
        if (memberBean.getGender() != null && memberBean.getGender().equalsIgnoreCase(GlobalTypes.FEMALE) && memberBean.getIsPregnantFlag() == null) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IS_PREGNANT, "5");
        }

        if (memberBean.getIsHivPositive() != null) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.HIV_TEST, memberBean.getIsHivPositive());
        }

        if (memberBean.getNrcNumber() != null) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.NRC_NUMBER, memberBean.getNrcNumber());
        }

        if (memberBean.getBirthCertNumber() != null) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.BIRTH_CERTIFICATE_NUMBER, memberBean.getBirthCertNumber());
        }

        if (memberBean.getWeight() != null) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LAST_WEIGHT,
                    memberBean.getWeight().toString() + UtilBean.getMyLabel(" Kgs"));
        }

        if (memberBean.getChronicDiseaseIds() != null && !memberBean.getChronicDiseaseIds().isEmpty()) {
            StringBuilder builder = new StringBuilder();
            if (memberBean.getChronicDiseaseIds().contains(",")) {
                String[] split = memberBean.getChronicDiseaseIds().split(",");
                for (int i = 0; i < split.length; i++) {
                    builder.append(UtilBean.getNotAvailableIfNull(fhsService.getValueOfListValuesById(split[i])));
                    if (i != split.length - 1) {
                        builder.append("\n");
                    }
                }
            }
            if (memberBean.getOtherChronic() != null && !memberBean.getOtherChronic().isEmpty()) {
                builder.append("\n");
                builder.append(memberBean.getOtherChronic());
            }
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CHRONIC_DISEASES, UtilBean.getMyLabel(builder.toString()));
        } else {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CHRONIC_DISEASES, UtilBean.getMyLabel(LabelConstants.NONE));
        }

        if (memberBean.getDob() != null) {
            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.YEAR, 1);
            if (memberBean.getDob().before(calendar.getTime())) {
                calendar.add(Calendar.YEAR, 1);
                if (memberBean.getDob().before(calendar.getTime())) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IMMUNISED_IN_TWO_YEAR, isChildImmunisedInTwoYearZambia(memberBean));
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.FULLY_IMMUNIZED_OR_NOT, isChildImmunisedInTwoYearZambia(memberBean));
                }
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IMMUNISED_IN_ONE_YEAR, isChildImmunisedInOneYear(memberBean));
            }
        }

        String tmpDataObj;
        tmpDataObj = FullFormConstants.getFullFormsOfPlace(memberBean.getPlaceOfBirth());
        if (tmpDataObj != null) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.PLACE_OF_BIRTH, tmpDataObj);
        }
        if (memberBean.getBirthWeight() != null) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.BIRTH_WEIGHT, memberBean.getBirthWeight().toString());
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.BIRTH_WEIGHT_DISPLAY, memberBean.getBirthWeight().toString() + " " + UtilBean.getMyLabel("Kgs"));
        }
        MemberAdditionalInfoDataBean memberAdditionalInfo = new MemberAdditionalInfoDataBean();
        if (memberBean.getAdditionalInfo() != null && !memberBean.getAdditionalInfo().isEmpty()) {
            Gson gson = new Gson();
            memberAdditionalInfo = gson.fromJson(memberBean.getAdditionalInfo(), MemberAdditionalInfoDataBean.class);
        }


        if (memberAdditionalInfo.getHivTest() != null && !memberAdditionalInfo.getHivTest().equals(RchConstants.NOT_DONE)) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.HIV_TEST, memberAdditionalInfo.getHivTest());
        }
        if (memberBean.getLastMethodOfContraception() != null) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LAST_METHOD_OF_CONTRACEPTION, FullFormConstants.convertToCamelCase(memberBean.getLastMethodOfContraception()));
            tmpDataObj = FullFormConstants.getFullFormOfFamilyPlanningMethods(memberBean.getLastMethodOfContraception());
            if (tmpDataObj != null) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LAST_METHOD_OF_CONTRACEPTION_DISPLAY, tmpDataObj);
            }

            if (memberBean.getFpInsertOperateDate() != null) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.FP_INSERT_OPERATE_DATE, String.valueOf(memberBean.getFpInsertOperateDate().getTime()));
            }
        }

        if (memberBean.getMemberReligion() != null) {
            String religion = fhsService.getValueOfListValuesById(memberBean.getMemberReligion());
            if (religion != null) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.RELIGION, religion);
            }
        }

        if (familyDataBean.getResidenceStatus() != null) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.RESIDENCE_STATUS,
                    UtilBean.getResidentStatusFromConstant(familyDataBean.getResidenceStatus()));
        }

        if (familyDataBean.getCaste() != null) {
            String caste = fhsService.getValueOfListValuesById(familyDataBean.getCaste());
            if (caste != null) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CASTE, caste);
            }
        }

        if (familyDataBean.getBplFlag() != null && familyDataBean.getBplFlag()) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IS_BPL, LabelConstants.YES);
        } else {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IS_BPL, LabelConstants.NO);
        }

        if (memberBean.getMobileNumber() != null && !memberBean.getMobileNumber().equals("T")) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.FAMILY_PHONE_NUMBER, memberBean.getMobileNumber());
        } else if (familyDataBean.getContactPersonId() != null) {
            try {
                MemberBean contactPerson = memberBeanDao.queryBuilder().where()
                        .eq(FieldNameConstants.ACTUAL_ID, familyDataBean.getContactPersonId()).queryForFirst();
                if (contactPerson != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.FAMILY_PHONE_NUMBER, contactPerson.getMobileNumber());
                }
            } catch (SQLException e) {
                Log.e(getClass().getSimpleName(), null, e);
            }
        }

        if (memberBean.getMotherId() != null) {
            try {
                MemberBean mother = memberBeanDao.queryBuilder().where().eq(FieldNameConstants.ACTUAL_ID, memberBean.getMotherId()).queryForFirst();
                if (mother != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MOTHER_HEALTH_ID, mother.getUniqueHealthId());
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MOTHER_NAME, UtilBean.getMemberFullName(mother));
                }
            } catch (SQLException e) {
                Log.e(getClass().getSimpleName(), null, e);
            }
        }

        if (memberBean.getBloodGroup() != null && !memberBean.getBloodGroup().equalsIgnoreCase(LabelConstants.N_A)) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.BLOOD_GROUP, memberBean.getBloodGroup());
        }

        if (memberBean.getWeight() != null) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LAST_WEIGHT_AND_DATE,
                    memberBean.getWeight().toString() + " " + UtilBean.getMyLabel("Kgs"));
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.PREV_WEIGHT, memberBean.getWeight().toString());
        }

        if (memberBean.getCurrentGravida() != null) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CURRENT_GRAVIDA, String.valueOf(memberBean.getCurrentGravida() + 1));
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.DEFAULT_GRAVIDA, String.valueOf(memberBean.getCurrentGravida() + 1));
        } else {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CURRENT_GRAVIDA, ("1"));
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.DEFAULT_GRAVIDA, ("1"));
        }

        if (memberBean.getCurrentPara() != null) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CURRENT_PARA, String.valueOf(memberBean.getCurrentPara()));
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.DEFAULT_PARA, String.valueOf(memberBean.getCurrentPara()));
        } else {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CURRENT_PARA, ("0"));
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.DEFAULT_PARA, ("0"));
        }


        if (memberBean.getLmpDate() != null && memberBean.getIsPregnantFlag() != null && memberBean.getIsPregnantFlag()) {
            int numberOfWeeks = UtilBean.getNumberOfWeeks(memberBean.getLmpDate(), new Date());
            if (numberOfWeeks <= 40) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.WEEKS_OF_PREGNANCY, String.valueOf(numberOfWeeks));
            } else {
                int overdueWeeks = numberOfWeeks - 40;
                String displayString = 40 + " " + UtilBean.getMyLabel("+ overdue")
                        + " " + overdueWeeks + " " + UtilBean.getMyLabel("weeks");
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.WEEKS_OF_PREGNANCY, displayString);
            }
        }


        if (memberAdditionalInfo.getLastServiceLongDate() != null && memberAdditionalInfo.getLastServiceLongDate() > 0) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LAST_SERVICE_DATE, memberAdditionalInfo.getLastServiceLongDate().toString());
        } else {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LAST_SERVICE_DATE, null);
        }
        if (memberAdditionalInfo.getFpServiceDate() != null && memberAdditionalInfo.getFpServiceDate() > 0) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.FP_SERVICE_DATE, memberAdditionalInfo.getFpServiceDate().toString());
        }
        if (memberAdditionalInfo.getDevelopmentDelays() != null && memberAdditionalInfo.getDevelopmentDelays()) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.DEVELOPMENTAL_DELAYS, "Yes");
        } else {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.DEVELOPMENTAL_DELAYS, "No");
        }
        if (memberAdditionalInfo.getAbortionCount() != null) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.ABORTION_COUNT, memberAdditionalInfo.getAbortionCount().toString());
        }
        if (memberAdditionalInfo.getPmmvyBeneficiary() != null && memberAdditionalInfo.getPmmvyBeneficiary()) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.PMMVY_BENEFICIARY, "1");
        } else if (memberAdditionalInfo.getPmmvyBeneficiary() != null && !memberAdditionalInfo.getPmmvyBeneficiary()) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.PMMVY_BENEFICIARY, "2");
        }
        if (memberAdditionalInfo.getPmmvyBeneficiary() != null && memberAdditionalInfo.getPmmvyBeneficiary()) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.PMSMA_BENEFICIARY, "1");
        } else if (memberAdditionalInfo.getPmmvyBeneficiary() != null && !memberAdditionalInfo.getPmmvyBeneficiary()) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.PMSMA_BENEFICIARY, "2");
        }
        if (memberAdditionalInfo.getDikariBeneficiary() != null && memberAdditionalInfo.getDikariBeneficiary()) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.DIKRI_BENEFICIARY, "1");
        } else if (memberAdditionalInfo.getDikariBeneficiary() != null && !memberAdditionalInfo.getDikariBeneficiary()) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.DIKRI_BENEFICIARY, "2");
        }
        if (memberAdditionalInfo.getHepatitisCTest() != null) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.HEPATITIS_TEST, memberAdditionalInfo.getHepatitisCTest());
        }
        if (memberAdditionalInfo.getAlbendanzoleGiven() != null) {
            if (memberAdditionalInfo.getAlbendanzoleGiven()) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.ALBENDAZOLE_GIVEN, LabelConstants.YES);
            } else {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.ALBENDAZOLE_GIVEN, LabelConstants.NO);
            }
        } else {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.ALBENDAZOLE_GIVEN, LabelConstants.NOT_AVAILABLE);
        }


        if (memberBean.getCongenitalAnomalyIds() != null && !memberBean.getCongenitalAnomalyIds().isEmpty()) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CONGENITAL_ANOMALY_IDS, memberBean.getCongenitalAnomalyIds());
        }

        if (memberBean.getIndexCase() != null && memberBean.getIndexCase()) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.INDEX_CASE, "Yes");
        } else {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.INDEX_CASE, "No");
        }

        if (memberBean.getChronicDiseaseIds() != null && !memberBean.getChronicDiseaseIds().isEmpty()) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CHRONIC_DISEASE_IDS, memberBean.getChronicDiseaseIds());
        }

        if (memberBean.getCurrentDiseaseIds() != null && !memberBean.getCurrentDiseaseIds().isEmpty()) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CURRENT_DISEASE_IDS, memberBean.getCurrentDiseaseIds());
        }

        if (memberBean.getEyeIssueIds() != null && !memberBean.getEyeIssueIds().isEmpty()) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.EYE_ISSUE_IDS, memberBean.getEyeIssueIds());
        }
        try {
            if (memberBean.getActualId() != null || memberBean.getMemberUuid() != null) {
                List<MemberBean> allChildrenOfMother = null;
                MemberBean wifeOf;
                if (memberBean.getActualId() != null) {
                    if (memberBean.getGender().equals(GlobalTypes.MALE)) {
                        wifeOf = memberBeanDao.queryBuilder().where()
                                .eq(FieldNameConstants.HUSBAND_ID, memberBean.getActualId())
                                .and().notIn(FieldNameConstants.STATE, invalidStates).queryForFirst();
                        if (wifeOf != null) {
                            allChildrenOfMother = memberBeanDao.queryBuilder().where()
                                    .eq(FieldNameConstants.MOTHER_ID, wifeOf.getActualId())
                                    .and().notIn(FieldNameConstants.STATE, invalidStates).query();
                            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.TOTAL_LIVING_CHILDREN,
                                    String.valueOf(memberBeanDao.queryBuilder().where()
                                            .eq(FieldNameConstants.MOTHER_ID, wifeOf.getActualId())
                                            .and().eq(FieldNameConstants.FAMILY_ID, wifeOf.getFamilyId())
                                            .and().ne(FieldNameConstants.ACTUAL_ID, wifeOf.getActualId())
                                            .and().notIn(FieldNameConstants.STATE, invalidStates).countOf()));
                        }

                    } else {
                        allChildrenOfMother = memberBeanDao.queryBuilder().where()
                                .eq(FieldNameConstants.MOTHER_ID, memberBean.getActualId())
                                .and().notIn(FieldNameConstants.STATE, invalidStates).query();
                        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.TOTAL_LIVING_CHILDREN,
                                String.valueOf(memberBeanDao.queryBuilder().where()
                                        .eq(FieldNameConstants.MOTHER_ID, memberBean.getActualId())
                                        .and().eq(FieldNameConstants.FAMILY_ID, memberBean.getFamilyId())
                                        .and().ne(FieldNameConstants.ACTUAL_ID, memberBean.getActualId())
                                        .and().notIn(FieldNameConstants.STATE, invalidStates).countOf()));

                        MemberBean latestChild = memberBeanDao.queryBuilder()
                                .orderBy(FieldNameConstants.DOB, false)
                                .where().eq(FieldNameConstants.MOTHER_ID, memberBean.getActualId())
                                .and().eq(FieldNameConstants.FAMILY_ID, memberBean.getFamilyId())
                                .and().ne(FieldNameConstants.ACTUAL_ID, memberBean.getActualId())
                                .and().notIn(FieldNameConstants.STATE, invalidStates).queryForFirst();

                        if (latestChild != null) {
                            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LATEST_CHILD_NAME, latestChild.getFirstName() + " " + latestChild.getLastName());
                            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LATEST_CHILD_AGE, UtilBean.getAgeDisplayOnGivenDate(latestChild.getDob(), new Date()));
                            if (latestChild.getGender() != null && latestChild.getGender().equals(GlobalTypes.MALE)) {
                                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LATEST_CHILD_GENDER, LabelConstants.MALE);
                            } else if (latestChild.getGender() != null && latestChild.getGender().equals(GlobalTypes.FEMALE)) {
                                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LATEST_CHILD_GENDER, LabelConstants.FEMALE);
                            }
                        }
                    }

                } else {
                    if (memberBean.getGender().equals(GlobalTypes.MALE)) {
                        wifeOf = memberBeanDao.queryBuilder().where()
                                .eq(FieldNameConstants.HUSBAND_ID, memberBean.getMemberUuid())
                                .and().notIn(FieldNameConstants.STATE, invalidStates).queryForFirst();
                        if (wifeOf != null) {
                            allChildrenOfMother = memberBeanDao.queryBuilder().where()
                                    .eq(FieldNameConstants.MOTHER_ID, wifeOf.getMemberUuid())
                                    .and().notIn(FieldNameConstants.STATE, invalidStates).query();
                            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.TOTAL_LIVING_CHILDREN,
                                    String.valueOf(memberBeanDao.queryBuilder().where()
                                            .eq(FieldNameConstants.MOTHER_ID, wifeOf.getMemberUuid())
                                            .and().eq(FieldNameConstants.FAMILY_ID, wifeOf.getFamilyId())
                                            .and().ne(FieldNameConstants.ACTUAL_ID, wifeOf.getMemberUuid())
                                            .and().notIn(FieldNameConstants.STATE, invalidStates).countOf()));
                        }
                    } else {
                        allChildrenOfMother = memberBeanDao.queryBuilder().where()
                                .eq(FieldNameConstants.MOTHER_UUID, memberBean.getMemberUuid())
                                .and().notIn(FieldNameConstants.STATE, invalidStates).query();

                        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.TOTAL_LIVING_CHILDREN,
                                String.valueOf(memberBeanDao.queryBuilder().where()
                                        .eq(FieldNameConstants.MOTHER_UUID, memberBean.getMemberUuid())
                                        .and().eq(FieldNameConstants.FAMILY_ID, memberBean.getFamilyId())
                                        .and().ne(FieldNameConstants.MEMBER_UUID, memberBean.getMemberUuid())
                                        .and().notIn(FieldNameConstants.STATE, invalidStates).countOf()));

                        MemberBean latestChild = memberBeanDao.queryBuilder()
                                .orderBy(FieldNameConstants.DOB, false)
                                .where().eq(FieldNameConstants.MOTHER_UUID, memberBean.getMemberUuid())
                                .and().eq(FieldNameConstants.FAMILY_ID, memberBean.getFamilyId())
                                .and().ne(FieldNameConstants.MEMBER_UUID, memberBean.getMemberUuid())
                                .and().notIn(FieldNameConstants.STATE, invalidStates).queryForFirst();

                        if (latestChild != null) {
                            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LATEST_CHILD_NAME, latestChild.getFirstName() + " " + latestChild.getLastName());
                            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LATEST_CHILD_AGE, UtilBean.getAgeDisplayOnGivenDate(latestChild.getDob(), new Date()));
                            if (latestChild.getGender() != null && latestChild.getGender().equals(GlobalTypes.MALE)) {
                                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LATEST_CHILD_GENDER, LabelConstants.MALE);
                            } else if (latestChild.getGender() != null && latestChild.getGender().equals(GlobalTypes.FEMALE)) {
                                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LATEST_CHILD_GENDER, LabelConstants.FEMALE);
                            }
                        }
                    }
                }

                if (allChildrenOfMother != null && !allChildrenOfMother.isEmpty()) {
                    List<MemberBean> childrenLessThan60Days = new ArrayList<>();
                    for (MemberBean child : allChildrenOfMother) {
                        Calendar cal1 = Calendar.getInstance();
                        cal1.add(Calendar.DATE, -60);
                        if (child.getDob().after(cal1.getTime())) {
                            childrenLessThan60Days.add(child);
                        }
                    }

                    //SETTING CHILDREN's METADATA
                    if (!childrenLessThan60Days.isEmpty()) {
                        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.DELIVERY_DATE_DISPLAY,
                                sdf.format(childrenLessThan60Days.get(0).getDob()));
                        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.DELIVERY_DATE,
                                Long.toString(childrenLessThan60Days.get(0).getDob().getTime()));

                        int i = 0;
                        for (MemberBean child : childrenLessThan60Days) {
                            if (i == 0) {
                                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.UNIQUE_HEALTH_ID_CHILD, child.getUniqueHealthId());
                                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CHILD_NAME, child.getFirstName());
                                Set<String> dueImmunisations;
                                if (GlobalTypes.FLAVOUR_CHIP.equalsIgnoreCase(BuildConfig.FLAVOR)) {
                                    dueImmunisations = immunisationService.getDueImmunisationsForChildZambia(child.getDob(), child.getImmunisationGiven(), new Date(), null, false);
                                } else {
                                    dueImmunisations = immunisationService.getDueImmunisationsForChild(child.getDob(), child.getImmunisationGiven(), new Date(), null, false);
                                }

                                if (dueImmunisations != null && !dueImmunisations.isEmpty()) {
                                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.REMAINING_VACCINES,
                                            dueImmunisations.toString().replace("[", "").replace("]", ""));
                                }
                            } else {
                                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.UNIQUE_HEALTH_ID_CHILD + i, child.getUniqueHealthId());
                                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CHILD_NAME + i, child.getFirstName());
                                Set<String> dueImmunisations;
                                if (GlobalTypes.FLAVOUR_CHIP.equalsIgnoreCase(BuildConfig.FLAVOR)) {
                                    dueImmunisations = immunisationService.getDueImmunisationsForChildZambia(child.getDob(), child.getImmunisationGiven(), new Date(), null, false);
                                } else {
                                    dueImmunisations = immunisationService.getDueImmunisationsForChild(child.getDob(), child.getImmunisationGiven(), new Date(), null, false);
                                }
                                if (dueImmunisations != null && !dueImmunisations.isEmpty()) {
                                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.REMAINING_VACCINES + i,
                                            dueImmunisations.toString().replace("[", "").replace("]", ""));
                                }
                            }
                            i++;
                        }
                    }

                    SharedStructureData.totalFamilyMembersCount = childrenLessThan60Days.size();
                } else {
                    SharedStructureData.totalFamilyMembersCount = 0;
                }
            }
        } catch (SQLException e) {
            Log.e(getClass().getSimpleName(), null, e);
        }

        switch (formType) {
            case FormConstants.LMP_FOLLOW_UP:
            case FormConstants.ASHA_LMPFU:
            case FormConstants.FHW_PREGNANCY_CONFIRMATION:
            case FormConstants.CHIP_COVID_SCREENING:
            case FormConstants.CHIP_ACTIVE_MALARIA:
            case FormConstants.CHIP_PASSIVE_MALARIA:
            case FormConstants.MALARIA_INDEX:
            case FormConstants.MALARIA_NON_INDEX:
            case FormConstants.CHIP_TB:
            case FormConstants.CHIP_TB_FOLLOW_UP:
            case FormConstants.CHIP_FP_FOLLOW_UP:
            case FormConstants.CHIP_GBV_SCREENING:
            case FormConstants.TECHO_FHW_RIM:
            case FormConstants.CAM_RIM:
            case FormConstants.CHIP_ACTIVE_MALARIA_FOLLOW_UP:
            case FormConstants.CHIP_INDEX_INVESTIGATION:

                if (memberBean.getMaritalStatus() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.DEFAULT_MARITAL_STATUS, memberBean.getMaritalStatus());
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MARITAL_STATUS,
                            UtilBean.getNotAvailableIfNull(fhsService.getValueOfListValuesById(memberBean.getMaritalStatus())));
                }
                try {
                    List<StockInventoryBean> stockInventoryBean = stockInventoryBeanDao.queryBuilder().query();
                    for (StockInventoryBean stock : stockInventoryBean) {
                        String constant = fhsService.getConstOfListValueById(String.valueOf(stock.getMedicineId()));
                        SharedStructureData.relatedPropertyHashTable.put(constant, String.valueOf(stock.getDeliveredQuantity() - stock.getUsed()));
                    }
                } catch (SQLException e) {
                    Log.e(getClass().getSimpleName(), null, e);
                }
                MemberBean mother;
                if (memberBean.getMotherId() != null) {
                    try {
                        mother = memberBeanDao.queryBuilder().where().eq("actualID", memberBean.getMotherId()).queryForFirst();
                        if (mother != null) {
                            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MOTHER_NAME, UtilBean.getMemberFullName(mother));
                        }
                    } catch (SQLException e) {
                        throw new RuntimeException(e);
                    }
                } else {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MOTHER_NAME, "Not Available");
                }

                if (memberBean.getLmpDate() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LAST_LMP, sdf.format(memberBean.getLmpDate()));
                }
                if (memberBean.getYearOfWedding() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MARRIAGE_YEAR, memberBean.getYearOfWedding().toString());
                }
                if (memberBean.getDob() != null && memberBean.getYearOfWedding() != null) {
                    Calendar c = Calendar.getInstance();
                    c.setTime(memberBean.getDob());
                    Integer yearOfBirth = c.get(Calendar.YEAR);
                    Integer yearOfWedding = memberBean.getYearOfWedding();
                    Integer ageAtWedding = yearOfWedding - yearOfBirth;
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.AGE_AT_WEDDING, ageAtWedding + " " + LabelConstants.YEARS);
                }

                if (memberBean.getDateOfWedding() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.DATE_OF_WEDDING, String.valueOf(memberBean.getDateOfWedding().getTime()));
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.DATE_OF_WEDDING_DISPLAY, sdf.format(memberBean.getDateOfWedding()));
                }

                SharedStructureData.membersUnderTwenty = getMembersLessThan20(memberBean.getFamilyId(), new MemberDataBean(memberBean));
                if (!SharedStructureData.membersUnderTwenty.isEmpty()) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MEMBERS_UNDER_20_AVAILABLE, "T");
                } else {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MEMBERS_UNDER_20_AVAILABLE, "F");
                }

                if (FormConstants.CHIP_ACTIVE_MALARIA.equalsIgnoreCase(formType) || FormConstants.CHIP_ACTIVE_MALARIA_FOLLOW_UP.equalsIgnoreCase(formType)) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MALARIA_TYPE, "ACTIVE");
                } else if (FormConstants.CHIP_PASSIVE_MALARIA.equalsIgnoreCase(formType)) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MALARIA_TYPE, "PASSIVE");
                }

                if (memberBean.getIsPregnantFlag() != null && memberBean.getIsPregnantFlag() || UtilBean.calculateAge(memberBean.getDob()) < 5 || UtilBean.calculateAge(memberBean.getDob()) > 65) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.POTENTIAL_MALARIA_CASE, "1");
                } else {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.POTENTIAL_MALARIA_CASE, "0");
                }


                if (memberBean.getIsPregnantFlag() != null && memberBean.getIsPregnantFlag() || UtilBean.calculateAge(memberBean.getDob()) < 5 || UtilBean.calculateAge(memberBean.getDob()) > 65) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.POTENTIAL_MALARIA_CASE, "1");
                } else {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.POTENTIAL_MALARIA_CASE, "0");
                }

                if (FormConstants.CHIP_TB.equalsIgnoreCase(formType)) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.TB_SCREENING_TYPE, "TB_SCREENING");
                } else if (FormConstants.CHIP_TB_FOLLOW_UP.equalsIgnoreCase(formType)) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.TB_SCREENING_TYPE, "TB_FOLLOW_UP");
                }

                if (memberBean.getIsPregnantFlag() != null && memberBean.getIsPregnantFlag() || UtilBean.calculateAge(memberBean.getDob()) < 5 || UtilBean.calculateAge(memberBean.getDob()) > 65) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.POTENTIAL_MALARIA_CASE, "1");
                } else {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.POTENTIAL_MALARIA_CASE, "0");
                }


                if (memberBean.getIsPregnantFlag() != null && memberBean.getIsPregnantFlag() || UtilBean.calculateAge(memberBean.getDob()) < 5 || UtilBean.calculateAge(memberBean.getDob()) > 65) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.POTENTIAL_MALARIA_CASE, "1");
                } else {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.POTENTIAL_MALARIA_CASE, "0");
                }


                if (memberBean.getHusbandId() != null) {
                    MemberBean husband = fhsService.retrieveMemberBeanByActualId(memberBean.getHusbandId());
                    if (husband != null && husband.getSickleCellStatus() != null && !husband.getSickleCellStatus().isEmpty()) {
                        SharedStructureData.relatedPropertyHashTable.put("fatherSickleCellStatus", husband.getSickleCellStatus());
                    }
                }

                if (memberBean.getMobileNumber() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MOBILE_NUMBER, memberBean.getMobileNumber());
                }

                if (memberBean.getHusbandId() != null) {
                    MemberBean husband = fhsService.retrieveMemberBeanByActualId(memberBean.getHusbandId());
                    if (husband != null && !UtilBean.getMemberFullName(husband).isEmpty()) {
                        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.HUSBAND_NAME, UtilBean.getMemberFullName(husband));
                    }
                }
                if (memberAdditionalInfo.getRchId() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.RCH_ID, memberAdditionalInfo.getRchId());
                }

                break;

            case FormConstants.TECHO_FHW_ANC:
            case FormConstants.CAM_ANC:
            case FormConstants.ASHA_ANC:
            case FormConstants.HIV_POSITIVE:
            case FormConstants.HIV_SCREENING:
                try {
                    if (SewaTransformer.loginBean.getIsSmagTrained() != null && SewaTransformer.loginBean.getIsSmagTrained()) {
                        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IS_SMAG_TRAINED, "1");
                    } else {
                        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IS_SMAG_TRAINED, "2");
                    }
                    List<StockInventoryBean> stockInventoryBean = stockInventoryBeanDao.queryBuilder().query();
                    for (StockInventoryBean stock : stockInventoryBean) {
                        String constant = fhsService.getConstOfListValueById(String.valueOf(stock.getMedicineId()));
                        SharedStructureData.relatedPropertyHashTable.put(constant, String.valueOf(stock.getDeliveredQuantity() - stock.getUsed()));
                    }


                    if (memberBean.getDob() != null) {
                        if (memberBean.getYearOfWedding() != null) {
                            Calendar c = Calendar.getInstance();
                            c.setTime(memberBean.getDob());
                            Integer yearOfBirth = c.get(Calendar.YEAR);
                            Integer yearOfWedding = memberBean.getYearOfWedding();
                            Integer ageAtWedding = yearOfWedding - yearOfBirth;
                            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.AGE_AT_WEDDING, ageAtWedding + " " + LabelConstants.YEARS);
                        }

                        if (memberBean.getDateOfWedding() != null) {
                            Calendar c = Calendar.getInstance();
                            c.setTime(memberBean.getDob());
                            Integer yearOfBirth = c.get(Calendar.YEAR);

                            c.setTime(memberBean.getDateOfWedding());
                            Integer yearOfWedding = c.get(Calendar.YEAR);
                            Integer ageAtWedding = yearOfWedding - yearOfBirth;
                            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.AGE_AT_WEDDING, ageAtWedding + " " + LabelConstants.YEARS);
                        }
                    }

                    SharedStructureData.membersUnderTwenty = this.getMembersLessThan20(memberBean.getFamilyId(), new MemberDataBean(memberBean));

                    if (this.checkIfMotherWasPregnantWithinLast3Years(memberBean)) {
                        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.PREGNANT_LAST_3_YRS, LabelConstants.YES);
                    } else {
                        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.PREGNANT_LAST_3_YRS, LabelConstants.NO);
                    }

                    if (memberBean.getImmunisationGiven() != null) {
                        if (memberBean.getImmunisationGiven().contains(RchConstants.TT_BOOSTER)) {
                            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.TT, RchConstants.TT_BOOSTER);
                        } else if (memberBean.getImmunisationGiven().contains(RchConstants.TT2)) {
                            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.TT, RchConstants.TT2);
                        } else if (memberBean.getImmunisationGiven().contains(RchConstants.TT1)) {
                            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.TT, RchConstants.TT1);
                        }

                        if (memberBean.getImmunisationGiven().contains(RchConstants.TT1)) {
                            String[] splitArray = memberBean.getImmunisationGiven().split(",");
                            for (String split : splitArray) {
                                String[] split1 = split.split("#");
                                if (split1[0].equals(RchConstants.TT1)) {
                                    SharedStructureData.relatedPropertyHashTable.put(
                                            RelatedPropertyNameConstants.TT_1_GIVEN_ON, String.valueOf(sdf.parse(split1[1]).getTime()));
                                }
                            }
                        }
                    }

                } catch (SQLException | ParseException e) {
                    Log.e(getClass().getSimpleName(), null, e);
                }

                if (memberBean.getCurrentDiseaseIds() != null) {
                    StringBuilder sb = new StringBuilder();
                    for (String diseaseId : memberBean.getCurrentDiseaseIds().split(",")) {
                        try {
                            sb.append(listValueBeanDao.queryBuilder()
                                    .where().eq(FieldNameConstants.ID_OF_VALUE, diseaseId).queryForFirst().getValue());
                            sb.append("\n");
                        } catch (SQLException e) {
                            Log.e(getClass().getSimpleName(), null, e);
                        }
                    }
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.PREVIOUS_ILLNESS, sb.toString());
                } else {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.PREVIOUS_ILLNESS, LabelConstants.NONE);
                }

                if (memberBean.getHaemoglobin() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LAST_HAEMOGLOBIN,
                            memberBean.getHaemoglobin().toString());
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LAST_HAEMOGLOBIN_DISPLAY,
                            memberBean.getHaemoglobin().toString() + " " + UtilBean.getMyLabel("gm"));
                }

                if (memberBean.getWeight() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LAST_WEIGHT,
                            memberBean.getWeight().toString() + UtilBean.getMyLabel(" Kgs"));
                }

                if (familyDataBean.getBplFlag() != null && familyDataBean.getBplFlag()) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.ELIGIBILITY_CRITERIA, LabelConstants.FAMILY_IS_BPL);
                } else {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.ELIGIBILITY_CRITERIA, LabelConstants.FAMILY_IS_NOT_BPL);
                }

                if (memberBean.getLmpDate() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.GESTATIONAL_AGE, calculateGestationalAgeInWeeks(memberBean.getLmpDate()) + " Weeks");
                }

                if (memberBean.getMobileNumber() != null) {
                    String mob = null;
                    if (memberBean.getMobileNumber().contains("F/")) {
                        mob = memberBean.getMobileNumber().replace("F/", "");
                    }
                    if (memberBean.getMobileNumber().contains("T")) {
                        mob = memberBean.getMobileNumber().replace("T", "");
                    }
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.PHONE_NUMBER, mob);
                }

                if (memberBean.getMobileNumber() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MOBILE_NUMBER, memberBean.getMobileNumber());
                }


                if (memberBean.getCurPregRegDate() != null && memberBean.getLmpDate() != null) {
                    Calendar calendar = Calendar.getInstance();
                    calendar.setTime(memberBean.getLmpDate());
                    calendar.add(Calendar.DATE, 90);

                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CUR_PREG_REG_DATE, String.valueOf(memberBean.getCurPregRegDate().getTime()));

                    if (calendar.getTime().after(memberBean.getCurPregRegDate())) {
                        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.EARLY_REGISTRATION, LabelConstants.YES);
                    } else {
                        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.EARLY_REGISTRATION, LabelConstants.NO);
                    }
                }

                if (memberBean.getHighRiskCase() != null && memberBean.getHighRiskCase()) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.HIGH_RISK_CONDITIONS, LabelConstants.YES);
                } else {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.HIGH_RISK_CONDITIONS, LabelConstants.NO);
                }

                if (memberBean.getImmunisationGiven() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IMMUNISATION_GIVEN, getImmunisationGivenString(memberBean));
                }

                if (memberBean.getPreviousPregnancyComplication() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.PREVIOUS_PREGNANCY_COMPLICATION, memberBean.getPreviousPregnancyComplication());
                }

                if (memberAdditionalInfo.getHbsagTest() != null && !memberAdditionalInfo.getHbsagTest().equals(RchConstants.NOT_DONE)) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.HBSAG_TEST, memberAdditionalInfo.getHbsagTest());
                }

                if (memberAdditionalInfo.getHivTest() != null && !memberAdditionalInfo.getHivTest().equals(RchConstants.NOT_DONE)) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.HIV_TEST, memberAdditionalInfo.getHivTest());
                }

                if (memberAdditionalInfo.getVdrlTest() != null && !memberAdditionalInfo.getVdrlTest().equals(RchConstants.NOT_DONE)) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.VDRL_TEST, memberAdditionalInfo.getVdrlTest());
                }

                if (memberAdditionalInfo.getHavingBirthPlan() != null && memberAdditionalInfo.getHavingBirthPlan()) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.BIRTH_PLAN, "1");
                } else {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.BIRTH_PLAN, "2");
                }

                if (memberAdditionalInfo.getSickleCellTest() != null && !memberAdditionalInfo.getSickleCellTest().equals(RchConstants.NOT_DONE)) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.SICKLE_CELL_TEST, UtilBean.getSickleCellStatusFromConstant(memberAdditionalInfo.getSickleCellTest()));
                }

                if (memberAdditionalInfo.getHeight() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MEMBER_HEIGHT, memberAdditionalInfo.getHeight().toString());
                }

                if (memberAdditionalInfo.getAncAshaMorbidity() != null && !memberAdditionalInfo.getAncAshaMorbidity().isEmpty()) {
                    StringBuilder sb = new StringBuilder();
                    try {
                        Type type = new TypeToken<List<MorbidityDataBean>>() {
                        }.getType();
                        List<MorbidityDataBean> morbidityDataBeans = new Gson().fromJson(memberAdditionalInfo.getAncAshaMorbidity(), type);
                        int count = 0;
                        for (MorbidityDataBean morbidityDataBean : morbidityDataBeans) {
                            sb.append(++count)
                                    .append(". ")
                                    .append(UtilBean.getMyLabel(MorbiditiesConstant.getMorbidityCodeAsKEYandMorbidityNameAsVALUE(morbidityDataBean.getCode())))
                                    .append("\n");
                        }
                    } catch (JsonSyntaxException e) {
                        Log.e(getClass().getSimpleName(), null, e);
                        String ancAshaMorbidity = memberAdditionalInfo.getAncAshaMorbidity();
                        String[] splitComma = ancAshaMorbidity.split("#");
                        int count = 0;
                        for (String aCommaPart : splitComma) {
                            if (aCommaPart.contains("@")) {
                                String[] split = aCommaPart.split("@");
                                sb.append(++count)
                                        .append(". ")
                                        .append(UtilBean.getMyLabel(MorbiditiesConstant.getMorbidityCodeAsKEYandMorbidityNameAsVALUE(split[0])))
                                        .append("\n");
                            }
                        }
                    }
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.ANC_MORB_ASHA, sb.toString());
                }

                break;

            case FormConstants.TECHO_FHW_WPD:
            case FormConstants.CAM_WPD:
                if (memberBean.getEarlyRegistration() != null && memberBean.getEarlyRegistration()) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.EARLY_REGISTRATION, "Yes");
                } else {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.EARLY_REGISTRATION, "No");
                }


                if (memberBean.getAncVisitDates() != null) {
                    String[] dates = memberBean.getAncVisitDates().split(",");
                    StringBuilder ancVisitsString = new StringBuilder();
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.PREG_REGISTRATION_DATE, dates[0]);
                    int i = 1;
                    int counter = 0;
                    for (String date : dates) {
                        ancVisitsString.append("Visit ");
                        ancVisitsString.append(i++);
                        ancVisitsString.append(" - ");
                        ancVisitsString.append(date);
                        counter++;
                        if (counter != dates.length) {
                            ancVisitsString.append("\n");
                        }
                    }
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.ANC_DETAILS, ancVisitsString.toString());
                }

                if (memberBean.getMobileNumber() != null && !memberBean.getMobileNumber().isEmpty()) {
                    String mob = memberBean.getMobileNumber();
                    if (memberBean.getMobileNumber().contains("F/")) {
                        mob = memberBean.getMobileNumber().replace("F/", "");
                    }
                    if (memberBean.getMobileNumber().contains("T")) {
                        mob = memberBean.getMobileNumber().replace("T", "");
                    }
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.PHONE_NUMBER, mob);
                }

                if (memberBean.getCurrentDiseaseIds() != null) {
                    StringBuilder sb = new StringBuilder();
                    for (String diseaseId : memberBean.getCurrentDiseaseIds().split(",")) {
                        try {
                            sb.append(listValueBeanDao.queryBuilder()
                                    .where().eq(FieldNameConstants.ID_OF_VALUE, diseaseId).queryForFirst().getValue());
                            sb.append("\n");
                        } catch (SQLException e) {
                            Log.e(getClass().getSimpleName(), null, e);
                        }
                    }
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.PREVIOUS_ILLNESS, sb.toString());
                } else {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.PREVIOUS_ILLNESS, LabelConstants.NONE);
                }

                if (memberBean.getImmunisationGiven() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IMMUNISATION_GIVEN, getImmunisationGivenString(memberBean));
                }

                if (memberBean.getHighRiskCase() != null && memberBean.getHighRiskCase()) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.HIGH_RISK_CONDITIONS, LabelConstants.YES);
                } else {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.HIGH_RISK_CONDITIONS, LabelConstants.NO);
                }

                if (memberAdditionalInfo.getHivTest() != null && !memberAdditionalInfo.getHivTest().equals(RchConstants.NOT_DONE)) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.HIV_TEST, memberAdditionalInfo.getHivTest());
                }


                break;

            case FormConstants.TECHO_FHW_CS:
            case FormConstants.ASHA_CS:
            case FormConstants.ASHA_SAM_SCREENING:
            case FormConstants.FHW_SAM_SCREENING_REF:
            case FormConstants.CMAM_FOLLOWUP:
            case FormConstants.TECHO_AWW_CS:
            case FormConstants.SAM_SCREENING:
            case FormConstants.TECHO_AWW_THR:
            case FormConstants.DNHDD_FHW_SAM_SCREENING:
            case FormConstants.DNHDD_CMAM_FOLLOWUP:


                tmpDataObj = FullFormConstants.getFullFormOfGender(memberBean.getGender());
                if (tmpDataObj != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.GENDER, tmpDataObj);
                }
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CHILD_FIRST_NAME, memberBean.getFirstName());

                mother = null;
                try {
                    if (memberBean.getMotherId() != null || memberBean.getMotherUUID() != null) {
                        if (memberBean.getMotherId() != null) {
                            mother = memberBeanDao.queryBuilder().where().eq("actualID", memberBean.getMotherId()).queryForFirst();
                        }
                        if (mother == null && memberBean.getMotherUUID() != null) {
                            mother = memberBeanDao.queryBuilder().where().eq("memberUuid", memberBean.getMotherUUID()).queryForFirst();
                            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MOTHER_NAME, UtilBean.getMemberFullName(mother));
                            String religion = fhsService.getValueOfListValuesById(mother.getMemberReligion());
                            if (religion != null) {
                                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.RELIGION, religion);
                            }
                        }
                    }
                } catch (SQLException e) {
                    Log.e(getClass().getSimpleName(), null, e);
                }

                if (mother != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.PHONE_NUMBER, mother.getMobileNumber());
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MOTHER_HEALTH_ID, mother.getUniqueHealthId());
                }


                if (memberBean.getDob() != null) {
                    int ageInMonths = UtilBean.calculateMonthsBetweenDates(memberBean.getDob(), new Date());
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.AGE, String.valueOf(ageInMonths));
                    int[] yearMonthDayAge = UtilBean.calculateAgeYearMonthDay(memberBean.getDob().getTime());
                    String ageDisplay = UtilBean.getAgeDisplay(yearMonthDayAge[0], yearMonthDayAge[1], yearMonthDayAge[2]);
                    int ageDisplayWeeks = UtilBean.getNumberOfWeeks(memberBean.getDob(), new Date());
                    if (ageDisplay != null) {
                        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.AGE_DISPLAY, ageDisplay);
                        String weekOrWeeks = ageDisplayWeeks == 1 ? " Week" : " Weeks";
                        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.AGE_DISPLAY_WEEKS, ageDisplayWeeks + weekOrWeeks);
                    }
                }

                if (memberBean.getComplementaryFeedingStarted() != null && memberBean.getComplementaryFeedingStarted()) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.COMPLIMENTARY_FEEDING, "Yes");
                } else {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.COMPLIMENTARY_FEEDING, "No");
                }

                if (memberBean.getImmunisationGiven() != null && !memberBean.getImmunisationGiven().isEmpty()) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IMMUNISATION_GIVEN, memberBean.getImmunisationGiven());
                }
                Set<String> dueImmunisationsForChild;
                dueImmunisationsForChild = immunisationService.getDueImmunisationsForChildZambia(memberBean.getDob(), memberBean.getImmunisationGiven(), new Date(), null, false);

                if (dueImmunisationsForChild != null && !dueImmunisationsForChild.isEmpty()) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.REMAINING_VACCINES, dueImmunisationsForChild.toString().replace("[", "").replace("]", ""));
                }

                if (memberBean.getDob() != null) {
                    Calendar calendar = Calendar.getInstance();
                    calendar.add(Calendar.YEAR, 1);
                    if (memberBean.getDob().before(calendar.getTime())) {
                        calendar.add(Calendar.YEAR, 1);
                        if (memberBean.getDob().before(calendar.getTime())) {
                            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IMMUNISED_IN_TWO_YEAR, isChildImmunisedInTwoYearZambia(memberBean));
                            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.FULLY_IMMUNIZED_OR_NOT, isChildImmunisedInTwoYearZambia(memberBean));
                        }
                        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IMMUNISED_IN_ONE_YEAR, isChildImmunisedInOneYear(memberBean));
                    }
                }

                try {
                    List<VersionBean> featureVersionBeans = versionBeanDao.queryForEq("key", GlobalTypes.VERSION_FEATURES_LIST);
                    if (featureVersionBeans != null && !featureVersionBeans.isEmpty()) {
                        VersionBean versionBean = featureVersionBeans.get(0);
                        if (versionBean.getValue().contains(GlobalTypes.MOB_FEATURE_CEREBRAL_PALSY_SCREENING)) {
                            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CP_SCREENING, GlobalTypes.MOB_FEATURE_CEREBRAL_PALSY_SCREENING);
                        }
                    }
                } catch (SQLException e) {
                    Log.e(getClass().getSimpleName(), null, e);
                }

                if (memberAdditionalInfo.getWtGainStatus() != null && !memberAdditionalInfo.getWtGainStatus().isEmpty()) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.WT_GAIN_STATUS, memberAdditionalInfo.getWtGainStatus());
                }

                if (memberAdditionalInfo.getGivenRUTF() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.GIVEN_RUTF, memberAdditionalInfo.getGivenRUTF().toString());
                }

                if (memberAdditionalInfo.getCpNegativeQues() != null && !memberAdditionalInfo.getCpNegativeQues().isEmpty()) {
                    Set<String> allCpQuestions = new HashSet<>(GlobalTypes.CEREBRAL_PALSY_QUESTION_IDS_MAP.keySet());
                    allCpQuestions.removeAll(memberAdditionalInfo.getCpNegativeQues());
                    String key;
                    for (String que : allCpQuestions) {
                        key = GlobalTypes.CEREBRAL_PALSY_QUESTION_IDS_MAP.get(que);
                        if (key != null) {
                            SharedStructureData.relatedPropertyHashTable.put(key, "Yes");
                        }
                    }
                }

                if (memberAdditionalInfo.getCpState() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CP_STATUS, memberAdditionalInfo.getCpState());
                }

                if (memberAdditionalInfo.getLastSamScreeningDate() != null) {
                    Calendar instance = Calendar.getInstance();
                    instance.set(Calendar.DATE, 1);
                    instance.set(Calendar.HOUR_OF_DAY, 0);
                    instance.set(Calendar.MINUTE, 0);
                    instance.set(Calendar.SECOND, 0);
                    instance.set(Calendar.MILLISECOND, 0);
                    if (new Date(memberAdditionalInfo.getLastSamScreeningDate()).after(instance.getTime())) {
                        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.SAM_SCREENING_DONE, "T");
                    } else {
                        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.SAM_SCREENING_DONE, "F");
                    }

                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LAST_SAM_SCREENING_DATE, memberAdditionalInfo.getLastSamScreeningDate().toString());

                } else {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.SAM_SCREENING_DONE, "F");
                }

                SharedStructureData.vaccineGivenDateMap.clear();
                if (memberBean.getImmunisationGiven() != null && !memberBean.getImmunisationGiven().isEmpty()) {
                    Map<String, Date> vaccineGivenDateMapTemp = new HashMap<>();
                    StringTokenizer vaccineTokenizer = new StringTokenizer(memberBean.getImmunisationGiven(), ",");
                    while (vaccineTokenizer.hasMoreElements()) {
                        String[] vaccine = vaccineTokenizer.nextToken().split("#");
                        String givenVaccineName = vaccine[0].trim();
                        try {
                            vaccineGivenDateMapTemp.put(givenVaccineName, sdf.parse(vaccine[1]));
                        } catch (ParseException e) {
                            Log.e(getClass().getSimpleName(), null, e);
                        }
                    }

                    if (!vaccineGivenDateMapTemp.isEmpty()) {
                        SharedStructureData.vaccineGivenDateMap = vaccineGivenDateMapTemp;
                    }
                }

                String religion = fhsService.getValueOfListValuesById(memberBean.getMemberReligion());
                if (religion != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.RELIGION, religion);
                }

                if (familyDataBean.getCaste() != null) {
                    String caste = fhsService.getValueOfListValuesById(familyDataBean.getCaste());
                    if (caste != null) {
                        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CASTE, caste);
                    }
                }

                if (memberAdditionalInfo.getLastTHRServiceDate() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LAST_THR_SERVICE_DATE, memberAdditionalInfo.getLastTHRServiceDate().toString());
                }

                if (memberAdditionalInfo.getWeightMap() != null && !memberAdditionalInfo.getWeightMap().isEmpty()) {
                    Long lastEntryDate = Collections.max(memberAdditionalInfo.getWeightMap().keySet());
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LAST_WEIGHT_AND_DATE,
                            memberAdditionalInfo.getWeightMap().get(lastEntryDate) + " " + UtilBean.getMyLabel("Kgs"));
                }
                if (memberAdditionalInfo.getRchId() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.RCH_ID, memberAdditionalInfo.getRchId());
                }

                if (memberBean.getBirthWeight() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.BIRTH_WEIGHT, memberBean.getBirthWeight().toString());
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.BIRTH_WEIGHT_DISPLAY, memberBean.getBirthWeight().toString() + " " + UtilBean.getMyLabel("Kgs"));
                }

                break;

            case FormConstants.TECHO_FHW_PNC:
            case FormConstants.ASHA_PNC:
                if (memberBean.getLastDeliveryDate() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.DELIVERY_DATE_DISPLAY, sdf.format(memberBean.getLastDeliveryDate()));
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.DELIVERY_DATE, Long.toString(memberBean.getLastDeliveryDate().getTime()));
                }

                if (memberBean.getMobileNumber() != null && !memberBean.getMobileNumber().isEmpty()) {
                    String mob = memberBean.getMobileNumber();
                    if (memberBean.getMobileNumber().contains("F/")) {
                        mob = memberBean.getMobileNumber().replace("F/", "");
                    }
                    if (memberBean.getMobileNumber().contains("T")) {
                        mob = memberBean.getMobileNumber().replace("T", "");
                    }
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.PHONE_NUMBER, mob);
                }

                if (selectedNotification != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.SERVICE_NUMBER, selectedNotification.getCustomField());
                }

                if (memberAdditionalInfo.getPncIfa() != null && memberAdditionalInfo.getPncIfa() > 0) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.PNC_IFA, memberAdditionalInfo.getPncIfa().toString());
                }

                if (memberAdditionalInfo.getPncCalcium() != null && memberAdditionalInfo.getPncCalcium() > 0) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.PNC_CALCIUM, memberAdditionalInfo.getPncCalcium().toString());
                }


                if (memberBean.getCurrentGravida() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.GRAVIDA_VALUE, memberBean.getCurrentGravida().toString());
                }

                if (memberBean.getCurrentPara() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CURRENT_PARA, String.valueOf(memberBean.getCurrentPara() + 1));
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.DEFAULT_PARA, String.valueOf(memberBean.getCurrentPara() + 1));
                } else {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CURRENT_PARA, ("1"));
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.DEFAULT_PARA, ("1"));
                }


                break;

            case FormConstants.TECHO_WPD_DISCHARGE:
                if (memberBean.getLastDeliveryDate() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.DELIVERY_DATE_DISPLAY,
                            sdf.format(memberBean.getLastDeliveryDate()));
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.DELIVERY_DATE,
                            String.valueOf(memberBean.getLastDeliveryDate().getTime()));
                }
                if (selectedNotification != null && selectedNotification.getOtherDetails() != null) {
                    try {
                        HealthInfrastructureBean infrastructureBean = healthInfrastructureBeanDao.queryBuilder().where()
                                .eq(FieldNameConstants.ACTUAL_ID, selectedNotification.getOtherDetails()).queryForFirst();
                        if (infrastructureBean != null) {
                            SharedStructureData.selectedHealthInfra = infrastructureBean;
                        }
                    } catch (SQLException e) {
                        Log.e(getClass().getSimpleName(), null, e);
                    }
                }
                break;

            case FormConstants.TECHO_FHW_VAE:
                String immunisationGivenString = memberBean.getImmunisationGiven();
                List<String> immunisationsGiven = new ArrayList<>();

                List<OptionDataBean> options = new ArrayList<>();
                options.add(new OptionDataBean("-1", GlobalTypes.SELECT, null));
                if (immunisationGivenString != null) {
                    for (String vac : immunisationGivenString.split(",")) {
                        immunisationsGiven.add(vac.split("#")[0]);
                    }
                    for (String str : immunisationsGiven) {
                        OptionDataBean optionDataBean = new OptionDataBean();
                        optionDataBean.setKey(str);
                        optionDataBean.setValue(FullFormConstants.getFullFormOfVaccines(str));
                        options.add(optionDataBean);
                    }
                }
                SharedStructureData.givenVaccinesToChild = options;
                break;

            case FormConstants.GERIATRICS_MEDICATION_ALERT:
                List<MemberBean> memberBeans = SharedStructureData.sewaFhsService.retrieveFamilyMembersContactListByMember(memberBean.getFamilyId(), memberBean.getActualId());
                StringBuilder contactDetails = new StringBuilder();
                if (memberBeans.isEmpty()) {
                    contactDetails = new StringBuilder(GlobalTypes.NOT_AVAILABLE);
                } else {
                    for (MemberBean member : memberBeans) {
                        if (contactDetails.length() != 0) {
                            contactDetails.append("\n");
                        }
                        contactDetails.append(member.getFirstName())
                                .append(" ")
                                .append(member.getMiddleName())
                                .append(" ")
                                .append(member.getLastName())
                                .append(" - ")
                                .append(member.getMobileNumber());
                    }
                }
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CONTACT_DETAILS, contactDetails.toString());

                if (memberBean.getGender() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.GENDER,
                            UtilBean.getGenderLabelFromValue(memberBean.getGender()));
                }
                break;

            case FormConstants.IDSP_MEMBER:
            case FormConstants.IDSP_MEMBER_2:
                if (memberBean.getGender() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.GENDER_DISPLAY,
                            UtilBean.getGenderLabelFromValue(memberBean.getGender()));
                }

                if (memberBean.getMobileNumber() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MOBILE_NUMBER, memberBean.getMobileNumber());
                }
                break;
            default:
        }
        editor.commit();
    }

    public void setMetaDataActiveMalariaFromNearbyHousehold(String memberActualId, String familyId, SharedPreferences sharedPref, boolean isFromNearbyHousehold) {

        SharedPreferences.Editor editor = sharedPref.edit();
        editor.clear().apply();

        SimpleDateFormat sdf = new SimpleDateFormat(GlobalTypes.DATE_DD_MM_YYYY_FORMAT, Locale.getDefault());
        SharedStructureData.relatedPropertyHashTable.clear();
        SharedStructureData.membersUnderTwenty.clear();
        SharedStructureData.selectedHealthInfra = null;
        SharedStructureData.highRiskConditions.clear();

        MemberBean memberBean = fhsService.retrieveMemberBeanByActualId(Long.valueOf(memberActualId));
        FamilyDataBean familyDataBean;
        if (familyId != null) {
            familyDataBean = fhsService.retrieveFamilyDataBeanByFamilyId(familyId);
        } else {
            familyDataBean = fhsService.retrieveFamilyDataBeanByFamilyId(memberBean.getFamilyId());
        }

        if (familyDataBean.getAreaId() != null) {
            editor.putString(RelatedPropertyNameConstants.LOCATION_ID, familyDataBean.getAreaId());
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LOCATION_ID, familyDataBean.getAreaId());
        } else {
            editor.putString(RelatedPropertyNameConstants.LOCATION_ID, familyDataBean.getLocationId());
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LOCATION_ID, familyDataBean.getLocationId());
        }
        editor.putString(RelatedPropertyNameConstants.MEMBER_ACTUAL_ID, memberBean.getActualId());

        HealthInfrastructureBean healthInfraBean = healthInfrastructureService.retrieveHealthInfrastructureAssignedToUser(SewaTransformer.loginBean.getUserID());
        if (healthInfraBean != null) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IS_DEFAULT_HEALTH_INFRA_ASSIGNED, "1");
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.USER_ASSIGNED_HEALTH_INFRA_ID, String.valueOf(healthInfraBean.getActualId()));
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.USER_ASSIGNED_HEALTH_INFRA_NAME, String.valueOf(healthInfraBean.getName()));
        } else {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IS_DEFAULT_HEALTH_INFRA_ASSIGNED, "2");
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.USER_ASSIGNED_HEALTH_INFRA_ID, null);
        }

        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.UNIQUE_HEALTH_ID, memberBean.getUniqueHealthId());
        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MEMBER_NAME, UtilBean.getMemberFullName(memberBean));
        if (memberBean.getDob() != null) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.DOB, memberBean.getDob().toString());
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.DOB_DISPLAY, sdf.format(memberBean.getDob()));
        }


        if (isFromNearbyHousehold) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IS_FROM_NEARBY_HOUSE_HOLD, "1");
        } else {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IS_FROM_NEARBY_HOUSE_HOLD, "2");
        }

        if (memberBean.getGender() != null) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.GENDER,
                    UtilBean.getGenderLabelFromValue(memberBean.getGender()));
        }

        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MEMBER_ACTUAL_ID, memberBean.getActualId());
        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.NAME_OF_BENEFICIARY, UtilBean.getMemberFullName(memberBean));
        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MARITAL_STATUS,
                UtilBean.getNotAvailableIfNull(fhsService.getValueOfListValuesById(memberBean.getMaritalStatus())));
        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.BENEFICIARY_NAME_FOR_LOG,
                UtilBean.getMemberFullName(memberBean) + "(" + memberBean.getUniqueHealthId() + ")");
        editor.commit();
    }

    public List<OptionDataBean> getMembersLessThan20(String familyId, MemberDataBean memberDataBean) {
        Calendar instance = Calendar.getInstance();
        List<OptionDataBean> membersLessThan20 = new ArrayList<>();
        StringBuilder selectedChildren = new StringBuilder();

        try {
            if (memberDataBean != null && memberDataBean.getDob() != null) {
                instance.setTimeInMillis(memberDataBean.getDob());
                instance.add(Calendar.YEAR, 16);
            } else {
                instance.add(Calendar.YEAR, -20);
            }

            List<MemberBean> memberBeans = memberBeanDao.queryBuilder().where()
                    .eq(FieldNameConstants.FAMILY_ID, familyId)
                    .and().isNull(FieldNameConstants.MOTHER_ID)
                    .and().gt(FieldNameConstants.DOB, instance.getTime())
                    .and().notIn(FieldNameConstants.STATE, invalidStates).query();

            if (memberDataBean != null && memberDataBean.getId() != null) {
                List<MemberBean> children = memberBeanDao.queryBuilder().where()
                        .eq(FieldNameConstants.MOTHER_ID, memberDataBean.getId())
                        .and().eq(FieldNameConstants.FAMILY_ID, memberDataBean.getFamilyId())
                        .and().ne(FieldNameConstants.ACTUAL_ID, memberDataBean.getId())
                        .and().notIn(FieldNameConstants.STATE, invalidStates).query();

                for (MemberBean memberBean : children) {
                    selectedChildren.append(memberBean.getActualId() != null ? memberBean.getActualId() : memberBean.getUniqueHealthId()).append(",");
                    if (!memberBeans.contains(memberBean)) {
                        memberBeans.add(memberBean);
                    }
                }

                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.ACTUAL_GRAVIDA, String.valueOf(children.size()));
                if (!children.isEmpty()) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.SELECTED_CHILDREN, selectedChildren.toString());
                }
            }
            if (memberDataBean != null && memberDataBean.getMemberUuid() != null) {
                List<MemberBean> children = memberBeanDao.queryBuilder().where()
                        .eq(FieldNameConstants.MOTHER_UUID, memberDataBean.getMemberUuid())
                        .and().eq(FieldNameConstants.MEMBERS_FAMILY_UUID, memberDataBean.getFamilyUuid())
                        .and().ne(FieldNameConstants.MEMBER_UUID, memberDataBean.getMemberUuid())
                        .and().notIn(FieldNameConstants.STATE, invalidStates).query();
                for (MemberBean memberBean : children) {
                    selectedChildren.append(memberBean.getActualId() != null ? memberBean.getActualId() : memberBean.getUniqueHealthId()).append(",");
                    if (!memberBeans.contains(memberBean)) {
                        memberBeans.add(memberBean);
                    }

                }
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.ACTUAL_GRAVIDA, String.valueOf(children.size()));
                if (!children.isEmpty()) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.SELECTED_CHILDREN, selectedChildren.toString());
                }
            }

            for (MemberBean memberBean : memberBeans) {
                membersLessThan20.add(new OptionDataBean(memberBean.getActualId() != null ? memberBean.getActualId() : memberBean.getUniqueHealthId(), UtilBean.getMemberFullName(memberBean), null));
            }
        } catch (SQLException e) {
            Log.e(getClass().getSimpleName(), null, e);
        }
        return membersLessThan20;
    }

    private boolean checkIfMotherWasPregnantWithinLast3Years(MemberBean memberBean) {
        if (memberBean.getLmpDate() == null || memberBean.getLastDeliveryDate() == null) {
            return false;
        }
        return UtilBean.calculateYearsBetweenDates(memberBean.getLmpDate().getTime(), memberBean.getLastDeliveryDate().getTime()) <= 2.0;
    }

    private String getImmunisationGivenString(MemberBean memberBean) {
        String[] immunisationAndDate = memberBean.getImmunisationGiven().split(",");
        StringBuilder immunisationString = new StringBuilder();
        int counter = 0;
        for (String date : immunisationAndDate) {
            String[] split = date.split("#");
            immunisationString.append(UtilBean.getMyLabel(split[0]));
            immunisationString.append(" - ");
            immunisationString.append(split[1]);
            counter++;
            if (counter != immunisationAndDate.length) {
                immunisationString.append("\n");
            }
        }
        return immunisationString.toString().replace("_", " ");
    }

    public String isChildImmunisedInOneYear(MemberBean memberBean) {
        if (memberBean.getImmunisationGiven() != null && memberBean.getImmunisationGiven().length() > 0) {
            String[] immunisationGiven = memberBean.getImmunisationGiven().split(",");
            List<String> immunisationList = new ArrayList<>();
            for (String immunisation : immunisationGiven) {
                immunisationList.add(immunisation.split("#")[0]);
            }

            if (!immunisationList.isEmpty()) {
                if (immunisationList.contains(RchConstants.BCG)
                        && immunisationList.contains(RchConstants.OPV_1)
                        && immunisationList.contains(RchConstants.OPV_2)
                        && immunisationList.contains(RchConstants.OPV_3)
                        && (immunisationList.contains(RchConstants.PENTA_1) || immunisationList.contains(RchConstants.DPT_1))
                        && (immunisationList.contains(RchConstants.PENTA_2) || immunisationList.contains(RchConstants.DPT_2))
                        && (immunisationList.contains(RchConstants.PENTA_3) || immunisationList.contains(RchConstants.DPT_3))
                        && (immunisationList.contains(RchConstants.MEASLES_RUBELLA_1) || immunisationList.contains(RchConstants.MEASLES_1))) {
                    return UtilBean.getMyLabel(LabelConstants.YES);
                } else {
                    return UtilBean.getMyLabel(LabelConstants.NO);
                }
            } else {
                return UtilBean.getMyLabel(LabelConstants.NO);
            }
        } else {
            return UtilBean.getMyLabel(LabelConstants.NO);
        }
    }

    public String isChildImmunisedInTwoYear(MemberBean memberBean) {
        if (memberBean.getImmunisationGiven() != null && memberBean.getImmunisationGiven().length() > 0) {
            String[] immunisationGiven = memberBean.getImmunisationGiven().split(",");
            List<String> immunisationList = new ArrayList<>();
            for (String immunisation : immunisationGiven) {
                immunisationList.add(immunisation.split("#")[0]);
            }

            if (!immunisationList.isEmpty()) {
                if (immunisationList.contains(RchConstants.BCG)
                        && immunisationList.contains(RchConstants.OPV_1)
                        && immunisationList.contains(RchConstants.OPV_2)
                        && immunisationList.contains(RchConstants.OPV_3)
                        && immunisationList.contains(RchConstants.OPV_BOOSTER)
                        && (immunisationList.contains(RchConstants.PENTA_1) || immunisationList.contains(RchConstants.DPT_1))
                        && (immunisationList.contains(RchConstants.PENTA_2) || immunisationList.contains(RchConstants.DPT_2))
                        && (immunisationList.contains(RchConstants.PENTA_3) || immunisationList.contains(RchConstants.DPT_3))
                        && (immunisationList.contains(RchConstants.MEASLES_RUBELLA_1) || immunisationList.contains(RchConstants.MEASLES_1))
                        && (immunisationList.contains(RchConstants.MEASLES_RUBELLA_2) || immunisationList.contains(RchConstants.MEASLES_2))) {
                    return UtilBean.getMyLabel("Yes");
                } else {
                    return UtilBean.getMyLabel("No");
                }
            } else {
                return UtilBean.getMyLabel("No");
            }
        } else {
            return UtilBean.getMyLabel("No");
        }
    }

    public String isChildImmunisedInTwoYearZambia(MemberBean memberBean) {
        if (memberBean.getImmunisationGiven() != null && memberBean.getImmunisationGiven().length() > 0) {
            String[] immunisationGiven = memberBean.getImmunisationGiven().split(",");
            List<String> immunisationList = new ArrayList<>();
            for (String immunisation : immunisationGiven) {
                immunisationList.add(immunisation.split("#")[0]);
            }

            if (!immunisationList.isEmpty()) {
                if (immunisationList.contains(RchConstants.Z_BCG)
                        && immunisationList.contains(RchConstants.Z_VITTAMIN_A_50000)
                        && immunisationList.contains(RchConstants.Z_VITTAMIN_A_100000)
                        && immunisationList.contains(RchConstants.Z_VITTAMIN_A_200000_1)
                        && immunisationList.contains(RchConstants.Z_VITTAMIN_A_200000_2)
                        && immunisationList.contains(RchConstants.Z_VITTAMIN_A_200000_3)
                        && immunisationList.contains(RchConstants.Z_VITTAMIN_A_200000_4)
                        && immunisationList.contains(RchConstants.Z_VITTAMIN_A_200000_5)
                        && immunisationList.contains(RchConstants.Z_VITTAMIN_A_200000_6)
                        && immunisationList.contains(RchConstants.Z_VITTAMIN_A_200000_7)
                        && immunisationList.contains(RchConstants.Z_VITTAMIN_A_200000_8)
                        && immunisationList.contains(RchConstants.Z_OPV_0)
                        && immunisationList.contains(RchConstants.Z_OPV_1)
                        && immunisationList.contains(RchConstants.Z_OPV_2)
                        && immunisationList.contains(RchConstants.Z_OPV_3)
                        && immunisationList.contains(RchConstants.Z_PCV_1)
                        && immunisationList.contains(RchConstants.Z_PCV_2)
                        && immunisationList.contains(RchConstants.Z_PCV_3)
                        && immunisationList.contains(RchConstants.Z_DPT_HEB_HIB_1)
                        && immunisationList.contains(RchConstants.Z_DPT_HEB_HIB_2)
                        && immunisationList.contains(RchConstants.Z_DPT_HEB_HIB_3)
                        && immunisationList.contains(RchConstants.Z_ROTA_VACCINE_1)
                        && immunisationList.contains(RchConstants.Z_MEASLES_RUBELLA_1)
                        && immunisationList.contains(RchConstants.Z_MEASLES_RUBELLA_2)) {
                    return UtilBean.getMyLabel("Fully immunized");
                } else {
                    return UtilBean.getMyLabel("Not fully immunized");
                }
            } else {
                return UtilBean.getMyLabel("Not fully immunized");
            }
        } else {
            return UtilBean.getMyLabel("Not fully immunized");
        }
    }

    public static int calculateGestationalAgeInWeeks(Date lmpDate) {
        Date currentDate = new Date();
        assert lmpDate != null;
        long millisecondsDifference = currentDate.getTime() - lmpDate.getTime();
        long daysDifference = millisecondsDifference / (1000 * 60 * 60 * 24);
        int gestationalAgeInWeeks = (int) (daysDifference / 7);

        // Adjust for partial weeks
        if (daysDifference % 7 >= 4) {
            gestationalAgeInWeeks++;
        }
        return gestationalAgeInWeeks;
    }

    public void setMetaDataForMemberUpdateForm(MemberDataBean memberDataBean, FamilyDataBean familyDataBean, SharedPreferences sharedPreferences) {
        SimpleDateFormat sdf = new SimpleDateFormat(GlobalTypes.DATE_DD_MM_YYYY_FORMAT, Locale.getDefault());
        sharedPreferences.edit().clear().apply();
        SharedPreferences.Editor editor = sharedPreferences.edit();

        if (memberDataBean != null) {
            editor.putString(RelatedPropertyNameConstants.MEMBER_ACTUAL_ID, memberDataBean.getId());
        }
        if (familyDataBean != null) {
            editor.putString(RelatedPropertyNameConstants.FAMILY_ID, familyDataBean.getId());
            if (familyDataBean.getAreaId() != null) {
                editor.putString(RelatedPropertyNameConstants.LOCATION_ID, familyDataBean.getAreaId());
            } else {
                editor.putString(RelatedPropertyNameConstants.LOCATION_ID, familyDataBean.getLocationId());
            }
        }

        SharedStructureData.relatedPropertyHashTable.clear();
        SharedStructureData.currentFamilyDataBean = familyDataBean;
        SharedStructureData.currentMemberDataBean = memberDataBean;
        SharedStructureData.membersUnderTwenty.clear();

        if (familyDataBean != null && familyDataBean.getFamilyId() != null) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.ADDRESS, UtilBean.getFamilyFullAddress(familyDataBean));
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.UUID, familyDataBean.getUuid());
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.FAMILY_ID, familyDataBean.getFamilyId());
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MEMBERS_FAMILY_UUID, familyDataBean.getUuid());
            SharedStructureData.membersUnderTwenty = this.getMembersLessThan20(familyDataBean.getFamilyId(), null);
            if (!SharedStructureData.membersUnderTwenty.isEmpty()) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MEMBERS_UNDER_20_AVAILABLE, "T");
            } else {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MEMBERS_UNDER_20_AVAILABLE, "F");
            }

            List<String> familyIds = new ArrayList<>();
            familyIds.add(familyDataBean.getFamilyId());
            Map<String, MemberDataBean> headMemberDataBeanMap = fhsService.retrieveHeadMemberDataBeansByFamilyId(familyIds);
            MemberDataBean headMember = headMemberDataBeanMap.get(familyDataBean.getFamilyId());
            if (headMember != null && headMember.getDob() != null) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.HOF_NAME, UtilBean.getMemberFullName(headMember));
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.HOF_ID, headMember.getUniqueHealthId());
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.HEAD_OF_FAMILY_NUMBER, headMember.getMobileNumber());
                SharedStructureData.relatedPropertyHashTable.put("hofDob", headMember.getDob().toString());
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IS_HOF_AVAILABLE, "1");
                if (headMember.getGender() != null && headMember.getGender().equals(GlobalTypes.FEMALE)) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.HOF_GENDER, "2");
                } else {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.HOF_GENDER, "1");
                }

                if (headMember.getMobileNumber() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MINOR_MOBILE_NUMBER, headMember.getMobileNumber());
                }
            }
        }


        if (memberDataBean != null) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MEMBER_ID, memberDataBean.getId());
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MEMBER_UUID, memberDataBean.getMemberUuid());
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.NAME_OF_BENEFICIARY, UtilBean.getMemberFullName(memberDataBean));
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.AADHAR_NUMBER, memberDataBean.getAadharNumber());
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.BANK_ACCOUNT_NUMBER, memberDataBean.getAccountNumber());
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MIDDLE_NAME, memberDataBean.getMiddleName());
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.BENEFICIARY_NAME_FOR_LOG,
                    UtilBean.getMemberFullName(memberDataBean) + "(" + memberDataBean.getUniqueHealthId() + ")"); //for showing purpose...in worklog
            if (memberDataBean.getDob() != null) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.DOB, memberDataBean.getDob().toString());
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.DOB_DISPLAY, sdf.format(new Date(memberDataBean.getDob())));
            }
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.FAMILY_HEAD_FLAG, "2");
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.SINGLE_MEMBER_FAMILY, "2");
            if (memberDataBean.getFamilyHeadFlag() != null && memberDataBean.getFamilyHeadFlag()) {
                List<MemberDataBean> memberList = fhsService.retrieveMemberDataBeansByFamily(familyDataBean.getFamilyId());
                if (memberList != null && !memberList.isEmpty()) {
                    List<OptionDataBean> memberNameOptions = new ArrayList<>();
                    for (MemberDataBean member : memberList) {
                        if (member.getFamilyHeadFlag() == null || !member.getFamilyHeadFlag()) {
                            Calendar cal = Calendar.getInstance();
                            cal.add(Calendar.YEAR, -18);
                            Date before18Years = cal.getTime();
                            if (!FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES.contains(member.getState())) {
                                memberNameOptions.add(new OptionDataBean(member.getId(), UtilBean.getMemberFullName(member), null));
                            }
                        }
                    }
                    SharedStructureData.nonHofMemberNameList = memberNameOptions;
                }
                if (SharedStructureData.nonHofMemberNameList == null || SharedStructureData.nonHofMemberNameList.isEmpty()) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.SINGLE_MEMBER_FAMILY, "1");
                }
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.FAMILY_HEAD_FLAG, "1");
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.GRANDFATHER_NAME, memberDataBean.getGrandfatherName());
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.HEAD_OF_FAMILY, UtilBean.getMemberFullName(memberDataBean));
            }
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MEMBER_FULL_NAME, UtilBean.getMemberFullName(memberDataBean));
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.FIRST_NAME, memberDataBean.getFirstName());
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MIDDLE_NAME, memberDataBean.getMiddleName());
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LAST_NAME, memberDataBean.getLastName());
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MOBILE_NUMBER, memberDataBean.getMobileNumber());
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.PHONE_NUMBER, memberDataBean.getMobileNumber());
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IFSC, memberDataBean.getIfsc());
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.UNIQUE_HEALTH_ID, memberDataBean.getUniqueHealthId());
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.DEFAULT_MARITAL_STATUS, memberDataBean.getMaritalStatus());
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MARITAL_STATUS,
                    UtilBean.getNotAvailableIfNull(fhsService.getValueOfListValuesById(memberDataBean.getMaritalStatus())));
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.RELATION_WITH_HOF, memberDataBean.getRelationWithHof());
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.ANS_12, "1");

            if (memberDataBean.getMobileNumber() != null) {
                String mob = memberDataBean.getMobileNumber();
                if (memberDataBean.getMobileNumber().contains("F/")) {
                    mob = memberDataBean.getMobileNumber().replace("F/", "");
                }
                if (memberDataBean.getMobileNumber().contains("T")) {
                    mob = memberDataBean.getMobileNumber().replace("T", "");
                }
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MOBILE_NUMBER, mob);
            }


            if (memberDataBean.isAadharUpdated()) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.AADHAR_AVAILABLE, "1");
            } else {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.AADHAR_AVAILABLE, "2");
            }
            if (memberDataBean.getNormalCycleDays() != null) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.NORMAL_CYCLE_DAYS, memberDataBean.getNormalCycleDays().toString());
            }
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.FAMILY_PLANNING_METHOD, memberDataBean.getFamilyPlanningMethod());
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IS_PREGNANT, "2");

            if (memberDataBean.getGender() != null) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.GENDER,
                        UtilBean.getGenderLabelFromValue(memberDataBean.getGender()));
            }

            if (memberDataBean.getGender() != null && memberDataBean.getGender().equals(GlobalTypes.FEMALE)) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.ANS_12, "2");
                if (memberDataBean.getIsPregnantFlag() != null && memberDataBean.getIsPregnantFlag()) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IS_PREGNANT, "1");
                }
                if (memberDataBean.getIsPregnantFlag() == null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IS_PREGNANT, "5");
                }
                if (memberDataBean.getIsPregnantFlag() == null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IS_PREGNANT, "5");
                }
                if (memberDataBean.getLmpDate() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LAST_LMP, sdf.format(memberDataBean.getLmpDate()));
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LMP, memberDataBean.getLmpDate().toString());
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LMP_DATE, String.valueOf(memberDataBean.getLmpDate()));
                }

            }
            try {
                Where<MemberBean, Integer> totalLivingChildRenWhere = memberBeanDao.queryBuilder().where();
                if (memberDataBean.getMemberId() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.TOTAL_LIVING_CHILDREN,
                            String.valueOf(totalLivingChildRenWhere.and(
                                    totalLivingChildRenWhere.eq(FieldNameConstants.MOTHER_ID, memberDataBean.getMemberId()),
                                    totalLivingChildRenWhere.eq(FieldNameConstants.FAMILY_ID, memberDataBean.getFamilyId()),
                                    totalLivingChildRenWhere.ne(FieldNameConstants.ACTUAL_ID, memberDataBean.getMemberId()),
                                    totalLivingChildRenWhere.notIn(FieldNameConstants.STATE, invalidStates)).countOf())
                    );
                }

                if (memberDataBean.getMemberUuid() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.TOTAL_LIVING_CHILDREN,
                            String.valueOf(totalLivingChildRenWhere.and(
                                    totalLivingChildRenWhere.eq(FieldNameConstants.MOTHER_UUID, memberDataBean.getMemberUuid()),
                                    totalLivingChildRenWhere.eq(FieldNameConstants.FAMILY_ID, memberDataBean.getFamilyId()),
                                    totalLivingChildRenWhere.ne(FieldNameConstants.MEMBER_UUID, memberDataBean.getMemberUuid()),
                                    totalLivingChildRenWhere.notIn(FieldNameConstants.STATE, invalidStates)).countOf())
                    );
                }


                Where<MemberBean, Integer> totalMaleChildrenWhere = memberBeanDao.queryBuilder().where();
                if (memberDataBean.getMemberId() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.TOTAL_MALE_CHILDREN,
                            String.valueOf(totalMaleChildrenWhere.and(
                                    totalMaleChildrenWhere.eq(FieldNameConstants.MOTHER_ID, memberDataBean.getMemberId()),
                                    totalMaleChildrenWhere.eq(FieldNameConstants.FAMILY_ID, memberDataBean.getFamilyId()),
                                    totalMaleChildrenWhere.ne(FieldNameConstants.ACTUAL_ID, memberDataBean.getMemberId()),
                                    totalMaleChildrenWhere.notIn(FieldNameConstants.STATE, invalidStates)).countOf())
                    );
                }

                if (memberDataBean.getMemberUuid() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.TOTAL_MALE_CHILDREN,
                            String.valueOf(totalMaleChildrenWhere.and(
                                    totalMaleChildrenWhere.eq(FieldNameConstants.MOTHER_UUID, memberDataBean.getMemberUuid()),
                                    totalMaleChildrenWhere.eq(FieldNameConstants.FAMILY_ID, memberDataBean.getFamilyId()),
                                    totalMaleChildrenWhere.ne(FieldNameConstants.MEMBER_UUID, memberDataBean.getMemberUuid()),
                                    totalMaleChildrenWhere.notIn(FieldNameConstants.STATE, invalidStates)).countOf())
                    );
                }

                Where<MemberBean, Integer> totalFemaleChildrenWhere = memberBeanDao.queryBuilder().where();
                if (memberDataBean.getMemberId() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.TOTAL_FEMALE_CHILDREN,
                            String.valueOf(totalFemaleChildrenWhere.and(
                                    totalFemaleChildrenWhere.eq(FieldNameConstants.MOTHER_ID, memberDataBean.getMemberId()),
                                    totalFemaleChildrenWhere.eq(FieldNameConstants.FAMILY_ID, memberDataBean.getFamilyId()),
                                    totalFemaleChildrenWhere.ne(FieldNameConstants.ACTUAL_ID, memberDataBean.getMemberId()),
                                    totalFemaleChildrenWhere.notIn(FieldNameConstants.STATE, invalidStates)).countOf())
                    );
                }

                if (memberDataBean.getMemberUuid() != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.TOTAL_FEMALE_CHILDREN,
                            String.valueOf(totalFemaleChildrenWhere.and(
                                    totalFemaleChildrenWhere.eq(FieldNameConstants.MOTHER_UUID, memberDataBean.getMemberUuid()),
                                    totalFemaleChildrenWhere.eq(FieldNameConstants.FAMILY_ID, memberDataBean.getFamilyId()),
                                    totalFemaleChildrenWhere.ne(FieldNameConstants.MEMBER_UUID, memberDataBean.getMemberUuid()),
                                    totalFemaleChildrenWhere.notIn(FieldNameConstants.STATE, invalidStates)).countOf())
                    );
                }

                MemberBean latestChild = null;
                Where<MemberBean, Integer> latestChilWhere = memberBeanDao.queryBuilder().orderBy(FieldNameConstants.DOB, false).where();
                if (memberDataBean.getMemberId() != null) {
                    latestChild = latestChilWhere.and(
                            latestChilWhere.eq(FieldNameConstants.MOTHER_ID, memberDataBean.getMemberId()),
                            latestChilWhere.eq(FieldNameConstants.FAMILY_ID, memberDataBean.getFamilyId()),
                            latestChilWhere.ne(FieldNameConstants.ACTUAL_ID, memberDataBean.getMemberId()),
                            latestChilWhere.notIn(FieldNameConstants.STATE, invalidStates)).queryForFirst();
                }

                if (memberDataBean.getMemberUuid() != null) {
                    latestChild = latestChilWhere.and(
                            latestChilWhere.eq(FieldNameConstants.MOTHER_UUID, memberDataBean.getMemberUuid()),
                            latestChilWhere.eq(FieldNameConstants.FAMILY_ID, memberDataBean.getFamilyId()),
                            latestChilWhere.ne(FieldNameConstants.MEMBER_UUID, memberDataBean.getMemberUuid()),
                            latestChilWhere.notIn(FieldNameConstants.STATE, invalidStates)).queryForFirst();
                }

                if (latestChild != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LATEST_CHILD_NAME, latestChild.getFirstName() + " " + latestChild.getLastName());
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LATEST_CHILD_AGE, UtilBean.getAgeDisplayOnGivenDate(latestChild.getDob(), new Date()));
                    if (latestChild.getGender() != null && latestChild.getGender().equals(GlobalTypes.MALE)) {
                        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LATEST_CHILD_GENDER, LabelConstants.MALE);
                    } else if (latestChild.getGender() != null && latestChild.getGender().equals(GlobalTypes.FEMALE)) {
                        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LATEST_CHILD_GENDER, LabelConstants.FEMALE);
                    }
                }
            } catch (SQLException e) {
                Log.e(getClass().getSimpleName(), null, e);
            }

            if (memberDataBean.getEducationStatus() != null) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.EDUCATION_STATUS, memberDataBean.getEducationStatus());
            }

            if (memberDataBean.getNrcNumber() != null) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.NRC_NUMBER, memberDataBean.getNrcNumber());
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IDENTIFICATION_PROOF, "NRC");
            }
            if (memberDataBean.getBirthCertNumber() != null) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.BIRTH_CERTIFICATE_NUMBER, memberDataBean.getBirthCertNumber());
            }
            if (memberDataBean.getMobileNumber() != null && !memberDataBean.getMobileNumber().equals("T")) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.FAMILY_PHONE_NUMBER, memberDataBean.getMobileNumber());
            } else if (familyDataBean.getContactPersonId() != null) {
                try {
                    MemberBean contactPerson = memberBeanDao.queryBuilder().where()
                            .eq(FieldNameConstants.ACTUAL_ID, familyDataBean.getContactPersonId()).queryForFirst();
                    if (contactPerson != null) {
                        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.FAMILY_PHONE_NUMBER, contactPerson.getMobileNumber());
                    }
                } catch (SQLException e) {
                    Log.e(getClass().getSimpleName(), null, e);
                }
            }

            if (familyDataBean.getAreaId() != null) {
                try {
                    LocationMasterBean locationMasterBean = locationMasterBeanDao.queryBuilder().where().
                            eq(FieldNameConstants.ACTUAL_I_D, familyDataBean.getAreaId()).queryForFirst();
                    if (locationMasterBean != null) {
                        String fhwDetailString = locationMasterBean.getFhwDetailString();
                        if (fhwDetailString != null) {
                            Type type = new TypeToken<List<Map<String, String>>>() {
                            }.getType();
                            List<Map<String, String>> fhwDetailMapList = new Gson().fromJson(fhwDetailString, type);
                            Map<String, String> fhwDetailMap = fhwDetailMapList.get(0);
                            if (fhwDetailMap.get("mobileNumber") != null) {
                                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.ASHA_INFO, fhwDetailMap.get("name") + " (" + fhwDetailMap.get("mobileNumber") + ")");
                            } else {
                                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.ASHA_INFO, fhwDetailMap.get("name") + " / " + LabelConstants.NOT_AVAILABLE);
                            }
                        }
                    }
                } catch (SQLException e) {
                    android.util.Log.e(getClass().getSimpleName(), null, e);
                }
            }

            if (memberDataBean.getChronicDiseaseIds() != null && !memberDataBean.getChronicDiseaseIds().isEmpty()) {
                StringBuilder builder = new StringBuilder();
                if (memberDataBean.getChronicDiseaseIds().contains(",")) {
                    String[] split = memberDataBean.getChronicDiseaseIds().split(",");
                    for (int i = 0; i < split.length; i++) {
                        builder.append(UtilBean.getNotAvailableIfNull(fhsService.getValueOfListValuesById(split[i])));
                        if (i != split.length - 1) {
                            builder.append("\n");
                        }
                    }
                }
                if (memberDataBean.getOtherChronic() != null && !memberDataBean.getOtherChronic().isEmpty()) {
                    builder.append("\n");
                    builder.append(memberDataBean.getOtherChronic());
                }
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CHRONIC_DISEASES, UtilBean.getMyLabel(builder.toString()));
            } else {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CHRONIC_DISEASES, UtilBean.getMyLabel(LabelConstants.NONE));
            }

            if (memberDataBean.getDob() != null) {
                Calendar calendar = Calendar.getInstance();
                calendar.add(Calendar.YEAR, 1);
                if (new Date(memberDataBean.getDob()).before(calendar.getTime())) {
                    calendar.add(Calendar.YEAR, 1);
                    if (new Date(memberDataBean.getDob()).before(calendar.getTime())) {
                        if (GlobalTypes.FLAVOUR_CHIP.equalsIgnoreCase(BuildConfig.FLAVOR)) {
                            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IMMUNISED_IN_TWO_YEAR, isChildImmunisedInTwoYearZambia(new MemberBean(memberDataBean)));
                            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.FULLY_IMMUNIZED_OR_NOT, isChildImmunisedInTwoYearZambia(new MemberBean(memberDataBean)));
                        } else {
                            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IMMUNISED_IN_TWO_YEAR, isChildImmunisedInTwoYear(new MemberBean(memberDataBean)));
                        }
                    }
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IMMUNISED_IN_ONE_YEAR, isChildImmunisedInOneYear(new MemberBean(memberDataBean)));
                }
            }

            if (memberDataBean.getBirthWeight() != null) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.BIRTH_WEIGHT, memberDataBean.getBirthWeight().toString());
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.BIRTH_WEIGHT_DISPLAY, memberDataBean.getBirthWeight().toString() + " " + UtilBean.getMyLabel("Kgs"));
            }
            if (memberDataBean.getWeight() != null) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LAST_WEIGHT,
                        memberDataBean.getWeight().toString() + UtilBean.getMyLabel(" Kgs"));
            }

            if (memberDataBean.getPassportNumber() != null) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.PASSPORT_NUMBER, memberDataBean.getPassportNumber());
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IDENTIFICATION_PROOF, "PASSPORT");
            }

            if (memberDataBean.getMemberReligion() != null) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.DEFAULT_RELIGION, memberDataBean.getMemberReligion());
            }

            if (memberDataBean.getIsChildGoingSchool() != null && memberDataBean.getIsChildGoingSchool()) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IS_CHILD_GOING_SCHOOL, "1");
            } else {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IS_CHILD_GOING_SCHOOL, "2");
            }

            if (memberDataBean.getEducationStatus() != null) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.STANDARD, memberDataBean.getEducationStatus());
            }

            if (memberDataBean.getUnderTreatmentChronic() != null && memberDataBean.getUnderTreatmentChronic()) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.ON_TREATMENT, "1");
            } else {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.ON_TREATMENT, "2");
            }

            if (memberDataBean.getChronicDiseaseIdsForTreatment() != null) {
                String chronicDiseaseIdsForTreatment = memberDataBean.getChronicDiseaseIdsForTreatment();
                if (memberDataBean.getOtherChronicDiseaseTreatment() != null && !memberDataBean.getOtherChronicDiseaseTreatment().isEmpty()) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.OTHER_CHRONIC_DISEASE_TREATMENT, memberDataBean.getOtherChronicDiseaseTreatment());
                    chronicDiseaseIdsForTreatment = UtilBean.addCommaSeparatedStringIfNotExists(memberDataBean.getChronicDiseaseIdsForTreatment(), "OTHER");
                }
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CHRONIC_DISEASE_TREATMENT, chronicDiseaseIdsForTreatment);
            }
            if (memberDataBean.getDob() != null) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.DOB, memberDataBean.getDob().toString());
                int[] yearMonthDayAge = UtilBean.calculateAgeYearMonthDay(memberDataBean.getDob());
                String tmpDataObj = UtilBean.getAgeDisplay(yearMonthDayAge[0], yearMonthDayAge[1], yearMonthDayAge[2]);
                if (tmpDataObj != null) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.AGE_DISPLAY, tmpDataObj);
                }
            }
            if (memberDataBean.getLastMethodOfContraception() != null) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.LAST_METHOD_OF_CONTRACEPTION, FullFormConstants.convertToCamelCase(memberDataBean.getLastMethodOfContraception()));

            }

            if (GlobalTypes.FLAVOUR_CHIP.equalsIgnoreCase(BuildConfig.FLAVOR)) {
                if (memberDataBean.getMemberReligion() != null) {
                    String religion = fhsService.getValueOfListValuesById(memberDataBean.getMemberReligion());
                    if (religion != null) {
                        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.RELIGION, religion);
                    }
                }
            } else {
                if (familyDataBean.getReligion() != null) {
                    String religion = fhsService.getValueOfListValuesById(familyDataBean.getReligion());
                    if (religion != null) {
                        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.RELIGION, religion);
                    }
                }
            }

            int[] ageYearMonthDayArray = UtilBean.calculateAgeYearMonthDayOnGivenDate(memberDataBean.getDob(), new Date().getTime());
            String ageDisplay = UtilBean.getAgeDisplay(ageYearMonthDayArray[0], ageYearMonthDayArray[1], ageYearMonthDayArray[2]);
            if (ageDisplay != null) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.AGE_AS_PER_DATE, ageDisplay);
            }

            if (memberDataBean.getCongenitalAnomalyIds() != null && !memberDataBean.getCongenitalAnomalyIds().isEmpty()) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CONGENITAL_STATUS, "1");
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CONGENITAL_ANOMALY_IDS, memberDataBean.getCongenitalAnomalyIds());
            } else {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CONGENITAL_STATUS, "2");
            }

            if (memberDataBean.getChronicDiseaseIds() != null && !memberDataBean.getChronicDiseaseIds().isEmpty()) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CHRONIC_DISEASE_STATUS, "1");
                String chronicDiseaseIds = memberDataBean.getChronicDiseaseIds();
                if (memberDataBean.getOtherChronic() != null && !memberDataBean.getOtherChronic().isEmpty()) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.OTHER_CHRONIC_DISEASE, memberDataBean.getOtherChronic());
                    chronicDiseaseIds = UtilBean.addCommaSeparatedStringIfNotExists(memberDataBean.getChronicDiseaseIds(), "OTHER");
                }
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CHRONIC_DISEASE_IDS, chronicDiseaseIds);
            } else {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CHRONIC_DISEASE_STATUS, "2");
            }

            if (memberDataBean.getCurrentDiseaseIds() != null && !memberDataBean.getCurrentDiseaseIds().isEmpty()) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CURRENT_DISEASE_STATUS, "1");
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CURRENT_DISEASE_IDS, memberDataBean.getCurrentDiseaseIds());
            } else {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.CURRENT_DISEASE_STATUS, "2");
            }

            if (memberDataBean.getEyeIssueIds() != null && !memberDataBean.getEyeIssueIds().isEmpty()) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.EYE_ISSUE_STATUS, "1");
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.EYE_ISSUE_IDS, memberDataBean.getEyeIssueIds());
            } else {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.EYE_ISSUE_STATUS, "2");
            }

            if (memberDataBean.getMotherId() != null) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MOTHER_ID, String.valueOf(memberDataBean.getMotherId()));
            }

            if (memberDataBean.getGender() != null && memberDataBean.getGender().equals("F")
                    && memberDataBean.getMaritalStatus() != null && memberDataBean.getMaritalStatus().equals("629")) {
                SharedStructureData.membersUnderTwenty = getMembersLessThan20(memberDataBean.getFamilyId(), memberDataBean);
                if (!SharedStructureData.membersUnderTwenty.isEmpty()) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MEMBERS_UNDER_20_AVAILABLE, "T");
                } else {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MEMBERS_UNDER_20_AVAILABLE, "F");
                }
            }

            if (memberDataBean.getAdditionalInfo() != null) {
                MemberAdditionalInfoDataBean memberAdditionalInfo = new Gson().fromJson(memberDataBean.getAdditionalInfo(), MemberAdditionalInfoDataBean.class);
                if (memberAdditionalInfo.getPersonallyUsingFp() != null && memberAdditionalInfo.getPersonallyUsingFp()) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.PERSONALLY_USING_FP, "1");
                } else {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.PERSONALLY_USING_FP, "2");
                }
                if ((memberAdditionalInfo.getHivTest() != null && !memberAdditionalInfo.getHivTest().equals(RchConstants.NOT_DONE)) || (memberDataBean.getIsHivPositive() != null && !memberDataBean.getIsHivPositive().equals(RchConstants.NOT_DONE))) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.HIV_TEST, memberAdditionalInfo.getHivTest());
                }
                if (memberAdditionalInfo.getDevelopmentDelays() != null && memberAdditionalInfo.getDevelopmentDelays()) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.DEVELOPMENTAL_DELAYS, "Yes");
                } else {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.DEVELOPMENTAL_DELAYS, "No");
                }
            }
            if (Boolean.TRUE.equals(memberDataBean.getHaveNssf())) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.HAVE_NSSF, "1");
            } else {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.HAVE_NSSF, "2");
            }

            if (memberDataBean.getNssfCardNumber() != null) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.NSSF_CARD_NUMBER, memberDataBean.getNssfCardNumber());
            }
        }
        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IS_QR_ENABLED, "1");
        editor.apply();
    }
}
