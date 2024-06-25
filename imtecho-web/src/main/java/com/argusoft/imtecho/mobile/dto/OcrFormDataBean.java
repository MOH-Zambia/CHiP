package com.argusoft.imtecho.mobile.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
public class OcrFormDataBean {
    private Integer id;
    private String formName;
    private String formJson;
    private Date modifiedOn;
}
