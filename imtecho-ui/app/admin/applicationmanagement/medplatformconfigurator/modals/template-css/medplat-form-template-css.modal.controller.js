(function (angular) {
    let MedplatFormTemplateCssModalController = function ($scope, $uibModalInstance, config) {

        $scope.init = () => {
            $scope.css = config.css;
        }

        $scope.save = () => {
            $uibModalInstance.close({
                css: $scope.css
            })
        }

        $scope.cancel = () => {
            $uibModalInstance.dismiss();
        }

        $scope.init();

    };
    angular.module('imtecho.controllers').controller('MedplatFormTemplateCssModalController', MedplatFormTemplateCssModalController);
})(window.angular);
