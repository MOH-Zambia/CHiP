package com.argusoft.imtecho.spreadsheetloader.utility;

/**
 * Define work sheet not fount exception.
 * @author dharmesh
 * @since 07/09/2020 10:30
 */
public class WorksheetNotFoundException extends Exception {

    /**
     * Creates a new instance of <code>WorksheetNotFoundException</code> without
     * detail message.
     */
    public WorksheetNotFoundException() {
    }

    /**
     * Constructs an instance of <code>WorksheetNotFoundException</code> with
     * the specified detail message.
     *
     * @param msg the detail message.
     */
    public WorksheetNotFoundException(String msg) {
        super(msg);
    }

}
