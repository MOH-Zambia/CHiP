(function (angular) {
    function SmsTypeListController(SmsTypeService, Mask, GeneralUtil, $uibModal, toaster) {
        var ctrl = this;
        var init = function () {
            ctrl.getAllTypes();
        }

        ctrl.getAllTypes = function(){
            Mask.show();
            SmsTypeService.getAllSmsTypes().then(function (res) {
                ctrl.smsTypeList = res;
            }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide);
        }

        ctrl.toggleActive = function (smsType) {
            var changedState = 'INACTIVE';
            if (smsType.state == 'INACTIVE') {
                changedState = 'ACTIVE';
            }
            var modalInstance = $uibModal.open({
                templateUrl: 'app/common/views/confirmation.modal.html',
                controller: 'ConfirmModalController',
                windowClass: 'cst-modal',
                size: 'med',
                resolve: {
                    message: function () {
                        return "Are you sure you want to change the state from " + smsType.state + ' to ' + changedState + '? ';
                    }
                }
            });
            modalInstance.result.then(function () {
                Mask.show();
                let isActive = smsType.state === 'ACTIVE' ? true : false;
                SmsTypeService.updateSmsTypeState(smsType, isActive).then(function (res) {
                    ctrl.getAllTypes();
                }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide);
            }, function () { });
        };

        init();
    }
    angular.module('imtecho.controllers').controller('SmsTypeListController', SmsTypeListController);
})(window.angular);
