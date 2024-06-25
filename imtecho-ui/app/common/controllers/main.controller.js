(function () {
    var mainController = function ($scope, $rootScope, APP_CONFIG, ENV) {
        $scope.setAppName = () => {
            
            $rootScope.appName = 'CHiP';
        }
        $rootScope.implementation = ENV.implementation;
        $rootScope.toastOptions = {
            'time-out': 4000,
            'close-button': true,
            'body-output-type': 'trustedHtml'
        };
        $rootScope.faviconPath = 'img/'+$rootScope.implementation+'/favicon.ico';
        $rootScope.familyIdFormat = APP_CONFIG.familyIdFormat;
        $scope.$on('invalid_grant', function () {
            $rootScope.logOut();
        });
        $scope.$on('invalid_auth', function () {
            $rootScope.logOut();
        });
        $scope.setAppName();
    };
    angular.module('imtecho.controllers').controller('MainController', mainController);
})();
