(function () {
    function QuestionSetController(CourseService, Mask, GeneralUtil, $stateParams, QueryDAO, toaster, $state, $q, APP_CONFIG) {
        let ctrl = this;
        ctrl.questionSetObj = {};
        ctrl.isUpdateForm = false;
        ctrl.refId = $stateParams.refId;
        ctrl.refType = $stateParams.refType;
        ctrl.type = 'Course';
        ctrl.typeList = ['Course', 'Module', 'Lesson'];
        ctrl.apiPath = APP_CONFIG.apiPath;
        ctrl.isMinMarksEditable = true;

        ctrl.init = () => {
            if ($stateParams.id) {
                ctrl.isUpdateForm = true;
                ctrl.retrieveQuestionSetById();
            } else {
                ctrl.retrieveAllCourses();
            }
            if ($stateParams.refType === 'MODULE') {
                ctrl.type = 'Module';
            } else if ($stateParams.refType === 'LESSON') {
                ctrl.type = 'Lesson';
            }
        }
        ctrl.retrieveAllCourses = function () {
            let promises = [];
            promises.push(CourseService.retrieveAllCourse());
            promises.push(QueryDAO.execute({
                code: 'fetch_listvalue_detail_from_field',
                parameters: {
                    field: 'LMS Question Set types'
                }
            }));
            Mask.show();
            $q.all(promises).then(responses => {
                ctrl.courseList = responses[0];
                ctrl.questionSetTypes = responses[1].result;
                ctrl.handleDropdownDetails($stateParams.refType, parseInt($stateParams.refId));
            }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide);
        }

        ctrl.retrieveQuestionSetById = function () {
            let promises = [];
            promises.push(CourseService.retrieveAllCourse());
            promises.push(QueryDAO.execute({
                code: 'fetch_listvalue_detail_from_field',
                parameters: {
                    field: 'LMS Question Set types'
                }
            }));
            promises.push(QueryDAO.execute({
                code: 'get_tr_question_set_configuration_by_id',
                parameters: {
                    id: parseInt($stateParams.id)
                }
            }));
            Mask.show();
            $q.all(promises).then(responses => {
                ctrl.courseList = responses[0];
                ctrl.questionSetTypes = responses[1].result;
                ctrl.questionSetObj = responses[2].result[0];
                ctrl.handleDropdownDetails($stateParams.refType, parseInt($stateParams.refId));
            }).catch(GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide);
        }

        ctrl.filterQuestionSetTypes = function () {
            let caseStudyQuizTypes = [];
            for (const test in ctrl.testConfig) {
                if (ctrl.testConfig[test].isCaseStudyQuestionSetType) {
                    caseStudyQuizTypes.push(test);
                }
            }
            ctrl.selectedMedia = ctrl.mediaList.find(media => media.id === ctrl.questionSetObj.mediaId);
            if (ctrl.type === 'Lesson' && ctrl.selectedMedia && ctrl.selectedMedia.mediaType === 'VIDEO') {
                ctrl.filteredQuestionSetTypes = ctrl.questionSetTypes;
            } else {
                ctrl.filteredQuestionSetTypes = ctrl.questionSetTypes.filter(type => !caseStudyQuizTypes.includes(String(type.id)));
            }
        }

        ctrl.onTypeChange = function () {
            if (ctrl.type === 'Course') {
                ctrl.questionSetObj.topicId = null;
                ctrl.questionSetObj.mediaId = null;
            } else if (ctrl.type === 'Module') {
                ctrl.questionSetObj.mediaId = null;
            }
            ctrl.filterQuestionSetTypes();
            ctrl.retrieveMinimumMarks();   
        }

        ctrl.getSelectedQuestionSetType = function () {
            if (ctrl.questionSetObj.questionSetType) {
                ctrl.selectedQuestionType = ctrl.questionSetTypes.find(type => type.id === ctrl.questionSetObj.questionSetType);
            }
            ctrl.showVideoToMarkPoint = false;
            if (ctrl.selectedQuestionType &&
                ctrl.testConfig[ctrl.selectedQuestionType.id] &&
                ctrl.testConfig[ctrl.selectedQuestionType.id].isCaseStudyQuestionSetType &&
                ctrl.selectedMedia.mediaType === 'VIDEO') {
                ctrl.showVideoToMarkPoint = true;
            }
        }

        ctrl.onQuestionSetTypeChange = function () {
            ctrl.retrieveMinimumMarks();
            ctrl.getSelectedQuestionSetType();
        }

        ctrl.retrieveMinimumMarks = function () {
            referenceId = null;
            referenceType = null;
            if (ctrl.questionSetObj.courseId) {
                referenceId = ctrl.questionSetObj.courseId;
                referenceType = 'COURSE';
            }
            if (ctrl.questionSetObj.topicId) {
                referenceId = ctrl.questionSetObj.topicId;
                referenceType = 'MODULE';
            }
            if (ctrl.questionSetObj.mediaId) {
                referenceId = ctrl.questionSetObj.mediaId;
                referenceType = 'LESSON';
            }
            Mask.show();
            QueryDAO.execute({
                code: 'get_min_marks_by_question_config',
                parameters: {
                    refId: referenceId,
                    refType: referenceType,
                    courseId: ctrl.questionSetObj.courseId,
                    questionSetType: ctrl.questionSetObj.questionSetType
                }
            }).then((response) => {
                if (response.result.length === 0) {
                    ctrl.questionSetObj.minimumMarks = null;
                    ctrl.isMinMarksEditable = true;
                } else {
                    let result = response.result[0];
                    ctrl.questionSetObj.minimumMarks = result.minimum_marks;
                    if (!!ctrl.questionSetObj.minimumMarks) {
                        ctrl.isMinMarksEditable = false;
                    } else {
                        ctrl.isMinMarksEditable = true;
                    }  
                }
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        ctrl.handleDropdownDetails = function (refType, refId) {
            Mask.show();
            QueryDAO.execute({
                code: 'get_course_module_lesson_hierarchy_by_ref_id_and_type',
                parameters: {
                    refId: refId,
                    refType: refType
                }
            }).then((response) => {
                let result = response.result[0];
                ctrl.questionSetObj.courseId = result.courseId;
                ctrl.questionSetObj.topicId = result.topicId;
                ctrl.questionSetObj.mediaId = result.mediaId;
                ctrl.getTopicDetails();
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        ctrl.getTopicDetails = function () {
            ctrl.testConfig = {};
            if (ctrl.questionSetObj.courseId) {
                Mask.show();
                CourseService.getCourseById(ctrl.questionSetObj.courseId).then((response) => {
                    try {
                        ctrl.testConfig = response.testConfigJson ? JSON.parse(response.testConfigJson) : {};
                    } catch (error) {
                        console.log('error while parsing JSON testConfig ::: ', error);
                    }
                    ctrl.topicList = response.topicMasterDtos;
                    ctrl.getMediaDetails();
                    ctrl.filterQuestionSetTypes();
                    ctrl.getSelectedQuestionSetType();
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                });
            } else {
                ctrl.topicList = [];
                ctrl.getMediaDetails();
                ctrl.filterQuestionSetTypes();
                ctrl.getSelectedQuestionSetType();
            }
        }

        ctrl.getMediaDetails = function () {
            let selectedTopic = ctrl.topicList.find(topic => topic.topicId === ctrl.questionSetObj.topicId);
            ctrl.mediaList = selectedTopic && selectedTopic.topicMediaList ? selectedTopic.topicMediaList : [];
        }

        ctrl.onMarkThisPoint = function () {
            let video = document.getElementById("myVideo");
            let second = Math.floor(video.currentTime)
            video.pause();
            Mask.show();
            if (ctrl.questionSetObj.courseId) {
                ctrl.questionSetObj.referenceId = ctrl.questionSetObj.courseId;
                ctrl.questionSetObj.referenceType = 'COURSE';
            }
            if (ctrl.questionSetObj.topicId) {
                ctrl.questionSetObj.referenceId = ctrl.questionSetObj.topicId;
                ctrl.questionSetObj.referenceType = 'MODULE';
            }
            if (ctrl.questionSetObj.mediaId) {
                ctrl.questionSetObj.referenceId = ctrl.questionSetObj.mediaId;
                ctrl.questionSetObj.referenceType = 'LESSON';
            }
            QueryDAO.execute({
                code: 'get_question_sets_by_second',
                parameters: {
                    id: $stateParams.id ? parseInt($stateParams.id) : 0,
                    refId: ctrl.questionSetObj.referenceId,
                    refType: ctrl.questionSetObj.referenceType,
                    quizAtSecond: second
                }
            }).then(response => {
                if (response.result.length) {
                    toaster.pop('error', `A quiz ${response.result[0].question_set_name} is already configured at ${second}.`);
                    return;
                }
                ctrl.questionSetObj.quizAtSecond = second;
            }).catch(GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide);
        }

        ctrl.action = function (form) {
            ctrl.questionSetForm.$setSubmitted();
            if (ctrl.questionSetForm.$valid) {
                if (ctrl.questionSetObj.courseId) {
                    ctrl.questionSetObj.referenceId = ctrl.questionSetObj.courseId;
                    ctrl.questionSetObj.referenceType = 'COURSE';
                }
                if (ctrl.questionSetObj.topicId) {
                    ctrl.questionSetObj.referenceId = ctrl.questionSetObj.topicId;
                    ctrl.questionSetObj.referenceType = 'MODULE';
                }
                if (ctrl.questionSetObj.mediaId) {
                    ctrl.questionSetObj.referenceId = ctrl.questionSetObj.mediaId;
                    ctrl.questionSetObj.referenceType = 'LESSON';
                }
                let dtoList = [];
                dtoList.push({
                    code: 'get_tr_question_set_configuration_by_name',
                    parameters: {
                        id: $stateParams.id ? parseInt($stateParams.id) : null,
                        questionSetName: ctrl.questionSetObj.questionSetName,
                        refId: ctrl.questionSetObj.referenceId,
                        refType: ctrl.questionSetObj.referenceType
                    },
                    sequence: 1
                });
                if (ctrl.showVideoToMarkPoint) {
                    dtoList.push({
                        code: 'get_question_sets_by_second',
                        parameters: {
                            id: $stateParams.id ? parseInt($stateParams.id) : 0,
                            refId: ctrl.questionSetObj.referenceId,
                            refType: ctrl.questionSetObj.referenceType,
                            quizAtSecond: (ctrl.questionSetObj.quizAtSecond === null || ctrl.questionSetObj.quizAtSecond === undefined) ? -1 : ctrl.questionSetObj.quizAtSecond
                        },
                        sequence: 2
                    });
                }
                Mask.show();
                QueryDAO.executeAll(dtoList).then(responses => {
                    if (responses[0].result.length) {
                        toaster.pop('error', 'Duplicate Question Set name are not allowed.');
                        Mask.hide();
                        return;
                    }
                    if (ctrl.showVideoToMarkPoint && (ctrl.questionSetObj.quizAtSecond === null || ctrl.questionSetObj.quizAtSecond === undefined)) {
                        toaster.pop('error', 'Please mark certain point in video for auto-pause and present quiz.');
                        Mask.hide();
                        return;
                    }
                    if (ctrl.showVideoToMarkPoint && responses[1].result.length) {
                        toaster.pop('error', `A quiz ${responses[1].result[0].question_set_name} is already configured at ${ctrl.questionSetObj.quizAtSecond}.`);
                        Mask.hide();
                        return;
                    }
                    let dto = {
                        code: 'insert_into_tr_question_set_configuration',
                        parameters: {
                            refId: ctrl.questionSetObj.referenceId,
                            refType: ctrl.questionSetObj.referenceType,
                            questionSetName: ctrl.questionSetObj.questionSetName,
                            questionSetType: ctrl.questionSetObj.questionSetType,
                            status: ctrl.questionSetObj.status,
                            minimumMarks: ctrl.questionSetObj.minimumMarks ? parseInt(ctrl.questionSetObj.minimumMarks) : null,
                            courseId: ctrl.questionSetObj.courseId,
                            quizAtSecond: ctrl.questionSetObj.quizAtSecond,
                            isAllowedToAttemptQuiz: ctrl.questionSetObj.isAllowedToAttemptQuiz
                        }
                    }
                    if ($stateParams.id) {
                        dto.code = 'update_tr_question_set_configuration';
                        dto.parameters.id = parseInt($stateParams.id);
                    }
                    QueryDAO.execute(dto).then(res => {
                        let message = parseInt($stateParams.id) ? 'updated' : 'added';
                        toaster.pop('success', `Question set ${message} successfully`);
                        $state.go('techo.training.questionsetlist', { refId: $stateParams.refId, refType: $stateParams.refType });
                    }).catch(GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide);
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                    Mask.hide();
                });
            }
        }

        ctrl.init();
    }
    angular.module('imtecho.controllers').controller('QuestionSetController', QuestionSetController);
})();
