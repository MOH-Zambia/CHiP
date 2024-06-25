(function (angular) {
    function SmsTypeManageController(SmsTypeService, Mask, GeneralUtil, $uibModal, toaster, $stateParams, $state) {
        var ctrl = this;

        var init = function () {
            if ($stateParams.type) {
                ctrl.isUpdateForm = true;
                ctrl.getSmsTypeByType($stateParams.type);
            } else {
                ctrl.isUpdateForm = false;
            }
        }

        ctrl.getSmsTypeByType = function (type) {
            Mask.show();
            SmsTypeService.getSmsTypeByType(type).then(function (res) {
                if(!!res){
                    ctrl.smsTypeObj = res;
                }
            }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide);
        }

        ctrl.action = function (form) {
            form.$setSubmitted();
            if (form.$valid) {
                if(ctrl.isUpdateForm){
                    Mask.show();
                    SmsTypeService.updateSmsType(ctrl.smsTypeObj).then(function (res) {
                        toaster.pop('success', 'Sms Type Updated Successfully!');
                        $state.go('techo.manage.smstype');
                    }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide);
                }else{
                    Mask.show();
                    SmsTypeService.createSmsType(ctrl.smsTypeObj).then(function (res) {
                        toaster.pop('success', 'Sms Type Created Successfully!');
                        $state.go('techo.manage.smstype');
                    }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide);
                }
            }
        }

        init();
    }
    angular.module('imtecho.controllers').controller('SmsTypeManageController', SmsTypeManageController);
})(window.angular);
