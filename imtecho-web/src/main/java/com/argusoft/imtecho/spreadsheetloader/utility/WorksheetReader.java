package com.argusoft.imtecho.spreadsheetloader.utility;
/**
 * Interface required to get data from a single tab of a spreadsheet
 *
 * @author dharmesh
 * @since 07/09/2020 10:30
 */
public interface WorksheetReader {

    /**
     * get estimated number of rows.
     *
     * @return estimated number of rows
     */
    int getEstimatedRows();

    /**
     * Get the value with the specified column name
     *
     * @param name to be compared ignoring case.
     * @return nulls converted to "" and values trimmed.
     */
    String getValue(String name);

    /**
     * Get the index to the column with the specified column name.
     *
     * @param name to be compared ignoring case
     * @return -1 if not found
     */
    int getIndex(String name);

    /**
     * Move to the next row in the worksheet skip if first five columns are blank
     *
     * @return false if no next row
     */
    boolean next();
    
    /**
     * Move to the next row in the worksheet
     * @return false if no next row
     */
    boolean nextRow();

    /**
     * Reopen the resource Note: the resource is assumed to be automatically
     * opened when created.
     */
    void reopen();

    /**
     * Close and free any resources Do nothing if already closed.
     */
    void close();
    
    /**
     * Get the current worksheet name
     * @return worksheet name
     */
    String getWorkSheetName();
    
    /**
     * Get the current rendering row index
     * @return row index
     */
    int getCurrentRowIndex();
}
