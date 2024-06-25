package com.argusoft.imtecho.fhs.mapper;

import com.argusoft.imtecho.fhs.dto.PncMotherDetailsDto;
import com.argusoft.imtecho.rch.model.PncMotherMaster;

public class PncMotherDetailsMapper {

    /**
     * Convert PNC Mother Master entity to PncMotherDetailsDto.
     *
     * @param pncMotherMaster Entity of PNC mother.
     * @return Returns details of PNC mother.
     */
    public static PncMotherDetailsDto mapFromPncMotherMaster(PncMotherMaster pncMotherMaster) {
        PncMotherDetailsDto dto = new PncMotherDetailsDto();
        dto.setMotherId(pncMotherMaster.getMotherId());
        dto.setDateOfDelivery(pncMotherMaster.getDateOfDelivery());
        dto.setServiceDate(pncMotherMaster.getServiceDate());
        dto.setIsAlive(pncMotherMaster.getIsAlive());
        dto.setIfaTabletsGiven(pncMotherMaster.getIfaTabletsGiven());
        dto.setOtherDangerSign(pncMotherMaster.getOtherDangerSign());
        dto.setDeathReason(pncMotherMaster.getDeathReason());
        dto.setFpInsertOperateDate(pncMotherMaster.getFpInsertOperateDate());
        dto.setFamilyPlanningMethod(pncMotherMaster.getFamilyPlanningMethod());
        dto.setIsHighRiskCase(pncMotherMaster.getIsHighRiskCase());
        dto.setBloodTransfusion(pncMotherMaster.getBloodTransfusion());
        dto.setIronDefAnemiaInj(pncMotherMaster.getIronDefAnemiaInj());
        dto.setIronDefAnemiaInjDueDate(pncMotherMaster.getIronDefAnemiaInjDueDate());
        dto.setReceivedMebendazole(pncMotherMaster.getReceivedMebendazole());
        dto.setTetanus4Date(pncMotherMaster.getTetanus4Date());
        dto.setTetanus5Date(pncMotherMaster.getTetanus5Date());
        dto.setCheckForBreastfeeding(pncMotherMaster.getCheckForBreastfeeding());
        dto.setPaymentType(pncMotherMaster.getPaymentType());
        return dto;
    }
}
