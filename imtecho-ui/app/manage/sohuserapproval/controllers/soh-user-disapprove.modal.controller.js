(function () {
    function DisApprovedUserReasonForHelathApproval(UserHealthApprovalService, toaster, Mask, userId, GeneralUtil, $uibModalInstance) {
        var ctrl = this;

        var initPage = function () {
            ctrl.reasonForDisApproval = null;
            ctrl.userId = userId;
            ctrl.res = {};
        };

        ctrl.cancel = function () {
            $uibModalInstance.dismiss('cancel');
        };

        ctrl.submitDisApprovalReason = function (reason) {
            Mask.show();
            if (!!reason) {
                UserHealthApprovalService.disApproveUser(userId, reason).then(function (res, headers) {
                    if (!!res) {
                        toaster.pop('success', 'User state updated Successfully!');
                        $uibModalInstance.close(1);
                    }
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                })
            } else
                toaster.pop('danger', 'Enter valid reason');
        }

        initPage();
    }
    angular.module('imtecho.controllers').controller('DisApprovedUserReasonForHelathApproval', DisApprovedUserReasonForHelathApproval);
})();
