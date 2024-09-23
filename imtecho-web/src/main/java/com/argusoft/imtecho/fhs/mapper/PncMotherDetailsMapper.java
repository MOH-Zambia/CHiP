package com.argusoft.imtecho.fhs.mapper;

import com.argusoft.imtecho.fhs.dto.PncMotherDetailsDto;

import java.util.Date;

public class PncMotherDetailsMapper {

    /**
     * Convert PNC Mother Master entity to PncMotherDetailsDto.
     *
     * @param row Object array representing a database row.
     * @return Returns details of PNC mother.
     */
    public static PncMotherDetailsDto mapFromPncMotherMaster(Object[] row) {
        PncMotherDetailsDto dto = new PncMotherDetailsDto();
        dto.setMotherId((Integer) row[0]);
        dto.setDateOfDelivery((Date) row[1]);
        dto.setServiceDate((Date) row[2]);
        dto.setIsAlive((Boolean) row[3]);
        dto.setIfaTabletsGiven((Integer) row[4]);
        dto.setOtherDangerSign((String) row[5]);
        dto.setDeathReason((String) row[6]);
        dto.setFpInsertOperateDate((Date) row[7]);
        dto.setFamilyPlanningMethod((String) row[8]);
        dto.setIsHighRiskCase((Boolean) row[9]);
        dto.setBloodTransfusion((Boolean) row[10]);
        dto.setIronDefAnemiaInj((String) row[11]);
        dto.setIronDefAnemiaInjDueDate((Date) row[12]);
        dto.setReceivedMebendazole((Boolean) row[13]);
        dto.setTetanus4Date((Date) row[14]);
        dto.setTetanus5Date((Date) row[15]);
        dto.setCheckForBreastfeeding((Boolean) row[16]);
        dto.setPaymentType((String) row[17]);
        return dto;
    }
}
