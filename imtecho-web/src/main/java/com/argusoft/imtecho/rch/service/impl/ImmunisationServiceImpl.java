/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.rch.service.impl;

import com.argusoft.imtecho.common.util.ConstantUtil;
import com.argusoft.imtecho.fhs.dao.MemberDao;
import com.argusoft.imtecho.mobile.constants.MobileConstantUtil;
import com.argusoft.imtecho.rch.constants.RchConstants;
import com.argusoft.imtecho.rch.dao.ImmunisationMasterDao;
import com.argusoft.imtecho.rch.model.ImmunisationMaster;
import com.argusoft.imtecho.rch.service.ImmunisationService;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.StringTokenizer;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.bouncycastle.asn1.crmf.EncryptedValue;
import org.joda.time.DateTime;
import org.joda.time.Days;
import org.joda.time.Months;
import org.joda.time.Weeks;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * <p>
 *     Define services for immunisations.
 * </p>
 * @author kunjan
 * @since 26/08/20 11:00 AM
 *
 */
@Service
@Transactional
public class ImmunisationServiceImpl implements ImmunisationService {

    private static org.slf4j.Logger log = LoggerFactory.getLogger(ImmunisationServiceImpl.class);

    @Autowired
    private ImmunisationMasterDao immunisationMasterDao;

    @Autowired
    private MemberDao memberDao;

    /**
     * {@inheritDoc}
     */
    @Override
    public void createImmunisationMaster(ImmunisationMaster immunisationMaster) {
        immunisationMaster.setImmunisationGiven(immunisationMaster.getImmunisationGiven().trim());
        if (immunisationMaster.getImmunisationGiven().equals(RchConstants.VaccinationType.VITAMIN_A)) {
            updatePreviousVitaminANo(immunisationMaster.getMemberId());
            immunisationMaster.setVitaminANo(immunisationMasterDao.getTotalVitaminADoseGiven(immunisationMaster.getMemberId()) + 1);
        }
        immunisationMasterDao.create(immunisationMaster);
    }

    private void updatePreviousVitaminANo(Integer memberId) {
        List<ImmunisationMaster> immunisationMasters = immunisationMasterDao.getAllVaccinesByVaccineType(memberId, RchConstants.VaccinationType.VITAMIN_A);
        int count = 1;
        for (ImmunisationMaster immunisationMaster : immunisationMasters) {
            immunisationMaster.setVitaminANo(count);
            count++;
        }
        immunisationMasterDao.updateAll(immunisationMasters);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public boolean checkImmunisationEntry(ImmunisationMaster immunisationMaster) {
        return immunisationMasterDao.checkImmunisationEntry(immunisationMaster.getMemberId(), immunisationMaster.getImmunisationGiven(), immunisationMaster.getPregnancyRegDetId());
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Set<String> getDueImmunisationsForChild(Date dateOfBirth, String givenImmunisations) {

        String message = "Date of Birth:" + dateOfBirth + " , Immunisation:" + givenImmunisations;
        log.info(message);

        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        Set<String> vaccinationSet = new LinkedHashSet<>();
        Map<String, Date> vaccineGivenDateMap = new HashMap<>();
        int ageInWeeks = getNumberOfWeeks(dateOfBirth, new Date());
        int ageInDays = getNumberOfDays(dateOfBirth, new Date());
        int ageInMonths = getNumberOfMonths(dateOfBirth, new Date());

        Calendar firstJuly = Calendar.getInstance();
        firstJuly.set(Calendar.YEAR, 2019);
        firstJuly.set(Calendar.MONTH, 6);
        firstJuly.set(Calendar.DATE, 1);
        firstJuly.set(Calendar.HOUR, 0);
        firstJuly.set(Calendar.MINUTE, 0);
        firstJuly.set(Calendar.SECOND, 0);
        firstJuly.set(Calendar.MILLISECOND, 0);
        firstJuly.set(Calendar.AM_PM, Calendar.AM);

        if(ConstantUtil.IMPLEMENTATION_TYPE.equals("imomcare")){
            if(ageInDays<=1){
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_HEPATITIS_B_0);
            }
            if(ageInDays<=7){
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_BCG);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_HEPATITIS_B_0);

            }
            if(ageInWeeks>=6 && ageInWeeks<=10){
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_DTP_HEPB_HIB_1);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_PCV_1);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_1);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_BCG);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_HEPATITIS_B_0);
            }
            if(ageInWeeks>=10 && ageInWeeks<=14){
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_DTP_HEPB_HIB_2);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_PCV_2);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_2);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_DTP_HEPB_HIB_1);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_PCV_1);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_1);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_BCG);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_HEPATITIS_B_0);
            }
            if(ageInWeeks>=14 && ageInWeeks<=18){
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_DTP_HEPB_HIB_3);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_PCV_3);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_3);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_IPV);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_DTP_HEPB_HIB_2);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_PCV_2);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_2);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_DTP_HEPB_HIB_1);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_PCV_1);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_1);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_BCG);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_HEPATITIS_B_0);
            }
            if(ageInMonths>=9 && ageInMonths<=18){
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_MR_1);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_JE);

            }
            if (ageInMonths>=18 ){
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_MR_2);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_JE);
            }
            if (givenImmunisations != null && givenImmunisations.length() > 0) {
                StringTokenizer vaccineTokenizer = new StringTokenizer(givenImmunisations, ",");
                while (vaccineTokenizer.hasMoreElements()) {
                    String[] vaccine = vaccineTokenizer.nextToken().split("#");
                    String givenVaccineName = vaccine[0].trim();
                    try {
                        vaccinationSet.remove(givenVaccineName);
                        vaccineGivenDateMap.put(givenVaccineName, sdf.parse(vaccine[1]));

                    } catch (ParseException e) {
                        log.error(getClass().getName(), null, e);
                    }
                }
            }
        }
        else{
            if (ageInDays <= 1) {
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_HEPATITIS_B_0);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_VITAMIN_K);
            }

            if (ageInDays <= 15) {
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_HEPATITIS_B_0);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_VITAMIN_K);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_0);
            }

            if (ageInMonths <= 12) {
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_HEPATITIS_B_0);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_VITAMIN_K);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_0);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_BCG);
            }

            if (ageInWeeks >= 6 && ageInWeeks < 10) {
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_HEPATITIS_B_0);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_VITAMIN_K);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_0);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_BCG);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_PENTA_1);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_1);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_1);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_F_IPV_1_01);

            } else if (ageInWeeks >= 6 && ageInWeeks < 14) {
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_HEPATITIS_B_0);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_VITAMIN_K);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_0);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_BCG);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_PENTA_1);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_1);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_1);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_F_IPV_1_01);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_PENTA_2);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_2);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_2);
            } else if (ageInWeeks >= 6 && ageInMonths < 9) {
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_HEPATITIS_B_0);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_VITAMIN_K);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_0);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_BCG);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_PENTA_1);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_1);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_1);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_F_IPV_1_01);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_PENTA_2);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_2);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_2);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_PENTA_3);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_3);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_3);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_F_IPV_2_01);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_F_IPV_2_05);
            } else if (ageInWeeks >= 6 && ageInMonths < 10) {
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_HEPATITIS_B_0);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_VITAMIN_K);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_0);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_BCG);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_PENTA_1);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_1);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_1);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_F_IPV_1_01);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_PENTA_2);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_2);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_2);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_PENTA_3);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_3);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_3);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_F_IPV_2_01);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_F_IPV_2_05);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_VITAMIN_A);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_MEASLES_RUBELLA_1);
            } else if (ageInWeeks >= 6 && ageInMonths < 16) {
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_HEPATITIS_B_0);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_VITAMIN_K);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_0);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_BCG);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_1);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_2);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_3);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_PENTA_1);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_PENTA_2);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_PENTA_3);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_1);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_2);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_3);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_F_IPV_1_01);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_F_IPV_2_01);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_F_IPV_2_05);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_VITAMIN_A);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_MEASLES_RUBELLA_1);
            } else if (ageInWeeks >= 6 && ageInMonths < 24) {
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_HEPATITIS_B_0);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_VITAMIN_K);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_0);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_BCG);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_1);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_2);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_3);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_PENTA_1);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_PENTA_2);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_PENTA_3);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_1);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_2);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_3);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_F_IPV_1_01);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_F_IPV_2_01);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_F_IPV_2_05);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_VITAMIN_A);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_MEASLES_RUBELLA_1);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_MEASLES_RUBELLA_2);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_BOOSTER);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_DPT_BOOSTER);
            } else if (ageInWeeks >= 6) {
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_HEPATITIS_B_0);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_VITAMIN_K);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_0);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_BCG);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_1);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_2);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_3);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_PENTA_1);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_PENTA_2);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_PENTA_3);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_F_IPV_1_01);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_F_IPV_2_01);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_F_IPV_2_05);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_VITAMIN_A);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_MEASLES_RUBELLA_1);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_MEASLES_RUBELLA_2);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_OPV_BOOSTER);
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_DPT_BOOSTER);
            }

            if (ageInMonths >= 12 && ageInMonths <= 84 &&
                    (givenImmunisations == null ||
                            !(givenImmunisations.contains(MobileConstantUtil.IMMUNISATION_PENTA_1)
                                    || givenImmunisations.contains(MobileConstantUtil.IMMUNISATION_PENTA_2)
                                    || givenImmunisations.contains(MobileConstantUtil.IMMUNISATION_PENTA_3)))) {
                vaccinationSet.add(MobileConstantUtil.IMMUNISATION_DPT_1);
                if (ageInMonths >= 13) {
                    vaccinationSet.add(MobileConstantUtil.IMMUNISATION_DPT_2);
                }
                if (ageInMonths >= 14) {
                    vaccinationSet.add(MobileConstantUtil.IMMUNISATION_DPT_3);
                }
            }

            if (givenImmunisations != null && givenImmunisations.length() > 0) {
                StringTokenizer vaccineTokenizer = new StringTokenizer(givenImmunisations, ",");
                while (vaccineTokenizer.hasMoreElements()) {
                    String[] vaccine = vaccineTokenizer.nextToken().split("#");
                    String givenVaccineName = vaccine[0].trim();
                    try {
                        if (givenVaccineName.equals(MobileConstantUtil.IMMUNISATION_VITAMIN_A)) {
                            Date givenDate = vaccineGivenDateMap.get(givenVaccineName);
                            if (givenDate == null || givenDate.before(sdf.parse(vaccine[1]))) {
                                vaccineGivenDateMap.put(givenVaccineName, sdf.parse(vaccine[1]));
                            }
                        } else {
                            vaccinationSet.remove(givenVaccineName);
                            vaccineGivenDateMap.put(givenVaccineName, sdf.parse(vaccine[1]));
                        }

                    } catch (ParseException e) {
                        log.error(getClass().getName(), null, e);
                    }
                }
            }

            if (vaccinationSet.contains(MobileConstantUtil.IMMUNISATION_DPT_BOOSTER)) {
                if (givenImmunisations == null) {
                    vaccinationSet.remove(MobileConstantUtil.IMMUNISATION_DPT_BOOSTER);
                } else {
                    if (!(givenImmunisations.contains(MobileConstantUtil.IMMUNISATION_PENTA_3)
                            || givenImmunisations.contains(MobileConstantUtil.IMMUNISATION_DPT_3))) {
                        vaccinationSet.remove(MobileConstantUtil.IMMUNISATION_DPT_BOOSTER);
                    }
                    if (givenImmunisations.contains(MobileConstantUtil.IMMUNISATION_PENTA_3) &&
                            getNumberOfMonths(vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_PENTA_3), new Date()) < 6) {
                        vaccinationSet.remove(MobileConstantUtil.IMMUNISATION_DPT_BOOSTER);
                    }
                    if (givenImmunisations.contains(MobileConstantUtil.IMMUNISATION_DPT_3) &&
                            getNumberOfMonths(vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_DPT_3), new Date()) < 6) {
                        vaccinationSet.remove(MobileConstantUtil.IMMUNISATION_DPT_BOOSTER);
                    }
                }
            }

            if (vaccinationSet.contains(MobileConstantUtil.IMMUNISATION_OPV_BOOSTER)) {
                if (givenImmunisations == null) {
                    vaccinationSet.remove(MobileConstantUtil.IMMUNISATION_OPV_BOOSTER);
                } else {
                    if (!givenImmunisations.contains(MobileConstantUtil.IMMUNISATION_OPV_3)) {
                        vaccinationSet.remove(MobileConstantUtil.IMMUNISATION_OPV_BOOSTER);
                    }
                    if (givenImmunisations.contains(MobileConstantUtil.IMMUNISATION_OPV_3) &&
                            getNumberOfMonths(vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_OPV_3), new Date()) < 6) {
                        vaccinationSet.remove(MobileConstantUtil.IMMUNISATION_OPV_BOOSTER);
                    }
                }
            }

            if (vaccinationSet.contains(MobileConstantUtil.IMMUNISATION_F_IPV_2_05)
                    && givenImmunisations != null
                    && givenImmunisations.contains(MobileConstantUtil.IMMUNISATION_F_IPV_1_01)) {
                vaccinationSet.remove(MobileConstantUtil.IMMUNISATION_F_IPV_2_05);
            }

            if (vaccinationSet.contains(MobileConstantUtil.IMMUNISATION_VITAMIN_A)
                    && givenImmunisations != null
                    && vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_VITAMIN_A)
                    && getNumberOfMonths(vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_VITAMIN_A), new Date()) < 4) {
                vaccinationSet.remove(MobileConstantUtil.IMMUNISATION_VITAMIN_A);
            }

            if (vaccinationSet.contains(MobileConstantUtil.IMMUNISATION_MEASLES_RUBELLA_1) &&
                    givenImmunisations != null &&
                    (givenImmunisations.contains(MobileConstantUtil.IMMUNISATION_MEASLES_RUBELLA_1)
                            || givenImmunisations.contains(MobileConstantUtil.IMMUNISATION_MEASLES_1))) {
                vaccinationSet.remove(MobileConstantUtil.IMMUNISATION_MEASLES_RUBELLA_1);
            }

            if (vaccinationSet.contains(MobileConstantUtil.IMMUNISATION_MEASLES_RUBELLA_2)) {
                if (givenImmunisations != null &&
                        (givenImmunisations.contains(MobileConstantUtil.IMMUNISATION_MEASLES_RUBELLA_2)
                                || givenImmunisations.contains(MobileConstantUtil.IMMUNISATION_MEASLES_2))) {
                    vaccinationSet.remove(MobileConstantUtil.IMMUNISATION_MEASLES_RUBELLA_2);
                    vaccinationSet.remove(MobileConstantUtil.IMMUNISATION_MEASLES_RUBELLA_1);
                } else if (givenImmunisations != null &&
                        !(givenImmunisations.contains(MobileConstantUtil.IMMUNISATION_MEASLES_RUBELLA_1)
                                || givenImmunisations.contains(MobileConstantUtil.IMMUNISATION_MEASLES_1))) {
                    vaccinationSet.remove(MobileConstantUtil.IMMUNISATION_MEASLES_RUBELLA_2);
                    vaccinationSet.add(MobileConstantUtil.IMMUNISATION_MEASLES_RUBELLA_1);
                } else if (givenImmunisations != null && givenImmunisations.contains(MobileConstantUtil.IMMUNISATION_MEASLES_1)
                        && getNumberOfWeeks(vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_MEASLES_1), new Date()) < 4) {
                    vaccinationSet.remove(MobileConstantUtil.IMMUNISATION_MEASLES_RUBELLA_2);
                } else if (givenImmunisations != null && givenImmunisations.contains(MobileConstantUtil.IMMUNISATION_MEASLES_RUBELLA_1)
                        && getNumberOfWeeks(vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_MEASLES_RUBELLA_1), new Date()) < 4) {
                    vaccinationSet.remove(MobileConstantUtil.IMMUNISATION_MEASLES_RUBELLA_2);
                }
            }

            if (dateOfBirth.before(firstJuly.getTime())) {
                int firstJulyAgeMonths = getNumberOfMonths(dateOfBirth, firstJuly.getTime());
                if (firstJulyAgeMonths >= 12 ||
                        (givenImmunisations != null &&
                                !givenImmunisations.contains(MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_1) &&
                                (givenImmunisations.contains(MobileConstantUtil.IMMUNISATION_PENTA_1) ||
                                        givenImmunisations.contains(MobileConstantUtil.IMMUNISATION_PENTA_2) ||
                                        givenImmunisations.contains(MobileConstantUtil.IMMUNISATION_PENTA_3)))) {
                    vaccinationSet.remove(MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_1);
                    vaccinationSet.remove(MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_2);
                    vaccinationSet.remove(MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_3);
                }
            } else if (getNumberOfMonths(dateOfBirth, new Date()) > 12 &&
                    (givenImmunisations == null ||
                            !givenImmunisations.contains(MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_1))) {
                vaccinationSet.remove(MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_1);
                vaccinationSet.remove(MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_2);
                vaccinationSet.remove(MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_3);
            }

        }
        if (!vaccinationSet.isEmpty()) {
            List<String> vaccines = new ArrayList<>(vaccinationSet);
            vaccines.sort(getVaccinationComparator);
            return new LinkedHashSet<>(vaccines);
        } else {
            return new LinkedHashSet<>();
        }
    }

    private int getNumberOfMonths(Date fromDate, Date toDate) {
        DateTime dateTime1 = new DateTime(fromDate);
        DateTime dateTime2 = new DateTime(toDate);

        return Months.monthsBetween(dateTime1, dateTime2).getMonths();
    }

    private static int getNumberOfWeeks(Date fromDate, Date toDate) {
        DateTime dateTime1 = new DateTime(fromDate);
        DateTime dateTime2 = new DateTime(toDate);

        return Weeks.weeksBetween(dateTime1, dateTime2).getWeeks();
    }

    private static int getNumberOfDays(Date fromDate, Date toDate) {
        DateTime dateTime1 = new DateTime(fromDate);
        DateTime dateTime2 = new DateTime(toDate);

        return Days.daysBetween(dateTime1, dateTime2).getDays() + 1;
    }

    private static Calendar clearTimeFromDate(Calendar today) {
        if (today != null) {
            today.set(Calendar.MILLISECOND, 0);
            today.set(Calendar.SECOND, 0);
            today.set(Calendar.MINUTE, 0);
            today.set(Calendar.HOUR_OF_DAY, 0);

        }
        return today;
    }

    private static Date clearTimeFromDate(Date date) {
        if (date != null) {
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(date);
            calendar.set(Calendar.MILLISECOND, 0);
            calendar.set(Calendar.SECOND, 0);
            calendar.set(Calendar.MINUTE, 0);
            calendar.set(Calendar.HOUR_OF_DAY, 0);

            return calendar.getTime();
        }
        return null;
    }

    private static final Comparator<String> getVaccinationComparator = new Comparator<>() {

        private Map<String, Integer> getVaccinationSortMap() {
            Map<String, Integer> vaccinationMap = new HashMap<>();
            vaccinationMap.put(MobileConstantUtil.IMMUNISATION_HEPATITIS_B_0, 1);
            vaccinationMap.put(MobileConstantUtil.IMMUNISATION_VITAMIN_K, 2);
            vaccinationMap.put(MobileConstantUtil.IMMUNISATION_BCG, 3);
            vaccinationMap.put(MobileConstantUtil.IMMUNISATION_OPV_0, 4);
            vaccinationMap.put(MobileConstantUtil.IMMUNISATION_OPV_1, 5);
            vaccinationMap.put(MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_1, 6);
            vaccinationMap.put(MobileConstantUtil.IMMUNISATION_PENTA_1, 7);
            vaccinationMap.put(MobileConstantUtil.IMMUNISATION_DPT_1, 8);
            vaccinationMap.put(MobileConstantUtil.IMMUNISATION_F_IPV_1_01, 9);
            vaccinationMap.put(MobileConstantUtil.IMMUNISATION_OPV_2, 10);
            vaccinationMap.put(MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_2, 11);
            vaccinationMap.put(MobileConstantUtil.IMMUNISATION_PENTA_2, 12);
            vaccinationMap.put(MobileConstantUtil.IMMUNISATION_DPT_2, 13);
            vaccinationMap.put(MobileConstantUtil.IMMUNISATION_OPV_3, 14);
            vaccinationMap.put(MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_3, 15);
            vaccinationMap.put(MobileConstantUtil.IMMUNISATION_PENTA_3, 16);
            vaccinationMap.put(MobileConstantUtil.IMMUNISATION_DPT_3, 17);
            vaccinationMap.put(MobileConstantUtil.IMMUNISATION_F_IPV_2_01, 18);
            vaccinationMap.put(MobileConstantUtil.IMMUNISATION_F_IPV_2_05, 19);
            vaccinationMap.put(MobileConstantUtil.IMMUNISATION_MEASLES_RUBELLA_1, 20);
            vaccinationMap.put(MobileConstantUtil.IMMUNISATION_MEASLES_RUBELLA_2, 21);
            vaccinationMap.put(MobileConstantUtil.IMMUNISATION_OPV_BOOSTER, 22);
            vaccinationMap.put(MobileConstantUtil.IMMUNISATION_DPT_BOOSTER, 23);
            vaccinationMap.put(MobileConstantUtil.IMMUNISATION_VITAMIN_A, 24);
            return vaccinationMap;
        }

        private Map<String, Integer> vaccinationSortMap = getVaccinationSortMap();

        @Override
        public int compare(String o1, String o2) {
            Integer one = vaccinationSortMap.get(o1);
            Integer two = vaccinationSortMap.get(o2);
            if (one != null && two != null) {
                return one.compareTo(two);
            }
            return 0;
        }
    };

    /**
     * {@inheritDoc}
     */
    @Override
    public String vaccinationValidationChild(Date dob, Date givenDate, String currentVaccine, String givenImmunisations) {

        final String VACCINATION_DATE_INVALID = "Vaccination date is not valid";
        final String VACCINATION_INVALID = "Vaccination is not valid";

        if (currentVaccine == null) {
            return null;
        }

        Map<String, Date> vaccineGivenDateMap = new HashMap<>();
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        if (givenImmunisations != null && givenImmunisations.length() > 0) {
            StringTokenizer vaccineTokenizer = new StringTokenizer(givenImmunisations, ",");
            while (vaccineTokenizer.hasMoreElements()) {
                String[] vaccine = vaccineTokenizer.nextToken().split("#");
                String givenVaccineName = vaccine[0].trim();
                try {
                    vaccineGivenDateMap.put(givenVaccineName, sdf.parse(vaccine[1]));
                } catch (ParseException e) {
                    Logger.getLogger(ImmunisationServiceImpl.class.getName()).log(Level.SEVERE, e.getMessage(), e);
                }
            }
        }

        dob = clearTimeFromDate(dob);
        givenDate = clearTimeFromDate(givenDate);
        Calendar from = Calendar.getInstance();
        from.setTime(dob);
        Calendar to = Calendar.getInstance();
        to.setTime(dob);
        switch (currentVaccine) {
            case MobileConstantUtil.IMMUNISATION_HEPATITIS_B_0:
            case MobileConstantUtil.IMMUNISATION_VITAMIN_K:
                to.add(Calendar.DATE, 1);
                if (givenDate != null && (givenDate.after(to.getTime()) || givenDate.before(from.getTime()))) {
                    return VACCINATION_DATE_INVALID;
                }
                break;
            case MobileConstantUtil.IMMUNISATION_OPV_0:
                to.add(Calendar.DATE, 15);
                if (givenDate != null && (givenDate.after(to.getTime()) || givenDate.before(from.getTime()))) {
                    return VACCINATION_DATE_INVALID;
                }
                break;
            case MobileConstantUtil.IMMUNISATION_BCG:
                if(ConstantUtil.IMPLEMENTATION_TYPE.equals("imomcare")){
                    to.add(Calendar.DATE, 7);
                    if (givenDate != null && (givenDate.after(to.getTime()) || givenDate.before(from.getTime()))) {
                        return VACCINATION_DATE_INVALID;
                    }
                    break;
                }

                to.add(Calendar.YEAR, 1);
                if (givenDate != null && (givenDate.after(to.getTime()) || givenDate.before(from.getTime()))) {
                    return VACCINATION_DATE_INVALID;
                }
                break;
            case MobileConstantUtil.IMMUNISATION_PCV_1:
                from.add(Calendar.DATE, 42);
                to.add(Calendar.DATE, 70);
                if (givenDate != null && (givenDate.after(to.getTime()) || givenDate.before(from.getTime()))) {
                    return VACCINATION_DATE_INVALID;
                }
                break;
            case MobileConstantUtil.IMMUNISATION_PCV_2:
                if (!vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_PCV_1)) {
                    return VACCINATION_INVALID;
                }

                if (vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_PCV_1).after(givenDate)) {
                    return VACCINATION_DATE_INVALID;
                }

                if (getNumberOfDays(vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_PCV_1), givenDate) <= 28) {
                    return VACCINATION_DATE_INVALID;
                }

                from.add(Calendar.DATE, 70);
                to.add(Calendar.DATE, 98);
                if (givenDate != null && (givenDate.after(to.getTime()) || givenDate.before(from.getTime()))) {
                    return VACCINATION_DATE_INVALID;
                }
                break;
            case MobileConstantUtil.IMMUNISATION_PCV_3:
                if (!vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_PCV_2)) {
                    return VACCINATION_INVALID;
                }

                if (vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_PCV_2).after(givenDate)) {
                    return VACCINATION_DATE_INVALID;
                }

                if (getNumberOfDays(vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_PCV_2), givenDate) <= 28) {
                    return VACCINATION_DATE_INVALID;
                }

                from.add(Calendar.DATE, 98);
                to.add(Calendar.DATE, 126);
                if (givenDate != null && (givenDate.after(to.getTime()) || givenDate.before(from.getTime()))) {
                    return VACCINATION_DATE_INVALID;
                }
                break;
            case MobileConstantUtil.IMMUNISATION_DTP_HEPB_HIB_1:
                from.add(Calendar.DATE, 42);
                to.add(Calendar.DATE, 70);
                if (givenDate != null && (givenDate.after(to.getTime()) || givenDate.before(from.getTime()))) {
                    return VACCINATION_DATE_INVALID;
                }
                break;
            case MobileConstantUtil.IMMUNISATION_DTP_HEPB_HIB_2:
                if (!vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_DTP_HEPB_HIB_1)) {
                    return VACCINATION_INVALID;
                }

                if (vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_DTP_HEPB_HIB_1).after(givenDate)) {
                    return VACCINATION_DATE_INVALID;
                }

                if (getNumberOfDays(vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_DTP_HEPB_HIB_1), givenDate) <= 28) {
                    return VACCINATION_DATE_INVALID;
                }

                from.add(Calendar.DATE, 70);
                to.add(Calendar.DATE, 98);
                if (givenDate != null && (givenDate.after(to.getTime()) || givenDate.before(from.getTime()))) {
                    return VACCINATION_DATE_INVALID;
                }
                break;
            case MobileConstantUtil.IMMUNISATION_DTP_HEPB_HIB_3:
                if (!vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_DTP_HEPB_HIB_2)) {
                    return VACCINATION_INVALID;
                }

                if (vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_DTP_HEPB_HIB_2).after(givenDate)) {
                    return VACCINATION_DATE_INVALID;
                }

                if (getNumberOfDays(vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_DTP_HEPB_HIB_2), givenDate) <= 28) {
                    return VACCINATION_DATE_INVALID;
                }

                from.add(Calendar.DATE, 98);
                to.add(Calendar.DATE, 126);
                if (givenDate != null && (givenDate.after(to.getTime()) || givenDate.before(from.getTime()))) {
                    return VACCINATION_DATE_INVALID;
                }
                break;
            case MobileConstantUtil.IMMUNISATION_IPV:
                from.add(Calendar.DATE, 98);
                to.add(Calendar.MONTH,12 );
                if (givenDate != null && (givenDate.after(to.getTime()) || givenDate.before(from.getTime()))) {
                    return VACCINATION_DATE_INVALID;
                }
                break;
            case MobileConstantUtil.IMMUNISATION_MR_1:
                from.add(Calendar.MONTH, 9);
                to.add(Calendar.MONTH,18 );
                if (givenDate != null && (givenDate.after(to.getTime()) || givenDate.before(from.getTime()))) {
                    return VACCINATION_DATE_INVALID;
                }
                break;
            case MobileConstantUtil.IMMUNISATION_MR_2:
                if (!vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_MR_1)) {
                    return VACCINATION_INVALID;
                }

                if (vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_MR_1).after(givenDate)) {
                    return VACCINATION_DATE_INVALID;
                }

                if (getNumberOfDays(vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_MR_1), givenDate) <= 270) {
                    return VACCINATION_DATE_INVALID;
                }

                from.add(Calendar.MONTH,18);
                to.add(Calendar.YEAR, 15);
                if (givenDate != null && (givenDate.after(to.getTime()) || givenDate.before(from.getTime()))) {
                    return VACCINATION_DATE_INVALID;
                }
                break;
            case MobileConstantUtil.IMMUNISATION_JE:
                from.add(Calendar.MONTH, 9);
                to.add(Calendar.YEAR,15 );
                if (givenDate != null && (givenDate.after(to.getTime()) || givenDate.before(from.getTime()))) {
                    return VACCINATION_DATE_INVALID;
                }
                break;
            case MobileConstantUtil.IMMUNISATION_OPV_1:
                if(ConstantUtil.IMPLEMENTATION_TYPE.equals("imomcare")){
                    from.add(Calendar.DATE, 42);
                    to.add(Calendar.DATE, 70);
                    if (givenDate != null && (givenDate.after(to.getTime()) || givenDate.before(from.getTime()))) {
                        return VACCINATION_DATE_INVALID;
                    }
                    break;
                }
                from.add(Calendar.DATE, 42);
                to.add(Calendar.MONTH, 58);
                if (givenDate != null && (givenDate.after(to.getTime()) || givenDate.before(from.getTime()))) {
                    return VACCINATION_DATE_INVALID;
                }
                break;
            case MobileConstantUtil.IMMUNISATION_OPV_2:
                if (!vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_OPV_1)) {
                    return VACCINATION_INVALID;
                }

                if (vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_OPV_1).after(givenDate)) {
                    return VACCINATION_DATE_INVALID;
                }

                if (getNumberOfDays(vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_OPV_1), givenDate) <= 28) {
                    return VACCINATION_DATE_INVALID;
                }
                if(ConstantUtil.IMPLEMENTATION_TYPE.equals("imomcare")){
                    from.add(Calendar.DATE, 70);
                    to.add(Calendar.DATE, 98);
                    if (givenDate != null && (givenDate.after(to.getTime()) || givenDate.before(from.getTime()))) {
                        return VACCINATION_DATE_INVALID;
                    }
                    break;
                }
                from.add(Calendar.DATE, 70);
                to.add(Calendar.MONTH, 59);
                if (givenDate != null && (givenDate.after(to.getTime()) || givenDate.before(from.getTime()))) {
                    return VACCINATION_DATE_INVALID;
                }
                break;
            case MobileConstantUtil.IMMUNISATION_OPV_3:
                if (!vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_OPV_2)) {
                    return VACCINATION_INVALID;
                }

                if (vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_OPV_2).after(givenDate)) {
                    return VACCINATION_DATE_INVALID;
                }

                if (getNumberOfDays(vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_OPV_2), givenDate) <= 28) {
                    return VACCINATION_DATE_INVALID;
                }

                if(ConstantUtil.IMPLEMENTATION_TYPE.equals("imomcare")){
                    from.add(Calendar.DATE, 98);
                    to.add(Calendar.DATE, 135);
                    if (givenDate != null && (givenDate.after(to.getTime()) || givenDate.before(from.getTime()))) {
                        return VACCINATION_DATE_INVALID;
                    }
                    break;
                }

                from.add(Calendar.DATE, 98);
                to.add(Calendar.MONTH, 60);
                if (givenDate != null && (givenDate.after(to.getTime()) || givenDate.before(from.getTime()))) {
                    return VACCINATION_DATE_INVALID;
                }
                break;
            case MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_1:
                from.add(Calendar.DATE, 42);
                to.add(Calendar.MONTH, 12);
                if (givenDate != null && (givenDate.after(to.getTime()) || givenDate.before(from.getTime()))) {
                    return VACCINATION_DATE_INVALID;
                }
                break;
            case MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_2:
                if (!vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_1)) {
                    return VACCINATION_INVALID;
                }

                if (vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_1).after(givenDate)) {
                    return VACCINATION_DATE_INVALID;
                }

                if (getNumberOfDays(vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_1), givenDate) <= 28) {
                    return VACCINATION_DATE_INVALID;
                }

                from.add(Calendar.DATE, 70);
                to.add(Calendar.MONTH, 23);
                if (givenDate != null && (givenDate.after(to.getTime()) || givenDate.before(from.getTime()))) {
                    return VACCINATION_DATE_INVALID;
                }
                break;
            case MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_3:
                if (!vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_2)) {
                    return VACCINATION_INVALID;
                }

                if (vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_2).after(givenDate)) {
                    return VACCINATION_DATE_INVALID;
                }

                if (getNumberOfDays(vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_ROTA_VIRUS_2), givenDate) <= 28) {
                    return VACCINATION_DATE_INVALID;
                }

                from.add(Calendar.DATE, 98);
                to.add(Calendar.MONTH, 24);
                if (givenDate != null && (givenDate.after(to.getTime()) || givenDate.before(from.getTime()))) {
                    return VACCINATION_DATE_INVALID;
                }
                break;
            case MobileConstantUtil.IMMUNISATION_PENTA_1:
                if (vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_DPT_1)
                        || vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_DPT_2)
                        || vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_DPT_3)) {
                    return VACCINATION_INVALID;
                }
                from.add(Calendar.DATE, 42);
                to.add(Calendar.MONTH, 12);
                if (givenDate != null && (givenDate.after(to.getTime()) || givenDate.before(from.getTime()))) {
                    return VACCINATION_DATE_INVALID;
                }
                break;

            case MobileConstantUtil.IMMUNISATION_PENTA_2:
                if (vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_DPT_1)
                        || vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_DPT_2)
                        || vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_DPT_3)) {
                    return VACCINATION_INVALID;
                }

                if (!vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_PENTA_1)) {
                    return VACCINATION_INVALID;
                }

                if (vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_PENTA_1).after(givenDate)) {
                    return VACCINATION_DATE_INVALID;
                }

                if (getNumberOfDays(vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_PENTA_1), givenDate) <= 28) {
                    return VACCINATION_DATE_INVALID;
                }

                from.add(Calendar.DATE, 70);
                to.add(Calendar.MONTH, 59);
                if (givenDate != null && (givenDate.after(to.getTime()) || givenDate.before(from.getTime()))) {
                    return VACCINATION_DATE_INVALID;
                }
                break;

            case MobileConstantUtil.IMMUNISATION_PENTA_3:
                if (vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_DPT_1)
                        || vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_DPT_2)
                        || vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_DPT_3)) {
                    return VACCINATION_INVALID;
                }

                if (!vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_PENTA_2)) {
                    return VACCINATION_INVALID;
                }

                if (vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_PENTA_2).after(givenDate)) {
                    return VACCINATION_DATE_INVALID;
                }

                if (getNumberOfDays(vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_PENTA_2), givenDate) <= 28) {
                    return VACCINATION_DATE_INVALID;
                }

                from.add(Calendar.DATE, 98);
                to.add(Calendar.MONTH, 60);
                if (givenDate != null && (givenDate.after(to.getTime()) || givenDate.before(from.getTime()))) {
                    return VACCINATION_DATE_INVALID;
                }
                break;

            case MobileConstantUtil.IMMUNISATION_DPT_1:
                if (vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_PENTA_1)
                        || vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_PENTA_2)
                        || vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_PENTA_3)) {
                    return VACCINATION_INVALID;
                }
                from.add(Calendar.MONTH, 12);
                to.add(Calendar.MONTH, 82);
                if (givenDate != null && (givenDate.after(to.getTime()) || givenDate.before(from.getTime()))) {
                    return VACCINATION_DATE_INVALID;
                }
                break;

            case MobileConstantUtil.IMMUNISATION_DPT_2:
                if (vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_PENTA_1)
                        || vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_PENTA_2)
                        || vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_PENTA_3)) {
                    return VACCINATION_INVALID;
                }

                if (!vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_DPT_1)) {
                    return VACCINATION_INVALID;
                }

                if (vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_DPT_1).after(givenDate)) {
                    return VACCINATION_DATE_INVALID;
                }

                if (getNumberOfDays(vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_DPT_1), givenDate) <= 28) {
                    return VACCINATION_DATE_INVALID;
                }

                from.add(Calendar.DATE, 13);
                to.add(Calendar.MONTH, 83);
                if (givenDate != null && (givenDate.after(to.getTime()) || givenDate.before(from.getTime()))) {
                    return VACCINATION_DATE_INVALID;
                }
                break;

            case MobileConstantUtil.IMMUNISATION_DPT_3:
                if (vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_PENTA_1)
                        || vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_PENTA_2)
                        || vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_PENTA_3)) {
                    return VACCINATION_INVALID;
                }
                if (!vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_DPT_2)) {
                    return VACCINATION_INVALID;
                }

                if (vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_DPT_2).after(givenDate)) {
                    return VACCINATION_DATE_INVALID;
                }

                if (getNumberOfDays(vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_DPT_2), givenDate) <= 28) {
                    return VACCINATION_DATE_INVALID;
                }

                from.add(Calendar.DATE, 14);
                to.add(Calendar.MONTH, 84);
                if (givenDate != null && (givenDate.after(to.getTime()) || givenDate.before(from.getTime()))) {
                    return VACCINATION_DATE_INVALID;
                }
                break;

            case MobileConstantUtil.IMMUNISATION_F_IPV_1_01:
                if (!vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_OPV_1)) {
                    return VACCINATION_INVALID;
                }

                Date opv1Date = vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_OPV_1);
                Calendar givenDateCalender0 = Calendar.getInstance();
                givenDateCalender0.setTime(givenDate);
                Calendar onlyDate0 = clearTimeFromDate(givenDateCalender0);
                if (opv1Date.after(onlyDate0.getTime()) || opv1Date.before(onlyDate0.getTime())) {
                    return VACCINATION_DATE_INVALID;
                }

                from.add(Calendar.DATE, 42);
                to.add(Calendar.MONTH, 12);
                if (givenDate != null && (givenDate.after(to.getTime()) || givenDate.before(from.getTime()))) {
                    return VACCINATION_DATE_INVALID;
                }
                break;

            case MobileConstantUtil.IMMUNISATION_F_IPV_2_01:
                if (!vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_F_IPV_1_01)) {
                    return VACCINATION_INVALID;
                }

                if (!vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_OPV_3)) {
                    return VACCINATION_INVALID;
                }

                Date opv3Date = vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_OPV_3);
                Calendar givenDateCalender = Calendar.getInstance();
                givenDateCalender.setTime(givenDate);
                Calendar onlyDate = clearTimeFromDate(givenDateCalender);
                if (opv3Date.after(onlyDate.getTime()) || opv3Date.before(onlyDate.getTime())) {
                    return VACCINATION_DATE_INVALID;
                }

                if (vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_F_IPV_1_01).after(givenDate)) {
                    return VACCINATION_DATE_INVALID;
                }

                if (getNumberOfDays(vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_F_IPV_1_01), givenDate) <= 56) {
                    return VACCINATION_DATE_INVALID;
                }

                from.add(Calendar.DATE, 98);
                to.add(Calendar.MONTH, 12);
                if (givenDate != null && (givenDate.after(to.getTime()) || givenDate.before(from.getTime()))) {
                    return VACCINATION_DATE_INVALID;
                }
                break;
            case MobileConstantUtil.IMMUNISATION_F_IPV_2_05:
                if (vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_F_IPV_1_01)
                        || vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_F_IPV_2_01)) {
                    return VACCINATION_INVALID;
                }

                if (!vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_OPV_3)) {
                    return VACCINATION_INVALID;
                }

                if (getNumberOfMonths(dob, givenDate) > 11) {
                    return VACCINATION_DATE_INVALID;
                }

                Date opv3Date2 = vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_OPV_3);
                Calendar givenDateCalender2 = Calendar.getInstance();
                givenDateCalender2.setTime(givenDate);
                Calendar onlyDate2 = clearTimeFromDate(givenDateCalender2);
                if (opv3Date2.after(onlyDate2.getTime()) || opv3Date2.before(onlyDate2.getTime())) {
                    return VACCINATION_DATE_INVALID;
                }
                from.add(Calendar.DATE, 98);
                to.add(Calendar.MONTH, 12);
                if (givenDate != null && (givenDate.after(to.getTime()) || givenDate.before(from.getTime()))) {
                    return VACCINATION_DATE_INVALID;
                }
                break;
            case MobileConstantUtil.IMMUNISATION_VITAMIN_A:
                if (vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_VITAMIN_A)
                        && vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_VITAMIN_A).after(givenDate)) {
                    return VACCINATION_DATE_INVALID;
                }
                from.add(Calendar.MONTH, 8);
                to.add(Calendar.MONTH, 60);
                if (givenDate != null && (givenDate.after(to.getTime()) || givenDate.before(from.getTime()))) {
                    return VACCINATION_DATE_INVALID;
                }
                break;
            case MobileConstantUtil.IMMUNISATION_OPV_BOOSTER:
                if (!vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_OPV_3)) {
                    return VACCINATION_INVALID;
                }
                if (vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_OPV_3)
                        && getNumberOfMonths(vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_OPV_3), givenDate) < 6) {
                    return VACCINATION_DATE_INVALID;
                }
                break;
            case MobileConstantUtil.IMMUNISATION_DPT_BOOSTER:
                if (!(vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_DPT_3)
                        || vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_PENTA_3))) {
                    return VACCINATION_INVALID;
                }
                if (vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_DPT_3)
                        && getNumberOfMonths(vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_DPT_3), givenDate) < 6) {
                    return VACCINATION_DATE_INVALID;
                }
                if (vaccineGivenDateMap.containsKey(MobileConstantUtil.IMMUNISATION_PENTA_3)
                        && getNumberOfMonths(vaccineGivenDateMap.get(MobileConstantUtil.IMMUNISATION_PENTA_3), givenDate) < 6) {
                    return VACCINATION_DATE_INVALID;
                }
                break;
            default:
                return "";
        }
        return null;
    }
}
