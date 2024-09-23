package com.argusoft.imtecho.fhs.mapper;

import com.argusoft.imtecho.fhs.dto.ClientMemberDto;

import java.math.BigDecimal;
import java.util.Date;

public class ClientMemberMapper {

    /**
     * Convert object to dto.
     *
     * @param row Object.
     * @return Returns details of member.
     */

    public static ClientMemberDto getMemberDto(Object[] row) {
        ClientMemberDto memberDto = new ClientMemberDto();

        memberDto.setId((Integer) row[29]);
        memberDto.setUniqueHealthId((String) row[0]);
        memberDto.setFirstName((String) row[22]);
        memberDto.setMiddleName((String) row[21]);
        memberDto.setLastName((String) row[20]);
        memberDto.setGender((String) row[2]);
        memberDto.setDob((Date) row[11]);
        memberDto.setMenopauseArrived((Boolean) row[12]);
        memberDto.setHysterectomyDone((Boolean) row[13]);

        memberDto.setMaritalStatus((String) row[16]);
        memberDto.setMobileNumber((String) row[15]);
        memberDto.setPassportNumber((String) row[17]);
        memberDto.setNrcNumber((String) row[18]);

        memberDto.setIsPregnantFlag((Boolean) row[1]);
        memberDto.setLmpDate((Date) row[3]);
        memberDto.setEdd((Date) row[26]);
        memberDto.setFamilyPlanningMethod((String) row[23]);
        memberDto.setEducationStatus((String) row[14]);
        memberDto.setImmunisationGiven((String) row[30]);
        memberDto.setBloodGroup((String) row[28]);
        memberDto.setWeight((BigDecimal) row[25]);
        memberDto.setHaemoglobin((BigDecimal) row[24]);
//        memberDto.setChronicDiseaseDetails((Set<Integer>) row[10]);
        memberDto.setOtherChronicDiseaseTreatment((String) row[4]);
        memberDto.setChronicDiseaseTreatment((String) row[5]);
        memberDto.setUnderTreatmentChronic((Boolean) row[6]);
        memberDto.setOtherDisability((String) row[7]);
        memberDto.setOtherChronic((String) row[8]);
        memberDto.setPhysicalDisability((String) row[9]);
        memberDto.setMemberReligion((String) row[19]);
        memberDto.setBloodGroup((String) row[28]);
        memberDto.setLastMethodOfContraception((String) row[27]);

        return memberDto;
    }

}
