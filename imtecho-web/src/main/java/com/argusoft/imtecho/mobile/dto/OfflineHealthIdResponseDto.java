package com.argusoft.imtecho.mobile.dto;

public class OfflineHealthIdResponseDto {

    private Status status;
    private Long failedHealthIdDataEntityId;
    private Long healthIdDocumentId;

    private String message;

    public enum Status{
        SUCCESS,
        FAILED
    }

    public OfflineHealthIdResponseDto(Status status, Long failedHealthIdDataEntityId, Long healthIdDocumentId, String message) {
        this.status = status;
        this.failedHealthIdDataEntityId = failedHealthIdDataEntityId;
        this.healthIdDocumentId = healthIdDocumentId;
        this.message = message;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public Long getFailedHealthIdDataEntityId() {
        return failedHealthIdDataEntityId;
    }

    public void setFailedHealthIdDataEntityId(Long failedHealthIdDataEntityId) {
        this.failedHealthIdDataEntityId = failedHealthIdDataEntityId;
    }

    public Long getHealthIdDocumentId() {
        return healthIdDocumentId;
    }

    public void setHealthIdDocumentId(Long healthIdDocumentId) {
        this.healthIdDocumentId = healthIdDocumentId;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
