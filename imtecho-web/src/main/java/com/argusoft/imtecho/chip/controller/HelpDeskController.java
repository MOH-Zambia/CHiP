package com.argusoft.imtecho.chip.controller;

import com.argusoft.imtecho.chip.service.HelpDeskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/helpdesk")
public class HelpDeskController {
    @Autowired
    HelpDeskService helpDeskService;

    @PostMapping("/update")
    public void updateStatus(
            @RequestParam Integer recordId,
            @RequestParam String status
    ) {
        helpDeskService.updateRecord(status, recordId);
    }
}