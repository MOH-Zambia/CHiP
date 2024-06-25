/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.config.requestresponsefilter.service;


import java.util.Date;

/**
 * @author ashish
 */
public interface RequestResponseDetailsService {

    void checkRequestResponse();

    void checkUserUsageList();

    void updateEndTimeToDB(Integer id, Date endDate);

    Integer insertPageTitle(String pageTitle);

    Integer insertUrl(String url);

    void setPageTitleMapping();

    void setUrlMapping();

    void setApiToBeIgnoredForReqResFilter();

    void initCacheVariables();
}
