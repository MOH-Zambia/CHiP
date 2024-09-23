package com.argusoft.imtecho.fhs.mapper;

import com.argusoft.imtecho.fhs.dto.ReferralDto;

import java.util.Date;

public class ReferralMapper {

    /**
     * Convert database row to ReferralDto.
     *
     * @param row Object array representing a database row.
     * @return Returns details of a referral.
     */
    public static ReferralDto getReferralDto(Object[] row){
        ReferralDto dto = new ReferralDto();

        String serviceName = switch ((String) row[10]) {
            case "ANC" -> " | ANTENATAL CARE";
            case "PNC CHILD", "PNC MOTHER" -> " | POSTNATAL CARE";
            case "WPD MOTHER", "WPD CHILD" -> " | WORK PLAN FOR DELIVERY";
            case "HIV" -> " | HUMAN IMMUNODEFICIENCY VIRUS";
            default -> "";
        };

        dto.setUniqueId(row[10] + " - " + ((Integer) row[20]).toString());
        dto.setSystemClientId((String) row[0]);
        dto.setPatientId((String) row[0]);
        dto.setFirstName((String) row[1]);
        dto.setMiddleName((String) row[2]);
        dto.setLastName((String) row[3]);
        dto.setDateOfBirth((Date) row[4]);
        dto.setGender((String) row[5]);
        dto.setMobileNumber((String) row[6]);
        dto.setMaritalStatus(((String) row[7]).charAt(0) + " | " + row[7]);
        dto.setNRC((String) row[8]);
        dto.setReasons((String) row[9]);
        dto.setReferredOn((Date) row[11]);
        dto.setReferredTo(((Integer) row[12]).toString() + " | " + row[16]);
        dto.setReferredBy(((Integer) row[13]).toString() + " | " + row[17]);
        dto.setReligion((String) row[14]);
        dto.setLocation((String) row[15]);
        dto.setReferredFrom(((Integer) row[18]).toString() +" | " + row[19]);
        dto.setServiceArea(row[10] + serviceName);

        return dto;
    }

}
