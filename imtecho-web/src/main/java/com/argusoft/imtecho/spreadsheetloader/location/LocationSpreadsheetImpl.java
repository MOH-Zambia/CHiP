package com.argusoft.imtecho.spreadsheetloader.location;

import com.argusoft.imtecho.location.model.LocationMaster;
import com.argusoft.imtecho.spreadsheetloader.utility.PoiSpreadsheetLoader;
import com.argusoft.imtecho.spreadsheetloader.utility.PoiSpreadsheetReader;
import com.argusoft.imtecho.spreadsheetloader.utility.PoiWorksheetReader;
import com.argusoft.imtecho.spreadsheetloader.utility.WorksheetNotFoundException;
import common.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.xssf.usermodel.*;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Read Location spread sheet and map to java object
 *
 * @author avani
 * @since 07/09/2020 10:30
 */
public class LocationSpreadsheetImpl {

    // Logger.
    public static final Logger logger = Logger.getLogger(LocationSpreadsheetImpl.class);

    // Map Container to store Location object worksheet wise
    private Map<String, Map<String, LocationMaster>> wsLocationMap = null;

    //Map that store row number and column number of work sheet for location
    private Map<String, Map<String, List<Integer>>> rowIndexMap = null;

    // SpreadSheet Loader
    private final PoiSpreadsheetLoader loader;

    PoiSpreadsheetReader locationSheetReader;

    LocationTransferrer locationTransferrer;

    LocationWorkSheetImpl locationWorkSheetImpl;

    String errorMessageCount = null;

    Map<String, Map<String, Map<Integer, List<String>>>> errorRowMap = new LinkedHashMap<>();

    //Work sheet object map
    Map<String, LocationWorkSheetImpl> workSheetMap = new HashMap<>();

    public LocationSpreadsheetImpl(String inputXLSXFilePath) {
        loader = new PoiSpreadsheetLoader(inputXLSXFilePath);
    }

    public PoiSpreadsheetLoader getLoader() {
        return loader;
    }

    /**
     * Initialize spread sheet and load all worksheet.
     *
     * @throws Exception Exception when load spreadsheet data.
     */
    public void init() throws Exception {
        // Load data from spreadsheet
        this.loadAllLocations();
    }

    /**
     * Load spread sheet and read each worksheet.
     *
     * @throws Exception Exception when load spreadsheet data.
     */
    private void loadAllLocations() throws Exception {

        try {
            // Get the worksheet reader
            locationSheetReader = this.loader.loadSpreadSheet();

            XSSFWorkbook workbook = locationSheetReader.getWorkbook();

            int totalWorkSheet = workbook.getNumberOfSheets();
            wsLocationMap = new LinkedHashMap<>();
            rowIndexMap = new LinkedHashMap<>();

            logger.info("Spread sheet " + locationSheetReader.getSourceName() + " having total " + totalWorkSheet + " worksheet");

            //Loop through all worksheet and read data
            for (int i = 0; i < totalWorkSheet; i++) {

                String worksheetName = null;
                PoiWorksheetReader wsReader = null;

                try {

                    worksheetName = workbook.getSheetName(i).trim();

                    XSSFSheet sheet = workbook.getSheetAt(i);
                    if (sheet.getRow(0) == null) {
                        logger.info("Skip worksheet " + worksheetName + " due to data not found.");
                    } else {
                        locationWorkSheetImpl = LocationWorkSheetImpl.getWorkSheetInstance(worksheetName);

                        if (locationWorkSheetImpl == null) {
                            logger.info("Skip worksheet " + worksheetName);
                            continue;
                        }

                        //Store worksheet object in map
                        workSheetMap.put(worksheetName, locationWorkSheetImpl);

                        wsReader = (PoiWorksheetReader) locationSheetReader.getWorksheetReader(worksheetName);
                        locationWorkSheetImpl.setWsReader(wsReader);
                        locationWorkSheetImpl.setErrorMessageCount(getErrorMessageCount());

                        //Parse location from worksheet
                        locationWorkSheetImpl.loadLocations();

                        wsLocationMap.put(worksheetName, locationWorkSheetImpl.getLocationMap());
                        rowIndexMap.put(worksheetName, locationWorkSheetImpl.getRowIndexMap());
                        logger.info("Work sheet '" + worksheetName + "' loaded successfully");

                        if (locationWorkSheetImpl.getErrorDetailMap() != null && !locationWorkSheetImpl.getErrorDetailMap().isEmpty()) {
                            errorRowMap.put(worksheetName, locationWorkSheetImpl.getErrorDetailMap());
                        }

                    }

                } catch (Exception e) {
                    logger.error(LocationConstants.FAIL_LOAD_WORKSHEET + worksheetName, e);
                    throw e;
                } finally {
                    if (wsReader != null) {
                        wsReader.close();
                    }
                }

            }
            logger.info(LocationConstants.LOADING_SUCCESS_SPREADSHEET + " : " + locationSheetReader.getSourceName());
            // Finish.

        } catch (Exception e) {
            logger.error(LocationConstants.FAIL_LOAD_SPREADSHEET);
            throw e;

        } finally {
            if (locationSheetReader != null) {
                locationSheetReader.close();
            }
        }

    }

    /**
     * Retrieves all locations.
     *
     * @return Returns mpa of locations.
     */
    public Map<String, Map<String, LocationMaster>> getAllLocations() {
        return this.wsLocationMap;
    }

    /**
     * Retrieves row index map.
     *
     * @return Returns map of row index.
     */
    public Map<String, Map<String, List<Integer>>> getRowIndexMap() {
        return this.rowIndexMap;
    }

    /**
     * Generate error spread sheet
     *
     * @param errorLocationMap Map of error in locations.
     * @param fileName         Fine name.
     * @param timestamp        Time stamp.
     * @return Returns file name.
     * @throws IOException If an I/O error occurs when reading or writing.
     */
    public String generateErrorSpreadSheet(Map<String, Map<String, Map<Integer, List<String>>>> errorLocationMap, String fileName, String timestamp) throws IOException {
        String spreadsheetFileName = "";
        String errorFileName;
        FileOutputStream out = null;
        File outFile = null;
        try {

            // Create Workbook instance holding reference to .xlsx file
            XSSFWorkbook workbook = locationSheetReader.getWorkbook();
            XSSFWorkbook outWorkbook = new XSSFWorkbook();

            //If file already contains time-stamp then replace it
            fileName = fileName.replace(LocationConstants.TIMESTAMP_REGEX, "");

            fileName = fileName.replace("_" + LocationConstants.ERROR, "");

            StringBuilder sb = new StringBuilder(fileName);
            int lastIndex = sb.toString().lastIndexOf(".");
            sb.insert(lastIndex, "_" + LocationConstants.ERROR);

            errorFileName = appendTimeStampInFileName(sb.toString(), timestamp);

            String outFilePath = getDefaultPathForCopyFile(LocationConstants.ERROR_FILE);

            File folder = new File(outFilePath);

            if (!folder.exists()) {
                folder.mkdirs();
            }

            outFile = new File(outFilePath + File.separator + errorFileName);

            if (!outFile.exists()) {
                Boolean isNewFileCreate = outFile.createNewFile();
                if (Boolean.FALSE.equals(isNewFileCreate)) {
                    logger.error("Error in file creation");
                }
            } else {
                Boolean isFileDelete = outFile.delete();
                if (Boolean.FALSE.equals(isFileDelete)) {
                    logger.error("Error in file delete");
                }
            }

            if (errorLocationMap.isEmpty()) {

                generateErrorFileForAllLocation(outFile, workbook, outWorkbook);
            } else {
                for (Map.Entry<String, Map<String, Map<Integer, List<String>>>> sheetDetail : errorLocationMap.entrySet()) {

                    // Get desired sheet from the workbook
                    XSSFSheet sheet = workbook.getSheet(sheetDetail.getKey());
                    LocationWorkSheetImpl workSheetImpl = getWorkSheetInstance(sheetDetail.getKey());

                    if (workSheetImpl != null) {
                        // Create new errored file and copy data
                        outWorkbook = workSheetImpl.getFilteredWorkBook(sheet, outWorkbook, sheetDetail.getValue());
                    }

                }

                out = new FileOutputStream(outFile);
                outWorkbook.write(out);

            }

        } catch (Exception e) {
            if (outFile != null) {
                Boolean isFileDelete = outFile.delete();
                if (Boolean.FALSE.equals(isFileDelete)) {
                    logger.error("Error in file delete");
                }
            }
            errorFileName = null;
            logger.error(LocationConstants.FAIL_GENERATE_ERROR_SHEET + spreadsheetFileName, e);
        } finally {
            if (out != null) {
                out.close();
            }

        }

        return errorFileName;

    }

    /**
     * Change file location move to processed folder.
     *
     * @param fileName  File name.
     * @param timestamp Time stamp.
     */
    public void changeFileLocation(String fileName, String timestamp) {

        try {
            File inputFile = new File(locationSheetReader.getSpreadSheetName());

            String outFilePath = getDefaultPathForCopyFile(LocationConstants.PROCESSED_FILE);

            File folder = new File(outFilePath);

            if (!folder.exists()) {
                folder.mkdirs();
            }

            //If file already contains time-stamp then replace it
            fileName = fileName.replace(LocationConstants.TIMESTAMP_REGEX, "");

            fileName = fileName.replace("_" + LocationConstants.ERROR, "");

            String newFileName = appendTimeStampInFileName(fileName, timestamp);

            File outFile = new File(outFilePath + File.separator + newFileName);

            Boolean isRenameFile = inputFile.renameTo(outFile);
            if (Boolean.FALSE.equals(isRenameFile)) {
                logger.error("File rename failed");
            }

        } catch (Exception e) {
            logger.error("Problem occured while move file to processed location");
        }

    }

    /**
     * Append default timestamp after filename.
     *
     * @param fileName  File name.
     * @param timeStamp Time stamp.
     * @return Returns fileName with timestamp.
     */
    public String appendTimeStampInFileName(String fileName, String timeStamp) {

        int lastIndex = fileName.lastIndexOf(".");
        StringBuilder sb = new StringBuilder(fileName);
        sb.insert(lastIndex, "_" + timeStamp);

        return sb.toString();
    }

    /**
     * Generate error file with copy whole input file and highlight data
     *
     * @param outputFile  Output file content.
     * @param inWorkBook  Xss in work book.
     * @param outWorkBook Xss out work book.
     * @throws IOException                If an I/O error occurs when reading or writing.
     * @throws WorksheetNotFoundException Work sheet not found exception.
     */
    private void generateErrorFileForAllLocation(File outputFile, XSSFWorkbook inWorkBook, XSSFWorkbook outWorkBook) throws IOException {
        int totalSheet = inWorkBook.getNumberOfSheets();

        XSSFCellStyle newCellStyle = outWorkBook.createCellStyle();

        newCellStyle.setFillForegroundColor(IndexedColors.RED.getIndex());
        newCellStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);

        for (int i = 0; i < totalSheet; i++) {
            XSSFSheet sheet = inWorkBook.getSheetAt(i);
            XSSFSheet outSheet = outWorkBook.createSheet(sheet.getSheetName());

            int totalRows = sheet.getLastRowNum();

            for (int rowNum = 0; rowNum < totalRows; rowNum++) {
                XSSFRow outRow = outSheet.createRow(rowNum);
                XSSFRow row = sheet.getRow(rowNum);
                if (row != null) {

                    int totalCol = row.getLastCellNum();
                    for (int col = 0; col < totalCol; col++) {
                        XSSFCell outCell = outRow.createCell(col);
                        XSSFCell cell = row.getCell(col);

                        if (cell != null) {
                            outCell.setCellStyle(newCellStyle);
                            setCellValue(outCell, cell);
                        }
                    }

                }
            }

        }

        FileOutputStream out = new FileOutputStream(outputFile);
        outWorkBook.write(out);
        out.close();

    }

    /**
     * Generate path for error and process folder
     *
     * @param destFolderName Destination folder name.
     * @return path Returns full path.
     */
    private String getDefaultPathForCopyFile(String destFolderName) {
        StringBuilder outFilePath = new StringBuilder();
        outFilePath.append(System.getProperty("user.home"));
        outFilePath.append(File.separator);
        outFilePath.append(LocationConstants.SPREAD_SHEET);
        outFilePath.append(File.separator);
        outFilePath.append(destFolderName);

        return outFilePath.toString();
    }

    /**
     * Check cell type and set its value
     *
     * @param outCell Output cell.
     * @param cell    Cell.
     */
    public void setCellValue(XSSFCell outCell, XSSFCell cell) {

        switch (cell.getCellType()) {
            case HSSFCell.CELL_TYPE_FORMULA:
                outCell.setCellFormula(cell.getCellFormula());
                break;
            case HSSFCell.CELL_TYPE_NUMERIC:
                outCell.setCellValue(cell.getNumericCellValue());
                break;
            case HSSFCell.CELL_TYPE_STRING:
                outCell.setCellValue(cell.getStringCellValue());
                break;
            case HSSFCell.CELL_TYPE_BLANK:
                outCell.setCellType(HSSFCell.CELL_TYPE_BLANK);
                break;
            case HSSFCell.CELL_TYPE_BOOLEAN:
                outCell.setCellValue(cell.getBooleanCellValue());
                break;
            case HSSFCell.CELL_TYPE_ERROR:
                outCell.setCellErrorValue(cell
                        .getErrorCellValue());
                break;
            default:
                outCell.setCellValue(cell.getStringCellValue());
                break;
        }

    }

    /**
     * Return worksheet instance from map
     *
     * @param workSheetName Work sheet name.
     * @return LocationWorkSheetImpl Returns work sheet of location.
     */
    public LocationWorkSheetImpl getWorkSheetInstance(String workSheetName) {
        return workSheetMap.get(workSheetName);
    }

    /**
     * Retrieves error message count.
     *
     * @return Returns error message count.
     */
    public String getErrorMessageCount() {
        return errorMessageCount;
    }

    /**
     * Set error message count.
     *
     * @param errorMessageCount Error message count.
     */
    public void setErrorMessageCount(String errorMessageCount) {
        this.errorMessageCount = errorMessageCount;
    }

    /**
     * Return error detail map
     *
     * @return Error detail map
     */
    public Map<String, Map<String, Map<Integer, List<String>>>> getErrorDetailMap() {
        return errorRowMap;
    }
}
