package com.argusoft.imtecho.fhs.mapper;

import com.argusoft.imtecho.fhs.dto.WpdChildDetailsDto;
import com.argusoft.imtecho.rch.model.WpdChildMaster;

public class WpdChildMapper {

    /**
     * Convert WPD Child Master entity to WpdChildDetailsDto.
     *
     * @param master Entity of WPD child.
     * @return Returns details of WPD child.
     */
    public static WpdChildDetailsDto mapFromWpdChildMaster(WpdChildMaster master) {
        WpdChildDetailsDto dto = new WpdChildDetailsDto();
        dto.setMemberId(master.getMemberId());
        dto.setWpdMotherId(master.getWpdMotherId());
        dto.setPregnancyOutcome(master.getPregnancyOutcome());
        dto.setKangarooCare(master.getKangarooCare());
        dto.setBreastCrawl(master.getBreastCrawl());
        dto.setWasPremature(master.getWasPremature());
        dto.setName(master.getName());
        dto.setTypeOfDelivery(master.getTypeOfDelivery());
        dto.setDeathReason(master.getDeathReason());
        dto.setIsHighRiskCase(master.getIsHighRiskCase());
        dto.setVitaminK1Date(master.getVitaminK1Date());
        dto.setBreastfeedingInHealthCenter(master.getBreastfeedingInHealthCenter());
        dto.setBabyBreatheAtBirth(master.getBabyBreatheAtBirth());
        dto.setSkinToSkin(master.getSkinToSkin());
        return dto;
    }
}
