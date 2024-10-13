package com.argusoft.imtecho.chip.service.impl;

import com.argusoft.imtecho.chip.dao.GbvDao;
import com.argusoft.imtecho.chip.model.GbvVisit;
import com.argusoft.imtecho.chip.service.GbvService;
import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.common.util.DateDeserializer;
import com.argusoft.imtecho.common.util.ImtechoUtil;
import com.argusoft.imtecho.document.dto.DocumentDto;
import com.argusoft.imtecho.fhs.dao.FamilyDao;
import com.argusoft.imtecho.fhs.dao.MemberDao;
import com.argusoft.imtecho.fhs.model.FamilyEntity;
import com.argusoft.imtecho.fhs.model.MemberEntity;
import com.argusoft.imtecho.location.dao.LocationLevelHierarchyDao;
import com.argusoft.imtecho.location.model.LocationLevelHierarchy;
import com.argusoft.imtecho.mobile.dao.SyncStatusDao;
import com.argusoft.imtecho.mobile.dto.GbvDto;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;
import com.argusoft.imtecho.mobile.dto.UploadFileDataBean;
import com.argusoft.imtecho.mobile.mapper.GbvMapper;
import com.argusoft.imtecho.mobile.model.SyncStatus;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
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
    @Autowired
    SyncStatusDao syncStatusDao;

    Gson gson = new Gson();

    @Override
    public Integer storeGbvForm(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap) {
        GbvDto gbvDto = gson.fromJson(parsedRecordBean.getAnswerRecord(), GbvDto.class);


        Integer memberId = null;
        if (gbvDto.getMemberId() != null && !gbvDto.getMemberId().equalsIgnoreCase("null")) {
            memberId = Integer.valueOf(gbvDto.getMemberId());
        } else {
            if (gbvDto.getMemberUuid() != null
                    && !gbvDto.getMemberUuid().equalsIgnoreCase("null")) {
                memberId = memberDao.retrieveMemberByUuid(gbvDto.getMemberUuid()).getId();
            }
        }

        FamilyEntity familyEntity;

        MemberEntity memberEntity = memberDao.retrieveMemberById(memberId);
        familyEntity = familyDao.retrieveFamilyByFamilyId(memberEntity.getFamilyId());
        GbvVisit gbvVisit = new GbvVisit();
        LocationLevelHierarchy locationLevelHierarchy = locationLevelHierarchyDao.retrieveByLocationId(familyEntity.getLocationId());
        gbvVisit.setLocationHierarchyId(locationLevelHierarchy.getId());
        gbvVisit.setLocationId(familyEntity.getAreaId() != null ? familyEntity.getAreaId() : familyEntity.getLocationId());
        gbvVisit.setMemberId(memberEntity.getId());
        gbvVisit.setFamilyId(familyEntity.getId());
        GbvMapper.mapDtoToGbvVisit(gbvDto, gbvVisit);
        return gbvDao.create(gbvVisit);

    }

    @Override
    public Integer storeGbvOcrForm(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap) {
        Gson gson = new GsonBuilder().registerTypeAdapter(Date.class, new DateDeserializer()).create();
        JsonObject jsonObject = JsonParser.parseString(parsedRecordBean.getAnswerRecord()).getAsJsonObject();
        GbvVisit gbvVisit = new GbvVisit();
        MemberEntity member = null;
        if (jsonObject.has("memberId")) {
            member = memberDao.retrieveMemberById(jsonObject.get("memberId").getAsInt());
        } else if (jsonObject.has("memberUuid")) {
            member = memberDao.retrieveMemberByUuid(jsonObject.get("memberUuid").getAsString());
        }
        FamilyEntity family = familyDao.retrieveFamilyByFamilyId(member.getFamilyId());
        gbvVisit.setMemberId(member.getId());
        gbvVisit.setServiceDate(new Date(Long.parseLong(jsonObject.get("serviceDate").getAsString())));
        gbvVisit.setCaseDate(new Date(Long.parseLong(jsonObject.get("caseDate").getAsString())));
        gbvVisit.setThreatenedWithViolencePast12Months(ImtechoUtil.returnTrueFalseFromInitials(jsonObject.get("threatenedWithSexualViolence").getAsString()));
        gbvVisit.setPhysicallyHurtPast12Months(ImtechoUtil.returnTrueFalseFromInitials(jsonObject.get("hurtWithWeaponOrPhysicallyHurt").getAsString()));
        gbvVisit.setForcedSexPast12Months(ImtechoUtil.returnTrueFalseFromInitials(jsonObject.get("forcedToHaveSexAgainstWill").getAsString()));
        gbvVisit.setForcedSexForEssentialsPast12Months(ImtechoUtil.returnTrueFalseFromInitials(jsonObject.get("forcedToHaveSexForBasicEssentials").getAsString()));
        gbvVisit.setPregnantDueToForce(ImtechoUtil.returnTrueFalseFromInitials(jsonObject.get("forcedToBePregnant").getAsString()));
        gbvVisit.setCoercedOrForcedMarriagePast12Months(ImtechoUtil.returnTrueFalseFromInitials(jsonObject.get("forcedIntoMarriage").getAsString()));
        if (member.getGender().equalsIgnoreCase("F")) {
            if (jsonObject.has("areYouPregnant")) {
                member.setIsPregnantFlag(ImtechoUtil.returnTrueFalseFromInitials(jsonObject.get("areYouPregnant").getAsString()));
            }
        }
        memberDao.update(member);
        gbvDao.create(gbvVisit);
        return 0;
    }

    @Override
    public Integer storeMediaData(DocumentDto documentDto, UploadFileDataBean uploadFileDataBean) {
        Integer updatedRows;
        if (uploadFileDataBean.getMemberId() != null) {
            updatedRows = gbvDao.updateDocumentId(uploadFileDataBean.getUniqueId(), documentDto.getId(), null, Math.toIntExact(uploadFileDataBean.getMemberId()));
        } else {
            SyncStatus status = syncStatusDao.retrieveById(uploadFileDataBean.getCheckSum());
            updatedRows = gbvDao.updateDocumentId(uploadFileDataBean.getUniqueId(), documentDto.getId(), status.getRelativeId(), null);
        }
        return updatedRows >= 1 ? 1 : -1;
    }
}
