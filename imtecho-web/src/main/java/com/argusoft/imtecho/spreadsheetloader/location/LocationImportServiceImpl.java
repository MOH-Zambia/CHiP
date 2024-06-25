/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.spreadsheetloader.location;

import com.argusoft.imtecho.common.dao.SystemConfigurationDao;
import com.argusoft.imtecho.common.model.SystemConfiguration;
import com.argusoft.imtecho.location.dao.LocationLevelHierarchyDao;
import com.argusoft.imtecho.location.dao.LocationMasterDao;
import com.argusoft.imtecho.location.model.LocationMaster;
import static com.argusoft.imtecho.spreadsheetloader.location.LocationTransferrer.logger;
import java.io.File;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * <p>
 *     Defines methods for location import.
 * </p>
 * @author avani
 * @since 07/09/2020 10:30
 */
@Service
@Transactional
public class LocationImportServiceImpl implements LocationImportService {

    // fromContainer
    private LocationSpreadsheetImpl fromContainer;

    @Autowired
    private LocationMasterDao locationDao;

    @Autowired
    private LocationLevelHierarchyDao locationLevelDao;

    @Autowired
    private SystemConfigurationDao systemConfigDao;

    @Override
    public Map<String, String> transfer(String inputPath, String fileName) {

        Map<String, LocationMaster> locationMap;
        //Error detail map for all worksheet 
        Map<String, Map<String, Map<Integer, List<String>>>> errorRowMap = null;
        Map<String, String> resultMap = new LinkedHashMap<>();

        String timeStamp;
        boolean isError = false;
        boolean isSuccess = false;
        String errorFileName = null;

        String filePath = generateFileName(inputPath, fileName);

        LocationWorkSheetImpl workSheetImpl;

        try {

            LocationSpreadsheetImpl spreadsheetImpl = new LocationSpreadsheetImpl(filePath);
            this.setFromContainer(spreadsheetImpl);
            spreadsheetImpl.setErrorMessageCount(getErrorMessageCount());
            spreadsheetImpl.init();

            errorRowMap = spreadsheetImpl.getErrorDetailMap();

            Map<String, Map<String, LocationMaster>> fromLocations = fromContainer.getAllLocations();

            if (!fromLocations.isEmpty()) {
                for (Map.Entry<String, Map<String, LocationMaster>> locationEntry : fromLocations.entrySet()) {
                    try {

                        locationMap = locationEntry.getValue();

                        workSheetImpl = fromContainer.getWorkSheetInstance(locationEntry.getKey());
                        Map<LocationResultEnum, AtomicInteger> results = workSheetImpl.getResults();

                        String hierarchy = workSheetImpl.getWorkSheetHierarchy();

                        if (locationMap != null && !locationMap.isEmpty()) {

                            workSheetImpl.setLocationDao(locationDao);
                            workSheetImpl.setLocationLevelDao(locationLevelDao);
                            workSheetImpl.insertLocations(errorRowMap);

                            if (!errorRowMap.isEmpty()) {
                                logger.info(LocationConstants.LOCATION_ADD_ERROR + " skip rows are: " + workSheetImpl.getSkipLocation() + " in worksheet " + locationEntry.getKey());
                            }

                            String resultString;

                            if (results.get(LocationResultEnum.LOCATION_ADDED).get() == 0 && results.get(LocationResultEnum.ERRORS_ENCOUNTERED).get() == 0
                                    && results.get(LocationResultEnum.SKIP_LOCATION).get() == 0) {

                                resultString = "For " + locationEntry.getKey() + ", This file is already processed earlier";

                            } else {
                                resultString = "For " + locationEntry.getKey() + ", " + results.get(LocationResultEnum.LOCATION_ADDED)
                                        + " locations added while " + results.get(LocationResultEnum.ERRORS_ENCOUNTERED)
                                        + " error encountered and " + results.get(LocationResultEnum.SKIP_LOCATION) + " locations are skipped";
                            }

                            resultMap.put(LocationConstants.RESULT + "_" + hierarchy, resultString);
                            isSuccess = true;

                        } else {
                            String resultString;

                            if (results.get(LocationResultEnum.LOCATION_ADDED).get() == 0 && results.get(LocationResultEnum.ERRORS_ENCOUNTERED).get() == 0
                                    && results.get(LocationResultEnum.SKIP_LOCATION).get() == 0) {

                                resultString = "For " + locationEntry.getKey() + ", This file is already processed earlier";

                            } else {
                                resultString = "For " + locationEntry.getKey() + ", " + results.get(LocationResultEnum.LOCATION_ADDED)
                                        + " locations added while " + results.get(LocationResultEnum.ERRORS_ENCOUNTERED)
                                        + " error encountered and " + results.get(LocationResultEnum.SKIP_LOCATION) + " locations are skipped";
                            }

                            resultMap.put(LocationConstants.RESULT + "_" + hierarchy, resultString);
                        }

                    } catch (DataIntegrityViolationException e) {
                        throw e;
                    } catch (Exception ex) {
                        logger.error(LocationConstants.LOCATION_ADD_ERROR + " for worksheet " + locationEntry.getKey(), ex);
                    }

                }
            } else {
                resultMap.put(LocationConstants.RESULT, LocationConstants.PROBLEM_WHILE_LOAD_SPREADSHEET);
            }

            DateFormat dateFormat = new SimpleDateFormat(LocationConstants.DEFAULT_TIMESTAMP);
            timeStamp = dateFormat.format(new Date());

            if (!errorRowMap.isEmpty()) {
                isError = true;
                errorFileName = fromContainer.generateErrorSpreadSheet(errorRowMap, fileName, timeStamp);
                resultMap.put(LocationConstants.ERROR_FILE_NAME, errorFileName);

            }

            // move file if any error not occured or error file generated successfully
            if (isError) {
                if (errorFileName != null && !errorFileName.equalsIgnoreCase("")) {
                    fromContainer.changeFileLocation(fileName, timeStamp);
                }
            } else if (isSuccess) {
                fromContainer.changeFileLocation(fileName, timeStamp);
            }

        } catch (IllegalArgumentException e) {
            logger.error(LocationConstants.FAIL_LOAD_SPREADSHEET, e);
            resultMap.put(LocationConstants.RESULT, LocationConstants.PROBLEM_WHILE_LOAD_SPREADSHEET);
        } catch (Exception e) {

            logger.error(LocationConstants.LOCATION_ADD_ERROR, e);

            DateFormat dateFormat = new SimpleDateFormat(LocationConstants.DEFAULT_TIMESTAMP);
            timeStamp = dateFormat.format(new Date());

            try {
                errorFileName = fromContainer.generateErrorSpreadSheet(errorRowMap, fileName, timeStamp);
            } catch (IOException ex) {
                logger.error(LocationConstants.FAIL_LOAD_SPREADSHEET, e);
            }
            resultMap.put(LocationConstants.RESULT, LocationConstants.PROBLEM_WHILE_LOAD_SPREADSHEET);
            resultMap.put(LocationConstants.ERROR_FILE_NAME, errorFileName);

            if (errorFileName != null && !errorFileName.equalsIgnoreCase("")) {
                fromContainer.changeFileLocation(fileName, timeStamp);
            }

        }

        logger.info("Final return map : " + resultMap);
        return resultMap;

    }

    /**
     * Generate file path using input path and file name
     *
     * @param path Path name
     * @param fileName File name
     * @return file path with name
     */
    public String generateFileName(String path, String fileName) {

        if (path != null && !path.equalsIgnoreCase("")) {

            return path + File.separator + fileName;
        } else {
            StringBuilder filePathBuilder = new StringBuilder();

            filePathBuilder.append(System.getProperty("user.home"));
            filePathBuilder.append(File.separator);
            filePathBuilder.append(LocationConstants.SPREAD_SHEET);
            filePathBuilder.append(File.separator);
            filePathBuilder.append(LocationConstants.NEW_FILE);
            filePathBuilder.append(File.separator);
            filePathBuilder.append(fileName);

            return filePathBuilder.toString();
        }
    }

    /**
     * Fetch error message count from system configuration
     *
     * @return count of error message
     */
    public String getErrorMessageCount() {
        if (systemConfigDao != null) {
            List<SystemConfiguration> sysConfigList = systemConfigDao.retrieveSystemConfigurationsBasedOnLikeKeySearch(LocationConstants.ALLOWED_CHARACTERS_IN_ERROR_LOG);

            if (sysConfigList != null && !sysConfigList.isEmpty()) {
                SystemConfiguration systemConfig = sysConfigList.get(0);
                return systemConfig.getKeyValue();
            }
        }

        return LocationConstants.EXCEPTION_MESSAGE_LENGTH;
    }

    public void setFromContainer(LocationSpreadsheetImpl fromContainer) {
        this.fromContainer = fromContainer;
    }

    public void setToContainer(LocationMasterDao toContainer) {
        this.locationDao = toContainer;
    }

    public void setLocationLevelDao(LocationLevelHierarchyDao locationLevelDao) {
        this.locationLevelDao = locationLevelDao;
    }

    public void setSystemConfigDao(SystemConfigurationDao systemConfigDao) {
        this.systemConfigDao = systemConfigDao;
    }

}
