(() => {
    let techoFormFieldDirective = (toaster, $filter, $compile, $timeout, UUIDgenerator, MedplatFormConfiguratorUtil, GeneralUtil, $state, PagingForFormConfiguratorQueryService, QueryDAO, Mask) => {
        return {
            restrict: 'E',
            scope: {
                config: '=',
                configJson: '=',
                iteratorIndicesMap: '=?',
            },
            require: '^ngController',
            templateUrl: 'app/admin/applicationmanagement/medplatformconfigurator/directives/generators/field/template.html',
            link: ($scope, elements, attributes, ctrl) => {
                $scope.ctrl = ctrl;
                $scope.uuid = UUIDgenerator.generateUUID();
                $scope.defaultTextPattern = "^[^<>\$\^\|\?\\\\]*$";
                $scope.today = moment();
                $scope.todayTimeMin = moment().format('YYYY-MM-DDT00:00');
                $scope.todayTimeMax = moment().format('YYYY-MM-DDT23:59');

                let _generateExpression = (option, fieldName) => {
                    if (option.operator === BETWEEN_OPERATOR) {
                        return `> ${option.value1} && ctrl.${fieldName} < ${option.value2}`;
                    } else {
                        return `${OPERATOR_MAPPING[option.operator]} ${option.value1}`;
                    }
                }

                $scope.fetchPagingData = () => {
                    let query = ctrl.formVm?.formQueries?.find(q => q.value === $scope.tableConfigJson.queryBuilderForPagination);
                    let continueIfFail = query.continueIfFail;
                    return new Promise((resolve, reject) => {
                        try {
                            let queryCode = query.queryCode;
                            let queryParams = JSON.parse(query.paramConfig);
                            let params = query.params;
                            let queryString = query.query;
                            Object.keys(queryParams).forEach(param => {
                                queryParams[param] = eval(MedplatFormConfiguratorUtil.replaceFormConfigParamsWithValues(queryParams[param], $scope.iteratorIndicesMap, ctrl.formIndexes));
                            })
                            let queryResponseObject = eval(MedplatFormConfiguratorUtil.replaceFormConfigParamsWithValues(query.response.substring(0, query.response.lastIndexOf('.')), $scope.iteratorIndicesMap, ctrl.formIndexes));
                            let queryResponseKey = query.response.substring(query.response.lastIndexOf('.') + 1);
                            // queryResponseObject[queryResponseKey] = query.isResultArray ? [] : {};
                            queryParams.limit = query.recordsToFetch;
                            queryParams.offSet = $scope[`${$scope.tableConfigJson.fieldName}PagingService`].paginationResponseObjects[$scope.tableConfigJson.fieldName].offSet;
                            let querydto = {
                                code: queryCode,
                                parameters: queryParams,
                                query: queryString,
                                params: params ? params + ",limit,offSet" : "limit,offSet"
                            };
                            Mask.show();
                            $scope[`${$scope.tableConfigJson.fieldName}PagingService`].getNextPage(QueryDAO.executeForFormConfigurator, querydto, $scope.tableObject, null, $scope.tableConfigJson.fieldName).then((response) => {
                                $scope.tableObject = response;
                                queryResponseObject[queryResponseKey] = $scope.tableObject;
                                if (query.successMessage != null) {
                                    toaster.pop('success', query.successMessage);
                                }
                                resolve();
                            }).catch((error) => {
                                reject({
                                    "status": 500,
                                    "data": {
                                        "message": `Error in ${$scope.tableConfigJson.queryBuilderForPagination} : ${error.message}`,
                                        "error": error.stack
                                    },
                                    "continueIfFail": continueIfFail
                                });
                            }).finally(() => {
                                Mask.hide();
                            });
                        } catch (error) {
                            reject({
                                "status": 500,
                                "data": {
                                    "message": `Error during ${$scope.tableConfigJson.queryBuilderForPagination} query execution`,
                                    "error": error
                                },
                                "continueIfFail": continueIfFail
                            })
                        }
                    })
                }

                $scope.generateAndExecuteActions = (actionItem, tableRow, tableObject) => {
                    let index = $scope.tableObject.indexOf(tableRow);
                    switch (actionItem.action) {
                        case 'NAVIGATE_TO':
                            if (!actionItem.openInNewWindow) {
                                if (actionItem.config) {
                                    let configJson = JSON.parse(MedplatFormConfiguratorUtil.replaceFormConfigParamsWithValues(actionItem.config, $scope.iteratorIndicesMap, $scope.ctrl.formIndexes).replaceAll('#tempIdx#', index));
                                    if (configJson.hasOwnProperty('config')) {
                                        Object.keys(configJson.config).forEach(cj => {
                                            // configJson[cj] = configJson[cj].replaceAll('#tempIdx#', index);
                                            configJson.config[cj] = eval(configJson.config[cj]);
                                        })
                                    } else {
                                        Object.keys(configJson).forEach(cj => {
                                            // configJson[cj] = configJson[cj].replaceAll('#tempIdx#', index);
                                            configJson[cj] = eval(configJson[cj]);
                                        })
                                    }
                                    if (Object.keys(configJson).length > 0) {
                                        $state.go(actionItem.state, configJson);
                                    }
                                } else {
                                    $state.go(actionItem.state);
                                }
                            } else {
                                if (actionItem.config) {
                                    let configJson = JSON.parse(MedplatFormConfiguratorUtil.replaceFormConfigParamsWithValues(actionItem.config, $scope.iteratorIndicesMap, $scope.ctrl.formIndexes).replaceAll('#tempIdx#', index));
                                    if (configJson.hasOwnProperty('config')) {
                                        Object.keys(configJson.config).forEach(cj => {
                                            // configJson[cj] = configJson[cj].replaceAll('#tempIdx#', index);
                                            configJson.config[cj] = eval(configJson.config[cj]);
                                        })
                                    } else {
                                        Object.keys(configJson).forEach(cj => {
                                            // configJson[cj] = configJson[cj].replaceAll('#tempIdx#', index);
                                            configJson[cj] = eval(configJson[cj]);
                                        })
                                    }
                                    if (Object.keys(configJson).length > 0) {
                                        let url = $state.href(actionItem.state, configJson);
                                        sessionStorage.setItem('linkClick', 'true')
                                        window.open(url, '_blank');
                                    }
                                } else {
                                    let url = $state.href(actionItem.state);
                                    sessionStorage.setItem('linkClick', 'true')
                                    window.open(url, '_blank');
                                }
                            }
                            break;
                    }
                }

                let _init = () => {
                    if ($scope.configJson?.fieldType) {
                        $scope.componentIdentifier = `${$scope.configJson.fieldKey}${$scope.uuid}`;
                        $scope.translatedLabel = $scope.configJson.label; //translatedLabel
                        /* $scope.uniqueId = '';
                        if ($scope.iteratorIndicesMap) {
                            for (const property in $scope.iteratorIndicesMap) {
                                $scope.uniqueId += `__${$scope.iteratorIndicesMap[property]}`;
                            }
                        } */
                        if ($scope.configJson.fieldType === 'CUSTOM_HTML') {
                            $timeout(function () {
                                let angularElement = angular.element($scope.configJson.customHTML);
                                let linkFunction = $compile(angularElement);
                                let newScope = $scope.$new();
                                let el = linkFunction(newScope);
                                angular.element(`#customHTML${$scope.uuid}`).append(el[0]);
                            })
                            return;
                        }
                        if ($scope.configJson.ngModel) {
                            $scope.ngModelObject = eval(MedplatFormConfiguratorUtil.replaceFormConfigParamsWithValues($scope.configJson.ngModel, $scope.iteratorIndicesMap, $scope.ctrl.formIndexes));
                        }
                        $scope.isRequired = String($scope.configJson.isRequired) === 'true';
                        $scope.isHidden = String($scope.configJson.isHidden) === 'true';
                        $scope.isDisabled = String($scope.configJson.isDisabled) === 'true';
                        if ($scope.configJson.events && $scope.configJson.events !== 'null' && $scope.configJson.events !== '{}') {
                            let events = JSON.parse($scope.configJson.events);
                            Object.keys(events).forEach((event) => {
                                let e = `ng${event}`;
                                let eventActions = MedplatFormConfiguratorUtil.configureActions(events[event].actions, { ctrl, iteratorIndicesMap: $scope.iteratorIndicesMap });
                                if (eventActions.length) {
                                    $scope[e] = () => {
                                        MedplatFormConfiguratorUtil.executeActionFunction(eventActions).then(() => {
                                            $scope.$apply();
                                        }).catch((error) => {
                                            GeneralUtil.showMessageOnApiCallFailure(error);
                                            console.error(error);
                                            window.history.back();
                                        })
                                    }
                                }
                            })
                        }
                        $scope.visible = 'true';
                        $scope.required = 'false';
                        $scope.disabled = 'false';
                        if ($scope.configJson.visibility && $scope.configJson.visibility !== 'null' && $scope.configJson.visibility !== '{}') {
                            $scope.visible = MedplatFormConfiguratorUtil.getExpressionFromJson({
                                expressionJson: JSON.parse($scope.configJson.visibility),
                                iteratorIndicesMap: $scope.iteratorIndicesMap,
                                formIndexes: $scope.ctrl.formIndexes
                            });
                        }
                        if ($scope.configJson.requirable && $scope.configJson.requirable !== 'null' && $scope.configJson.requirable !== '{}') {
                            $scope.required = MedplatFormConfiguratorUtil.getExpressionFromJson({
                                expressionJson: JSON.parse($scope.configJson.requirable),
                                iteratorIndicesMap: $scope.iteratorIndicesMap,
                                formIndexes: $scope.ctrl.formIndexes
                            });
                        }
                        if ($scope.configJson.disability && $scope.configJson.disability !== 'null' && $scope.configJson.disability !== '{}') {
                            $scope.disabled = MedplatFormConfiguratorUtil.getExpressionFromJson({
                                expressionJson: JSON.parse($scope.configJson.disability),
                                iteratorIndicesMap: $scope.iteratorIndicesMap,
                                formIndexes: $scope.ctrl.formIndexes
                            });
                        }
                        switch ($scope.configJson.fieldType) {
                            case 'IMMUNISATION_DIRECTIVE':
                                $scope.immunisationParams = {
                                    immunisationGiven: eval(MedplatFormConfiguratorUtil.replaceFormConfigParamsWithValues($scope.configJson.givenImmunisation, $scope.iteratorIndicesMap, $scope.ctrl.formIndexes)),
                                    dob: eval(MedplatFormConfiguratorUtil.replaceFormConfigParamsWithValues($scope.configJson.dob, $scope.iteratorIndicesMap, $scope.ctrl.formIndexes)),
                                }
                                $scope.ngModelObject[$scope.configJson.fieldKey] = null;
                                break;
                            case 'DROPDOWN':
                                if (typeof $scope.configJson.isMultiple === 'undefined' || String($scope.configJson.isMultiple) === 'false') {
                                    $scope.configJson.isMultiple = false;
                                } else {
                                    $scope.configJson.isMultiple = true;
                                }
                                $scope.optionsArray = [];
                                $scope.configureOptions();
                                break;
                            case 'CHECKBOX':
                                $scope.optionsArray = [];
                                if ($scope.configJson && $scope.configJson.staticOptions) {
                                    $scope.optionsArray.data = JSON.parse($scope.configJson.staticOptions);
                                }
                                break;
                            case 'RADIO':
                                $scope.optionsArray = [];
                                if (typeof $scope.configJson.isBoolean === 'undefined' || String($scope.configJson.isBoolean) === 'false') {
                                    $scope.configJson.isBoolean = false;
                                } else {
                                    $scope.configJson.isBoolean = true;
                                }
                                $scope.configureOptions();
                                break;
                            case 'DATE':
                                [$scope.minDateObject, $scope.minDateKey] = $scope.dateMinMaxValidation($scope.configJson.minDateField);
                                [$scope.maxDateObject, $scope.maxDateKey] = $scope.dateMinMaxValidation($scope.configJson.maxDateField);
                                if ($scope.minDateObject[$scope.minDateKey] > $scope.maxDateObject[$scope.maxDateKey]) {
                                    $scope.ngModelObject[$scope.configJson.fieldKey] = null;
                                }
                                break;
                            case 'DATE_AND_TIME':
                                [$scope.minDateTimeObject, $scope.minDateTimeKey] = $scope.dateTimeMinMaxValidation($scope.configJson.minDateTimeField, 'MIN');
                                [$scope.maxDateTimeObject, $scope.maxDateTimeKey] = $scope.dateTimeMinMaxValidation($scope.configJson.maxDateTimeField, 'MAX');
                                if ($scope.minDateTimeObject[$scope.minDateTimeKey] > $scope.maxDateTimeObject[$scope.maxDateTimeKey]) {
                                    $scope.ngModelObject[$scope.configJson.fieldKey] = null;
                                }
                                break;
                            case 'TABLE':
                                if ($scope.configJson.isPagination === 'true') {
                                    $scope.tablePagination = true;
                                    $scope.tableConfigJson = $scope.configJson;
                                    $scope.tableId = $scope.tableConfigJson.fieldName;
                                    $scope[`${$scope.tableConfigJson.fieldName}PagingService`] = new PagingForFormConfiguratorQueryService.initialize($scope.tableConfigJson.fieldName);
                                } else {
                                    $scope.tablePagination = false;
                                }
                                try {
                                    $scope.tableConfig = JSON.parse($scope.configJson.tableConfig);
                                } catch (error) {
                                    toaster.pop('error', `Error parsing JSON for ${$scope.configJson.fieldKey}`);
                                }
                                $scope.tableObject = [eval(MedplatFormConfiguratorUtil.replaceFormConfigParamsWithValues($scope.configJson.tableObject, $scope.iteratorIndicesMap, $scope.ctrl.formIndexes))];
                                if ($scope.configJson.isPagination === 'true') {
                                    $scope[`${$scope.tableConfigJson.fieldName}PagingService`].paginationResponseObjects[$scope.tableConfigJson.fieldName].offSet = $scope.tableObject.length;
                                }
                                break;
                            case 'INFORMATION_TEXT':
                                $scope.isClickable = String($scope.configJson.isClickable) === 'true'
                                break;
                            case 'INFORMATION_DISPLAY':
                                if ($scope.configJson.displayType === "dateAndTime" || $scope.configJson.displayType === 'date') {
                                    $scope.ngModelObject[$scope.configJson.fieldKey] = $filter('date')($scope.ngModelObject[$scope.configJson.fieldKey], $scope.configJson.dateFormat);
                                }
                                break;
                        }
                    }
                }

                $scope.getTableId = () => {
                    return $scope.tableId;
                }

                $scope.configureOptions = () => {
                    if ($scope.configJson && $scope.configJson.optionsType) {
                        switch ($scope.configJson.optionsType) {
                            case 'staticOptions':
                                try {
                                    $scope.optionsArray.data = JSON.parse($scope.configJson.staticOptions);
                                } catch (error) {
                                    toaster.pop('error', `Error parsing JSON for ${$scope.configJson.fieldKey}`);
                                }
                                break;
                            case 'listValueField':
                                try {
                                    $scope.optionsArray.data = JSON.parse($scope.configJson.listValueFieldValue).map((element) => {
                                        return {
                                            key: element['id'],
                                            value: element['value']
                                        }
                                    });
                                    if ($scope.configJson.staticOptions && $scope.configJson.staticOptions.length) {
                                        $scope.optionsArray.data.push(...JSON.parse($scope.configJson.staticOptions));
                                    }
                                } catch (error) {
                                    toaster.pop('error', `Error parsing JSON for ${$scope.configJson.fieldKey}`);
                                }
                                break;
                            case 'queryBuilder':
                                let key = `__extra${$scope.configJson.fieldKey}List`;
                                if ($scope.ngModelObject[key] == null) {
                                    $scope.ngModelObject[`__extra${$scope.configJson.fieldKey}List`] = { data: [] };
                                }
                                $scope.optionsArray = $scope.ngModelObject[`__extra${$scope.configJson.fieldKey}List`];
                                break;
                            case 'variableList':
                                //FORM_CONFIGURATOR_TODO
                                $scope.optionsArray.data = eval(MedplatFormConfiguratorUtil.replaceFormConfigParamsWithValues($scope.configJson.variableList, $scope.iteratorIndicesMap, $scope.ctrl.formIndexes));
                                break;
                        }
                    }
                }

                $scope.dateMinMaxValidation = (dateField) => {
                    let dateObject = null;
                    let dateKey = null;
                    if (dateField != null) {
                        let dateConfig = JSON.parse(dateField || null);
                        if (dateConfig.type === 'FIELD') {
                            dateObject = eval(MedplatFormConfiguratorUtil.replaceFormConfigParamsWithValues(dateConfig.key.substring(0, dateConfig.key.lastIndexOf('.')), $scope.iteratorIndicesMap, $scope.ctrl.formIndexes));
                            dateKey = dateConfig.key.substring(dateConfig.key.lastIndexOf('.') + 1);
                        } else if (dateConfig.type === 'VARIABLE') {
                            if (dateConfig.key === '$today$') {
                                return [$scope, 'today']
                            }
                            dateObject = eval(MedplatFormConfiguratorUtil.replaceFormConfigParamsWithValues(dateConfig.key.substring(0, dateConfig.key.lastIndexOf('.')), $scope.iteratorIndicesMap, $scope.ctrl.formIndexes));
                            dateKey = dateConfig.key.substring(dateConfig.key.lastIndexOf('.') + 1);
                        }
                    }
                    return [dateObject, dateKey];
                }

                $scope.dateTimeMinMaxValidation = (dateField, type) => {
                    let dateObject = null;
                    let dateKey = null;
                    if (dateField != null) {
                        let dateConfig = JSON.parse(dateField || null);
                        if (dateConfig.type === 'FIELD') {
                            //FORM_CONFIGURATOR_TODO
                            dateObject = MedplatFormConfiguratorUtil.getObjectFromScope(ctrl, dateConfig.key.substring(0, dateConfig.key.lastIndexOf('.')), $scope.iteratorIndicesMap);
                            dateKey = dateConfig.key.substring(dateConfig.key.lastIndexOf('.') + 1);
                        } else if (dateConfig.type === 'VARIABLE') {
                            if (dateConfig.key === '$today$') {
                                if (type === 'MIN') {
                                    return [$scope, 'todayTimeMin']
                                } else {
                                    return [$scope, 'todayTimeMax']
                                }
                            }
                            dateObject = eval(MedplatFormConfiguratorUtil.replaceFormConfigParamsWithValues(dateConfig.key.substring(0, dateConfig.key.lastIndexOf('.'))));
                            dateKey = dateConfig.key.substring(dateConfig.key.lastIndexOf('.') + 1);
                        }
                    }
                    return [dateObject, dateKey];
                }

                _init();
            }
        }
    };
    angular.module('imtecho.directives').directive('techoFormFieldDirective', techoFormFieldDirective);
})();
