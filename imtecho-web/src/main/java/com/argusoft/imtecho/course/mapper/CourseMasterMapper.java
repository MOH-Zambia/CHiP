/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.course.mapper;

import com.argusoft.imtecho.course.dto.CourseMasterDto;
import com.argusoft.imtecho.course.dto.PushNotificationDto;
import com.argusoft.imtecho.course.dto.TopicMasterDto;
import com.argusoft.imtecho.course.model.CourseMaster;

import java.util.Set;

/**
 * @author akshar
 */
public class CourseMasterMapper {

    public static CourseMasterDto entityToDtoCourseMaster(CourseMaster courseMaster, Set<TopicMasterDto> topicMasterDtos, Set<PushNotificationDto> pushNotificationDtos) {
        CourseMasterDto courseMasterDto = new CourseMasterDto();

        courseMasterDto.setCourseDescription(courseMaster.getCourseDescription());
        courseMasterDto.setCourseId(courseMaster.getCourseId());
        courseMasterDto.setCourseName(courseMaster.getCourseName());
        courseMasterDto.setTopicMasterDtos(topicMasterDtos);
        courseMasterDto.setCourseState(courseMaster.getCourseState());
        courseMasterDto.setCourseType(courseMaster.getCourseType());
        courseMasterDto.setRoleIds(courseMaster.getRoleIds());
        courseMasterDto.setTrainerRoleIds(courseMaster.getTrainerRoleIds());
        courseMasterDto.setCourseModuleId(courseMaster.getCourseModuleId());
        courseMasterDto.setTestConfigJson(courseMaster.getTestConfigJson());
        courseMasterDto.setEstimatedTimeInHrs(courseMaster.getEstimatedTimeInHrs());
        courseMasterDto.setCourseImageJson(courseMaster.getCourseImageJson());
        courseMasterDto.setIsAllowedToSkipLessons(courseMaster.getIsAllowedToSkipLessons());
        courseMasterDto.setPushNotificationDtos(pushNotificationDtos);
        courseMasterDto.setHasNotificationConfiguration(courseMaster.getHasNotificationConfiguration());

        return courseMasterDto;
    }

    public static CourseMaster dtoToEntityCourseMaster(CourseMasterDto courseMasterdto, CourseMaster courseMaster, Set<Integer> topicIds) {
        if (courseMaster == null) {
            courseMaster = new CourseMaster();
        }
        courseMaster.setCourseDescription(courseMasterdto.getCourseDescription());
        courseMaster.setCourseId(courseMasterdto.getCourseId());
        courseMaster.setCourseName(courseMasterdto.getCourseName());
        courseMaster.setCourseState(courseMasterdto.getCourseState());
        courseMaster.setCourseType(courseMasterdto.getCourseType());
        courseMaster.setTopicIds(topicIds);
        courseMaster.setRoleIds(courseMasterdto.getRoleIds());
        courseMaster.setTrainerRoleIds(courseMasterdto.getTrainerRoleIds());
        courseMaster.setCourseModuleId(courseMasterdto.getCourseModuleId());
        courseMaster.setTestConfigJson(courseMasterdto.getTestConfigJson());
        courseMaster.setEstimatedTimeInHrs(courseMasterdto.getEstimatedTimeInHrs());
        courseMaster.setCourseImageJson(courseMasterdto.getCourseImageJson());
        courseMaster.setIsAllowedToSkipLessons(courseMasterdto.getIsAllowedToSkipLessons());
        courseMaster.setHasNotificationConfiguration(courseMasterdto.getHasNotificationConfiguration());

        return courseMaster;
    }
}
