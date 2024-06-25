package com.argusoft.imtecho.fhs.mapper;

import com.argusoft.imtecho.fhs.dto.CovidDto;


public class CovidMapper {

    /**
     * Convert database row to CovidDto.
     *
     * @param row Object array representing a database row.
     * @return Returns details of a COVID case.
     */
    public static CovidDto mapFromObjectArray(Object[] row) {
        CovidDto covidDto = new CovidDto();
        covidDto.setMemberId((Integer) row[0]);
        covidDto.setIsDoseOneTaken((Boolean) row[1]);
        covidDto.setDoseOneName((String) row[2]);
        covidDto.setIsDoseTwoTaken((Boolean) row[3]);
        covidDto.setDoseTwoName((String) row[4]);
        covidDto.setWillingForBoosterVaccine((Boolean) row[5]);
        covidDto.setIsBoosterDoseGiven((Boolean) row[6]);
        covidDto.setBoosterName((String) row[7]);
        covidDto.setAnyReactions((Boolean) row[8]);

        return covidDto;
    }
}
