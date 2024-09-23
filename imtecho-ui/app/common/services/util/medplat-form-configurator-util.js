(function (angular) {
    angular.module('imtecho.service').factory('MedplatFormConfiguratorUtil', function (Mask, QueryDAO, toaster, GeneralUtil, $state, $rootScope, $http, APP_CONFIG) {
        let MedplatFormConfiguratorUtil = {};

        MedplatFormConfiguratorUtil.getPropByPath = (obj, path) => {
            if (!obj || !path) {
                return obj;
            }
            path = path.replace(/\[(\w+)\]/g, '.$1'); // convert indexes to properties
            path = path.replace(/^\./, '');           // strip a leading dot
            var a = path.split('.');
            for (var i = 0; i < a.length; ++i) {
                var k = a[i];
                if (k in obj) {
                    obj = obj[k];
                } else {
                    return;
                }
            }
            return obj;
        };

        MedplatFormConfiguratorUtil.getObjectFromScope = (controllerScope, objectValue, iteratorIndicesMap = {}) => {
            let object;
            let objectArray = objectValue.split("[$index].");
            let currentElement = "";
            objectArray.forEach((o, index) => {
                currentElement = index === 0 ? o : currentElement.concat(`[$index].${o}`);
                object = index === 0 ? MedplatFormConfiguratorUtil.getPropByPath(controllerScope, o) : MedplatFormConfiguratorUtil.getPropByPath(object, o);
                if (iteratorIndicesMap[currentElement] !== null && typeof iteratorIndicesMap[currentElement] !== 'undefined') {
                    object = object[iteratorIndicesMap[currentElement]];
                }
            });
            return object;
        }

        MedplatFormConfiguratorUtil.OPERATOR_MAPPING = {
            "EQ": "==",
            "NQ": "!=",
            "EQWithType": "===",
            "NQWithType": "!==",
            "GT": ">",
            "LT": "<",
            "GTE": ">=",
            "LTE": "<="
        }

        MedplatFormConfiguratorUtil.getExpressionFromJson = ({ expressionJson, iteratorIndicesMap, formIndexes, parentJoinType, expression }) => {
            let joinType = expressionJson.conditions.rule === 'AND' ? '&&' : '||';
            let expressionArray = [];
            expressionJson.conditions.options.forEach((option) => {
                if (option.hasOwnProperty('conditions')) {
                    expression = MedplatFormConfiguratorUtil.getExpressionFromJson({
                        expressionJson: option,
                        iteratorIndicesMap,
                        formIndexes,
                        parentJoinType: joinType,
                        expression
                    });
                }
                switch (option.type) {
                    case 'FIELD':
                    case 'VARIABLE':
                        let fieldString = MedplatFormConfiguratorUtil.replaceFormConfigParamsWithValues(option.fieldName, iteratorIndicesMap, formIndexes);
                        expressionArray.push(`${fieldString} ${MedplatFormConfiguratorUtil.generateExpression(option, fieldString)}`)
                        break;
                    case 'CUSTOM':
                        expressionArray.push(MedplatFormConfiguratorUtil.replaceFormConfigParamsWithValues(option.expression, iteratorIndicesMap, formIndexes))
                        break;
                }
            });
            if (expressionArray.length) {
                if (expression && expression.length) {
                    return `(${expressionArray.join(joinType)})`.concat(parentJoinType || joinType).concat(expression);
                } else {
                    return `(${expressionArray.join(joinType)})`;
                }
            }
            return expression;
        }

        MedplatFormConfiguratorUtil.generateExpression = (option, fieldName) => {
            if (option.operator === 'BT') {
                //FORM_CONFIGURATOR_TODO
                return `>= ${option.value1} && ${fieldName} <= ${option.value2}`;
            } else {
                return `${MedplatFormConfiguratorUtil.OPERATOR_MAPPING[option.operator]} ${option.value1}`;
            }
        }

        MedplatFormConfiguratorUtil.configureActions = (actions, config) => {
            let configuredActions = [];
            if (Array.isArray(actions) && actions.length) {
                actions.forEach((action) => {
                    configuredActions.push(MedplatFormConfiguratorUtil.getFunctionByAction(action, config));
                })
            }
            return configuredActions;
        }

        MedplatFormConfiguratorUtil.executeActionFunction = (eventActions) => {
            return new Promise((resolve, reject) => {
                if (Array.isArray(eventActions) && eventActions.length) {
                    eventActions.reduce((previousAction, currentAction) => {
                        return previousAction.then(() => {
                            return currentAction();
                        }).catch((error) => {
                            if (error.continueIfFail) {
                                GeneralUtil.showMessageOnApiCallFailure(error);
                                console.error(error);
                                return Promise.resolve();
                            } else {
                                throw error;
                            }
                        })
                    }, Promise.resolve()).then(() => {
                        resolve();
                    }).catch((error) => {
                        reject(error);
                    })
                }
            });
        }

        MedplatFormConfiguratorUtil.getFunctionByAction = (action, config) => {
            switch (action.type) {
                case 'LOAD_FIELD':
                    return () => MedplatFormConfiguratorUtil.loadField(action.value, action.continueIfFail || false, config);
                case 'RESET_FIELD':
                    return () => MedplatFormConfiguratorUtil.resetField(action.value, action.continueIfFail || false, config);
                case 'FORM_METHOD':
                    return () => MedplatFormConfiguratorUtil.callFormMethod(action.value, action.continueIfFail || false, config);
                case 'FORM_VARIABLE_SETTER':
                    return () => MedplatFormConfiguratorUtil.callVariableSetter(action.value, action.continueIfFail || false, config);
                case 'FORM_QUERY':
                    return () => MedplatFormConfiguratorUtil.callFormQuery(action.value, action.continueIfFail || false, config);
                    break;
            }
        }

        MedplatFormConfiguratorUtil.removeIndexPart = (str) => {
            const regex = /\[\$.*?\$\]/g;
            return str.replace(regex, '[#tempIdx#]');
        }

        MedplatFormConfiguratorUtil.replaceFormConfigParamsWithValues = (value, iteratorIndicesMap = {}, formIndexes = {}) => {
            let isJSONValue = false;
            try {
                let jsonValue = JSON.parse(value);
                isJSONValue = true;
            } catch (error) { }
            const loggedInUserReplace = "$rootScope.loggedInUserId";
            const stateReplace = "$state.params.config";
            const formDataReplace = "ctrl.formData";
            const infoDataReplace = "ctrl.infoData";
            const utilityDataReplace = "ctrl.utilityData";
            let replacedValue = value;
            Object.keys(formIndexes).every(formIndex => {
                if (replacedValue.includes(`[${formIndex}]`)) {
                    let currentValue = "";
                    if (isJSONValue) {
                        currentValue = MedplatFormConfiguratorUtil.removeIndexPart(replacedValue);
                    } else {
                        currentValue = replacedValue.substring(0, replacedValue.indexOf(`[${formIndex}]`))
                    }
                    let index = iteratorIndicesMap[formIndexes[formIndex]];
                    if (index != null) {
                        replacedValue = replacedValue.replaceAll(formIndex, index);
                    } else {
                        replacedValue = currentValue;
                        return false;
                    }
                }
                return true;
            });
            replacedValue = replacedValue.replaceAll('$loggedInUserId$', loggedInUserReplace)
                .replaceAll('$stateParams$', stateReplace)
                .replaceAll('$formData$', formDataReplace)
                .replaceAll('$infoData$', infoDataReplace)
                .replaceAll('$utilityData$', utilityDataReplace)
            return replacedValue;
        }

        MedplatFormConfiguratorUtil.filterFormStructureList = (list, filter) => {
            return list.filter((item) => {
                return filter(item);
            })
        }

        MedplatFormConfiguratorUtil.replaceRootObject = (value) => {
            return value.replaceAll('$formData$', 'formData')
                .replaceAll('$infoData$', 'infoData')
                .replaceAll('$utilityData$', 'utilityData');
        }

        MedplatFormConfiguratorUtil.getDefaultEmptyDropdownData = () => {
            return [{
                "key": null,
                "value": "--No Data Found--"
            }]
        }

        MedplatFormConfiguratorUtil.loadField = (fieldName, continueIfFail, { ctrl, iteratorIndicesMap }) => {
            let field = ctrl.formConfigurations[fieldName];
            let fieldVisibility = 'true';
            if (field.visibility && field.visibility !== 'null' && field.visibility !== '{}') {
                fieldVisibility = MedplatFormConfiguratorUtil.getExpressionFromJson({
                    expressionJson: JSON.parse(field.visibility),
                    iteratorIndicesMap,
                    formIndexes: ctrl.formIndexes
                });
            }
            if (eval(fieldVisibility)) {
                let formQuery = ctrl.formVm?.formQueries?.find(q => q.value === field.queryBuilder);
                return new Promise((resolve, reject) => {
                    try {
                        let ngModelObject = eval(MedplatFormConfiguratorUtil.replaceFormConfigParamsWithValues(field.ngModel, iteratorIndicesMap, ctrl.formIndexes));
                        ngModelObject[`__extra${field.fieldKey}List`].data = [];
                        let query = formQuery.queryCode;
                        let queryParams = JSON.parse(formQuery.paramConfig);
                        let queryString = formQuery.query;
                        let params = formQuery.params;
                        Object.keys(queryParams).forEach((param) => {
                            queryParams[param] = eval(MedplatFormConfiguratorUtil.replaceFormConfigParamsWithValues(queryParams[param], iteratorIndicesMap, ctrl.formIndexes));
                        });
                        Mask.show();
                        QueryDAO.executeForFormConfigurator({
                            code: query,
                            parameters: queryParams,
                            query: queryString,
                            params: params
                        }).then((response) => {
                            if (response.result.length) {
                                ngModelObject[`__extra${field.fieldKey}List`].data = formQuery.isField ? GeneralUtil.transformArrayToKeyValue(response.result, formQuery.dropdownKey, formQuery.dropdownValue) : response.result;
                                resolve();
                            } else {
                                ngModelObject[`__extra${field.fieldKey}List`].data = MedplatFormConfiguratorUtil.getDefaultEmptyDropdownData();
                                ctrl.formData[field?.fieldKey] = null;
                                reject({
                                    "status": 500,
                                    "data": {
                                        "message": `No data found for ${fieldName} field`
                                    },
                                    "continueIfFail": continueIfFail
                                });
                            }
                        }).catch((error) => {
                            ngModelObject[`__extra${field.fieldKey}List`].data = MedplatFormConfiguratorUtil.getDefaultEmptyDropdownData();
                            ctrl.formData[field?.fieldKey] = null;
                            reject({
                                "status": 500,
                                "data": {
                                    "message": `Error loading ${fieldName} field : ${error.message}`,
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
                                "message": `Error loading ${fieldName} field`,
                                "error": error
                            },
                            "continueIfFail": continueIfFail
                        })
                    }
                })
            }
        }

        MedplatFormConfiguratorUtil.resetField = (fieldName, continueIfFail, { ctrl, iteratorIndicesMap }) => {
            let field = ctrl.formConfigurations[fieldName];
            return new Promise((resolve, reject) => {
                try {
                    let object = eval(MedplatFormConfiguratorUtil.replaceFormConfigParamsWithValues(field.ngModel, iteratorIndicesMap, ctrl.formIndexes));
                    if (Array.isArray(object) && object.length) {
                        object.forEach((o) => {
                            o[field.fieldKey] = null;
                        })
                    } else {
                        object[field.fieldKey] = null;
                    }
                    resolve();
                } catch (error) {
                    reject({
                        "status": 500,
                        "data": {
                            "message": `Could not reset field ${field.fieldKey}`,
                            "error": error
                        },
                        "continueIfFail": continueIfFail
                    });
                }
            });
        }

        MedplatFormConfiguratorUtil.callFormMethod = (methodName, continueIfFail, { ctrl, iteratorIndicesMap }) => {
            let method = ctrl.formVm?.formMethods?.find(m => m.value === methodName);
            return new Promise((resolve, reject) => {
                try {
                    let code = eval(MedplatFormConfiguratorUtil.replaceFormConfigParamsWithValues(method.code, iteratorIndicesMap, ctrl.formIndexes));
                    code();
                    resolve();
                } catch (error) {
                    reject({
                        "status": 500,
                        "data": {
                            "message": `Error during ${method.value}() execution`,
                            "error": error
                        },
                        "continueIfFail": continueIfFail
                    })
                }
            });
        }

        MedplatFormConfiguratorUtil.callVariableSetter = (variableName, continueIfFail, { ctrl, iteratorIndicesMap }) => {
            let variable = ctrl.formVm?.formVariables?.find(v => v.value === variableName);
            return new Promise((resolve, reject) => {
                try {
                    let code = eval(MedplatFormConfiguratorUtil.replaceFormConfigParamsWithValues(variable.setterMethodCode, iteratorIndicesMap, ctrl.formIndexes));
                    code();
                    resolve();
                } catch (error) {
                    reject({
                        "status": 500,
                        "data": {
                            "message": `Error during ${variable.value} setter method execution`,
                            "error": error
                        },
                        "continueIfFail": continueIfFail
                    })
                }
            })
        }

        MedplatFormConfiguratorUtil.callFormQuery = (queryName, continueIfFail, { ctrl, iteratorIndicesMap }) => {
            let query = ctrl.formVm?.formQueries?.find(q => q.value === queryName);
            return new Promise((resolve, reject) => {
                try {
                    let queryCode = query.queryCode;
                    let queryParams = JSON.parse(query.paramConfig);
                    let queryString = query.query;
                    let params = query.params;
                    Object.keys(queryParams).forEach(param => {
                        queryParams[param] = eval(MedplatFormConfiguratorUtil.replaceFormConfigParamsWithValues(queryParams[param], iteratorIndicesMap, ctrl.formIndexes));
                    })
                    let queryResponseObject = eval(MedplatFormConfiguratorUtil.replaceFormConfigParamsWithValues(query.response.substring(0, query.response.lastIndexOf('.')), iteratorIndicesMap, ctrl.formIndexes));
                    let queryResponseKey = query.response.substring(query.response.lastIndexOf('.') + 1);
                    queryResponseObject[queryResponseKey] = query.isResultArray ? [] : {};
                    if (query.isPagination) {
                        queryParams.limit = query.recordsToFetch;
                        queryParams.offSet = 0;
                    }
                    Mask.show();
                    QueryDAO.executeForFormConfigurator({
                        code: queryCode,
                        parameters: queryParams,
                        params: params,
                        query: queryString
                    }).then((response) => {
                        if (response.result.length) {
                            if (query.isField) {
                                queryResponseObject[queryResponseKey] = query.isResultArray ? GeneralUtil.transformArrayToKeyValue(response.result, query.dropdownKey, query.dropdownValue) : GeneralUtil.transformArrayToKeyValue(response.result[0], query.dropdownKey, query.dropdownValue);
                            } else if (query.isPagination) {
                                queryResponseObject[queryResponseKey] = response.result;
                            } else {
                                let r = query.isResultArray ? response.result : response.result[0];
                                if (Array.isArray(r)) {
                                    queryResponseObject[queryResponseKey].push(...r)
                                } else {
                                    Object.assign(queryResponseObject[queryResponseKey], { ...r })
                                }
                            }
                            if (query.successMessage != null) {
                                toaster.pop('success', query.successMessage);
                            }
                            resolve();
                        } else if (query.isResponseMandatory) {
                            reject({
                                "status": 500,
                                "data": {
                                    "message": `No data found for ${queryName} query`
                                },
                                "continueIfFail": continueIfFail
                            });
                        } else {
                            resolve();
                        }
                    }).catch((error) => {
                        reject({
                            "status": 500,
                            "data": {
                                "message": `Error in ${queryName} : ${error.message}`,
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
                            "message": `Error during ${queryName} query execution`,
                            "error": error
                        },
                        "continueIfFail": continueIfFail
                    })
                }
            })
        }


       


        MedplatFormConfiguratorUtil.setQueryColumnNameMap = function (formVmQueries) {
            return new Promise((resolve,reject)=>{
                let queryColumnNameMap = {}
                for (let queryObj of formVmQueries) {
                    let queryString = queryObj.query;
                    let cte = /with\s+.*?\)\s*select/igs.exec(queryString);
                    let queryWithoutCte = cte ? queryString.substring(cte[0].length - 6) : queryString;
                    queryColumnNameMap[queryObj.response] = MedplatFormConfiguratorUtil.getColumnArray(queryWithoutCte);
                }
                resolve(queryColumnNameMap);
            })
        
        }

        MedplatFormConfiguratorUtil.applyColRegex = (selectQuery) => {
            // const columnsRegex = /(\w*\(.*?\)\s+as\s+\w+|\w+\.\w+\s+as\s+\w+|\w+\s+as\s+\w+|[^,\s]+\s*(?=,|$))/gi;
            const columnsRegex = /(\w*\(.*?\)\s+as\s+\w+|\w+\.\w+\s+as\s+\w+|\w+\s+as\s+\w+|[^*,\s][^,\s]*\s*(?=,|$))/gi;
            let columnsMatch = selectQuery.match(columnsRegex) || [];
            return columnsMatch.map(column => {
              const asMatch = column.match(/\s+as\s+(\w+)/i);
              if (asMatch) {
                return asMatch[1].trim();
              }

              const tableColumnMatch = column.match(/(\w+)\.(\w+)/);
              if (tableColumnMatch) {
                  return tableColumnMatch[2];
              }
              return column.trim().replace(/;$/, '').replaceAll('"','');
            });
        };


        MedplatFormConfiguratorUtil.getColumnArray = (query) => {
            let parenthesesCount = 0;
            let selectIndex = -1;
            let fromIndex = -1;

            for (let i = 0; i < query.length; i++) {
                const char = query[i];
                if (char === '(') {
                    parenthesesCount++;
                } else if (char === ')') {
                    parenthesesCount--;
                } else if (parenthesesCount === 0) {
                    if (selectIndex === -1 && query.substring(i, i + 6).toLowerCase() === 'select') {
                        selectIndex = i;
                    } else if (selectIndex !== -1 && fromIndex === -1 && query.substring(i, i + 4).toLowerCase() === 'from') {
                        fromIndex = i;
                        break;
                    }
                }
            }

            if (selectIndex !== -1 && fromIndex !== -1 && selectIndex < fromIndex) {
                return MedplatFormConfiguratorUtil.applyColRegex(query.substring(selectIndex, fromIndex));
            }

            return [];
        };
        return MedplatFormConfiguratorUtil;
    });
})(window.angular, window.Math);