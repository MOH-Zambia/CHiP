package com.argusoft.imtecho.fhs.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.util.Date;

@Data
public class ReferredPatientsDto {

    private String referralId="123456789";
    private String referredFrom;
    private String referredTo;

    @JsonFormat(pattern = "yyyy-MM-dd' 'HH:mm:ss")
    private Date referredOn;
    private String referredBy;
    private String reasons;
    private String  typeCode = "310449005";
    private String serviceArea;
    private String notes;
    private String clientNupn="234345345345";

}
