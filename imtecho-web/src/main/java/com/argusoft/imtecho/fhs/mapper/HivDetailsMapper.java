package com.argusoft.imtecho.fhs.mapper;

import com.argusoft.imtecho.fhs.dto.HivDto;
import com.argusoft.imtecho.rch.model.HivScreeningEntity;

public class HivDetailsMapper {

    /**
     * Convert HivScreeningEntity to HivDto.
     *
     * @param hivScreening Entity of HIV screening.
     * @return Returns details of HIV screening.
     */
    public static HivDto getHivDto(HivScreeningEntity hivScreening){
        HivDto dto = new HivDto();
        dto.setChildHivTest(hivScreening.isChildHivTest());
        dto.setHivTestResult(hivScreening.isHivTestResult());
        dto.setChildMotherHivPositive(hivScreening.isChildMotherHivPositive());
        dto.setChildHasTbSymptoms(hivScreening.isChildHasTbSymptoms());
        dto.setChildSick(hivScreening.isChildSick());
        dto.setChildRashes(hivScreening.isChildRashes());
        dto.setPusNearEar(hivScreening.isPusNearEar());
        dto.setEverToldHivPositive(hivScreening.isEverToldHivPositive());
        dto.setTestedForHivIn12Months(hivScreening.isTestedForHivIn12Months());
        dto.setSymptoms(hivScreening.isSymptoms());
        dto.setPrivatePartsSymptoms(hivScreening.isPrivatePartsSymptoms());
        dto.setExposedToHiv(hivScreening.isExposedToHiv());
        dto.setUnprotectedSexInLast6Months(hivScreening.isUnprotectedSexInLast6Months());
        dto.setPregnantOrBreastfeeding(hivScreening.isPregnantOrBreastfeeding());

        return dto;
    }
}
