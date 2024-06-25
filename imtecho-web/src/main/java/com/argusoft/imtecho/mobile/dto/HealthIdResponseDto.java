package com.argusoft.imtecho.mobile.dto;

/**
 * Defines methods for HealthIdResponseDto
 *
 * @author dhruvil
 * @since 06/04/23 6:30 PM
 */
public class HealthIdResponseDto {

    private Status status;
    private String message;

    public enum Status {
        SUCCESS,
        FAILED
    }

    public HealthIdResponseDto(Status status, String message) {
        this.status = status;
        this.message = message;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

}
