// (function () {
//     function UploadUserController(APP_CONFIG, LocationService, AuthenticateService, RoleDAO, UploadUserService, toaster, $rootScope, Mask, GeneralUtil) {

//         var ctrl = this;
//         ctrl.selectedLocation = {};
//         ctrl.fileName;
//         ctrl.isError = false;
//         ctrl.isFormatError = false;
//         ctrl.accessToken = $rootScope.authToken;
//         ctrl.apiPath = APP_CONFIG.apiPath;
//         ctrl.roleId = null;
//         ctrl.maxAllowedLevel = 0;
//         ctrl.roleList = []
//         ctrl.fileName = null;
//         ctrl.responseMessage = {};

//         var initPage = function () {
//             AuthenticateService.getAssignedFeature("techo.manage.users").then(function (res) {
//                 ctrl.rights = res.featureJson;
//                 if (!ctrl.rights) {
//                     ctrl.rights = {};
//                 }
//                 ctrl.getAllActiveRoles();

//             });

//         }

//         ctrl.retrieveLocationByRoleId = function () {
//             Mask.show();
//             return LocationService.retrieveLocationByRoleId(ctrl.roleId).then(function (res) {
//                 ctrl.maxAllowedLevel = _.max(res.hierarchy, function (hierarchy) {
//                     return hierarchy.level;
//                 }).level;
//                 if (ctrl.maxAllowedLevel == 0) {
//                     ctrl.maxAllowedLevel = 10;
//                 }
//                 ctrl.selectedLocation = {};

//             }).finally(function () {
//                 Mask.hide();
//             });

//         }

//         ctrl.getAllActiveRoles = function () {
//             Mask.show();
//             RoleDAO.retieveRolesByRoleId(ctrl.rights.isAdmin).then(function (res) {
//                 ctrl.roleList = res;
//             }).finally(function () {
//                 Mask.hide();
//             });
//         }

//         ctrl.download = function () {
//             ctrl.accessToken = $rootScope.authToken;
//             if (ctrl.form.$valid) {
//                 if (ctrl.selectedLocation.finalSelected) {
//                     Mask.show();
//                     UploadUserService.downloadSample(ctrl.selectedLocation.finalSelected.optionSelected.id, ctrl.roleId).then(function (res) {
//                         ctrl.selectedLocationInfo = res;
//                         if (res.data !== null && navigator.msSaveBlob) {
//                             return navigator.msSaveBlob(new Blob([res.data], { type: '' }));
//                         }
//                         var a = $("<a style='display: none;'/>");
//                         var url = window.URL.createObjectURL(new Blob([res.data], { type: 'application/vnd.ms-excel' }));
//                         a.attr("href", url);
//                         a.attr("download", (!!ctrl.fileName ? ctrl.fileName : "") + "_" + new Date().getTime() + ".xlsx");
//                         $("body").append(a);
//                         a[0].click();
//                         window.URL.revokeObjectURL(url);
//                         a.remove();
//                     }).catch((error) => {
//                         GeneralUtil.showMessageOnApiCallFailure(error);
//                     }).finally(() => {
//                         Mask.hide();
//                     });
//                 } else {
//                     toaster.pop('danger', 'Please select location.');
//                 }
//             }
//         }

//         ctrl.uploadFile = {
//             singleFile: true,
//             testChunks: false,
//             allowDuplicateUploads: true,
//             chunkSize: 10 * 1024 * 1024,
//             headers: {
//                 Authorization: 'Bearer ' + ctrl.accessToken
//             },
//             uploadMethod: 'POST'
//         };


//         ctrl.upload = function ($file, $event, $flow) {
//             ctrl.fileName = null;
//             ctrl.responseMessage = {};
//             if ($file.getExtension() !== "xlsx") {
//                 ctrl.isFormatError = true;
//                 ctrl.isError = false;
//                 $flow.cancel();
//                 return;
//             }
//             ctrl.isError = false;
//             ctrl.isFormatError = false;
//             $flow.opts.target = APP_CONFIG.apiPath + '/upload/user';
//         }

//         ctrl.uploadFn = function ($files, $event, $flow) {
//             Mask.show();
//             if (!ctrl.isFormatError) {
//                 $flow.upload();
//             } else {
//                 $flow.cancel();
//             }
//             Mask.hide();
//         }


//         ctrl.getUploadResponse = function ($file, $message, $flow) {
//             var fileName = $message;
//             ctrl.processLocationFile(fileName);
//         };

//         ctrl.processLocationFile = function (fileName) {
//             ctrl.isDataLoading = true;
//             ctrl.responseMessage = {};
//             console.log(fileName);
//             UploadUserService.processXls(fileName).then(function (res) {
//                 ctrl.responseMessage = angular.copy(res);
//                 if (ctrl.responseMessage.result_File) {
//                     ctrl.isError = false;
//                     ctrl.fileName = ctrl.responseMessage.result_File;
//                 } else if (ctrl.responseMessage.result) {
//                     ctrl.isError = true;
//                 } else {
//                     ctrl.isError = false;
//                 }

//             }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
//                 ctrl.isDataLoading = false;
//             });
//         };
//         initPage();
//     }
//     angular.module('imtecho.controllers').controller('UploadUserController', UploadUserController);
// })();
