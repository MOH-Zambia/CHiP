(function (angular) {
    let FormVmQueryDetailsModalController = function ($scope, $uibModal, $uibModalInstance, config, toaster) {

        $scope.init = () => {
            $scope.query = config.queryObj.queryCode;
            $scope.availableColumns = config.queryObj.availableColumns ? config.queryObj.availableColumns.join(", ") : '';
            $scope.queryBuilderMap = config.queryBuilderMap;
        }

        $scope.close = () => {
            $uibModalInstance.close();
        }

        $scope.cancel = () => {
            $uibModalInstance.dismiss();
        }

        $scope.init();

    };
    angular.module('imtecho.controllers').controller('FormVmQueryDetailsModalController', FormVmQueryDetailsModalController);
})(window.angular);
