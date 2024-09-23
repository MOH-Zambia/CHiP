(function (angular) {
    let AceEditorModalController = function ($scope, $uibModalInstance, config) {

        $scope.init = () => {
            $scope.currentCodeEditorModel = config.currentCodeEditorModel;
            $scope.indexAliases = config.indexAliases || [];
            $scope.availableParameters = [
                "$formData$",
                "$infoData$",
                "$utilityData$",
                "$stateParams$",
                "$loggedInUserId$",
                ...$scope.indexAliases
            ]
        }

        $scope.save = () => {
            $uibModalInstance.close({
                code: $scope.currentCodeEditorModel
            })
        }

        $scope.cancel = () => {
            $uibModalInstance.dismiss();
        }

        $scope.init();

    };
    angular.module('imtecho.controllers').controller('AceEditorModalController', AceEditorModalController);
})(window.angular);
