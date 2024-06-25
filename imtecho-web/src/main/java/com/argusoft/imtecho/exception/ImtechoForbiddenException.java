package com.argusoft.imtecho.exception;

public class ImtechoForbiddenException extends RuntimeException {

    ImtechoResponseEntity agdRes;

    public ImtechoForbiddenException(String message) {
        super(message);
        this.agdRes = new ImtechoResponseEntity(message);
    }

    public ImtechoForbiddenException(String message, int errorCode, Object data) {
        super(message);
        this.agdRes = new ImtechoResponseEntity(message, errorCode, data);
    }

}
