(function (angular) {
    function ManagePushNotificationController($state, Mask, toaster, RoleDAO, QueryDAO, GeneralUtil, AuthenticateService, UserDAO, TriggerTypes, PushNotificationDAO) {
        let ctrl = this;
        ctrl.selectedLocationsId;
        ctrl.userObj = {};
        ctrl.triggerTypesList = TriggerTypes;
        ctrl.hstep = 1;
        ctrl.mstep = 1;
        ctrl.ismeridian = false;
        ctrl.showspinners = false;
        ctrl.dateAndTimeConf = {
            fieldName: 'dateNTime'
        }
        ctrl.today = new Date();
        ctrl.noLocationSelected = false;
        ctrl.deletedLocations = [];

        ctrl.init = () => {
            ctrl.getTypeList();
            ctrl.retrieveQueryMasters();
            ctrl.selectedLocationsId = [];
            ctrl.userObj = {}
            if ($state.params.id) {
                ctrl.id = $state.params.id;
                ctrl.updateMode = true;
                ctrl.headerText = "Update Push Notification";
                ctrl.getNotificationConfig();
            } else {
                ctrl.headerText = "Add Push Notification";
                ctrl.configType = "ROLE_LOCATION_BASED";
            }
            AuthenticateService.getAssignedFeature("techo.manage.pushnotification").then(function (res) {
                ctrl.rights = res.featureJson;
                if (!ctrl.rights) {
                    ctrl.rights = {};
                }
                ctrl.getAllActiveRoles();
            });

        }
        ctrl.getNotificationConfig = () => {
            PushNotificationDAO.getNotificationConfigById(ctrl.id).then(function (res) {
                ctrl.name = res.name;
                ctrl.description = res.description;
                ctrl.notificationTypeId = res.notificationTypeId;
                ctrl.triggerType = res.triggerType;
                ctrl.configType = res.configType;
                ctrl.queryUUID = res.queryUUID;
                ctrl.updateTriggerType = res.triggerType;
                ctrl.updateStatus = res.status;

                if (res.triggerType == 'SCHEDULE_TIME') {
                    ctrl.date = new Date(res.dateTime);
                    ctrl.time = new Date(res.dateTime);
                }
                if (res.roles.length > 0) {
                    ctrl.userObj.roleId = res.roles.map((role) => {
                        return role.roleId;
                    });
                }
                if (res.locations.length > 0) {
                    ctrl.selectedLocationsId = res.locations;
                }
            });
        };

        ctrl.getTypeList = () => {
            if (!ctrl.typeList || ctrl.typeList.length < 0) {
                PushNotificationDAO.getNotificationTypeList().then(function (res) {
                    ctrl.typeList = res;
                    ctrl.typeList = ctrl.typeList.filter((type) => {
                        return type.isActive;
                    });
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                });
            }
        }

        ctrl.getAllActiveRoles = function () {
            Mask.show();
            RoleDAO.retieveRolesByRoleId(ctrl.rights.isAdmin).then(function (res) {
                ctrl.roleList = res;
            }).finally(function () {
                Mask.hide();
            });
        };

        ctrl.timeChanged = function () {
            if (ctrl.invalidTime && ctrl.invalidTime === true && ctrl.time && ctrl.time != "") {
                ctrl.invalidTime = false;
            }
        }

        ctrl.selectedArea = function () {
            ctrl.locationForm.$setSubmitted();
            if (ctrl.selectedLocation.finalSelected !== null) {
                let selectedobj;
                if (ctrl.selectedLocation.finalSelected.optionSelected) {
                    selectedobj = {
                        locationId: ctrl.selectedLocation.finalSelected.optionSelected.id,
                        type: ctrl.selectedLocation.finalSelected.optionSelected.type,
                        level: ctrl.selectedLocation.finalSelected.level,
                        name: ctrl.selectedLocation.finalSelected.optionSelected.name

                    };
                } else {
                    selectedobj = {
                        locationId: ctrl.selectedLocation["level" + (ctrl.selectedLocation.finalSelected.level - 1)].id,
                        type: ctrl.selectedLocation["level" + (ctrl.selectedLocation.finalSelected.level - 1)].type,
                        level: ctrl.selectedLocation.finalSelected.level - 1,
                        name: ctrl.selectedLocation["level" + (ctrl.selectedLocation.finalSelected.level - 1)].name

                    };
                }
                ctrl.duplicateEntry = false;
                for (let i = 0; i < ctrl.selectedLocationsId.length; i++) {
                    if (ctrl.selectedLocationsId[i].locationId === selectedobj.locationId) {
                        ctrl.duplicateEntry = true;
                        ctrl.isLocationButtonDisabled = false;
                    }
                }
                if (!ctrl.duplicateEntry) {
                    ctrl.isNotAllowedLocation = false;
                    if (!ctrl.selectedLocationsId) {
                        ctrl.selectedLocationsId = [];
                    }
                    var itteratingLevel = 1,
                        locationFullName = '';
                    while (itteratingLevel < ctrl.selectedLocation.finalSelected.level) {
                        if (ctrl.selectedLocation['level' + itteratingLevel]) {
                            locationFullName = locationFullName.concat(ctrl.selectedLocation['level' + itteratingLevel].name + ',');
                        }
                        itteratingLevel = itteratingLevel + 1;
                    }
                    if (ctrl.selectedLocation.finalSelected.optionSelected) {
                        locationFullName = locationFullName.concat(ctrl.selectedLocation.finalSelected.optionSelected.name);
                    } else {
                        locationFullName = locationFullName.substring(0, locationFullName.length - 1);
                    }
                    selectedobj.locationFullName = locationFullName;

                    var selectedLocationIds = _.pluck(ctrl.selectedLocationsId, "locationId");
                    ctrl.isLocationButtonDisabled = true;
                    UserDAO.validateaoi(ctrl.userObj.roleId, selectedLocationIds, selectedobj.locationId, ctrl.userObj.id).then(function (res) {
                        if (res.errorcode === 2) {
                            if (!res.data) {
                                ctrl.errorMsg = res.message;
                                ctrl.errorCode = res.errorcode;
                                return
                            }
                        }
                        ctrl.selectedLocationsId.push(selectedobj);
                        delete ctrl.errorMsg;
                        delete ctrl.errorCode;
                        if (ctrl.selectedLocationsId.length > 0) {
                            ctrl.noLocationSelected = false;
                        }
                    }, GeneralUtil.showMessageOnApiCallFailure)
                        .finally(function () {
                            ctrl.isLocationButtonDisabled = false;
                        });
                }
            }
        };

        ctrl.removeSelectedArea = function (removedLoc, index) {
            ctrl.deletedLocations.push(removedLoc);
            ctrl.selectedLocationsId.splice(index, 1);
            if (ctrl.selectedLocationsId.length <= 0) {
                ctrl.noLocationSelected = true;
            }
        };

        ctrl.saveOrUpdate = function (form) {
            if (ctrl.configType == 'ROLE_LOCATION_BASED' && ctrl.selectedLocationsId.length <= 0) {
                ctrl.noLocationSelected = true;
                return;
            }

            if (form.$valid) {
                ctrl.notificationObj = {};
                ctrl.notificationObj.name = ctrl.name;
                ctrl.notificationObj.description = ctrl.description;
                ctrl.notificationObj.notificationTypeId = ctrl.notificationTypeId;
                ctrl.notificationObj.triggerType = ctrl.triggerType;
                ctrl.notificationObj.configType = ctrl.configType;
                ctrl.notificationObj.userObj = ctrl.userObj;
                ctrl.notificationObj.queryUUID = ctrl.queryUUID;

                let date = new Date(Date.parse(ctrl.date));
                var dateNTime = new Date();
                if (ctrl.updateMode) {
                    dateNTime = new Date(ctrl.date);
                }
                if (ctrl.triggerType == 'SCHEDULE_TIME') {
                    if (!ctrl.time || ctrl.time == "") {
                        ctrl.invalidTime = true;
                        return;
                    }
                    if (!ctrl.updateMode || (ctrl.updateMode && dateNTime != ctrl.date)) {
                        dateNTime.setDate(date.getDate());
                        dateNTime.setMonth(date.getMonth());
                        dateNTime.setFullYear(date.getFullYear());
                        dateNTime.setHours(ctrl.time.getHours());
                        dateNTime.setMinutes(ctrl.time.getMinutes());
                        dateNTime.setSeconds(0);
                    }

                }

                if (ctrl.updateMode) {
                    ctrl.notificationObj.id = ctrl.id;
                }
                ctrl.notificationObj.dateTime = dateNTime;

                if (ctrl.configType == 'ROLE_LOCATION_BASED') {
                    ctrl.notificationObj.locations = ctrl.selectedLocationsId;
                    ctrl.notificationObj.roles = ctrl.userObj.roleId.map((role) => { return { roleId: role } });
                }
                Mask.show();
                PushNotificationDAO.createOrUpdateConfig(ctrl.notificationObj).then((data) => {

                    ctrl.chagneState();
                    toaster.pop('success', 'Push Notification Configuration added successfully');
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(function () {
                    Mask.hide();
                });

            } else if (!form.$valid && ctrl.triggerType == 'SCHEDULE_TIME' && (!ctrl.time)) {
                ctrl.invalidTime = true;
                return;
            }
        };

        ctrl.chagneState = () => {
            $state.go("techo.manage.pushnotification");
        }

        ctrl.onConfigTypeChange = () => {
            ctrl.retrieveQueryMasters();
        };

        ctrl.retrieveQueryMasters = () => {
            if (!ctrl.queryMasters || ctrl.queryMasters.length < 0) {
                Mask.show();
                return QueryDAO.retrieveAllConfigured(true).then(function (res) {
                    ctrl.queryMasters = res;
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                });
            }
        };

        ctrl.init();
    }
    angular.module('imtecho.controllers').controller('ManagePushNotificationController', ManagePushNotificationController
    );
})(window.angular);
