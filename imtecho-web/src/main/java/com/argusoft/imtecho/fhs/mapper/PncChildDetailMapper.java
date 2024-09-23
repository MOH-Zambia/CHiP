package com.argusoft.imtecho.fhs.mapper;

import com.argusoft.imtecho.fhs.dto.PncChildDetailsDto;

import java.math.BigDecimal;
import java.util.Date;

public class PncChildDetailMapper {

    /**
     * Convert PNC Child Master entity to PncChildDetailsDto.
     *
     * @param row Object array representing a database row.
     * @return Returns details of PNC child.
     */
    public static PncChildDetailsDto mapFromPncChildMaster(Object[] row) {
        PncChildDetailsDto dto = new PncChildDetailsDto();
        dto.setChildId((Integer) row[0]);
        dto.setIsAlive((Boolean) row[1]);
        dto.setOtherDangerSign((String) row[2]);
        dto.setChildWeight(row[3] != null ? ((BigDecimal) row[3]).floatValue() : null);
        dto.setMemberStatus((String) row[4]);
        dto.setDeathDate((Date) row[5]);
        dto.setDeathReason((String) row[6]);
        dto.setPlaceOfDeath((String) row[7]);
        dto.setReferralPlace((Integer) row[8]);
        dto.setOtherDeathReason((String) row[9]);
        dto.setIsHighRiskCase((Boolean) row[10]);
        dto.setChildReferralDone((String) row[11]);
        return dto;
    }
}
