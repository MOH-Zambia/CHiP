package com.argusoft.imtecho.fhs.mapper;

import com.argusoft.imtecho.fhs.dto.WpdMotherDetailsDto;

import java.util.Date;

public class WpdMotherDetailsMapper {

    /**
     * Convert WPD Mother Master entity to WpdMotherDetailsDto.
     *
     * @param row Object array representing a database row.
     * @return Returns details of WPD mother.
     */
    public static WpdMotherDetailsDto mapFromWpdMotherMaster(Object[] row) {
        WpdMotherDetailsDto dto = new WpdMotherDetailsDto();
        dto.setMemberId((Integer) row[28]);
        dto.setDateOfDelivery((Date) row[0]);
        dto.setHasDeliveryHappened((Boolean) row[1]);
        dto.setCorticoSteroidGiven((Boolean) row[2]);
        dto.setIsPretermBirth((Boolean) row[3]);
        dto.setDeliveryPlace((String) row[4]);
        dto.setInstitutionalDeliveryPlace((String) row[5]);
        dto.setTypeOfHospital((Integer) row[6]);
        dto.setDeliveryDoneBy((String) row[7]);
        dto.setTypeOfDelivery((String) row[8]);
        dto.setMotherAlive((Boolean) row[9]);
        dto.setOtherDangerSigns((String) row[10]);
        dto.setIsDischarged((Boolean) row[11]);
        dto.setDischargeDate((Date) row[12]);
        dto.setBreastFeedingInOneHour((Boolean) row[13]);
        dto.setMtpDoneAt((Integer) row[14]);
        dto.setMtpPerformedBy((String) row[15]);
        dto.setDeathReason((String) row[16]);
        dto.setIsHighRiskCase((Boolean) row[17]);
        dto.setPregnancyRegDetId((Integer) row[18]);
        dto.setPregnancyOutcome((String) row[19]);
        dto.setMisoprostolGiven((Boolean) row[20]);
        dto.setFreeDropDelivery((String) row[21]);
        dto.setDeliveryPerson((Integer) row[22]);
        dto.setDeliveryPersonName((String) row[23]);
        dto.setWasARTGiven((Boolean) row[24]);
        dto.setHivDuringDelivery((String) row[25]);
        dto.setIsARTGivenDelivery((Boolean) row[26]);
        dto.setPaymentType((String) row[27]);

        return dto;
    }
}
