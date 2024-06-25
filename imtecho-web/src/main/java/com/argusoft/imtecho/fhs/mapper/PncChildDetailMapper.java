package com.argusoft.imtecho.fhs.mapper;

import com.argusoft.imtecho.fhs.dto.PncChildDetailsDto;
import com.argusoft.imtecho.rch.model.PncChildMaster;

public class PncChildDetailMapper {

    /**
     * Convert PNC Child Master entity to PncChildDetailsDto.
     *
     * @param pncChildMaster Entity of PNC child.
     * @return Returns details of PNC child.
     */
    public static PncChildDetailsDto mapFromPncChildMaster(PncChildMaster pncChildMaster) {
        PncChildDetailsDto dto = new PncChildDetailsDto();
        dto.setChildId(pncChildMaster.getChildId());
        dto.setIsAlive(pncChildMaster.getIsAlive());
        dto.setOtherDangerSign(pncChildMaster.getOtherDangerSign());
        dto.setChildWeight(pncChildMaster.getChildWeight());
        dto.setMemberStatus(pncChildMaster.getMemberStatus());
        dto.setDeathDate(pncChildMaster.getDeathDate());
        dto.setDeathReason(pncChildMaster.getDeathReason());
        dto.setPlaceOfDeath(pncChildMaster.getPlaceOfDeath());
        dto.setReferralPlace(pncChildMaster.getReferralPlace());
        dto.setOtherDeathReason(pncChildMaster.getOtherDeathReason());
        dto.setIsHighRiskCase(pncChildMaster.getIsHighRiskCase());
        dto.setChildReferralDone(pncChildMaster.getChildReferralDone());
        dto.setChildDangerSigns(pncChildMaster.getChildDangerSigns());
        return dto;
    }
}
