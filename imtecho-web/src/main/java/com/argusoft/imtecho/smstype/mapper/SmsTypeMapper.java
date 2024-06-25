package com.argusoft.imtecho.smstype.mapper;

import com.argusoft.imtecho.smstype.dto.SmsTypeMasterDto;
import com.argusoft.imtecho.smstype.model.SmsTypeMaster;

import java.util.ArrayList;
import java.util.List;

/**
 * <p>
 * Mapper for sms type entity
 * </p>
 *
 * @author monika
 * @since 10/03/21 12:34 PM
 */
public class SmsTypeMapper {
    private SmsTypeMapper(){}

    public static SmsTypeMasterDto smsTypeEntityToDto(SmsTypeMaster smsTypeMaster){
        SmsTypeMasterDto smsTypeMasterDto = new SmsTypeMasterDto();
        smsTypeMasterDto.setDiscription(smsTypeMaster.getDiscription());
        smsTypeMasterDto.setSmsText(smsTypeMaster.getSmsText());
        smsTypeMasterDto.setSmsType(smsTypeMaster.getSmsType());
        smsTypeMasterDto.setState(smsTypeMaster.getState());
        smsTypeMasterDto.setTemplateId(smsTypeMaster.getTemplateId());
        smsTypeMasterDto.setCreatedBy(smsTypeMaster.getCreatedBy());
        smsTypeMasterDto.setCreatedOn(smsTypeMaster.getCreatedOn());
        smsTypeMasterDto.setModifiedBy(smsTypeMaster.getModifiedBy());
        smsTypeMasterDto.setModifiedOn(smsTypeMaster.getModifiedOn());
        return smsTypeMasterDto;
    }

    public static List<SmsTypeMasterDto> entityToDtoList(List<SmsTypeMaster> smsTypeMasters) {
        List<SmsTypeMasterDto> smsTypeMasterDtos = new ArrayList<>();
        for (SmsTypeMaster smsTypeMaster : smsTypeMasters) {
            SmsTypeMasterDto smsTypeMasterDto = smsTypeEntityToDto(smsTypeMaster);
            smsTypeMasterDtos.add(smsTypeMasterDto);
        }
        return smsTypeMasterDtos;
    }

    public static SmsTypeMaster smsTypeDtoToEntity(SmsTypeMasterDto smsTypeMasterDto){
        SmsTypeMaster smsTypeMaster = new SmsTypeMaster();
        smsTypeMaster.setSmsType(smsTypeMasterDto.getSmsType());
        smsTypeMaster.setSmsText(smsTypeMasterDto.getSmsText());
        smsTypeMaster.setState(smsTypeMasterDto.getState());
        smsTypeMaster.setDiscription(smsTypeMasterDto.getDiscription());
        smsTypeMaster.setTemplateId(smsTypeMasterDto.getTemplateId());
        smsTypeMaster.setCreatedBy(smsTypeMasterDto.getCreatedBy());
        smsTypeMaster.setCreatedOn(smsTypeMasterDto.getCreatedOn());
        smsTypeMaster.setModifiedBy(smsTypeMasterDto.getModifiedBy());
        smsTypeMaster.setModifiedOn(smsTypeMasterDto.getModifiedOn());
        return smsTypeMaster;
    }
}
