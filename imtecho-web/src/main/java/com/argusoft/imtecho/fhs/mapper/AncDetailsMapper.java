package com.argusoft.imtecho.fhs.mapper;

import com.argusoft.imtecho.fhs.dto.AncDto;
import com.argusoft.imtecho.rch.model.AncVisit;

public class AncDetailsMapper {

    /**
     * Convert ANC Visit entity to AncDto.
     *
     * @param ancVisit Entity of ANC visit.
     * @return Returns details of ANC visit.
     */
    public static AncDto mapFromAncVisit(AncVisit ancVisit) {
        AncDto ancDto = new AncDto();
        ancDto.setMemberId(ancVisit.getMemberId());
        ancDto.setLmp(ancVisit.getLmp());
        ancDto.setLastDeliveryOutcome(ancVisit.getLastDeliveryOutcome());
        ancDto.setPreviousPregnancyComplication(ancVisit.getPreviousPregnancyComplication());
        ancDto.setOtherPreviousPregnancyComplication(ancVisit.getOtherPreviousPregnancyComplication());
        ancDto.setAncPlace(ancVisit.getAncPlace());
        ancDto.setWeight(ancVisit.getWeight());
        ancDto.setHaemoglobinCount(ancVisit.getHaemoglobinCount());
        ancDto.setSystolicBp(ancVisit.getSystolicBp());
        ancDto.setDiastolicBp(ancVisit.getDiastolicBp());
        ancDto.setMemberHeight(ancVisit.getMemberHeight());
        ancDto.setFoetalMovement(ancVisit.getFoetalMovement());
        ancDto.setFoetalHeight(ancVisit.getFoetalHeight());
        ancDto.setFoetalHeartSound(ancVisit.getFoetalHeartSound());
        ancDto.setFoetalPosition(ancVisit.getFoetalPosition());
        ancDto.setIfaTabletsGiven(ancVisit.getIfaTabletsGiven());
        ancDto.setFaTabletsGiven(ancVisit.getFaTabletsGiven());
        ancDto.setCalciumTabletsGiven(ancVisit.getCalciumTabletsGiven());
        ancDto.setHbsagTest(ancVisit.getHbsagTest());
        ancDto.setBloodSugarTest(ancVisit.getBloodSugarTest());
        ancDto.setSugarTestAfterFoodValue(ancVisit.getSugarTestAfterFoodValue());
        ancDto.setSugarTestBeforeFoodValue(ancVisit.getSugarTestBeforeFoodValue());
        ancDto.setUrineTestDone(ancVisit.getUrineTestDone());
        ancDto.setUrineAlbumin(ancVisit.getUrineAlbumin());
        ancDto.setUrineSugar(ancVisit.getUrineSugar());
        ancDto.setVdrlTest(ancVisit.getVdrlTest());
        ancDto.setSickleCellTest(ancVisit.getSickleCellTest());
        ancDto.setHivTest(ancVisit.getHivTest());
        ancDto.setAlbendazoleGiven(ancVisit.getAlbendazoleGiven());
        ancDto.setMebendazole1Given(ancVisit.getMebendazole1Given());
        ancDto.setMebendazole1Date(ancVisit.getMebendazole1Date());
        ancDto.setMebendazole2Given(ancVisit.getMebendazole2Given());
        ancDto.setMebendazole2Date(ancVisit.getMebendazole2Date());
        return ancDto;
    }


}
