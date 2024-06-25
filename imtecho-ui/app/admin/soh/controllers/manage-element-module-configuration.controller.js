(function (angular) {
    function ManageSohElementModuleConfiguration($state, Mask, toaster, GeneralUtil, SohElementConfigurationDAO, AuthenticateService, $q) {
        let ctrl = this;
        ctrl.isEditMode = false;
        ctrl.elementModuleId = $state.params.id ? Number($state.params.id) : null;
        ctrl.elementModuleObj = {};

        const _fetchElementModuleById = function () {
            Mask.show();
            AuthenticateService.getAssignedFeature("techo.manage.sohElementConfiguration").then(function (res) {
                ctrl.rights = res.featureJson;
                if (ctrl.rights.normal || ctrl.rights.advanced) {
                    let promises = [];
                    promises.push(SohElementConfigurationDAO.getElementModuleById(ctrl.elementModuleId));
                    $q.all(promises).then(function (responses) {
                        ctrl.elementModuleObj = responses[0];
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
            if (ctrl.elementModuleId) {
                ctrl.isEditMode = true;
                _fetchElementModuleById();
            } else {
                Mask.show();
                AuthenticateService.getAssignedFeature("techo.manage.sohElementConfiguration").then(function (res) {
                    ctrl.rights = res.featureJson;
                    if (!ctrl.rights.advanced) {
                        toaster.pop('error', 'You don\'t have rights to access this page.');
                    }
                }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide);
            }
        };

        let _preparePayload = function () {
            ctrl.payload = {
                id: ctrl.elementModuleId,
                module: ctrl.elementModuleObj.module,
                moduleName: ctrl.elementModuleObj.moduleName,
                isPublic: ctrl.elementModuleObj.isPublic,
                moduleOrder: ctrl.elementModuleObj.moduleOrder,
                state: ctrl.elementModuleObj.state,
                footerDescription: ctrl.elementModuleObj.footerDescription
            };
        }

        ctrl.addOrEditElementModuleDetails = function () {
            ctrl.manageSohElementModuleConfigurationForm.$setSubmitted();
            if (ctrl.manageSohElementModuleConfigurationForm.$valid) {
                Mask.show();
                _preparePayload();
                if (ctrl.isEditMode) {
                    ctrl.payload.createdBy = ctrl.elementModuleObj.createdBy;
                    ctrl.payload.createdOn = ctrl.elementModuleObj.createdOn;
                }
                SohElementConfigurationDAO.createOrUpdateElementModule(ctrl.payload).then(function () {
                    if (ctrl.isEditMode) {
                        toaster.pop('success', 'Element Module edited successfully!');
                    } else {
                        toaster.pop('success', 'Element Module added successfully!');
                    }
                    $state.go('techo.manage.sohElementConfiguration', { selectedTab: 2 });
                }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide);
            }
        }

        _init();

    }
    angular.module('imtecho.controllers').controller('ManageSohElementModuleConfiguration', ManageSohElementModuleConfiguration);
})(window.angular);
