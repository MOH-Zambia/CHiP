(function () {
    function UserListModalController($scope, staffSmsConfigId, QueryDAO, $uibModalInstance, GeneralUtil, Mask) {

        $scope.close = function () {
            $uibModalInstance.dismiss('cancel');
        };

        $scope.init = function () {
            $scope.staffSmsUserList = {};
            Mask.show();
            QueryDAO.execute({
                code: 'retrieve_staff_sms_user_sms_status_list',
                parameters: {
                    staffSmsConfigId: Number(staffSmsConfigId)
                }
            }).then(function (res) {
                $scope.staffSmsUserList = res.result;
                if ($scope.staffSmsUserList.length > 0) {
                    $scope.isRoleBased = $scope.staffSmsUserList[0].configType === "ROLE_LOCATION_BASED";
                }
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        };

        $scope.init();

    }
    angular.module('imtecho.controllers').controller('UserListModalController', UserListModalController);
})();
