package com.argusoft.sewa.android.app.constants;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Created by prateek on 9/26/19
 */
public class FormConstants {

    private FormConstants() {
        throw new IllegalStateException("Utility Class");
    }

    //TeCHO FHW Sheets
    public static final String FAMILY_HEALTH_SURVEY = "FHS";
    public static final String ADOLESCENT_HEALTH_SCREENING = "ADOLESCENT_HEALTH_SCREENING";
    public static final String CFHC = "CFHC";
    public static final String CAM_FHS = "CAM_FHS";
    public static final String CAM_ANC = "CAM_ANC";
    public static final String CAM_WPD = "CAM_WPD";
    public static final String CAM_RIM = "CAM_RIM";
    public static final String CAM_FHS_MEMBER_UPDATE = "CAM_FHS_MEMBER_UPDATE";
    public static final String HOUSE_HOLD_LINE_LIST = "HOUSE_HOLD_LINE_LIST";
    public static final String HOUSE_HOLD_LINE_LIST_NEW = "HOUSE_HOLD_LINE_LIST_NEW";
    public static final String FAMILY_FOLDER = "FAMILY_FOLDER";
    public static final String FAMILY_FOLDER_MEMBER_UPDATE = "FAMILY_FOLDER_MEMBER_UPDATE";
    public static final String LOCKED_FAMILY = "LOCKED_FAMILY";
    public static final String FHS_MEMBER_UPDATE = "MEMBER_UPDATE";
    public static final String FHS_MEMBER_UPDATE_NEW = "MEMBER_UPDATE_NEW";
    public static final String HIV_POSITIVE = "HIV_POSITIVE";
    public static final String BCG_VACCINATION_SURVEY = "BCG_VACCINATION_SURVEY";
    public static final String BCG_ELIGIBLE = "BCG_ELIGIBLE";
    public static final String FHS_ADD_MEMBER = "ADD_MEMBER";
    public static final String LMP_FOLLOW_UP = "LMPFU";
    public static final String TECHO_FHW_ANC = "FHW_ANC";
    public static final String TECHO_FHW_WPD = "FHW_WPD";
    public static final String TECHO_FHW_PNC = "FHW_PNC";
    public static final String TECHO_FHW_CI = "FHW_CI";
    public static final String TECHO_FHW_CS = "FHW_CS";
    public static final String TECHO_FHW_VAE = "FHW_VAE";
    public static final String CHIP_ACTIVE_MALARIA = "ACTIVE_MALARIA";
    public static final String CHIP_ACTIVE_MALARIA_FOLLOW_UP = "ACTIVE_MALARIA_FOLLOW_UP";
    public static final String CHIP_PASSIVE_MALARIA = "PASSIVE_MALARIA";
    public static final String CHIP_INDEX_INVESTIGATION = "INDEX_INVESTIGATION";
    public static final String MALARIA_NON_INDEX = "MALARIA_NON_INDEX";
    public static final String MALARIA_INDEX = "MALARIA_INDEX";
    public static final String CHIP_TB = "CHIP_TB";
    public static final String HIV_SCREENING = "HIV_SCREENING";
    public static final String OCR_CHILD_HIV_SCREENING = "OCR_CHILD_HIV_SCREENING";
    public static final String OCR_ADULT_HIV_SCREENING = "OCR_ADULT_HIV_SCREENING";
    public static final String CHIP_TB_FOLLOW_UP = "CHIP_TB_FOLLOW_UP";
    public static final String CHIP_COVID_SCREENING = "CHIP_COVID_SCREENING";
    public static final String TECHO_FHW_RIM = "FHW_RIM";
    public static final String CHIP_GBV_SCREENING = "CHIP_GBV_SCREENING";
    public static final String CHIP_FP_FOLLOW_UP = "CHIP_FP_FOLLOW_UP";
    public static final String PREGNANCY_STATUS = "PREGNANCY_STATUS";
    public static final String IDSP_FAMILY_2 = "IDSP_FAMILY_2";
    public static final String IDSP_MEMBER = "IDSP_MEMBER";
    public static final String IDSP_MEMBER_2 = "IDSP_MEMBER_2";
    public static final String IDSP_NEW_FAMILY = "IDSP_NEW_FAMILY";
    public static final String TECHO_WPD_DISCHARGE = "DISCHARGE";
    public static final String TECHO_CS_APPETITE_TEST = "APPETITE";
    public static final String TT2_ALERT = "TT2_ALERT";
    public static final String IRON_SUCROSE_ALERT = "IRON_SUCROSE_ALERT";
    public static final String SAM_SCREENING = "SAM_SCREENING";
    public static final String FHW_SAM_SCREENING_REF = "FHW_SAM_SCREENING_REF";
    public static final String FHW_MONTHLY_SAM_SCREENING = "FHW_SAM_AFTER_CMAM";
    public static final String GERIATRICS_MEDICATION_ALERT = "GMA";
    public static final String TRAVELLERS_SCREENING = "TRAVELLERS_SCREENING";

    //TeCHO NCD FHW SHEETS
    public static final String NCD_FHW_MENTAL_HEALTH = "NCD_FHW_MENTAL_HEALTH";
    public static final String NCD_FHW_HYPERTENSION = "NCD_FHW_HYPERTENSION";
    public static final String NCD_FHW_DIABETES = "NCD_FHW_DIABETES";
    public static final String NCD_FHW_ORAL = "NCD_FHW_ORAL";
    public static final String NCD_FHW_BREAST = "NCD_FHW_BREAST";
    public static final String NCD_FHW_CERVICAL = "NCD_FHW_CERVICAL";
    public static final String NCD_FHW_HEALTH_SCREENING = "NCD_FHW_HEALTH_SCREENING";
    public static final String NCD_PERSONAL_HISTORY = "NCD_PERSONAL_HISTORY";
    public static final String NCD_FHW_DIABETES_CONFIRMATION = "NCD_FHW_DIABETES_CONFIRMATION";
    public static final String NCD_FHW_WEEKLY_CLINIC = "NCD_FHW_WEEKLY_CLINIC";
    public static final String NCD_FHW_WEEKLY_HOME = "NCD_FHW_WEEKLY_HOME";
    public static final String NCD_MO_CONFIRMED = "NCD_MO_CONFIRMED";
    public static final String NCD_URINE_TEST = "NCD_URINE_TEST";
    public static final String NCD_CVC_CLINIC = "NCD_CVC_CLINIC";
    public static final String NCD_CVC_HOME = "NCD_CVC_HOME";
    public static final String NCD_RETINOPATHY_TEST = "NCD_RETINOPATHY_TEST";

    // Data Collector for Anemia
    public static final String SICKLE_CELL_SURVEY = "SICKLE_CELL_SURVEY";
    public static final String SICKLE_CELL_ADD_FAMILY = "SICKLE_CELL_ADD_FAMILY";
    public static final String SICKLE_CELL_ADD_NEW_MEMBER = "SICKLE_CELL_ADD_NEW_MEMBER";
    public static final String ANEMIA_SURVEY = "ANEMIA_SURVEY";
    public static final String DNHDD_ANEMIA_SURVEY = "DNHDD_ANEMIA_SURVEY";
    public static final String ANEMIA_PROTOCOL_DEVIATION = "ANEMIA_PROTOCOL_DEVIATION";
    public static final String ANEMIA_CRF = "ANEMIA_CRF";


    //TeCHO ASHA Sheets
    public static final String ASHA_LMPFU = "ASHA_LMPFU";
    public static final String ASHA_PNC = "ASHA_PNC";
    public static final String ASHA_ANC = "ASHA_ANC";
    public static final String ASHA_WPD = "ASHA_WPD";
    public static final String ASHA_CS = "ASHA_CS";
    public static final String ASHA_SAM_SCREENING = "ASHA_SAM_SCREENING";
    public static final String CMAM_FOLLOWUP = "CMAM_FOLLOWUP";

    //TeCHO NCD ASHA Sheets
    public static final String NCD_ASHA_CBAC = "NCD_ASHA_CBAC";

    //TeCHO NPCB ASHA Sheets
    public static final String ASHA_NPCB = "ASHA_NPCB";

    //TeCHO Static Form Names.
    public static final String AADHAR_UPDATION = "AADHAR_UPDATION";
    public static final String PHONE_UPDATION = "PHONE_UPDATION";
    public static final String AADHAR_PHONE_UPDATION = "AADHAR_PHONE_UPDATION";
    public static final String TECHO_MIGRATION_IN = "MIGRATION_IN";
    public static final String TECHO_MIGRATION_OUT = "MIGRATION_OUT";
    public static final String TECHO_MIGRATION_IN_CONFIRMATION = "MIGRATION_IN_CONFIRMATION";
    public static final String TECHO_MIGRATION_OUT_CONFIRMATION = "MIGRATION_OUT_CONFIRMATION";
    public static final String TECHO_MIGRATION_REVERTED = "MIGRATION_REVERTED";
    public static final String TECHO_FAMILY_MIGRATION_REVERTED = "FAMILY_MIGRATION_REVERTED";
    public static final String FHSR_PHONE_UPDATE = "FHSR_PHONE_UPDATE";
    public static final String MOBILE_NUMBER_VERIFICATION = "MOBILE_NUMBER_VERIFICATION";
    public static final String LMS_TEST = "LMS_TEST";
    public static final String OFFLINE_ABHA_NUMBER_CREATIONS = "OFFLINE_ABHA_NUMBER_CREATIONS";
    public static final String NCD_ECG_REPORT = "NCD_ECG_REPORT";
    public static final String NCD_ECG_TOKEN = "NCD_ECG_TOKEN";

    //Family Migration Forms
    public static final String FAMILY_MIGRATION_OUT = "FAM_MIG_OUT";
    public static final String FAMILY_MIGRATION_IN_CONFIRMATION = "FAM_MIG_IN_CONF";

    //AWW Sheets
    public static final String TECHO_AWW_CS = "AWW_CS";
    public static final String TECHO_AWW_THR = "AWW_THR";
    public static final String TECHO_AWW_HEIGHT_GROWTH_GRAPH = "AWW_HEIGHT_GROWTH_GRAPH";
    public static final String TECHO_AWW_WEIGHT_GROWTH_GRAPH = "AWW_WEIGHT_GROWTH_GRAPH";
    public static final String TECHO_AWW_DAILY_NUTRITION = "AWW_DAILY_NUTRITION";

    // Morbidity Sheets for Techo
    public static final String ANC_MORBIDITY = "ANCMORB";
    public static final String PNC_MORBIDITY = "PNCMORB";
    public static final String CHILD_CARE_MORBIDITY = "CCMORB";

    public static final String SURVEILLANCE_PREG_OUTCOME = "SURVEILLANCE_PREG_OUTCOME";
    public static final String SURVEILLANCE_PREG_REG = "SURVEILLANCE_PREG_REG";
    public static final String SURVEILLANCE_CHILD_DEATH = "SURVEILLANCE_CHILD_DEATH";
    public static final String SURVEILLANCE_ADD_FAMILY = "SURVEILLANCE_ADD_FAMILY";
    public static final String SURVEILLANCE_ADD_MEMBER = "SURVEILLANCE_ADD_NEW_MEMBER";

    //KIOSK Sheets
    public static final String CHARDHAM_MEMBER_SCREENING = "CHARDHAM_MEMBER_SCREENING";

    public static final List<String> FHS_SHEETS = Collections.unmodifiableList(getFhsSheets());
    public static final List<String> RCH_SHEETS = Collections.unmodifiableList(getRchSheets());
    public static final List<String> NCD_SHEETS = Collections.unmodifiableList(getNcdSheets());
    public static final List<String> NPCB_SHEETS = Collections.unmodifiableList(getNpcbSheets());
    public static final List<String> MORBIDITY_SHEETS = Collections.unmodifiableList(getMorbiditySheets());
    public static final List<String> AWW_SHEETS = Collections.unmodifiableList(getAwwSheets());
    public static final List<String> KIOSK_SHEETS = Collections.unmodifiableList(getKioskSheets());
    public static final List<String> NEW_DATA_BEAN_APPROACH_FORMS = Collections.unmodifiableList(getNewDataBeanApproachForms());

    //Reported Event Form
    public static final String ASHA_REPORTED_EVENT = "ASHA_REPORTED_EVENT";
    public static final String FHW_REPORTED_EVENT_REJECTION = "FHW_EVENT_REJECTION";

    //ASHA Reported Event Types
    public static final String ASHA_REPORT_FAMILY_MIGRATION = "REPORT_FAMILY_MIGRATION";
    public static final String ASHA_REPORT_FAMILY_SPLIT = "REPORT_FAMILY_SPLIT";
    public static final String ASHA_REPORT_MEMBER_MIGRATION = "REPORT_MIGRATION";
    public static final String ASHA_REPORT_MEMBER_DEATH = "REPORT_DEATH";
    public static final String ASHA_REPORT_MEMBER_DELIVERY = "REPORT_DELIVERY";

    //FHW Confirmation Forms for ASHA Reported Events
    public static final String FHW_PREGNANCY_CONFIRMATION = "FHW_PREG_CONF";
    public static final String FHW_DEATH_CONFIRMATION = "FHW_DEATH_CONF";

    // Form Types for Production Access
    public static final String FORM_TYPE_FHS = "FHS";
    public static final String FORM_TYPE_RCH = "RCH";
    public static final String FORM_TYPE_ASHA_FHS = "ASHA_FHS";
    public static final String FORM_TYPE_ASHA_RCH = "ASHA_RCH";
    public static final String FORM_TYPE_IDSP_2 = "IDSP_2";
    public static final String FORM_TYPE_NCD = "NCD";
    public static final String FORM_TYPE_NPCB = "NPCB";

    //DNHDD related forms
    public static final String DNHDD_NCD_CBAC_AND_NUTRITION = "DNHDD_NCD_CBAC_AND_NUTRITION";
    public static final String DNHDD_NCD_HYPERTENSION_DIABETES_AND_MENTAL_HEALTH = "DNHDD_NCD_HYPERTENSION_DIABETES_AND_MENTAL_HEALTH";
    public static final String CANCER_SCREENING = "CANCER_SCREENING";
    public static final String DNHDD_FHW_SAM_SCREENING = "DNHDD_FHW_SAM_SCREENING";
    public static final String DNHDD_CMAM_FOLLOWUP = "DNHDD_CMAM_FOLLOWUP";
    public static final String KNOWN_POSITIVE = "KNOWN_POSITIVE";
    public static final String OCR_KNOWN_POSITIVE = "OCR_KNOWN_POSITIVE";
    public static final String HIV_SCREENING_FU = "HIV_SCREENING_FU";
    public static final String STOCK_MANAGEMENT = "STOCK_MANAGEMENT";
    public static final String EMTCT = "EMTCT";
    public static final String OCR_ACTIVE_MALARIA = "OCR_ACTIVE_MALARIA";
    public static final String OCR_PASSIVE_MALARIA = "OCR_PASSIVE_MALARIA";
    public static final String OCR_COVID_SCREENING = "OCR_COVID_SCREENING";
    public static final String OCR_TB_SCREENING = "OCR_TB_SCREENING";
    public static final String OCR_LMPFU = "OCR_LMPFU";
    public static final String OCR_FAMILY_PLANNING = "OCR_FAMILY_PLANNING";
    public static final String OCR_HIV_POSITIVE = "OCR_HIV_POSITIVE";
    public static final String OCR_EMTCT = "OCR_EMTCT";
    public static final String OCR_ANC = "OCR_ANC";

//    public static final String DNHDD_APPETITE = "DNHDD_APPETITE";

    //Sickle cell survey forms
    public static final String ADD_FAMILY_FOR_SURVEY = "FAMILY_FOLDER_FOR_SURVEY";

    //Hydroxyurea survey forms
    public static final String HU_SURVEY = "HU_SURVEY";
    public static final String HU_MEDICAL_ASSESSMENT = "HU_MEDICAL_ASSESSMENT";
    public static final String HU_FOLLOW_UP = "HU_FOLLOW_UP";
    public static final String HU_PREG_OUTCOME = "HU_PREG_OUTCOME";

    private static List<String> stringList;

    private static List<String> getFhsSheets() {
        stringList = new ArrayList<>();
        stringList.add(FormConstants.FAMILY_HEALTH_SURVEY);
        stringList.add(FormConstants.CFHC);
        stringList.add(FormConstants.FHS_MEMBER_UPDATE);
        stringList.add(FormConstants.FHS_MEMBER_UPDATE_NEW);
        stringList.add(FormConstants.FHS_ADD_MEMBER);
        stringList.add(FormConstants.FAMILY_FOLDER);
        stringList.add(FormConstants.HOUSE_HOLD_LINE_LIST);
        stringList.add(FormConstants.HOUSE_HOLD_LINE_LIST_NEW);
        stringList.add(FormConstants.FAMILY_FOLDER_MEMBER_UPDATE);
        stringList.add(FormConstants.CAM_FHS);
        stringList.add(FormConstants.CAM_FHS_MEMBER_UPDATE);
        return stringList;
    }

    private static List<String> getRchSheets() {
        stringList = new ArrayList<>();
        stringList.add(FormConstants.LMP_FOLLOW_UP);
        stringList.add(FormConstants.CAM_ANC);
        stringList.add(FormConstants.CAM_WPD);
        stringList.add(FormConstants.CAM_RIM);
        stringList.add(FormConstants.TECHO_FHW_ANC);
        stringList.add(FormConstants.TECHO_FHW_WPD);
        stringList.add(FormConstants.TECHO_FHW_PNC);
        stringList.add(FormConstants.TECHO_FHW_CI);
        stringList.add(FormConstants.TECHO_FHW_CS);
        stringList.add(FormConstants.TECHO_FHW_RIM);
        stringList.add(FormConstants.TECHO_FHW_VAE);
        stringList.add(FormConstants.TECHO_WPD_DISCHARGE);
        stringList.add(FormConstants.TECHO_CS_APPETITE_TEST);
        stringList.add(FormConstants.ASHA_PNC);
        stringList.add(FormConstants.ASHA_ANC);
        stringList.add(FormConstants.ASHA_WPD);
        stringList.add(FormConstants.ASHA_CS);
        stringList.add(FormConstants.ASHA_LMPFU);
        stringList.add(FormConstants.TT2_ALERT);
        stringList.add(FormConstants.IRON_SUCROSE_ALERT);
        stringList.add(FormConstants.SAM_SCREENING);
        stringList.add(FormConstants.ANC_MORBIDITY);
        stringList.add(FormConstants.PNC_MORBIDITY);
        stringList.add(FormConstants.CHILD_CARE_MORBIDITY);
        stringList.add(FormConstants.TECHO_AWW_CS);
        stringList.add(FormConstants.TECHO_AWW_THR);
        stringList.add(FormConstants.ASHA_SAM_SCREENING);
        stringList.add(FormConstants.FHW_SAM_SCREENING_REF);
        stringList.add(FormConstants.CMAM_FOLLOWUP);
        stringList.add(FormConstants.GERIATRICS_MEDICATION_ALERT);
        stringList.add(FormConstants.IDSP_MEMBER);
        stringList.add(FormConstants.IDSP_MEMBER_2);
        stringList.add(FormConstants.IDSP_NEW_FAMILY);
        stringList.add(FormConstants.ADOLESCENT_HEALTH_SCREENING);
        stringList.add(FormConstants.HIV_POSITIVE);
        stringList.add(FormConstants.HIV_SCREENING);
        stringList.add(FormConstants.KNOWN_POSITIVE);
        stringList.add(FormConstants.HIV_SCREENING_FU);
        stringList.add(FormConstants.DNHDD_FHW_SAM_SCREENING);
        stringList.add(FormConstants.DNHDD_CMAM_FOLLOWUP);
        stringList.add(FormConstants.CHIP_ACTIVE_MALARIA);
        stringList.add(FormConstants.CHIP_ACTIVE_MALARIA_FOLLOW_UP);
        stringList.add(FormConstants.CHIP_PASSIVE_MALARIA);
        stringList.add(FormConstants.CHIP_TB);
        stringList.add(FormConstants.CHIP_TB_FOLLOW_UP);
        stringList.add(FormConstants.CHIP_COVID_SCREENING);
        stringList.add(FormConstants.CHIP_FP_FOLLOW_UP);
        stringList.add(FormConstants.MALARIA_NON_INDEX);
        stringList.add(FormConstants.MALARIA_INDEX);
        stringList.add(FormConstants.STOCK_MANAGEMENT);
        stringList.add(FormConstants.EMTCT);
        stringList.add(FormConstants.CHIP_INDEX_INVESTIGATION);
        return stringList;
    }

    private static List<String> getNewDataBeanApproachForms() {
        stringList = new ArrayList<>();
        stringList.add(FormConstants.HOUSE_HOLD_LINE_LIST_NEW);
        stringList.add(FormConstants.FHS_MEMBER_UPDATE_NEW);
        stringList.add(FormConstants.CHIP_GBV_SCREENING);
        return stringList;
    }

    private static List<String> getAwwSheets() {
        stringList = new ArrayList<>();
        stringList.add(FormConstants.TECHO_AWW_CS);
        stringList.add(FormConstants.TECHO_AWW_THR);
        return stringList;
    }

    private static List<String> getKioskSheets() {
        stringList = new ArrayList<>();
        stringList.add(FormConstants.CHARDHAM_MEMBER_SCREENING);
        return stringList;
    }

    private static List<String> getMorbiditySheets() {
        stringList = new ArrayList<>();
        stringList.add(FormConstants.ANC_MORBIDITY);
        stringList.add(FormConstants.PNC_MORBIDITY);
        stringList.add(FormConstants.CHILD_CARE_MORBIDITY);
        return stringList;
    }

    private static List<String> getNcdSheets() {
        stringList = new ArrayList<>();
        stringList.add(FormConstants.NCD_ASHA_CBAC);
        stringList.add(FormConstants.NCD_FHW_HYPERTENSION);
        stringList.add(FormConstants.NCD_FHW_DIABETES);
        stringList.add(FormConstants.NCD_FHW_ORAL);
        stringList.add(FormConstants.NCD_FHW_BREAST);
        stringList.add(FormConstants.NCD_FHW_CERVICAL);
        stringList.add(FormConstants.NCD_FHW_MENTAL_HEALTH);
        stringList.add(FormConstants.NCD_FHW_HEALTH_SCREENING);
        stringList.add(FormConstants.NCD_PERSONAL_HISTORY);
        stringList.add(FormConstants.NCD_FHW_DIABETES_CONFIRMATION);
        stringList.add(FormConstants.NCD_FHW_WEEKLY_HOME);
        stringList.add(FormConstants.NCD_FHW_WEEKLY_CLINIC);
        stringList.add(FormConstants.NCD_MO_CONFIRMED);
        stringList.add(FormConstants.NCD_URINE_TEST);
        stringList.add(FormConstants.DNHDD_NCD_CBAC_AND_NUTRITION);
        stringList.add(FormConstants.DNHDD_NCD_HYPERTENSION_DIABETES_AND_MENTAL_HEALTH);
        stringList.add(FormConstants.CANCER_SCREENING);
        stringList.add(FormConstants.ANEMIA_SURVEY);
        stringList.add(FormConstants.ANEMIA_PROTOCOL_DEVIATION);
        stringList.add(FormConstants.ANEMIA_CRF);
        stringList.add(FormConstants.NCD_CVC_CLINIC);
        stringList.add(FormConstants.NCD_CVC_HOME);
        stringList.add(FormConstants.NCD_RETINOPATHY_TEST);
        return stringList;
    }

    private static List<String> getNpcbSheets() {
        stringList = new ArrayList<>();
        stringList.add(FormConstants.ASHA_NPCB);
        return stringList;
    }
}
