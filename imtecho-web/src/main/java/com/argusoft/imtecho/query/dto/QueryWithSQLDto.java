package com.argusoft.imtecho.query.dto;

import lombok.Data;

import java.util.LinkedHashMap;
import java.util.List;

@Data
public class QueryWithSQLDto {
    private String code;
    private List<LinkedHashMap<String,Object>> result;
    private LinkedHashMap<String,Object> parameters;
    private Integer sequence;
    private String query;
    private String params;
}
