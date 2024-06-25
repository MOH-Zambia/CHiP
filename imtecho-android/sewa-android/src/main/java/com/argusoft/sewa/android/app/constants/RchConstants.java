package com.argusoft.sewa.android.app.constants;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class RchConstants {

    private RchConstants() {
        throw new IllegalStateException("Utility Class");
    }

    //Member Status
    public static final String MEMBER_STATUS_AVAILABLE = "AVAILABLE";
    public static final String MEMBER_STATUS_DEATH = "DEATH";

    //
    public static final String OTHER = "OTHER";
    public static final String NONE = "NONE";
    public static final String NOT_KNOWN = "NK";
    public static final String REACTIVE = "REACTIVE";

    //
    public static final String NOT_DONE = "NOT_DONE";

    //Family Planning Methods
    public static final String FEMALE_STERILIZATION = "FMLSTR";
    public static final String MALE_STERILIZATION = "MLSTR";
    public static final String IUCD_5_YEARS = "IUCD5";
    public static final String SMAG_TRAINED = "SMAG Trained";
    public static final String IUCD_10_YEARS = "IUCD10";
    public static final String CONDOM = "CONDOM";
    public static final String ORAL_PILLS = "ORALPILLS";
    public static final String CHHAYA = "CHHAYA";
    public static final String ANTARA = "ANTARA";
    public static final String EMERGENCY_CONTRACEPTIVE_PILLS = "CONTRA";
    public static final String PPIUCD = "PPIUCD";
    public static final String PAIUCD = "PAIUCD";

    //Vaccinations
    public static final String HEPATITIS_B_0 = "HEPATITIS_B_0";
    public static final String BCG = "BCG";
    public static final String VITAMIN_K = "VITAMIN_K";
    public static final String OPV_0 = "OPV_0";
    public static final String OPV_1 = "OPV_1";
    public static final String OPV_2 = "OPV_2";
    public static final String OPV_3 = "OPV_3";
    public static final String OPV_BOOSTER = "OPV_BOOSTER";
    public static final String PENTA_1 = "PENTA_1";
    public static final String PENTA_2 = "PENTA_2";
    public static final String PENTA_3 = "PENTA_3";
    public static final String DPT_1 = "DPT_1";
    public static final String DPT_2 = "DPT_2";
    public static final String DPT_3 = "DPT_3";
    public static final String MEASLES_RUBELLA_1 = "MEASLES_RUBELLA_1";
    public static final String MEASLES_1 = "MEASLES_1";
    public static final String DPT_BOOSTER = "DPT_BOOSTER";
    public static final String F_IPV_1_01 = "F_IPV_1_01";
    public static final String F_IPV_2_01 = "F_IPV_2_01";
    public static final String F_IPV_2_05 = "F_IPV_2_05";
    public static final String MEASLES_RUBELLA_2 = "MEASLES_RUBELLA_2";
    public static final String MEASLES_2 = "MEASLES_2";
    public static final String VITAMIN_A = "VITAMIN_A";
    public static final String ROTA_VIRUS_1 = "ROTA_VIRUS_1";
    public static final String ROTA_VIRUS_2 = "ROTA_VIRUS_2";
    public static final String ROTA_VIRUS_3 = "ROTA_VIRUS_3";
    public static final String TT1 = "TT1";
    public static final String TT2 = "TT2";
    public static final String TT_BOOSTER = "TT_BOOSTER";

    //Zambian vaccines
    public static final String Z_BCG = "BCG";
    public static final String Z_VITTAMIN_A_50000 = "VITAMIN_A_50000";
    public static final String Z_VITTAMIN_A_100000 = "VITAMIN_A_100000";
    public static final String Z_VITTAMIN_A_200000_1 = "VITAMIN_A_200000_1";
    public static final String Z_VITTAMIN_A_200000_2 = "VITAMIN_A_200000_2";
    public static final String Z_VITTAMIN_A_200000_3 = "VITAMIN_A_200000_3";
    public static final String Z_VITTAMIN_A_200000_4 = "VITAMIN_A_200000_4";
    public static final String Z_VITTAMIN_A_200000_5 = "VITAMIN_A_200000_5";
    public static final String Z_VITTAMIN_A_200000_6 = "VITAMIN_A_200000_6";
    public static final String Z_VITTAMIN_A_200000_7 = "VITAMIN_A_200000_7";
    public static final String Z_VITTAMIN_A_200000_8 = "VITAMIN_A_200000_8";

    public static final String Z_OPV_0 = "OPV_0";
    public static final String Z_OPV_1 = "OPV_1";
    public static final String Z_OPV_2 = "OPV_2";
    public static final String Z_OPV_3 = "OPV_3";
    public static final String Z_OPV_4 = "OPV_4";
    public static final String Z_PCV_1 = "PCV_1";
    public static final String Z_PCV_2 = "PCV_2";
    public static final String Z_PCV_3 = "PCV_3";
    public static final String Z_DPT_HEB_HIB_1 = "DPT-HEPB-HIB_1";
    public static final String Z_DPT_HEB_HIB_2 = "DPT-HEPB-HIB_2";
    public static final String Z_DPT_HEB_HIB_3 = "DPT-HEPB-HIB_3";
    public static final String Z_MEASLES_RUBELLA_1 = "MEASLES_RUBELLA_1";
    public static final String Z_MEASLES_RUBELLA_2 = "MEASLES_RUBELLA_2";
    public static final String Z_ROTA_VACCINE_1 = "ROTA_VACCINE_1";
    public static final String Z_ROTA_VACCINE_2 = "ROTA_VACCINE_2";
    public static final String PCV_BOOSTER = "PCV_BOOSTER";

    // Health Infrastructure Type IDs
    public static final Long INFRA_DISTRICT_HOSPITAL = 1007L;
    public static final Long INFRA_SUB_DISTRICT_HOSPITAL = 1008L;
    public static final Long INFRA_COMMUNITY_HEALTH_CENTER = 1009L;
    public static final Long INFRA_TRUST_HOSPITAL = 1010L;
    public static final Long INFRA_MEDICAL_COLLEGE_HOSPITAL = 1012L;
    public static final Long INFRA_PRIVATE_HOSPITAL = 1013L;
    public static final Long INFRA_PHC = 1061L;
    public static final Long INFRA_SC = 1062L;
    public static final Long INFRA_UPHC = 1063L;
    public static final Long INFRA_URBAN_COMMUNITY_HEALTH_CENTER = 1084L;

    //Health Infrastructure Types
    public static final String INFRA_TYPE_SC = "Sub Center";

    //SD Score Constants
    public static final String SD_SCORE_SD4 = "SD4";
    public static final String SD_SCORE_SD3 = "SD3";
    public static final String SD_SCORE_SD2 = "SD2";
    public static final String SD_SCORE_SD1 = "SD1";
    public static final String SD_SCORE_MEDIAN = "MEDIAN";
    public static final String SD_SCORE_NONE = "NONE";
    public static final String SD_SCORE_CANNOT_BE_CALCULATED = "Cannot be calculated";

    //Place of birth
    public static final String HOME = "HOME";
    public static final String HOSP = "HOSP";
    public static final String ON_THE_WAY = "ON_THE_WAY";
    public static final String AMBULANCE_108 = "108_AMBULANCE";
    public static final String OUT_OF_STATE_GOVT = "OUT_OF_STATE_GOVT";
    public static final String OUT_OF_STATE_PVT = "OUT_OF_STATE_PVT";

    //RCH HIGH RISK
    public static final String HIGH_RISK_HIGH_BLOOD_PRESSURE = "High Blood Pressure";
    public static final String HIGH_RISK_LOW_HAEMOGLOBIN = "Low Haemoglobin";
    public static final String HIGH_RISK_LOW_OXYGEN = "Low Oxygen";
    public static final String HIGH_TEMP = "High Temperature";
    public static final String HIGH_BLOOD_SUGAR_LEVEL = "High Blood Sugar";
    public static final String HIGH_RISK_VERY_LOW_WEIGHT = "Very Low Weight";
    public static final String HIGH_RISK_URINE_ALBUMIN = "Urine Albumin";
    public static final String HIGH_RISK_URINE_SUGAR = "Urine Sugar";
    public static final String HIGH_RISK_SICKLE_CELL = "Sickle Cell Test Positive";
    public static final String NO_RISK_FOUND = "No risks found";
    public static final String NO_RISK_IDENTIFIED_IN_THIS_VISIT = "No high risks were identified in this visit";
    public static final String HEALTH_ADVISORY_FOR = "Health Advisory For";

    //RCH High Risk for DNHDD
    public static final String SUSPECTED_HYPERTENSION = "Suspected Hypertension";
    public static final String SUSPECTED_DIABETES = "Gestational Diabetes Suspect";

    //CEREBRAL PALSY CONSTANTS
    public static final String CP_DELAYED_DEVELOPMENT = "DD";
    public static final String CP_TREATMENT_COMMENCED = "TC";

    public static final String HIGH_RISK_LOW_HEIGHT = "Low Height";
    public static final String WEIGHT_PW = "WEIGHT_PW";
    public static final String HEIGHT_PW = "HEIGHT_PW";
    public static final String WEIGHT_C = "WEIGHT_C";
    public static final String DISEASE_LIST_VALUES = "DISEASE_LV";
    public static final String DISABILITY_LV = "DISABILITY_LV";
    public static final String DISEASE_CONSTANT = "DISEASE_CONSTANT";
    public static final String OTHER_DISEASE = "OTHER_DISEASE";
    public static final String BLOOD_PRESSURE = "BP";
    public static final String HAEMOGLOBIN = "HB";
    public static final String HAEMOGLOBIN_DNHDD = "HB_DNHDD";
    public static final String URINE_TEST = "URINE_TEST";
    public static final String URINE_ALBUMIN = "URINE_ALBUMIN";
    public static final String URINE_SUGAR = "URINE_SUGAR";
    public static final String ULTRASOUND_TEST = "ULTRASOUND_TEST";
    public static final String ULTRASOUND_ABNORMALITY = "ULTRASOUND_ABNORMALITY";
    public static final String HEPATITIS_C = "HEPATITIS_C";
    public static final String FETAL_HEART_RATE = "FETAL_HEART_RATE";
    public static final String HBSAG_TEST = "HBSAG";
    public static final String BLOOD_SUGAR_TEST = "SUGAR_TEST";
    public static final String DNHDD_BLOOD_SUGAR_TEST = "SUGAR_TEST_DNHDD";
    public static final String BLOOD_SUGAR_VALUE = "SUGAR_VALUE";
    public static final String DNHDD_BLOOD_SUGAR_VALUE = "SUGAR_VALUE_DNHDD";
    public static final String VDRL_TEST = "VDRL";
    public static final String TUBERCULOSIS = "TB";
    public static final String MALARIA = "MALARIA";
    public static final String SYPHILIS_TEST = "SYPHILIS";
    public static final String RPR_FOR_SYPHILIS_TEST = "RPR_FOR_SYPHILIS";
    public static final String HIV_TEST = "HIV";
    public static final String SICKLE_CELL_TEST = "SICKLE_CELL";
    public static final String SICKLE_CELL_TEST_DNHDD = "SICKLE_CELL_DNHDD";
    public static final String ORAL_GTT = "ORAL_GTT";
    public static final String PREVIOUS_PREG_OUTCOME = "PREVIOUS_PREG_OUTCOME";
    public static final String HIGH_RISK_TUBERCULOSIS = "Tuberculosis";
    public static final String HIGH_RISK_MALARIA = "Malaria";
    public static final String HBSAG_REACTIVE = "REACTIVE";
    public static final String TEST_POSITIVE = "POSITIVE";
    public static final String TEST_NEGATIVE = "NEGATIVE";
    public static final String TEST_NOT_DONE = "NOT_DONE";

    public static final String SICKLE_CELL = "SICKLE_CELL";
    public static final String SICKLE_CELL_TRAIT = "SICKLE_CELL_TRAIT";
    public static final String HIGH_RISK_HIV = "HIV Positive";
    public static final String HIGH_RISK_VDRL = "VDRL Positive";
    public static final String HIGH_RISK_SYPHILIS = "Syphilis Positive";
    public static final String HIGH_RISK_RPR_SYPHILIS = "RPR for Syphilis Positive";
    public static final String HIGH_RISK_ORAL_GTT = "Oral GTT Positive";
    public static final String HIGH_RISK_ABNORMALITY_IN_ULTRASOUND = "Abnormality detected in Ultrasound";
    public static final String HIGH_RISK_HIGH_FETAL_HEART_RATE = "High Fetal Heart Rate";
    public static final String HIGH_RISK_LOW_FETAL_HEART_RATE = "Low Fetal Heart Rate";
    public static final String HIGH_RISK_REACTIVE_HBSAG_TEST = "HBsAg Reactive";
    public static final String HIGH_RISK_HIGH_BLOOD_SUGAR = "High Blood Sugar";
    public static final String HIGH_RISK_PREVIOUS_PREG_OUTCOME_STILL_BIRTH = "Still birth in previous pregnancy";
    public static final String HEPATITIS_C_POSITIVE = "Positive for Hepatitis C ";
    public static final String TEEN_AGE_PREGNANCY = "Teenage Pregnancy";
    public static final String ELDER_AGE_PREGNANCY = "Elderly Pregnancy";
    public static final String ABORTION_HISTORY = "History of recurrent abortion";
    public static final String THYROID_RISK = "Hypothyroidism";
    public static final String NEGATIVE_BLOOD_GROUP = "Has -ve blood group";
    public static final String CERVIX_LENGTH = "Risk found in cervix length";
    public static final String NECK_CORD = "Has cord around neck";
    public static final String MULTIPLE_GESTATION = "Multiple Gestation";
    public static final String OVARIAN_ANOMALY = "Ovarian Anomaly";
    public static final String UTERUS_ANOMALY = "Uterus Anomaly";
    public static final String FETAL_ANOMALY = "Fetal Anomaly";
    public static final String IUGR = "Has intrauterine growth restriction";
    public static final String FOETAL_POSITION_BREECH = "Breech position of foetus";
    public static final String AMNIOTIC_FLUID_LOW = "Low amniotic fluid index";
    public static final String AMNIOTIC_FLUID_HIGH = "High amniotic fluid index";
    public static final String FOETAL_HEART_SOUND = "No foetal heart sound";
    public static final String PLACENTA_POSITION = "Risk in placenta position";
    public static final String FOETAL_POSITION = "Risk in foetal position";

    public static final String PREVIOUS_PREGNANCY_COMPLICATION_APH = "APH";
    public static final String PREVIOUS_PREGNANCY_COMPLICATION_PPH = "PPH";
    public static final String PREVIOUS_PREGNANCY_COMPLICATION_PRETRM = "PRETRM";
    public static final String PREVIOUS_PREGNANCY_COMPLICATION_PIH = "PIH";
    public static final String PREVIOUS_PREGNANCY_COMPLICATION_CONVLS = "CONVLS";
    public static final String PREVIOUS_PREGNANCY_COMPLICATION_MLPRST = "MLPRST";
    public static final String PREVIOUS_PREGNANCY_COMPLICATION_PRELS = "PRELS";
    public static final String PREVIOUS_PREGNANCY_COMPLICATION_TWINS = "TWINS";
    public static final String PREVIOUS_PREGNANCY_COMPLICATION_SBRTH = "SBRTH";
    public static final String PREVIOUS_PREGNANCY_COMPLICATION_P2ABO = "P2ABO";
    public static final String PREVIOUS_PREGNANCY_COMPLICATION_SEVANM = "SEVANM";
    public static final String PREVIOUS_PREGNANCY_COMPLICATION_OBSLBR = "OBSLBR";

    public static final String HIGH_RISK_IDENTIFIED_INSTRUCTION = "Following high risks have been identified in the visit";

    public static final String HIGH_RISK_OVERWEIGHT = "Over weight";
    public static final String HIGH_RISK_UNDERWEIGHT = "Under weight";
    public static final String NORMAL = "Normal";
    public static final String HIGH_RISK_OBESE = "Obese";

    public static final String HIGH_RISK_MODERATE_HAEMOGLOBIN = "Moderate Haemoglobin";
    public static final String HIGH_RISK_SEVERE_ANEMIA = "Severe Anemia";

    public static final List<String> PHI_INSTITUTIONS_TYPE_ID_FOR_2_DAYS_DEL_GAP = Collections.unmodifiableList(getPhiInstitutionsTypeIdFor2DaysDelGap());
    public static final List<Long> GOVERNMENT_INSTITUTIONS = Collections.unmodifiableList(getGovernmentInstitutions());

    private static List<String> getPhiInstitutionsTypeIdFor2DaysDelGap() {
        List<String> stringList = new ArrayList<>();
        stringList.add(RchConstants.INFRA_DISTRICT_HOSPITAL.toString());
        stringList.add(RchConstants.INFRA_SUB_DISTRICT_HOSPITAL.toString());
        stringList.add(RchConstants.INFRA_COMMUNITY_HEALTH_CENTER.toString());
        stringList.add(RchConstants.INFRA_MEDICAL_COLLEGE_HOSPITAL.toString());
        stringList.add(RchConstants.INFRA_PHC.toString());
        stringList.add(RchConstants.INFRA_UPHC.toString());
        stringList.add(RchConstants.INFRA_URBAN_COMMUNITY_HEALTH_CENTER.toString());
        return stringList;
    }

    private static List<Long> getGovernmentInstitutions() {
        List<Long> longList = new ArrayList<>();
        longList.add(RchConstants.INFRA_DISTRICT_HOSPITAL);
        longList.add(RchConstants.INFRA_SUB_DISTRICT_HOSPITAL);
        longList.add(RchConstants.INFRA_COMMUNITY_HEALTH_CENTER);
        longList.add(RchConstants.INFRA_MEDICAL_COLLEGE_HOSPITAL);
        longList.add(RchConstants.INFRA_PHC);
        longList.add(RchConstants.INFRA_SC);
        longList.add(RchConstants.INFRA_UPHC);
        longList.add(RchConstants.INFRA_URBAN_COMMUNITY_HEALTH_CENTER);
        return longList;
    }

    private static final Map<String, String> HIGH_RISK_DISEASES_MAP = new HashMap<>();

    public static String getHighRiskDiseaseFromConstant(String constant) {
        if (HIGH_RISK_DISEASES_MAP.isEmpty()) {
            //PREVIOUS_PREGNANCY_COMPLICATIONS
            HIGH_RISK_DISEASES_MAP.putAll(getPreviousPregnancyComplicationsMap());
            HIGH_RISK_DISEASES_MAP.putAll(getPreviousIllnessAncMap());
            HIGH_RISK_DISEASES_MAP.putAll(getHereditaryDiseaseMap());

        }
        return HIGH_RISK_DISEASES_MAP.containsKey(constant) ? HIGH_RISK_DISEASES_MAP.get(constant) : constant;
    }

    private static Map<String, String> getPreviousIllnessAncMap() {
        Map<String, String> map = new HashMap<>();
        map.put("HYPERTENSION", "Hypertension");
        map.put("DIABETES", "Diabetes");
        map.put("HYPOTHYROIDISM", "Hypothyroidism");
        map.put("EPILEPSY", "Epilepsy");
        map.put("SICKLE_CELL_DISEASE", "Sickle cell disease");
        map.put("RHEUMATIC_HEART_DISEASE", "Rheumatic heart disease");
        map.put("CANCER", "Cancer");
        map.put("HIV", "HIV");
        return map;
    }

    private static Map<String, String> getPreviousPregnancyComplicationsMap() {
        Map<String, String> map = new HashMap<>();
        map.put(PREVIOUS_PREGNANCY_COMPLICATION_APH, "APH");
        map.put(PREVIOUS_PREGNANCY_COMPLICATION_PPH, "PPH");
        map.put(PREVIOUS_PREGNANCY_COMPLICATION_PRETRM, "Pre term");
        map.put(PREVIOUS_PREGNANCY_COMPLICATION_PIH, "PIH");
        map.put(PREVIOUS_PREGNANCY_COMPLICATION_CONVLS, "Convulsion");
        map.put(PREVIOUS_PREGNANCY_COMPLICATION_MLPRST, "Malpresentation");
        map.put(PREVIOUS_PREGNANCY_COMPLICATION_PRELS, "Previous LSCS");
        map.put(PREVIOUS_PREGNANCY_COMPLICATION_TWINS, "Multi Para");
        map.put(PREVIOUS_PREGNANCY_COMPLICATION_SBRTH, "Still birth");
        map.put(PREVIOUS_PREGNANCY_COMPLICATION_P2ABO, "Previous abortions");
        map.put(PREVIOUS_PREGNANCY_COMPLICATION_SEVANM, "Severe Anemia");
        map.put(PREVIOUS_PREGNANCY_COMPLICATION_OBSLBR, "Obstructed Labour");
        return map;
    }

    private static Map<String, String> getHereditaryDiseaseMap() {
        Map<String, String> map = new HashMap<>();
        map.put("HEMOPHILIA", "Hemophilia");
        map.put("SICKLE_CELL_ANEMIA", "Sickle cell anemia");
        map.put("THALASSEMIA", "Thalassemia");
        return map;
    }

}
