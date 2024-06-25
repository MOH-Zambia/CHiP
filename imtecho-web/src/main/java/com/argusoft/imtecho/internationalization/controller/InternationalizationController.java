package com.argusoft.imtecho.internationalization.controller;

import com.argusoft.imtecho.internationalization.service.InternationalizationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 *
 * <p>
 * Define APIs for internationalization.
 * </p>
 *
 * @author dhaval
 * @since 26/08/20 10:19 AM
 */
@RestController
@RequestMapping("/api/internationalization")
public class InternationalizationController {

    @Autowired
    private InternationalizationService internationalizationService;

    /**
     * Update labels.
     */
    @PostMapping(value = "/updateLabelsMap")
    public void updateLabelsMap() {
        internationalizationService.updateLabelsMap();
    }
}
