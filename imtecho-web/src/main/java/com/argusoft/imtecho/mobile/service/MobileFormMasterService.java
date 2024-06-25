package com.argusoft.imtecho.mobile.service;

import com.argusoft.imtecho.mobile.dto.ComponentTagDto;

import java.util.List;

public interface MobileFormMasterService {

    void createMobileFormMaster(List<ComponentTagDto> dtos, String formName);

    List<ComponentTagDto> retrieveMobileFormBySheet(String sheet);
}
