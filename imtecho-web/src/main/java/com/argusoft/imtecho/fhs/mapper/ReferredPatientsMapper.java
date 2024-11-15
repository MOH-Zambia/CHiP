package com.argusoft.imtecho.fhs.mapper;

import com.argusoft.imtecho.fhs.dto.ReferredPatientsDto;

import java.util.Date;

public class ReferredPatientsMapper {
    public static ReferredPatientsDto getReferredPatientsDto(Object[] row) {
        ReferredPatientsDto dto = new ReferredPatientsDto();

        String serviceName = switch ((String) row[10]) {
            case "ANC" -> " | ANTENATAL CARE";
            case "PNC CHILD", "PNC MOTHER" -> " | POSTNATAL CARE";
            case "WPD MOTHER", "WPD CHILD" -> " | WORK PLAN FOR DELIVERY";
            case "HIV" -> " | HUMAN IMMUNODEFICIENCY VIRUS";
            default -> "";
        };

        // Set referredFrom (referral place and facility name)
        dto.setReferredFrom(((Integer) row[18]).toString() + " | " + row[19]);

        // Set referredTo (referral place and facility name)
        dto.setReferredTo(((Integer) row[12]).toString() + " | " + row[16]);

        // Set referredOn (referred date)
        dto.setReferredOn((Date) row[11]);

        // Set referredBy (creator's ID and name)
        dto.setReferredBy(((Integer) row[13]).toString() + " | " + row[17]);

        // Set reasons (reason for referral)
        dto.setReasons((String) row[9]);

        // Set serviceArea (referral type and service name)
        dto.setServiceArea(row[10] + serviceName);

        // Optionally, you can set other fields if needed, such as 'notes'.
        dto.setNotes(null);  // Assuming notes are not available in `row[]`.

        return dto;
    }

}
