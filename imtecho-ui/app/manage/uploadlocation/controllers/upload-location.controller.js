(function () {
    function UploadLocationController(APP_CONFIG, $rootScope, UploadLocationService, Mask, GeneralUtil) {

        var ctrl = this;
        ctrl.fileName;
        ctrl.isError = false;
        ctrl.isFormatError = false;
        ctrl.accessToken = $rootScope.authToken;
        ctrl.apiPath = APP_CONFIG.apiPath;

        ctrl.uploadFile = {
            singleFile: true,
            testChunks: false,
            allowDuplicateUploads: true,
            chunkSize: 10 * 1024 * 1024,
            headers: {
                Authorization: 'Bearer ' + ctrl.accessToken
            },
            uploadMethod: 'POST'
        };

        ctrl.upload = function ($file, $event, $flow) {
            ctrl.responseMessage = {};
            if ($file.getExtension() !== "xlsx") {
                ctrl.isFormatError = true;
                ctrl.isError = false;
                $flow.cancel();
                return;
            }
            ctrl.isError = false;
            ctrl.isFormatError = false;
            $flow.opts.target = APP_CONFIG.apiPath + '/upload/location';
        }

        ctrl.uploadFn = function ($files, $event, $flow) {
            Mask.show();
            if (!ctrl.isFormatError) {
                $flow.upload();
            } else {
                $flow.cancel();
            }
            Mask.hide();
        }

        ctrl.getUploadResponse = function ($file, $message, $flow) {
            var fileName = $message;
            ctrl.processLocationFile(fileName);
        };

        ctrl.processLocationFile = function (fileName) {
            ctrl.isDataLoading = true;
            ctrl.responseMessage = {};
            UploadLocationService.processXls(fileName).then(function (res) {
                ctrl.responseMessage = angular.copy(res);
                if (ctrl.responseMessage.error_file_name) {
                    ctrl.isError = true;
                    ctrl.fileName = ctrl.responseMessage.error_file_name;
                } else if (ctrl.responseMessage.result) {
                    ctrl.isError = true;
                } else {
                    ctrl.isError = false;
                }

            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                ctrl.isDataLoading = false;
            });
        };


    }
    angular.module('imtecho.controllers').controller('UploadLocationController', UploadLocationController);
})();
