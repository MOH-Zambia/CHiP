package com.argusoft.imtecho.common.controller;

import com.argusoft.imtecho.common.service.Dhis2DataService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;

@RestController
@RequestMapping("/chipIntegration")
public class Dhis2DataController {

    @Autowired
    private Dhis2DataService dataService;



    @GetMapping("/sendData")
    public String sendDataToDhis2(@RequestParam Date monthEnd, @RequestParam Integer facilityId){
        return dataService.sendData(monthEnd, facilityId);

    }

}
