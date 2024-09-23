
(function () {
    function BackendConfigurationController($scope, $uibModal, $uibModalInstance, toaster, config, QueryDAO, Mask, GeneralUtil) {

        $scope.getAllActiveEvents = () => {
            let dto = {
                code: 'get_form_submitted_events_list',
                parameters: {}
            };
            Mask.show();
            QueryDAO.execute(dto).then(function (res) {
                $scope.formSubmittedEvents = [];
                $scope.configuredEvents = res.result;
                $scope.configuredEvents.forEach(event => {
                    $scope.formSubmittedEvents.push({
                        key: event.uuid,
                        value: event.name
                    });
                });
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
                $scope.init();
            });
        }

        $scope.init = () => {
            $scope.backendConfiguration = config.queryConfig || [];
            $scope.configuredQueries = config.configuredQueries;
            $scope.fieldConfigs = config.fieldConfigs;
            $scope.getColumnArray = config.getColumnArray;
            $scope.queryBuilderListAll = [];
            $scope.queryBuilderMapAll = {};
            $scope.queryBuilderListWithParams = [];
            $scope.queryBuilderMapWithParams = {};
            $scope.queryBuilderMapWithParamsNested = {};
            $scope.fieldList = [];
            $scope.currentConfig = null;
            $scope.configMapForParamList = {};
            $scope.uniqueQueryCodeSet = new Set();
            $scope.showBackdropForSQLEdit = false;

            $scope.isEventResourceTrueInConfig = false;
            $scope.isEventResourceTrueInConfigObject = {};
            for (let topLevelConfig of $scope.backendConfiguration) {
                $scope.checkAndSetEventResource(topLevelConfig);
                if ($scope.isEventResourceTrueInConfig) {
                    break;
                }
            }

            $scope.generateListOfConfigs();

            for (let topLevelConfig of $scope.backendConfiguration) {
                $scope.processConfigOnInit(topLevelConfig);
                $scope.genareteUniqueQueryCode(topLevelConfig);
            }


            Object.keys($scope.fieldConfigs).forEach(field => {
                if (!['TABLE', 'INFORMATION_DISPLAY', 'INFORMATION_TEXT', 'CUSTOM_COMPONENT'].includes($scope.fieldConfigs[field].fieldType)) {
                    $scope.fieldList.push({
                        key: `${$scope.fieldConfigs[field].fieldKey}`,
                        value: `${$scope.fieldConfigs[field].fieldName} | ${$scope.fieldConfigs[field].fieldType}`
                    })
                }
            })            
        }

        $scope.addConfig = (backendConfiguration) => {
            backendConfiguration.push({
                "queryCode" : null,
                "hasLoop": null,
                "queryPath": null,
                "subQueries": [],
                "params": {},
                "isEventResource": null,
                "selected": false
            });
        }

        $scope.checkUniqueQueryCode = (currentConfig, queryCode) => {
            $scope.backendConfigurationForm.$setSubmitted();
            if ($scope.uniqueQueryCodeSet.has(queryCode)) {
                $scope.backendConfigurationForm.queryCode.$setValidity('duplicate', false);
                $scope.duplicateQueryCodeError = true;
            } else {
                $scope.backendConfigurationForm.queryCode.$setValidity('duplicate', true);
                $scope.duplicateQueryCodeError = false;
            }
        }

        $scope.paramConfigTypeChange = (config) => {
            if (config.hasOwnProperty('valueKey')) {
                delete config.valueKey;
            }
            if (config.hasOwnProperty('value')) {
                delete config.value;
            }
            if (config.hasOwnProperty('referenceQuery')) {
                delete config.referenceQuery;
            }
            if (config.hasOwnProperty('referenceParam')) {
                delete config.referenceParam;
            }
        }

        // $scope.moved = (backendConfiguration, backendConfig, index) => {
        //     console.log(backendConfiguration, backendConfig, index);
        //     if (index <= $scope.dropIndex && index > -1 && ($scope.dropIndex - index >= 0)) {
        //         backendConfiguration.splice(index, 1);
        //     } else {
        //         backendConfiguration.pop();
        //     }
        // }

        $scope.removeConfig = (config, current) => {
            let modalInstance = $uibModal.open({
                templateUrl: 'app/common/views/confirmation.modal.html',
                controller: 'ConfirmModalController',
                windowClass: 'cst-modal',
                size: 'med',
                resolve: {
                    message: function () {
                        return "Are you sure you want to remove this config?";
                    }
                }
            });
            modalInstance.result.then(function () {
                current.remove();
                if ($scope.currentConfig === config) {
                    $scope.currentConfig = null;
                }
            }, () => {
            });
        }

        $scope.editConfig = (config) => {
            if ($scope.currentConfig == config) {
                return;
            }
            $scope.backendConfigurationForm.$setSubmitted();
            if ($scope.backendConfigurationForm.$valid) {
                $scope.generateListOfConfigs();
                $scope.genareteUniqueQueryCode();
                $scope.configListForParams = $scope.configListForParams.filter(con => con.key !== config.queryCode);
                config.selected = true;
                $scope.currentConfig = config;
            } else {
                toaster.pop('error', 'Current config has errors!');
            }
        }

        $scope.$watch('currentConfig', function(newValue, oldValue) {
            if (newValue !== null && oldValue !== null && newValue !== undefined && oldValue !== undefined) {
                oldValue.selected = false;
                newValue.selected = true;
            }
        });


        $scope.startResize = (event) => {
            var startX = event.clientX;
            var leftPane = document.getElementById('table-list');
            var rightPane = document.getElementById('config-container');
            var startWidthLeft = leftPane.offsetWidth;
            var containerWidth = document.querySelector('.configuration-container').offsetWidth;
            var minLeftWidth = 400;
            var minRightWidth = containerWidth / 2;
            function mouseMoveHandler(e) {
                var newWidthLeft = startWidthLeft + (e.clientX - startX);
                if (newWidthLeft < minLeftWidth) {
                    newWidthLeft = minLeftWidth;
                } else if (newWidthLeft > containerWidth - minRightWidth) {
                    newWidthLeft = containerWidth - minRightWidth;
                }
                leftPane.style.flex = '0 0 ' + newWidthLeft + 'px';
                rightPane.style.flex = '1';
            }
            function mouseUpHandler() {
            document.removeEventListener('mousemove', mouseMoveHandler);
            document.removeEventListener('mouseup', mouseUpHandler);
            }
            document.addEventListener('mousemove', mouseMoveHandler);
            document.addEventListener('mouseup', mouseUpHandler);
        }

        $scope.processQueries = (queries) => {
            return queries.map(query => {
                delete query.selected;
                delete query.fetchedFromServer;
                if (query.subQueries && query.subQueries.length > 0) {
                    query.subQueries = $scope.processQueries(query.subQueries);
                }
                return query;
            });
        }

        $scope.showQueryDetails = (config) => {
            var modalInstance = $uibModal.open({
                templateUrl: 'app/admin/applicationmanagement/medplatformconfigurator/modals/form-vm/form-vm-query-details-modal.html',
                controller: 'FormVmQueryDetailsModalController',
                windowClass: 'cst-modal',
                size: 'lg',
                resolve: {
                    config: () => {
                        return {
                            queryObj: config,
                            queryBuilderMap: $scope.queryBuilderMapAll
                        }
                    }
                }
            });
            modalInstance.result.then(function () {
            }, function () {
            });
        }

        $scope.isEventResourceChanged = (currentConfig, isEventResource) => {
            if (isEventResource === false && $scope.isEventResourceTrueInConfigObject === currentConfig) {
                $scope.isEventResourceTrueInConfig = false;
                $scope.isEventResourceTrueInConfigObject = {};
                if (currentConfig.hasOwnProperty('eventUUID')) {
                    delete currentConfig.eventUUID;
                }
            }

            if (isEventResource === true) {
                $scope.isEventResourceTrueInConfig = true;
                $scope.isEventResourceTrueInConfigObject = currentConfig;
            }
        }


        $scope.checkAndSetEventResource = (config) => {
            if (config.isEventResource === true) {
                $scope.isEventResourceTrueInConfig = true;
                $scope.isEventResourceTrueInConfigObject = config;
                return;
            }
            if (Array.isArray(config.subQueries)) {
                for (let subQuery of config.subQueries) {
                    $scope.checkAndSetEventResource(subQuery);
                    if ($scope.isEventResourceTrueInConfig === true) {
                        return;
                    }
                }
            }
        }


        // $scope.stopInserted = (index) => {
        //     $scope.dropIndex = index;
        // }

        $scope.toggleFilter = function (calledFromInside = false) {
            // if (angular.element('.filter-div').hasClass('active')) {
            //     angular.element('body').css("overflow", "auto");
            // } else {
            //     angular.element('body').css("overflow", "hidden");
            // }
            if (calledFromInside) {
                $scope.showBackdropForSQLEdit = false;
            } else {
                $scope.showBackdropForSQLEdit = true;
            }
            angular.element('.cst-backdrop').fadeToggle();
            angular.element('.filter-div').toggleClass('active');
        };

        $scope.generateListOfConfigs = () => {
            function flattenQueries(queries) {
                let result = [];
                queries.forEach(query => {
                    result.push({
                        key: query.queryCode,
                        value: query.queryName
                    });
                    if (query.subQueries && query.subQueries.length > 0) {
                        result = result.concat(flattenQueries(query.subQueries));
                    }
                });
                return result;
            };
            $scope.configListForParams = flattenQueries($scope.backendConfiguration);
        };

        $scope.genareteUniqueQueryCode = (config) => {
            if (config) {
                $scope.uniqueQueryCodeSet.add(config.queryCode);
                if (Array.isArray(config.subQueries)) {
                    for (let subQuery of config.subQueries) {
                        $scope.genareteUniqueQueryCode(subQuery);
                    }
                }
            }
        };

        $scope.processConfigOnInit = (config) => {
            config.fetchedFromServer = true;
            if (config.query) {
                let availableColumns = $scope.extractWordsBetweenHashes(config.query);
                if (availableColumns) {
                    $scope.configMapForParamList[config.queryCode] = availableColumns;
                }
            }
            if (Array.isArray(config.subQueries)) {
                for (let subQuery of config.subQueries) {
                    $scope.processConfigOnInit(subQuery);
                }
            }
        }

        $scope.queryStringChanged = (currentConfig, query) => {
            let availableColumns = $scope.extractWordsBetweenHashes(query);
            if (availableColumns) {
                $scope.configMapForParamList[currentConfig.queryCode] = availableColumns;
            }
            
            if (currentConfig.params.length > 0) {
                let oldParams = JSON.parse(JSON.stringify(currentConfig.params));
                let paramList = availableColumns;
                let paramConfig = [];
                paramList.forEach(param => {
                    if (param.key !== 'loggedInUserId') {
                        paramConfig.push({
                            "key" : param.key,
                            "type": null,
                        });
                    }
                });
                let newParamConfigs = [];
                paramConfig.forEach(param => {
                    let configData = oldParams.filter(item => item.key === param.key);
                    if (configData && configData.length > 0) {
                        newParamConfigs.push(configData[0]);
                    } else {
                        newParamConfigs.push(param);
                    }
                });
                currentConfig.params = newParamConfigs;
            } else {
                let paramList = availableColumns
                let paramConfig = [];
                paramList.forEach(param => {
                    if (param.key !== 'loggedInUserId') {
                        paramConfig.push({
                            "key" : param.key,
                            "type": null,
                        });
                    }
                });
                currentConfig.params = paramConfig;
            }
        }

        $scope.extractWordsBetweenHashes = (query) => {
            const matches = new Set();
            const regex = /#(.*?)#/g;
            let match;
            while ((match = regex.exec(query)) !== null) {
                if (match[1]) {
                    matches.add(match[1]);
                }
            }
            let paramList = Array.from(matches);
            let response = [];
            paramList.forEach(param => {
                response.push({
                    key: param,
                    value: param
                })
            })
            return response;
        }

        $scope.save = () => {
            $scope.backendConfigurationForm.$setSubmitted();
            if ($scope.backendConfigurationForm.$valid) {
                let queryConfig = $scope.processQueries($scope.backendConfiguration);
                $uibModalInstance.close({
                    queryConfig: JSON.stringify(queryConfig)
                })
            }
        }

        $scope.cancel = () => {
            $uibModalInstance.dismiss();
        }

        $scope.getAllActiveEvents();


    } angular.module('imtecho.controllers').controller('BackendConfigurationController', BackendConfigurationController);
})()