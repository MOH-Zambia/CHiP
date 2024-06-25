package com.argusoft.imtecho.spreadsheetloader.util;

import java.util.Map;

/**
 * Define methods for location transfer.
 * @author dharmesh
 * @since 07/09/2020 10:30
 */
public interface Transferrer {

    /**
     * Location transfer.
     * @param inputPath Input path.
     * @param fileName File name
     * @return Returns map of result.
     * @throws Exception Define exception.
     */
    Map<String, String> transfer(String inputPath, String fileName) throws Exception;
}
