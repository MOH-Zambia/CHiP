/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.spreadsheetloader.controller;

import com.argusoft.imtecho.spreadsheetloader.util.Transferrer;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import static com.argusoft.imtecho.spreadsheetloader.location.LocationTransferrer.logger;

/**
 *
 * <p>
 * Define APIs for sheet loader.
 * </p>
 *
 * @author Harshit
 * @since 26/08/20 10:19 AM
 */
@RestController
@RequestMapping("/api/sheetload")
public class SheetLoaderController {

    @Autowired
    private Transferrer locationTransferrer;

    /**
     * Load location spread sheet.
     */
    @GetMapping(value = "/test")
    public void sheetLoadTest() {
            
        try {
            logger.info("Running Location Spreadsheet Transferrer");
            
            String inputPath= "/home/avani/SpreadSheet/Newfile" ; 
            String fileName = "Final Urban Mapping Detail-Botad-Urban.xlsx"; 

            Map<String, String> result = locationTransferrer.transfer(inputPath,fileName);

            logger.info("--------- LOCATION SPREADSHEET TRANSFERRER SUMMARY ---------");
            logger.info(result);
            logger.info("--------------------------------------------------------");

            logger.info("Exiting Location Spreadsheet Transferrer");
        } catch (Exception ex) {
            logger.info("Exception occured while load file ."+ex);
        }
    }

}
