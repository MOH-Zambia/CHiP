package com.argusoft.imtecho.fhs.mapper;

import com.argusoft.imtecho.fhs.dto.ChildServiceDto;
import com.argusoft.imtecho.rch.model.ChildServiceMaster;

public class ChildServiceMapper {


    /**
     * Convert Child Service Master entity to ChildServiceDto.
     *
     * @param childServiceMaster Entity of child service.
     * @return Returns details of child service.
     */
    public static ChildServiceDto mapFromChildServiceMaster(ChildServiceMaster childServiceMaster) {
        ChildServiceDto childServiceDto = new ChildServiceDto();
        childServiceDto.setMemberId(childServiceMaster.getMemberId());
        childServiceDto.setIsAlive(childServiceMaster.getIsAlive());
        childServiceDto.setDeathReason(childServiceMaster.getDeathReason());
        childServiceDto.setWeight(childServiceMaster.getWeight());
        childServiceDto.setIfaSyrupGiven(childServiceMaster.getIfaSyrupGiven());
        childServiceDto.setComplementaryFeedingStarted(childServiceMaster.getComplementaryFeedingStarted());
        childServiceDto.setComplementaryFeedingStartPeriod(childServiceMaster.getComplementaryFeedingStartPeriod());
        childServiceDto.setDieseases(childServiceMaster.getDieseases());
        childServiceDto.setOtherDiseases(childServiceMaster.getOtherDiseases());
        childServiceDto.setIsTreatementDone(childServiceMaster.getIsTreatementDone());
        childServiceDto.setHeight(childServiceMaster.getHeight());
        childServiceDto.setHavePedalEdema(childServiceMaster.getHavePedalEdema());
        childServiceDto.setExclusivelyBreastfeded(childServiceMaster.getExclusivelyBreastfeded());
        childServiceDto.setAnyVaccinationPending(childServiceMaster.getAnyVaccinationPending());
        childServiceDto.setSdScore(childServiceMaster.getSdScore());
        childServiceDto.setDeliveryPlace(childServiceMaster.getDeliveryPlace());
        childServiceDto.setDeliveryDoneBy(childServiceMaster.getDeliveryDoneBy());
        childServiceDto.setDeliveryPerson(childServiceMaster.getDeliveryPerson());
        childServiceDto.setDeliveryPersonName(childServiceMaster.getDeliveryPersonName());

        return childServiceDto;
    }
}
