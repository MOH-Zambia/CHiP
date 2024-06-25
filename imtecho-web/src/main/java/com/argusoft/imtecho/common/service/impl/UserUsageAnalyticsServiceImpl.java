package com.argusoft.imtecho.common.service.impl;

import com.argusoft.imtecho.common.dao.UserUsageAnalyticsDao;
import com.argusoft.imtecho.common.service.UserUsageAnalyticsService;
import com.argusoft.imtecho.config.RequestResponseLoggingFilter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Implements methods of UserUsageAnalyticsService
 *
 * @author ashish
 * @since 28/08/2020 4:30
 */
@Service
@Transactional
public class UserUsageAnalyticsServiceImpl implements UserUsageAnalyticsService {

    @Autowired
    private UserUsageAnalyticsDao userUsageAnalyticsDao;

    @Autowired
    private RequestResponseLoggingFilter requestResponseLoggingFilter;

    /**
     * {@inheritDoc}
     */
//    @Override
//    public Integer insertUserUsageDetails(String id, String pageTitle, Integer userId, Long activeTabTime, Long totalTime, String nextStateId, String prevStateId, Boolean isBrowserCloseDet) {
//        Integer pageTitleId = requestResponseLoggingFilter.getPageTitleId(pageTitle);
//        return userUsageAnalyticsDao.insertOrUpdateUserUsageDetails(id, pageTitleId, userId, activeTabTime, totalTime, nextStateId, prevStateId, isBrowserCloseDet);
//    }

//    public void upload() {
//        if(tenantCacheProviderForIsUserUsageAnalyticsActive.get()) {
//            if (tenantCacheProviderForUserUsageAnalyticsDbApiList.get().size() > 0) {
//                for (UserUsageAnalyticsDto userUsageAnalyticsDto : tenantCacheProviderForUserUsageAnalyticsDbApiList.get()
//                ) {
//                    this.insertUserUsageDetails(userUsageAnalyticsDto.getCurrStateId(), userUsageAnalyticsDto.getPageTitle(), userUsageAnalyticsDto.getUserId(), userUsageAnalyticsDto.getActiveTabTime(), userUsageAnalyticsDto.getTotalTime(), userUsageAnalyticsDto.getNextStateId(), userUsageAnalyticsDto.getPrevStateId(), userUsageAnalyticsDto.isBrowserCloseDet());
//                }
//            }
//            tenantCacheProviderForUserUsageAnalyticsDbApiList.get().clear();
//        }
//    }
}
