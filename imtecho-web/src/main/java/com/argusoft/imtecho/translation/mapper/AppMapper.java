package com.argusoft.imtecho.translation.mapper;

import com.argusoft.imtecho.translation.dto.AppDto;
import com.argusoft.imtecho.translation.model.App;

public class AppMapper {

    public static App convertDtoToMaster(AppDto appDto, App existingApp) {
        App app = new App();
        if (existingApp != null) {
            app = existingApp;
        }
        app.setAppKey(appDto.getAppKey());
        app.setAppValue(appDto.getAppValue());
        app.setIsActive(appDto.getIsActive());
        return app;
    }
}
