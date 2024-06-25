/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.rch.controller;

import com.argusoft.imtecho.rch.dto.VolunteersDto;
import com.argusoft.imtecho.rch.service.VolunteersService;
import java.util.Date;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 *
 * <p>
 * Define APIs for volunteers.
 * </p>
 *
 * @author smeet
 * @since 26/08/20 10:19 AM
 */
@RestController
@RequestMapping("/api/volunteers")
public class VolunteersController {

    @Autowired
    VolunteersService volunteersService;

    /**
     * Add volunteers details.
     * @param volunteersDto Volunteers details.
     */
    @PostMapping(value = "")
    public void createOrUpdate(@RequestBody VolunteersDto volunteersDto) {
        volunteersService.createOrUpdate(volunteersDto);
    }

    /**
     * Retrieves volunteers details by health infra structure.
     * @param healthInfrastructureId Health infrastructure id.
     * @param monthYear Define month year.
     * @return Returns volunteers details.
     */
    @GetMapping(value = "/retrievedata")
    public VolunteersDto retrieveData(
            @RequestParam(name = "healthInfrastructureId") Integer healthInfrastructureId,
            @RequestParam(name = "monthYear") Long monthYear) {
        return volunteersService.retrieveData(healthInfrastructureId, new Date(monthYear));
    }

}
