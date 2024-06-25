package com.argusoft.sewa.android.app.core.impl;

import com.argusoft.sewa.android.app.constants.FullFormConstants;
import com.argusoft.sewa.android.app.constants.LabelConstants;
import com.argusoft.sewa.android.app.constants.RchConstants;
import com.argusoft.sewa.android.app.core.ImmunisationService;
import com.argusoft.sewa.android.app.datastructure.QueFormBean;
import com.argusoft.sewa.android.app.util.UtilBean;

import org.androidannotations.annotations.EBean;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

@EBean(scope = EBean.Scope.Singleton)
public class ImmunisationServiceImpl implements ImmunisationService {

    @Override
    public Set<String> getDueImmunisationsForChild(Date dateOfBirth, String givenImmunisations, Date currentDate, Map<String, Date> immunisationDateMap, boolean isRemovePreviousDoses) {
        Set<String> vaccinationSet = new LinkedHashSet<>();

        if ((immunisationDateMap == null || immunisationDateMap.isEmpty())) {
            immunisationDateMap = UtilBean.getImmunisationDateMap(givenImmunisations);
        }

        int ageInDays = UtilBean.getNumberOfDays(dateOfBirth, currentDate);
        int ageInWeeks = UtilBean.getNumberOfWeeks(dateOfBirth, currentDate);
        int ageInMonths = UtilBean.getNumberOfMonths(dateOfBirth, currentDate);
        Calendar date1stJan = Calendar.getInstance();
        UtilBean.clearTimeFromDate(date1stJan);
        date1stJan.set(Calendar.DAY_OF_MONTH, 1);
        date1stJan.set(Calendar.MONTH, Calendar.JANUARY);
        date1stJan.set(Calendar.YEAR, 2023);
        int ageInYears = UtilBean.getNumberOfYears(dateOfBirth, currentDate);

        //Adding Birth Vaccines

        if (ageInDays <= 1) {
            vaccinationSet.add(RchConstants.HEPATITIS_B_0);
            vaccinationSet.add(RchConstants.VITAMIN_K);
        }
        if (ageInDays <= 15) {
            vaccinationSet.add(RchConstants.OPV_0);
        }
        if (ageInYears <= 1) {
            vaccinationSet.add(RchConstants.BCG);
        }

        if (ageInWeeks >= 6) {
            vaccinationSet.add(RchConstants.OPV_1);
            vaccinationSet.add(RchConstants.PENTA_1);
            vaccinationSet.add(RchConstants.ROTA_VIRUS_1);
            vaccinationSet.add(RchConstants.F_IPV_1_01);
        }
        if (ageInWeeks >= 10) {
            vaccinationSet.add(RchConstants.OPV_2);
            vaccinationSet.add(RchConstants.PENTA_2);
            vaccinationSet.add(RchConstants.ROTA_VIRUS_2);
        }
        if (ageInWeeks >= 14) {
            vaccinationSet.add(RchConstants.OPV_3);
            vaccinationSet.add(RchConstants.PENTA_3);
            vaccinationSet.add(RchConstants.ROTA_VIRUS_3);
            vaccinationSet.add(RchConstants.F_IPV_2_01);
        }
        if (ageInMonths >= 9) {
            vaccinationSet.add(RchConstants.MEASLES_RUBELLA_1);
        }
        if (ageInMonths >= 12) {
            vaccinationSet.add(RchConstants.DPT_1);
        }
        if (ageInMonths >= 13) {
            vaccinationSet.add(RchConstants.DPT_2);
        }
        if (ageInMonths >= 14) {
            vaccinationSet.add(RchConstants.DPT_3);
        }
        if (ageInMonths >= 16) {
            vaccinationSet.add(RchConstants.MEASLES_RUBELLA_2);
            vaccinationSet.add(RchConstants.OPV_BOOSTER);
            vaccinationSet.add(RchConstants.DPT_BOOSTER);
        }

        boolean anyPentaDoseGiven = !immunisationDateMap.isEmpty() &&
                (immunisationDateMap.containsKey(RchConstants.PENTA_1) ||
                        immunisationDateMap.containsKey(RchConstants.PENTA_2) ||
                        immunisationDateMap.containsKey(RchConstants.PENTA_3));

        if (anyPentaDoseGiven) {
            vaccinationSet.remove(RchConstants.DPT_1);
            vaccinationSet.remove(RchConstants.DPT_2);
            vaccinationSet.remove(RchConstants.DPT_3);
        }

        boolean anyDptDoseGiven = !immunisationDateMap.isEmpty() &&
                (immunisationDateMap.containsKey(RchConstants.DPT_1) ||
                        immunisationDateMap.containsKey(RchConstants.DPT_2) ||
                        immunisationDateMap.containsKey(RchConstants.DPT_3));

        if (anyDptDoseGiven) {
            vaccinationSet.remove(RchConstants.PENTA_1);
            vaccinationSet.remove(RchConstants.PENTA_2);
            vaccinationSet.remove(RchConstants.PENTA_3);
        }

        //Removing already given vaccines
        for (Map.Entry<String, Date> entry : immunisationDateMap.entrySet()) {
            vaccinationSet.remove(entry.getKey());
        }

        //Removing previous doses of OPV
        if (immunisationDateMap.containsKey(RchConstants.OPV_BOOSTER)) {
            vaccinationSet.remove(RchConstants.OPV_0);
            vaccinationSet.remove(RchConstants.OPV_1);
            vaccinationSet.remove(RchConstants.OPV_2);
            vaccinationSet.remove(RchConstants.OPV_3);
        } else if (immunisationDateMap.containsKey(RchConstants.OPV_3)) {
            vaccinationSet.remove(RchConstants.OPV_0);
            vaccinationSet.remove(RchConstants.OPV_1);
            vaccinationSet.remove(RchConstants.OPV_2);
        } else if (immunisationDateMap.containsKey(RchConstants.OPV_2)) {
            vaccinationSet.remove(RchConstants.OPV_0);
            vaccinationSet.remove(RchConstants.OPV_1);
        } else if (immunisationDateMap.containsKey(RchConstants.OPV_1)) {
            vaccinationSet.remove(RchConstants.OPV_0);
        }


        //Removing previous doses of ROTA Virus
        if (immunisationDateMap.containsKey(RchConstants.ROTA_VIRUS_3)) {
            vaccinationSet.remove(RchConstants.ROTA_VIRUS_1);
            vaccinationSet.remove(RchConstants.ROTA_VIRUS_2);
        } else if (immunisationDateMap.containsKey(RchConstants.ROTA_VIRUS_2)) {
            vaccinationSet.remove(RchConstants.ROTA_VIRUS_1);
        }

        //Removing previous doses of Penta
        if (immunisationDateMap.containsKey(RchConstants.PENTA_3)) {
            vaccinationSet.remove(RchConstants.PENTA_1);
            vaccinationSet.remove(RchConstants.PENTA_2);
        } else if (immunisationDateMap.containsKey(RchConstants.PENTA_2)) {
            vaccinationSet.remove(RchConstants.PENTA_1);
        }

        //Removing previous doses of DPT
        if (immunisationDateMap.containsKey(RchConstants.DPT_3)) {
            vaccinationSet.remove(RchConstants.DPT_1);
            vaccinationSet.remove(RchConstants.DPT_2);
        } else if (immunisationDateMap.containsKey(RchConstants.DPT_2)) {
            vaccinationSet.remove(RchConstants.DPT_1);
        }


        //Removing previous doses of Measles Rubella
        if (immunisationDateMap.containsKey(RchConstants.MEASLES_RUBELLA_2)) {
            vaccinationSet.remove(RchConstants.MEASLES_RUBELLA_1);
        }

        if (!vaccinationSet.isEmpty()) {
            List<String> vaccines = new ArrayList<>(vaccinationSet);
            Collections.sort(vaccines, UtilBean.VACCINATION_COMPARATOR);
            return new LinkedHashSet<>(vaccines);
        } else {
            return new LinkedHashSet<>();
        }
    }
    @Override
    public Set<String> getDueImmunisationsForChildDnhdd(Date dateOfBirth, String givenImmunisations, Date currentDate, Map<String, Date> immunisationDateMap, boolean isRemovePreviousDoses) {
        Set<String> vaccinationSet = new LinkedHashSet<>();

        if ((immunisationDateMap == null || immunisationDateMap.isEmpty())) {
            immunisationDateMap = UtilBean.getImmunisationDateMap(givenImmunisations);
        }

        int ageInDays = UtilBean.getNumberOfDays(dateOfBirth, currentDate);
        int ageInWeeks = UtilBean.getNumberOfWeeks(dateOfBirth, currentDate);
        int ageInMonths = UtilBean.getNumberOfMonths(dateOfBirth, currentDate);
        Calendar date1stJan = Calendar.getInstance();
        UtilBean.clearTimeFromDate(date1stJan);
        date1stJan.set(Calendar.DAY_OF_MONTH, 1);
        date1stJan.set(Calendar.MONTH, Calendar.JANUARY);
        date1stJan.set(Calendar.YEAR, 2023);
        int ageInYears = UtilBean.getNumberOfYears(dateOfBirth, currentDate);

        //Adding Birth Vaccines

        if (ageInDays <= 1) {
            vaccinationSet.add(RchConstants.HEPATITIS_B_0);
            vaccinationSet.add(RchConstants.VITAMIN_K);
        }
        if (ageInDays <= 15) {
            vaccinationSet.add(RchConstants.OPV_0);
        }
        if (ageInYears <= 1) {
            vaccinationSet.add(RchConstants.BCG);
        }

        if (ageInWeeks >= 6) {
            vaccinationSet.add(RchConstants.OPV_1);
            vaccinationSet.add(RchConstants.PENTA_1);
            vaccinationSet.add(RchConstants.ROTA_VIRUS_1);
            vaccinationSet.add(RchConstants.F_IPV_1_01);
            vaccinationSet.add(RchConstants.Z_PCV_1);
        }
        if (ageInWeeks >= 10) {
            vaccinationSet.add(RchConstants.OPV_2);
            vaccinationSet.add(RchConstants.PENTA_2);
            vaccinationSet.add(RchConstants.ROTA_VIRUS_2);
        }
        if (ageInWeeks >= 14) {
            vaccinationSet.add(RchConstants.OPV_3);
            vaccinationSet.add(RchConstants.PENTA_3);
            vaccinationSet.add(RchConstants.ROTA_VIRUS_3);
            vaccinationSet.add(RchConstants.F_IPV_2_01);
            vaccinationSet.add(RchConstants.Z_PCV_2);
        }
        if (ageInMonths >= 9) {
            vaccinationSet.add(RchConstants.MEASLES_RUBELLA_1);
            vaccinationSet.add(RchConstants.PCV_BOOSTER);
        }
        if (ageInMonths >= 12) {
            vaccinationSet.add(RchConstants.DPT_1);
        }
        if (ageInMonths >= 13) {
            vaccinationSet.add(RchConstants.DPT_2);
        }
        if (ageInMonths >= 14) {
            vaccinationSet.add(RchConstants.DPT_3);
        }
        if (ageInMonths >= 16) {
            vaccinationSet.add(RchConstants.MEASLES_RUBELLA_2);
            vaccinationSet.add(RchConstants.OPV_BOOSTER);
            vaccinationSet.add(RchConstants.DPT_BOOSTER);
        }

        boolean anyPentaDoseGiven = !immunisationDateMap.isEmpty() &&
                (immunisationDateMap.containsKey(RchConstants.PENTA_1) ||
                        immunisationDateMap.containsKey(RchConstants.PENTA_2) ||
                        immunisationDateMap.containsKey(RchConstants.PENTA_3));

        if (anyPentaDoseGiven) {
            vaccinationSet.remove(RchConstants.DPT_1);
            vaccinationSet.remove(RchConstants.DPT_2);
            vaccinationSet.remove(RchConstants.DPT_3);
        }

        boolean anyDptDoseGiven = !immunisationDateMap.isEmpty() &&
                (immunisationDateMap.containsKey(RchConstants.DPT_1) ||
                        immunisationDateMap.containsKey(RchConstants.DPT_2) ||
                        immunisationDateMap.containsKey(RchConstants.DPT_3));

        if (anyDptDoseGiven) {
            vaccinationSet.remove(RchConstants.PENTA_1);
            vaccinationSet.remove(RchConstants.PENTA_2);
            vaccinationSet.remove(RchConstants.PENTA_3);
        }

        //Removing already given vaccines
        for (Map.Entry<String, Date> entry : immunisationDateMap.entrySet()) {
            vaccinationSet.remove(entry.getKey());
        }

        //Removing previous doses of OPV
        if (immunisationDateMap.containsKey(RchConstants.OPV_BOOSTER)) {
            vaccinationSet.remove(RchConstants.OPV_0);
            vaccinationSet.remove(RchConstants.OPV_1);
            vaccinationSet.remove(RchConstants.OPV_2);
            vaccinationSet.remove(RchConstants.OPV_3);
        } else if (immunisationDateMap.containsKey(RchConstants.OPV_3)) {
            vaccinationSet.remove(RchConstants.OPV_0);
            vaccinationSet.remove(RchConstants.OPV_1);
            vaccinationSet.remove(RchConstants.OPV_2);
        } else if (immunisationDateMap.containsKey(RchConstants.OPV_2)) {
            vaccinationSet.remove(RchConstants.OPV_0);
            vaccinationSet.remove(RchConstants.OPV_1);
        } else if (immunisationDateMap.containsKey(RchConstants.OPV_1)) {
            vaccinationSet.remove(RchConstants.OPV_0);
        }


        //Removing previous doses of ROTA Virus
        if (immunisationDateMap.containsKey(RchConstants.ROTA_VIRUS_3)) {
            vaccinationSet.remove(RchConstants.ROTA_VIRUS_1);
            vaccinationSet.remove(RchConstants.ROTA_VIRUS_2);
        } else if (immunisationDateMap.containsKey(RchConstants.ROTA_VIRUS_2)) {
            vaccinationSet.remove(RchConstants.ROTA_VIRUS_1);
        }

        //Removing previous doses of Penta
        if (immunisationDateMap.containsKey(RchConstants.PENTA_3)) {
            vaccinationSet.remove(RchConstants.PENTA_1);
            vaccinationSet.remove(RchConstants.PENTA_2);
        } else if (immunisationDateMap.containsKey(RchConstants.PENTA_2)) {
            vaccinationSet.remove(RchConstants.PENTA_1);
        }

        //Removing previous doses of DPT
        if (immunisationDateMap.containsKey(RchConstants.DPT_3)) {
            vaccinationSet.remove(RchConstants.DPT_1);
            vaccinationSet.remove(RchConstants.DPT_2);
        } else if (immunisationDateMap.containsKey(RchConstants.DPT_2)) {
            vaccinationSet.remove(RchConstants.DPT_1);
        }


        //Removing previous doses of Measles Rubella
        if (immunisationDateMap.containsKey(RchConstants.MEASLES_RUBELLA_2)) {
            vaccinationSet.remove(RchConstants.MEASLES_RUBELLA_1);
        }

        // Removing previous doses of PCV
        if (immunisationDateMap.containsKey(RchConstants.PCV_BOOSTER)) {
            vaccinationSet.remove(RchConstants.Z_PCV_1);
            vaccinationSet.remove(RchConstants.Z_PCV_2);
        } else if (immunisationDateMap.containsKey(RchConstants.Z_PCV_2)) {
            vaccinationSet.remove(RchConstants.Z_PCV_1);
        }

        if (!vaccinationSet.isEmpty()) {
            List<String> vaccines = new ArrayList<>(vaccinationSet);
            Collections.sort(vaccines, UtilBean.VACCINATION_COMPARATOR);
            return new LinkedHashSet<>(vaccines);
        } else {
            return new LinkedHashSet<>();
        }
    }

    @Override
    public Set<String> getDueImmunisationsForChildZambia(Date dateOfBirth, String givenImmunisations, Date currentDate, Map<String, Date> immunisationDateMap, boolean isRemovePreviousDoses) {
        Set<String> vaccinationSet = new LinkedHashSet<>();

        if ((immunisationDateMap == null || immunisationDateMap.isEmpty())) {
            immunisationDateMap = UtilBean.getImmunisationDateMap(givenImmunisations);
        }

        int ageInDays = UtilBean.getNumberOfDays(dateOfBirth, currentDate);
        int ageInWeeks = UtilBean.getNumberOfWeeks(dateOfBirth, currentDate);
        int ageInMonths = UtilBean.getNumberOfMonths(dateOfBirth, currentDate);
        Calendar date1stJan = Calendar.getInstance();
        UtilBean.clearTimeFromDate(date1stJan);
        date1stJan.set(Calendar.DAY_OF_MONTH, 1);
        date1stJan.set(Calendar.MONTH, Calendar.JANUARY);
        date1stJan.set(Calendar.YEAR, 2023);
        int ageInYears = UtilBean.getNumberOfYears(dateOfBirth, currentDate);


        vaccinationSet.add(RchConstants.Z_OPV_0);
        vaccinationSet.add(RchConstants.Z_BCG);
        vaccinationSet.add(RchConstants.Z_VITTAMIN_A_50000);
        vaccinationSet.add(RchConstants.Z_VITTAMIN_A_100000);
//        if (ageInMonths <= 5) {
//            vaccinationSet.add(RchConstants.Z_VITTAMIN_A_50000);
//        }
//        if (ageInMonths >= 6 && ageInMonths <= 11) {
//            vaccinationSet.add(RchConstants.Z_VITTAMIN_A_100000);
//        }
        if (ageInMonths >= 12 && ageInMonths <= 59) {
            vaccinationSet.add(RchConstants.Z_VITTAMIN_A_200000_1);
            vaccinationSet.add(RchConstants.Z_VITTAMIN_A_200000_2);
            vaccinationSet.add(RchConstants.Z_VITTAMIN_A_200000_3);
            vaccinationSet.add(RchConstants.Z_VITTAMIN_A_200000_4);
            vaccinationSet.add(RchConstants.Z_VITTAMIN_A_200000_5);
            vaccinationSet.add(RchConstants.Z_VITTAMIN_A_200000_6);
            vaccinationSet.add(RchConstants.Z_VITTAMIN_A_200000_7);
            vaccinationSet.add(RchConstants.Z_VITTAMIN_A_200000_8);
        }
        if (ageInWeeks >= 6) {
            vaccinationSet.add(RchConstants.Z_OPV_1);
            vaccinationSet.add(RchConstants.Z_PCV_1);
            vaccinationSet.add(RchConstants.Z_ROTA_VACCINE_1);
            vaccinationSet.add(RchConstants.Z_DPT_HEB_HIB_1);
        }
        if (ageInWeeks >= 10) {
            vaccinationSet.add(RchConstants.Z_OPV_2);
            vaccinationSet.add(RchConstants.Z_PCV_2);
            vaccinationSet.add(RchConstants.Z_ROTA_VACCINE_2);
            vaccinationSet.add(RchConstants.Z_DPT_HEB_HIB_2);
        }
        if (ageInWeeks >= 14) {
            vaccinationSet.add(RchConstants.Z_OPV_3);
            vaccinationSet.add(RchConstants.Z_PCV_3);
            vaccinationSet.add(RchConstants.Z_DPT_HEB_HIB_3);
        }
        if (ageInMonths >= 9) {
            vaccinationSet.add(RchConstants.Z_MEASLES_RUBELLA_1);
            if (!immunisationDateMap.isEmpty()
                    && (!immunisationDateMap.containsKey(RchConstants.Z_OPV_0))) {
                vaccinationSet.add(RchConstants.Z_OPV_4);
            }
        }
        if (ageInMonths >= 18) {
            vaccinationSet.add(RchConstants.Z_MEASLES_RUBELLA_2);
        }

        //Removing already given vaccines
        for (Map.Entry<String, Date> entry : immunisationDateMap.entrySet()) {
            vaccinationSet.remove(entry.getKey());
        }

        //Removing previous doses of OPV
        if (immunisationDateMap.containsKey(RchConstants.Z_OPV_4)) {
            vaccinationSet.remove(RchConstants.Z_OPV_0);
            vaccinationSet.remove(RchConstants.Z_OPV_1);
            vaccinationSet.remove(RchConstants.Z_OPV_2);
            vaccinationSet.remove(RchConstants.Z_OPV_3);
        } else if (immunisationDateMap.containsKey(RchConstants.Z_OPV_3)) {
            vaccinationSet.remove(RchConstants.Z_OPV_0);
            vaccinationSet.remove(RchConstants.Z_OPV_1);
            vaccinationSet.remove(RchConstants.Z_OPV_2);
        } else if (immunisationDateMap.containsKey(RchConstants.Z_OPV_2)) {
            vaccinationSet.remove(RchConstants.Z_OPV_0);
            vaccinationSet.remove(RchConstants.Z_OPV_1);
        } else if (immunisationDateMap.containsKey(RchConstants.Z_OPV_1)) {
            vaccinationSet.remove(RchConstants.Z_OPV_0);
        }


        if (immunisationDateMap.containsKey(RchConstants.Z_VITTAMIN_A_200000_8)) {
            vaccinationSet.remove(RchConstants.Z_VITTAMIN_A_200000_1);
            vaccinationSet.remove(RchConstants.Z_VITTAMIN_A_200000_2);
            vaccinationSet.remove(RchConstants.Z_VITTAMIN_A_200000_3);
            vaccinationSet.remove(RchConstants.Z_VITTAMIN_A_200000_4);
            vaccinationSet.remove(RchConstants.Z_VITTAMIN_A_200000_5);
            vaccinationSet.remove(RchConstants.Z_VITTAMIN_A_200000_6);
            vaccinationSet.remove(RchConstants.Z_VITTAMIN_A_200000_7);
        } else if (immunisationDateMap.containsKey(RchConstants.Z_VITTAMIN_A_200000_7)) {
            vaccinationSet.remove(RchConstants.Z_VITTAMIN_A_200000_1);
            vaccinationSet.remove(RchConstants.Z_VITTAMIN_A_200000_2);
            vaccinationSet.remove(RchConstants.Z_VITTAMIN_A_200000_3);
            vaccinationSet.remove(RchConstants.Z_VITTAMIN_A_200000_4);
            vaccinationSet.remove(RchConstants.Z_VITTAMIN_A_200000_5);
            vaccinationSet.remove(RchConstants.Z_VITTAMIN_A_200000_6);
        } else if (immunisationDateMap.containsKey(RchConstants.Z_VITTAMIN_A_200000_6)) {
            vaccinationSet.remove(RchConstants.Z_VITTAMIN_A_200000_1);
            vaccinationSet.remove(RchConstants.Z_VITTAMIN_A_200000_2);
            vaccinationSet.remove(RchConstants.Z_VITTAMIN_A_200000_3);
            vaccinationSet.remove(RchConstants.Z_VITTAMIN_A_200000_4);
            vaccinationSet.remove(RchConstants.Z_VITTAMIN_A_200000_5);
        } else if (immunisationDateMap.containsKey(RchConstants.Z_VITTAMIN_A_200000_5)) {
            vaccinationSet.remove(RchConstants.Z_VITTAMIN_A_200000_1);
            vaccinationSet.remove(RchConstants.Z_VITTAMIN_A_200000_2);
            vaccinationSet.remove(RchConstants.Z_VITTAMIN_A_200000_3);
            vaccinationSet.remove(RchConstants.Z_VITTAMIN_A_200000_4);
        } else if (immunisationDateMap.containsKey(RchConstants.Z_VITTAMIN_A_200000_4)) {
            vaccinationSet.remove(RchConstants.Z_VITTAMIN_A_200000_1);
            vaccinationSet.remove(RchConstants.Z_VITTAMIN_A_200000_2);
            vaccinationSet.remove(RchConstants.Z_VITTAMIN_A_200000_3);
        } else if (immunisationDateMap.containsKey(RchConstants.Z_VITTAMIN_A_200000_3)) {
            vaccinationSet.remove(RchConstants.Z_VITTAMIN_A_200000_1);
            vaccinationSet.remove(RchConstants.Z_VITTAMIN_A_200000_2);
        } else if (immunisationDateMap.containsKey(RchConstants.Z_VITTAMIN_A_200000_2)) {
            vaccinationSet.remove(RchConstants.Z_VITTAMIN_A_200000_1);
        }


        //Removing previous doses of ROTA Virus
        if (immunisationDateMap.containsKey(RchConstants.Z_ROTA_VACCINE_2)) {
            vaccinationSet.remove(RchConstants.Z_ROTA_VACCINE_1);
        }

        //Removing previous doses of PCV
        if (immunisationDateMap.containsKey(RchConstants.Z_PCV_3)) {
            vaccinationSet.remove(RchConstants.Z_PCV_1);
            vaccinationSet.remove(RchConstants.Z_PCV_2);
        } else if (immunisationDateMap.containsKey(RchConstants.Z_PCV_2)) {
            vaccinationSet.remove(RchConstants.Z_PCV_1);
        }

        //Removing previous doses of DPT
        if (immunisationDateMap.containsKey(RchConstants.Z_DPT_HEB_HIB_3)) {
            vaccinationSet.remove(RchConstants.Z_DPT_HEB_HIB_1);
            vaccinationSet.remove(RchConstants.Z_DPT_HEB_HIB_2);
        } else if (immunisationDateMap.containsKey(RchConstants.Z_DPT_HEB_HIB_2)) {
            vaccinationSet.remove(RchConstants.Z_DPT_HEB_HIB_1);
        }


        //Removing previous doses of Measles Rubella
        if (immunisationDateMap.containsKey(RchConstants.Z_MEASLES_RUBELLA_2)) {
            vaccinationSet.remove(RchConstants.Z_MEASLES_RUBELLA_1);
        }

        if (!vaccinationSet.isEmpty()) {
            List<String> vaccines = new ArrayList<>(vaccinationSet);
            Collections.sort(vaccines, UtilBean.Z_VACCINATION_COMPARATOR);
            return new LinkedHashSet<>(vaccines);
        } else {
            return new LinkedHashSet<>();
        }
    }

    @Override
    public Map<Boolean, String> isImmunisationMissedOrNotValid(Date dateOfBirth, String immunisation,
                                                               Date currentDate, Map<String, Date> vaccineGivenDateMap, boolean isForNextDueDate) {
        Map<Boolean, String> vaccineMissedMap = new HashMap<>();
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.getDefault());
        boolean isMissed;
        String dateRange;
        Calendar dob = Calendar.getInstance();
        Calendar temp = Calendar.getInstance();
        dateOfBirth = UtilBean.clearTimeFromDate(dateOfBirth);
        currentDate = UtilBean.clearTimeFromDate(currentDate);
        dob.setTime(dateOfBirth);
        temp.setTime(dateOfBirth);
        Date lbw = UtilBean.clearTimeFromDate(new Date());
        Date ubw = UtilBean.clearTimeFromDate(new Date());
        Date tmpDate;

        if (vaccineGivenDateMap == null) {
            vaccineGivenDateMap = new HashMap<>();
        }

        switch (immunisation) {
            case RchConstants.HEPATITIS_B_0:
            case RchConstants.VITAMIN_K:
                lbw = dob.getTime();
                dob.add(Calendar.DATE, 1);
                ubw = dob.getTime();
                break;

            case RchConstants.BCG:
                lbw = dob.getTime();
                dob.add(Calendar.YEAR, 1);
                ubw = dob.getTime();
                break;

            case RchConstants.OPV_0:
                lbw = dob.getTime();
                dob.add(Calendar.DATE, 15);
                ubw = dob.getTime();
                break;

            case RchConstants.OPV_1:
                dob.add(Calendar.DATE, 42);
                lbw = dob.getTime();
                dob.setTime(dateOfBirth);
                dob.add(Calendar.MONTH, 60);
                ubw = dob.getTime();
                break;

            case RchConstants.OPV_2:
                dob.add(Calendar.DATE, 70);
                lbw = dob.getTime();
                tmpDate = vaccineGivenDateMap.get(RchConstants.OPV_1);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 28);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                dob.setTime(dateOfBirth);
                dob.add(Calendar.MONTH, 60);
                ubw = dob.getTime();
                break;

            case RchConstants.OPV_3:
                dob.add(Calendar.DATE, 98);
                lbw = dob.getTime();
                tmpDate = vaccineGivenDateMap.get(RchConstants.OPV_1);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 56);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                tmpDate = vaccineGivenDateMap.get(RchConstants.OPV_2);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 28);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                dob.setTime(dateOfBirth);
                dob.add(Calendar.MONTH, 60);
                ubw = dob.getTime();
                break;

            case RchConstants.ROTA_VIRUS_1:
            case RchConstants.PENTA_1:
            case RchConstants.F_IPV_1_01:
            case RchConstants.Z_PCV_1:
                dob.add(Calendar.DATE, 42);
                lbw = dob.getTime();
                dob.setTime(dateOfBirth);
                dob.add(Calendar.MONTH, 12);
                ubw = dob.getTime();
                break;

            case RchConstants.ROTA_VIRUS_2:
                dob.add(Calendar.DATE, 70);
                lbw = dob.getTime();
                tmpDate = vaccineGivenDateMap.get(RchConstants.ROTA_VIRUS_1);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 28);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                dob.setTime(dateOfBirth);
                dob.add(Calendar.MONTH, 24);
                ubw = dob.getTime();
                break;

            case RchConstants.ROTA_VIRUS_3:
                dob.add(Calendar.DATE, 98);
                lbw = dob.getTime();
                tmpDate = vaccineGivenDateMap.get(RchConstants.ROTA_VIRUS_1);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 56);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                tmpDate = vaccineGivenDateMap.get(RchConstants.ROTA_VIRUS_2);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 28);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                dob.setTime(dateOfBirth);
                dob.add(Calendar.MONTH, 24);
                ubw = dob.getTime();
                break;

            case RchConstants.PENTA_2:
                dob.add(Calendar.DATE, 70);
                lbw = dob.getTime();
                tmpDate = vaccineGivenDateMap.get(RchConstants.PENTA_1);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 28);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                dob.setTime(dateOfBirth);
                dob.add(Calendar.MONTH, 16);
                ubw = dob.getTime();
                break;

            case RchConstants.PENTA_3:
                dob.add(Calendar.DATE, 98);
                lbw = dob.getTime();
                tmpDate = vaccineGivenDateMap.get(RchConstants.PENTA_1);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 56);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                tmpDate = vaccineGivenDateMap.get(RchConstants.PENTA_2);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 28);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                dob.setTime(dateOfBirth);
                dob.add(Calendar.MONTH, 16);
                ubw = dob.getTime();
                break;

            case RchConstants.Z_PCV_2:
                dob.add(Calendar.DATE, 98);
                lbw = dob.getTime();
                tmpDate = vaccineGivenDateMap.get(RchConstants.Z_PCV_1);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 56);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                dob.setTime(dateOfBirth);
                dob.add(Calendar.MONTH, 24);
                ubw = dob.getTime();
                break;

            case RchConstants.PCV_BOOSTER:
                dob.add(Calendar.MONTH, 9);
                lbw = dob.getTime();
                tmpDate = vaccineGivenDateMap.get(RchConstants.Z_PCV_1);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 112);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                tmpDate = vaccineGivenDateMap.get(RchConstants.Z_PCV_2);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 56);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                dob.setTime(dateOfBirth);
                dob.add(Calendar.MONTH, 24);
                ubw = dob.getTime();
                break;

            case RchConstants.DPT_1:
                dob.add(Calendar.MONTH, 12);
                lbw = dob.getTime();
                dob.setTime(dateOfBirth);
                dob.add(Calendar.MONTH, 84);
                ubw = dob.getTime();
                break;

            case RchConstants.DPT_2:
                dob.add(Calendar.MONTH, 12);
                dob.add(Calendar.DATE, 28);
                lbw = dob.getTime();
                tmpDate = vaccineGivenDateMap.get(RchConstants.DPT_1);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 28);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                dob.setTime(dateOfBirth);
                dob.add(Calendar.MONTH, 84);
                ubw = dob.getTime();
                break;

            case RchConstants.DPT_3:
                dob.add(Calendar.MONTH, 12);
                dob.add(Calendar.DATE, 28);
                lbw = dob.getTime();
                tmpDate = vaccineGivenDateMap.get(RchConstants.DPT_1);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 56);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                tmpDate = vaccineGivenDateMap.get(RchConstants.DPT_2);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 28);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                dob.setTime(dateOfBirth);
                dob.add(Calendar.MONTH, 84);
                ubw = dob.getTime();
                break;

            case RchConstants.F_IPV_2_01:
            case RchConstants.F_IPV_2_05:
                dob.add(Calendar.DATE, 98);
                lbw = dob.getTime();
                tmpDate = vaccineGivenDateMap.get(RchConstants.F_IPV_1_01);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 56);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                dob.setTime(dateOfBirth);
                dob.add(Calendar.MONTH, 24);
                ubw = dob.getTime();
                break;
//            case RchConstants.VITAMIN_A:
//                return vaccineMissedMap;
            case RchConstants.MEASLES_RUBELLA_1:
                dob.add(Calendar.MONTH, 9);
                lbw = dob.getTime();
                dob.setTime(dateOfBirth);
                dob.add(Calendar.MONTH, 60);
                ubw = dob.getTime();
                break;


            case RchConstants.MEASLES_RUBELLA_2:
                dob.add(Calendar.MONTH, 16);
                lbw = dob.getTime();
                tmpDate = vaccineGivenDateMap.get(RchConstants.MEASLES_RUBELLA_1);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 28);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                dob.setTime(dateOfBirth);
                dob.add(Calendar.MONTH, 60);
                ubw = dob.getTime();
                break;

            case RchConstants.OPV_BOOSTER:
                dob.add(Calendar.MONTH, 16);
                lbw = dob.getTime();
                tmpDate = vaccineGivenDateMap.get(RchConstants.OPV_0);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 98);
                    temp.add(Calendar.MONTH, 6);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                tmpDate = vaccineGivenDateMap.get(RchConstants.OPV_1);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 56);
                    temp.add(Calendar.MONTH, 6);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                tmpDate = vaccineGivenDateMap.get(RchConstants.OPV_2);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 28);
                    temp.add(Calendar.MONTH, 6);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                tmpDate = vaccineGivenDateMap.get(RchConstants.OPV_3);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.MONTH, 6);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                dob.setTime(dateOfBirth);
                dob.add(Calendar.MONTH, 60);
                ubw = dob.getTime();
                break;

            case RchConstants.DPT_BOOSTER:
                dob.add(Calendar.MONTH, 16);
                lbw = dob.getTime();
                tmpDate = vaccineGivenDateMap.get(RchConstants.DPT_1);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 56);
                    temp.add(Calendar.MONTH, 6);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                tmpDate = vaccineGivenDateMap.get(RchConstants.DPT_2);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 28);
                    temp.add(Calendar.MONTH, 6);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                tmpDate = vaccineGivenDateMap.get(RchConstants.DPT_3);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.MONTH, 6);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                tmpDate = vaccineGivenDateMap.get(RchConstants.PENTA_1);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 56);
                    temp.add(Calendar.MONTH, 6);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                tmpDate = vaccineGivenDateMap.get(RchConstants.PENTA_2);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 28);
                    temp.add(Calendar.MONTH, 6);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                tmpDate = vaccineGivenDateMap.get(RchConstants.PENTA_3);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.MONTH, 6);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                dob.setTime(dateOfBirth);
                dob.add(Calendar.MONTH, 84);
                ubw = dob.getTime();
                break;

            default:
        }

        if (!isForNextDueDate) {
            isMissed = !UtilBean.clearTimeFromDate(lbw).equals(currentDate) && !UtilBean.clearTimeFromDate(lbw).before(currentDate);
        } else {
            isMissed = !UtilBean.clearTimeFromDate(ubw).equals(currentDate) &&
                    (UtilBean.clearTimeFromDate(lbw).equals(currentDate) ?
                            !UtilBean.clearTimeFromDate(ubw).after(currentDate) :
                            (!UtilBean.clearTimeFromDate(lbw).before(currentDate) || !UtilBean.clearTimeFromDate(ubw).after(currentDate)));
        }
        dateRange = sdf.format(lbw) + " - " + sdf.format(ubw);
        vaccineMissedMap.put(isMissed, dateRange);
        return vaccineMissedMap;
    }

    @Override
    public Map<Boolean, String> isImmunisationMissedOrNotValidZambia(Date dateOfBirth, String immunisation,
                                                                     Date currentDate, Map<String, Date> vaccineGivenDateMap, boolean isForNextDueDate) {
        Map<Boolean, String> vaccineMissedMap = new HashMap<>();
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.getDefault());
        boolean isMissed;
        String dateRange;
        Calendar dob = Calendar.getInstance();
        Calendar temp = Calendar.getInstance();
        dateOfBirth = UtilBean.clearTimeFromDate(dateOfBirth);
        currentDate = UtilBean.clearTimeFromDate(currentDate);
        dob.setTime(dateOfBirth);
        temp.setTime(dateOfBirth);
        Date lbw = UtilBean.clearTimeFromDate(new Date());
        Date ubw = UtilBean.clearTimeFromDate(new Date());
        Date tmpDate;

        if (vaccineGivenDateMap == null) {
            vaccineGivenDateMap = new HashMap<>();
        }

        switch (immunisation) {
            case RchConstants.Z_BCG:
                lbw = dob.getTime();
                dob.add(Calendar.YEAR, 1);
                ubw = dob.getTime();
                dob.setTime(dateOfBirth);
                break;

            case RchConstants.Z_OPV_0:
                lbw = dob.getTime();
                dob.add(Calendar.DATE, 13);
                ubw = dob.getTime();
                dob.setTime(dateOfBirth);
                break;
            case RchConstants.Z_VITTAMIN_A_50000:
                lbw = dob.getTime();
                dob.add(Calendar.MONTH, 5);
                ubw = dob.getTime();
                dob.setTime(dateOfBirth);
                break;

            case RchConstants.Z_VITTAMIN_A_100000:
                dob.add(Calendar.MONTH, 6);
                lbw = dob.getTime();
                dob.setTime(dateOfBirth);
                dob.add(Calendar.MONTH, 11);
                ubw = dob.getTime();
                dob.setTime(dateOfBirth);
                break;

            case RchConstants.Z_VITTAMIN_A_200000_1:
                dob.add(Calendar.MONTH, 12);
                lbw = dob.getTime();
                dob.setTime(dateOfBirth);
                dob.add(Calendar.MONTH, 18);
                ubw = dob.getTime();
                dob.setTime(dateOfBirth);
                break;
            case RchConstants.Z_VITTAMIN_A_200000_2:
                dob.add(Calendar.MONTH, 18);
                lbw = dob.getTime();
                dob.setTime(dateOfBirth);
                dob.add(Calendar.MONTH, 24);
                ubw = dob.getTime();
                dob.setTime(dateOfBirth);
                break;
            case RchConstants.Z_VITTAMIN_A_200000_3:
                dob.add(Calendar.MONTH, 24);
                lbw = dob.getTime();
                dob.setTime(dateOfBirth);
                dob.add(Calendar.MONTH, 30);
                ubw = dob.getTime();
                dob.setTime(dateOfBirth);
                break;
            case RchConstants.Z_VITTAMIN_A_200000_4:
                dob.add(Calendar.MONTH, 30);
                lbw = dob.getTime();
                dob.setTime(dateOfBirth);
                dob.add(Calendar.MONTH, 36);
                ubw = dob.getTime();
                dob.setTime(dateOfBirth);
                break;
            case RchConstants.Z_VITTAMIN_A_200000_5:
                dob.add(Calendar.MONTH, 36);
                lbw = dob.getTime();
                dob.setTime(dateOfBirth);
                dob.add(Calendar.MONTH, 42);
                ubw = dob.getTime();
                dob.setTime(dateOfBirth);
                break;
            case RchConstants.Z_VITTAMIN_A_200000_6:
                dob.add(Calendar.MONTH, 42);
                lbw = dob.getTime();
                dob.setTime(dateOfBirth);
                dob.add(Calendar.MONTH, 48);
                ubw = dob.getTime();
                dob.setTime(dateOfBirth);
                break;
            case RchConstants.Z_VITTAMIN_A_200000_7:
                dob.add(Calendar.MONTH, 48);
                lbw = dob.getTime();
                dob.setTime(dateOfBirth);
                dob.add(Calendar.MONTH, 54);
                ubw = dob.getTime();
                dob.setTime(dateOfBirth);
                break;
            case RchConstants.Z_VITTAMIN_A_200000_8:
                dob.add(Calendar.MONTH, 54);
                lbw = dob.getTime();
                dob.setTime(dateOfBirth);
                dob.add(Calendar.MONTH, 59);
                ubw = dob.getTime();
                dob.setTime(dateOfBirth);
                break;

            case RchConstants.Z_OPV_1:
            case RchConstants.Z_ROTA_VACCINE_1:
            case RchConstants.Z_PCV_1:
            case RchConstants.Z_DPT_HEB_HIB_1:
                dob.add(Calendar.DATE, 42);
                lbw = dob.getTime();
                dob.setTime(dateOfBirth);
                break;

            case RchConstants.Z_OPV_2:
                dob.add(Calendar.DATE, 70);
                lbw = dob.getTime();
                tmpDate = vaccineGivenDateMap.get(RchConstants.Z_OPV_1);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 28);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                dob.setTime(dateOfBirth);
                break;

            case RchConstants.Z_OPV_3:
                dob.add(Calendar.DATE, 98);
                lbw = dob.getTime();
                tmpDate = vaccineGivenDateMap.get(RchConstants.OPV_1);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 56);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                tmpDate = vaccineGivenDateMap.get(RchConstants.Z_OPV_2);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 28);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                dob.setTime(dateOfBirth);
                break;

            case RchConstants.Z_ROTA_VACCINE_2:
                dob.add(Calendar.DATE, 70);
                lbw = dob.getTime();
                tmpDate = vaccineGivenDateMap.get(RchConstants.Z_ROTA_VACCINE_1);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 28);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                dob.setTime(dateOfBirth);
                break;

            case RchConstants.Z_PCV_2:
                dob.add(Calendar.DATE, 70);
                lbw = dob.getTime();
                tmpDate = vaccineGivenDateMap.get(RchConstants.Z_PCV_1);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 28);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                dob.setTime(dateOfBirth);
                break;

            case RchConstants.Z_PCV_3:
                dob.add(Calendar.DATE, 98);
                lbw = dob.getTime();
                tmpDate = vaccineGivenDateMap.get(RchConstants.Z_PCV_1);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 56);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                tmpDate = vaccineGivenDateMap.get(RchConstants.Z_PCV_2);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 28);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                dob.setTime(dateOfBirth);
                break;

            case RchConstants.Z_DPT_HEB_HIB_2:
                dob.add(Calendar.DATE, 70);
                lbw = dob.getTime();
                tmpDate = vaccineGivenDateMap.get(RchConstants.Z_DPT_HEB_HIB_1);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 28);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                dob.setTime(dateOfBirth);
                break;

            case RchConstants.Z_DPT_HEB_HIB_3:
                dob.add(Calendar.DATE, 98);
                lbw = dob.getTime();
                tmpDate = vaccineGivenDateMap.get(RchConstants.Z_DPT_HEB_HIB_1);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 56);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                tmpDate = vaccineGivenDateMap.get(RchConstants.Z_DPT_HEB_HIB_2);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 28);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                dob.setTime(dateOfBirth);
                break;

            case RchConstants.Z_MEASLES_RUBELLA_1:
                dob.add(Calendar.MONTH, 9);
                lbw = dob.getTime();
                dob.setTime(dateOfBirth);
                break;


            case RchConstants.Z_MEASLES_RUBELLA_2:
                dob.add(Calendar.MONTH, 18);
                lbw = dob.getTime();
                tmpDate = vaccineGivenDateMap.get(RchConstants.MEASLES_RUBELLA_1);
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 28);
                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                        lbw = temp.getTime();
                    }
                }
                dob.setTime(dateOfBirth);
                break;
            default:
        }

        if (!isForNextDueDate) {
            isMissed = !UtilBean.clearTimeFromDate(lbw).equals(currentDate) && !UtilBean.clearTimeFromDate(lbw).before(currentDate);
        } else {
            isMissed = !UtilBean.clearTimeFromDate(ubw).equals(currentDate) &&
                    (UtilBean.clearTimeFromDate(lbw).equals(currentDate) ?
                            !UtilBean.clearTimeFromDate(ubw).after(currentDate) :
                            (!UtilBean.clearTimeFromDate(lbw).before(currentDate) || !UtilBean.clearTimeFromDate(ubw).after(currentDate)));
        }
        if (immunisation.equalsIgnoreCase(RchConstants.Z_BCG) ||
                immunisation.equalsIgnoreCase(RchConstants.Z_VITTAMIN_A_50000) ||
                immunisation.equalsIgnoreCase(RchConstants.Z_VITTAMIN_A_100000) ||
                immunisation.equalsIgnoreCase(RchConstants.Z_VITTAMIN_A_200000_1) ||
                immunisation.equalsIgnoreCase(RchConstants.Z_VITTAMIN_A_200000_2) ||
                immunisation.equalsIgnoreCase(RchConstants.Z_VITTAMIN_A_200000_3) ||
                immunisation.equalsIgnoreCase(RchConstants.Z_VITTAMIN_A_200000_4) ||
                immunisation.equalsIgnoreCase(RchConstants.Z_VITTAMIN_A_200000_5) ||
                immunisation.equalsIgnoreCase(RchConstants.Z_VITTAMIN_A_200000_6) ||
                immunisation.equalsIgnoreCase(RchConstants.Z_VITTAMIN_A_200000_7) ||
                immunisation.equalsIgnoreCase(RchConstants.Z_VITTAMIN_A_200000_8) ||
                immunisation.equalsIgnoreCase(RchConstants.Z_OPV_0)) {
            dateRange = sdf.format(lbw) + " - " + sdf.format(ubw);
        } else {
            dateRange = "After " + sdf.format(lbw);
        }
        vaccineMissedMap.put(isMissed, dateRange);
        return vaccineMissedMap;
    }

    @Override
    public String vaccinationValidationForChild(Date dob, Date givenDate, String currentVaccine, Map<String, Date> vaccineGivenDateMap) {
        if (currentVaccine == null) {
            return null;
        }
        if (givenDate == null) {
            return LabelConstants.PLEASE_SELECT_A_DATE;
        }
        dob = UtilBean.clearTimeFromDate(dob);
        givenDate = UtilBean.clearTimeFromDate(givenDate);

        Calendar from = Calendar.getInstance();
        from.setTime(dob);
        Calendar to = Calendar.getInstance();
        to.setTime(dob);
        Calendar temp = Calendar.getInstance();
        temp.setTime(dob);
        Date tmpDate;
        Date tmpDate2;
        switch (currentVaccine) {
            case RchConstants.HEPATITIS_B_0:
            case RchConstants.VITAMIN_K:
                to.add(Calendar.DATE, 1);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }
                break;
            case RchConstants.OPV_0:
                to.add(Calendar.DATE, 15);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }
                break;
            case RchConstants.BCG:
                to.add(Calendar.YEAR, 1);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }
                break;
            case RchConstants.OPV_1:
                from.add(Calendar.DATE, 42);
                to.add(Calendar.MONTH, 58);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }
                break;
            case RchConstants.OPV_2:
                tmpDate = vaccineGivenDateMap.get(RchConstants.OPV_1);
                if (tmpDate == null) {
                    return UtilBean.getMyLabel(LabelConstants.VACCINATION_IS_NOT_VALID);
                }

                if (tmpDate.after(givenDate)) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }

                if (UtilBean.getNumberOfDays(tmpDate, givenDate) <= 28) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }

                from.add(Calendar.DATE, 70);
                to.add(Calendar.MONTH, 59);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }
                break;
            case RchConstants.OPV_3:
                tmpDate = vaccineGivenDateMap.get(RchConstants.OPV_2);
                if (tmpDate == null) {
                    return UtilBean.getMyLabel(LabelConstants.VACCINATION_IS_NOT_VALID);
                }

                if (tmpDate.after(givenDate)) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }

                if (UtilBean.getNumberOfDays(tmpDate, givenDate) <= 28) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }

                from.add(Calendar.DATE, 98);
                to.add(Calendar.MONTH, 60);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }
                break;

            case RchConstants.ROTA_VIRUS_1:
            case RchConstants.F_IPV_1_01:
            case RchConstants.Z_PCV_1:
                from.add(Calendar.DATE, 42);
                to.add(Calendar.MONTH, 12);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }
                break;

            case RchConstants.ROTA_VIRUS_2:
                tmpDate = vaccineGivenDateMap.get(RchConstants.ROTA_VIRUS_1);
                if (tmpDate == null) {
                    return UtilBean.getMyLabel(LabelConstants.VACCINATION_IS_NOT_VALID);
                }

                if (tmpDate.after(givenDate)) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }

                if (UtilBean.getNumberOfDays(tmpDate, givenDate) <= 28) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }

                from.add(Calendar.DATE, 70);
                to.add(Calendar.MONTH, 23);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }
                break;
            case RchConstants.ROTA_VIRUS_3:
                tmpDate = vaccineGivenDateMap.get(RchConstants.ROTA_VIRUS_2);
                if (tmpDate == null) {
                    return UtilBean.getMyLabel(LabelConstants.VACCINATION_IS_NOT_VALID);
                }

                if (tmpDate.after(givenDate)) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }

                if (UtilBean.getNumberOfDays(tmpDate, givenDate) <= 28) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }

                from.add(Calendar.DATE, 98);
                to.add(Calendar.MONTH, 24);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }
                break;

            case RchConstants.Z_PCV_2:
                tmpDate = vaccineGivenDateMap.get(RchConstants.Z_PCV_1);
                if (tmpDate == null) {
                    return UtilBean.getMyLabel(LabelConstants.VACCINATION_IS_NOT_VALID);
                }
                if (UtilBean.getNumberOfDays(tmpDate, givenDate) < 55) {
                    return "Please enter date after 8 weeks from PCV 1 given date";
                }
                from.setTime(tmpDate);
                from.add(Calendar.DATE, 56);
                to.add(Calendar.MONTH, 24);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }
                break;

            case RchConstants.PCV_BOOSTER:
                from.add(Calendar.MONTH, 9);
                to.add(Calendar.MONTH, 24);
                tmpDate = vaccineGivenDateMap.get(RchConstants.Z_PCV_1);
                if (tmpDate != null && UtilBean.getNumberOfDays(tmpDate, givenDate) < 111) {
                    return "Please enter date after 16 weeks from PCV 1 given date";
                }
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 112);
                    if (temp.getTimeInMillis() > from.getTimeInMillis() && !temp.getTime().after(new Date())) {
                        from.setTime(temp.getTime());
                    }
                }
                tmpDate = vaccineGivenDateMap.get(RchConstants.Z_PCV_2);
                if (tmpDate != null && UtilBean.getNumberOfDays(tmpDate, givenDate) < 55) {
                    return "Please enter date after 8 weeks from PCV 2 given date";
                }
                if (tmpDate != null) {
                    temp.setTime(tmpDate);
                    temp.add(Calendar.DATE, 56);
                    if (temp.getTimeInMillis() > from.getTimeInMillis() && !temp.getTime().after(new Date())) {
                        from.setTime(temp.getTime());
                    }
                }
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }
                break;

            case RchConstants.PENTA_1:
                if (vaccineGivenDateMap.containsKey(RchConstants.DPT_1)
                        || vaccineGivenDateMap.containsKey(RchConstants.DPT_2)
                        || vaccineGivenDateMap.containsKey(RchConstants.DPT_3)) {
                    return UtilBean.getMyLabel(LabelConstants.VACCINATION_IS_NOT_VALID);
                }
                from.add(Calendar.DATE, 42);
                to.add(Calendar.MONTH, 12);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }
                break;

            case RchConstants.PENTA_2:
                if (vaccineGivenDateMap.containsKey(RchConstants.DPT_1)
                        || vaccineGivenDateMap.containsKey(RchConstants.DPT_2)
                        || vaccineGivenDateMap.containsKey(RchConstants.DPT_3)) {
                    return UtilBean.getMyLabel(LabelConstants.VACCINATION_IS_NOT_VALID);
                }

                tmpDate = vaccineGivenDateMap.get(RchConstants.PENTA_1);
                if (tmpDate == null) {
                    return UtilBean.getMyLabel(LabelConstants.VACCINATION_IS_NOT_VALID);
                }

                if (tmpDate.after(givenDate)) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }

                if (UtilBean.getNumberOfDays(tmpDate, givenDate) <= 28) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }

                from.add(Calendar.DATE, 70);
                to.add(Calendar.MONTH, 59);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }
                break;

            case RchConstants.PENTA_3:
                if (vaccineGivenDateMap.containsKey(RchConstants.DPT_1)
                        || vaccineGivenDateMap.containsKey(RchConstants.DPT_2)
                        || vaccineGivenDateMap.containsKey(RchConstants.DPT_3)) {
                    return UtilBean.getMyLabel(LabelConstants.VACCINATION_IS_NOT_VALID);
                }

                tmpDate = vaccineGivenDateMap.get(RchConstants.PENTA_2);
                if (tmpDate == null) {
                    return UtilBean.getMyLabel(LabelConstants.VACCINATION_IS_NOT_VALID);
                }

                if (tmpDate.after(givenDate)) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }

                if (UtilBean.getNumberOfDays(tmpDate, givenDate) <= 28) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }

                from.add(Calendar.DATE, 98);
                to.add(Calendar.MONTH, 60);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }
                break;

            case RchConstants.DPT_1:
                if (vaccineGivenDateMap.containsKey(RchConstants.PENTA_1)
                        || vaccineGivenDateMap.containsKey(RchConstants.PENTA_2)
                        || vaccineGivenDateMap.containsKey(RchConstants.PENTA_3)) {
                    return UtilBean.getMyLabel(LabelConstants.VACCINATION_IS_NOT_VALID);
                }
                from.add(Calendar.MONTH, 12);
                to.add(Calendar.MONTH, 82);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }
                break;

            case RchConstants.DPT_2:
                if (vaccineGivenDateMap.containsKey(RchConstants.PENTA_1)
                        || vaccineGivenDateMap.containsKey(RchConstants.PENTA_2)
                        || vaccineGivenDateMap.containsKey(RchConstants.PENTA_3)) {
                    return UtilBean.getMyLabel(LabelConstants.VACCINATION_IS_NOT_VALID);
                }

                tmpDate = vaccineGivenDateMap.get(RchConstants.DPT_1);
                if (tmpDate == null) {
                    return UtilBean.getMyLabel(LabelConstants.VACCINATION_IS_NOT_VALID);
                }

                if (tmpDate.after(givenDate)) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }

                if (UtilBean.getNumberOfDays(tmpDate, givenDate) <= 28) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }

                from.add(Calendar.DATE, 13);
                to.add(Calendar.MONTH, 83);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }
                break;

            case RchConstants.DPT_3:
                if (vaccineGivenDateMap.containsKey(RchConstants.PENTA_1)
                        || vaccineGivenDateMap.containsKey(RchConstants.PENTA_2)
                        || vaccineGivenDateMap.containsKey(RchConstants.PENTA_3)) {
                    return UtilBean.getMyLabel(LabelConstants.VACCINATION_IS_NOT_VALID);
                }

                tmpDate = vaccineGivenDateMap.get(RchConstants.DPT_2);
                if (tmpDate == null) {
                    return UtilBean.getMyLabel(LabelConstants.VACCINATION_IS_NOT_VALID);
                }

                if (tmpDate.after(givenDate)) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }

                if (UtilBean.getNumberOfDays(tmpDate, givenDate) <= 28) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }

                from.add(Calendar.DATE, 14);
                to.add(Calendar.MONTH, 84);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }
                break;

            case RchConstants.F_IPV_2_01:
                tmpDate = vaccineGivenDateMap.get(RchConstants.F_IPV_1_01);
                if (tmpDate == null) {
                    return UtilBean.getMyLabel(LabelConstants.VACCINATION_IS_NOT_VALID);
                }

                if (tmpDate.after(givenDate)) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }

                if (UtilBean.getNumberOfDays(tmpDate, givenDate) <= 28) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }

                from.add(Calendar.DATE, 98);
                to.add(Calendar.MONTH, 12);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }
                break;
            case RchConstants.F_IPV_2_05:
                if (vaccineGivenDateMap.containsKey(RchConstants.F_IPV_1_01)
                        || vaccineGivenDateMap.containsKey(RchConstants.F_IPV_2_01)) {
                    return UtilBean.getMyLabel(LabelConstants.VACCINATION_IS_NOT_VALID);
                }

                Date opv3Date2 = vaccineGivenDateMap.get(RchConstants.OPV_3);
                if (opv3Date2 == null) {
                    return UtilBean.getMyLabel(LabelConstants.VACCINATION_IS_NOT_VALID);
                }

                if (UtilBean.getNumberOfMonths(dob, givenDate) > 11) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }

                Calendar givenDateCalender2 = Calendar.getInstance();
                givenDateCalender2.setTime(givenDate);
                Calendar onlyDate2 = UtilBean.clearTimeFromDate(givenDateCalender2);
                if (opv3Date2.after(onlyDate2.getTime()) || opv3Date2.before(onlyDate2.getTime())) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }

                from.add(Calendar.DATE, 98);
                to.add(Calendar.MONTH, 12);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }
                break;
            case RchConstants.VITAMIN_A:
                tmpDate = vaccineGivenDateMap.get(RchConstants.VITAMIN_A);

                if (tmpDate != null && tmpDate.after(givenDate)) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }
                from.add(Calendar.MONTH, 8);
                to.add(Calendar.MONTH, 60);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }
                break;
            case RchConstants.OPV_BOOSTER:
                tmpDate = vaccineGivenDateMap.get(RchConstants.OPV_3);
                if (tmpDate == null) {
                    return UtilBean.getMyLabel(LabelConstants.VACCINATION_IS_NOT_VALID);
                }

                if (UtilBean.getNumberOfMonths(tmpDate, givenDate) < 6) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }
                break;
            case RchConstants.DPT_BOOSTER:
                tmpDate = vaccineGivenDateMap.get(RchConstants.DPT_3);
                tmpDate2 = vaccineGivenDateMap.get(RchConstants.PENTA_3);
                if (tmpDate == null
                        && tmpDate2 == null) {
                    return UtilBean.getMyLabel(LabelConstants.VACCINATION_IS_NOT_VALID);
                }

                if (tmpDate != null && UtilBean.getNumberOfMonths(tmpDate, givenDate) < 6) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }

                if (tmpDate2 != null && UtilBean.getNumberOfMonths(tmpDate2, givenDate) < 6) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }
                break;
            case RchConstants.MEASLES_RUBELLA_1:

                from.add(Calendar.MONTH, 9);
                to.add(Calendar.MONTH, 59);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }
                break;
            case RchConstants.MEASLES_RUBELLA_2:
                tmpDate = vaccineGivenDateMap.get(RchConstants.MEASLES_RUBELLA_1);
                tmpDate2 = vaccineGivenDateMap.get(RchConstants.MEASLES_1);
                if (tmpDate == null
                        && tmpDate2 == null) {
                    return UtilBean.getMyLabel(LabelConstants.VACCINATION_IS_NOT_VALID);
                }

                if (tmpDate != null && UtilBean.getNumberOfDays(tmpDate, givenDate) <= 28) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }

                if (tmpDate2 != null && UtilBean.getNumberOfDays(tmpDate2, givenDate) <= 28) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }

                from.add(Calendar.MONTH, 16);
                to.add(Calendar.MONTH, 60);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }
                break;
            default:
        }
        return null;
    }


    @Override
    public String vaccinationValidationForChildZambia(Date dob, Date givenDate, String currentVaccine, Map<String, Date> vaccineGivenDateMap, QueFormBean queFormBean) {
        if (currentVaccine == null) {
            return null;
        }
        if (givenDate == null) {
            return LabelConstants.PLEASE_SELECT_A_DATE;
        }
        dob = UtilBean.clearTimeFromDate(dob);
        givenDate = UtilBean.clearTimeFromDate(givenDate);

        Calendar from = Calendar.getInstance();
        from.setTime(dob);
        Calendar to = Calendar.getInstance();
        to.setTime(dob);
        Date tmpDate;
        switch (currentVaccine) {
            case RchConstants.Z_OPV_0:
                to.add(Calendar.DATE, 13);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return "OPV 0 vaccine should be given within 13 days from date of birth";
                }
                break;

            case RchConstants.Z_BCG:
                to.add(Calendar.YEAR, 1);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return "BCG vaccine should be given within 1 year from date of birth";
                }
                break;
            case RchConstants.Z_VITTAMIN_A_50000:
                to.add(Calendar.MONTH, 5);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return "Vitamin A, 50,000 IU vaccine should be given within 5 months from date of birth";
                }
                break;
            case RchConstants.Z_VITTAMIN_A_100000:
                from.add(Calendar.MONTH, 6);
                to.add(Calendar.MONTH, 11);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return "Vitamin A, 100,000 IU vaccine should be given between 6 to 11 months from date of birth";
                }
                break;
            case RchConstants.Z_VITTAMIN_A_200000_1:
                from.add(Calendar.MONTH, 12);
                to.add(Calendar.MONTH, 18);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return "Vitamin A, 200,000 IU first dose vaccine should be given between 12 to 18 months from date of birth";
                }
                break;
            case RchConstants.Z_VITTAMIN_A_200000_2:
                from.add(Calendar.MONTH, 18);
                to.add(Calendar.MONTH, 24);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return "Vitamin A, 200,000 IU second dose vaccine should be given between 18 to 24 months from date of birth";
                }
                break;
            case RchConstants.Z_VITTAMIN_A_200000_3:
                from.add(Calendar.MONTH, 24);
                to.add(Calendar.MONTH, 30);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return "Vitamin A, 200,000 IU third dose vaccine should be given between 24 to 30 months from date of birth";
                }
                break;
            case RchConstants.Z_VITTAMIN_A_200000_4:
                from.add(Calendar.MONTH, 30);
                to.add(Calendar.MONTH, 36);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return "Vitamin A, 200,000 IU fourth dose vaccine should be given between 30 to 36 months from date of birth";
                }
                break;
            case RchConstants.Z_VITTAMIN_A_200000_5:
                from.add(Calendar.MONTH, 36);
                to.add(Calendar.MONTH, 42);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return "Vitamin A, 200,000 IU fifth dose vaccine should be given between 36 to 42 months from date of birth";
                }
                break;
            case RchConstants.Z_VITTAMIN_A_200000_6:
                from.add(Calendar.MONTH, 42);
                to.add(Calendar.MONTH, 48);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return "Vitamin A, 200,000 IU sixth dose vaccine should be given between 42 to 48 months from date of birth";
                }
                break;
            case RchConstants.Z_VITTAMIN_A_200000_7:
                from.add(Calendar.MONTH, 48);
                to.add(Calendar.MONTH, 54);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return "Vitamin A, 200,000 IU seventh dose vaccine should be given between 48 to 54 months from date of birth";
                }
                break;
            case RchConstants.Z_VITTAMIN_A_200000_8:
                from.add(Calendar.MONTH, 54);
                to.add(Calendar.MONTH, 59);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return "Vitamin A, 200,000 IU eighth dose vaccine should be given between 54 to 59 months from date of birth";
                }
                break;

            case RchConstants.Z_OPV_1:
                from.add(Calendar.DATE, 42);
                to.add(Calendar.MONTH, 58);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return "OPV 1 vaccine should be given after 6 weeks from date of birth";
                }
                break;

            case RchConstants.Z_OPV_2:
                tmpDate = vaccineGivenDateMap.get(RchConstants.Z_OPV_1);
                if (tmpDate == null) {
                    return "OPV 1 vaccine is not given yet";
                }

                if (tmpDate.after(givenDate)) {
                    return "OPV 2 vaccine date cannot be before OPV 1 vaccine date";
                }

                if (UtilBean.getNumberOfDays(tmpDate, givenDate) <= 28) {
                    return "OPV 2 vaccine should be given 28 days after OPV 1 vaccine";
                }

                from.add(Calendar.DATE, 70);
                to.add(Calendar.MONTH, 59);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }
                break;

            case RchConstants.Z_OPV_3:
                tmpDate = vaccineGivenDateMap.get(RchConstants.Z_OPV_2);
                if (tmpDate == null) {
                    return "OPV 2 vaccine is not given yet";
                }

                if (tmpDate.after(givenDate)) {
                    return "OPV 3 vaccine date cannot be before OPV 2 vaccine date";
                }

                if (UtilBean.getNumberOfDays(tmpDate, givenDate) <= 28) {
                    return "OPV 3 vaccine should be given 28 days after OPV 2 vaccine";
                }

                from.add(Calendar.DATE, 98);
                to.add(Calendar.MONTH, 60);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }
                break;

            case RchConstants.Z_OPV_4:
                tmpDate = vaccineGivenDateMap.get(RchConstants.Z_OPV_0);
                if (tmpDate == null) {
                    from.add(Calendar.MONTH, 9);
                    to.add(Calendar.MONTH, 59);
                    if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                        return "OPV 4 should be given after 9 months after date of birth";
                    }
                } else {
                    return "OPV 0 is already given";
                }

                break;

            case RchConstants.Z_ROTA_VACCINE_1:
            case RchConstants.Z_PCV_1:
            case RchConstants.Z_DPT_HEB_HIB_1:
                from.add(Calendar.DATE, 42);
                to.add(Calendar.MONTH, 12);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return FullFormConstants.getFullFormOfVaccines(currentVaccine) + " should be given 6 weeks after date of birth";
                }
                break;

            case RchConstants.Z_ROTA_VACCINE_2:
                tmpDate = vaccineGivenDateMap.get(RchConstants.Z_ROTA_VACCINE_1);
                if (tmpDate == null) {
                    return "ROTA vaccine 1 is not given yet";
                }

                if (tmpDate.after(givenDate)) {
                    return "ROTA vaccine 2 date cannot be before ROTA vaccine 1 date";
                }

                if (UtilBean.getNumberOfDays(tmpDate, givenDate) <= 28) {
                    return "ROTA vaccine 2 should be given 28 days after ROTA vaccine 1";
                }

                from.add(Calendar.DATE, 70);
                to.add(Calendar.MONTH, 23);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }
                break;

            case RchConstants.Z_PCV_2:
                tmpDate = vaccineGivenDateMap.get(RchConstants.Z_PCV_1);
                if (tmpDate == null) {
                    return "PCV 1 vaccine is not given yet";
                }

                if (tmpDate.after(givenDate)) {
                    return "PCV 2 vaccine date cannot be before PCV 1 vaccine date";
                }

                if (UtilBean.getNumberOfDays(tmpDate, givenDate) <= 28) {
                    return "PCV 2 vaccine should be given 28 days after PCV 1";
                }

                from.add(Calendar.DATE, 98);
                to.add(Calendar.MONTH, 12);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }
                break;

            case RchConstants.Z_DPT_HEB_HIB_2:
                tmpDate = vaccineGivenDateMap.get(RchConstants.Z_DPT_HEB_HIB_1);
                if (tmpDate == null) {
                    return "DPT-HepB-Hib 1 vaccine is not given yet";
                }

                if (tmpDate.after(givenDate)) {
                    return "DPT-HepB-Hib 2 vaccine date cannot be before DPT-HepB-Hib 1 vaccine date";
                }

                if (UtilBean.getNumberOfDays(tmpDate, givenDate) <= 28) {
                    return "DPT-HepB-Hib 2 vaccine should be given 28 days after DPT-HepB-Hib 1";
                }

                from.add(Calendar.DATE, 98);
                to.add(Calendar.MONTH, 12);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }
                break;

            case RchConstants.Z_PCV_3:
                tmpDate = vaccineGivenDateMap.get(RchConstants.Z_PCV_2);
                if (tmpDate == null) {
                    return "PCV 2 vaccine is not given yet";
                }

                if (tmpDate.after(givenDate)) {
                    return "PCV 3 vaccine date cannot be before PCV 2 vaccine date";
                }

                if (UtilBean.getNumberOfDays(tmpDate, givenDate) <= 28) {
                    return "PCV 3 vaccine should be given 28 days after PCV 2";
                }

                from.add(Calendar.DATE, 98);
                to.add(Calendar.MONTH, 12);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }
                break;

            case RchConstants.Z_DPT_HEB_HIB_3:
                tmpDate = vaccineGivenDateMap.get(RchConstants.Z_DPT_HEB_HIB_2);
                if (tmpDate == null) {
                    return "DPT-HepB-Hib 2 vaccine is not given yet";
                }

                if (tmpDate.after(givenDate)) {
                    return "DPT-HepB-Hib 3 vaccine date cannot be before DPT-HepB-Hib 2 vaccine date";
                }

                if (UtilBean.getNumberOfDays(tmpDate, givenDate) <= 28) {
                    return "DPT-HepB-Hib 3 vaccine should be given 28 days after DPT-HepB-Hib 2";
                }

                from.add(Calendar.DATE, 98);
                to.add(Calendar.MONTH, 12);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return LabelConstants.VACCINATION_DATE_IS_NOT_VALID;
                }
                break;

            case RchConstants.Z_MEASLES_RUBELLA_1:
                from.add(Calendar.MONTH, 9);
                to.add(Calendar.MONTH, 59);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return "Measles Rubella 1 should be given after 9 months from date of birth";
                }
                break;
            case RchConstants.Z_MEASLES_RUBELLA_2:
                from.add(Calendar.MONTH, 18);
                to.add(Calendar.MONTH, 60);
                if (givenDate.after(to.getTime()) || givenDate.before(from.getTime())) {
                    return "Measles Rubella 2 should be given after 18 months from date of birth";
                }
                break;
            default:
        }
        return null;


//        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.getDefault());
//        Map<Boolean, String> immunisationMissedMap;
//        if (GlobalTypes.FLAVOUR_CHIP.equalsIgnoreCase(BuildConfig.FLAVOR)) {
//            immunisationMissedMap  = SharedStructureData.immunisationService.isImmunisationMissedOrNotValidZambia(dob, currentVaccine, new Date(), SharedStructureData.getVaccineGivenDateMap(queFormBean.getLoopCounter()), true);
//        } else {
//            immunisationMissedMap = SharedStructureData.immunisationService.isImmunisationMissedOrNotValid(dob, currentVaccine, new Date(), SharedStructureData.getVaccineGivenDateMap(queFormBean.getLoopCounter()), true);
//        }
//        for (Map.Entry<Boolean, String> entry : immunisationMissedMap.entrySet()) {
//            String dateRange = entry.getValue();
//            try {
//                if (dateRange != null) {
//                    String[] date = dateRange.split("-");
//                    if (!Objects.requireNonNull(sdf.parse(date[0])).before(givenDate)) {
//                        return "Please select date within the range for " + currentVaccine.replace("_", " ");
//                    }
//                    if (!Objects.requireNonNull(sdf.parse(date[1])).after(givenDate)) {
//                        return "Please select date within the range for " + currentVaccine.replace("_", " ");
//                    }
//                }
//            } catch (ParseException e) {
//                e.printStackTrace();
//            }
//        }
//        return null;
    }


    @Override
    public boolean isImmunisationMissed(Date dateOfBirth, String immunisation) {
        Calendar instance = Calendar.getInstance();
        Date currentDate = instance.getTime();
        instance.setTime(dateOfBirth);
        Date lbw = new Date();
        Date ubw = new Date();

        switch (immunisation) {
            case RchConstants.HEPATITIS_B_0:
            case RchConstants.VITAMIN_K:
                lbw = instance.getTime();
                instance.add(Calendar.DAY_OF_WEEK, 1);
                ubw = instance.getTime();
                break;


            case RchConstants.BCG:
                lbw = instance.getTime();
                instance.add(Calendar.YEAR, 1);
                ubw = instance.getTime();
                break;

            case RchConstants.OPV_0:
                lbw = instance.getTime();
                instance.add(Calendar.DAY_OF_WEEK, 15);
                ubw = instance.getTime();
                break;

            case RchConstants.OPV_1:
                instance.add(Calendar.DAY_OF_WEEK, 42);
                lbw = instance.getTime();
                instance.add(Calendar.DAY_OF_WEEK, -42);
                instance.add(Calendar.MONTH, 58);
                ubw = instance.getTime();
                break;

            case RchConstants.OPV_2:
            case RchConstants.PENTA_2:
                instance.add(Calendar.DAY_OF_WEEK, 70);
                lbw = instance.getTime();
                instance.add(Calendar.DAY_OF_WEEK, -70);
                instance.add(Calendar.MONTH, 59);
                ubw = instance.getTime();
                break;

            case RchConstants.OPV_3:
            case RchConstants.PENTA_3:
                instance.add(Calendar.DAY_OF_WEEK, 98);
                lbw = instance.getTime();
                instance.add(Calendar.DAY_OF_WEEK, -98);
                instance.add(Calendar.MONTH, 60);
                ubw = instance.getTime();
                break;

            case RchConstants.ROTA_VIRUS_1:
            case RchConstants.PENTA_1:
            case RchConstants.F_IPV_1_01:
                instance.add(Calendar.DAY_OF_WEEK, 42);
                lbw = instance.getTime();
                instance.add(Calendar.DAY_OF_WEEK, -42);
                instance.add(Calendar.MONTH, 12);
                ubw = instance.getTime();
                break;

            case RchConstants.ROTA_VIRUS_2:
                instance.add(Calendar.DAY_OF_WEEK, 70);
                lbw = instance.getTime();
                instance.add(Calendar.DAY_OF_WEEK, -70);
                instance.add(Calendar.MONTH, 23);
                ubw = instance.getTime();
                break;

            case RchConstants.ROTA_VIRUS_3:
                instance.add(Calendar.DAY_OF_WEEK, 98);
                lbw = instance.getTime();
                instance.add(Calendar.DAY_OF_WEEK, -98);
                instance.add(Calendar.MONTH, 24);
                ubw = instance.getTime();
                break;

            case RchConstants.DPT_1:
                instance.add(Calendar.MONTH, 12);
                lbw = instance.getTime();
                instance.add(Calendar.MONTH, -12);
                instance.add(Calendar.MONTH, 82);
                ubw = instance.getTime();
                break;

            case RchConstants.DPT_2:
                instance.add(Calendar.MONTH, 13);
                lbw = instance.getTime();
                instance.add(Calendar.MONTH, -13);
                instance.add(Calendar.MONTH, 83);
                ubw = instance.getTime();
                break;

            case RchConstants.DPT_3:
                instance.add(Calendar.MONTH, 14);
                lbw = instance.getTime();
                instance.add(Calendar.MONTH, -14);
                instance.add(Calendar.MONTH, 84);
                ubw = instance.getTime();
                break;

            case RchConstants.F_IPV_2_01:
            case RchConstants.F_IPV_2_05:
                instance.add(Calendar.DAY_OF_WEEK, 98);
                lbw = instance.getTime();
                instance.add(Calendar.DAY_OF_WEEK, -98);
                instance.add(Calendar.MONTH, 12);
                ubw = instance.getTime();
                break;

            case RchConstants.VITAMIN_A:
                instance.add(Calendar.MONTH, 8);
                lbw = instance.getTime();
                instance.add(Calendar.MONTH, -8);
                instance.add(Calendar.MONTH, 60);
                ubw = instance.getTime();
                break;

            case RchConstants.OPV_BOOSTER:
            case RchConstants.DPT_BOOSTER:
                instance.add(Calendar.MONTH, 16);
                lbw = instance.getTime();
                instance.add(Calendar.MONTH, -16);
                ubw = instance.getTime();
                break;

            case RchConstants.MEASLES_RUBELLA_1:
                instance.add(Calendar.MONTH, 9);
                lbw = instance.getTime();
                instance.add(Calendar.MONTH, -9);
                instance.add(Calendar.MONTH, 59);
                ubw = instance.getTime();
                break;

            case RchConstants.MEASLES_RUBELLA_2:
                instance.add(Calendar.MONTH, 16);
                lbw = instance.getTime();
                instance.add(Calendar.MONTH, -16);
                instance.add(Calendar.MONTH, 60);
                ubw = instance.getTime();
                break;
            default:
        }

        return !lbw.before(currentDate) || !ubw.after(currentDate);
    }
}
