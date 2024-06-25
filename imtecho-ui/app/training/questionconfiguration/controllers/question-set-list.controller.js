(function () {
    function QuestionSetListController(Mask, GeneralUtil, QueryDAO, CourseService, $stateParams, $state) {
        let ctrl = this;
        ctrl.questionSetObj = {};
        ctrl.questionSets = [];
        ctrl.isSearched = false;

        ctrl.init = () => {
            if ($stateParams.refId && $stateParams.refType) {
                ctrl.questionSetObj.referenceId = parseInt($stateParams.refId);
                ctrl.questionSetObj.referenceType = $stateParams.refType;
                ctrl.retrieveAllQuestionSets(true);
            }
            ctrl.retrieveAllCourses();
        }

        ctrl.retrieveAllCourses = function () {
            Mask.show();
            CourseService.retrieveAllCourse().then(function (res) {
                ctrl.courseList = res;
            }).finally(function () {
                Mask.hide();
            })
        }

        ctrl.getTopicDetails = function () {
            if (ctrl.questionSetObj.courseId) {
                ctrl.questionSetObj.topicId = null;
                ctrl.questionSetObj.mediaId = null;
                Mask.show();
                CourseService.getCourseById(ctrl.questionSetObj.courseId).then((response) => {
                    ctrl.topicList = response.topicMasterDtos;
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                });
            } else {
                ctrl.topicList = [];
            }
        }

        ctrl.getMediaDetails = function () {
            ctrl.questionSetObj.mediaId = null;
            let selectedTopic = ctrl.topicList.find(topic => topic.topicId === ctrl.questionSetObj.topicId);
            ctrl.mediaList = selectedTopic && selectedTopic.topicMediaList ? selectedTopic.topicMediaList : [];
        }

        ctrl.close = function () {
            ctrl.searchForm.$setPristine();
            ctrl.toggleFilter();
        };


        ctrl.retrieveAllQuestionSets = (isParamAvailable) => {
            if (!isParamAvailable && ctrl.searchForm.$invalid) {
                return;
            }
            ctrl.isSearched = true;
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
            $state.go('.', { refId: ctrl.questionSetObj.referenceId, refType: ctrl.questionSetObj.referenceType }, { notify: false });
            Mask.show();
            QueryDAO.execute({
                code: 'get_all_tr_question_set_configuration',
                parameters: {
                    refId: ctrl.questionSetObj.referenceId,
                    refType: ctrl.questionSetObj.referenceType
                }
            }).then((response) => {
                ctrl.questionSets = response.result;
                !isParamAvailable && ctrl.toggleFilter();
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        ctrl.toggleFilter = function () {
            if (angular.element('.filter-div').hasClass('active')) {
                angular.element('body').css("overflow", "auto");
            } else {
                angular.element('body').css("overflow", "hidden");
            }
            angular.element('.cst-backdrop').fadeToggle();
            angular.element('.filter-div').toggleClass('active');
        };


        ctrl.init();
    }
    angular.module('imtecho.controllers').controller('QuestionSetListController', QuestionSetListController);
})();
