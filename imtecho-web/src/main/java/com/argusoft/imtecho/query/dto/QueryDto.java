/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.query.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.LinkedHashMap;
import java.util.List;

/**
 * Defines fields of query
 * @author vaishali
 * @since 02/09/2020 10:30
 */
@Getter
@Setter
@ToString
public class QueryDto {

    private String code;
    private String query;
    private List<LinkedHashMap<String, Object>> result;
    private LinkedHashMap<String, Object> parameters;
    private Integer sequence;
}

