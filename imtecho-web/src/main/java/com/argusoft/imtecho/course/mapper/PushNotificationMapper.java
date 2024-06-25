package com.argusoft.imtecho.course.mapper;

import com.argusoft.imtecho.course.dto.PushNotificationDto;
import com.argusoft.imtecho.course.model.CourseNotificationTypeRel;
import com.argusoft.imtecho.fcm.dao.TechoPushNotificationTypeDao;
import com.argusoft.imtecho.fcm.model.TechoPushNotificationType;
import org.springframework.beans.factory.annotation.Autowired;

public class PushNotificationMapper {

    public static TechoPushNotificationType pushNotificationToTechoPushNotificationMapper(PushNotificationDto pushNotificationDto){
        TechoPushNotificationType techoPushNotificationType  = new TechoPushNotificationType();
        techoPushNotificationType.setType(pushNotificationDto.getType());
        techoPushNotificationType.setHeading(pushNotificationDto.getHeading());
        techoPushNotificationType.setMessage(pushNotificationDto.getMessage());
        techoPushNotificationType.setIsActive(true);
        return techoPushNotificationType;
    }

    public static CourseNotificationTypeRel pushNotificationToNotificationRelMapper(PushNotificationDto pushNotificationDto, Integer courseId,Integer notificationId){
        CourseNotificationTypeRel courseNotificationTypeRel = new CourseNotificationTypeRel();
        courseNotificationTypeRel.setDay(pushNotificationDto.getDay());
        courseNotificationTypeRel.setCourseId(courseId);
        courseNotificationTypeRel.setPushNotificationTypeId(notificationId);
        return courseNotificationTypeRel;
    }
}
