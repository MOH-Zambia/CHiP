package com.argusoft.imtecho.spreadsheetloader.location;

import com.argusoft.imtecho.spreadsheetloader.util.Transferrer;
import common.Logger;
import java.util.HashMap;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;

/**
 * Transfer to sync data from Spreadsheet to DB.
 *
 * @author avani
 * @since 07/09/2020 10:30
 */
@Service
public class LocationTransferrer implements Transferrer {

    public static final Logger logger = Logger.getLogger(LocationTransferrer.class);

    @Autowired
    private LocationImportService locationImportService;

    /**
     * Transfer Location records from spreadsheet to database
     *
     * @param inputPath Input path.
     * @param fileName File name.
     * @return Returns result map.
     *
     */
    @Override
    public Map<String, String> transfer(String inputPath, String fileName) {

        Map<String, String> result = new HashMap<>();

        try {
            result = locationImportService.transfer(inputPath, fileName);

        } catch (DataIntegrityViolationException e) {
            logger.error("Duplicate data found while process file");
            result.put(LocationConstants.RESULT, LocationConstants.DUPLICATE_LOCATION_FOUND);

        } catch (Exception e) {
            logger.error("Exception occured while process file" +e.getMessage());
            e.printStackTrace();
            if (!result.isEmpty()) {
                return result;
            } else {
                result.put(LocationConstants.RESULT, LocationConstants.PROBLEM_WHILE_LOAD_SPREADSHEET);
            }

        }

        return result;
    }
}
