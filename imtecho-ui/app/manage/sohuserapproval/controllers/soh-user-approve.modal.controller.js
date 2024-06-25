(function () {
    function ApprovedUserLocationForHelathApproval(UserHealthApprovalService, toaster, Mask, userId, GeneralUtil, $uibModalInstance) {
        var ctrl = this;

        var initPage = function () {
            ctrl.selectedLocationId = null;
            ctrl.userId = userId;
            ctrl.res = {};
        };

        ctrl.cancel = function () {
            $uibModalInstance.dismiss('cancel');
        };

        ctrl.updateUserState = function (locationId) {
            Mask.show();
            if (!!locationId) {
                UserHealthApprovalService.updateUserState(userId, locationId).then(function (res, headers) {
                    if (!!res) {
                        toaster.pop('success', 'User state updated Successfully!');
                        $uibModalInstance.close(1);
                    }
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                })
            } else
                toaster.pop('danger', 'Select valid location');
        }

        initPage();
    }
    angular.module('imtecho.controllers').controller('ApprovedUserLocationForHelathApproval', ApprovedUserLocationForHelathApproval);
})();
