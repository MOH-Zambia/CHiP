
(function () {
    function ExecutionSequenceController($scope, $uibModalInstance, toaster, config) {

        $scope.init = () => {
            if (config.executionSequence != null) {
                $scope.executionSequence = config.executionSequence
            } else {
                $scope.executionSequence = [];
            }
            let formVm = config.formVm;
            $scope.executionData = [];
            for (type in formVm) {

                switch (type) {
                    case 'formQueries': typeName = 'FORM_QUERY'; break;
                    case 'formMethods': typeName = 'FORM_METHOD'; break;
                    case 'formApis': typeName = 'FORM_API'; break;
                    case 'formVariables': typeName = 'FORM_VARIABLE_SETTER'; break;
                }
                formVm[type].forEach((element) => {
                    $scope.executionData.push({ "type": typeName, "value": element.value })
                })

            }
            $scope.executionSequence.forEach((sequenceItem) => {
                let index = $scope.executionData.filter((element) => { return element.value === sequenceItem.value });
                if (index.length === 0) {
                    sequenceItem.itemModified = true;
                }
            })
            $scope.checkSelected();
        }



        $scope.checkSelected = function () {
            $scope.executionSequence.forEach(sequenceItem => {
                $scope.executionData.forEach(element => {
                    if (element.value === sequenceItem.value) {
                        element.isAdded = true
                    }
                })
            })
        }

        $scope.onDelete = (index, item) => {
            $scope.executionSequence.splice(index, 1);
            $scope.executionData.forEach(element => {
                if (element.value === item.value) {
                    element.isAdded = false;
                }
            })
        }

        $scope.save = () => {
            const modifiedItems = $scope.executionSequence.filter(element => element.itemModified);
            if (modifiedItems.length === 0) {
                $scope.executionSequence.forEach((element) => {
                    delete element.isAdded;
                    delete element.$$hashKey;
                });
                $uibModalInstance.close($scope.executionSequence);
            } else {
                toaster.pop('error', 'Delete modified items from form onLoad execution configuration before saving'); x
            }
        }

        $scope.cancel = () => {
            $uibModalInstance.dismiss();
        }
        $scope.init();

    } angular.module('imtecho.controllers').controller('ExecutionSequenceController', ExecutionSequenceController);
})()