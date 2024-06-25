package com.argusoft.imtecho.spreadsheetloader.user;

import java.util.Map;

/**
 * <p>
 * transfer user upload file to users
 * </p>
 *
 * @author nihar
 * @since 10/07/21 10:19 AM
 */
public interface UserImportService {

    /**
     * Transfer user.
     *
     * @param inputPath Input file path.
     * @param fileName  File name.
     * @return Returns result.
     */
    Map<String, String> transfer(String inputPath, String fileName);
}
