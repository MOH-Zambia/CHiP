package com.argusoft.imtecho.common.controller;

import com.argusoft.imtecho.common.dto.EncryptionKeyAndIVDto;
import com.argusoft.imtecho.common.dto.LoginDto;
import com.argusoft.imtecho.common.dto.MenuConfigDto;
import com.argusoft.imtecho.common.mapper.LoginMapper;
import com.argusoft.imtecho.common.mapper.MenuConfigMapper;
import com.argusoft.imtecho.common.model.MenuConfig;
import com.argusoft.imtecho.common.model.UserMenuItem;
import com.argusoft.imtecho.common.service.MenuConfigService;
import com.argusoft.imtecho.common.util.ConstantUtil;
import com.argusoft.imtecho.common.util.EmailUtil;
import com.argusoft.imtecho.common.util.LoginAESEncryptionKeyManager;
import com.argusoft.imtecho.config.requestresponsefilter.service.RequestResponseDetailsService;
import com.argusoft.imtecho.config.security.ImtechoSecurityUser;
import com.argusoft.imtecho.fcm.service.TechoPushNotificationHandler;
import com.argusoft.imtecho.location.service.HealthInfrastructureService;
import com.argusoft.imtecho.location.service.LocationService;
import com.argusoft.imtecho.mobile.service.MobileFhsService;
import com.argusoft.imtecho.mobile.service.MobileUtilService;
import com.argusoft.imtecho.reportconfig.service.ReportQueueService;
import com.argusoft.imtecho.sms_queue.service.SmsQueueService;
import com.argusoft.imtecho.timer.service.TimerEventService;
import com.argusoft.imtecho.translation.service.TranslatorService;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.support.DefaultListableBeanFactory;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.PostConstruct;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <p>Defines rest endpoints for login</p>
 *
 * @author hshah
 * @since 26/08/2020 10:30
 */
@RestController
@RequestMapping("/api/login")
public class LoginController {

    @Autowired
    private ImtechoSecurityUser user;

    @Autowired
    private MenuConfigService menuConfigService;

    @Autowired
    @Qualifier("timerEventServiceDefault")
    private TimerEventService timerEventService;

    @Autowired
    private SmsQueueService smsQueueService;

    @Autowired
    private LocationService locationService;

    @Autowired
    private MobileUtilService mobileUtilService;

    @Autowired
    private MobileFhsService mobileFhsService;

    @Autowired
    private EmailUtil emailUtil;

    @Autowired
    private HealthInfrastructureService healthInfrastructureService;

    @Autowired
    private RequestResponseDetailsService requestResponseDetailsService;

    @Autowired
    private DefaultListableBeanFactory context;

    @Autowired
    private ReportQueueService reportQueueService;

    @Autowired
    private TechoPushNotificationHandler techoPushNotificationHandler;

    @Autowired
    private TranslatorService translatorService;

    private static final org.slf4j.Logger logger = LoggerFactory.getLogger(LoginController.class);

    @GetMapping(value = "/get-key-and-iv")
    public EncryptionKeyAndIVDto getKeyAndIV() {
        return new EncryptionKeyAndIVDto(LoginAESEncryptionKeyManager.getKey(), LoginAESEncryptionKeyManager.getInitVector());
    }

    /**
     * Returns instance of LoginDto
     *
     * @return An instance of LoginDto
     */
    @GetMapping(value = "/principle")
    public LoginDto getPrinciple() {
        return LoginMapper.convertToLoginDto(user);
    }

    /**
     * Returns a list of main menu with its child menu
     *
     * @return A map of main menu and its child menu
     */
    @GetMapping(value = "/menu")
    public Map<String, List<MenuConfigDto>> getMenuDetail() {

        Map<String, List<MenuConfigDto>> mainMenuDtoMap = new HashMap<>();
        Map<String, List<MenuConfig>> mainMenuConfigMap = new HashMap<>();

        List<MenuConfig> menuConfigList
                = menuConfigService.getActiveMenusByUserIdAndDesignationAndGroup(Boolean.TRUE, user.getId(), user.getRoleId());

        menuConfigList.stream().forEach(menuConfig -> {
            List<MenuConfig> menuConfigs = mainMenuConfigMap.computeIfAbsent(menuConfig.getType(), k -> new ArrayList<>());

            if (!CollectionUtils.isEmpty(menuConfig.getUserMenuItemList())) {
                boolean found = false;
                for (UserMenuItem userMenuItem : menuConfig.getUserMenuItemList()) {
                    if (userMenuItem.getFeatureJson() != null && userMenuItem.getUserId() != null) {
                        menuConfig.setFeatureJson(userMenuItem.getFeatureJson());
                        found = true;
                    }
                }
                if (Boolean.FALSE.equals(found)) {
                    for (UserMenuItem userMenuItem : menuConfig.getUserMenuItemList()) {
                        if (userMenuItem.getFeatureJson() != null && userMenuItem.getRoleId() != null) {
                            menuConfig.setFeatureJson(userMenuItem.getFeatureJson());
                            found = true;
                        }
                    }
                }
                if (Boolean.FALSE.equals(found)) {
                    for (UserMenuItem userMenuItem : menuConfig.getUserMenuItemList()) {
                        if (userMenuItem.getFeatureJson() != null) {
                            menuConfig.setFeatureJson(userMenuItem.getFeatureJson());
                        }
                    }
                }
            }
            menuConfigs.add(menuConfig);
        });

        if (!mainMenuConfigMap.isEmpty()) {
            for (Map.Entry<String, List<MenuConfig>> entrySet : mainMenuConfigMap.entrySet()) {
                String key = entrySet.getKey();
                List<MenuConfig> menuConfigListByType = entrySet.getValue();
                mainMenuDtoMap.put(key, MenuConfigMapper.getMenuConfigAsMenuDtoList(menuConfigListByType, new ArrayList<>(), null, null));
            }
            return mainMenuDtoMap;
        }
        return null;
    }

    @PostConstruct
    public void initApplicationScope() {
        if (!ConstantUtil.SERVER_TYPE.equals("RCH")) {
            if (!ConstantUtil.SERVER_TYPE.equals("DEV")) {
                timerEventService.setNewStatusToProcessingEvents();
                timerEventService.startTimerThread();
                smsQueueService.startSmsThread();
                techoPushNotificationHandler.startPushNotification();
                if (ConstantUtil.SERVER_TYPE.equals("LIVE")) {
                    emailUtil.sendEmail("Server Restarted");
                }
            }
            mobileUtilService.updateProcessingStringsToPendingOnServerStartup();
            smsQueueService.updateStatusFromProcessedToNewOnServerStartup();
        }
        locationService.updateAllActiveLocationsWithWorkerInfo();
        healthInfrastructureService.updateAllHealthInfrastructureForMobile();
        // DO NOT ADD TRY CATCH HERE.. IF YOU ARE FACING ERROR IN THIS CODE.. CONTACT PRATEEK
        mobileFhsService.setXlsSheetsAsComponentTagsInMemory();
        requestResponseDetailsService.setPageTitleMapping();
        requestResponseDetailsService.setUrlMapping();
        requestResponseDetailsService.setApiToBeIgnoredForReqResFilter();
        requestResponseDetailsService.initCacheVariables();
        LoginAESEncryptionKeyManager.generateAndSetKey();
        translatorService.loadAllLanguageLabels();
    }
}
