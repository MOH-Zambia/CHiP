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
        dto.setPatientId((String) row[0]);
        dto.setFirstName((String) row[1]);
        dto.setMiddleName((String) row[2]);
        dto.setLastName((String) row[3]);
        dto.setDateOfBirth((Date) row[4]);
        dto.setGender((String) row[5]);
        dto.setMobileNumber((String) row[6]);
        dto.setMaritalStatus((Integer) row[7]);
        dto.setNRC((String) row[8]);
        dto.setReasons((String) row[9]);
        dto.setTypeCode((String) row[10]);
        dto.setReferredOn((Date) row[11]);
        dto.setReferredTo((Integer) row[12]);
        dto.setReferredBy((Integer) row[13]);
        dto.setReligion((String) row[14]);
        dto.setLocation((Integer) row[15]);
        dto.setReferredFrom((String) row[16]);

        return dto;
    }
}
