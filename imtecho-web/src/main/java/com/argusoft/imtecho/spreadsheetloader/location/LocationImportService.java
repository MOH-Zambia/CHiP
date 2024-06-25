/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.spreadsheetloader.location;

import java.util.Map;

/**
 * <p>
 *     Defines methods for location import.
 * </p>
 * @author avani
 * @since 07/09/2020 10:30
 */
public interface LocationImportService {

    /**
     * Transfer location.
     * @param inputPath Input file path.
     * @param fileName File name.
     * @return Returns result.
     */
    Map<String, String> transfer(String inputPath, String fileName);
    
}
