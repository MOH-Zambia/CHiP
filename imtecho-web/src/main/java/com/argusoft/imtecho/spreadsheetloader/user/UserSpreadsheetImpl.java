package com.argusoft.imtecho.spreadsheetloader.user;

import com.argusoft.imtecho.common.dto.UserMasterDto;
import com.argusoft.imtecho.spreadsheetloader.location.LocationConstants;
import com.argusoft.imtecho.spreadsheetloader.utility.PoiSpreadsheetLoader;
import com.argusoft.imtecho.spreadsheetloader.utility.PoiSpreadsheetReader;
import com.argusoft.imtecho.spreadsheetloader.utility.PoiWorksheetReader;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * <p>
 * user Workbook reading and writing service
 * </p>
 *
 * @author nihar
 * @since 10/07/21 10:19 AM
 */
public class UserSpreadsheetImpl {

    private final PoiSpreadsheetLoader loader;

    private PoiSpreadsheetReader sheetReader;

    private UserWorkSheetImpl workSheetImpl;

    private Map<String, Map<Integer, Integer>> wsRowLocationMap = new LinkedHashMap<>();

    private Map<String, Map<Integer, Map<Integer, UserMasterDto>>> wsUserMap = new LinkedHashMap<>();

    private Map<String, Map<Integer, Map<UserConstants.ResultFields, String>>> wsResultRowMap = new LinkedHashMap<>();

    private Map<String, UserWorkSheetImpl> workSheetMap = new HashMap<>();

    public UserSpreadsheetImpl(String inputXLSXFilePath) {
        loader = new PoiSpreadsheetLoader(inputXLSXFilePath);
    }

    public PoiSpreadsheetLoader getLoader() {
        return loader;
    }

    /**
     * Read excel file
     *
     * @throws Exception
     */
    public void init() throws Exception {
        try {
            // Get the worksheet reader
            sheetReader = this.loader.loadSpreadSheet();
            XSSFWorkbook workbook = sheetReader.getWorkbook();

            int totalWorkSheet = workbook.getNumberOfSheets();
            for (int i = 0; i < totalWorkSheet; i++) {

                String worksheetName = null;
                PoiWorksheetReader wsReader = null;

                try {
                    worksheetName = workbook.getSheetName(i).trim();

                    XSSFSheet sheet = workbook.getSheetAt(i);
                    if (sheet.getRow(0) != null) {
                        workSheetImpl = new UserWorkSheetImpl(worksheetName);
                        workSheetMap.put(worksheetName, workSheetImpl);

                        wsReader = (PoiWorksheetReader) sheetReader.getWorksheetReader(worksheetName);
                        workSheetImpl.setWsReader(wsReader);

                        workSheetImpl.loadUsers();
                        wsUserMap.put(worksheetName, workSheetImpl.getUsersLocationMap());
                        wsResultRowMap.put(worksheetName, workSheetImpl.getResultRowMap());
                    }
                } catch (UploadUserException e) {
                    throw e;
                } catch (Exception e) {
                    throw e;
                } finally {
                    if (wsReader != null) {
                        wsReader.close();
                    }
                }
            }
        } catch (UploadUserException e) {
            throw e;
        } catch (Exception e) {
            throw e;
        } finally {
            if (sheetReader != null) {
                sheetReader.close();
            }
        }
    }

    /**
     * Create a excel file of result data
     *
     * @return file name
     * @throws IOException
     */
    public String createResultWorkbook() throws IOException {

        FileOutputStream out = null;
        File outFile = null;

        XSSFWorkbook workbook = sheetReader.getWorkbook();
        XSSFWorkbook outWorkbook = workbook;

        DateFormat dateFormat = new SimpleDateFormat(UserConstants.DEFAULT_TIMESTAMP);
        String timeStamp = dateFormat.format(new Date());

        String fileName = UserConstants.DEFAULT_RESULT_FILE_NAME;

        int lastIndex = fileName.lastIndexOf(".");
        StringBuilder sb = new StringBuilder(fileName);
        sb.insert(lastIndex, "_" + timeStamp);

        String outFilePath = getDefaultPathForCopyFile(UserConstants.RESULT);

        File folder = new File(outFilePath);

        if (!folder.exists()) {
            folder.mkdirs();
        }
        fileName = outFilePath + File.separator + sb;
        outFile = new File(fileName);

        if (!outFile.exists()) {
            outFile.createNewFile();
        } else {
            outFile.delete();
        }

        for (Map.Entry<String, Map<Integer, Map<UserConstants.ResultFields, String>>> resultRowMap : wsResultRowMap.entrySet()) {

            UserWorkSheetImpl workSheetImpl = getWorkSheetInstance(resultRowMap.getKey());

            if (workSheetImpl != null) {
                workSheetImpl.createResultSheet(outWorkbook);
            }

        }
        out = new FileOutputStream(outFile);
        outWorkbook.write(out);
        out.close();
        return sb.toString();
    }

    /**
     * get file path
     *
     * @param destFolderName folder name
     * @return file path
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

    public UserWorkSheetImpl getWorkSheetInstance(String workSheetName) {
        return workSheetMap.get(workSheetName);
    }

    public Map<String, Map<Integer, Map<Integer, UserMasterDto>>> getWsUserMap() {
        return wsUserMap;
    }

    public Map<String, Map<Integer, Map<UserConstants.ResultFields, String>>> getWsResultRowMap() {
        return wsResultRowMap;
    }
}
