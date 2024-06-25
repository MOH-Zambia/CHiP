/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.config.requestresponsefilter.service.impl;

import com.argusoft.imtecho.common.controller.UserUsageAnalyticsController;
import com.argusoft.imtecho.common.dao.UserUsageAnalyticsDao;
import com.argusoft.imtecho.common.dto.UserUsageAnalyticsDto;
import com.argusoft.imtecho.config.requestresponsefilter.constant.RequestResponseConstant;
import com.argusoft.imtecho.config.requestresponsefilter.dao.RequestResponseDetailsDao;
import com.argusoft.imtecho.config.requestresponsefilter.dto.RequestResponseDetailsDto;
import com.argusoft.imtecho.config.requestresponsefilter.service.RequestResponseDetailsService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.Iterator;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * @author ashish
 */
@Service
public class RequestResponseDetailsServiceImpl implements RequestResponseDetailsService {

    public static Map<String, RequestResponseDetailsDto> hm
            = new ConcurrentHashMap<>();

    public static Map<String, Integer> page_title_map
            = new ConcurrentHashMap<>();

    public static Map<String, Integer> url_map
            = new ConcurrentHashMap<>();

    public static final Integer LIST_REMOVE_TIME = 60000; // 10 min
    private static final Logger log = LoggerFactory.getLogger(RequestResponseDetailsServiceImpl.class);
    @Autowired
    RequestResponseDetailsDao requestResponseDetailsDao;

    @Autowired
    private UserUsageAnalyticsDao userUsageAnalyticsDao;

    @Override
    public void checkRequestResponse() {

        Iterator<Map.Entry<String, RequestResponseDetailsDto>> itr = hm.entrySet().iterator();

        while (itr.hasNext()) {
            Map.Entry<String, RequestResponseDetailsDto> entry = itr.next();
            RequestResponseDetailsDto dto = entry.getValue();
            //wait for request gets completed
            if (dto.getEndTime() != null
                    || new Date().getTime() - dto.getStartTime().getTime() > LIST_REMOVE_TIME) {
                insertAndRemoveFromIterator(dto, itr);
            }
        }

    }


    private void insertAndRemoveFromIterator(RequestResponseDetailsDto dto
            , Iterator<Map.Entry<String, RequestResponseDetailsDto>> itr) {

        if (dto.getId() != null) {
            itr.remove();
        } else {
            try {
                requestResponseDetailsDao.createOrUpdate(dto);
            } catch (Exception e) {
                log.error("Exception: during request response enter {0}", e);
            } finally {
                itr.remove();
            }
        }
    }

    @Override
    public void updateEndTimeToDB(Integer id, Date endDate) {
        requestResponseDetailsDao.updateRequestById(id, endDate);
    }

    @Override
    public Integer insertPageTitle(String pageTitle) {
        Integer pageTitleId = requestResponseDetailsDao.insertPageTitle(pageTitle);
        RequestResponseDetailsServiceImpl.page_title_map.put(pageTitle, pageTitleId);
        return pageTitleId;
    }

    @Override
    public void setPageTitleMapping() {
        log.info("Updating Cache Of Page Title Mapping In All Tenant's Memory");
        page_title_map = requestResponseDetailsDao.getPageTitleMapping();
    }

    @Override
    public void setUrlMapping() {
        log.info("Updating Cache Of URL Mapping For Mobile In All Tenant's Memory");
        url_map = requestResponseDetailsDao.getUrlMapping();
    }

    @Override
    public void setApiToBeIgnoredForReqResFilter() {
        log.info("Updating Cache Of APIs To Be Ignored By Regex For Mobile In All Tenant's Memory");
        RequestResponseConstant.API_TO_BE_IGNORED_REGEX_ARRAY = requestResponseDetailsDao.getApiToBeIgnoredForReqResFilter();
    }

    @Override
    public void initCacheVariables() {
//        log.info("::: Initializing Cache Of Request Response Details In All Tenant's Memory :::");
//        Map<String, RequestResponseDetailsDto> requestResponseDetailsMap = new ConcurrentHashMap<>();
//        tenantCacheProviderForRequestResponseDetailsMap.put(requestResponseDetailsMap);
//        tenantCacheProviderForIsFilterAppliedOnEachRequest.put(Boolean.FALSE);
//        List<UserUsageAnalyticsDto> userUsageAnalyticsDtos = new LinkedList<>();
//        tenantCacheProviderForUserUsageAnalyticsDbApiList.put(userUsageAnalyticsDtos);
//        tenantCacheProviderForIsUserUsageAnalyticsActive.put(Boolean.TRUE);
//        tenantCacheProviderForMobileMaxRefreshCount.put(100);
//        tenantCacheProviderForMobileCurrentRefreshCount.put(0);
    }

    @Override
    public Integer insertUrl(String url) {
        Integer urlId = requestResponseDetailsDao.insertUrl(url);
        RequestResponseDetailsServiceImpl.url_map.put(url, urlId);
        return urlId;
    }

    @Override
    public void checkUserUsageList() {
        //      For inserting data of state and their time to db
        Iterator<UserUsageAnalyticsDto> userUsageItr = UserUsageAnalyticsController.USER_USAGE_ANALYTICS_DB_API_LIST.iterator();
        while (userUsageItr.hasNext()) {
            UserUsageAnalyticsDto userUsageAnalyticsDto = userUsageItr.next();
            try {
                insertUserUsageDetails(userUsageAnalyticsDto.getCurrStateId(), userUsageAnalyticsDto.getPageTitle(), userUsageAnalyticsDto.getUserId(), userUsageAnalyticsDto.getActiveTabTime(), userUsageAnalyticsDto.getTotalTime(), userUsageAnalyticsDto.getNextStateId(), userUsageAnalyticsDto.getPrevStateId(), userUsageAnalyticsDto.isBrowserCloseDet());
            } catch (Exception e) {
                log.info(e.getMessage());
            } finally {
                userUsageItr.remove();
            }
        }
    }

    private Integer insertUserUsageDetails(String id, String pageTitle, Integer userId, Long activeTabTime, Long totalTime, String nextStateId, String prevStateId, Boolean isBrowserCloseDet) {
        Integer pageTitleId = getPageTitleId(pageTitle);
        return userUsageAnalyticsDao.insertOrUpdateUserUsageDetails(id, pageTitleId, userId, activeTabTime, totalTime, nextStateId, prevStateId, isBrowserCloseDet);
    }

    private Integer getPageTitleId(String pageTitle) {
        if (pageTitle == null) {
            return -1;
        }
        Integer pageTitleId = getPageTitleId(pageTitle);
        if (pageTitleId == null) {
            pageTitleId = insertPageTitle(pageTitle);
        }
        return pageTitleId;
    }
}