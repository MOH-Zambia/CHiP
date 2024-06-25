package com.argusoft.imtecho.spreadsheetloader.utility;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 * This reads an excel spreadsheet using the Apache POI.
 * @author dharmesh
 * @since 07/09/2020 10:30
 */
public class PoiSpreadsheetReader implements SpreadsheetReader {

    private String spreadsheetFileName;

    public PoiSpreadsheetReader(String spreadsheetFileName) {
        this.spreadsheetFileName = spreadsheetFileName;
    }

    private transient XSSFWorkbook workbook = null;

    /**
     * Retrieve work book.
     * @return Returns XSSFWorkbook.
     */
    public XSSFWorkbook getWorkbook() {
        if (this.workbook != null) {
            return this.workbook;
        }
        try {
            InputStream in = this.getClass().getResourceAsStream(
                    spreadsheetFileName);
            if (in == null) {
                File file = new File(spreadsheetFileName);
                in = file.toURI().toURL().openConnection().getInputStream();
            }
            workbook = new XSSFWorkbook(in);
        } catch (IOException ex) {
            throw new RuntimeException("problem with file " + spreadsheetFileName, ex);
        }
        return workbook;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<String> getWorksheetNames() {
        List<String> names = new ArrayList<>();
        for (int i = 0; i < getWorkbook().getNumberOfSheets(); i++) {
            names.add(getWorkbook().getSheetAt(i).getSheetName().toLowerCase());
        }
        return names;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public WorksheetReader getWorksheetReader(String name) throws WorksheetNotFoundException {
        name = name.toLowerCase();
        if (!getWorksheetNames().contains(name)) {
            StringBuilder buf = new StringBuilder();
            String comma = "";
            for (String nme : getWorksheetNames()) {
                buf.append(comma);
                buf.append(nme);
                comma = ", ";
            }
            throw new WorksheetNotFoundException(name + " not in "
                    + buf.toString());
        }
        return new PoiWorksheetReader(this, name);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void close() {
        if (workbook == null) {
            return;
        }
        workbook = null;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String getSourceName() {
        return "Excel Spreadsheet " + spreadsheetFileName;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String getSpreadSheetName() {
        return spreadsheetFileName;
    }
    
    

    @Override
    public String toString() {
        return "ExcelSpreadsheetReader{" + "spreadsheetFileName=" + spreadsheetFileName + ", workbook=" + workbook + '}';
    }
}
