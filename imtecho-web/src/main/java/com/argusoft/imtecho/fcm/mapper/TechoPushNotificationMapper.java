package com.argusoft.imtecho.fcm.mapper;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.fcm.dto.TechoPushNotificationDto;
import com.argusoft.imtecho.fcm.model.TechoPushNotificationMaster;
import com.argusoft.imtecho.fhs.model.MemberEntity;
import org.hl7.fhir.r4.model.Appointment;
import org.hl7.fhir.r4.model.CodeableConcept;
import org.hl7.fhir.r4.model.Coding;
import org.hl7.fhir.r4.model.Reference;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * @author nihar
 * @since 03/08/22 2:07 PM
 */
public class TechoPushNotificationMapper {

    private TechoPushNotificationMapper() {
        throw new IllegalStateException("Utility class");
    }


//    public static TechoPushNotificationMaster dtoToEntityTechoPushNotification(
//            TechoPushNotificationDto techoPushNotificationDto
//    ) {
//        TechoPushNotificationMaster techoPushNotificationMaster =
//                new TechoPushNotificationMaster();
//
//        techoPushNotificationMaster.setId(techoPushNotificationDto.getId());
//        techoPushNotificationMaster.setUserId(techoPushNotificationDto.getUserId());
//        techoPushNotificationMaster.setType(techoPushNotificationDto.getType());
//        techoPushNotificationMaster.setResponse(techoPushNotificationDto.getResponse());
//        techoPushNotificationMaster.setException(techoPushNotificationDto.getException());
//        techoPushNotificationMaster.setIsSent(techoPushNotificationDto.getIsSent());
//        techoPushNotificationMaster.setIsPriority(techoPushNotificationDto.getIsPriority());
//        techoPushNotificationMaster.setCreatedOn(techoPushNotificationDto.getCreatedOn());
//        techoPushNotificationMaster.setCreatedBy(techoPushNotificationDto.getCreatedBy());
//        return techoPushNotificationMaster;
//    }

}
