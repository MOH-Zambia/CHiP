(function () {
    function ManageStaffSmsConfigController($stateParams, $location, toaster, APP_CONFIG, StaffSmsConfigDAO, RoleDAO, UserDAO, Mask, AuthenticateService, GeneralUtil, TriggerTypes, $state, $rootScope) {
        var staffSmsConfig = this;
        staffSmsConfig.role = "";
        staffSmsConfig.name = "";
        staffSmsConfig.description = "";
        staffSmsConfig.triggerType = "";
        staffSmsConfig.template = "";
        staffSmsConfig.date = "";
        staffSmsConfig.time = "";
        staffSmsConfig.hour = "";
        staffSmsConfig.triggerTypesList = TriggerTypes;
        staffSmsConfig.selectedLocation;
        staffSmsConfig.maxAllowedLevel;
        staffSmsConfig.locationForm;
        staffSmsConfig.isLocationButtonDisabled;
        staffSmsConfig.selectedLocationsId;
        staffSmsConfig.duplicateEntry;
        staffSmsConfig.isNotAllowedLocation;
        staffSmsConfig.noLocationSelected = false;
        staffSmsConfig.deletedLocations = [];
        staffSmsConfig.today = new Date();
        staffSmsConfig.allowedExcelExts = ['xlsx', 'xls'];
        staffSmsConfig.uploadInfoObj = {};
        staffSmsConfig.excelError = '';

        var initPage = function () {
            staffSmsConfig.authToken = $rootScope.authToken;
            staffSmsConfig.apiPath = APP_CONFIG.apiPath;
            staffSmsConfig.hstep = 1;
            staffSmsConfig.mstep = 1;
            staffSmsConfig.ismeridian = false;
            staffSmsConfig.showspinners = false;
            staffSmsConfig.dateAndTimeConf = {
                fieldName: 'dateNTime'
            }
            staffSmsConfig.fileUploaded = false;
            staffSmsConfig.TriggerTypes = TriggerTypes
            staffSmsConfig.selectedLocationsId = [];
            staffSmsConfig.userObj = {};
            staffSmsConfig.allowEdit = false;
            staffSmsConfig.uploadExcel = false;
            staffSmsConfig.server = $location.protocol() + $location.host() + $location.port();
            staffSmsConfig.filename = "demo.xlsx";

            if ($stateParams.id) {
                StaffSmsConfigDAO.retrieveById($stateParams.id).then((data) => {
                    staffSmsConfig.initInputs(data);
                });
                staffSmsConfig.updateMode = true;
                staffSmsConfig.headerText = 'Update Staff Sms Configuration';
            } else {
                staffSmsConfig.headerText = 'Add Staff Sms Configuration';
                staffSmsConfig.uploadExcel = "ROLE_LOCATION_BASED";
            }

            AuthenticateService.getAssignedFeature("techo.manage.users").then(function (res) {
                staffSmsConfig.rights = res.featureJson;
                if (!staffSmsConfig.rights) {
                    staffSmsConfig.rights = {};
                }
                staffSmsConfig.getAllActiveRoles();
            });
            staffSmsConfig.isLocationButtonDisabled = false;
        }

        staffSmsConfig.getAllActiveRoles = function () {
            Mask.show();
            RoleDAO.retieveRolesByRoleId(staffSmsConfig.rights.isAdmin).then(function (res) {
                staffSmsConfig.roleList = res;
            }).finally(function () {
                Mask.hide();
            });
        };

        staffSmsConfig.initInputs = function (data) {
            AuthenticateService.getLoggedInUser().then(function (user) {
                staffSmsConfig.loggedInUser = user.data;
                staffSmsConfig.createdByUser = false;
                if (staffSmsConfig.loggedInUser.id == data.createdBy) {
                    staffSmsConfig.createdByUser = true;
                }
                staffSmsConfig.id = data.id;
                staffSmsConfig.triggerType = data.triggerType;
                staffSmsConfig.updateTriggerType = data.triggerType;
                staffSmsConfig.updateStatus = data.status;
                staffSmsConfig.uploadExcel = data.configType;
                if (staffSmsConfig.uploadExcel == 'EXCEL_BASED') {
                    staffSmsConfig.uploadInfoObj.mediaName = data.documentId
                    StaffSmsConfigDAO.getDocumentDetail(data.documentId).then((doc) => {
                        staffSmsConfig.fileUploaded = true;
                        staffSmsConfig.uploadInfoObj.fileName = doc.fileName;
                        staffSmsConfig.uploadInfoObj.originalMediaName = doc.actualFileName;
                    });
                }
                if (data.triggerType == "scheduleTime") {
                    staffSmsConfig.date = new Date(data.dateTime);
                    staffSmsConfig.time = new Date(data.dateTime);
                }
                else if (data.triggerType == "timer") {
                    staffSmsConfig.day = data.day;
                    staffSmsConfig.hour = data.hour;
                    staffSmsConfig.minute = data.minute;
                }
                staffSmsConfig.name = data.name;
                staffSmsConfig.description = data.description;
                staffSmsConfig.template = data.smsTemplate
                if (data.roles.length > 0) {
                    staffSmsConfig.userObj.roleId = data.roles.map((role) => {
                        return role.roleId;
                    });
                }
                if (data.locations.length > 0) {
                    staffSmsConfig.selectedLocationsId = data.locations;
                }
            });
        }

        staffSmsConfig.selectedArea = function () {
            staffSmsConfig.locationForm.$setSubmitted();
            if (staffSmsConfig.selectedLocation.finalSelected !== null) {
                let selectedobj;
                if (staffSmsConfig.selectedLocation.finalSelected.optionSelected) {
                    selectedobj = {
                        locationId: staffSmsConfig.selectedLocation.finalSelected.optionSelected.id,
                        type: staffSmsConfig.selectedLocation.finalSelected.optionSelected.type,
                        level: staffSmsConfig.selectedLocation.finalSelected.level,
                        name: staffSmsConfig.selectedLocation.finalSelected.optionSelected.name

                    };
                } else {
                    selectedobj = {
                        locationId: staffSmsConfig.selectedLocation["level" + (staffSmsConfig.selectedLocation.finalSelected.level - 1)].id,
                        type: staffSmsConfig.selectedLocation["level" + (staffSmsConfig.selectedLocation.finalSelected.level - 1)].type,
                        level: staffSmsConfig.selectedLocation.finalSelected.level - 1,
                        name: staffSmsConfig.selectedLocation["level" + (staffSmsConfig.selectedLocation.finalSelected.level - 1)].name

                    };
                }
                staffSmsConfig.duplicateEntry = false;
                for (let i = 0; i < staffSmsConfig.selectedLocationsId.length; i++) {
                    if (staffSmsConfig.selectedLocationsId[i].locationId === selectedobj.locationId) {
                        staffSmsConfig.duplicateEntry = true;
                        staffSmsConfig.isLocationButtonDisabled = false;
                    }
                }
                if (!staffSmsConfig.duplicateEntry) {
                    staffSmsConfig.isNotAllowedLocation = false;
                    if (!staffSmsConfig.selectedLocationsId) {
                        staffSmsConfig.selectedLocationsId = [];
                    }
                    var itteratingLevel = 1,
                        locationFullName = '';
                    while (itteratingLevel < staffSmsConfig.selectedLocation.finalSelected.level) {
                        if (staffSmsConfig.selectedLocation['level' + itteratingLevel]) {
                            locationFullName = locationFullName.concat(staffSmsConfig.selectedLocation['level' + itteratingLevel].name + ',');
                        }
                        itteratingLevel = itteratingLevel + 1;
                    }
                    if (staffSmsConfig.selectedLocation.finalSelected.optionSelected) {
                        locationFullName = locationFullName.concat(staffSmsConfig.selectedLocation.finalSelected.optionSelected.name);
                    } else {
                        locationFullName = locationFullName.substring(0, locationFullName.length - 1);
                    }
                    selectedobj.locationFullName = locationFullName;

                    var selectedLocationIds = _.pluck(staffSmsConfig.selectedLocationsId, "locationId");
                    staffSmsConfig.isLocationButtonDisabled = true;
                    UserDAO.validateaoi(staffSmsConfig.userObj.roleId, selectedLocationIds, selectedobj.locationId, staffSmsConfig.userObj.id).then(function (res) {
                        if (res.errorcode === 2) {
                            if (!res.data) {
                                staffSmsConfig.errorMsg = res.message;
                                staffSmsConfig.errorCode = res.errorcode;
                                return
                            }
                        }
                        staffSmsConfig.selectedLocationsId.push(selectedobj);
                        delete staffSmsConfig.errorMsg;
                        delete staffSmsConfig.errorCode;
                        if (staffSmsConfig.selectedLocationsId.length > 0) {
                            staffSmsConfig.noLocationSelected = false;
                        }
                    }, GeneralUtil.showMessageOnApiCallFailure)
                        .finally(function () {
                            staffSmsConfig.isLocationButtonDisabled = false;
                        });
                }
            }
        };

        staffSmsConfig.removeSelectedArea = function (removedLoc, index) {
            staffSmsConfig.deletedLocations.push(removedLoc);
            staffSmsConfig.selectedLocationsId.splice(index, 1);
            if (staffSmsConfig.selectedLocationsId.length <= 0) {
                staffSmsConfig.noLocationSelected = true;
            }
        };

        staffSmsConfig.chagneState = function () {
            $state.go('techo.manage.staffsmsconfigs');
        };
        staffSmsConfig.timeChanged = function () {
            if (staffSmsConfig.invalidTime && staffSmsConfig.invalidTime === true && staffSmsConfig.time && staffSmsConfig.time != "") {
                staffSmsConfig.invalidTime = false;
            }
        }
        staffSmsConfig.saveOrUpdateStaffSmsConfig = function (form) {
            if (staffSmsConfig.uploadExcel == 'ROLE_LOCATION_BASED' && staffSmsConfig.selectedLocationsId.length <= 0) {
                staffSmsConfig.noLocationSelected = true;
                return;
            }
            if (staffSmsConfig.uploadExcel == 'EXCEL_BASED' && !staffSmsConfig.uploadInfoObj.mediaName) {
                staffSmsConfig.noFileUploaded = true;
                return;
            }

            if (form.$valid) {
                let date = new Date(Date.parse(staffSmsConfig.date));
                var dateNTime = new Date();
                if (staffSmsConfig.updateMode) {
                    dateNTime = new Date(staffSmsConfig.date);
                }
                if (staffSmsConfig.triggerType == 'scheduleTime') {
                    if (!staffSmsConfig.time || staffSmsConfig.time == "") {
                        staffSmsConfig.invalidTime = true;
                        return;
                    }
                    if (!staffSmsConfig.updateMode || (staffSmsConfig.updateMode && dateNTime != staffSmsConfig.date)) {
                        dateNTime.setDate(date.getDate());
                        dateNTime.setMonth(date.getMonth());
                        dateNTime.setFullYear(date.getFullYear());
                        dateNTime.setHours(staffSmsConfig.time.getHours());
                        dateNTime.setMinutes(staffSmsConfig.time.getMinutes());
                        dateNTime.setSeconds(0);
                    }

                }
                var smsStaffConfigDto = {}

                if (staffSmsConfig.updateMode) {
                    smsStaffConfigDto.id = staffSmsConfig.id;
                }
                smsStaffConfigDto.name = staffSmsConfig.name;
                smsStaffConfigDto.description = staffSmsConfig.description;
                smsStaffConfigDto.smsTemplate = staffSmsConfig.template;
                smsStaffConfigDto.dateTime = dateNTime;
                smsStaffConfigDto.triggerType = staffSmsConfig.triggerType;
                smsStaffConfigDto.day = staffSmsConfig.day;
                smsStaffConfigDto.hour = staffSmsConfig.hour;
                smsStaffConfigDto.date = new Date()
                smsStaffConfigDto.minute = staffSmsConfig.minute;
                if (staffSmsConfig.uploadExcel == 'ROLE_LOCATION_BASED') {
                    smsStaffConfigDto.locations = staffSmsConfig.selectedLocationsId;
                    smsStaffConfigDto.roles = staffSmsConfig.userObj.roleId.map((role) => { return { roleId: role } });
                } else {
                    smsStaffConfigDto.documentId = staffSmsConfig.uploadInfoObj.mediaName;
                }
                smsStaffConfigDto.configType = staffSmsConfig.uploadExcel;

                Mask.show();
                if (staffSmsConfig.uploadExcel == 'ROLE_LOCATION_BASED') {
                    StaffSmsConfigDAO.createOrUpdate(smsStaffConfigDto).then((data) => {
                        staffSmsConfig.chagneState();
                        toaster.pop('success', 'Staff sms Configuration saved successfully');
                    }).catch((error) => {
                        toaster.pop('error', 'Your Staff configuration is not saved successfully. Please try after some time.');
                    }).finally(function () {
                        Mask.hide();
                    });
                } else {
                    StaffSmsConfigDAO.createOrUpdateExcelConf(smsStaffConfigDto).then((data) => {
                        staffSmsConfig.chagneState();
                        toaster.pop('success', 'Staff sms Configuration saved successfully');
                    }).catch((error) => {
                        if (error && error.data && angular.isDefined(error.data.message)) {
                            staffSmsConfig.excelError = error.data.message;
                        }
                    }).finally(function () {
                        Mask.hide();
                    });
                }
            } else if (!form.$valid && staffSmsConfig.triggerType == 'scheduleTime' && (!staffSmsConfig.time)) {
                staffSmsConfig.invalidTime = true;
                return;
            }
        };

        staffSmsConfig.uploadFile = {
            singleFile: true,
            testChunks: false,
            allowDuplicateUploads: true,
            chunkSize: 10 * 1024 * 1024 * 1024,
            headers: {
                Authorization: 'Bearer ' + AuthenticateService.getToken()
            },
            uploadMethod: 'POST'
        };

        staffSmsConfig.upload = function ($file, $event, $flow, timeline) {
            staffSmsConfig.fileUploaded = false;
            staffSmsConfig.responseMessage = {};
            timeline.isError = false;
            if (staffSmsConfig.allowedExcelExts.indexOf($file.getExtension()) < 0) {
                toaster.pop('danger', $file.getExtension() + ' format is not supported. Please upload file having extensions ' + staffSmsConfig.allowedExcelExts.toString());
                timeline.isError = true;
            }
            if (timeline.isError) {
                $flow.cancel();
                return false;
            }
            $flow.opts.target = APP_CONFIG.apiPath + '/document/uploaddocument/TECHO/false';
        };

        staffSmsConfig.uploadFn = function ($files, $event, $flow, timeline) {
            if (!timeline.isError) {
                Mask.show();
                AuthenticateService.refreshAccessToken().then(function () {
                    $flow.opts.headers.Authorization = 'Bearer ' + AuthenticateService.getToken();
                    timeline.flow = ($flow);
                    $flow.upload();
                    staffSmsConfig.isUploading = true;
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {

                });
            }
        };

        staffSmsConfig.getUploadResponse = function ($file, $message, $flow, timeline) {
            staffSmsConfig.isUploading = false;
            staffSmsConfig.fileUploaded = true;
            timeline.mediaName = JSON.parse($message).id;
            timeline.originalMediaName = $file.name;
            timeline.fileName = JSON.parse($message).fileName;
            staffSmsConfig.noFileUploaded = false;
            Mask.hide();
        };

        staffSmsConfig.fileError = function ($file, $message) {
            staffSmsConfig.fileUploaded = false;
            staffSmsConfig.isUploading = false;
            toaster.pop('danger', 'Error in file upload.');
            Mask.hide();
        };

        staffSmsConfig.removeFile = function (timeline) {
            if (staffSmsConfig.updateMode == true && (staffSmsConfig.updateTriggerType == 'immediately' || staffSmsConfig.updateStatus == 'SENT')) {
                return false;
            }
            if (timeline.mediaName) {
                staffSmsConfig.isRemove = true;
                StaffSmsConfigDAO.removeFile(timeline.mediaName)
                    .then(function () {
                        if (!!timeline.flow && !!timeline.flow.files) {
                            timeline.flow.files = [];
                        }
                        timeline.mediaName = undefined;
                        timeline.originalMediaName = undefined;
                        staffSmsConfig.fileUploaded = false;
                        staffSmsConfig.excelError = '';
                    }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                        Mask.hide();
                        staffSmsConfig.isRemove = false;
                    });
            }
        };

        initPage();

    }
    angular.module('imtecho.controllers').controller('ManageStaffSmsConfigController', ManageStaffSmsConfigController);
})();
