package com.argusoft.imtecho.fhs.mapper;

import com.argusoft.imtecho.fhs.dto.TuberculosisDto;


public class TBMapper {

    /**
     * Convert database row to TuberculosisDto.
     *
     * @param row Object array representing a database row.
     * @return Returns details of a tuberculosis case.
     */
    public static TuberculosisDto mapFromObjectArray(Object[] row) {
        TuberculosisDto tuberculosisDto = new TuberculosisDto();
        tuberculosisDto.setMemberId((Integer) row[0]);
        tuberculosisDto.setTbSymptoms((String) row[1]);
        tuberculosisDto.setIsTbCured((Boolean) row[2]);

        return tuberculosisDto;
    }
}
