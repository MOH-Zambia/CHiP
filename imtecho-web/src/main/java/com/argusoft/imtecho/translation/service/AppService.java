package com.argusoft.imtecho.translation.service;

import com.argusoft.imtecho.translation.dto.AppDto;
import com.argusoft.imtecho.translation.model.App;

import java.util.List;

public interface AppService {
    void createOrUpdate(AppDto appDto);
    List<App> getAllApp();
}
