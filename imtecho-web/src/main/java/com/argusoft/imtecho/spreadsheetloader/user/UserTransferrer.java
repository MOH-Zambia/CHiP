package com.argusoft.imtecho.spreadsheetloader.user;

import com.argusoft.imtecho.spreadsheetloader.location.LocationConstants;
import com.argusoft.imtecho.spreadsheetloader.location.LocationTransferrer;
import com.argusoft.imtecho.spreadsheetloader.util.Transferrer;
import common.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

/**
 * <p>
 * transfer user upload file to users
 * </p>
 *
 * @author nihar
 * @since 10/07/21 10:19 AM
 */
@Service
public class UserTransferrer implements Transferrer {

    public static final Logger logger = Logger.getLogger(UserTransferrer.class);

    @Autowired
    private UserImportService userImportService;

    /**
     * User transfer.
     *
     * @param inputPath Input path.
     * @param fileName  File name
     * @return Returns map of result.
     * @throws Exception Define exception.
     */
    @Override
    public Map<String, String> transfer(String inputPath, String fileName) {
        Map<String, String> result = new HashMap<>();
        try {
            result = this.userImportService.transfer(inputPath, fileName);
        } catch (Exception e) {
            logger.error("Exception occured while process file" + e.getMessage());
            e.printStackTrace();
            if (!result.isEmpty()) {
                return result;
            } else {
                result.put(UserConstants.RESULT, UserConstants.PROBLEM_WHILE_LOAD_SPREADSHEET);
            }

        }
        return result;
    }
}
