(function (angular) {
    var UpdateModalController = function ($uibModalInstance, $uibModal, topics, toaster, $filter) {
        let $ctrl = this;
        $ctrl.topicForUpdate = {};
        $ctrl.topicForUpdate = {
            topicDay: topics[2],
            topicOrder: 1,
        }
        $ctrl.todayTopic = [];
        $ctrl.topicsList = angular.copy(topics[0]);
        if (topics[1] === true) {
            $ctrl.addFlag = topics[1];
            $ctrl.isShowControls = true;
            $ctrl.isShowAdd = false;
        }
        $ctrl.isShowTable = topics[3];
        $ctrl.isEditing = false;
        if (topics[3]) {
            $ctrl.isShowControls = false;
            $ctrl.isShowAdd = true;
        }

        $ctrl.ok = () => {
            $ctrl.topicUpdateForm.$setSubmitted();
            if ($ctrl.topicUpdateForm.$valid) {
                // if ($ctrl.topicForUpdate.topicDescription === null || $ctrl.topicForUpdate.topicDescription === '') {
                //     $ctrl.topicForUpdate.topicDescription = $ctrl.topicForUpdate.topicName;
                // }
                if (Array.isArray($ctrl.topicsList) && $ctrl.topicsList.length) {
                    let index = $ctrl.topicsList.findIndex((topic) => {
                        if ($ctrl.addFlag) {
                            return Number($ctrl.topicForUpdate.topicOrder) === Number(topic.topicOrder) && Number($ctrl.topicForUpdate.topicDay) === Number(topic.topicDay);
                        } else {
                            return Number($ctrl.topicForUpdate.topicId) !== Number(topic.topicId) && Number($ctrl.topicForUpdate.topicOrder) === Number(topic.topicOrder) && Number($ctrl.topicForUpdate.topicDay) === Number(topic.topicDay);
                        }
                    });
                    if (index === -1) {
                        if ($ctrl.isEditing) {
                            $ctrl.topicsList.splice($ctrl.editIndex, 1);
                            $ctrl.isEditing = false;
                        }
                        $ctrl.topicsList.push($ctrl.topicForUpdate);
                        toaster.pop('success', 'Topic added successfully');
                        // $uibModalInstance.close($ctrl.topicForUpdate);
                    } else {
                        if ($ctrl.isEditing && $ctrl.topicForUpdate.topicOrder === $ctrl.editTopicOrder) {
                            $ctrl.topicsList.splice($ctrl.editIndex, 1)
                            $ctrl.topicsList.push($ctrl.topicForUpdate);
                            toaster.pop('success', 'Topic added successfully');
                            $ctrl.isEditing = false;
                        } else {
                            toaster.pop('error', 'Topic with existing order and day cannot be added. Change order or day of topic');
                        }

                    }
                } else {
                    $ctrl.topicsList.push($ctrl.topicForUpdate);
                    toaster.pop('success', 'Topic added successfully');
                }
                if (topics[1] === true) {
                    $ctrl.addFlag = topics[1];
                } else {
                    $ctrl.topicForUpdate.topicDay = topics[1];
                    $ctrl.isShowControls = false;
                }
                $ctrl.isShowControls = false;
                $ctrl.isShowAdd = true;
                $ctrl.isShowTable = true;
                $ctrl.topicUpdateForm.$setPristine();
                $ctrl.topicsList = $ctrl.orderTopics($ctrl.topicsList)
            }
        };
        $ctrl.orderTopics = (topic) => {
            let sorted = [];
            sorted = $filter('orderBy')(topic, ['topicDay', 'topicOrder']);
            return sorted;
        };
        $ctrl.save = () => {
            $uibModalInstance.close($ctrl.topicsList);
        };
        $ctrl.cancel = () => {
            if ($ctrl.todayTopic.length === 0) {
                $uibModalInstance.dismiss();
            } else {
                $ctrl.isShowControls = false;
                $ctrl.isShowAdd = true;
                $ctrl.topicForUpdate = {};
                if (topics[1] === true) {
                    $ctrl.addFlag = topics[1];
                    $ctrl.topicForUpdate.topicDay = topics[2];
                } else {
                    $ctrl.topicForUpdate.topicDay = topics[1];
                }
            }
        }
        $ctrl.close = () => {
            $uibModalInstance.dismiss();
        }

        $ctrl.editTopic = (topic) => {
            $ctrl.isShowControls = true
            $ctrl.addFlag = false
            $ctrl.editIndex = $ctrl.topicsList.findIndex(t => t.topicOrder === topic.topicOrder && t.topicDay === topic.topicDay && t.topicName === topic.topicName);;
            $ctrl.editTopicOrder = topic.topicOrder;
            $ctrl.topicForUpdate = angular.copy(topic);
            $ctrl.isEditing = true
            // $ctrl.topicsList.splice(index, 1);
        }
        $ctrl.deleteTopic = (topic) => {
            let modalInstance = $uibModal.open({
                templateUrl: 'app/common/views/confirmation.modal.html',
                controller: 'ConfirmModalController',
                windowClass: 'cst-modal',
                size: 'med',
                resolve: {
                    message: () => {
                        return `Are you sure you want to delete topic : ${topic.topicName}?`;
                    }
                }
            });
            modalInstance.result.then(() => {
                $ctrl.topicsList.forEach(e => {
                    if (e.topicOrder > topic.topicOrder && e.topicDay === topic.topicDay) {
                        e.topicOrder--;
                    }
                });
                $ctrl.topicsList = $ctrl.topicsList.filter((t) => {
                    return t.topicDay !== topic.topicDay || t.topicOrder !== topic.topicOrder || t.topicName !== topic.topicName;
                });
                toaster.pop('success', 'Topic deleted successfully');
            }, () => {
            });
        };
        $ctrl.addTopic = () => {
            $ctrl.isShowControls = true;
            $ctrl.isShowAdd = false;
            $ctrl.nextOrder = $ctrl.topicOrder(topics[2]);
            $ctrl.topicForUpdate = {}
            $ctrl.topicForUpdate = {
                topicDay: topics[2],
                topicOrder: $ctrl.nextOrder
            }
        };
        $ctrl.topicOrder = (topicDay) => {
            let order = 1;
            $ctrl.todayTopic = $ctrl.topicsList.filter(e => e.topicDay === topicDay);
            for (let topic of $ctrl.todayTopic) {
                if (topic.topicOrder > order) {
                    order = topic.topicOrder
                }
            }
            return parseInt(order) + 1;
        }
    };
    angular.module('imtecho.controllers').controller('UpdateModalController', UpdateModalController);
})(window.angular);
