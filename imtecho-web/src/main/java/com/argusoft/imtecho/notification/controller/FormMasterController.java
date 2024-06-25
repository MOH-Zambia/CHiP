/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.notification.controller;

import com.argusoft.imtecho.notification.dto.FormMasterDto;
import com.argusoft.imtecho.notification.service.FormMasterService;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 *
 * <p>
 * Define APIs for form master.
 * </p>
 *
 * @author vaishali
 * @since 26/08/20 10:19 AM
 */
@RestController
@RequestMapping("/api/form")
public class FormMasterController {

    @Autowired
    FormMasterService formMasterService;

    /**
     * Retrieves all forms.
     * @param isActive Is form active or not.
     * @return Returns list of forms.
     */
    @GetMapping(value = "")
    public List<FormMasterDto> retrieveAll(@RequestParam(name = "is_active", required = false) Boolean isActive) {
        return formMasterService.retrieveAll(isActive);
    }
}
