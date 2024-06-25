package com.argusoft.sewa.android.app.core.impl;

import com.argusoft.sewa.android.app.BuildConfig;
import com.argusoft.sewa.android.app.constants.FieldNameConstants;
import com.argusoft.sewa.android.app.constants.LabelConstants;
import com.argusoft.sewa.android.app.constants.RchConstants;
import com.argusoft.sewa.android.app.constants.RelatedPropertyNameConstants;
import com.argusoft.sewa.android.app.core.RchHighRiskService;
import com.argusoft.sewa.android.app.databean.OptionDataBean;
import com.argusoft.sewa.android.app.datastructure.SharedStructureData;
import com.argusoft.sewa.android.app.db.DBConnection;
import com.argusoft.sewa.android.app.model.ListValueBean;
import com.argusoft.sewa.android.app.util.GlobalTypes;
import com.argusoft.sewa.android.app.util.Log;
import com.argusoft.sewa.android.app.util.UtilBean;
import com.j256.ormlite.dao.Dao;

import org.androidannotations.annotations.EBean;
import org.androidannotations.ormlite.annotations.OrmLiteDao;

import java.sql.SQLException;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@EBean(scope = EBean.Scope.Singleton)
public class RchHighRiskServiceImpl implements RchHighRiskService {

    @OrmLiteDao(helper = DBConnection.class)
    public Dao<ListValueBean, Integer> listValueBeanDao;


    @Override
    public void identifyHighRisk(String type, Object answer, List<OptionDataBean> allOptions, String property) {
        if (type == null) {
            return;
        }
        switch (type) {
            case RchConstants.WEIGHT_PW:
                if (answer != null && answer.toString().length() > 0 && Float.parseFloat(answer.toString()) < 45f) {
                    SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.HIGH_RISK_VERY_LOW_WEIGHT));
                } else {
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.HIGH_RISK_VERY_LOW_WEIGHT));
                }
                break;
            case RchConstants.WEIGHT_C:
                boolean lowWeight = answer != null &&
                        ((Float.parseFloat(answer.toString()) < 5.0 && Float.parseFloat(answer.toString()) < 2.5f && Float.parseFloat(answer.toString()) > 0)
                                || ((Float.parseFloat(answer.toString()) >= 500 && Float.parseFloat(answer.toString()) <= 5000) && (Float.parseFloat(answer.toString()) / 1000) < 2.5f && (Float.parseFloat(answer.toString()) / 1000) > 0));
                if (lowWeight) {
                    SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.HIGH_RISK_VERY_LOW_WEIGHT));
                } else {
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.HIGH_RISK_VERY_LOW_WEIGHT));
                }
                break;
            case RchConstants.HEIGHT_PW:
                if (answer != null && answer.toString().length() > 0 && Integer.parseInt(answer.toString()) < 145) {
                    SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.HIGH_RISK_LOW_HEIGHT));
                } else {
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.HIGH_RISK_LOW_HEIGHT));
                }
                break;
            case RchConstants.DISEASE_LIST_VALUES:
            case RchConstants.DISABILITY_LV:
                if (allOptions != null && !allOptions.isEmpty()) {
                    for (OptionDataBean option : allOptions) {
                        if (option.getKey().contains(RchConstants.OTHER)
                                || option.getKey().contains(RchConstants.NONE)
                                || option.getKey().contains(RchConstants.NOT_KNOWN)) {
                            continue;
                        }
                        try {
                            SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(
                                    listValueBeanDao.queryBuilder().where().eq(FieldNameConstants.ID_OF_VALUE, option.getKey()).queryForFirst().getValue()));
                        } catch (Exception e) {
                            Log.e(getClass().getSimpleName(), e.getMessage(), e);
                        }
                    }
                }
                if (answer != null) {
                    for (String risk : answer.toString().split(",")) {
                        try {
                            if (risk.contains(RchConstants.OTHER) || risk.contains(RchConstants.NONE) || risk.contains(RchConstants.NOT_KNOWN)) {
                                continue;
                            } else {
                                SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(
                                        listValueBeanDao.queryBuilder().where().eq(FieldNameConstants.ID_OF_VALUE, risk).queryForFirst().getValue()));
                            }
                        } catch (Exception e) {
                            Log.e(getClass().getSimpleName(), null, e);
                        }
                    }
                }
                break;
            case RchConstants.DISEASE_CONSTANT:
                if (allOptions != null && !allOptions.isEmpty()) {
                    for (OptionDataBean option : allOptions) {
                        if (option.getKey().contains(RchConstants.OTHER) || option.getKey().contains(RchConstants.NONE) || option.getKey().contains(RchConstants.NOT_KNOWN)) {
                            continue;
                        }
                        SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.getHighRiskDiseaseFromConstant(option.getKey())));
                    }
                }
                if (answer != null) {
                    for (String risk : answer.toString().split(",")) {
                        if (risk.contains(RchConstants.OTHER) || risk.contains(RchConstants.NONE) || risk.contains(RchConstants.NOT_KNOWN)) {
                            continue;
                        }
                        SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.getHighRiskDiseaseFromConstant(risk)));
                    }
                }
                break;
            case RchConstants.OTHER_DISEASE:
                if (answer != null && !answer.toString().trim().isEmpty()) {
                    SharedStructureData.highRiskConditions.add(answer.toString());
                }
                break;
            case RchConstants.BLOOD_PRESSURE:
                if (answer != null && answer.toString().contains("F")) {
                    String[] bpAnswerArray = answer.toString().split("-");
                    if (bpAnswerArray.length == 3) {
                        int systolic = Integer.parseInt(bpAnswerArray[1]);
                        int diastolic = Integer.parseInt(bpAnswerArray[2]);
                        if (!BuildConfig.FLAVOR.equals(GlobalTypes.FLAVOUR_DNHDD)) {
                            if (systolic > 139 || diastolic > 89) {
                                SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.HIGH_RISK_HIGH_BLOOD_PRESSURE));
                            }
                        } else {
                            if (systolic > 129 || diastolic > 89) {
                                SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.SUSPECTED_HYPERTENSION));
                            }
                        }

                    }
                }
                break;
            case RchConstants.HAEMOGLOBIN:
                if (answer != null && answer.toString().length() > 0 && Float.parseFloat(answer.toString()) < 7) {
                    SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.HIGH_RISK_LOW_HAEMOGLOBIN));
                } else {
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.HIGH_RISK_LOW_HAEMOGLOBIN));
                }
                break;
            case RchConstants.HAEMOGLOBIN_DNHDD:
                if (answer != null && answer.toString().length() > 0 && Float.parseFloat(answer.toString()) < 7) {
                    SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.HIGH_RISK_SEVERE_ANEMIA));
                } else if (answer != null && answer.toString().length() > 0 &&
                        Float.parseFloat(answer.toString()) >= 7 && Float.parseFloat(answer.toString()) < 9) {
                    SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.HIGH_RISK_MODERATE_HAEMOGLOBIN));
                } else {
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.HIGH_RISK_SEVERE_ANEMIA));
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.HIGH_RISK_MODERATE_HAEMOGLOBIN));
                }
                break;
            case RchConstants.TUBERCULOSIS:
                if (answer != null && answer.toString().equals("1")) {
                    SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.HIGH_RISK_TUBERCULOSIS));
                } else {
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.HIGH_RISK_TUBERCULOSIS));
                }
                break;
            case RchConstants.MALARIA:
                if (answer != null && answer.toString().equals("1")) {
                    SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.HIGH_RISK_MALARIA));
                } else {
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.HIGH_RISK_MALARIA));
                }
                break;
            case RchConstants.FETAL_HEART_RATE:
                if (answer != null && answer.toString().contains("F")) {
                    String[] fetalHeartRateAnswerArray = answer.toString().split("/");
                    if (fetalHeartRateAnswerArray.length == 2) {
                        int fetalHeartRate = Integer.parseInt(fetalHeartRateAnswerArray[1]);
                        if (fetalHeartRate > 160) {
                            SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.HIGH_RISK_HIGH_FETAL_HEART_RATE));
                        } else if (fetalHeartRate < 110) {
                            SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.HIGH_RISK_LOW_FETAL_HEART_RATE));
                        } else {
                            SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.HIGH_RISK_HIGH_FETAL_HEART_RATE));
                            SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.HIGH_RISK_LOW_FETAL_HEART_RATE));
                        }
                    } else {
                        SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.HIGH_RISK_HIGH_FETAL_HEART_RATE));
                        SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.HIGH_RISK_LOW_FETAL_HEART_RATE));
                    }
                } else {
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.HIGH_RISK_HIGH_FETAL_HEART_RATE));
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.HIGH_RISK_LOW_FETAL_HEART_RATE));
                }
                break;
            case RchConstants.HBSAG_TEST:
                if (answer != null && answer.toString().equalsIgnoreCase(RchConstants.HBSAG_REACTIVE)) {
                    SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.HIGH_RISK_REACTIVE_HBSAG_TEST));
                } else {
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.HIGH_RISK_REACTIVE_HBSAG_TEST));
                }
                break;
            case RchConstants.BLOOD_SUGAR_TEST:
                if (answer != null && answer.toString().equalsIgnoreCase(RchConstants.NOT_DONE)) {
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.HIGH_RISK_HIGH_BLOOD_SUGAR));
                }
                break;
            case RchConstants.DNHDD_BLOOD_SUGAR_TEST:
                if (answer != null && answer.toString().equalsIgnoreCase(RchConstants.NOT_DONE)) {
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.SUSPECTED_DIABETES));
                }
                break;
            case RchConstants.BLOOD_SUGAR_VALUE:
                try {
                    if (answer != null && Integer.parseInt(answer.toString()) > 125) {
                        SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.HIGH_RISK_HIGH_BLOOD_SUGAR));
                    } else {
                        SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.HIGH_RISK_HIGH_BLOOD_SUGAR));
                    }
                } catch (NumberFormatException e) {

                }
                break;
            case RchConstants.DNHDD_BLOOD_SUGAR_VALUE:
                try {
                    if (answer != null && property != null) {
                        switch (property) {
                            case "RBS":
                                if (Integer.parseInt(answer.toString()) > 109) {
                                    SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.SUSPECTED_DIABETES));
                                } else {
                                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.SUSPECTED_DIABETES));
                                }
                                break;
                            case "FBS":
                                if (Integer.parseInt(answer.toString()) > 99) {
                                    SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.SUSPECTED_DIABETES));
                                } else {
                                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.SUSPECTED_DIABETES));
                                }
                                break;
                            case "PPBS":
                                if (Integer.parseInt(answer.toString()) > 139) {
                                    SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.SUSPECTED_DIABETES));
                                } else {
                                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.SUSPECTED_DIABETES));
                                }
                                break;
                            default:
                        }
                    } else {
                        SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.SUSPECTED_DIABETES));
                    }
                } catch (NumberFormatException e) {

                }
                break;
            case RchConstants.HIV_TEST:
                if (answer != null && answer.toString().equalsIgnoreCase(RchConstants.TEST_POSITIVE)) {
                    SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.HIGH_RISK_HIV));
                } else {
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.HIGH_RISK_HIV));
                }
                break;
            case RchConstants.VDRL_TEST:
                if (answer != null && answer.toString().equalsIgnoreCase(RchConstants.TEST_POSITIVE)) {
                    SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.HIGH_RISK_VDRL));
                } else {
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.HIGH_RISK_VDRL));
                }
                break;
            case RchConstants.SYPHILIS_TEST:
                if (answer != null && answer.toString().equalsIgnoreCase(RchConstants.TEST_POSITIVE)) {
                    SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.HIGH_RISK_SYPHILIS));
                } else {
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.HIGH_RISK_SYPHILIS));
                }
                break;
            case RchConstants.RPR_FOR_SYPHILIS_TEST:
                if (answer != null && answer.toString().equalsIgnoreCase(RchConstants.TEST_POSITIVE)) {
                    SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.HIGH_RISK_RPR_SYPHILIS));
                } else {
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.HIGH_RISK_RPR_SYPHILIS));
                }
                break;
            case RchConstants.SICKLE_CELL_TEST:
                if (answer != null && answer.toString().equalsIgnoreCase(RchConstants.SICKLE_CELL)) {
                    SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.HIGH_RISK_SICKLE_CELL));
                } else {
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.HIGH_RISK_SICKLE_CELL));
                }
                break;
            case RchConstants.SICKLE_CELL_TEST_DNHDD:
                if (answer != null && (answer.toString().equalsIgnoreCase(FieldNameConstants.SICKLE_CELL_DISEASE)
                        || answer.toString().equalsIgnoreCase(RchConstants.SICKLE_CELL_TRAIT))) {
                    SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.HIGH_RISK_SICKLE_CELL));
                } else {
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.HIGH_RISK_SICKLE_CELL));
                }
                break;
            case RchConstants.ORAL_GTT:
                if (answer != null && answer.toString().equalsIgnoreCase(RchConstants.REACTIVE)) {
                    SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.HIGH_RISK_ORAL_GTT));
                } else {
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.HIGH_RISK_ORAL_GTT));
                }
                break;
            case RchConstants.PREVIOUS_PREG_OUTCOME:
                if (answer != null && answer.toString().equalsIgnoreCase("SBIRTH")) {
                    SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.HIGH_RISK_PREVIOUS_PREG_OUTCOME_STILL_BIRTH));
                } else {
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.HIGH_RISK_PREVIOUS_PREG_OUTCOME_STILL_BIRTH));
                }
                break;
            case RchConstants.URINE_TEST:
                if (answer != null && !answer.toString().equals("2")) {
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.HIGH_RISK_URINE_ALBUMIN));
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.HIGH_RISK_URINE_SUGAR));
                }
                break;
            case RchConstants.URINE_ALBUMIN:
                if (answer != null && !answer.toString().equals("0")) {
                    SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.HIGH_RISK_URINE_ALBUMIN));
                } else {
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.HIGH_RISK_URINE_ALBUMIN));
                }
                break;
            case RchConstants.URINE_SUGAR:
                if (answer != null && !answer.toString().equals("0")) {
                    SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.HIGH_RISK_URINE_SUGAR));
                } else {
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.HIGH_RISK_URINE_SUGAR));
                }
                break;
            case RchConstants.ULTRASOUND_TEST:
                if (answer != null && !answer.toString().equals("1")) {
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.HIGH_RISK_ABNORMALITY_IN_ULTRASOUND));
                }
                break;
            case RchConstants.ULTRASOUND_ABNORMALITY:
                if (answer != null && answer.toString().equals("1")) {
                    SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.HIGH_RISK_ABNORMALITY_IN_ULTRASOUND));
                } else {
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.HIGH_RISK_ABNORMALITY_IN_ULTRASOUND));
                }
                break;
            case RchConstants.HEPATITIS_C:
                if (answer != null && answer.toString().equals("POSITIVE")) {
                    SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.HEPATITIS_C_POSITIVE));
                } else {
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.HEPATITIS_C_POSITIVE));
                }
                break;
            case "AGE":
                String dob = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.DOB);
                if (dob != null && !dob.isEmpty()) {
                    Date dobDate = new Date(Long.parseLong(dob));

                    Calendar instance = Calendar.getInstance();
                    UtilBean.clearTimeFromDate(instance.getTime());
                    instance.add(Calendar.YEAR, -19);
                    Date nineteenYearBefore = instance.getTime();
                    instance.add(Calendar.YEAR, -16);
                    Date thirtyFiveYearBefore = instance.getTime();

                    if (dobDate.after(nineteenYearBefore)) {
                        SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.TEEN_AGE_PREGNANCY));
                    } else if (dobDate.before(thirtyFiveYearBefore)) {
                        SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.ELDER_AGE_PREGNANCY));
                    } else {
                        SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.TEEN_AGE_PREGNANCY));
                        SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.ELDER_AGE_PREGNANCY));
                    }
                }
                break;
            case "ABORTUS":
                String abortionCount = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.ABORTION_COUNT);
                if (abortionCount != null && !abortionCount.isEmpty()) {
                    int count = Integer.parseInt(abortionCount);
                    if (count > 3) {
                        SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.ABORTION_HISTORY));
                    } else {
                        SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.ABORTION_HISTORY));
                    }
                }
                break;
            case "TSH":
                String lmpDateString = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.LMP_DATE);
                if (lmpDateString != null && lmpDateString.equals("null")) {
                    if (UtilBean.checkIfSecondTrimester(Long.parseLong(lmpDateString))) {
                        if (answer != null && Float.parseFloat(answer.toString()) > 3f) {
                            SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.THYROID_RISK));
                        } else {
                            SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.THYROID_RISK));
                        }
                    } else {
                        if (answer != null && Float.parseFloat(answer.toString()) > 2.5f) {
                            SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.THYROID_RISK));
                        } else {
                            SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.THYROID_RISK));
                        }
                    }
                }
            case "BLOOD_GROUP":
                if (answer != null && answer.toString().split("-").length > 0) {
                    SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.NEGATIVE_BLOOD_GROUP));
                } else {
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.NEGATIVE_BLOOD_GROUP));
                }
            case "CERVIX":
                try {
                    String lmp = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.LMP_DATE);
                    String serviceDate = SharedStructureData.relatedPropertyHashTable.get("serviceDate");
                    if (answer != null && lmp != null && serviceDate != null) {
                        int days = UtilBean.getNumberOfDays(new Date(Long.parseLong(lmp)), new Date(Long.parseLong(serviceDate)));
                        if (Integer.parseInt(answer.toString()) < 2) {
                            SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.CERVIX_LENGTH));
                        } else if (Integer.parseInt(answer.toString()) < 3 && days > 190) {
                            SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.CERVIX_LENGTH));
                        } else {
                            SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.CERVIX_LENGTH));
                        }
                    } else {
                        SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.CERVIX_LENGTH));
                    }

                } catch (NumberFormatException e) {

                }
                break;
            case "NECK_CORD":
                if (answer != null && answer.toString().equals("1")) {
                    String neckCord = UtilBean.getMyLabel(RchConstants.NECK_CORD);
                    if (!SharedStructureData.highRiskConditions.contains(neckCord)) {
                        SharedStructureData.highRiskConditions.add(neckCord);
                    }
                } else {
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.NECK_CORD));
                }
                break;
            case "GESTATION":
                if (answer != null && !answer.toString().equals("SINGLE")) {
                    String gestation = UtilBean.getMyLabel(RchConstants.MULTIPLE_GESTATION);
                    if (!SharedStructureData.highRiskConditions.contains(gestation)) {
                        SharedStructureData.highRiskConditions.add(gestation);
                    }
                } else {
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.MULTIPLE_GESTATION));
                }
                break;
            case "OTHER_ANOMALY":
                if (answer != null && answer.toString().equals("OVARIAN")) {
                    SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.OVARIAN_ANOMALY));
                } else if (answer != null && answer.toString().equals("UTERUS")) {
                    SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.UTERUS_ANOMALY));
                } else if (answer != null && answer.toString().equals("FETAL")) {
                    SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.FETAL_ANOMALY));
                } else {
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.OVARIAN_ANOMALY));
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.UTERUS_ANOMALY));
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.FETAL_ANOMALY));
                }
                break;
            case "AMNIOTIC_FLUID":
                if (answer != null && (Integer.parseInt(answer.toString()) < 8)) {
                    SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.AMNIOTIC_FLUID_LOW));
                } else if (answer != null && (Integer.parseInt(answer.toString()) > 20)) {
                    SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.AMNIOTIC_FLUID_HIGH));
                } else {
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.AMNIOTIC_FLUID_LOW));
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.AMNIOTIC_FLUID_HIGH));
                }
                break;
            case "FOETAL_POSITION_DNHDD":
                if (answer != null && !answer.toString().equals("CEPHALIC")) {
                    String foetalPosition = UtilBean.getMyLabel(RchConstants.FOETAL_POSITION);
                    if (!SharedStructureData.highRiskConditions.contains(foetalPosition)) {
                        SharedStructureData.highRiskConditions.add(foetalPosition);
                    }
                } else {
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.FOETAL_POSITION));
                }
                break;
            case "FOETAL_WEIGHT":
                if (answer != null && !answer.toString().isEmpty()
                        && !SharedStructureData.highRiskConditions.contains(UtilBean.getMyLabel(RchConstants.IUGR))) {
                    Float ageAnswer = Float.parseFloat(answer.toString());
                    String gestationalAgeGap = SharedStructureData.relatedPropertyHashTable.get("gestationalAgeFromLmp");
                    String ageInWeek = gestationalAgeGap != null ? gestationalAgeGap.split("W")[0] : null;
                    if (ageInWeek != null) {
                        Float highRiskWeight = foetalWeightAsPerAgeMap().get(Integer.parseInt(ageInWeek) - 2);
                        if (highRiskWeight != null && ageAnswer < highRiskWeight) {
                            SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.IUGR));
                        } else {
                            SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.IUGR));
                        }
                    } else {
                        SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.IUGR));
                    }
                }
                break;
            case "IUGR":
                if (answer != null) {
                    String lmpDate = SharedStructureData.relatedPropertyHashTable.get("lmpDate");
                    Long lmpLongVal = null;
                    Integer daysAsPerLmp = null;
                    Long gesAgeAsPerUsg = Long.parseLong(String.valueOf(answer));
                    Integer daysAsPerUsg = UtilBean.getNumberOfDays(new Date(gesAgeAsPerUsg), new Date());

                    if (lmpDate != null) {
                        lmpLongVal = Long.parseLong(lmpDate);
                    }
                    if (lmpLongVal != null) {
                        daysAsPerLmp = UtilBean.getNumberOfDays(new Date(lmpLongVal), new Date());
                    }

                    if (daysAsPerLmp != null && daysAsPerUsg != null) {
                        int daysDiff = daysAsPerLmp - daysAsPerUsg;
                        if (daysDiff >= 21) {
                            String iugr = UtilBean.getMyLabel(RchConstants.IUGR);
                            if (!SharedStructureData.highRiskConditions.contains(iugr)) {
                                SharedStructureData.highRiskConditions.add(UtilBean.getMyLabel(RchConstants.IUGR));
                            }
                        } else {
                            SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.IUGR));
                        }
                    }

                }
                break;
            case "PLACENTA_POSITION":
                if (answer != null && answer.toString().equals("PLACENTA_PREVIA")) {
                    String placentaPosition = UtilBean.getMyLabel(RchConstants.PLACENTA_POSITION);
                    if (!SharedStructureData.highRiskConditions.contains(placentaPosition)) {
                        SharedStructureData.highRiskConditions.add(placentaPosition);
                    }
                } else {
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.PLACENTA_POSITION));
                }
                break;
            case "FHS":
                if (answer != null && answer.toString().equals("2")) {
                    String fhs = UtilBean.getMyLabel(RchConstants.FOETAL_HEART_SOUND);
                    if (!SharedStructureData.highRiskConditions.contains(fhs)) {
                        SharedStructureData.highRiskConditions.add(fhs);
                    }
                } else {
                    SharedStructureData.highRiskConditions.remove(UtilBean.getMyLabel(RchConstants.FOETAL_HEART_SOUND));
                }
                break;
            default:
        }
    }

    private static Map<Integer, Float> foetalWeightAsPerAgeMap() {
        Map<Integer, Float> ageWeightMap = new HashMap<>();
        ageWeightMap.put(20, 0.3f);
        ageWeightMap.put(21, .36f);
        ageWeightMap.put(22, .43f);
        ageWeightMap.put(23, .501f);
        ageWeightMap.put(24, .6f);
        ageWeightMap.put(25, .66f);
        ageWeightMap.put(26, .76f);
        ageWeightMap.put(27, .875f);
        ageWeightMap.put(28, 1f);
        ageWeightMap.put(29, 1.2f);
        ageWeightMap.put(30, 1.3f);
        ageWeightMap.put(31, 1.5f);
        ageWeightMap.put(32, 1.7f);
        ageWeightMap.put(33, 1.9f);
        ageWeightMap.put(34, 2.1f);
        ageWeightMap.put(35, 2.4f);
        ageWeightMap.put(36, 2.6f);
        ageWeightMap.put(37, 2.9f);
        ageWeightMap.put(38, 3.1f);
        ageWeightMap.put(39, 3.3f);
        ageWeightMap.put(40, 3.5f);

        return ageWeightMap;
    }

    @Override
    public String identifyHighRiskForRchAnc(Map<String, Object> mapOfAnswers) {
        Object bpAnswer = mapOfAnswers.get("bpAnswer");
        Object weightAnswer = mapOfAnswers.get("weightAnswer");
        Object haemoglobinAnswer = mapOfAnswers.get("haemoglobinAnswer");
        Object dangerousSignAnswer = mapOfAnswers.get("dangerousSignAnswer");
        Object otherDangerousSignAnswer = mapOfAnswers.get("otherDangerousSignAnswer");
        Object urineAlbuminAnswer = mapOfAnswers.get("urineAlbuminAnswer");
        Object urineSugarAnswer = mapOfAnswers.get("urineSugarAnswer");
        Object sickleCellTestAnswer = mapOfAnswers.get("sickleCellTestAnswer");
        Object previousComplicationsAnswer = mapOfAnswers.get("previousComplicationsAnswer");
        Object otherPreviousComplicationsAnswer = mapOfAnswers.get("otherPreviousComplicationsAnswer");

        StringBuilder highRiskFound = new StringBuilder();

        if (bpAnswer != null && bpAnswer.toString().contains("F")) {
            String[] bpAnswerArray = bpAnswer.toString().split("-");
            if (bpAnswerArray.length == 3) {
                int systolic = Integer.parseInt(bpAnswerArray[1]);
                int diastolic = Integer.parseInt(bpAnswerArray[2]);
                if (systolic > 139 || diastolic > 89) {
                    highRiskFound.append(UtilBean.getMyLabel(RchConstants.HIGH_RISK_HIGH_BLOOD_PRESSURE));
                    highRiskFound.append("\n");
                }
            }
        }

        if (haemoglobinAnswer != null && haemoglobinAnswer.toString().length() > 0 && Float.parseFloat(haemoglobinAnswer.toString()) < 7) {
            highRiskFound.append(UtilBean.getMyLabel(RchConstants.HIGH_RISK_LOW_HAEMOGLOBIN));
            highRiskFound.append("\n");
        }

        if (weightAnswer != null && weightAnswer.toString().length() > 0 && Float.parseFloat(weightAnswer.toString()) < 45f) {
            highRiskFound.append(UtilBean.getMyLabel(RchConstants.HIGH_RISK_VERY_LOW_WEIGHT));
            highRiskFound.append("\n");
        }

        if (urineAlbuminAnswer != null && !urineAlbuminAnswer.toString().equals("0")) {
            highRiskFound.append(UtilBean.getMyLabel(RchConstants.HIGH_RISK_URINE_ALBUMIN));
            highRiskFound.append("\n");
        }

        if (urineSugarAnswer != null && !urineSugarAnswer.toString().equals("0")) {
            highRiskFound.append(UtilBean.getMyLabel(RchConstants.HIGH_RISK_URINE_SUGAR));
            highRiskFound.append("\n");
        }

        if (dangerousSignAnswer != null) {
            for (String risk : dangerousSignAnswer.toString().split(",")) {
                if (!risk.contains(RchConstants.OTHER) && !risk.contains(RchConstants.NONE)) {
                    try {
                        highRiskFound.append(UtilBean.getMyLabel(
                                listValueBeanDao.queryBuilder().where().eq(FieldNameConstants.ID_OF_VALUE, risk).queryForFirst().getValue()));
                        highRiskFound.append("\n");
                    } catch (SQLException e) {
                        Log.e(getClass().getSimpleName(), null, e);
                    }
                } else if (risk.contains(RchConstants.OTHER) && otherDangerousSignAnswer != null) {
                    highRiskFound.append(otherDangerousSignAnswer);
                    highRiskFound.append("\n");
                }
            }
        }

        if (sickleCellTestAnswer != null && sickleCellTestAnswer.toString().equals("SICKLE_CELL")) {
            highRiskFound.append(UtilBean.getMyLabel(RchConstants.HIGH_RISK_SICKLE_CELL));
            highRiskFound.append("\n");
        }

        if (previousComplicationsAnswer != null) {
            for (String risk : previousComplicationsAnswer.toString().split(",")) {
                if (!risk.contains(RchConstants.OTHER) && !risk.contains(RchConstants.NONE) && !risk.contains(RchConstants.NOT_KNOWN)) {
                    //to display values instead of keys
                    switch (risk) {
                        case "PLPRE":
                            highRiskFound.append("Placenta previa");
                            break;
                        case "PRETRM":
                            highRiskFound.append("Pre term");
                            break;
                        case "CONVLS":
                            highRiskFound.append("Convulsion");
                            break;
                        case "MLPRST":
                            highRiskFound.append("Malpresentation");
                            break;
                        case "PRELS":
                            highRiskFound.append("Previous LSCS");
                            break;
                        case "TWINS":
                            highRiskFound.append("Twins");
                            break;
                        case "SBRTH":
                            highRiskFound.append("Still birth");
                            break;
                        case "P2ABO":
                            highRiskFound.append("Previous 2 abortions");
                            break;
                        case "KCOSCD":
                            highRiskFound.append("Known case of sickle cell disease");
                            break;
                        case "CONGDEF":
                            highRiskFound.append("Congenital Defects");
                            break;
                        case "SEVANM":
                            highRiskFound.append("Severe Anemia");
                            break;
                        case "OBSLBR":
                            highRiskFound.append("Obstructed Labour");
                            break;
                        case "CAESARIAN":
                            highRiskFound.append("Caesarian Section");
                            break;
                        default:
                            highRiskFound.append(risk);
                            break;
                    }
                    highRiskFound.append("\n");
                } else if (risk.contains(RchConstants.OTHER) && otherPreviousComplicationsAnswer != null) {
                    highRiskFound.append(otherPreviousComplicationsAnswer);
                    highRiskFound.append("\n");
                }
            }
        }

        if (highRiskFound.length() > 0) {
            return highRiskFound.toString();
        }

        return UtilBean.getMyLabel(RchConstants.NO_RISK_FOUND);
    }

    @Override
    public String identifyHighRiskForChildRchPnc(Object dangerousSignAnswer, Object otherDangerousSignAnswer) {

        StringBuilder highRiskFound = new StringBuilder();

        if (dangerousSignAnswer != null) {
            for (String risk : dangerousSignAnswer.toString().split(",")) {
                if (!risk.contains(RchConstants.OTHER) && !risk.contains(RchConstants.NONE)) {
                    try {
                        highRiskFound.append(UtilBean.getMyLabel(listValueBeanDao.queryBuilder()
                                .where().eq("idOfValue", risk).queryForFirst().getValue()));
                        highRiskFound.append("\n");
                    } catch (SQLException e) {
                        Log.e(getClass().getSimpleName(), null, e);
                    }
                } else if (risk.contains(RchConstants.OTHER) && otherDangerousSignAnswer != null) {
                    highRiskFound.append(otherDangerousSignAnswer);
                    highRiskFound.append("\n");
                }
            }
        }

        if (highRiskFound.length() > 0) {
            return highRiskFound.toString();
        }

        return UtilBean.getMyLabel(RchConstants.NO_RISK_FOUND);
    }

    @Override
    public String identifyHighRiskForMotherRchPnc(Object dangerousSignAnswer, Object otherDangerousSignAnswer) {

        StringBuilder highRiskFound = new StringBuilder();

        if (dangerousSignAnswer != null) {
            for (String risk : dangerousSignAnswer.toString().split(",")) {
                if (!risk.contains(RchConstants.OTHER) && !risk.contains(RchConstants.NONE)) {
                    try {
                        highRiskFound.append(UtilBean.getMyLabel(
                                listValueBeanDao.queryBuilder().where().eq(FieldNameConstants.ID_OF_VALUE, risk).queryForFirst().getValue()));
                        highRiskFound.append("\n");
                    } catch (SQLException e) {
                        Log.e(getClass().getSimpleName(), null, e);
                    }
                } else if (risk.contains(RchConstants.OTHER) && otherDangerousSignAnswer != null) {
                    highRiskFound.append(otherDangerousSignAnswer);
                    highRiskFound.append("\n");
                }
            }
        }

        if (highRiskFound.length() > 0) {
            return highRiskFound.toString();
        }

        return UtilBean.getMyLabel(RchConstants.NO_RISK_FOUND);
    }

    @Override
    public String identifyHighRiskForChildRchWpd(Object weightAnswer) {

        StringBuilder highRiskFound = new StringBuilder();
        if (BuildConfig.FLAVOR.equals(GlobalTypes.FLAVOUR_IMOMCARE)) {
            if (weightAnswer != null && Float.parseFloat(weightAnswer.toString()) < 2500f && Float.parseFloat(weightAnswer.toString()) > 0) {
                highRiskFound.append(UtilBean.getMyLabel(RchConstants.HIGH_RISK_VERY_LOW_WEIGHT));
                highRiskFound.append("\n");
            }
        } else {
            if (weightAnswer != null && Float.parseFloat(weightAnswer.toString()) < 2.5f && Float.parseFloat(weightAnswer.toString()) > 0) {
                highRiskFound.append(UtilBean.getMyLabel(RchConstants.HIGH_RISK_VERY_LOW_WEIGHT));
                highRiskFound.append("\n");
            }
        }

        if (highRiskFound.length() > 0) {
            return highRiskFound.toString();
        }

        return UtilBean.getMyLabel(RchConstants.NO_RISK_FOUND);
    }

    @Override
    public String identifyHighRiskForChardhamTourist(Map<String, Object> mapOfAnswers) {
        Object oxygenAnswer = mapOfAnswers.get("oxygenAnswer");
        Object bloodPressureAnswer = mapOfAnswers.get("bloodPressureAnswer");
        Object bloodSugarAnswer = mapOfAnswers.get("bloodSugarAnswer");
        Object temperatureAnswer = mapOfAnswers.get("temperatureAnswer");

        String age = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.CHARDHAM_MEMBER_AGE);
        String weight = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.CHARDHAM_MEMBER_WEIGHT);
        String hasBreathlessness = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.HAS_BREATHLESSNESS);
        String hasHighBp = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.HAS_HIGH_BP);
        String hasAsthma = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.HAS_ASTHMA);
        String hasDiabetes = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.HAS_DIABETES);
        String hasHeartConditions = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.HAS_HEART_CONDITIONS);
        String isChMemberPregnant = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.IS_CH_MEMBER_PREGNANT);

        String highRiskStatusOxygen = "";
        String highRiskStatusBP = "";
        String highRiskStatusBS = "";
        String highRiskStatusTemp = "";

        if (oxygenAnswer != null && oxygenAnswer.toString().length() > 0 && Float.parseFloat(oxygenAnswer.toString()) > 95.0) {
            highRiskStatusOxygen = LabelConstants.SCREENING_STATUS_GREEN;
        } else if (oxygenAnswer != null
                && oxygenAnswer.toString().length() > 0
                && Float.parseFloat(oxygenAnswer.toString()) <= 95.0
                && Float.parseFloat(oxygenAnswer.toString()) >= 90.0) {
            highRiskStatusOxygen = LabelConstants.SCREENING_STATUS_YELLOW;
        } else if (oxygenAnswer != null
                && oxygenAnswer.toString().length() > 0
                && Float.parseFloat(oxygenAnswer.toString()) < 90.0) {
            highRiskStatusOxygen = LabelConstants.SCREENING_STATUS_RED;
        }

        if (bloodPressureAnswer != null && bloodPressureAnswer.toString().contains("F")) {
            String[] bpAnswerArray = bloodPressureAnswer.toString().split("-");
            if (bpAnswerArray.length == 3) {
                int systolic = Integer.parseInt(bpAnswerArray[1]);
                int diastolic = Integer.parseInt(bpAnswerArray[2]);

                if (systolic < 140 && diastolic < 90) {
                    highRiskStatusBP = LabelConstants.SCREENING_STATUS_GREEN;
                } else if ((systolic > 170 || diastolic > 110)) {
                    highRiskStatusBP = LabelConstants.SCREENING_STATUS_RED;
                } else {
                    highRiskStatusBP = LabelConstants.SCREENING_STATUS_YELLOW;
                }
            }
        }

        if (bloodSugarAnswer != null && bloodSugarAnswer.toString().length() > 0 && Integer.parseInt(bloodSugarAnswer.toString()) <= 99) {
            highRiskStatusBS = LabelConstants.SCREENING_STATUS_GREEN;
        } else if (bloodSugarAnswer != null && bloodSugarAnswer.toString().length() > 0
                && Integer.parseInt(bloodSugarAnswer.toString()) >= 100
                && Integer.parseInt(bloodSugarAnswer.toString()) <= 125) {
            highRiskStatusBS = LabelConstants.SCREENING_STATUS_YELLOW;
        } else if (bloodSugarAnswer != null && bloodSugarAnswer.toString().length() > 0
                && Integer.parseInt(bloodSugarAnswer.toString()) >= 126) {
            highRiskStatusBS = LabelConstants.SCREENING_STATUS_RED;
        }

        if (temperatureAnswer != null && temperatureAnswer.toString().length() > 0 && Float.parseFloat(temperatureAnswer.toString()) < 100.0) {
            highRiskStatusTemp = LabelConstants.SCREENING_STATUS_GREEN;
        } else if (temperatureAnswer != null
                && temperatureAnswer.toString().length() > 0
                && Float.parseFloat(temperatureAnswer.toString()) >= 100.0
                && Float.parseFloat(temperatureAnswer.toString()) < 103.0) {
            highRiskStatusTemp = LabelConstants.SCREENING_STATUS_YELLOW;
        } else if (temperatureAnswer != null
                && temperatureAnswer.toString().length() > 0
                && Float.parseFloat(temperatureAnswer.toString()) >= 103.0) {
            highRiskStatusTemp = LabelConstants.SCREENING_STATUS_RED;
        }


        if (highRiskStatusOxygen.equalsIgnoreCase(LabelConstants.SCREENING_STATUS_RED)
                || highRiskStatusBP.equalsIgnoreCase(LabelConstants.SCREENING_STATUS_RED)
                || highRiskStatusBS.equalsIgnoreCase(LabelConstants.SCREENING_STATUS_RED)
                || highRiskStatusTemp.equalsIgnoreCase(LabelConstants.SCREENING_STATUS_RED)) {
            return LabelConstants.SCREENING_STATUS_RED;
        }

        if (highRiskStatusOxygen.equalsIgnoreCase(LabelConstants.SCREENING_STATUS_YELLOW)
                || highRiskStatusBP.equalsIgnoreCase(LabelConstants.SCREENING_STATUS_YELLOW)
                || highRiskStatusBS.equalsIgnoreCase(LabelConstants.SCREENING_STATUS_YELLOW)
                || highRiskStatusTemp.equalsIgnoreCase(LabelConstants.SCREENING_STATUS_YELLOW)
                || (age != null && Integer.parseInt(age) > 55)
                || (weight != null && Float.parseFloat(weight) > 100.00)
                || "1".equalsIgnoreCase(hasBreathlessness)
                || "1".equalsIgnoreCase(hasHighBp)
                || "1".equalsIgnoreCase(hasAsthma)
                || "1".equalsIgnoreCase(hasDiabetes)
                || "1".equalsIgnoreCase(hasHeartConditions)
                || "1".equalsIgnoreCase(isChMemberPregnant)) {
            return LabelConstants.SCREENING_STATUS_YELLOW;
        }

        if (highRiskStatusOxygen.equalsIgnoreCase(LabelConstants.SCREENING_STATUS_GREEN)
                || highRiskStatusBP.equalsIgnoreCase(LabelConstants.SCREENING_STATUS_GREEN)
                || highRiskStatusBS.equalsIgnoreCase(LabelConstants.SCREENING_STATUS_GREEN)
                || highRiskStatusTemp.equalsIgnoreCase(LabelConstants.SCREENING_STATUS_GREEN)
                || age != null && Integer.parseInt(age) <= 55) {
            return LabelConstants.SCREENING_STATUS_GREEN;
        }

        return UtilBean.getMyLabel(RchConstants.NO_RISK_FOUND);
    }

    @Override
    public String identifyHighRiskForAdolescent(Map<String, Object> mapOfAnswers) {
        Object haemoglobinAnswer = mapOfAnswers.get("haemoglobinAnswer");
        Object bmiAnswer = mapOfAnswers.get("bmiAnswer");
        Object isHavingIssueWithMenstruation = mapOfAnswers.get("isHavingIssueWithMenstruation");
        Object issueWithMenstruationAnswer = mapOfAnswers.get("issueWithMenstruationAnswer");
        StringBuilder highRiskFound = new StringBuilder();

        if (haemoglobinAnswer != null) {
            if (haemoglobinAnswer.toString().length() > 0 && Float.parseFloat(haemoglobinAnswer.toString()) <= 7) {
                highRiskFound.append(UtilBean.getMyLabel(RchConstants.HIGH_RISK_LOW_HAEMOGLOBIN));
                highRiskFound.append("\n");
                highRiskFound.append(UtilBean.getMyLabel(RchConstants.HIGH_RISK_SEVERE_ANEMIA));
                highRiskFound.append("\n");
            } else if (haemoglobinAnswer.toString().length() > 0 && Float.parseFloat(haemoglobinAnswer.toString()) >= 7 && Float.parseFloat(haemoglobinAnswer.toString()) <= 9) {
                highRiskFound.append(UtilBean.getMyLabel(RchConstants.HIGH_RISK_MODERATE_HAEMOGLOBIN));
                highRiskFound.append("\n");
            }
        }


        if (bmiAnswer != null) {
            String[] split = bmiAnswer.toString().split("/");
            String bmi = split[2];
            if (bmi.length() > 0 && Float.parseFloat(bmi) <= 18.5) {
                highRiskFound.append(UtilBean.getMyLabel(RchConstants.HIGH_RISK_UNDERWEIGHT));
                highRiskFound.append("\n");
            } else if (bmi.length() > 0 && Float.parseFloat(bmi) > 25 && Float.parseFloat(bmi) <= 29.9) {
                highRiskFound.append(UtilBean.getMyLabel(RchConstants.HIGH_RISK_OVERWEIGHT));
                highRiskFound.append("\n");
            } else if (bmi.length() > 0 && Float.parseFloat(bmi) >= 30) {
                highRiskFound.append(UtilBean.getMyLabel(RchConstants.HIGH_RISK_OBESE));
                highRiskFound.append("\n");
            }
        }

        if (isHavingIssueWithMenstruation != null && isHavingIssueWithMenstruation.toString().length() > 0 && isHavingIssueWithMenstruation.toString().contains("T")) {
            if (issueWithMenstruationAnswer != null && issueWithMenstruationAnswer.toString().length() > 0 && !issueWithMenstruationAnswer.toString().contains("NONE")) {
                highRiskFound.append(getFormattedIssues(capitalizeWord(issueWithMenstruationAnswer.toString().toLowerCase())));
                highRiskFound.append("\n");
            }
        }


        if (highRiskFound.length() > 0) {
            return highRiskFound.toString();
        }

        return UtilBean.getMyLabel(RchConstants.NO_RISK_FOUND);
    }

    public String getFormattedIssues(String issuesList) {
        String[] issueTokens = issuesList.split(",");
        String issues = "";
        StringBuilder stringBuilder = new StringBuilder();
        String delimiter = "";
        for (String email : issueTokens) {
            stringBuilder.append(delimiter);
            stringBuilder.append(email);
            delimiter = "\n";
        }
        issues = stringBuilder.toString();
        return issues;
    }

    public String capitalizeWord(String str) {
        String[] words = str.split("\\s");
        StringBuilder capitalizeWord = new StringBuilder();
        for (String w : words) {
            String first = w.substring(0, 1);
            String afterFirst = w.substring(1);
            capitalizeWord.append(first.toUpperCase()).append(afterFirst).append(" ");
        }
        return capitalizeWord.toString().trim();
    }
}
