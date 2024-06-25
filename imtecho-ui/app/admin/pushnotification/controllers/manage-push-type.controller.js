(function (angular) {
    function ManagePushNotificationTypeController($state, Mask, toaster, DocumentDAO, GeneralUtil, AuthenticateService, APP_CONFIG, PushNotificationDAO) {
        let ctrl = this;
        ctrl.allowedFileExtns = ['jpg', 'png', 'jpeg'];
        ctrl.filePayload = { file: {} };
        ctrl.isFileRemoving = {};
        ctrl.isFileUploadProcessing = {};

        ctrl.fileUploadOptions = {
            singleFile: true,
            testChunks: false,
            allowDuplicateUploads: false,
            simultaneousUploads: 1,
            chunkSize: 10 * 1024 * 1024 * 1024,
            headers: {
                Authorization: 'Bearer ' + AuthenticateService.getToken()
            },
            uploadMethod: 'POST'
        };
        ctrl.init = () => {
            if ($state.params.id) {
                ctrl.id = $state.params.id;
                ctrl.updateMode = true;
                ctrl.headerText = "Update Push Notification Type";
                ctrl.getNotificationTypeById();
            } else {
                ctrl.headerText = "Add  New Push Notification Type";
            }
        }
        ctrl.getNotificationTypeById = () => {
            PushNotificationDAO.getById(ctrl.id).then(function (res) {
                ctrl.typeObj = res;
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        }

        ctrl.saveOrUpdated = () => {
            ctrl.managePushNotificationTypeForm.$setSubmitted();
            if (ctrl.managePushNotificationTypeForm.$valid) {
                ctrl.typeObj.type = ctrl.typeObj.type.toUpperCase();
                ctrl.typeObj.isActive = true;
                Mask.show();
                PushNotificationDAO.createOrUpdate(ctrl.typeObj).then(function (res) {
                    $state.go('techo.manage.pushnotificationtype');
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                });
            }
        }

        ctrl.onFileAdded = function ($file, $event, $flow) {
            ctrl.responseMessage = {};
            if (!ctrl.allowedFileExtns.includes($file.getExtension())) {
                ctrl.filePayload.isError = true;
                ctrl.filePayload.errorMessage = `Only .${ctrl.allowedFileExtns.join(', .')} files supported!`;
                $event.preventDefault();
                return false;
            }
            delete ctrl.filePayload.errorMessage;
            ctrl.filePayload.isError = false;
            $flow.opts.target = `${APP_CONFIG.apiPath}/document/uploaddocument/TECHO/false`;
        };

        ctrl.onFileSubmitted = function ($files, $event, $flow) {
            if (!$files || $files.length === 0) {
                return;
            }
            Mask.show();
            AuthenticateService.refreshAccessToken().then(function () {
                $flow.opts.headers.Authorization = 'Bearer ' + AuthenticateService.getToken();
                ctrl.filePayload.flow = ($flow);
                $flow.upload();
                if (!ctrl.filePayload.isError) {
                    ctrl.isFileUploading = true;
                    $files.forEach(file => ctrl.isFileUploadProcessing[file.name] = true)
                }
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        };

        ctrl.onFileSuccess = function ($file, $message, $flow) {
            ctrl.isFileUploading = false;
            ctrl.isFileUploadProcessing[$file.name] = false;
            ctrl.typeObj.mediaId = JSON.parse($message).id;
            ctrl.filePayload.file = {
                id: JSON.parse($message).id,
                name: $file.name
            };
        };

        ctrl.onFileError = function ($file, $message) {
            ctrl.isFileUploading = false;
            ctrl.isFileUploadProcessing[$file.name] = false;
            ctrl.filePayload.flow.files = ctrl.filePayload.flow.files.filter(e => e.name !== $file.name);
            toaster.pop('danger', 'Error in file upload!');
        };

        function _removeFile(fileName) {
            if (ctrl.filePayload.flow && ctrl.filePayload.flow.files) {
                ctrl.filePayload.flow.files = ctrl.filePayload.flow.files
                    .filter(e => e.name !== fileName);
            }
            ctrl.attachmentImage = null;
            ctrl.filePayload.file = {}
        }

        ctrl.onRemoveFile = function (fileName) {
            if (ctrl.filePayload.file.id) {
                ctrl.isFileRemoving[fileName] = true;
                DocumentDAO.removeFile(ctrl.filePayload.file.id)
                    .then(function () {
                        _removeFile(fileName);
                    }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                        ctrl.isFileRemoving[fileName] = false;
                    });
            } else {
                _removeFile(fileName);
            }
        };


        ctrl.init();
    }
    angular.module('imtecho.controllers').controller('ManagePushNotificationTypeController', ManagePushNotificationTypeController
    );
})(window.angular);
