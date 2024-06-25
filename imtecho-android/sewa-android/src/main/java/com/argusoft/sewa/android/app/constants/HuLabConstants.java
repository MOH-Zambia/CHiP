package com.argusoft.sewa.android.app.constants;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class HuLabConstants {

    private HuLabConstants() {
        throw new IllegalStateException("Utility Class");
    }

    private static Map<String, String> labValueWithUnits;
    private static Map<String, String> getLabLabel;
    private static List<String> labConstantList;
    private static String HAEMOGLOBIN = "Haemoglobin";
    private static String RBC_COUNT = "RBC Count";
    private static String PLATELET_COUNT = "Platelet Count";
    private static String HCT = "HCT";
    private static String MCV = "MCV";
    private static String MCH = "MCH";
    private static String MCHC = "MCHC";
    private static String RDW_CV = "RDW-CV";
    private static String TOTAL_WBC_COUNT = "Total WBC Count";
    private static String NEUTROPHILS = "Neutrophils";
    private static String LYMPHOCYTES = "Lymphocytes";
    private static String EOSINOPHILS = "Eosinophils";
    private static String MONOCYTES = "Monocytes";
    private static String BASOPHILS = "Basophils";
    private static String NORMOBLASTS = "Normoblasts";
    private static String ABSOLUTE_NEUTROPHILS_COUNT = "Absolute Neutrophils Count";
    private static String ABSOLUTE_NORMOBLASTS_COUNT = "Absolute Normoblasts Count";
    private static String CORRECTED_WBC_COUNT = "Corrected WBC Count";
    private static String ICT = "ICT(INDIRECT COOMBS TEST)";
    private static String UNDILUTED = "Undiluted";
    private static String DIRECT_COOMBS_TEST = "DIRECT COOMBS TEST (DCT)";
    private static String DCT = "DCT";
    private static String HPLC_FOR_HAEMOGLOBINOPATHY = "HPLC FOR HAEMOGLOBINOPATHY";
    private static String HB_F = "Hb F";
    private static String HBA = "Hb Adult(A0)";
    private static String HBA2 = "Hb A2";
    private static String HBS = "S-Window";
    public static String PERIPHERAL_SMEAR = "PS(PERIPHERAL SMEAR)";
    private static String RBC_MORPHOLOGY = "RBC Morphology";
    private static String WBC_MORPHOLOGY = "WBC Morphology";
    private static String PLATELETS = "Platelets";
    private static String PARASITES = "Parasites";
    private static String CONCLUSION = "Conclusion";
    private static String RETIC_COUNT = "RETIC COUNT/RETIC-HE";
    private static String RETICULOCYTE_COUNT = "Reticulocyte Count";
    private static String RETIC_HE = "Retic-He";
    private static String BILIRUBIN = "BILIRUBIN";
    private static String TOTAL_BILIRUBIN = "Total Bilirubin";
    private static String DIRECT_BILIRUBIN = "Direct Bilirubin";
    private static String INDIRECT_BILIRUBIN = "Indirect Bilirubin";
    private static String CREATININE = "CREATININE";
    private static String S_CREATININE = "S. Creatinine";
    private static String SGPT = "SGPT";


    public static String getLabConstantUnit(String constant) {
        if (constant == null)
            return null;

        if (labValueWithUnits == null) {
            labValueWithUnits = new HashMap<>();
            labValueWithUnits.put(HAEMOGLOBIN, " gm%");
            labValueWithUnits.put(TOTAL_WBC_COUNT, " /cmm");
            labValueWithUnits.put(NEUTROPHILS, " %");
            labValueWithUnits.put(PLATELET_COUNT, " /cmm");
            labValueWithUnits.put(RETICULOCYTE_COUNT, " %");
            labValueWithUnits.put(RETIC_HE, " %");
            labValueWithUnits.put(HB_F, " %");
            labValueWithUnits.put(HBA, " %");
            labValueWithUnits.put(HBA2, " %");
            labValueWithUnits.put(S_CREATININE, " mg/dl");
            labValueWithUnits.put(SGPT, " U/I");
            labValueWithUnits.put(TOTAL_BILIRUBIN, " mg/dl");
            labValueWithUnits.put(DIRECT_BILIRUBIN, " mg/dl");
        }

        if (labValueWithUnits.containsKey(constant.trim())) {
            return labValueWithUnits.get(constant.trim());
        }
        return "";
    }

    public static String getLabelByConstant(String constant) {
        if (constant == null)
            return null;

        if (getLabLabel == null) {
            getLabLabel = new HashMap<>();
            getLabLabel.put(TOTAL_WBC_COUNT, LabelConstants.TOTAL_WBC_COUNT);
            getLabLabel.put(UNDILUTED, LabelConstants.UNDILUTED);
            getLabLabel.put(DCT, LabelConstants.DCT);
            getLabLabel.put(HB_F, LabelConstants.HB_F);
            getLabLabel.put(HBA, LabelConstants.HBA);
            getLabLabel.put(HBA2, LabelConstants.HBA2);
            getLabLabel.put(HBS, LabelConstants.HBS);
            getLabLabel.put(PERIPHERAL_SMEAR, LabelConstants.PERIPHERAL_SMEAR);
            getLabLabel.put(S_CREATININE, LabelConstants.S_CREATININE);

        }

        if (getLabLabel.containsKey(constant.trim())) {
            return getLabLabel.get(constant.trim());
        }
        return constant;
    }

    public static List<String> getLabConstants() {
        labConstantList = new ArrayList<>();
        labConstantList.add(HAEMOGLOBIN);
        labConstantList.add(TOTAL_WBC_COUNT);
        labConstantList.add(PLATELET_COUNT);
        labConstantList.add(NEUTROPHILS);
        labConstantList.add(RETICULOCYTE_COUNT);
        labConstantList.add(RETIC_HE);
        labConstantList.add(HBS);
        labConstantList.add(HB_F);
        labConstantList.add(HBA);
        labConstantList.add(HBA2);
        labConstantList.add(DCT);
        labConstantList.add(ICT);
        labConstantList.add(S_CREATININE);
        labConstantList.add(SGPT);
        labConstantList.add(TOTAL_BILIRUBIN);
        labConstantList.add(DIRECT_BILIRUBIN);
        return labConstantList;
    }
}
