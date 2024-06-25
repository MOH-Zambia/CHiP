(function () {
    function DashboardDetailsCtrl($state, $stateParams, TopicCoverageService, toaster, $q, $uibModal, $timeout, TrainingService, Mask, AttendanceService) {
        var ctrl = this;
        ctrl.isDisable = false;
        ctrl.reasonsList = ["Not Well", "Other Work", "Unknown"];
        ctrl.topicReasonsList = ["Technical Issues", "Time not sufficient", "Have doubts myself", "Other Reasons"];
        ctrl.date = new Date(parseInt($stateParams.trainingDate));
        
        ctrl.attendanceCheckBoxClick = function (participant) {
            if (participant.present === false) {
                ctrl.selectedParticipant = participant;
                if (!participant.reason) {
                    participant.reason = ctrl.reasonsList[2];
                }
                if (participant.remarks === null) {
                    participant.remarks = "";
                }
                ctrl.selectedParticipant.present = true;
                var modalInstance = $uibModal.open({
                    templateUrl: 'app/training/mytrainingdashboard/views/reason-attendance.modal.html',
                    controller: 'ReasonModalAttendanceCtrl',
                    controllerAs: '$ctrl',
                    windowClass: 'cst-modal',
                    size: 'med',
                    resolve: {
                        selectedParticipant: function () {
                            return ctrl.selectedParticipant;
                        }
                    }
                });
                modalInstance.result.then(function () { }, function () { });
            }
        };

        ctrl.topicCheckBoxClick = function (topic) {
            if (topic.completed === false) {
                ctrl.selectedTopic = topic;
                if (!topic.reason) {
                    topic.reason = ctrl.topicReasonsList[0];
                }
                if (topic.remarks === null) {
                    topic.remarks = "";
                }
                ctrl.selectedTopic.completed = true;
                var modalInstance = $uibModal.open({
                    templateUrl: 'app/training/mytrainingdashboard/views/reason-topic.modal.html',
                    controller: 'ReasonModalTopicCtrl',
                    controllerAs: '$ctrl',
                    windowClass: 'cst-modal',
                    size: 'med',
                    resolve: {
                        selectedTopic: function () {
                            return ctrl.selectedTopic;
                        }
                    }
                });
                modalInstance.result.then(function () { }, function () { });
            } else {
                topic.completedOn = ctrl.date;
            }
        };

        ctrl.getStatus = function (date) {
            var today = new Date().setHours(0, 0, 0, 0);
            var dateCheck = date.setHours(0, 0, 0, 0);
            if (dateCheck === today) {
                return 0;
            } else if (dateCheck > today) {
                return 1;
            } else if (dateCheck < today) {
                return -1;
            }
        };

        ctrl.getDay = function (date) {
            var days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
            return days[date.getDay()];
        };

        ctrl.getCurrentTrainingDayDetails = function (date, scheduleList) {
            var currentSch;
            angular.forEach(scheduleList, function (sch) {
                if (sch.date.setHours(0, 0, 0, 0) === date.getTime()) {
                    currentSch = sch;
                    ctrl.currentTrainingDay = sch.day;
                    ctrl.currentTrainingTopicsSubmitted = sch.submittedTopics[0] !== null;
                }
            });
            return currentSch;
        };

        ctrl.goToPreviousDay = function () {
            $state.go("techo.training.dashboardDetails", {
                trainerId: ctrl.trainerId, trainingId: ctrl.trainingId,
                trainingDate: ctrl.previousTrainingDayDetails.date.getTime()
            });
        };

        ctrl.goToNextDay = function () {
            $state.go("techo.training.dashboardDetails", {
                trainerId: ctrl.trainerId, trainingId: ctrl.trainingId,
                trainingDate: ctrl.nextTrainingDayDetails.date.getTime()
            });
        };

        ctrl.hasPrevious = function (currentDay) {
            var hasPrevious = false;
            angular.forEach(ctrl.currentTrainingScheduleList, function (sch) {
                if (sch.day === currentDay - 1) {
                    hasPrevious = true;
                    ctrl.previousTrainingDayDetails = sch;
                }
            });
            return hasPrevious;
        };

        ctrl.hasNext = function (currentDay) {
            var hasNext = false;
            angular.forEach(ctrl.currentTrainingScheduleList, function (sch) {
                if (sch.day === currentDay + 1) {
                    hasNext = true;
                    ctrl.nextTrainingDayDetails = sch;
                }
            });
            return hasNext;
        };

        ctrl.isAttendanceEditable = function () {
            if (ctrl.currentTrainingTopicsSubmitted) {
                return false;
            }
            if (ctrl.status === 1) {
                return false;
            }
            return true;
        };

        ctrl.isTopicsEditable = function () {
            if (ctrl.currentTrainingTopicsSubmitted) {
                return false;
            }
            if (ctrl.status === 1) {
                return false;
            }
            return true;
        };

        ctrl.saveAttendance = function () {
            var promise = AttendanceService.saveAttendance(ctrl.participantsAttendance)
                .then(function (res) {
                }).finally(function () {

                });
            return promise;
        };

        ctrl.saveTopicsCovered = function () {
            angular.forEach(ctrl.topicsCovered, function (topic) {
                delete topic.completed;
            });
            var promises = TopicCoverageService.saveTopicCoverage(ctrl.topicsCovered)
                .then(function () { }, function () { });
            return promises;
        };

        ctrl.saveTrainingDetails = function () {
            ctrl.isDisable = true;
            ctrl.isSaveClicked = true;
            var promises = [];
            Mask.show();
            var attendancepromise = ctrl.saveAttendance();
            var topicspromise = ctrl.saveTopicsCovered();
            promises.push(attendancepromise);
            promises.push(topicspromise);
            $q.all(promises).then(function () {
                toaster.pop('success', "Training Details Saved!");
                $timeout(function () {
                    ctrl.isSaveClicked = false;
                    $state.reload();
                }, 2000);
            }).finally(function () {
                Mask.hide();
                ctrl.isDisable = false;
            });
        };

        ctrl.openConfirmationModal = function (type) {
            if (ctrl.isDisable) {
                return;
            }
            ctrl.submitType = type;
            var modalInstance = $uibModal.open({
                templateUrl: 'app/common/views/confirmation.modal.html',
                controller: 'ConfirmModalController',
                windowClass: 'cst-modal',
                size: 'med',
                resolve: {
                    message: function () {
                        return "Please note that you will not be able to edit this form once it is submitted";
                    }
                }
            });
            modalInstance.result.then(function () {
                ctrl.submitTraining();
            }, function () {
                ctrl.submitType = null;
            });
        };

        ctrl.submitTraining = function () {
            ctrl.isDisable = true;
            var promises = [];
            var attendancepromise = ctrl.saveAttendance();
            var topicspromise = ctrl.saveTopicsCovered();
            promises.push(attendancepromise);
            promises.push(topicspromise);
            $q.all(promises).then(function () {
                ctrl.isDisable = false;
                $timeout(function () {
                    var topicIds = [];
                    for (var i = 0; i < ctrl.currentTopicsCovered.length; i++) {
                        topicIds.push(ctrl.currentTopicsCovered[i].topicCoverageId);
                    }
                    Mask.show();
                    TopicCoverageService.submitTopicCoverages(topicIds)
                        .then(function () {
                            toaster.pop('success', "Training Saved and Submitted!");
                            if (ctrl.hasNext(ctrl.currentTrainingDay) === false)
                                $state.go("techo.training.editTraineeStatus", { trainingId: ctrl.trainingId });
                            else {
                                $timeout(function () {
                                    $state.reload();
                                }, 500);
                            }
                        }, function () {
                        }).finally(function () {
                            Mask.hide();
                        });
                }, 2000);
            });
        };

        ctrl.getCurrentTrainingScheduleFromTopicsList = function (currentTrainingTopics) {
            var groupedResults = _.chain(currentTrainingTopics)
                .groupBy('effectiveDate')
                .map(function (value, key) {
                    return {
                        date: new Date(parseInt(key)),
                        submittedTopics: _.pluck(value, 'submittedOn')
                    };
                })
                .value();
            groupedResults.sort(function (a, b) {
                return new Date(a.date) - new Date(b.date);
            });
            var count = 1;
            angular.forEach(groupedResults, function (res) {
                res.day = count;
                count++;
            });
            return groupedResults;
        };

        ctrl.attendanceList = function () {
            AttendanceService.getAttendancesByTrainingAndDate(ctrl.trainingId, $stateParams.trainingDate).then(function (res) {
                ctrl.participantsAttendance = res;
                ctrl.currentTrainingList();
            });
        };

        ctrl.topicsCoveredList = function () {
            Mask.show();
            TopicCoverageService.getTopicCoveragesByTrainingAndDate(ctrl.trainingId, $stateParams.trainingDate).then(function (res) {
                ctrl.topicsCovered = res;
                angular.forEach(ctrl.topicsCovered, function (topic) {
                    topic.completed = topic.completedOn !== null;
                });
                ctrl.currentTopicsCovered = _.filter(ctrl.topicsCovered, function (topic) {
                    if (topic.effectiveDate === ctrl.date.getTime()) {
                        return topic;
                    }
                });
                ctrl.otherTopicsCovered = _.filter(ctrl.topicsCovered, function (topic) {
                    if (topic.effectiveDate !== ctrl.date.getTime()) {
                        return topic;
                    }
                });
            }).finally(function () {
                Mask.hide();
            });
        };

        ctrl.currentTrainingList = function () {
            Mask.show();
            TrainingService.retrieveCurrentTraining($stateParams.trainingDate, ctrl.trainerId).then(function (res) {
                ctrl.currentTraining = res;
                if (!!ctrl.currentTraining[0]) {
                    ctrl.attendees = Object.keys(ctrl.currentTraining[0].attendees);
                    ctrl.additionalAttendees = Object.keys(ctrl.currentTraining[0].additionalAttendees);
                    ctrl.organizationUnits = Object.values(ctrl.currentTraining[0].organizationUnits);
                }
                $timeout(function () {
                    ctrl.participants = _.filter(ctrl.participantsAttendance, function (participant) {
                        if (ctrl.attendees.indexOf(participant.userId.toString()) >= 0) {
                            return participant;
                        }
                    });
                    ctrl.additionalParticipants = _.filter(ctrl.participantsAttendance, function (participant) {
                        if (ctrl.additionalAttendees.indexOf(participant.userId.toString()) >= 0) {
                            return participant;
                        }
                    });
                });
            }).finally(function () {
                Mask.hide();
            });
        };

        ctrl.currentTrainingTopicsList = function () {
            Mask.show();
            TopicCoverageService.getTopicCoverageByTrainingId(ctrl.trainingId).then(function (res) {
                ctrl.currentTrainingTopics = res;
                ctrl.currentTrainingScheduleList = ctrl.getCurrentTrainingScheduleFromTopicsList(ctrl.currentTrainingTopics);
                ctrl.currentTrainingDayDetails = ctrl.getCurrentTrainingDayDetails(ctrl.date, ctrl.currentTrainingScheduleList);
                ctrl.isAttendanceDetailsEditable = ctrl.isAttendanceEditable();
                ctrl.isTopicsDetailsEditable = ctrl.isTopicsEditable();
            }).finally(function () {
                Mask.hide();
            });
        };

        ctrl.init = function () {
            ctrl.trainingId = $stateParams.trainingId;
            ctrl.trainerId = $stateParams.trainerId;
            ctrl.attendanceList();
            ctrl.topicsCoveredList();
            ctrl.currentTrainingTopicsList();
        };

        ctrl.init();
        ctrl.status = ctrl.getStatus(angular.copy(ctrl.date));

        $timeout(function () {
            $(".header-fixed").tableHeadFixer();
        });
    }
    angular.module('imtecho.controllers').controller('DashboardDetailsCtrl', DashboardDetailsCtrl);
})();
