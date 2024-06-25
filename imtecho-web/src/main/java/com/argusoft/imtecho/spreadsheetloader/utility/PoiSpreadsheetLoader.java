package com.argusoft.imtecho.spreadsheetloader.utility;

import common.Logger;
import java.io.File;

/**
 * Define utility for poi spread sheet loader.
 * @author dharmesh
 * @since 07/09/2020 10:30
 */
public class PoiSpreadsheetLoader {

    // Logger.
    Logger logger = Logger.getLogger(PoiSpreadsheetLoader.class);

    private String inputXLSFile;

    private PoiSpreadsheetReader spreadsheetReader;

    public PoiSpreadsheetLoader(String inputXLSFile) {
        this.inputXLSFile = inputXLSFile;
    }

    /**
     * Read spread sheet.
     * @return Returns PoiSpreadsheetReader.
     */
    private PoiSpreadsheetReader readSpreadSheet() {
        if (this.spreadsheetReader == null) {
            if (this.inputXLSFile == null) {
                throw new IllegalArgumentException("Invalid parameter inputXLSFile");
            }
            File file = new File(inputXLSFile);
            if (!file.isFile()) {
                throw new IllegalArgumentException("IO exception while reading spreadsheet = " + inputXLSFile);
            }
            logger.info("Reading " + inputXLSFile);
            // Instantiate the spread sheet reader
            this.spreadsheetReader = new PoiSpreadsheetReader(inputXLSFile);
        }
        return this.spreadsheetReader;
    }

    /**
     * Load spread sheet.
     * @return Returns PoiSpreadsheetReader.
     */
    public PoiSpreadsheetReader loadSpreadSheet() {
        // Get the spread sheet reader
        PoiSpreadsheetReader ssReader = this.readSpreadSheet();
        ssReader.getSourceName();

        return ssReader;
    }

}
