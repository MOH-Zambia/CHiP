package com.argusoft.imtecho.mobile.mapper;

import com.argusoft.imtecho.mobile.dto.*;
import com.argusoft.imtecho.rch.model.*;

/**
 * @author prateek on 14 Dec, 2018
 */
public class RchDataBeanMapper {

    private RchDataBeanMapper() {
        throw new IllegalStateException("Utility Class");
    }

    public static RchAncDataBean convertAncVisitToRchAncDataBean(AncVisit ancVisit) {

        if (ancVisit == null) {
            return null;
        }

        RchAncDataBean rchAncDataBean = new RchAncDataBean();
        rchAncDataBean.setId(ancVisit.getId());
        rchAncDataBean.setMemberId(ancVisit.getMemberId());
        rchAncDataBean.setFamilyId(ancVisit.getFamilyId());
        rchAncDataBean.setLocationId(ancVisit.getLocationId());
        rchAncDataBean.setBloodGroup(ancVisit.getBloodGroup());
        rchAncDataBean.setWeight(ancVisit.getWeight());
        rchAncDataBean.setHaemoglobinCount(ancVisit.getHaemoglobinCount());
        rchAncDataBean.setSystolicBp(ancVisit.getSystolicBp());
        rchAncDataBean.setDiastolicBp(ancVisit.getDiastolicBp());
        rchAncDataBean.setMemberHeight(ancVisit.getMemberHeight());
        rchAncDataBean.setHbsagTest(ancVisit.getHbsagTest());
        rchAncDataBean.setBloodSugarTest(ancVisit.getBloodSugarTest());
        rchAncDataBean.setSugarTestBeforeFoodValue(ancVisit.getSugarTestBeforeFoodValue());
        rchAncDataBean.setSugarTestAfterFoodValue(ancVisit.getSugarTestAfterFoodValue());
        rchAncDataBean.setUrineTestDone(ancVisit.getUrineTestDone());
        rchAncDataBean.setUrineAlbumin(ancVisit.getUrineAlbumin());
        rchAncDataBean.setUrineSugar(ancVisit.getUrineSugar());
        rchAncDataBean.setVdrlTest(ancVisit.getVdrlTest());
        rchAncDataBean.setHivTest(ancVisit.getHivTest());
        rchAncDataBean.setIsHighRiskCase(ancVisit.getIsHighRiskCase());

        if (ancVisit.getServiceDate() != null) {
            rchAncDataBean.setServiceDate(ancVisit.getServiceDate().getTime());
        }
        if (ancVisit.getLmp() != null) {
            rchAncDataBean.setLmp(ancVisit.getLmp().getTime());
        }

        return rchAncDataBean;
    }

    public static RchLmpfuDataBean convertLmpFollowUpVisitToRchLmpfuDataBean(LmpFollowUpVisit lmpFollowUpVisit) {

        if (lmpFollowUpVisit == null) {
            return null;
        }

        RchLmpfuDataBean rchLmpfuDataBean = new RchLmpfuDataBean();
        rchLmpfuDataBean.setId(lmpFollowUpVisit.getId());
        rchLmpfuDataBean.setMemberId(lmpFollowUpVisit.getMemberId());
        rchLmpfuDataBean.setFamilyId(lmpFollowUpVisit.getFamilyId());
        rchLmpfuDataBean.setLocationId(lmpFollowUpVisit.getLocationId());

        if (lmpFollowUpVisit.getServiceDate() != null) {
            rchLmpfuDataBean.setServiceDate(lmpFollowUpVisit.getServiceDate().getTime());
        }

        if (lmpFollowUpVisit.getServiceDate() != null) {
            rchLmpfuDataBean.setServiceDate(lmpFollowUpVisit.getServiceDate().getTime());
        }

        return rchLmpfuDataBean;
    }

    public static RchWpdMotherDataBean convertWpdMotherMasterToRchWpdMotherDataBean(WpdMotherMaster wpdMotherMaster) {

        if (wpdMotherMaster == null) {
            return null;
        }

        RchWpdMotherDataBean rchWpdMotherDataBean = new RchWpdMotherDataBean();
        rchWpdMotherDataBean.setId(wpdMotherMaster.getId());
        rchWpdMotherDataBean.setMemberId(wpdMotherMaster.getMemberId());
        rchWpdMotherDataBean.setFamilyId(wpdMotherMaster.getFamilyId());
        rchWpdMotherDataBean.setLocationId(wpdMotherMaster.getLocationId());
        rchWpdMotherDataBean.setTypeOfDelivery(wpdMotherMaster.getTypeOfDelivery());
        rchWpdMotherDataBean.setDeliveryDoneBy(wpdMotherMaster.getDeliveryDoneBy());
        rchWpdMotherDataBean.setDeliveryPlace(wpdMotherMaster.getDeliveryPlace());
        rchWpdMotherDataBean.setTypeOfHospital(wpdMotherMaster.getTypeOfHospital());
        rchWpdMotherDataBean.setPregnancyOutcome(wpdMotherMaster.getPregnancyOutcome());
        rchWpdMotherDataBean.setIsHighRiskCase(wpdMotherMaster.getIsHighRiskCase());
        rchWpdMotherDataBean.setIsDischarged(wpdMotherMaster.getIsDischarged());

        if (wpdMotherMaster.getDateOfDelivery() != null) {
            rchWpdMotherDataBean.setDateOfDelivery(wpdMotherMaster.getDateOfDelivery().getTime());
        }

        if (wpdMotherMaster.getDischargeDate() != null) {
            rchWpdMotherDataBean.setDischargeDate(wpdMotherMaster.getDischargeDate().getTime());
        }

        return rchWpdMotherDataBean;
    }

    public static RchWpdChildDataBean convertWpdChildMasterToRchWpdChildDataBean(WpdChildMaster wpdChildMaster) {

        if (wpdChildMaster == null) {
            return null;
        }

        RchWpdChildDataBean rchWpdChildDataBean = new RchWpdChildDataBean();
        rchWpdChildDataBean.setId(wpdChildMaster.getId());
        rchWpdChildDataBean.setMotherId(wpdChildMaster.getMotherId());
        rchWpdChildDataBean.setWpdMotherId(wpdChildMaster.getWpdMotherId());
        rchWpdChildDataBean.setGender(wpdChildMaster.getGender());
        rchWpdChildDataBean.setBirthWeight(wpdChildMaster.getBirthWeight());
        rchWpdChildDataBean.setIsHighRiskCase(wpdChildMaster.getIsHighRiskCase());

        if (wpdChildMaster.getDateOfDelivery() != null) {
            rchWpdChildDataBean.setDateOfDelivery(wpdChildMaster.getDateOfDelivery().getTime());
        }

        return rchWpdChildDataBean;
    }

    public static RchPncDataBean convertPncMasterToRchPncDataBean(PncMaster pncMaster) {

        if (pncMaster == null) {
            return null;
        }

        RchPncDataBean rchPncDataBean = new RchPncDataBean();
        rchPncDataBean.setId(pncMaster.getId());
        rchPncDataBean.setMemberId(pncMaster.getMemberId());
        rchPncDataBean.setFamilyId(pncMaster.getFamilyId());
        rchPncDataBean.setLocationId(pncMaster.getLocationId());

        if (pncMaster.getServiceDate() != null) {
            rchPncDataBean.setServiceDate(pncMaster.getServiceDate().getTime());
        }

        return rchPncDataBean;
    }

    public static RchPncMotherDataBean convertPncMotherMasterToRchPncMotherDataBean(PncMotherMaster pncMotherMaster) {

        if (pncMotherMaster == null) {
            return null;
        }

        RchPncMotherDataBean rchPncMotherDataBean = new RchPncMotherDataBean();
        rchPncMotherDataBean.setId(pncMotherMaster.getId());
        rchPncMotherDataBean.setPncId(pncMotherMaster.getPncMasterId());
        rchPncMotherDataBean.setMotherId(pncMotherMaster.getMotherId());
        rchPncMotherDataBean.setFamilyPlanningMethod(pncMotherMaster.getFamilyPlanningMethod());
        rchPncMotherDataBean.setIsHighRiskCase(pncMotherMaster.getIsHighRiskCase());

        if (pncMotherMaster.getServiceDate() != null) {
            rchPncMotherDataBean.setServiceDate(pncMotherMaster.getServiceDate().getTime());
        }
        return rchPncMotherDataBean;
    }

    public static RchPncChildDataBean convertPncChildMasterToRchPncChildDataBean(PncChildMaster pncChildMaster) {

        if (pncChildMaster == null) {
            return null;
        }

        RchPncChildDataBean rchPncChildDataBean = new RchPncChildDataBean();
        rchPncChildDataBean.setId(pncChildMaster.getId());
        rchPncChildDataBean.setPncMasterId(pncChildMaster.getPncMasterId());
        rchPncChildDataBean.setChildId(pncChildMaster.getChildId());
        rchPncChildDataBean.setChildWeight(pncChildMaster.getChildWeight());
        rchPncChildDataBean.setIsHighRiskCase(pncChildMaster.getIsHighRiskCase());

        return rchPncChildDataBean;
    }

    public static RchCsDataBean convertChildServiceMasterToRchCsDataBean(ChildServiceMaster childServiceMaster) {

        if (childServiceMaster == null) {
            return null;
        }

        RchCsDataBean rchCsDataBean = new RchCsDataBean();
        rchCsDataBean.setId(childServiceMaster.getId());
        rchCsDataBean.setMemberId(childServiceMaster.getMemberId());
        rchCsDataBean.setFamilyId(childServiceMaster.getFamilyId());
        rchCsDataBean.setLocationId(childServiceMaster.getLocationId());
        rchCsDataBean.setWeight(childServiceMaster.getWeight());
        rchCsDataBean.setMidArmCircumference(childServiceMaster.getMidArmCircumference());
        rchCsDataBean.setHeight(childServiceMaster.getHeight());
        rchCsDataBean.setHavePedalEdema(childServiceMaster.getHavePedalEdema());
        rchCsDataBean.setExclusivelyBreastfeded(childServiceMaster.getExclusivelyBreastfeded());
        rchCsDataBean.setAnyVaccinationPending(childServiceMaster.getAnyVaccinationPending());

        if (rchCsDataBean.getServiceDate() != null) {
            rchCsDataBean.setServiceDate(childServiceMaster.getServiceDate().getTime());
        }

        return rchCsDataBean;
    }
}
