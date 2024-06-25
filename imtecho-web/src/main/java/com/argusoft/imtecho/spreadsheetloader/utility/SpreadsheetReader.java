package com.argusoft.imtecho.spreadsheetloader.utility;

import java.util.List;

/**
 * Interface that can be implemented for both google and excel spreadsheets
 *
 * @author dharmesh
 * @since 07/09/2020 10:30
 */
public interface SpreadsheetReader {

    /**
     * get names of all the worksheets in this spreadsheet
     *
     * @return names mapped to lower case.
     */
    List<String> getWorksheetNames();

    /**
     * get a reader to the worksheet with that name
     *
     * @param name of the worksheet (case ignored)
     * @return Returns WorksheetReader.
     * @throws WorksheetNotFoundException Define work sheet not found exception.
     */
    WorksheetReader getWorksheetReader(String name)
            throws WorksheetNotFoundException;

    /**
     * Close and free any resources Do nothing if already closed.
     */
    void close();

    /**
     * get Human readable Information about this spreadsheet. For example the
     * list of file names or Urls holding these worksheets
     *
     * @return source of the spreadsheet
     */
    String getSourceName();
    
    /**
     * get actual spread sheet name
     * 
     *
     * @return spreadsheet name
     */
    String getSpreadSheetName();

}
