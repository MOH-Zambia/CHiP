package com.argusoft.imtecho.common.util;

import com.argusoft.imtecho.common.service.SystemConfigurationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class Dhis2ConstantsUtil {

    @Autowired
    private SystemConfigurationService systemConfigurationService;

    private Dhis2ConstantsUtil(){

    }

    public String getDhis2Api(){
        return systemConfigurationService.retrieveSystemConfigurationByKey("DHIS2_API_URL").getKeyValue();
    }
}
