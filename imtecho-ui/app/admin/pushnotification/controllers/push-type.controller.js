(function (angular) {
    function PushNotificationTypeController($state, Mask, toaster, GeneralUtil, PushNotificationDAO, $uibModal) {
        let ctrl = this;

        ctrl.init = () => {
            ctrl.getTypeList();
        }

        ctrl.getTypeList = () => {
            PushNotificationDAO.getNotificationTypeList().then(function (res) {
                ctrl.typeList = res;
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        }

        ctrl.navigateToEdit = (id) => {
            $state.go('techo.manage.managepushnotificationtype', { id: id });
        }

        ctrl.toggleState = (typeObj) => {
            let changedState;
            if (typeObj.isActive) {
                changedState = false;
            } else {
                changedState = true;
            }
            var modalInstance = $uibModal.open({
                templateUrl: 'app/common/views/confirmation.modal.html',
                controller: 'ConfirmModalController',
                windowClass: 'cst-modal',
                size: 'med',
                resolve: {
                    message: function () {
                        return `Are you sure you want to change the state from  ${typeObj.isActive ? 'ACTIVE' : 'INACTIVE'}  to  ${!changedState ? 'INACTIVE' : 'ACTIVE'} ? `;
                    }
                }
            });
            modalInstance.result.then(function () {
                typeObj.isActive = !typeObj.isActive;
                Mask.show();
                PushNotificationDAO.createOrUpdate(typeObj).then(function (res) {
                    toaster.pop("success", "State changed successfully");
                    ctrl.getTypeList();
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                });
            }, function () {

            });

        }

        ctrl.init();
    }
    angular.module('imtecho.controllers').controller('PushNotificationTypeController', PushNotificationTypeController
    );
})(window.angular);
