package com.argusoft.imtecho.formconfigurator.mapper;

import com.argusoft.imtecho.formconfigurator.dto.MedplatFieldKeyDto;
import com.argusoft.imtecho.formconfigurator.dto.MedplatFieldKeyMapDto;
import com.argusoft.imtecho.formconfigurator.models.MedplatFieldKeyMaster;
import com.argusoft.imtecho.formconfigurator.models.MedplatFieldMaster;

import java.util.ArrayList;
import java.util.List;

public class MedplatFormConfiguratorMapper {
    public static MedplatFieldKeyMapDto convertToMedplatFieldKeyMapDto(List<MedplatFieldKeyMaster> fieldKeyMasters, MedplatFieldMaster fieldMaster) {
        MedplatFieldKeyMapDto medplatFieldKeyMapDto = new MedplatFieldKeyMapDto();
        medplatFieldKeyMapDto.setFieldCode(fieldMaster.getFieldCode());
        medplatFieldKeyMapDto.setFieldName(fieldMaster.getFieldName());
        medplatFieldKeyMapDto.setFieldKeyDto(convertToMedplatFieldKeyDtos(fieldKeyMasters));
        return medplatFieldKeyMapDto;
    }

    private static List<MedplatFieldKeyDto> convertToMedplatFieldKeyDtos(List<MedplatFieldKeyMaster> fieldKeyMasters) {
        List<MedplatFieldKeyDto> medplatFieldKeyDtos = new ArrayList<>();
        fieldKeyMasters.forEach(f -> {
            MedplatFieldKeyDto medplatFieldKeyDto = new MedplatFieldKeyDto();
            medplatFieldKeyDto.setFieldKeyCode(f.getFieldKeyCode());
            medplatFieldKeyDto.setFieldKeyName(f.getFieldKeyName());
            medplatFieldKeyDto.setFieldKeyValueType(f.getFieldKeyValueType());
            medplatFieldKeyDto.setDefaultValue(f.getDefaultValue());
            medplatFieldKeyDto.setIsRequired(f.getIsRequired());
            medplatFieldKeyDto.setOrderNo(f.getOrderNo());
            medplatFieldKeyDtos.add(medplatFieldKeyDto);
        });
        return medplatFieldKeyDtos;
    }
}
