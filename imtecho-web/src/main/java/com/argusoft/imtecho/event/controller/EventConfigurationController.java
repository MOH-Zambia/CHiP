/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.event.controller;

import com.argusoft.imtecho.common.util.SystemConstantUtil;
import com.argusoft.imtecho.event.dto.EventConfigurationDto;
import com.argusoft.imtecho.event.service.EventConfigurationService;
import com.argusoft.imtecho.exception.ImtechoSystemException;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 *
 * <p>
 * Define APIs for event configuration.
 * </p>
 *
 * @author vaishali
 * @since 26/08/20 10:19 AM
 */
@RestController
@RequestMapping("/api/eventconfig")
public class EventConfigurationController {

    @Autowired
    private EventConfigurationService notificationConfigurationService;

    /**
     * Add/Update event configuration.
     * @param notificationConfigDto Event configuration details.
     * @throws IOException If an I/O error occurs when reading or writing.
     */
    @PostMapping()
    public void saveOrUpdate(@RequestBody EventConfigurationDto notificationConfigDto) throws IOException {
        notificationConfigurationService.saveOrUpdate(notificationConfigDto,false);
    }

    /**
     * Retrieves event details by uuid.
     * @param id Event uuid.
     * @return Returns event configuration details by uuid.
     */
    @GetMapping(value = "/{id}")
    public EventConfigurationDto retrieveByUUID(@PathVariable UUID id) {
        return notificationConfigurationService.retrieveByUUID(id);
    }

    /**
     * Retrieves all events.
     * @return Returns list of all events.
     */
    @GetMapping(value = "")
    public List<EventConfigurationDto> retreiveAll(@RequestParam("isActive") Boolean isActive) {
        return notificationConfigurationService.retrieveAll(isActive);
    }

    /**
     * Retrieves all manual events.
     * @return Returns list of manual events.
     */
    @GetMapping(value = "/manualevents")
    public Map<String, String> retrieveManualEvents()
    {
        return SystemConstantUtil.MANUAL_EVENTS_MAP;
    }

    /**
     * Run event by event id.
     * @param id Event id.
     */
    @GetMapping(value = "/run/{id}")
    public void runEventConfig(@PathVariable UUID id) {
        if (id == null) {
            throw new ImtechoSystemException("Event config uuid is required", 503);
        }
        notificationConfigurationService.runEvent(id);
    }

    /**
     * Make event active or inactive.
     * @param notificationConfigurationDto Event configuration details.
     */
    @PutMapping(value="")
    public void toggleState(@RequestBody EventConfigurationDto notificationConfigurationDto){
         notificationConfigurationService.toggleState(notificationConfigurationDto);
    }

}
