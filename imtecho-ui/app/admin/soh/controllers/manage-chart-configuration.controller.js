(function (angular) {
    function ManageSohChartConfiguration($state, Mask, toaster, GeneralUtil, SohElementConfigurationDAO, AuthenticateService, $q) {
        let ctrl = this;
        ctrl.isEditMode = false;
        ctrl.chartId = $state.params.id ? Number($state.params.id) : null;
        ctrl.configurationArray = [];
        ctrl.today = new Date();

        const _fetchElementById = function () {
            Mask.show();
            AuthenticateService.getAssignedFeature("techo.manage.sohElementConfiguration").then(function (res) {
                ctrl.rights = res.featureJson;
                if (ctrl.rights.normal || ctrl.rights.advanced) {
                    let promises = [];
                    promises.push(SohElementConfigurationDAO.getChartById(ctrl.chartId));
                    promises.push(SohElementConfigurationDAO.getElementModules(true));
                    promises.push(AuthenticateService.getLoggedInUser());
                    $q.all(promises).then(function (responses) {
                        ctrl.chartObj = responses[0];
                        ctrl.elementModuleList = responses[1];
                        ctrl.loggedInUser = responses[2].data;
                        try {
                            ctrl.configurationArray = ctrl.chartObj.configurationJson ? JSON.parse(ctrl.chartObj.configurationJson) : [];
                        } catch (error) {
                            console.log('Error while parsing configurationJson JSON :: ', error);
                            ctrl.configurationArray = [];
                        }
                    }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide);
                } else {
                    toaster.pop('error', 'You don\'t have rights to access this page.');
                    Mask.hide();
                }
            }, function () {
                GeneralUtil.showMessageOnApiCallFailure();
                Mask.hide();
            });
        }

        const _init = function () {
            if (ctrl.chartId) {
                ctrl.isEditMode = true;
                _fetchElementById();
            } else {
                Mask.show();
                AuthenticateService.getAssignedFeature("techo.manage.sohElementConfiguration").then(function (res) {
                    ctrl.rights = res.featureJson;
                    if (ctrl.rights.advanced) {
                        let promises = [];
                        promises.push(SohElementConfigurationDAO.getElementModules(true));
                        promises.push(AuthenticateService.getLoggedInUser());
                        $q.all(promises).then(function (responses) {
                            ctrl.elementModuleList = responses[0];
                            ctrl.loggedInUser = responses[1].data;
                        }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide);
                    } else {
                        toaster.pop('error', 'You don\'t have rights to access this page.');
                        Mask.hide();
                    }
                }, function () {
                    GeneralUtil.showMessageOnApiCallFailure();
                    Mask.hide();
                });
            }
        };

        let _preparePayload = function () {
            ctrl.payload = {
                id: ctrl.chartId,
                name: ctrl.chartObj.name,
                module: ctrl.chartObj.module,
                displayName: ctrl.chartObj.displayName,
                queryName: ctrl.chartObj.queryName,
                chartType: ctrl.chartObj.chartType,
                chartOrder: ctrl.chartObj.chartOrder,
                fromDate: ctrl.chartObj.fromDate,
                toDate: ctrl.chartObj.toDate,
                configurationJson: ctrl.configurationArray ? JSON.stringify(ctrl.configurationArray) : null,
                modifiedBy: ctrl.loggedInUser.id,
                modifiedOn: moment().utcOffset('+05:30').format()
            };
        }

        ctrl.addOrEditChartDetails = function () {
            ctrl.manageSohChartConfigurationForm.$setSubmitted();
            if (ctrl.manageSohChartConfigurationForm.$valid) {
                Mask.show();
                _preparePayload();
                if (!ctrl.isEditMode) {
                    ctrl.payload.createdBy = ctrl.loggedInUser.id;
                    ctrl.payload.createdOn = moment().utcOffset('+05:30').format();
                } else {
                    ctrl.payload.createdBy = ctrl.chartObj.createdBy;
                    ctrl.payload.createdOn = ctrl.chartObj.createdOn;
                }
                SohElementConfigurationDAO.createOrUpdateChart(ctrl.payload).then(function () {
                    if (ctrl.isEditMode) {
                        toaster.pop('success', 'Chart Edited Successfully!');
                    } else {
                        toaster.pop('success', 'Chart Added Successfully!');
                    }
                    $state.go('techo.manage.sohElementConfiguration', { selectedTab: 1 });
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                });
            }
        }

        ctrl.addConfigurationObj = function () {
            ctrl.configurationArray.push({
                elementName: '',
                displayName: '',
                module: '',
                color: '',
                fields: [{
                    name: '',
                    field: '',
                    type: 'x'
                }, {
                    name: '',
                    field: '',
                    type: 'y'
                }]
            });
        }

        ctrl.removeConfigurationObj = function (index) {
            ctrl.configurationArray.splice(index, 1);
        }

        ctrl.addConfigurationFieldObj = function (parentIndex) {
            ctrl.configurationArray[parentIndex].fields.push({
                name: '',
                field: '',
                type: 'other'
            });
        }

        ctrl.removeConfigurationFieldObj = function (index, parentIndex) {
            if (['x', 'y'].includes(ctrl.configurationArray[parentIndex].fields[index].type)) {
                toaster.pop('danger', 'You could not remove field of x axis or y axis.');
                return;
            }
            ctrl.configurationArray[parentIndex].fields.splice(index, 1);
        }

        _init();

    }
    angular.module('imtecho.controllers').controller('ManageSohChartConfiguration', ManageSohChartConfiguration);
})(window.angular);
