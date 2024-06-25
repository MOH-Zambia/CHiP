package com.argusoft.imtecho.chip.service.impl;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.common.util.SystemConstantUtil;
import com.argusoft.imtecho.dashboard.fhs.constants.FamilyHealthSurveyServiceConstants;
import com.argusoft.imtecho.event.dto.Event;
import com.argusoft.imtecho.event.service.EventHandler;
import com.argusoft.imtecho.fhs.dao.FamilyDao;
import com.argusoft.imtecho.fhs.dao.MemberDao;
import com.argusoft.imtecho.fhs.dto.MemberAdditionalInfo;
import com.argusoft.imtecho.fhs.model.FamilyEntity;
import com.argusoft.imtecho.fhs.model.MemberEntity;
import com.argusoft.imtecho.fhs.service.FamilyHealthSurveyService;
import com.argusoft.imtecho.mobile.dto.HouseHoldLineListMobileDto;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;
import com.argusoft.imtecho.mobile.mapper.HouseHoldLineListMobileMapper;
import com.argusoft.imtecho.chip.service.MobileHouseHoldLineListService;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.*;

@Service
@Transactional
public class MobileHouseHoldLineListServiceImpl implements MobileHouseHoldLineListService {

    @Autowired
    private FamilyDao familyDao;
    @Autowired
    private MemberDao memberDao;
    @Autowired
    private EventHandler eventHandler;
    @Autowired
    private FamilyHealthSurveyService familyHealthSurveyService;
    private static final Gson gson = new Gson();

    @Override
    public Map<String, String> storeHouseHoldLineListForm(ParsedRecordBean parsedRecordBean, UserMaster user) {
        Map<String, String> returnMap = new LinkedHashMap<>();
        StringBuilder returnMessage = new StringBuilder();
        HouseHoldLineListMobileDto houseHoldLineListMobileDto = gson.fromJson(parsedRecordBean.getAnswerRecord(), HouseHoldLineListMobileDto.class);

        //Updating Family Details
        FamilyEntity family;
        if (houseHoldLineListMobileDto.getFamilyNumber() == null || houseHoldLineListMobileDto.getFamilyNumber().contains("TMP")) {
            family = new FamilyEntity();
            HouseHoldLineListMobileMapper.convertHouseHoldLineListDtoToFamilyEntity(houseHoldLineListMobileDto, family);
            family.setFamilyId(familyHealthSurveyService.generateFamilyId());
            family.setState(FamilyHealthSurveyServiceConstants.CFHC_FAMILY_STATE_NEW);
            if (houseHoldLineListMobileDto.getLocationId() != null) {
                family.setLocationId(houseHoldLineListMobileDto.getLocationId());
                family.setAreaId(houseHoldLineListMobileDto.getLocationId());
            }

            //For WorkLog in mobile
            returnMessage.append("Family ID : ");
            returnMessage.append(family.getFamilyId());
            returnMessage.append("\n");
            returnMessage.append("\n");
        } else {
            family = familyDao.retrieveFamilyByFamilyId(houseHoldLineListMobileDto.getFamilyNumber());
            HouseHoldLineListMobileMapper.convertHouseHoldLineListDtoToFamilyEntity(houseHoldLineListMobileDto, family);
            family.setState(getFamilyStateAccordingToPreviousState(family.getState()));
        }

        List<MemberEntity> membersEntitiesInFamily = new LinkedList<>();
        int loopId = 0;

        MemberEntity femaleHofMember = null;
        MemberEntity maleHofMember = null;
        MemberEntity hofHusbandOrWifeMember = null;
        Map<Integer, MemberEntity> memberLoopIdMap = new HashMap<>();

        //Updating member details
        for (HouseHoldLineListMobileDto.MemberDetails memberDetails : houseHoldLineListMobileDto.getMemberDetails()) {
            MemberEntity member;
            if (memberDetails.getUniqueHealthId() != null && !memberDetails.getUniqueHealthId().contains("UN")) {
                member = memberDao.retrieveMemberByUniqueHealthId(memberDetails.getUniqueHealthId());
                member.setState(FamilyHealthSurveyServiceConstants.CFHC_MEMBER_STATE_VERIFIED);
                HouseHoldLineListMobileMapper.convertMemberDetailsToMemberEntity(memberDetails, member, true);
            } else {
                member = new MemberEntity();
                member.setUniqueHealthId(familyHealthSurveyService.generateMemberUniqueHealthId());
                member.setFamilyId(family.getFamilyId());
                member.setState(FamilyHealthSurveyServiceConstants.CFHC_MEMBER_STATE_NEW);
                HouseHoldLineListMobileMapper.convertMemberDetailsToMemberEntity(memberDetails, member, false);
            }

            //Setting data for WorkLog
            if (loopId != 0) {
                returnMessage.append("\n");
            }
            returnMessage.append(member.getUniqueHealthId());
            returnMessage.append(" - ");
            returnMessage.append(member.getFirstName());
            if (member.getMiddleName() != null && !member.getMiddleName().isEmpty()) {
                returnMessage.append(" ");
                returnMessage.append(member.getMiddleName());
            }
            returnMessage.append(" ");
            returnMessage.append(member.getLastName());

            if (Boolean.TRUE.equals(member.getFamilyHeadFlag())) {
                StringBuilder familyTitle = new StringBuilder();
                familyTitle.append(family.getFamilyId()).append(" - ").append(member.getFirstName());
                if (member.getMiddleName() != null && !member.getMiddleName().isEmpty()) {
                    familyTitle.append(" ").append(member.getMiddleName());
                }
                familyTitle.append(" ").append(member.getLastName());
                returnMap.put("familyId", familyTitle.toString());
            }

            memberDao.createMember(member);

            if (Boolean.TRUE.equals(member.getFamilyHeadFlag()) && member.getGender().equalsIgnoreCase("F")) {
                femaleHofMember = member;
            }

            if (Boolean.TRUE.equals(member.getFamilyHeadFlag()) && member.getGender().equalsIgnoreCase("M")) {
                maleHofMember = member;
            }

            if ("WIFE".equalsIgnoreCase(member.getRelationWithHof()) ||
                    "HUSBAND".equalsIgnoreCase(member.getRelationWithHof())) {
                hofHusbandOrWifeMember = member;
            }

            if (femaleHofMember != null && hofHusbandOrWifeMember != null) {
                femaleHofMember.setHusbandId(hofHusbandOrWifeMember.getId());
            }

            if (maleHofMember != null && hofHusbandOrWifeMember != null) {
                hofHusbandOrWifeMember.setHusbandId(maleHofMember.getId());
            }

            checkIfDuplicateIdProofExists(memberDetails, member);
            updateAdditionalInfoForMember(member);

            member.setIsPregnantFlag(memberDetails.getIsWomanPregnant());
            member.setMarkedPregnant(Boolean.TRUE.equals(member.getIsPregnantFlag()));

            memberDao.update(member);
            memberDao.flush();
            membersEntitiesInFamily.add(member);
            memberLoopIdMap.put(loopId, member);
            loopId++;
        }

        if (houseHoldLineListMobileDto.getMotherRelation() != null) {
            motherChildRelation(houseHoldLineListMobileDto.getMotherRelation(), memberLoopIdMap);
        }
        if (houseHoldLineListMobileDto.getHusbandRelation() != null) {
            husbandWifeRelation(houseHoldLineListMobileDto.getHusbandRelation(), memberLoopIdMap);
        }

        setContactPersonAndHofIdInFamily(membersEntitiesInFamily, family);

        familyDao.create(family);
        familyDao.flush();

        returnMap.put("message", returnMessage.toString());
        returnMap.put("createdInstanceId", family.getId().toString());
        newFamilyMsg(family, membersEntitiesInFamily, returnMap);
        markPregnancyEvent(membersEntitiesInFamily);
        return returnMap;
    }

    private void markPregnancyEvent(List<MemberEntity> membersEntitiesInFamily) {
        for (MemberEntity member : membersEntitiesInFamily) {
            if (Boolean.TRUE.equals(member.isMarkedPregnant())) {
                eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.PREGNANCY_MARK, member.getId()));
            }
        }
    }

    @Override
    public Map<String, String> storeMemberUpdateFormZambia(ParsedRecordBean parsedRecordBean, UserMaster user) {
        Map<String, String> returnMap = new LinkedHashMap<>();
        MemberEntity memberEntity;
        FamilyEntity family;
        HouseHoldLineListMobileDto houseHoldLineListMobileDto = gson.fromJson(parsedRecordBean.getAnswerRecord(), HouseHoldLineListMobileDto.class);

        String familyUUid = null;
        if (houseHoldLineListMobileDto.getUuid() != null) {
            familyUUid = houseHoldLineListMobileDto.getUuid();
        }

        for (HouseHoldLineListMobileDto.MemberDetails memberDetails : houseHoldLineListMobileDto.getMemberDetails()) {
            if (memberDetails.getUniqueHealthId() != null) {
                //first search if members unique health id is present if not search with uuid
                memberEntity = memberDao.retrieveMemberByUniqueHealthId(memberDetails.getUniqueHealthId());
                if (memberEntity == null) {
                    memberEntity = memberDao.retrieveMemberByUuid(memberDetails.getMemberUuid() != null ? memberDetails.getMemberUuid() : "");
                }
                family = familyDao.retrieveFamilyByFamilyId(memberEntity.getFamilyId());
            } else {
                memberEntity = new MemberEntity();
                //first search if family_id for family is present if not search with families uuid
                family = familyDao.retrieveFamilyByFamilyId(memberDetails.getFamilyId());
                if (family == null) {
                    family = familyDao.retrieveFamilyByUuid(familyUUid != null ? familyUUid : "");
                }
                memberEntity.setFamilyId(family.getFamilyId());
                memberEntity.setUniqueHealthId(familyHealthSurveyService.generateMemberUniqueHealthId());
                memberEntity.setState(FamilyHealthSurveyServiceConstants.FHS_MEMBER_STATE_NEW);
            }

            if (memberDetails.getMemberStatus() != null && (memberDetails.getMemberStatus().equals("DEATH"))) {
                familyHealthSurveyService.markMemberAsDeathZambia(memberDetails.getDeathDate(), memberDetails.getDeathPlace(), memberDetails.getOtherDeathPlace(), memberDetails.getDeathReason(),
                        memberDetails.getOtherDeathReason(), memberDetails.getDeathHealthInfraId(), memberEntity.getId(),
                        family.getId(), family.getAreaId() != null ? family.getAreaId() : family.getLocationId(),
                        user.getId(), "MEMBER_UPDATE_NEW", memberEntity.getId());
                returnMap.put("createdInstanceId", memberEntity.getId().toString());
                return returnMap;
            } else {
                boolean alreadyPregnant = memberEntity.getIsPregnantFlag() != null && memberEntity.getIsPregnantFlag();
                memberEntity.setIsPregnantFlag(memberDetails.getIsWomanPregnant());
                memberEntity.setMarkedPregnant(!alreadyPregnant && Boolean.TRUE.equals(memberEntity.getIsPregnantFlag()));

                HouseHoldLineListMobileMapper.convertMemberDetailsToMemberEntity(memberDetails, memberEntity, memberEntity.getId() != null);
                checkIfDuplicateIdProofExists(memberDetails, memberEntity);
                updateAdditionalInfoForMember(memberEntity);

                if (memberEntity.getId() != null) {
                    memberDao.update(memberEntity);
                } else {
                    memberDao.create(memberEntity);
                }
            }

            returnMap.put("createdInstanceId", memberEntity.getId().toString());

            if (memberDetails.getUniqueHealthId() == null) {
                StringBuilder sb = new StringBuilder();
                sb.append(memberEntity.getUniqueHealthId());
                sb.append("-");
                sb.append(memberEntity.getFirstName());
                sb.append(" ");
                if (memberEntity.getMiddleName() != null && !memberEntity.getMiddleName().isEmpty()) {
                    sb.append(memberEntity.getMiddleName());
                    sb.append(" ");
                }
                sb.append(memberEntity.getLastName());
                returnMap.put("memberId", sb.toString());

                sb = new StringBuilder();
                sb.append("New Member Added");
                sb.append("\n");
                sb.append("\n");
                sb.append("Family ID : ");
                sb.append(memberEntity.getFamilyId());
                sb.append("\n");
                sb.append("Member ID : ");
                sb.append(memberEntity.getUniqueHealthId());
                sb.append("\n");
                sb.append("Member Name : ");
                sb.append(memberEntity.getFirstName());
                sb.append(" ");
                if (memberEntity.getMiddleName() != null && !memberEntity.getMiddleName().isEmpty()) {
                    sb.append(memberEntity.getMiddleName());
                    sb.append(" ");
                }
                sb.append(memberEntity.getLastName());
                returnMap.put("message", sb.toString());
            }

            if (memberEntity.isDuplicateNrc()) {
                StringBuilder sb1 = new StringBuilder();
                sb1.append("\n");
                sb1.append(" ");
                sb1.append(String.format("Entered NRC number %s already exists in the system for this member please update member from health services", memberEntity.getDuplicateNrcNumber()));
                sb1.append(" ");
                sb1.append("\n");
                returnMap.put("message", sb1.toString());
            }

            if (memberEntity.isDuplicatePassport()) {
                StringBuilder sb2 = new StringBuilder();
                sb2.append("\n");
                sb2.append(" ");
                sb2.append(String.format("Entered passport number %s already exists in the system for this member please update member from health services", memberEntity.getDuplicatePassportNumber()));
                sb2.append(" ");
                sb2.append("\n");
                returnMap.put("message", sb2.toString());
            }

            if (memberEntity.isDuplicateBirthCert()) {
                StringBuilder sb2 = new StringBuilder();
                sb2.append("\n");
                sb2.append(" ");
                sb2.append(String.format("Entered birth certificate Number %s already exists in the system for this member please update member from health services", memberEntity.getDuplicateBirthCertNumber()));
                sb2.append(" ");
                sb2.append("\n");
                returnMap.put("message", sb2.toString());
            }

            memberDao.flush();
            if (Boolean.TRUE.equals(memberEntity.isMarkedPregnant())) {
                eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.PREGNANCY_MARK, memberEntity.getId()));
            }
            return returnMap;
        }
        return null;
    }

    @Override
    public MemberEntity retrieveMemberByUuid(String uuid) {
        return memberDao.retrieveMemberByUuid(uuid);
    }

    private void checkIfDuplicateIdProofExists(HouseHoldLineListMobileDto.MemberDetails memberDetails, MemberEntity memberEntity) {
        if (memberDetails.getNRCNumber() != null && !memberDetails.getNRCNumber().trim().isEmpty()) {
            if (!memberDao.checkSameNrcExists(memberDetails.getNRCNumber())) {
                memberEntity.setNrcNumber(memberDetails.getNRCNumber());
            } else {
                memberEntity.setDuplicateNrc(true);
                memberEntity.setDuplicateNrcNumber(memberDetails.getNRCNumber());
                memberEntity.setNrcNumber(null);
            }
        }

        if (memberDetails.getPassportNumber() != null && !memberDetails.getPassportNumber().trim().isEmpty()) {
            if (!memberDao.checkSamePassportExists(memberDetails.getPassportNumber().toUpperCase(Locale.ROOT))) {
                memberEntity.setPassportNumber(memberDetails.getPassportNumber().toUpperCase(Locale.ROOT));
            } else {
                memberEntity.setDuplicatePassport(true);
                memberEntity.setDuplicatePassportNumber(memberDetails.getPassportNumber());
                memberEntity.setPassportNumber(null);
            }
        }

        if (memberDetails.getBirthCertificateNumber() != null && !memberDetails.getBirthCertificateNumber().trim().isEmpty()) {
            if (!memberDao.checkSameBirthCertificateExists(memberDetails.getBirthCertificateNumber())) {
                memberEntity.setBirthCertificateNumber(memberDetails.getBirthCertificateNumber());
            } else {
                memberEntity.setDuplicateBirthCert(true);
                memberEntity.setDuplicateBirthCertNumber(memberDetails.getBirthCertificateNumber());
                memberEntity.setBirthCertificateNumber(null);
            }
        }
    }

    private void motherChildRelation(String motherOf, Map<Integer, MemberEntity> membersWithLoopIdMap) {
        Map<String, String> motherChildMap = gson.fromJson(motherOf, new TypeToken<HashMap<String, String>>() {
        }.getType());
        for (Map.Entry<String, String> entry : motherChildMap.entrySet()) {
            MemberEntity childEntity = membersWithLoopIdMap.get(Integer.parseInt(entry.getKey()));
            if (childEntity == null) {
                continue;
            }
            if (!entry.getValue().equals("-1")) {
                MemberEntity motherEntity = membersWithLoopIdMap.get(Integer.parseInt(entry.getValue()));
                if (motherEntity != null) {
                    childEntity.setMotherId(motherEntity.getId());
                }
            } else {
                childEntity.setMotherId(null);
            }
            memberDao.update(childEntity);
        }
    }

    private void husbandWifeRelation(String husbandOf, Map<Integer, MemberEntity> membersWithLoopIdMap) {
        Map<String, String> husbandWifeMap = gson.fromJson(husbandOf, new TypeToken<HashMap<String, String>>() {
        }.getType());
        for (Map.Entry<String, String> entry : husbandWifeMap.entrySet()) {
            MemberEntity wifeEntity = membersWithLoopIdMap.get(Integer.parseInt(entry.getKey()));
            if (wifeEntity == null) {
                continue;
            }
            if (!entry.getValue().equals("-1")) {
                MemberEntity husbandEntity = membersWithLoopIdMap.get(Integer.parseInt(entry.getValue()));
                if (husbandEntity != null) {
                    wifeEntity.setHusbandId(husbandEntity.getId());
                }
            } else {
                wifeEntity.setHusbandId(null);
            }
            memberDao.update(wifeEntity);
        }
    }

    private static void setContactPersonAndHofIdInFamily(List<MemberEntity> memberEntities, FamilyEntity family) {
        Integer contactPersonId = null;
        for (MemberEntity member : memberEntities) {
            if (Boolean.TRUE.equals(member.getFamilyHeadFlag())) {
                family.setHeadOfFamily(member.getId());
                if (member.getMobileNumber() != null) {
                    contactPersonId = member.getId();
                    break;
                }
            } else if (member.getMobileNumber() != null) {
                contactPersonId = member.getId();
            }
        }
        if (contactPersonId != null) {
            family.setContactPersonId(contactPersonId);
        }
    }

    private static String getFamilyStateAccordingToPreviousState(String previousState) {
        return switch (previousState) {
            case FamilyHealthSurveyServiceConstants.CFHC_FAMILY_STATE_IN_REVERIFICATION ->
                    FamilyHealthSurveyServiceConstants.CFHC_FAMILY_STATE_MO_REVERIFIED;
            case FamilyHealthSurveyServiceConstants.CFHC_FAMILY_STATE_GVK_IN_REVERIFICATION ->
                    FamilyHealthSurveyServiceConstants.CFHC_FAMILY_STATE_GVK_REVERIFIED;
            default -> FamilyHealthSurveyServiceConstants.CFHC_FAMILY_STATE_VERIFIED;
        };
    }

    private void updateAdditionalInfoForMember(MemberEntity member) {
        MemberAdditionalInfo additionalInfo = new MemberAdditionalInfo();
        if (member.getAdditionalInfo() != null) {
            additionalInfo = gson.fromJson(member.getAdditionalInfo(), MemberAdditionalInfo.class);
        }

        if (member.getChronicDisease() != null && member.getChronicDisease().contains("2678")) {
            additionalInfo.setHivTest("POSITIVE");
            member.setAdditionalInfo(gson.toJson(additionalInfo));
        }

        if (member.getChronicDisease() != null && member.getChronicDisease().contains("2679")) {
            additionalInfo.setTbCured(false);
            additionalInfo.setTbSuspected(true);
            member.setAdditionalInfo(gson.toJson(additionalInfo));
        }
    }

    private void newFamilyMsg(FamilyEntity familyEntity, List<MemberEntity> memberEntities, Map<String, String> returnMap) {
        StringBuilder sb = new StringBuilder();
        sb.append("Family ID : ");
        sb.append(familyEntity.getFamilyId());
        sb.append("\n");
        sb.append("\n");
        int count = 1;
        for (MemberEntity member: memberEntities) {
            if (Boolean.TRUE.equals(member.getFamilyHeadFlag())) {
                StringBuilder familyTitle = new StringBuilder();
                familyTitle.append(familyEntity.getFamilyId())
                        .append(" - ").append(member.getFirstName());
                if (member.getMiddleName() != null && !member.getMiddleName().isEmpty()) {
                    familyTitle.append(" ").append(member.getMiddleName());
                }
                familyTitle.append(" ").append(member.getLastName());
                returnMap.put("familyId", familyTitle.toString());
            }
            sb.append(member.getUniqueHealthId());
            sb.append(" - ");
            sb.append(member.getFirstName());
            if (member.getMiddleName() != null && !member.getMiddleName().isEmpty()) {
                sb.append(" ");
                sb.append(member.getMiddleName());
            }
            sb.append(" ");
            sb.append(member.getLastName());
            if (member.isDuplicateNrc()) {
                sb.append(" ");
                sb.append(String.format("Entered NRC number %s already exists in the system for this member please update member from health services", member.getDuplicateNrcNumber()));
                sb.append(" ");
                sb.append("\n");
            }
            if (member.isDuplicatePassport()) {
                sb.append(" ");
                sb.append(String.format("Entered passport number %s already exists in the system for this member please update member from health services", member.getDuplicatePassportNumber()));
                sb.append(" ");
                sb.append("\n");
            }
            if (member.isDuplicateBirthCert()) {
                sb.append(" ");
                sb.append(String.format("Entered birth certificate number %s already exists in the system for this member please update member from health services", member.getDuplicateBirthCertNumber()));
                sb.append(" ");
                sb.append("\n");
            }
            if (count < memberEntities.size()) {
                sb.append("\n");
            }
            count++;
        }
        if (!sb.isEmpty()) {
            returnMap.put("message", sb.toString());
        }
    }
}
