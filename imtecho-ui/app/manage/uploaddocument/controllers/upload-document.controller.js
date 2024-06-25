(function () {
    function UploadDocumentController(APP_CONFIG, Mask, GeneralUtil, $rootScope, toaster, UploadDocumentService) {
        var ctrl = this;
        ctrl.isFilterOpen = false;
        ctrl.category = null;
        ctrl.fileName = null;
        ctrl.fileExtention = null;
        ctrl.isFormatError = false;
        ctrl.isSizeError = false;
        ctrl.accessToken = $rootScope.authToken;
        ctrl.apiPath = APP_CONFIG.apiPath;
        ctrl.isUploadFileError = false;
        ctrl.folderHierarchy = {};
        ctrl.levels = [];

        ctrl.resetFields = function () {
            ctrl.category = null;
            ctrl.fileName = null;
            ctrl.fileExtention = null;
            ctrl.isFormatError = false;
            ctrl.isSizeError = false;
            ctrl.flow = null;
            ctrl.isUploadFileError = false;
            ctrl.folderHierarchy = {};
            ctrl.levels = [];
            ctrl.folderPath = '';
            ctrl.description = '';
        }

        ctrl.uploadFile = {
            singleFile: true,
            testChunks: false,
            allowDuplicateUploads: true,
            chunkSize: 4 * 1024 * 1024 * 1024,
            headers: {
                Authorization: 'Bearer ' + ctrl.accessToken
            },
            uploadMethod: 'POST'
        };

        ctrl.upload = function ($file, $event, $flow) {
            ctrl.isUploadFileError = false;
            ctrl.fileExtention = $file.getExtension();
            ctrl.fileSize = $file.size;
            $flow.opts.target = APP_CONFIG.apiPath + '/upload/document/upload';
            $flow.opts.query = { path: ctrl.folderPath };
            ctrl.isFormatError = false;
            ctrl.isSizeError = false;
        }

        ctrl.uploadFn = function ($files, $event, $flow) {
            Mask.show();
            ctrl.flow = ($flow);
            if (!ctrl.isFormatError && !ctrl.isSizeError) {
                ctrl.flow.upload();
            } else {
                ctrl.flow.cancel();
            }
            Mask.hide();
        }

        ctrl.getUploadResponse = function ($file, $message, $flow) {
            ctrl.isUploadFileError = false;
            ctrl.fileName = $message;
        };

        ctrl.removeDocument = function (fileName) {
            if (fileName) {
                UploadDocumentService.removeDocument(fileName).then(function (response) {
                    toaster.pop("success", fileName + " is successfully deleted");
                    ctrl.removeFileFromFlow(fileName);
                });
            }
        }

        ctrl.removeFileFromFlow = function (fileName) {
            if (ctrl.flow != undefined) {
                for (var i = 0; i < ctrl.flow.files.length; i++) {
                    if (ctrl.flow.files[i].name === fileName) {
                        ctrl.flow.files.splice(i, 1);
                    }
                }
                ctrl.fileName = null;
                ctrl.fileExtention = null;
            }
        }

        ctrl.uploadDocumentFile = function (form) {
            if (!ctrl.folderPath) {
                toaster.pop("warning", "Please select main folder!");
                return;
            }
            if (!ctrl.flow) {
                toaster.pop("warning", "Please upload file!");
                return;
            }
            if (ctrl.flow && (ctrl.fileName === null || ctrl.fileName === "")) {
                ctrl.isUploadFileError = true;
                return;
            } else
                ctrl.isUploadFileError = false;

            if (ctrl.uploadFileForm.$invalid)
                return;

            Mask.show();
            UploadDocumentService.uploadDocument(ctrl.fileName).then(function (res) {
                toaster.pop('success', 'Record submitted successfully');
                ctrl.resetFields();
                ctrl.uploadFileForm.$setPristine();
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            })
        }

        ctrl.toggleFilter = function (fileObject) {
            if (fileObject)
                ctrl.fileObject = fileObject;
            ctrl.isFilterOpen = !ctrl.isFilterOpen;
        };
    }
    angular.module('imtecho.controllers').controller('UploadDocumentController', UploadDocumentController);
})();
