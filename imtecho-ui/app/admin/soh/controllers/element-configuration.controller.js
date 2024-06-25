(function (angular) {
    function SohElementConfiguration(Mask, toaster, QueryDAO, GeneralUtil, SohElementConfigurationDAO, AuthenticateService, $uibModal, $q, $state,RoleDAO) {
        let ctrl = this;

        ctrl.fetchElements = function (initMode) {
            $state.go('.', { selectedTab: ctrl.selectedTab }, { notify: false });
            let promises = [];
            promises.push(SohElementConfigurationDAO.getElements());
            if (initMode) {
                promises.push(AuthenticateService.getAssignedFeature("techo.manage.sohElementConfiguration"));
                promises.push(QueryDAO.execute({
                    code: 'retrieve_system_configuration_by_key',
                    parameters: {
                        key: 'SOH_MAINTENANCE_MODE_ENABLE'
                    }
                }));
            }
            Mask.show();
            $q.all(promises).then(function (results) {
                ctrl.elements = results[0];
                if (initMode) {
                    ctrl.rights = results[1].featureJson;
                    ctrl.isMaintenanceModeEnabled = results[2].result[0] && results[2].result[0].value ? results[2].result[0].value === 'true' : false;
                }
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        }

        ctrl.fetchCharts = function (initMode) {
            $state.go('.', { selectedTab: ctrl.selectedTab }, { notify: false });
            let promises = [];
            promises.push(SohElementConfigurationDAO.getCharts());
            if (initMode) {
                promises.push(AuthenticateService.getAssignedFeature("techo.manage.sohElementConfiguration"));
                promises.push(QueryDAO.execute({
                    code: 'retrieve_system_configuration_by_key',
                    parameters: {
                        key: 'SOH_MAINTENANCE_MODE_ENABLE'
                    }
                }));
            }
            Mask.show();
            $q.all(promises).then(function (results) {
                ctrl.charts = results[0];
                if (initMode) {
                    ctrl.rights = results[1].featureJson;
                    ctrl.isMaintenanceModeEnabled = results[2].result[0] && results[2].result[0].value ? results[2].result[0].value === 'true' : false;
                }
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        }

        ctrl.fetchElementModules = function (initMode) {
            $state.go('.', { selectedTab: ctrl.selectedTab }, { notify: false });
            let promises = [];
            promises.push(SohElementConfigurationDAO.getElementModules(false));
            if (initMode) {
                promises.push(AuthenticateService.getAssignedFeature("techo.manage.sohElementConfiguration"));
                promises.push(QueryDAO.execute({
                    code: 'retrieve_system_configuration_by_key',
                    parameters: {
                        key: 'SOH_MAINTENANCE_MODE_ENABLE'
                    }
                }));
            }
            Mask.show();
            $q.all(promises).then(function (results) {
                ctrl.elementModules = results[0];
                if (initMode) {
                    ctrl.rights = results[1].featureJson;
                    ctrl.isMaintenanceModeEnabled = results[2].result[0] && results[2].result[0].value ? results[2].result[0].value === 'true' : false;
                }
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        }

        ctrl.fetchLocationTypes = function(){
            Mask.show();
            QueryDAO.execute({
                code: 'fetch_all_types_of_location'
            }).then(function (res) {
                ctrl.typesList = res.result;
                ctrl.fetchLocationUser();
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        }

        ctrl.fetchLocationUser =  function(){
            Mask.show();
            QueryDAO.execute({
                code: 'fetch_soh_location_type_role_mapping'
            }).then(function (res) {
                ctrl.locationWiseUser = res.result;
                ctrl.typesList.forEach(ltype => {
                    let roles = res.result.filter(location => {
                        return location.location_type === ltype.type;
                    }).map(result=>{
                        return {
                            id: result.role_id,
                            name : result.name
                        };
                    });
                    if(roles){
                        ltype.roles = roles.map(role => role.name).join(', ');
                        ltype.ids = roles.map(role => role.id).join(',');
                    }else {
                        ltype.roles = null;
                    }
                })
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        }

        ctrl.selectedtType  = function(location){
            console.log(location);
            Mask.show();
            QueryDAO.execute({
                code: 'set_soh_enbale_in_location_type',
                parameters : {
                    type : location.type,
                    is_soh_enable: location.is_soh_enable
                }
            }).then(function (res) {
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        }

        ctrl.openRoleModel = function(location){
            console.log(ctrl.allDesignation);
            let modalInstance = $uibModal.open({
                templateUrl: 'app/admin/soh/views/select-roles-modal.html',
                windowClass: 'cst-modal',
                size: 'lg',
                controller: function ($scope, allDesignation, $uibModalInstance) {
                    $scope.allDesignation = allDesignation;
                    let selectedRoles = location.ids ? location.ids.split(",").map(Number) : null;
                    $scope.selectedRoleIds = selectedRoles ? selectedRoles : [];
                    $scope.ok = function () {
                        Mask.show();
                        let code ;
                        let params;
                        if($scope.selectedRoleIds.length > 0){
                            code = 'insert_soh_location_type_role_mapping';
                            params = {
                                location_type: location.type,
                                role_ids: "{"+ $scope.selectedRoleIds.toString() + "}"
                            }
                        } else {
                            code = 'delete_soh_location_user_by_type'
                            params = {
                                location_type: location.type,
                            }
                        }
                        QueryDAO.execute({
                            code: code,
                            parameters: params
                        }).then(function () {
                            $uibModalInstance.close();
                            toaster.pop('success', 'Location wise roles details saved successfully.');
                            ctrl.fetchLocationTypes();
                        }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                            Mask.hide();
                            $uibModalInstance.close();
                        });
                    }
                    $scope.cancel = function () {
                        $uibModalInstance.dismiss();
                    }
                },
                resolve: {
                    allDesignation: function () {
                        return ctrl.allDesignation
                    }
                }
            });
            modalInstance.result
                .then(function () { }, function () { })
        }

        ctrl.fetchRolesDetails = function () {
            var roleList = [];
            Mask.show();
            var rolePromise = RoleDAO.retireveAll(true).then(function (data) {
                return data;
            }, GeneralUtil.showMessageOnApiCallFailure);
            $q.all([rolePromise]).then(function (data) {
                roleList = data[0];
                _.each(roleList, function (userGroup) {
                    userGroup.enabled = true;
                });
                ctrl.allDesignation = angular.copy(roleList);
                angular.forEach(roleList, function (designation) {
                    designation.enabled = true;
                });
            }).finally(function () {
                Mask.hide();
            });
        }

        const _init = function () {
            ctrl.fetchRolesDetails();
            if ($state.params.selectedTab) {
                ctrl.selectedTab = Number($state.params.selectedTab);
            } else {
                ctrl.selectedTab = 0;
            }
            switch (ctrl.selectedTab) {
                case 0:
                default:
                    ctrl.fetchElements(true);
                    break;
                case 1:
                    ctrl.fetchCharts(true);
                    break;
                case 2:
                    ctrl.fetchElementModules(true);
                    break;
            }
        };

        ctrl.showElementDetails = function (elementObj) {
            let modalInstance = $uibModal.open({
                templateUrl: 'app/admin/soh/views/element-details-modal.html',
                windowClass: 'cst-modal',
                size: 'md',
                controller: function ($scope, element, $uibModalInstance) {
                    $scope.element = element;
                    try {
                        $scope.elementTabs = typeof $scope.element.tabsJson === 'string' ? JSON.parse($scope.element.tabsJson) : $scope.element.tabsJson;
                    } catch (error) {
                        console.log('Error while parsing JSON :: ', $scope.element.tabsJson);
                        $scope.elementTabs = [];
                    }
                    $scope.ok = function () {
                        $uibModalInstance.close();
                    }
                    $scope.cancel = function () {
                        $uibModalInstance.dismiss();
                    }
                },
                resolve: {
                    element: function () {
                        return elementObj
                    }
                }
            });
            modalInstance.result
                .then(function () { }, function () { })
        }

        ctrl.updateMaintenanceMode = function () {
            Mask.show();
            QueryDAO.execute({
                code: 'update_system_configuration_by_key',
                parameters: {
                    key: 'SOH_MAINTENANCE_MODE_ENABLE',
                    value: ctrl.isMaintenanceModeEnabled,
                    isActive: true
                }
            }).then(function () {
                toaster.pop('success', `SOH maintenance mode ${ctrl.isMaintenanceModeEnabled ? 'enabled' : 'disabled'} successfully.`);
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        }

        ctrl.addConfig = function () {
            switch (ctrl.selectedTab) {
                case 0:
                default:
                    $state.go('techo.manage.manageSohElementConfiguration');
                    break;
                case 1:
                    $state.go('techo.manage.manageSohChartConfiguration');
                    break;
                case 2:
                    $state.go('techo.manage.manageSohElementModuleConfiguration');
                    break;
            }
        }

        _init();
    }
    angular.module('imtecho.controllers').controller('SohElementConfiguration', SohElementConfiguration);
})(window.angular);
