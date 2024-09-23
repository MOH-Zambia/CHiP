(function (angular) {
    let EventsModalController = function ($scope, $uibModalInstance, $uibModal, config, toaster) {

        $scope.supportedEvents = [
            "Change",
            "Blur",
            "MouseEnter",
            "MouseLeave",
            "KeyPress",
            "KeyUp",
            "KeyDown",
            "Click",
            // "DoubleClick",
            // "MouseDown",
            // "MouseUp",
            // "MouseMove",
            // "MouseOver",
        ];

        $scope.init = () => {
            $scope.events = config.event || {}
            $scope.fieldName = config.fieldName;
            $scope.formFields = config.formFields || [];
            $scope.formFields = $scope.formFields.filter(field => field.fieldType !== 'INFORMATION_DISPLAY');
            $scope.formVm = config.formVm || {};
            if (Array.isArray($scope.formVm.formVariables) && $scope.formVm.formVariables.length) {
                $scope.formVm.formVariables = $scope.formVm.formVariables.filter(v => v.setter);
            }
            $scope.currentEvent = "Change";
            if (Object.keys($scope.events).length === 0) {
                $scope.supportedEvents.forEach((event) => {
                    $scope.events[event] = { actions: [] }
                })
            }
        }

        $scope.setCurrentEvent = (e) => {
            $scope.eventsForm.$setSubmitted();
            if ($scope.eventsForm.$valid) {
                $scope.currentEvent = e
            } else {
                toaster.pop('error', 'Please enter all the details required')
            }
        }

        $scope.addAction = () => {
            $scope.events[$scope.currentEvent].actions.push({})
        }

        $scope.actionTypeChanged = (index, type) => {
            $scope.events[$scope.currentEvent].actions[index] = { type }
        }

        $scope.delete = (index) => {
            $scope.events[$scope.currentEvent].actions.splice(index, 1);
        }

        $scope.save = () => {
            $scope.eventsForm.$setSubmitted();
            if ($scope.eventsForm.$valid) {
                $uibModalInstance.close({
                    event: $scope.events
                })
            }
        }

        $scope.cancel = () => {
            $uibModalInstance.dismiss();
        }

        $scope.init();

    };
    angular.module('imtecho.controllers').controller('EventsModalController', EventsModalController);
})(window.angular);
