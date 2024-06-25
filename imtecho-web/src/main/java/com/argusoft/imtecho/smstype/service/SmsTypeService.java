package com.argusoft.imtecho.smstype.service;

import com.argusoft.imtecho.smstype.dto.SmsTypeMasterDto;

import java.util.List;

/**
 * <p>
 * Define methods of sms type service
 * </p>
 *
 * @author monika
 * @since 10/03/21 12:20 PM
 */
public interface SmsTypeService {
//    List<SmsTypeMasterDto> getAllActiveSmsTypes();

    List<SmsTypeMasterDto> getAllSmsTypes();

    void toggleActive(SmsTypeMasterDto smsTypeMasterDto, Boolean isActive);

    void create(SmsTypeMasterDto smsTypeMasterDto);

    SmsTypeMasterDto getSmsTypeByType(String type);

    void updateSmsType(SmsTypeMasterDto smsTypeMasterDto);
}
