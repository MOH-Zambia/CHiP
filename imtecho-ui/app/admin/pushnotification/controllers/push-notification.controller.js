(function (angular) {
    function PushNotificationController($state, Mask, toaster, GeneralUtil, PushNotificationDAO, $uibModal, PagingService) {
        let ctrl = this;
        ctrl.pagingService = PagingService.initialize();

        ctrl.init = () => {
            ctrl.getNotificationList(true);
        }

        ctrl.getNotificationList = (reset) => {
            ctrl.criteria = { limit: ctrl.pagingService.limit, offset: ctrl.pagingService.offSet };
            var notificationList = ctrl.notificationList;
            if (reset) {
                userList = [];
                ctrl.pagingService.resetOffSetAndVariables();
            }

            Mask.show();
            PagingService.getNextPage(PushNotificationDAO.getNotifications, ctrl.criteria, notificationList, null).then(function (res) {
                ctrl.notificationList = res;
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        }

        ctrl.navigateToEdit = (id) => {
            $state.go('techo.manage.managepushnotification', { id: id });
        }

        ctrl.toggleState = (obj) => {
            let changedState;
            if (obj.state == 'ACTIVE') {
                changedState = 'INACTIVE';

            } else {
                changedState = 'ACTIVE';
            }
            var modalInstance = $uibModal.open({
                templateUrl: 'app/common/views/confirmation.modal.html',
                controller: 'ConfirmModalController',
                windowClass: 'cst-modal',
                size: 'med',
                resolve: {
                    message: function () {
                        return "Are you sure you want to change the state from " + obj.state + ' to ' + changedState + '? ';
                    }
                }
            });
            modalInstance.result.then(function () {
                obj.state = changedState;
                Mask.show();
                PushNotificationDAO.toggleNotificationConfigState(obj.id).then(function (res) {
                    toaster.pop("success", "State changed successfully");
                    ctrl.getNotificationList();
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                });
            }, function () {

            });

        }

        ctrl.init();
    }
    angular.module('imtecho.controllers').controller('PushNotificationController', PushNotificationController
    );
})(window.angular);
