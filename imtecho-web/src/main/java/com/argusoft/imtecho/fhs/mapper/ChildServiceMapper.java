package com.argusoft.imtecho.fhs.mapper;

import com.argusoft.imtecho.fhs.dto.ChildServiceDto;

import java.math.BigDecimal;

public class ChildServiceMapper {


    /**
     * Convert Child Service Master entity to ChildServiceDto.
     *
     * @param row Object array representing a database row.
     * @return Returns details of child service.
     */
    public static ChildServiceDto mapFromChildServiceMaster(Object[] row) {
        ChildServiceDto dto = new ChildServiceDto();
        dto.setMemberId((Integer) row[0]);
        dto.setIsAlive((Boolean) row[1]);
        dto.setDeathReason((String) row[2]);
        dto.setWeight(row[3] != null ? ((BigDecimal) row[3]).floatValue() : null);
        dto.setIfaSyrupGiven((Boolean) row[4]);
        dto.setComplementaryFeedingStarted((Boolean) row[5]);
        dto.setComplementaryFeedingStartPeriod((String) row[6]);
        dto.setOtherDiseases((String) row[7]);
        dto.setIsTreatementDone((String) row[8]);
        dto.setHeight((Integer) row[9]);
        dto.setHavePedalEdema((Boolean) row[10]);
        dto.setExclusivelyBreastfeded((Boolean) row[11]);
        dto.setAnyVaccinationPending((Boolean) row[12]);
        dto.setSdScore((String) row[13]);
        dto.setDeliveryPlace((String) row[14]);
        dto.setDeliveryDoneBy((String) row[15]);
        dto.setDeliveryPerson((Integer) row[16]);
        dto.setDeliveryPersonName((String) row[17]);

        return dto;
    }
}
