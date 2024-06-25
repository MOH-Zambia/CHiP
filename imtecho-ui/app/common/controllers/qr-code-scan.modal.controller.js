(function (angular) {
    let QRCodeScanModalController = function ($scope, $uibModalInstance, toaster, validInput) {

        const init = function () {

            angular.element(document).ready(function () {
                angular.element('#reader').html5_qrcode(function (data) { // starts webcam
                    if(data.includes(validInput)){
                        $scope.close(data);
                    }
                    else{
                        toaster.pop('error', 'Invalid QR Code');
                        $scope.close();
                    }   
                },
                function() {
                },
                function() {
                    toaster.pop('error','Give camera permission first.');
                    $uibModalInstance.close();
                })
            });

        };

        $scope.close = function (data = null) {
            angular.element("#reader").html5_qrcode_stop(); // stops webcam
            $uibModalInstance.close(data);
        };

        init();
    };
    angular.module('imtecho.controllers').controller('QRCodeScanModalController', QRCodeScanModalController);
})(window.angular);