package com.argusoft.imtecho.spreadsheetloader.user;

/**
 * @author nihar
 * @since 10/07/21 10:19 AM
 */
public class UploadUserException extends Exception{
    private final String message;

    public UploadUserException(String message) {
        super();
        this.message = message;
    }

    @Override
    public String toString() {
        return message;
    }
}
