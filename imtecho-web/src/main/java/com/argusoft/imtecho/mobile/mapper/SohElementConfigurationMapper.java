/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.mobile.mapper;

import com.argusoft.imtecho.mobile.dto.SohChartConfigurationDto;
import com.argusoft.imtecho.mobile.dto.SohElementConfigurationDto;
import com.argusoft.imtecho.mobile.dto.SohElementModuleMasterDto;
import com.argusoft.imtecho.mobile.model.SohChartConfiguration;
import com.argusoft.imtecho.mobile.model.SohElementConfiguration;
import com.argusoft.imtecho.mobile.model.SohElementModuleMaster;
import com.google.gson.Gson;

import java.util.Date;

public class SohElementConfigurationMapper {

    private SohElementConfigurationMapper() {
        throw new IllegalStateException("Utility Class");
    }

    public static SohElementConfiguration mapSohElementConfigurationDtoToModel(SohElementConfigurationDto sohElementConfigurationDto) {
        SohElementConfiguration sohElementConfiguration = new SohElementConfiguration();

        sohElementConfiguration.setId(sohElementConfigurationDto.getId());
        sohElementConfiguration.setElementName(sohElementConfigurationDto.getElementName());
        sohElementConfiguration.setElementDisplayShortName(sohElementConfigurationDto.getElementDisplayShortName());
        sohElementConfiguration.setElementDisplayName(sohElementConfigurationDto.getElementDisplayName());
        sohElementConfiguration.setElementDisplayNamePostfix(sohElementConfigurationDto.getElementDisplayNamePostfix());
        sohElementConfiguration.setEnableReporting(sohElementConfigurationDto.getEnableReporting());
        sohElementConfiguration.setUpperBound(sohElementConfigurationDto.getUpperBound());
        sohElementConfiguration.setLowerBound(sohElementConfigurationDto.getLowerBound());
        sohElementConfiguration.setUpperBoundForRural(sohElementConfigurationDto.getUpperBoundForRural());
        sohElementConfiguration.setLowerBoundForRural(sohElementConfigurationDto.getLowerBoundForRural());
        sohElementConfiguration.setIsSmallValuePositive(sohElementConfigurationDto.getIsSmallValuePositive());
        sohElementConfiguration.setFieldName(sohElementConfigurationDto.getFieldName());
        sohElementConfiguration.setModule(sohElementConfigurationDto.getModule());
        sohElementConfiguration.setTarget(sohElementConfigurationDto.getTarget());
        sohElementConfiguration.setTargetForRural(sohElementConfigurationDto.getTargetForRural());
        sohElementConfiguration.setTargetForUrban(sohElementConfigurationDto.getTargetForUrban());
        sohElementConfiguration.setTargetMid(sohElementConfigurationDto.getTargetMid());
        sohElementConfiguration.setTargetMidEnable(sohElementConfigurationDto.getTargetMidEnable());
        sohElementConfiguration.setIsPublic(sohElementConfigurationDto.getIsPublic());
        sohElementConfiguration.setIsHidden(sohElementConfigurationDto.getIsHidden());
        sohElementConfiguration.setIsTimelineEnable(sohElementConfigurationDto.getIsTimelineEnable());
        sohElementConfiguration.setElementOrder(sohElementConfigurationDto.getOrder());
        sohElementConfiguration.setFileId(sohElementConfigurationDto.getFileId());
        sohElementConfiguration.setTabsJson(sohElementConfigurationDto.getTabsJson());
        sohElementConfiguration.setLastUpdatedAnalytics(sohElementConfigurationDto.getLastUpdatedAnalytics());
        sohElementConfiguration.setState(sohElementConfigurationDto.getState());
        sohElementConfiguration.setCreatedBy(sohElementConfigurationDto.getCreatedBy());
        sohElementConfiguration.setCreatedOn(sohElementConfigurationDto.getCreatedOn());
        sohElementConfiguration.setModifiedBy(sohElementConfigurationDto.getModifiedBy());
        sohElementConfiguration.setModifiedOn(sohElementConfigurationDto.getModifiedOn());
        sohElementConfiguration.setFooterDescription(sohElementConfigurationDto.getFooterDescription());
        sohElementConfiguration.setIsFilterEnable(sohElementConfigurationDto.getIsFilterEnable());
        sohElementConfiguration.setShowInMenu(sohElementConfigurationDto.getShowInMenu());
        sohElementConfiguration.setRankFieldName(sohElementConfigurationDto.getRankFieldName());
        return sohElementConfiguration;
    }

    public static SohElementConfigurationDto mapSohElementConfigurationModelToDto(SohElementConfiguration sohElementConfiguration, Boolean getParsedJson) {
        SohElementConfigurationDto sohElementConfigurationDto = new SohElementConfigurationDto();

        sohElementConfigurationDto.setId(sohElementConfiguration.getId());
        sohElementConfigurationDto.setElementName(sohElementConfiguration.getElementName());
        sohElementConfigurationDto.setElementDisplayShortName(sohElementConfiguration.getElementDisplayShortName());
        sohElementConfigurationDto.setElementDisplayName(sohElementConfiguration.getElementDisplayName());
        sohElementConfigurationDto.setElementDisplayNamePostfix(sohElementConfiguration.getElementDisplayNamePostfix());
        sohElementConfigurationDto.setEnableReporting(sohElementConfiguration.getEnableReporting());
        sohElementConfigurationDto.setUpperBound(sohElementConfiguration.getUpperBound());
        sohElementConfigurationDto.setLowerBound(sohElementConfiguration.getLowerBound());
        sohElementConfigurationDto.setUpperBoundForRural(sohElementConfiguration.getUpperBoundForRural());
        sohElementConfigurationDto.setLowerBoundForRural(sohElementConfiguration.getLowerBoundForRural());
        sohElementConfigurationDto.setIsSmallValuePositive(sohElementConfiguration.getIsSmallValuePositive());
        sohElementConfigurationDto.setFieldName(sohElementConfiguration.getFieldName());
        sohElementConfigurationDto.setModule(sohElementConfiguration.getModule());
        sohElementConfigurationDto.setTarget(sohElementConfiguration.getTarget());
        sohElementConfigurationDto.setTargetForRural(sohElementConfiguration.getTargetForRural());
        sohElementConfigurationDto.setTargetForUrban(sohElementConfiguration.getTargetForUrban());
        sohElementConfigurationDto.setTargetMid(sohElementConfiguration.getTargetMid());
        sohElementConfigurationDto.setTargetMidEnable(sohElementConfiguration.getTargetMidEnable());
        sohElementConfigurationDto.setIsPublic(sohElementConfiguration.getIsPublic());
        sohElementConfigurationDto.setIsHidden(sohElementConfiguration.getIsHidden());
        sohElementConfigurationDto.setIsTimelineEnable(sohElementConfiguration.getIsTimelineEnable());
        sohElementConfigurationDto.setOrder(sohElementConfiguration.getElementOrder());
        sohElementConfigurationDto.setFileId(sohElementConfiguration.getFileId());
        sohElementConfigurationDto.setLastUpdatedAnalytics(sohElementConfiguration.getLastUpdatedAnalytics());
        sohElementConfigurationDto.setState(sohElementConfiguration.getState());
        sohElementConfigurationDto.setCreatedBy(sohElementConfiguration.getCreatedBy());
        sohElementConfigurationDto.setCreatedOn(sohElementConfiguration.getCreatedOn());
        sohElementConfigurationDto.setModifiedBy(sohElementConfiguration.getModifiedBy());
        sohElementConfigurationDto.setModifiedOn(sohElementConfiguration.getModifiedOn());
        sohElementConfigurationDto.setFooterDescription(sohElementConfiguration.getFooterDescription());
        sohElementConfigurationDto.setIsFilterEnable(sohElementConfiguration.getIsFilterEnable());
        sohElementConfigurationDto.setShowInMenu(sohElementConfiguration.getShowInMenu());
        sohElementConfigurationDto.setRankFieldName(sohElementConfiguration.getRankFieldName());
        if (getParsedJson) {
            Object tabs = new Gson().fromJson(sohElementConfiguration.getTabsJson(), Object.class);
            sohElementConfigurationDto.setTabs(tabs);
        } else {
            sohElementConfigurationDto.setTabsJson(sohElementConfiguration.getTabsJson());
        }

        return sohElementConfigurationDto;
    }

    public static SohChartConfiguration mapSohChartConfigurationDtoToModel(SohChartConfigurationDto sohChartConfigurationDto) {
        SohChartConfiguration sohChartConfiguration = new SohChartConfiguration();

        sohChartConfiguration.setId(sohChartConfigurationDto.getId());
        sohChartConfiguration.setName(sohChartConfigurationDto.getName());
        sohChartConfiguration.setDisplayName(sohChartConfigurationDto.getDisplayName());
        sohChartConfiguration.setFromDate(sohChartConfigurationDto.getFromDate());
        sohChartConfiguration.setToDate(sohChartConfigurationDto.getToDate());
        sohChartConfiguration.setConfigurationJson(sohChartConfigurationDto.getConfigurationJson());
        sohChartConfiguration.setModule(sohChartConfigurationDto.getModule());
        sohChartConfiguration.setQueryName(sohChartConfigurationDto.getQueryName());
        sohChartConfiguration.setChartType(sohChartConfigurationDto.getChartType());
        sohChartConfiguration.setChartOrder(sohChartConfigurationDto.getChartOrder());
        sohChartConfiguration.setCreatedBy(sohChartConfigurationDto.getCreatedBy());
        sohChartConfiguration.setCreatedOn(sohChartConfigurationDto.getCreatedOn());
        sohChartConfiguration.setModifiedBy(sohChartConfigurationDto.getModifiedBy());
        sohChartConfiguration.setModifiedOn(sohChartConfigurationDto.getModifiedOn());

        return sohChartConfiguration;
    }

    public static SohChartConfigurationDto mapSohChartConfigurationModelToDto(SohChartConfiguration sohChartConfiguration, Boolean getParsedJson) {
        SohChartConfigurationDto sohChartConfigurationDto = new SohChartConfigurationDto();

        sohChartConfigurationDto.setId(sohChartConfiguration.getId());
        sohChartConfigurationDto.setName(sohChartConfiguration.getName());
        sohChartConfigurationDto.setDisplayName(sohChartConfiguration.getDisplayName());
        sohChartConfigurationDto.setFromDate(sohChartConfiguration.getFromDate());
        sohChartConfigurationDto.setToDate(sohChartConfiguration.getToDate());
        sohChartConfigurationDto.setModule(sohChartConfiguration.getModule());
        sohChartConfigurationDto.setQueryName(sohChartConfiguration.getQueryName());
        sohChartConfigurationDto.setChartType(sohChartConfiguration.getChartType());
        sohChartConfigurationDto.setChartOrder(sohChartConfiguration.getChartOrder());
        sohChartConfigurationDto.setCreatedBy(sohChartConfiguration.getCreatedBy());
        sohChartConfigurationDto.setCreatedOn(sohChartConfiguration.getCreatedOn());
        sohChartConfigurationDto.setModifiedBy(sohChartConfiguration.getModifiedBy());
        sohChartConfigurationDto.setModifiedOn(sohChartConfiguration.getModifiedOn());

        if (getParsedJson) {
            Object configuration = new Gson().fromJson(sohChartConfiguration.getConfigurationJson(), Object.class);
            sohChartConfigurationDto.setConfiguration(configuration);
        } else {
            sohChartConfigurationDto.setConfigurationJson(sohChartConfiguration.getConfigurationJson());
        }

        return sohChartConfigurationDto;
    }

    public static SohElementModuleMaster mapSohElementModuleMasterDtoToModel(SohElementModuleMasterDto sohElementModuleMasterDto, Integer loggedInUserId) {
        SohElementModuleMaster sohElementModuleMaster = new SohElementModuleMaster();

        sohElementModuleMaster.setId(sohElementModuleMasterDto.getId());
        sohElementModuleMaster.setModule(sohElementModuleMasterDto.getModule());
        sohElementModuleMaster.setModuleName(sohElementModuleMasterDto.getModuleName());
        sohElementModuleMaster.setModuleOrder(sohElementModuleMasterDto.getModuleOrder());
        sohElementModuleMaster.setIsPublic(sohElementModuleMasterDto.getIsPublic());
        sohElementModuleMaster.setState(sohElementModuleMasterDto.getState());
        sohElementModuleMaster.setFooterDescription(sohElementModuleMasterDto.getFooterDescription());

        if (sohElementModuleMasterDto.getId() != null) {
            sohElementModuleMaster.setCreatedBy(sohElementModuleMasterDto.getCreatedBy());
            sohElementModuleMaster.setCreatedOn(sohElementModuleMasterDto.getCreatedOn());
        } else {
            sohElementModuleMaster.setCreatedBy(loggedInUserId);
            sohElementModuleMaster.setCreatedOn(new Date());
        }
        sohElementModuleMaster.setModifiedBy(loggedInUserId);
        sohElementModuleMaster.setModifiedOn(new Date());

        return sohElementModuleMaster;
    }

    public static SohElementModuleMasterDto mapSohElementModuleMasterModelToDto(SohElementModuleMaster sohElementModuleMaster) {
        SohElementModuleMasterDto sohElementModuleMasterDto = new SohElementModuleMasterDto();

        sohElementModuleMasterDto.setId(sohElementModuleMaster.getId());
        sohElementModuleMasterDto.setModule(sohElementModuleMaster.getModule());
        sohElementModuleMasterDto.setModuleName(sohElementModuleMaster.getModuleName());
        sohElementModuleMasterDto.setModuleOrder(sohElementModuleMaster.getModuleOrder());
        sohElementModuleMasterDto.setIsPublic(sohElementModuleMaster.getIsPublic());
        sohElementModuleMasterDto.setState(sohElementModuleMaster.getState());

        sohElementModuleMasterDto.setCreatedBy(sohElementModuleMaster.getCreatedBy());
        sohElementModuleMasterDto.setCreatedOn(sohElementModuleMaster.getCreatedOn());
        sohElementModuleMasterDto.setModifiedBy(sohElementModuleMaster.getModifiedBy());
        sohElementModuleMasterDto.setModifiedOn(sohElementModuleMaster.getModifiedOn());

        return sohElementModuleMasterDto;
    }
}
