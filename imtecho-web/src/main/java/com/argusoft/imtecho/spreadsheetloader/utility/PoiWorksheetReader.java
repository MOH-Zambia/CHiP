package com.argusoft.imtecho.spreadsheetloader.utility;

import common.Logger;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 * This reads a single tab of an Excel spreadsheet using the JDBC-ODBC bridge
 *
 * @author dharmesh
 * @since 07/09/2020 10:30
 */
public class PoiWorksheetReader implements WorksheetReader {

    private PoiSpreadsheetReader reader;
    private String name;
    private XSSFSheet sheet;
    private int rowIndex = 0;
    private List<String> columnNames;
    FormulaEvaluator evaluator;
    private String dateFormat = "dd-MM-yyyy";

    // Logger.
    Logger logger = Logger.getLogger(PoiWorksheetReader.class);

    public PoiWorksheetReader(PoiSpreadsheetReader reader, String name) {
        this.reader = reader;
        this.name = name;
        reopen();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void reopen() {
        close();
        getSheet(name);
        rowIndex = 0;
        getColumnNames();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void close() {
        sheet = null;
        columnNames = null;
    }

    /**
     * Retrieves column names.
     *
     * @return Returns list of strings.
     */
    public List<String> getColumnNames() {

        if (columnNames != null) {
            return columnNames;
        }
        this.logger.info("Getting columns... ");

        int cols = 0;
        int headerIndex = getHeaderRowIndex();

        this.logger.info("Found header at row " + headerIndex);
        if (headerIndex != -1) {
            rowIndex = headerIndex;

            Iterator<Cell> itr = sheet.getRow(rowIndex).cellIterator();

            while (itr.hasNext()) {
                Cell cell = itr.next();
                if (cell.getCellType() != Cell.CELL_TYPE_BLANK) {
                    cols++;
                }
            }
        } else {
            throw new RuntimeException("Header not found in spreadsheet");
        }

        List<String> names = new ArrayList<>(cols);
        for (int i = 0; i < cols; i++) {
            names.add(sheet.getRow(rowIndex).getCell(i).getStringCellValue().toUpperCase().trim());
        }
        columnNames = names;
        this.logger.info("columnNames... " + columnNames);
        return columnNames;
    }

    /**
     * Retrieves sheet.
     *
     * @param name Sheet name.
     * @return Returns XSSFSheet.
     */
    private XSSFSheet getSheet(String name) {
        this.logger.info("Reading sheet... " + name);
        if (sheet != null) {
            return sheet;
        }
        XSSFWorkbook workbook = reader.getWorkbook();
        evaluator = workbook.getCreationHelper().createFormulaEvaluator();
        sheet = workbook.getSheet(name);
        if (sheet != null) {
            return sheet;
        }
        for (int i = 0; i < workbook.getNumberOfSheets(); i++) {
            XSSFSheet aSheet = workbook.getSheetAt(i);
            if (aSheet.getSheetName().equalsIgnoreCase(name)) {
                sheet = aSheet;
                return sheet;
            }
        }
        this.logger.info("FAILED : Reading sheet... " + name);
        return null;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public int getEstimatedRows() {
        // subtract 1 for the header row
        return sheet.getPhysicalNumberOfRows() - 1;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public int getIndex(String name) {
        name = name.trim();
        String name2 = name.replaceAll("\\_", " ");
        String name3 = name.replaceAll("/", "");
        List<String> names = getColumnNames();
        for (int i = 0; i < names.size(); i++) {
            // This is to remove special characters from the column name
            // Added removal of newline char
            String columnName = names.get(i).replaceAll("[^\\w\\s]|[\\n$]", "");

            if (name.equalsIgnoreCase(columnName)) {
                return i;
            }
            if (name2.equalsIgnoreCase(columnName)) {
                return i;
            }
            if (name3.equalsIgnoreCase(columnName)) {
                return i;
            }
        }
        return -1;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String getValue(String name) {
        String val = "";

        if ("spreadsheet.row.number".equalsIgnoreCase(name)) {
            val = String.valueOf(rowIndex);
            return val;
        }

        int col = getIndex(name);
        if (col == -1) {
            throw new RuntimeException("ColName=" + name
                    + " does not exist in " + getColumnNames());
        }

        XSSFCell cell = sheet.getRow(rowIndex).getCell(col);
        if (cell != null) {
            switch (evaluator.evaluateInCell(cell).getCellType()) {
                case Cell.CELL_TYPE_STRING:
                    val = cell.getStringCellValue();
                    break;
                case Cell.CELL_TYPE_NUMERIC:
                    if (HSSFDateUtil.isCellDateFormatted(cell)) {
                        SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
                        val = sdf.format(cell.getDateCellValue());
                    } else {
                        //read exact value from numeric cells
                        //read value 1234 as 1234 not 1234.0, 12001008 as 12001008 not 1.2001008E7, 123.02 as 123.02
                        DataFormatter formatter = new DataFormatter();
                        val = formatter.formatCellValue(cell);
                    }
                    break;
                case Cell.CELL_TYPE_BOOLEAN:
                    val = Boolean.toString(cell.getBooleanCellValue());
                    break;
                case Cell.CELL_TYPE_BLANK:
                    val = null;
                    break;
                case Cell.CELL_TYPE_ERROR:
                    logger.error("Error???" + cell.getErrorCellString());
                    logger.error("Column : " + name);
                    break;
                default:
                    logger.info("Default!!!");
            }
        }
        if (val == null || val.trim().isEmpty()) {
            return null;
        }
        val = val.trim();
        return val;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public boolean next() {
        while (true) {
            rowIndex++;
            if (rowIndex < sheet.getPhysicalNumberOfRows() && sheet.getRow(rowIndex) != null
                    && sheet.getRow(rowIndex).getPhysicalNumberOfCells() != 0) {
//                if first 5 columns are blank then skip row
                if (areFirst5ColumnsBlank(rowIndex)) {
                    continue;
                }
                return true;
            }
            return false;
        }
    }

    /**
     * Check for first 5 columns are blank or not.
     *
     * @param rowIndex Row index.
     * @return Return true/false for first 5 columns are blank or not.
     */
    private boolean areFirst5ColumnsBlank(int rowIndex) {
        for (int col = 0; col < 5; col++) {
            XSSFCell cell = sheet.getRow(rowIndex).getCell(col);
            if (cell != null) {
                if (cell.getCellType() == Cell.CELL_TYPE_NUMERIC) {
                    if (cell.getNumericCellValue() != 0) {
                        return false;
                    }
                } else if (cell.getRawValue() != null &&
                        !cell.getRawValue().trim().isEmpty()) {
                    return false;
                }
            }
        }
        return true;
    }

    /**
     * Retrieves header row index.
     *
     * @return Returns index of header.
     */
    private int getHeaderRowIndex() {
        for (int i = 0; i < sheet.getPhysicalNumberOfRows(); ) {
            boolean isHeader = true;
            for (int c = 0; c < 2; c++) {
                Cell cell = sheet.getRow(i).getCell(c);
                if (cell == null || cell.getCellType() == Cell.CELL_TYPE_BLANK) {
                    isHeader = false;
                    break;
                }

            }

            if (!isHeader) {
                i++;
            } else {
                return i;
            }

        }

        return -1;

    }

    /**
     * {@inheritDoc}
     */
    @Override
    public boolean nextRow() {
        rowIndex++;
        return rowIndex < sheet.getPhysicalNumberOfRows() && sheet.getRow(rowIndex) != null
                && sheet.getRow(rowIndex).getPhysicalNumberOfCells() != 0;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String getWorkSheetName() {
        return this.name;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public int getCurrentRowIndex() {
        return this.rowIndex + 1; //starts from column row 
    }

}
