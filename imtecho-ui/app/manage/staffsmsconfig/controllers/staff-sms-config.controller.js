(function () {
    function StaffSmsController($state, AuthenticateService, APP_CONFIG, Mask, GeneralUtil, toaster, StaffSmsConfigDAO, QueryDAO, $uibModal) {
        var ctrl = this;
        ctrl.allowedExcelExts = ['xlsx', 'csv', 'xls'];
        ctrl.uploadInfoObj = {};

        var initPage = function () {
            ctrl.headerText = "Staff Sms Configuration";
            ctrl.orderByField = 'dateTime'
            ctrl.reverseOrder = true;
            AuthenticateService.getAssignedFeature("techo.manage.staffsmsconfigs").then(function (res) {
                ctrl.rights = res.featureJson;
                if (!!ctrl.rights) {
                    if (ctrl.rights.canManageAllSms) {
                        ctrl.retrieveStaffSmsConfigs();
                    } else {
                        AuthenticateService.getLoggedInUser().then(function (user) {
                            ctrl.loggedInUser = user.data;
                            ctrl.retrieveStaffSmsConfigsByUserId(ctrl.loggedInUser.id);
                        });
                    }
                }
            });
        }

        ctrl.retrieveStaffSmsConfigs = function () {
            var dto = {
                code: 'retrieve_all_staff_sms',
                parameters: {}
            };
            Mask.show();
            QueryDAO.execute(dto).then(function (res) {
                ctrl.smsStaffConfigs = res.result;
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        }

        ctrl.retrieveStaffSmsConfigsByUserId = function (userId) {
            var dto = {
                code: 'retrieve_staff_sms_by_userid',
                parameters: {
                    userId: userId,
                }
            };
            Mask.show();
            QueryDAO.execute(dto).then(function (res) {
                ctrl.smsStaffConfigs = res.result;
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        }

        ctrl.orderField = function (orderByField) {
            ctrl.orderByField = orderByField;
            ctrl.reverseOrder = !ctrl.reverseOrder;
        };

        ctrl.onAddEditClick = function (staffSmsConfId) {
            $state.go('techo.manage.staffsmsconfigdynamic', { id: staffSmsConfId });
        }

        ctrl.uploadFile = {
            singleFile: true,
            testChunks: false,
            allowDuplicateUploads: true,
            chunkSize: 10 * 1024 * 1024 * 1024,
            headers: {
                Authorization: 'Bearer ' + AuthenticateService.getToken()
            },
            uploadMethod: 'POST'
        };

        ctrl.upload = function ($file, $event, $flow, mediatype, timeline) {
            ctrl.responseMessage = {};
            timeline.isError = false;
            if (mediatype === 'upload' && ctrl.allowedExcelExts.indexOf($file.getExtension()) < 0) {
                toaster.pop('danger', $file.getExtension() + ' format is not supported. Please upload '
                    + mediatype + ' having extensions ' + ctrl.allowedExcelExts.toString());
                timeline.isError = true;
            }
            if (timeline.isError) {
                $flow.cancel();
                return false;
            }
            $flow.opts.target = APP_CONFIG.apiPath + '/document/uploaddocument/TECHO/false';
        };

        ctrl.uploadFn = function ($files, $event, $flow, timeline) {
            if (!timeline.isError) {
                Mask.show();
                AuthenticateService.refreshAccessToken().then(function () {
                    $flow.opts.headers.Authorization = 'Bearer ' + AuthenticateService.getToken();
                    timeline.flow = ($flow);
                    $flow.upload();
                    ctrl.isUploading = true;
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                });
            }
        };

        ctrl.getUploadResponse = function ($file, $message, $flow, timeline) {
            ctrl.isUploading = false;
            timeline.mediaName = JSON.parse($message).id;
            timeline.originalMediaName = $file.name;
        };

        ctrl.fileError = function ($file, $message, timeline) {
            timeline.flow.files = [];
            ctrl.isUploading = false;
            toaster.pop('danger', 'Error in file upload.');
        };

        ctrl.toggleStafSmsConfig = function (timelineConfig) {
            var modalInstance = $uibModal.open({
                templateUrl: 'app/common/views/confirmation.modal.html',
                controller: 'ConfirmModalController',
                windowClass: 'cst-modal',
                size: 'med',
                resolve: {
                    message: function () {
                        return "Are you sure you want to change the state of this staff sms configuration ?";
                    }
                }
            });
            modalInstance.result.then(function () {
                console.log('api call');
                ctrl.toggle = timelineConfig.state == 'INACTIVE' ? 'ACTIVE' : 'INACTIVE';
                Mask.show();
                console.log(ctrl.toggle, timelineConfig.id);

                StaffSmsConfigDAO.markStateActiveOrInActive(ctrl.toggle, timelineConfig.id).then(function (res) {
                    toaster.pop('success', "Staff sms configuration state changed successfully.");
                    initPage();
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                });
            });
        };

        ctrl.openUserModal = function (staffSmsConfig) {
            $uibModal.open({
                templateUrl: 'app/manage/staffsmsconfig/views/user-list.modal.html',
                controller: 'UserListModalController',
                windowClass: 'cst-modal',
                size: 'lg',
                resolve: {
                    staffSmsConfigId: function () {
                        return staffSmsConfig.id;
                    }
                }
            });
        };

        initPage();

    }
    angular.module('imtecho.controllers').controller('StaffSmsController', StaffSmsController);
})();
