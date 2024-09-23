(function (angular) {
    let EditFormObjectModalController = function ($scope, $uibModalInstance, config, toaster) {

        $scope.init = () => {
            $scope.currentNode = { ...config.node };
            if ($scope.currentNode == null) {
                $scope.currentNode = {
                    "title": null,
                    "isArray": false
                }
            }
            $scope.uniqueAlias = config.uniqueAlias;
        }

        $scope.save = () => {
            $scope.editFormObject.$setSubmitted();
            if ($scope.editFormObject.$valid) {
                $uibModalInstance.close({
                    node: $scope.currentNode
                })
            }
        }

        $scope.titleChanged = (title) => {
            if (['formData', 'infoData', 'utilityData'].includes(title)) {
                $scope.editFormObject.formObject.$setValidity('root', false);
            } else {
                $scope.editFormObject.formObject.$setValidity('root', true);
            }

        }

        $scope.indexAliasChanged = (indexAlias) => {
            if ($scope.uniqueAlias.has(indexAlias)) {
                $scope.editFormObject.indexAlias.$setValidity('alias', false);
            } else {
                $scope.editFormObject.indexAlias.$setValidity('alias', true);
            }
        }

        $scope.isArrayChanged = (currentNode) => {
            if(!currentNode.isArray) {
                currentNode.indexAlias = null;
            }
        }

        $scope.cancel = () => {
            $uibModalInstance.dismiss();
        }

        $scope.init();

    };
    angular.module('imtecho.controllers').controller('EditFormObjectModalController', EditFormObjectModalController);
})(window.angular);
