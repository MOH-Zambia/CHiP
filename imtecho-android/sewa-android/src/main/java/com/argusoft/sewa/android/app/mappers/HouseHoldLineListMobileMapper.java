package com.argusoft.sewa.android.app.mappers;

import com.argusoft.sewa.android.app.constants.FhsConstants;
import com.argusoft.sewa.android.app.constants.LabelConstants;
import com.argusoft.sewa.android.app.constants.RchConstants;
import com.argusoft.sewa.android.app.constants.RelatedPropertyNameConstants;
import com.argusoft.sewa.android.app.databean.MemberAdditionalInfoDataBean;
import com.argusoft.sewa.android.app.datastructure.SharedStructureData;
import com.argusoft.sewa.android.app.dtos.HouseHoldLineListMobileDto;
import com.argusoft.sewa.android.app.model.FamilyBean;
import com.argusoft.sewa.android.app.model.MemberBean;
import com.argusoft.sewa.android.app.util.UtilBean;
import com.google.gson.Gson;

import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

public class HouseHoldLineListMobileMapper {
    public HouseHoldLineListMobileMapper() {
        throw new IllegalStateException("Utility Class");
    }

    public static void convertHouseHoldLineListDtoToFamilyBean(HouseHoldLineListMobileDto houseHoldLineListMobileDto, FamilyBean familyBean) {
        if (houseHoldLineListMobileDto.getLocationId() != null) {
            familyBean.setLocationId(String.valueOf(houseHoldLineListMobileDto.getLocationId()));
            familyBean.setAreaId(String.valueOf(houseHoldLineListMobileDto.getLocationId()));
        }

        familyBean.setHouseNumber(houseHoldLineListMobileDto.getHouseNumber() != null ? houseHoldLineListMobileDto.getHouseNumber() : familyBean.getHouseNumber());
        familyBean.setAddress1(houseHoldLineListMobileDto.getHouseAddress() != null ? houseHoldLineListMobileDto.getHouseAddress() : familyBean.getAddress1());
        familyBean.setTypeOfToilet(houseHoldLineListMobileDto.getHouseNumber() != null ? houseHoldLineListMobileDto.getHouseNumber() : familyBean.getHouseNumber());
        familyBean.setDrinkingWaterSource(houseHoldLineListMobileDto.getWaterSource() != null ? houseHoldLineListMobileDto.getWaterSource() : familyBean.getDrinkingWaterSource());
        familyBean.setLatitude(houseHoldLineListMobileDto.getCurrentLatitude() != null ? houseHoldLineListMobileDto.getCurrentLatitude() : familyBean.getLatitude());
        familyBean.setLongitude(houseHoldLineListMobileDto.getCurrentLongitude() != null ? houseHoldLineListMobileDto.getCurrentLongitude() : familyBean.getLongitude());
        familyBean.setUuid(houseHoldLineListMobileDto.getUuid() != null ? houseHoldLineListMobileDto.getUuid() : familyBean.getUuid());
        familyBean.setFamilyId("TMP" + new Date().getTime() / 1000);
        familyBean.setState(FhsConstants.CFHC_FAMILY_STATE_NEW);
    }


    public static void convertMemberDetailsToMemberBean(HouseHoldLineListMobileDto.MemberDetails member, MemberBean memberBean, FamilyBean familyBean, boolean isFromUpdate) {
        if (memberBean == null) {
            memberBean = new MemberBean();
        }
        if (member == null) {
            member = new HouseHoldLineListMobileDto.MemberDetails();
        }
        memberBean.setFamilyHeadFlag(member.getHof() != null ? member.getHof() : memberBean.getFamilyHeadFlag());
        memberBean.setFirstName(member.getFirstName() != null ? member.getFirstName() : memberBean.getFirstName());
        memberBean.setMiddleName(member.getMiddleName() != null ? member.getMiddleName() : memberBean.getMiddleName());
        memberBean.setLastName(member.getLastName() != null ? member.getLastName() : memberBean.getLastName());
        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MEMBER_NAME_FOR_LOG, UtilBean.getMemberFullName(memberBean));
        memberBean.setMemberReligion(member.getReligion() != null ? member.getReligion() : memberBean.getMemberReligion());
        memberBean.setNrcNumber(member.getNRCNumber() != null ? member.getNRCNumber() : memberBean.getNrcNumber());
        memberBean.setPassportNumber(member.getPassportNumber() != null ? member.getPassportNumber() : memberBean.getPassportNumber());
        memberBean.setMaritalStatus(member.getMaritalStatus() != null ? String.valueOf((member.getMaritalStatus())) : memberBean.getMaritalStatus());
        memberBean.setMobileNumber(member.getMobileNumber() != null ? extractMobileNumber(member.getMobileNumber()) : memberBean.getMobileNumber());
        memberBean.setEducationStatus(member.getEducationStatus() != null ? String.valueOf((member.getEducationStatus())) : memberBean.getEducationStatus());
        memberBean.setHysterectomyDone(member.getHysterectomyArrived() != null ? member.getHysterectomyArrived() : memberBean.getHysterectomyDone());
        memberBean.setMenopauseArrived(member.getMenopauseArrived() != null ? member.getMenopauseArrived() : memberBean.getMenopauseArrived());
        memberBean.setFamilyId(familyBean.getFamilyId());
        if ((member.getGender() != null && "F".equalsIgnoreCase(checkGenderFromNumber(member.getGender()))) ||
                memberBean.getGender() != null && "F".equalsIgnoreCase(checkGenderFromNumber(memberBean.getGender()))) {
            memberBean.setLmpDate(member.getLmpDate() != null ? new Date(member.getLmpDate()) : memberBean.getLmpDate());
            if (member.getLmpDate() != null) {
                Calendar calendar = Calendar.getInstance();
                Date lastLmpDate = new Date(member.getLmpDate());
                calendar.setTime(lastLmpDate);
                calendar.add(Calendar.DAY_OF_YEAR, 281);
                Date edd = calendar.getTime();
                if (memberBean.getEdd() == null) {
                    memberBean.setEdd(edd);
                }
            }
        } else {
            memberBean.setLmpDate(null);
        }
        memberBean.setRelationWithHof(member.getRelationWithHof() != null ? member.getRelationWithHof() : memberBean.getRelationWithHof());
        memberBean.setIsChildGoingSchool(member.getChildGoingToSchool() != null ? member.getChildGoingToSchool() : memberBean.getIsChildGoingSchool());
        memberBean.setCurrentStudyingStandard(member.getChildStandard() != null ? member.getChildStandard() : memberBean.getCurrentStudyingStandard());

        memberBean.setState(memberBean.getState() != null ? memberBean.getState() : FhsConstants.CFHC_MEMBER_STATE_NEW);
        if (member.getMemberDead() != null && member.getMemberDead()) {
            memberBean.setState(FhsConstants.CFHC_MEMBER_STATE_DEAD);
        }

        if ((member.getGender() != null && "F".equalsIgnoreCase(checkGenderFromNumber(member.getGender()))) ||
                memberBean.getGender() != null && "F".equalsIgnoreCase(checkGenderFromNumber(memberBean.getGender()))) {
            if (memberBean.getPregnantFlag() != null && !memberBean.getPregnantFlag() && member.getWomanPregnant() == null) {
                memberBean.setIsPregnantFlag(null);
            } else {
                memberBean.setIsPregnantFlag(member.getWomanPregnant() != null ? member.getWomanPregnant() : memberBean.getPregnantFlag());
                if (memberBean.getPregnantFlag() != null && memberBean.getPregnantFlag()) {
                    if (memberBean.getCurrentGravida() != null) {
                        memberBean.setCurrentGravida((short) (memberBean.getCurrentGravida() + 1));
                    } else {
                        memberBean.setCurrentGravida((short) 1);
                    }
                }
            }
        } else {
            memberBean.setPregnantFlag(null);
        }


        String stringBuilder =
                UtilBean.getMemberFullName(memberBean) + " " +
                        memberBean.getUniqueHealthId() + " " +
                        memberBean.getFamilyId() + " " +
                        memberBean.getNrcNumber() + " " +
                        memberBean.getPassportNumber() + " " +
                        UtilBean.getFamilyFullAddress(familyBean) + " ";
        memberBean.setSearchString(stringBuilder);
        if (memberBean.getChronicDiseaseIds() != null && memberBean.getChronicDiseaseIds().equalsIgnoreCase(RchConstants.NONE)) {
            memberBean.setChronicDiseaseIds(null);
        }
        if (member.getChronicDisease() != null) {
            for (String diseaseId : convertSetToCommaSeparatedString(member.getChronicDisease(), ",").split(",")) {
                if (memberBean.getChronicDiseaseIds() != null) {
                    if (!memberBean.getChronicDiseaseIds().contains(diseaseId)) {
                        memberBean.setChronicDiseaseIds(memberBean.getChronicDiseaseIds() + "," + diseaseId);
                    }
                } else {
                    memberBean.setChronicDiseaseIds(diseaseId);
                }
            }
        }
        if (memberBean.getChronicDiseaseIds() != null) {
            member.setChronicDisease(memberBean.getChronicDiseaseIds().split(","));
        }
        if (member.getChronicDisease() != null) {
            for (String id : convertSetToCommaSeparatedString(member.getChronicDisease(), ",").split(",")) {
                MemberAdditionalInfoDataBean memberAdditionalInfo;
                Gson gson = new Gson();
                if (memberBean.getAdditionalInfo() != null && !memberBean.getAdditionalInfo().isEmpty()) {
                    memberAdditionalInfo = gson.fromJson(memberBean.getAdditionalInfo(), MemberAdditionalInfoDataBean.class);
                } else {
                    memberAdditionalInfo = new MemberAdditionalInfoDataBean();
                }
                switch (id) {
                    case "2678":
                        memberAdditionalInfo.setHivTest("POSITIVE");
                        break;
                    case "2679":
                        memberAdditionalInfo.setTbCured(false);
                        memberAdditionalInfo.setTbSuspected(true);
                        break;
                    default:

                }
                memberBean.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
            }
        }

        memberBean.setOtherChronic(member.getOtherChronicDisease() != null ? member.getOtherChronicDisease() : memberBean.getOtherChronic());
        memberBean.setUnderTreatmentChronic(member.getOnTreatment() != null ? member.getOnTreatment() : memberBean.getUnderTreatmentChronic());

        memberBean.setChronicDiseaseIdsForTreatment(member.getChronicDiseaseTreatment() != null ? convertSetToCommaSeparatedString(member.getChronicDiseaseTreatment(), ",") : memberBean.getChronicDiseaseIdsForTreatment());
        memberBean.setOtherChronicDiseaseTreatment(member.getOtherChronicDiseaseTreatment() != null ? member.getOtherChronicDiseaseTreatment() : memberBean.getOtherChronicDiseaseTreatment());

        if (member.getChronicDisease() != null) {
            if (convertSetToCommaSeparatedString(member.getChronicDisease(), ",").contains("2678")) {
                memberBean.setIsHivPositive(RchConstants.TEST_POSITIVE);
            }
            if (convertSetToCommaSeparatedString(member.getChronicDisease(), ",").contains("2679")) {
                memberBean.setTbCured(Boolean.FALSE);
                memberBean.setTbSuspected(Boolean.TRUE);
            }
        }

        //only update following info if member is getting registered for the first time
        if (!isFromUpdate) {
            if (SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MOTHER_ID) != null && !SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MOTHER_ID).equalsIgnoreCase("NOT_AVAILABLE")) {
                memberBean.setMotherId(Long.valueOf(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MOTHER_ID)));
            }
            memberBean.setGender(member.getGender() != null ? checkGenderFromNumber(member.getGender()) : memberBean.getGender());
            memberBean.setDob(member.getDob() != null ? new Date(member.getDob()) : memberBean.getDob());
            memberBean.setMemberUuid(member.getMemberUuid() != null ? member.getMemberUuid() : memberBean.getMemberUuid());
            memberBean.setFamilyUuid(familyBean.getUuid());
            memberBean.setFamilyId(familyBean.getFamilyId());
            if (memberBean.getUniqueHealthId() == null) {
                memberBean.setUniqueHealthId(generateTempUniqueHealthId(memberBean.getMemberUuid()));
            }
        }
    }

    public static String generateTempUniqueHealthId(String UUID) {
        String uuidString = UUID.replace("-", "");
        return "UN" + uuidString.substring(0, 8).toUpperCase(Locale.ROOT);
    }

    public static String convertSetToCommaSeparatedString(String[] list, String separator) {
        if (list != null && list.length > 0) {
            StringBuilder sb = new StringBuilder();
            boolean first = true;
            for (String item : list) {
                boolean isOtherOrNone = !item.isEmpty() && !item.equalsIgnoreCase(LabelConstants.OTHER) && !item.equalsIgnoreCase(LabelConstants.NONE);
                if (first) {
                    first = false;
                } else {
                    if (isOtherOrNone) {
                        sb.append(separator);
                    }
                }
                if (isOtherOrNone) {
                    sb.append(item);
                }
            }
            return sb.toString();
        } else {
            return null;
        }
    }

    private static String checkGenderFromNumber(String gender) {
        switch (gender) {
            case "1":
            case "M":
                return "M";
            case "2":
            case "F":
                return "F";
        }
        return null;
    }

    private static String extractMobileNumber(String mobileNumber) {
        String mob = null;
        if (mobileNumber.contains("F/")) {
            mob = mobileNumber.replace("F/", "");
        }
        if (mobileNumber.contains("T")) {
            mob = mobileNumber.replace("T", "");
        }
        return mob;
    }
}