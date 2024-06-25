package com.argusoft.imtecho.common.controller;

import com.argusoft.imtecho.common.dto.UserUsageAnalyticsDto;
import com.argusoft.imtecho.common.service.UserUsageAnalyticsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.LinkedList;
import java.util.List;

/**
 * <p>Defines rest end points for user usage</p>
 * @since 26/08/2020 10:30
 */
@RestController
@RequestMapping("/api/insert_user_analytics_details")
public class UserUsageAnalyticsController {

    public static boolean isUserAnalyticsActive = true;

    public static List<UserUsageAnalyticsDto> USER_USAGE_ANALYTICS_DB_API_LIST = new LinkedList<>();

    @Autowired
    private UserUsageAnalyticsService userUsageAnalyticsService;
    /**
     * Create user usage analytics
     * @param userUsageAnalyticsDto An instance of UserUsageAnalyticsDto
     */
    @PostMapping(value = "")
    public void addUserUsageDetails(@RequestBody UserUsageAnalyticsDto userUsageAnalyticsDto) {
        if (isUserAnalyticsActive && userUsageAnalyticsDto.getCurrStateId() != null) {
            USER_USAGE_ANALYTICS_DB_API_LIST.add(userUsageAnalyticsDto);
        }
    }

}
