package com.argusoft.imtecho.fhs.mapper;

import com.argusoft.imtecho.fhs.dto.AncDto;

import java.math.BigDecimal;
import java.util.Date;

public class AncDetailsMapper {

    /**
     * Convert ANC Visit entity to AncDto.
     *
     * @param row Object array representing a database row.
     * @return Returns details of ANC visit.
     */
    public static AncDto mapFromAncVisit(Object[] row) {
        AncDto ancDto = new AncDto();
        ancDto.setMemberId((Integer) row[0]);
        ancDto.setLmp((Date) row[1]);
        ancDto.setLastDeliveryOutcome((String) row[2]);
        ancDto.setOtherPreviousPregnancyComplication((String) row[3]);
        ancDto.setAncPlace((Integer) row[4]);
        ancDto.setWeight(row[5] != null ? ((BigDecimal) row[5]).floatValue() : null);
        ancDto.setHaemoglobinCount(row[6] != null ? ((BigDecimal) row[6]).floatValue() : null);
        ancDto.setSystolicBp((Integer) row[7]);
        ancDto.setDiastolicBp((Integer) row[8]);
        ancDto.setMemberHeight((Integer) row[9]);
        ancDto.setFoetalMovement((String) row[10]);
        ancDto.setFoetalHeight((Integer) row[11]);
        ancDto.setFoetalHeartSound((Boolean) row[12]);
        ancDto.setFoetalPosition((String) row[13]);
        ancDto.setIfaTabletsGiven((Integer) row[14]);
        ancDto.setFaTabletsGiven((Integer) row[15]);
        ancDto.setCalciumTabletsGiven((Integer) row[16]);
        ancDto.setHbsagTest((String) row[17]);
        ancDto.setBloodSugarTest((String) row[18]);
        ancDto.setSugarTestAfterFoodValue((Integer) row[19]);
        ancDto.setSugarTestBeforeFoodValue((Integer) row[20]);
        ancDto.setUrineTestDone((Boolean) row[21]);
        ancDto.setUrineAlbumin((String) row[22]);
        ancDto.setUrineSugar((String) row[23]);
        ancDto.setVdrlTest((String) row[24]);
        ancDto.setSickleCellTest((String) row[25]);
        ancDto.setHivTest((String) row[26]);
        ancDto.setAlbendazoleGiven((Boolean) row[27]);
        ancDto.setMebendazole1Given((Boolean) row[28]);
        ancDto.setMebendazole1Date((Date) row[29]);
        ancDto.setMebendazole2Given((Boolean) row[30]);
        ancDto.setMebendazole2Date((Date) row[31]);
        return ancDto;
    }


}
