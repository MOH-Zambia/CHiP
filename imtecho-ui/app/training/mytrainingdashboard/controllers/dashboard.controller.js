(function () {
    function DashboardCtrl($state, TrainingService, TopicCoverageService, PagingService, AuthenticateService, CommonService, $timeout, Mask) {
        var ctrl = this;
        ctrl.now = new Date();
        ctrl.trainer = { id: 1, name: "Admin" }
        var today = new Date().setHours(0, 0, 0, 0);
        ctrl.currentTrainingOfLocation = [];
        ctrl.upcomingTrainingList = [];
        ctrl.pagingService1 = PagingService.initialize();
        ctrl.pagingService2 = PagingService.initialize();
        ctrl.pendingTrainingStatus = [];
        ctrl.field = 'courseName';
        ctrl.reverse = false;
        ctrl.courseName = '';

        ctrl.retrieveCurrentTraining = function () {
            AuthenticateService.getLoggedInUser().then(function (res) {
                ctrl.userDetail = res.data;
                Mask.show();
                TrainingService.getTodaysTraining(ctrl.userDetail.id).then(function (res) {
                    ctrl.currentTraining = res[0];
                    if (!!ctrl.currentTraining) {
                        ctrl.courseName = Object.entries(ctrl.currentTraining.courses)[0][1];
                        if (ctrl.currentTraining.attendees || ctrl.currentTraining.additionalAttendees) {
                            ctrl.size = Object.keys(ctrl.currentTraining.attendees).length + Object.keys(ctrl.currentTraining.additionalAttendees).length;
                        }
                        if (ctrl.currentTraining.primaryTrainers) {
                            ctrl.primaryTrainersList = Object.values(ctrl.currentTraining.primaryTrainers);
                        }
                        if (ctrl.currentTraining.optionalTrainers) {
                            ctrl.optionalTrainersList = Object.values(ctrl.currentTraining.optionalTrainers);
                        }
                        if (ctrl.currentTraining.organizationUnits) {
                            ctrl.organizationUnitsList = Object.values(ctrl.currentTraining.organizationUnits);
                        }
                        TopicCoverageService.getTopicCoverageByTrainingId(ctrl.currentTraining.trainingId).then(function (res) {
                            var topics = res;
                            var topicsByDate = CommonService.groupTopicsByDate(topics);
                            ctrl.currentTraining.scheduleList = topicsByDate;
                        });
                    }
                }, function () {
                }).finally(function () {
                    Mask.hide();
                });
            });
        };

        ctrl.retrieveUpcomingTrainings = function () {
            Mask.show();
            ctrl.criteria = { afterDate: today, currentDate: null, limit: ctrl.pagingService2.limit, offset: ctrl.pagingService2.offSet };
            var offsetCopy = ctrl.pagingService2.offSet;
            TrainingService.getTrainingsByUserLocation(ctrl.criteria).then(function (res) {
                ctrl.upcomingTrainingList = _.filter(res, function (obj) {
                    return Object.keys(obj.primaryTrainers).includes(ctrl.userDetail.id.toString());
                })
                if (offsetCopy === 0) {
                    $timeout(function () {
                        $(".header-fixed").tableHeadFixer();
                    });
                }
                ctrl.upcomingCourseList = _.map(_.pluck(ctrl.upcomingTrainingList, 'courses'), function (course) {
                    return [Object.keys(course)[0], Object.values(course)[0]];
                });
                $timeout(function () {
                    ctrl.upcomingOrganizationUnitsList = _.map(_.pluck(ctrl.upcomingTrainingList, 'organizationUnits'), function (location) {
                        return [Object.keys(location)[0], Object.values(location)[0]];
                    });

                    ctrl.upcomingPrimaryTrainersList = _.map(_.pluck(ctrl.upcomingTrainingList, 'primaryTrainers'), function (primaryTrainer) {
                        return [Object.keys(primaryTrainer)[0], Object.values(primaryTrainer)[0]];
                    });
                });
                angular.forEach(ctrl.upcomingTrainingList, function (trainingList) {
                    trainingList.upcomingTrainingSize;
                    trainingList.upcomingTrainingSize = Object.keys(trainingList.attendees).length + Object.keys(trainingList.additionalAttendees).length;
                });
            }, function () {
            }).finally(function () {
                Mask.hide();
            });
        };

        ctrl.retrieveCurrentTrainingsofLocation = function () {
            Mask.show();
            if (ctrl.currentTrainingOfLocation.length === 0) {
                ctrl.pagingService1.resetOffSetAndVariables();
            }
            ctrl.criteria = { afterDate: null, currentDate: today, limit: ctrl.pagingService1.limit, offset: ctrl.pagingService1.offSet };
            var offsetCopy = ctrl.pagingService1.offSet;
            TrainingService.getTrainingsByUserLocation(ctrl.criteria).then(function (res) {
                if (offsetCopy === 0) {
                    $timeout(function () {
                        $(".header-fixed").tableHeadFixer();
                    });
                }
                ctrl.currentTrainingOfLocation = res;
                ctrl.currentTrainingCourseList = _.map(_.pluck(ctrl.currentTrainingOfLocation, 'courses'), function (course) {
                    return [Object.keys(course)[0], Object.values(course)[0]];
                });

                ctrl.currentTrainingOrganizationUnitsList = _.map(_.pluck(ctrl.currentTrainingOfLocation, 'organizationUnits'), function (location) {
                    return [Object.keys(location)[0], Object.values(location)[0]];
                });

                ctrl.currentTrainingPrimaryTrainersList = _.map(_.pluck(ctrl.currentTrainingOfLocation, 'primaryTrainers'), function (primaryTrainer) {
                    return [Object.keys(primaryTrainer)[0], Object.values(primaryTrainer)[0]];
                });
                angular.forEach(ctrl.currentTrainingOfLocation, function (trainingList) {
                    trainingList.currentTrainingSize;
                    trainingList.currentTrainingSize = Object.keys(trainingList.attendees).length + Object.keys(trainingList.additionalAttendees).length;
                });
            }, function () {
            }).finally(function () {
                Mask.hide();
            });
        };

        ctrl.getStatus = function (date) {
            if (!!date) {
                var dateCheck = date.setHours(0, 0, 0, 0);
                if (dateCheck === today) {
                    return 0;
                } else if (dateCheck > today) {
                    return 1;
                } else if (dateCheck < today) {
                    return -1;
                }
            }
        };

        ctrl.navigateToTrainerDetails = function (date) {
            date = date.getTime();
            //not accepting string with . in between
            var id = ctrl.currentTraining.trainingId;
            $state.go("techo.training.dashboardDetails", { trainerId: ctrl.userDetail.id, trainingId: id, trainingDate: date });
        };

        ctrl.sort = function (field) {
            if (field === ctrl.field)
                ctrl.reverse = !ctrl.reverse;
            else {
                ctrl.reverse = false;
                ctrl.field = field;
            }
        }
        ctrl.initPage = function () {
            ctrl.retrieveUpcomingTrainings();
            ctrl.retrieveCurrentTraining();
        };

        ctrl.initPage();
    }
    angular.module('imtecho.controllers').controller('DashboardCtrl', DashboardCtrl);
})();
