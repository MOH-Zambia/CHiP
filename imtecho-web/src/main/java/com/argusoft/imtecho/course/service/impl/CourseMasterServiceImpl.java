/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.course.service.impl;

import com.argusoft.imtecho.common.dao.UserDao;
import com.argusoft.imtecho.common.dto.FieldValueMasterDto;
import com.argusoft.imtecho.common.dto.RoleMasterDto;
import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.common.service.FieldMasterService;
import com.argusoft.imtecho.common.service.FieldValueService;
import com.argusoft.imtecho.common.service.RoleService;
import com.argusoft.imtecho.course.dao.*;
import com.argusoft.imtecho.course.dto.CourseMasterDto;
import com.argusoft.imtecho.course.dto.PushNotificationDto;
import com.argusoft.imtecho.course.dto.TopicMasterDto;
import com.argusoft.imtecho.course.dto.TopicMediaMasterDto;
import com.argusoft.imtecho.course.mapper.*;
import com.argusoft.imtecho.course.model.*;
import com.argusoft.imtecho.course.service.CourseMasterService;
import com.argusoft.imtecho.document.service.DocumentService;
import com.argusoft.imtecho.exception.ImtechoSystemException;
import com.argusoft.imtecho.exception.ImtechoUserException;
import com.argusoft.imtecho.fcm.dao.TechoPushNotificationTypeDao;
import com.argusoft.imtecho.fcm.model.TechoPushNotificationType;
import com.argusoft.imtecho.mobile.dto.*;
import com.argusoft.imtecho.training.util.TrainingUtil;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;
import java.util.stream.Collectors;


/**
 * @author akshar
 */
@Slf4j
@Service("courseMasterService")
@Transactional
public class CourseMasterServiceImpl implements CourseMasterService {

    @Autowired
    private CourseMasterDao courseMasterDao;

    @Autowired
    private TopicMasterDao topicMasterDao;

    @Autowired
    private TopicMediaMasterDao topicMediaMasterDao;

    @Autowired
    private FieldValueService fieldValueService;

    @Autowired
    private FieldMasterService fieldMasterService;

    @Autowired
    private RoleService roleService;

    @Autowired
    private QuestionSetConfigurationDao questionSetConfigurationDao;

    @Autowired
    private QuestionBankConfigurationDao questionBankConfigurationDao;

    @Autowired
    private UserDao userDao;

    @Autowired
    private LmsUserMetaDataDao lmsUserMetaDataDao;

    @Autowired
    DocumentService documentService;

    @Autowired
    TechoPushNotificationTypeDao techoPushNotificationTypeDao;

    @Autowired
    CourseNotificationTypeRelDao courseNotificationTypeRelDao;


    private final Random random = new Random();

    @Override
    public void createCourse(CourseMasterDto courseMasterDto) {
        Set<TopicMasterDto> topicMasterDtos = courseMasterDto.getTopicMasterDtos();
        if (courseMasterDto.getCourseState() == null)
            courseMasterDto.setCourseState(CourseMaster.State.ACTIVE);

        Set<Integer> topicIds = new HashSet<>();
        for (TopicMasterDto topicMasterDto : topicMasterDtos) {
            topicIds.add(this.createTopic(topicMasterDto));
        }
        Integer courseId = courseMasterDao.create(CourseMasterMapper.dtoToEntityCourseMaster(courseMasterDto, null, topicIds));
        if ( !courseMasterDto.getPushNotificationDtos().isEmpty() || courseMasterDto.getPushNotificationDtos() != null) {
            this.createOrUpdate_C_N_typeRel(courseMasterDto.getPushNotificationDtos(), courseId);
        }

    }

    public void createOrUpdate_C_N_typeRel(Set<PushNotificationDto> pushNotificationDtoList, Integer courseId){
        for (PushNotificationDto pushNotificationDto : pushNotificationDtoList) {
            TechoPushNotificationType techoPushNotificationType = techoPushNotificationTypeDao.getTechoPushNotificationTypeByType(pushNotificationDto.getType());
            if(techoPushNotificationType == null){
                Integer pushNotificationId = techoPushNotificationTypeDao.create(PushNotificationMapper.pushNotificationToTechoPushNotificationMapper(pushNotificationDto));
                courseNotificationTypeRelDao.create(PushNotificationMapper.pushNotificationToNotificationRelMapper(pushNotificationDto,courseId,pushNotificationId));
            } else {
                techoPushNotificationType.setMessage(pushNotificationDto.getMessage());
                techoPushNotificationType.setHeading(pushNotificationDto.getHeading());
                techoPushNotificationTypeDao.update(techoPushNotificationType);
            }

        }
    }

    @Override
    public List<CourseMasterDto> getAllCourses(Boolean isActive) {

        List<CourseMaster> courseMasters = courseMasterDao.retrieveAll();
        if (isActive != null && isActive) {
            courseMasters = courseMasters.stream()
                    .filter(c -> c.getCourseState().equals(CourseMaster.State.ACTIVE)).collect(Collectors.toList());
        }

        List<CourseMasterDto> courseMasterDtos = new LinkedList<>();

        for (CourseMaster courseMaster : courseMasters) {
            CourseMasterDto course = new CourseMasterDto();
            course.setCourseDescription(courseMaster.getCourseDescription());
            course.setCourseName(courseMaster.getCourseName());
            course.setCourseId(courseMaster.getCourseId());
            course.setCourseType(courseMaster.getCourseType());
            course.setCourseState(courseMaster.getCourseState());
            course.setTargetRole(this.getRolesByRoleIds(courseMaster.getRoleIds()));
            course.setTrainerRole(courseMaster.getTrainerRoleIds().size() != 0 ? this.getRolesByRoleIds(courseMaster.getTrainerRoleIds()) : null);
            course.setCourseModuleId(courseMaster.getCourseModuleId());
            course.setModuleName(courseMaster.getCourseModuleId() != null ? fieldValueService.getFieldNameById(courseMaster.getCourseModuleId()) : null);
            course.setDuration(this.calculateDuration(courseMaster.getCourseId()));
            course.setTestConfigJson(courseMaster.getTestConfigJson());
            UserMaster userMaster = userDao.retrieveById(courseMaster.getCreatedBy());
            if(userMaster != null) {
                course.setCreatedByUserName(userMaster.getFirstName().concat(" ").concat(userMaster.getLastName()));
            }
            courseMasterDtos.add(course);
        }
        return courseMasterDtos;
    }

    private void createOrUpdateMediaVideo(List<TopicMediaMasterDto> topicMediaMasterDtos, Integer topicId) {
        List<TopicMediaMaster> topicMediaMasters = topicMediaMasterDao.getTopicMediaByTopicId(topicId);
        topicMediaMasters.forEach(topicMediaMaster -> {
            topicMediaMaster.setMediaState(TopicMediaMaster.State.INACTIVE);
            topicMediaMasterDao.merge(topicMediaMaster);
        });
        topicMediaMasterDtos.forEach(topicMediaMasterDto -> {
            topicMediaMasterDto.setTopicId(topicId);
            topicMediaMasterDto.setMediaState(TopicMediaMaster.State.ACTIVE);
            TopicMediaMaster topicMediaMaster = TopicMediaMasterMapper.dtoToEntityTopicMaster(topicMediaMasterDto);
            if (topicMediaMaster.getId() != null) {
                TopicMediaMaster exitingTopicMediaMaster = topicMediaMasterDao.retrieveById(topicMediaMaster.getId());
                topicMediaMaster.setCreatedBy(exitingTopicMediaMaster.getCreatedBy());
                topicMediaMaster.setCreatedOn(exitingTopicMediaMaster.getCreatedOn());
                topicMediaMasterDao.merge(topicMediaMaster);
            } else {
                topicMediaMasterDao.create(topicMediaMaster);
            }
        });
    }

    @Override
    public Integer createTopic(TopicMasterDto topicMasterDto) {
        topicMasterDto.setTopicState(TopicMaster.State.ACTIVE);
        TopicMaster topicMaster = TopicMasterMapper.dtoToEntityTopicMaster(topicMasterDto);
        if (topicMaster.getTopicId() == null) {
            topicMasterDao.create(topicMaster);
        }
        List<TopicMediaMasterDto> topicMediaMasterDtos = topicMasterDto.getTopicMediaList();
        if (Objects.nonNull(topicMediaMasterDtos)) {
            createOrUpdateMediaVideo(topicMediaMasterDtos, topicMaster.getTopicId());
        }
        return topicMaster.getTopicId();
    }

    @Override
    public TopicMasterDto getTopicById(Integer topicId) {
        TopicMasterDto topicMasterDto = TopicMasterMapper.entityToDtoTopicMaster(topicMasterDao.retrieveById(topicId));
        List<TopicMediaMaster> topicMediaMasters = topicMediaMasterDao.getTopicMediaByTopicId(topicId);
        topicMasterDto.setTopicMediaList(TopicMediaMasterMapper.entityToDtoTopicMasterList(topicMediaMasters));
        return topicMasterDto;
    }

    @Override
    public List<TopicMasterDto> getTopicsByCourse(Integer courseId) {

        CourseMaster courseMaster = courseMasterDao.retrieveById(courseId);
        Set<Integer> topicIds = courseMaster.getTopicIds();
        List<TopicMasterDto> topicMasterDtos = new LinkedList<>();

        for (Integer topicId : topicIds) {
            topicMasterDtos.add(TopicMasterMapper.entityToDtoTopicMaster(topicMasterDao.retrieveById(topicId)));
        }
        return topicMasterDtos;
    }


    public CourseMasterDto getCourseById(Integer courseId) {
        CourseMaster courseMaster = courseMasterDao.retrieveById(courseId);
        Set<TopicMasterDto> topicMasterDtos = new HashSet<>();
        Set<PushNotificationDto> pushNotificationDtos = new HashSet<>();

        for (Integer topicId : courseMaster.getTopicIds()) {
            topicMasterDtos.add(this.getTopicById(topicId));
        }
        List<String> keys = new ArrayList<>();
        keys.add("COURSE_MODULE_NAME");
        List<Integer> fieldIds = fieldMasterService.getIdsByNameForFieldConstants(keys);
        Map<String, List<FieldValueMasterDto>> dropDown = fieldValueService.getFieldValuesByList(fieldIds);
        if (courseMaster.getCourseNotificationTypeRelIds() == null || courseMaster.getCourseNotificationTypeRelIds().isEmpty()){
            pushNotificationDtos = null;
        } else {
            pushNotificationDtos = this.getPushNoticficationDtosById(courseMaster.getCourseNotificationTypeRelIds());
        }
        CourseMasterDto result = CourseMasterMapper.entityToDtoCourseMaster(courseMasterDao.retrieveById(courseId), topicMasterDtos,pushNotificationDtos);
        result.setDropDown(dropDown);
        return result;
    }

    public Set<PushNotificationDto> getPushNoticficationDtosById(List<Integer> courseNotificationTypeRelIds){
        Set<PushNotificationDto> dtoList = new HashSet<>();
        List<CourseNotificationTypeRel> courseNotificationTypeRels = courseNotificationTypeRelDao.retriveByIds("id",(List<Integer>)courseNotificationTypeRelIds);
        for(CourseNotificationTypeRel rel : courseNotificationTypeRels){
         PushNotificationDto dto = new PushNotificationDto();
         TechoPushNotificationType techoNotification = techoPushNotificationTypeDao.retrieveById(rel.getPushNotificationTypeId());
         dto.setDay(rel.getDay());
         dto.setType(techoNotification.getType());
         dto.setMessage(techoNotification.getMessage());
         dto.setHeading(techoNotification.getHeading());
         dtoList.add(dto);
         }
        return dtoList;
    }

    @Override
    public Date getTrainingCompletionDate(Long trainingStartDateInLong, List<Integer> courseIds) throws ImtechoUserException {
        Date trainingStartDate = new Date(trainingStartDateInLong);

        try {
            List<TopicMasterDto> allTopics = new ArrayList<>();
            for (Integer courseId : courseIds) {
                List<TopicMasterDto> topics = this.getTopicsByCourse(courseId);
                allTopics.addAll(topics);
            }

            return TrainingUtil.calculateNewDateExcludingSunday(trainingStartDate, allTopics.stream().max(Comparator.comparingInt(TopicMasterDto::getTopicDay)).get().getTopicDay());
        } catch (Exception ex) {
            throw new ImtechoSystemException("error in getTrainingCompletionDate", ex);
        }
    }

    @Override
    public List<CourseMasterDto> getCoursesByIds(Set<Integer> courseIds) {
        List<Integer> courseIdList = new LinkedList<>(courseIds);

        List<CourseMaster> courseMasters = courseMasterDao.retriveByIds("courseId", courseIdList);

        List<CourseMasterDto> courseMasterDtos = new LinkedList<>();

        for (CourseMaster courseMaster : courseMasters) {
            Set<TopicMasterDto> topicMasterDtos = new HashSet<>();
            Integer courseId = courseMaster.getCourseId();
            for (Integer topicId : courseMaster.getTopicIds()) {
                topicMasterDtos.add(this.getTopicById(topicId));
            }
            courseMasterDtos.add(CourseMasterMapper.entityToDtoCourseMaster(courseMasterDao.retrieveById(courseId), topicMasterDtos,null));
        }

        return courseMasterDtos;
    }

    @Override
    public List<TopicMasterDto> getTopicByIds(List<Integer> topicIds) {
        return TopicMasterMapper.entityToDtoTopicMasterList(topicMasterDao.getTopicByIds(topicIds));
    }

    @Override
    public List<CourseMasterDto> getCoursesbyRoleIds(List<Integer> roleIds) {
        List<CourseMasterDto> list = new ArrayList<>();
        for (CourseMaster course : courseMasterDao.getCoursesbyRoleIds(roleIds)) {
            list.add(CourseMasterMapper.entityToDtoCourseMaster(course, null,null));
        }
        return list;
    }

    @Override
    public void toggleActive(Integer courseId, Boolean isActive) {
        courseMasterDao.toggleActive(courseId, isActive);
    }

    @Override
    public void updateCourse(CourseMasterDto courseMasterDto) {
        CourseMaster courseMaster = courseMasterDao.retrieveById(courseMasterDto.getCourseId());
        Set<Integer> topicIds = new HashSet<>();
        for (TopicMasterDto topicMasterDto : courseMasterDto.getTopicMasterDtos()) {
            if (topicMasterDto.getTopicId() != null) {
                topicIds.add(topicMasterDto.getTopicId());
                TopicMaster topicMaster = topicMasterDao.retrieveById(topicMasterDto.getTopicId());
                topicMaster.setTopicName(topicMasterDto.getTopicName());
                topicMaster.setTopicDescription(topicMasterDto.getTopicDescription());
                topicMaster.setDay(topicMasterDto.getTopicDay());
                topicMaster.setTopicOrder(topicMasterDto.getTopicOrder());
                topicMasterDao.update(topicMaster);
                createOrUpdateMediaVideo(topicMasterDto.getTopicMediaList(), topicMasterDto.getTopicId());
            } else {
                topicIds.add(createTopic(topicMasterDto));
                courseMaster.setTopicIds(topicIds);
            }
        }
        if (courseMasterDto.getPushNotificationDtos() != null){
            this.createOrUpdate_C_N_typeRel(courseMasterDto.getPushNotificationDtos(),courseMaster.getCourseId());
        }

        courseMasterDao.update(CourseMasterMapper.dtoToEntityCourseMaster(courseMasterDto, courseMaster, topicIds));
    }

    @Override
    public List<RoleMasterDto> getRolesByCourse(Integer courseId) {
        return courseMasterDao.getRolesByCourse(courseId);
    }

    @Override
    public List<RoleMasterDto> getAllRoles(){
        return courseMasterDao.getAllRoles();
    }

    @Override
    public List<RoleMasterDto> getTrainerRolesByCourse(Integer courseId) {
        return courseMasterDao.getTrainerRolesByCourse(courseId);
    }

    @Override
    public List<CourseMasterDto> getCoursesByModuleIds(List<Integer> moduleIds) {
        return courseMasterDao.getCoursesByModuleIds(moduleIds);
    }

    private String getRolesByRoleIds(Set<Integer> roleIds) {
        return roleService.getRolesByIds(roleIds)
                .stream().map(r -> r.getName()).collect(Collectors.joining(","));
    }

    private int calculateDuration(Integer courseId) {
        return this.getTopicsByCourse(courseId).stream().max(Comparator.comparingInt(TopicMasterDto::getTopicDay)).get().getTopicDay();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<CourseDataBean> getCourseDataBeanByUserId(Integer userId) {
        List<CourseDataBean> courseDataBeanList = courseMasterDao.getCourseDataBeansByUserId(userId);

        for (CourseDataBean course : courseDataBeanList) {
            //Adding test Json
            if (course.getTestConfigJsonString() != null && !course.getTestConfigJsonString().isEmpty()) {
                course.setTestConfigJson(new Gson().fromJson(course.getTestConfigJsonString(), new TypeToken<Map<Integer, LmsQuizConfigDataBean>>() {
                }.getType()));
            }
            //Adding course image Json
            if (course.getCourseImageJsonString() != null && !course.getCourseImageJsonString().isEmpty()) {
                course.setCourseImage(new Gson().fromJson(course.getCourseImageJsonString(), CourseImageDataBean.class));
            }
            //Adding modules
            List<TopicDataBean> topicDataBeanList = topicMasterDao.getTopicDataBeanByCourseId(course.getCourseId());
            for (TopicDataBean topic : topicDataBeanList) {
                //Adding lessons
                List<TopicMediaMaster> topicMediaMasters = topicMediaMasterDao.getTopicMediaByTopicId(topic.getTopicId());
                List<TopicMediaDataBean> mediaDataBeans = new ArrayList<>();
                for (TopicMediaMaster mediaMaster : topicMediaMasters) {
                    mediaDataBeans.add(TopicMediaMasterMapper.entityToDataBean(mediaMaster,
                            getQuestionSetBeansByReferenceIdAndType(mediaMaster.getId(), "LESSON",
                                    course.getTestConfigJson() != null ? course.getTestConfigJson().keySet() : new HashSet<>())));
                }
                topic.setTopicMedias(mediaDataBeans);
                topic.setQuestionSet(getQuestionSetBeansByReferenceIdAndType(topic.getTopicId(), "MODULE",
                        course.getTestConfigJson() != null ? course.getTestConfigJson().keySet() : new HashSet<>()));
            }
            course.setTopics(topicDataBeanList);
            course.setQuestionSet(getQuestionSetBeansByReferenceIdAndType(course.getCourseId(), "COURSE",
                    course.getTestConfigJson() != null ? course.getTestConfigJson().keySet() : new HashSet<>()));
        }

        return courseDataBeanList;
    }

    public List<QuestionSetBean> getQuestionSetBeansByReferenceIdAndType(Integer referenceId, String referenceType, Set<Integer> quizTypes) {
        List<QuestionSetBean> questionSetBeans = new ArrayList<>();
        for (Integer quizType : quizTypes) {
            List<QuestionSetConfiguration> questionSets = questionSetConfigurationDao.getQuestionSetByReferenceIdAndType(referenceId, referenceType, quizType);
            if (questionSets != null && !questionSets.isEmpty()) {
                for (QuestionSetConfiguration questionSetConfiguration : questionSets) {
                    List<QuestionBankConfiguration> questionBanks = questionBankConfigurationDao.getQuestionBanksByQuestionSetId(questionSetConfiguration.getId());
                    questionSetBeans.add(QuestionSetMapper.questionSetEntityToDataBean(questionSetConfiguration, questionBanks));
                }
            }
        }
        return questionSetBeans;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<LmsUserMetaData> getLmsUserMetaData(Integer userId) {
        return lmsUserMetaDataDao.retrieveByUserId(userId);
    }

    @Override
    public String updateMediaSize(Integer courseId) {
        CourseMasterDto courseMasterDto = getCourseById(courseId);
        if(courseMasterDto.getCourseId() != null) {
            for (TopicMasterDto topicMasterDto : courseMasterDto.getTopicMasterDtos()) {
                List<TopicMediaMasterDto> topicMediaMasterDtos = topicMasterDto.getTopicMediaList();
                topicMediaMasterDtos.forEach(topicMediaMasterDto -> {
                    try {
                        File file = documentService.getFile(topicMediaMasterDto.getMediaId());
                        if(file.exists()) {
                            if(topicMediaMasterDto.getMediaType().toString().equals("VIDEO") && topicMediaMasterDto.getTranscriptFileId() != null) {
                                File transcriptFile = documentService.getFile(topicMediaMasterDto.getTranscriptFileId());
                                topicMediaMasterDto.setSize(file.length() + transcriptFile.length());
                            } else {
                                topicMediaMasterDto.setSize(file.length());
                            }
                            TopicMediaMaster topicMediaMaster = TopicMediaMasterMapper.dtoToEntityTopicMaster(topicMediaMasterDto);
                            if(topicMediaMaster.getId() != null) {
                                TopicMediaMaster exitingTopicMediaMaster = topicMediaMasterDao.retrieveById(topicMediaMaster.getId());
                                topicMediaMaster.setCreatedBy(exitingTopicMediaMaster.getCreatedBy());
                                topicMediaMaster.setCreatedOn(exitingTopicMediaMaster.getCreatedOn());
                                topicMediaMasterDao.merge(topicMediaMaster);
                            }
                        }
                    } catch (Exception e) {
                        log.error(e.getMessage());
                    }
                });
            }
        }
        return "PROCESS COMPLETED";
    }

    @Override
    public void refreshCourseSize() {
        List<TopicMediaMaster> topics = topicMediaMasterDao.getActiveTopicMedia();

        for(TopicMediaMaster tmm: topics){

            try {
                File mediaFile = documentService.getFile(tmm.getMediaId());

                Path path = Paths.get(mediaFile.getPath());

                Long size = Files.size(path);

                tmm.setSize(size);

                topicMediaMasterDao.update(tmm);

            } catch (IOException e) {
                throw new RuntimeException(e);
            }

        }

    }

}
