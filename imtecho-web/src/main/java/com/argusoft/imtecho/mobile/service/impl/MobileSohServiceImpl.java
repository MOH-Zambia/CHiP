package com.argusoft.imtecho.mobile.service.impl;

import com.argusoft.imtecho.config.security.ImtechoSecurityUser;
import com.argusoft.imtecho.mobile.dao.SohChartConfigurationDao;
import com.argusoft.imtecho.mobile.dao.SohElementConfigurationDao;
import com.argusoft.imtecho.mobile.dao.SohElementModuleMasterDao;
import com.argusoft.imtecho.mobile.dto.SohChartConfigurationDto;
import com.argusoft.imtecho.mobile.dto.SohElementConfigurationDto;
import com.argusoft.imtecho.mobile.dto.SohElementModuleMasterDto;
import com.argusoft.imtecho.mobile.dto.SohGroupByElementsDto;
import com.argusoft.imtecho.mobile.mapper.SohElementConfigurationMapper;
import com.argusoft.imtecho.mobile.model.SohChartConfiguration;
import com.argusoft.imtecho.mobile.model.SohElementConfiguration;
import com.argusoft.imtecho.mobile.model.SohElementModuleMaster;
import com.argusoft.imtecho.mobile.service.MobileSohService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@Transactional
public class MobileSohServiceImpl implements MobileSohService {

    @Autowired
    private SohElementConfigurationDao sohElementConfigurationDao;

    @Autowired
    private SohElementModuleMasterDao sohElementModuleMasterDao;

    @Autowired
    private SohChartConfigurationDao sohChartConfigurationDao;

    @Autowired
    private ImtechoSecurityUser user;

    @Override
    public List<SohElementConfiguration> getElements() {
        return sohElementConfigurationDao.getAllElements();
    }

    @Override
    public List<SohGroupByElementsDto> getElementsJson(Integer userId) {
        List<SohElementConfiguration> sohElementList ;
        if(userId != null){
            sohElementList = sohElementConfigurationDao.getAllElementsBasedOnPermission(userId);
        }else {
            sohElementList = sohElementConfigurationDao.getAllElements();
        }
        List<SohElementModuleMaster> sohElementModuleList = sohElementModuleMasterDao.getAllModules(true);

        List<SohElementConfigurationDto> sohElementConfigurationDtos = new ArrayList<>();
        List<SohGroupByElementsDto> groupByElementsDtos = new ArrayList<>();

        if (CollectionUtils.isEmpty(sohElementList)) {
            return groupByElementsDtos;
        }

        for (SohElementConfiguration sohElementConfiguration : sohElementList) {
            SohElementConfigurationDto sohElementConfigurationDto = SohElementConfigurationMapper.mapSohElementConfigurationModelToDto(sohElementConfiguration, true);
            sohElementConfigurationDtos.add(sohElementConfigurationDto);
        }

        Map<String, List<SohElementConfigurationDto>> groupedElements = sohElementConfigurationDtos.stream().collect(Collectors.groupingBy(SohElementConfigurationDto::getModule));

        if (!CollectionUtils.isEmpty(sohElementModuleList)) {
            for (SohElementModuleMaster sohElementModuleMaster : sohElementModuleList) {
                if (!CollectionUtils.isEmpty(groupedElements.get(sohElementModuleMaster.getModule()))) {
                    SohGroupByElementsDto sohGroupByElementsDto = new SohGroupByElementsDto();

                    sohGroupByElementsDto.setModule(sohElementModuleMaster.getModule());
                    sohGroupByElementsDto.setModuleName(sohElementModuleMaster.getModuleName());
                    sohGroupByElementsDto.setIsPublic(sohElementModuleMaster.getIsPublic());
                    sohGroupByElementsDto.setModuleOrder(sohElementModuleMaster.getModuleOrder());
                    sohGroupByElementsDto.setState(sohElementModuleMaster.getState());
                    sohGroupByElementsDto.setElements(groupedElements.get(sohElementModuleMaster.getModule()));
                    sohGroupByElementsDto.setFooterDescription(sohElementModuleMaster.getFooterDescription());
                    Boolean isElementsAvailableForDisplay = sohGroupByElementsDto.getElements().stream().filter(data -> Boolean.FALSE.equals(data.getIsHidden())).collect(Collectors.toList()).size() > 0 ? true : false;
                    sohGroupByElementsDto.setElementsAvailableForDisplay(isElementsAvailableForDisplay);
                    groupByElementsDtos.add(sohGroupByElementsDto);
                }
            }
        }

        return groupByElementsDtos;
    }

    @Override
    public SohElementConfiguration getElementById(Integer id) {
        return sohElementConfigurationDao.retrieveById(id);
    }

    @Override
    public void createOrUpdateElement(SohElementConfigurationDto sohElementConfigurationDto) {
        SohElementConfiguration sohElementConfiguration = SohElementConfigurationMapper.mapSohElementConfigurationDtoToModel(sohElementConfigurationDto);
        sohElementConfigurationDao.createOrUpdate(sohElementConfiguration);
    }

    @Override
    public List<SohChartConfigurationDto> getChartsJson() {
        List<SohChartConfiguration> sohChartConfigurations = sohChartConfigurationDao.retrieveAll();

        List<SohChartConfigurationDto> sohChartConfigurationDtos = new ArrayList<>();

        if (CollectionUtils.isEmpty(sohChartConfigurations)) {
            return sohChartConfigurationDtos;
        }

        for (SohChartConfiguration sohChartConfiguration : sohChartConfigurations) {
            SohChartConfigurationDto sohChartConfigurationDto = SohElementConfigurationMapper.mapSohChartConfigurationModelToDto(sohChartConfiguration, true);
            sohChartConfigurationDtos.add(sohChartConfigurationDto);
        }

        return sohChartConfigurationDtos;
    }

    @Override
    public SohChartConfiguration getChartById(Integer id) {
        return sohChartConfigurationDao.retrieveById(id);
    }

    @Override
    public void createOrUpdateChart(SohChartConfigurationDto sohChartConfigurationDto) {
        SohChartConfiguration sohChartConfiguration = SohElementConfigurationMapper.mapSohChartConfigurationDtoToModel(sohChartConfigurationDto);
        sohChartConfigurationDao.createOrUpdate(sohChartConfiguration);
    }

    @Override
    public List<SohElementModuleMaster> getElementModules(Boolean retrieveActiveOnly) {
        return sohElementModuleMasterDao.getAllModules(retrieveActiveOnly);
    }

    @Override
    public SohElementModuleMaster getElementModuleById(Integer id) {
        return sohElementModuleMasterDao.retrieveById(id);
    }

    @Override
    public void createOrUpdateElementModule(SohElementModuleMasterDto sohElementModuleMasterDto) {
        SohElementModuleMaster sohElementModuleMaster = SohElementConfigurationMapper.mapSohElementModuleMasterDtoToModel(sohElementModuleMasterDto, user.getId());
        sohElementModuleMasterDao.createOrUpdate(sohElementModuleMaster);
    }
}
