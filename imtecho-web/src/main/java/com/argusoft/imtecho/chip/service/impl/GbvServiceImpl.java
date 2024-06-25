package com.argusoft.imtecho.chip.service.impl;

import com.argusoft.imtecho.chip.dao.GbvDao;
import com.argusoft.imtecho.chip.model.GbvVisit;
import com.argusoft.imtecho.chip.service.GbvService;
import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.fhs.dao.FamilyDao;
import com.argusoft.imtecho.fhs.dao.MemberDao;
import com.argusoft.imtecho.fhs.model.FamilyEntity;
import com.argusoft.imtecho.fhs.model.MemberEntity;
import com.argusoft.imtecho.location.dao.LocationLevelHierarchyDao;
import com.argusoft.imtecho.location.model.LocationLevelHierarchy;
import com.argusoft.imtecho.mobile.dto.GbvDto;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;
import com.argusoft.imtecho.mobile.mapper.GbvMapper;
import com.google.gson.Gson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

@Service
@Transactional
public class GbvServiceImpl implements GbvService {

    @Autowired
    MemberDao memberDao;

    @Autowired
    FamilyDao familyDao;

    @Autowired
    GbvDao gbvDao;

    @Autowired
    LocationLevelHierarchyDao locationLevelHierarchyDao;

    Gson gson = new Gson();

    @Override
    public Integer storeGbvForm(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap) {
        GbvDto gbvDto = gson.fromJson(parsedRecordBean.getAnswerRecord(), GbvDto.class);
        MemberEntity memberEntity = memberDao.retrieveMemberById(Integer.valueOf(gbvDto.getMemberId()));
        FamilyEntity familyEntity = familyDao.retrieveFamilyByFamilyId(memberEntity.getFamilyId());
        GbvVisit gbvVisit = new GbvVisit();
        LocationLevelHierarchy locationLevelHierarchy = locationLevelHierarchyDao.retrieveByLocationId(familyEntity.getLocationId());
        gbvVisit.setLocationHierarchyId(locationLevelHierarchy.getId());
        gbvVisit.setLocationId(familyEntity.getAreaId() != null ? familyEntity.getAreaId() : familyEntity.getLocationId());
        GbvMapper.mapDtoToGbvVisit(gbvDto, gbvVisit);
        return gbvDao.create(gbvVisit);

    }
}
