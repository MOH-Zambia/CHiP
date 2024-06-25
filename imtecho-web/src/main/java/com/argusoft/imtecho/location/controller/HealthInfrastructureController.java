package com.argusoft.imtecho.location.controller;

import com.argusoft.imtecho.location.model.HealthInfraStructureOtherDetails;
import com.argusoft.imtecho.location.model.HealthInfrastructureDetails;
import com.argusoft.imtecho.location.model.HealthInfrastructureHFRDetails;
import com.argusoft.imtecho.location.model.HealthInfrastructureMatchDetail;
import com.argusoft.imtecho.location.service.HealthInfrastructureService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/health-infra")
public class HealthInfrastructureController {

    @Autowired
    private HealthInfrastructureService healthInfrastructureService;


    @RequestMapping(value = "/toggleactive/{id}", method = RequestMethod.POST)
    public void toggleActive(@PathVariable Integer id,
                             @RequestParam("state") String state) {
        healthInfrastructureService.toggleActive(id, state);
    }
}
