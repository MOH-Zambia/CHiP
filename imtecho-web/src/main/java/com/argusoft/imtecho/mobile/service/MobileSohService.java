package com.argusoft.imtecho.mobile.service;

import com.argusoft.imtecho.mobile.dto.SohChartConfigurationDto;
import com.argusoft.imtecho.mobile.dto.SohElementConfigurationDto;
import com.argusoft.imtecho.mobile.dto.SohElementModuleMasterDto;
import com.argusoft.imtecho.mobile.dto.SohGroupByElementsDto;
import com.argusoft.imtecho.mobile.model.SohChartConfiguration;
import com.argusoft.imtecho.mobile.model.SohElementConfiguration;
import com.argusoft.imtecho.mobile.model.SohElementModuleMaster;

import java.util.List;

public interface MobileSohService {

    List<SohElementConfiguration> getElements();

    List<SohGroupByElementsDto> getElementsJson(Integer userId);

    SohElementConfiguration getElementById(Integer id);

    void createOrUpdateElement(SohElementConfigurationDto sohElementConfigurationDto);

    List<SohChartConfigurationDto> getChartsJson();

    SohChartConfiguration getChartById(Integer id);

    void createOrUpdateChart(SohChartConfigurationDto sohChartConfigurationDto);

    List<SohElementModuleMaster> getElementModules(Boolean retrieveActiveOnly);

    SohElementModuleMaster getElementModuleById(Integer id);

    void createOrUpdateElementModule(SohElementModuleMasterDto sohElementModuleMasterDto);
}
