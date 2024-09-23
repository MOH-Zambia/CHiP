package com.argusoft.imtecho.fhs.mapper;

import com.argusoft.imtecho.fhs.dto.WpdChildDetailsDto;

import java.util.Date;

public class WpdChildMapper {

    /**
     * Convert WPD Child Master entity to WpdChildDetailsDto.
     *
     * @param row Object array representing a database row.
     * @return Returns details of WPD child.
     */
    public static WpdChildDetailsDto mapFromWpdChildMaster(Object[] row) {
        WpdChildDetailsDto dto = new WpdChildDetailsDto();
        dto.setMemberId((Integer) row[0]);
        dto.setWpdMotherId((Integer) row[1]);
        dto.setPregnancyOutcome((String) row[2]);
        dto.setKangarooCare((Boolean) row[3]);
        dto.setBreastCrawl((Boolean) row[4]);
        dto.setWasPremature((Boolean) row[5]);
        dto.setName((String) row[6]);
        dto.setTypeOfDelivery((String) row[7]);
        dto.setDeathReason((String) row[8]);
        dto.setIsHighRiskCase((Boolean) row[9]);
        dto.setVitaminK1Date((Date) row[10]);
        dto.setBreastfeedingInHealthCenter((Boolean) row[11]);
        dto.setBabyBreatheAtBirth((Boolean) row[12]);
        dto.setSkinToSkin((Boolean) row[13]);
        return dto;
    }
}
