(function (angular) {
    let FormVmModalController = function ($scope, $uibModal, $uibModalInstance, config, toaster, MedplatFormConfiguratorUtil) {

        $scope.init = () => {
            $scope.selectedTab = 'variables';
            $scope.formVm = config.formVm || {
                "formVariables": [],
                "formMethods": [],
                "formQueries": []
            };
            $scope.queryBuilderCode = config.queryBuilderCode;
            $scope.queryMigrationMap = config.queryMigrationMap;
            $scope.queryBuilderCodeParams = config.queryBuilderCodeParams;
            $scope.queryBuilderMap = config.queryBuilderMap;
            $scope.getColumnArray = config.getColumnArray;
            $scope.indexAliases = config.indexAliases;
            $scope.showQueryDetails = [];
            $scope.formObjectGroupKeys = config.formObjectGroupKeys || [];
            $scope.formObjectArrayKeysWithIndex = config.formObjectArrayKeysWithIndex || [];
            $scope.formObjectArrayKeysWithoutIndex = config.formObjectArrayKeysWithoutIndex || [];
            $scope.arrayVariables = $scope.formVm.formVariables.filter(fv => fv.type === 'ARRAY').map(fv => `${fv.bindTo}.${fv.value}`);
            $scope.nonArrayVariables = $scope.formVm.formVariables.filter(fv => fv.type !== 'ARRAY').map(fv => `${fv.bindTo}.${fv.value}`);
            $scope.variablesBindTo = MedplatFormConfiguratorUtil.filterFormStructureList(
                [
                    '$utilityData$',
                    ...$scope.formObjectGroupKeys,
                    ...$scope.formObjectArrayKeysWithIndex
                ], (item) => {
                    return !item.startsWith('$infoData$') && item !== '$formData$'
                }
            );
            $scope.setDefaultResponseBindTo();
            $scope.setFieldVariableResponseBindTo();
            $scope.setArrayResponseBindTo();

            if ($scope.formVm.hasOwnProperty("formQueries")) {
                $scope.formVm.formQueries.forEach((query, index) => {
                    query.paramConfig = JSON.parse(query.paramConfig);
                    $scope.setQueryColumnNameMap(query);
                })
            }
        }

        $scope.getObjectKeys = (obj) => {
            if (typeof obj === 'object') {
                return Object.keys(obj);
            } else {
                return [];
            }
        }

        $scope.add = () => {
            if ($scope.selectedTab === 'variables') {
                $scope.formVm.formVariables.push({
                    value: null,
                    type: null,
                    bindTo: '$utilityData$',
                    setter: true,
                    setterMethodName: null,
                    setterMethodCode: null
                })
            } else if ($scope.selectedTab === 'methods') {
                $scope.formVm.formMethods.push({
                    value: null,
                    code: null
                })
            } else if ($scope.selectedTab === 'queries') {
                $scope.formVm.formQueries.push({
                    value: null,
                    queryCode: null,
                    params: null,
                    paramConfig: {},
                    query: null,
                    response: null,
                    isResultArray: null,
                    successMessage: null,
                    failureMessage: null,
                    isResponseMandatory: null,
                    isField: null,
                    isPagination: null
                });
            }
        }

        $scope.delete = (array, index) => {
            array.splice(index, 1);
        }

        $scope.manageVariableSetterMethod = (variable) => {
            if (variable.setter && variable.value != null) {
                variable.setterMethodName = `set${variable.value.charAt(0).toUpperCase()}${variable.value.slice(1)}`
                variable.setterMethodCode = $scope.initializeSetterMethodCode(variable);
            } else {
                variable.setterMethodName = null;
                variable.setterMethodCode = null;
            }
        }

        $scope.initializeSetterMethodCode = (variable) => {
            let code = `(function ${variable.setterMethodName}() {\n\n${$scope.getComment(variable)}\n\t\n});`
            return code;
        }

        $scope.editVariableMethodCode = (variable) => {
            let currentCodeEditorModel = variable.setterMethodCode;

            let modalInstance = $uibModal.open({
                templateUrl: 'app/admin/applicationmanagement/medplatformconfigurator/modals/ace-editor/ace-editor.modal.html',
                controller: 'AceEditorModalController',
                windowClass: 'cst-modal',
                backdrop: 'static',
                keyboard: false,
                size: 'xl',
                resolve: {
                    config: () => {
                        return {
                            currentCodeEditorModel,
                            indexAliases: $scope.indexAliases
                        }
                    }
                }
            });
            modalInstance.result.then(function (data) {
                variable.setterMethodCode = data.code
            }, () => {
            });
        }

        $scope.manageMethod = (method) => {
            if (method.value != null) {
                variable.setterMethodCode = $scope.initializeMethodCode(method);
            } else {
                method.value = null;
                method.code = null;
            }
        }

        $scope.initializeMethodCode = (method) => {
            let code = `(function ${method.value}() {\n\t\n});`
            return code;
        }

        $scope.queryCheckboxChange = (query, type) => {
            if (type === 'FIELD') {
                if (query.isField) {
                    query.isResultArray = true;
                } else {
                    query.isResultArray = false;
                    query.toVariable = false;
                }
            }
            query.response = null;
            query.dropdownKey = null;
            query.dropdownValue = null;
        }

        $scope.editMethodCode = (method) => {
            if (method.value == null) {
                toaster.pop('error', 'Please enter method name first');
                return
            }
            let currentCodeEditorModel = null;
            if (method.code != null) {
                currentCodeEditorModel = method.code;
            } else {
                currentCodeEditorModel = `(function ${method.value}() {\n\t\n});`;
            }
            let modalInstance = $uibModal.open({
                templateUrl: 'app/admin/applicationmanagement/medplatformconfigurator/modals/ace-editor/ace-editor.modal.html',
                controller: 'AceEditorModalController',
                windowClass: 'cst-modal',
                backdrop: 'static',
                keyboard: false,
                size: 'xl',
                resolve: {
                    config: () => {
                        return {
                            currentCodeEditorModel,
                            indexAliases: $scope.indexAliases
                        }
                    }
                }
            });
            modalInstance.result.then(function (data) {
                method.code = data.code
            }, () => {
            });
        }

        $scope.showQueryDetailsModal = (queryObj) => {
            var modalInstance = $uibModal.open({
                templateUrl: 'app/admin/applicationmanagement/medplatformconfigurator/modals/form-vm/form-vm-query-details-modal.html',
                controller: 'FormVmQueryDetailsModalController',
                windowClass: 'cst-modal',
                size: 'lg',
                resolve: {
                    config: () => {
                        return {
                            queryObj: queryObj,
                            queryBuilderMap: $scope.queryBuilderMap
                        }
                    }
                }
            });
            modalInstance.result.then(function () {
            }, function () {
            });
        }

        $scope.configureQueryParams = (query, queryCode) => {
            query.params = {};
            query.isPagination = false;
            $scope.queryBuilderCodeParams.forEach(param => {
                if (param.forQueryCode === queryCode) {
                    param.fieldKeyCode.forEach(kq => {
                        if (kq === 'limit_offset') {
                            query.isPagination = true;
                        } else if (kq === 'limit' || kq === 'offset') {
                            // query.isPagination = false;
                        } else {
                            query.params[kq] = null;
                        }
                    })
                }
            })
            $scope.setQueryColumnNameMap(query);
        };

        $scope.setQueryColumnNameMap = (queryObj) => {
            if ( queryObj.queryCode) {
                let queryString = queryObj.query
                let cte = /with\s+.*?\)\s*select/igs.exec(queryString);
                let queryWithoutCte = cte ? queryString.substring(cte[0].length - 6) : queryString;
                queryObj.availableColumns = $scope.getColumnArray(queryWithoutCte);
            }
        }


        $scope.save = () => {
            $scope.uniqueQueryNames = new Set();
            if ($scope.formVm.hasOwnProperty("formQueries")) {
                $scope.formVm.formQueries.forEach((query, index) => {
                    if ($scope.uniqueQueryNames.has(query.value)) {
                        $scope.vmForm.queriesForm['value' + index].$setValidity('querynameduplicate', false);
                        $scope.selectedTab = 'queries';
                        return;
                    } else {
                        $scope.uniqueQueryNames.add(query.value);
                        $scope.vmForm.queriesForm['value' + index].$setValidity('querynameduplicate', true);
                        if (!query.isField) {
                            delete query.dropdownKey;
                            delete query.dropdownValue;
                        }
                        delete query.availableColumns;
                    }
                })
            }
            $scope.vmForm.variablesForm?.$setSubmitted();
            if ($scope.vmForm.variablesForm?.$invalid) {
                $scope.selectedTab = 'variables';
                return;
            }
            $scope.vmForm.methodsForm?.$setSubmitted();
            if ($scope.vmForm.methodsForm?.$invalid) {
                $scope.selectedTab = 'methods';
                return;
            }
            $scope.vmForm.queriesForm?.$setSubmitted();
            if ($scope.vmForm.queriesForm?.$invalid) {
                $scope.selectedTab = 'queries';
                return;
            }
            if ($scope.formVm.hasOwnProperty("formQueries")) {
                $scope.formVm.formQueries.forEach(query => {
                    query.paramConfig = JSON.stringify(query.paramConfig);
                })
            }
            $uibModalInstance.close({
                formVm: JSON.stringify($scope.formVm)
            })
        }

        $scope.setDefaultResponseBindTo = () => {
            $scope.defaultResponseBindTo = MedplatFormConfiguratorUtil.filterFormStructureList(
                [
                    ...$scope.formObjectGroupKeys,
                    ...$scope.formObjectArrayKeysWithIndex,
                    ...$scope.nonArrayVariables
                ], (item) => {
                    return item !== '$formData$' && item !== '$utilityData$' && item !== '$infoData$';
                }
            );
        }

        $scope.setFieldVariableResponseBindTo = () => {
            $scope.fieldVariableResponseBindTo = [...$scope.arrayVariables]
        }

        $scope.setArrayResponseBindTo = () => {
            $scope.arrayResponseBindTo = MedplatFormConfiguratorUtil.filterFormStructureList(
                [
                    ...$scope.formObjectArrayKeysWithoutIndex,
                    ...$scope.arrayVariables
                ], (item) => {
                    return item !== '$formData$' && item !== '$utilityData$' && item !== '$infoData$';
                }
            )
        }

        $scope.getComment = (variable) => {
            let commentArray = [
                `* Setter method for ${variable.bindTo}.${variable.value} (${variable.type})`,
                `* Please see example below on how to set the value`,
                `* ${variable.bindTo}.${variable.value} = xxx;`,
                `* You can use the available parameters`
            ]
            return `\t/**\n\t${commentArray.join('\n\t')}\n\t*/`;
        }

        $scope.cancel = () => {
            $uibModalInstance.dismiss();
        }

        $scope.toggleFilter = function (query, calledFromInside = false) {
            if (query) {
                $scope.currentQueryConfig = query;
            }
            if (calledFromInside) {
                $scope.showBackdropForSQLEdit = false;
            } else {
                $scope.showBackdropForSQLEdit = true;
            }
            angular.element('.cst-backdrop').fadeToggle();
            angular.element('.filter-div').toggleClass('active');
        };

        $scope.queryStringChanged = (currentQueryConfig, queryString) => {
            let availableParams = $scope.extractWordsBetweenHashes(queryString);
            let previousParamsIfAvailable = null;
            let previousParamsList = []
            let newParams = {};

            if (currentQueryConfig.paramConfig && Object.keys(currentQueryConfig.paramConfig).length > 0) {
                previousParamsIfAvailable = currentQueryConfig.paramConfig;
                previousParamsList = Object.keys(currentQueryConfig.paramConfig);
            }

            currentQueryConfig.isPagination = false;

            if (Object.keys(currentQueryConfig.paramConfig).length > 0) {
                availableParams.forEach(param=> {
                    if (param === 'limit_offset') {
                        currentQueryConfig.isPagination = true;
                    } else if (param === 'limit' || param === 'offset') {

                    } else {
                        if(previousParamsList.includes(param)) {
                            newParams[param] = previousParamsIfAvailable[param];
                        } else {
                            newParams[param] = null;
                        }
                    }
                })
            } else {
                availableParams.forEach(param=> {
                    if (param === 'limit_offset') {
                        currentQueryConfig.isPagination = true;
                    } else if (param === 'limit' || param === 'offset') {

                    } else {
                        newParams[param] = null;
                    }
                })
            }

            currentQueryConfig.paramConfig = newParams;
            currentQueryConfig.params = availableParams.join(',');
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
            return Array.from(matches);
        }

        $scope.migrate = () => {
            if ($scope.formVm) {
                $scope.formVm.formQueries.forEach(query => {
                    if (Object.keys($scope.queryMigrationMap).includes(query.queryCode)){
                        query.queryCode = $scope.queryMigrationMap[query.queryCode];
                    }
                })
            }
            $scope.save();
        }

        $scope.init();

    };
    angular.module('imtecho.controllers').controller('FormVmModalController', FormVmModalController);
})(window.angular);
