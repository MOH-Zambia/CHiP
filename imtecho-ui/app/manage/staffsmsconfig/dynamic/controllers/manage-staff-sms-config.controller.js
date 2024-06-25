(function () {
    function ManageStaffSmsConfigController(toaster, APP_CONFIG, StaffSmsConfigDAO, RoleDAO, UserDAO, Mask, AuthenticateService, GeneralUtil, $state, $q, $filter) {
        let ctrl = this;
        const FEATURE = 'techo.manage.staffsmsconfigs';
        const STAFF_SMS_FORM_CONFIGURATION_KEY = 'STAFF_SMS_CONFIG';
        ctrl.formData = {
            roleId: [],
            selectedLocationsId: [],
            upload: {},
            downloadSampleFile: '(Download Sample File)'
        };
        ctrl.today = moment().startOf('day');

        ctrl.init = () => {
            let promiseList = [];
            promiseList.push(AuthenticateService.getLoggedInUser());
            promiseList.push(AuthenticateService.getAssignedFeature("techo.manage.users"));
            Mask.show();
            $q.all(promiseList).then((response) => {
                ctrl.loggedInUser = response[0].data;
                ctrl.rights = response[1].featureJson;
                if (!ctrl.rights) {
                    ctrl.rights = {};
                }
                return RoleDAO.retieveRolesByRoleId(ctrl.rights.isAdmin);
            }).then((response) => {
                ctrl.roleList = response;
                if ($state.params.id) {
                    ctrl.updateMode = true;
                    $state.current.title = ctrl.cardTitle = 'Update Staff SMS Configuration';
                    Mask.show();
                    StaffSmsConfigDAO.retrieveById($state.params.id).then((response) => {
                        Object.assign(ctrl.formData, {
                            ...ctrl.formData,
                            id: response.id,
                            name: response.name,
                            description: response.description,
                            templateId: response.templateId,
                            triggerType: response.triggerType,
                            date: response.dateTime != null ? new Date(response.dateTime) : null,
                            time: response.dateTime != null ? new Date($filter('date')(new Date(response.dateTime), 'yyyy-MM-dd HH:mm')) : null,
                            configurationType: response.configType,
                            template: response.smsTemplate
                        });
                        if (Array.isArray(response.roles) && response.roles.length) {
                            ctrl.formData.roleId = response.roles.map(role => role.roleId);
                        }
                        if (Array.isArray(response.locations) && response.locations.length) {
                            ctrl.formData.selectedLocationsId = response.locations;
                        }
                        if (ctrl.formData.configurationType === 'EXCEL_BASED') {
                            ctrl.formData.upload.mediaName = response.documentId;
                            StaffSmsConfigDAO.getDocumentDetail(response.documentId).then((media) => {
                                ctrl.formData.upload.fileName = media.fileName;
                                ctrl.formData.upload.originalMediaName = media.actualFileName;
                            }).catch((error) => {
                                GeneralUtil.showMessageOnApiCallFailure(error);
                                $state.go('techo.manage.staffsmsconfigs');
                            });
                        }
                        ctrl.updateStatus = response.status;
                        ctrl.createdByUser = ctrl.loggedInUser.id == response.createdBy;
                    }).catch((error) => {
                        GeneralUtil.showMessageOnApiCallFailure(error);
                        $state.go('techo.manage.staffsmsconfigs');
                    }).finally(() => {
                        Mask.hide();
                    });
                } else {
                    ctrl.updateMode = false;
                    $state.current.title = ctrl.cardTitle = 'Add Staff SMS Configuration';
                    ctrl.formData.configurationType = 'ROLE_LOCATION_BASED';
                }
                return AuthenticateService.getAssignedFeature(FEATURE);
            }).then((response) => {
                ctrl.formConfigurations = response.systemConstraintConfigs[STAFF_SMS_FORM_CONFIGURATION_KEY];
                ctrl.webTemplateConfigs = response.webTemplateConfigs[STAFF_SMS_FORM_CONFIGURATION_KEY];
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
                $state.go('techo.manage.staffsmsconfigs');
            }).finally(() => {
                Mask.hide();
            });
        }

        ctrl.onAllComponentsLoaded = () => {
            if (Array.isArray(ctrl.roleList) && ctrl.roleList.length && 'roleIdList' in ctrl.formData) {
                ctrl.formData.roleIdList.data = ctrl.transformArrayToKeyValue(ctrl.roleList, 'id', 'name');
            }
        }

        ctrl.triggerTypeChanged = () => {
            ctrl.formData.date = null;
            ctrl.formData.time = null;
        }

        ctrl.timeChanged = (_, uuid) => {
            ctrl.timeUuid = uuid;
            ctrl.checkTimeValidity();
        }

        ctrl.configurationTypeChanged = () => {
            ctrl.formData.roleId = [];
            ctrl.selectedLocation = {};
            ctrl.formData.selectedLocationsId = [];
            ctrl.formData.upload = {};
            delete ctrl.errorMsg;
            delete ctrl.errorCode;
        }

        ctrl.addLocation = () => {
            if (ctrl.selectedLocation.finalSelected !== null) {
                let selectedobj;
                if (ctrl.selectedLocation.finalSelected.optionSelected) {
                    selectedobj = {
                        locationId: ctrl.selectedLocation.finalSelected.optionSelected.id,
                        type: ctrl.selectedLocation.finalSelected.optionSelected.type,
                        level: ctrl.selectedLocation.finalSelected.level,
                        name: ctrl.selectedLocation.finalSelected.optionSelected.name

                    }
                } else {
                    selectedobj = {
                        locationId: ctrl.selectedLocation["level" + (ctrl.selectedLocation.finalSelected.level - 1)].id,
                        type: ctrl.selectedLocation["level" + (ctrl.selectedLocation.finalSelected.level - 1)].type,
                        level: ctrl.selectedLocation.finalSelected.level - 1,
                        name: ctrl.selectedLocation["level" + (ctrl.selectedLocation.finalSelected.level - 1)].name
                    }
                }
                if (!Array.isArray(ctrl.formData.selectedLocationsId)) {
                    ctrl.formData.selectedLocationsId = [];
                }
                let iteratingLevel = 1;
                let locationFullName = '';
                while (iteratingLevel < ctrl.selectedLocation.finalSelected.level) {
                    if (ctrl.selectedLocation['level' + iteratingLevel]) {
                        locationFullName = locationFullName.length ? locationFullName.concat(` -> ${ctrl.selectedLocation['level' + iteratingLevel].name}`) : locationFullName.concat(ctrl.selectedLocation['level' + iteratingLevel].name);
                    }
                    iteratingLevel++;
                }
                if (ctrl.selectedLocation.finalSelected.optionSelected) {
                    locationFullName = locationFullName.length ? locationFullName.concat(` -> ${ctrl.selectedLocation.finalSelected.optionSelected.name}`) : locationFullName.concat(ctrl.selectedLocation.finalSelected.optionSelected.name);
                }
                selectedobj.locationFullName = locationFullName;
                let selectedLocationIds = _.pluck(ctrl.formData.selectedLocationsId, "locationId");
                Mask.show();
                UserDAO.validateaoi(ctrl.formData.roleId, selectedLocationIds, selectedobj.locationId, ctrl.loggedInUser.id).then((response) => {
                    if (response.errorcode === 2 && !response.data) {
                        ctrl.errorMsg = response.message;
                        ctrl.errorCode = response.errorcode;
                        return;
                    }
                    ctrl.formData.selectedLocationsId.push(selectedobj);
                    delete ctrl.errorMsg;
                    delete ctrl.errorCode;
                    if (ctrl.formData.selectedLocationsId.length) {
                        ctrl.noLocationSelected = false;
                    }
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                });
            }
        }

        ctrl.removeSelectedArea = (index) => {
            ctrl.formData.selectedLocationsId.splice(index, 1);
            if (ctrl.formData.selectedLocationsId.length <= 0) {
                ctrl.noLocationSelected = true;
            }
        };

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

        ctrl.upload = ($file, $event, $flow, media, fieldKey, allowedExtensions, type) => {
            let extensions = allowedExtensions.replace(/\s/g, '').split(',');
            ctrl.responseMessage = {};
            media.isError = false;
            if (extensions.indexOf($file.getExtension()) < 0) {
                toaster.pop('danger', `${$file.getExtension()} format is not supported. Please upload file having extension ${extensions.join()}`);
                media.isError = true;
            }
            if (media.isError) {
                $flow.cancel();
                return false;
            }
            $flow.opts.target = APP_CONFIG.apiPath + '/document/uploaddocument/TECHO/false';
        };

        ctrl.uploadFn = ($files, $event, $flow, media, type) => {
            if (!media.isError) {
                Mask.show();
                AuthenticateService.refreshAccessToken().then(() => {
                    $flow.opts.headers.Authorization = 'Bearer ' + AuthenticateService.getToken();
                    media.flow = ($flow);
                    $flow.upload();
                    ctrl.isUploading = true;
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error)
                }).finally(() => {
                    Mask.hide();
                });
            }
        };

        ctrl.getUploadResponse = ($file, $message, $flow, media, type) => {
            ctrl.isUploading = false;
            media.mediaName = JSON.parse($message).id;
            media.originalMediaName = $file.name;
        };

        ctrl.fileError = ($file, $message, media, type) => {
            media.flow.files = [];
            ctrl.isUploading = false;
            toaster.pop('danger', 'Error in file upload.');
        };

        ctrl.removeFile = (media, fieldKey) => {
            if (media.mediaName) {
                ctrl.isRemove = true;
                StaffSmsConfigDAO.removeFile(media.mediaName).then(() => {
                    if (!!media.flow && !!media.flow.files) {
                        media.flow.files = [];
                    }
                    media.mediaName = undefined;
                    media.originalMediaName = undefined;
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                    ctrl.isRemove = false;
                });
            }
        };

        ctrl.downloadSampleFile = (_, uuid) => {
            $(`a#${uuid}`).attr({
                target: '_blank',
                href: 'files/StaffSmsSampleExcel.xlsx'
            })
        }

        ctrl.saveOrUpdateStaffSmsConfig = () => {
            ctrl.staffSmsForm.$setSubmitted();
            if (ctrl.formData.configurationType == 'ROLE_LOCATION_BASED' && ctrl.formData.selectedLocationsId.length <= 0) {
                ctrl.noLocationSelected = true;
                return;
            }
            if (ctrl.formData.configurationType == 'EXCEL_BASED' && !ctrl.formData.upload.mediaName) {
                toaster.pop('error', 'Please upload excel file');
                return;
            }
            ctrl.checkTimeValidity();
            if (ctrl.staffSmsForm.$valid) {
                let smsStaffConfigDto = {
                    name: ctrl.formData.name,
                    description: ctrl.formData.description,
                    templateId: ctrl.formData.templateId,
                    type: ctrl.formData.name.toUpperCase().replaceAll(' ', '_'),
                    triggerType: ctrl.formData.triggerType,
                    dateTime: ctrl.formData.date && ctrl.formData.time ? new Date(
                        ctrl.formData.date.getFullYear(),
                        ctrl.formData.date.getMonth(),
                        ctrl.formData.date.getDate(),
                        ctrl.formData.time.getHours(),
                        ctrl.formData.time.getMinutes(),
                        ctrl.formData.time.getMilliseconds()
                    ) : null,
                    configType: ctrl.formData.configurationType,
                    smsTemplate: ctrl.formData.template,
                    roles: ctrl.formData.roleId.map((role) => {
                        return {
                            roleId: role
                        }
                    }),
                    locations: ctrl.formData.selectedLocationsId,
                    documentId: ctrl.formData.upload.mediaName
                }
                Mask.show();
                let promise;
                if (ctrl.formData.configurationType == 'ROLE_LOCATION_BASED') {
                    promise = StaffSmsConfigDAO.createOrUpdate(smsStaffConfigDto);
                } else if (ctrl.formData.configurationType === 'EXCEL_BASED') {
                    promise = StaffSmsConfigDAO.createOrUpdateExcelConf(smsStaffConfigDto);
                }
                promise.then(() => {
                    toaster.pop('success', 'Staff sms Configuration saved successfully');
                    $state.go('techo.manage.staffsmsconfigs');
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                });
            }
        };

        ctrl.checkTimeValidity = () => {
            if (ctrl.formData.date && ctrl.formData.time) {
                let dateAndTime = new Date(
                    ctrl.formData.date.getFullYear(),
                    ctrl.formData.date.getMonth(),
                    ctrl.formData.date.getDate(),
                    ctrl.formData.time.getHours(),
                    ctrl.formData.time.getMinutes(),
                    ctrl.formData.time.getMilliseconds()
                );
                ctrl.staffSmsForm[ctrl.timeUuid].$setValidity('Please enter valid time', dateAndTime > moment());
            }
        }

        ctrl.transformArrayToKeyValue = (array, keyProperty, valueProperty) => {
            return array.map((element) => {
                return {
                    key: element[keyProperty],
                    value: element[valueProperty]
                }
            });
        }

        ctrl.goBack = () => {
            $state.go('techo.manage.staffsmsconfigs');
        };

        ctrl.init();

    }
    angular.module('imtecho.controllers').controller('ManageStaffSmsConfigController', ManageStaffSmsConfigController);
})();
