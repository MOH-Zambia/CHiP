package com.argusoft.imtecho.fhs.mapper;

import com.argusoft.imtecho.fhs.dto.MalariaDto;

import java.util.Objects;

public class MalariaMapper {

    /**
     * Convert database row to MalariaDto.
     *
     * @param row Object array representing a database row.
     * @return Returns details of a malaria case.
     */
    public static MalariaDto mapFromObjectArray(Object[] row) {
        MalariaDto malariaDto = new MalariaDto();

        malariaDto.setMemberId((Integer) row[0]);
        malariaDto.setActiveMalariaSymptoms((String) row[1]);
        malariaDto.setRdtTestStatus((String) row[2]);
        malariaDto.setIsTreatmentGiven(Objects.equals(row[3], Boolean.TRUE));
        malariaDto.setMalariaType((String) row[4]);

        return malariaDto;
    }
}
