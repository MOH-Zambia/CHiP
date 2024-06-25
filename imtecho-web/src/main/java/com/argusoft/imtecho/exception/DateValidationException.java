package com.argusoft.imtecho.exception;

/**
 * Custom exception for date validation errors.
 */
public class DateValidationException extends RuntimeException {

    /**
     * Constructs a new DateValidationException with the specified detail message.
     *
     * @param message the detail message.
     */

    public DateValidationException(String message) {
        super(message);
    }
}
