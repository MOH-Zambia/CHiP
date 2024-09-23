package com.argusoft.imtecho.fhs.mapper;

import com.argusoft.imtecho.fhs.dto.HivDto;

public class HivDetailsMapper {

    /**
     * Convert HivScreeningEntity to HivDto.
     *
     * @param row Object array representing a database row.
     * @return Returns details of HIV screening.
     */
    public static HivDto getHivDto(Object[] row){
        HivDto dto = new HivDto();
        dto.setMemberId((Integer) row[1]);
        dto.setChildHivTest((Boolean) row[2]);
        dto.setHivTestResult((Boolean) row[3]);
        dto.setChildMotherHivPositive((Boolean) row[6]);
        dto.setChildHasTbSymptoms((Boolean) row[8]);
        dto.setChildSick((Boolean) row[9]);
        dto.setChildRashes((Boolean) row[10]);
        dto.setPusNearEar((Boolean) row[11]);
        dto.setEverToldHivPositive((Boolean) row[14]);
        dto.setTestedForHivIn12Months((Boolean) row[17]);
        dto.setSymptoms((Boolean) row[18]);
        dto.setPrivatePartsSymptoms((Boolean) row[19]);
        dto.setExposedToHiv((Boolean) row[20]);
        dto.setUnprotectedSexInLast6Months((Boolean) row[21]);
        dto.setPregnantOrBreastfeeding((Boolean) row[22]);

        return dto;
    }
}
