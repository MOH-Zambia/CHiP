package com.argusoft.imtecho.smstype.controller;

import com.argusoft.imtecho.common.dto.RoleMasterDto;
import com.argusoft.imtecho.smstype.dto.SmsTypeMasterDto;
import com.argusoft.imtecho.smstype.service.SmsTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * <p>
 * Controller for Sms Type
 * </p>
 *
 * @author monika
 * @since 10/03/21 12:24 PM
 */
@RestController
@RequestMapping("/api/smstype")
public class SmsTypeController {
    @Autowired
    SmsTypeService smsTypeService;

    @RequestMapping(value = "/getAllSmsTypes", method = RequestMethod.GET)
    public List<SmsTypeMasterDto> getAllSmsTypes() {
        return smsTypeService.getAllSmsTypes();
    }

    @RequestMapping(value = "/toggleState", method = RequestMethod.PUT)
    public void toggleActive(@RequestBody SmsTypeMasterDto smsTypeMasterDto, @RequestParam("is_active") Boolean isActive) {
        smsTypeService.toggleActive(smsTypeMasterDto, isActive);
    }

    @RequestMapping(value = "/create", method = RequestMethod.POST)
    public void create(@RequestBody SmsTypeMasterDto smsTypeMasterDto) {
        smsTypeService.create(smsTypeMasterDto);
    }

    @RequestMapping(value = "/updateSmsType", method = RequestMethod.PUT)
    public void updateSmsType(@RequestBody SmsTypeMasterDto smsTypeMasterDto) {
        smsTypeService.updateSmsType(smsTypeMasterDto);
    }

    @RequestMapping(value = "/getSmsTypeByType", method = RequestMethod.GET)
    public SmsTypeMasterDto getSmsTypeByType(@RequestParam(value = "type") String type) {
        return smsTypeService.getSmsTypeByType(type);
    }
}
