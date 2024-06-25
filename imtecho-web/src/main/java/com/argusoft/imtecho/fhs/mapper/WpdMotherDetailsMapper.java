package com.argusoft.imtecho.fhs.mapper;

import com.argusoft.imtecho.fhs.dto.WpdMotherDetailsDto;
import com.argusoft.imtecho.rch.model.WpdMotherMaster;

public class WpdMotherDetailsMapper {

    /**
     * Convert WPD Mother Master entity to WpdMotherDetailsDto.
     *
     * @param master Entity of WPD mother.
     * @return Returns details of WPD mother.
     */
    public static WpdMotherDetailsDto mapFromWpdMotherMaster(WpdMotherMaster master) {
        WpdMotherDetailsDto dto = new WpdMotherDetailsDto();
        dto.setDateOfDelivery(master.getDateOfDelivery());
        dto.setHasDeliveryHappened(master.getHasDeliveryHappened());
        dto.setCorticoSteroidGiven(master.getCorticoSteroidGiven());
        dto.setIsPretermBirth(master.getIsPretermBirth());
        dto.setDeliveryPlace(master.getDeliveryPlace());
        dto.setInstitutionalDeliveryPlace(master.getInstitutionalDeliveryPlace());
        dto.setTypeOfHospital(master.getTypeOfHospital());
        dto.setDeliveryDoneBy(master.getDeliveryDoneBy());
        dto.setTypeOfDelivery(master.getTypeOfDelivery());
        dto.setMotherAlive(master.getMotherAlive());
        dto.setOtherDangerSigns(master.getOtherDangerSigns());
        dto.setIsDischarged(master.getIsDischarged());
        dto.setDischargeDate(master.getDischargeDate());
        dto.setBreastFeedingInOneHour(master.getBreastFeedingInOneHour());
        dto.setMtpDoneAt(master.getMtpDoneAt());
        dto.setMtpPerformedBy(master.getMtpPerformedBy());
        dto.setDeathReason(master.getDeathReason());
        dto.setIsHighRiskCase(master.getIsHighRiskCase());
        dto.setPregnancyRegDetId(master.getPregnancyRegDetId());
        dto.setPregnancyOutcome(master.getPregnancyOutcome());
        dto.setMisoprostolGiven(master.getMisoprostolGiven());
        dto.setFreeDropDelivery(master.getFreeDropDelivery());
        dto.setDeliveryPerson(master.getDeliveryPerson());
        dto.setDeliveryPersonName(master.getDeliveryPersonName());
        dto.setWasARTGiven(master.getWasARTGiven());
        dto.setHivDuringDelivery(master.getHivDuringDelivery());
        dto.setIsARTGivenDelivery(master.getIsARTGivenDelivery());
        dto.setPaymentType(master.getPaymentType());

        return dto;
    }
}
