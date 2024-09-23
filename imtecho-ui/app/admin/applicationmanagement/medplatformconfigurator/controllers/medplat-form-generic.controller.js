(function () {
    function GenericFormController(MedplatFormServiceV2, GeneralUtil, $state, Mask, QueryDAO, MedplatFormConfiguratorUtil, $scope, $state,toaster) {
        let ctrl = this;

        ctrl.init = function () {
            ctrl.listValueFieldsDto = [];
            ctrl.listValueResponseMap = {};
            ctrl.utilityData = {};
            ctrl.formIndexes = {};
            Mask.show();
            MedplatFormServiceV2.getMedplatFormConfigByFormCode($state.params.config.formCode).then((res) => {
                ctrl.formConfigurations = res.medplatFieldConfigs[res.medplatFormMasterDto.formCode];
                ctrl.webTemplateConfigs = JSON.parse(res.medplatFormMasterDto.webTemplateConfig);
                ctrl.templateCss = res.medplatFormMasterDto.templateCss || {}
                ctrl.formVm = JSON.parse(res.medplatFormMasterDto.formVm || null)
                ctrl.formObject = JSON.parse(res.medplatFormMasterDto.formObject || null);
                ctrl.formLoadConfigurations = res.medplatFormMasterDto.executionSequence;
                ctrl.queryConfig = JSON.parse(res.medplatFormMasterDto.queryConfig || null);
                ctrl.setListValueConfigs();
                return QueryDAO.executeAll(ctrl.listValueFieldsDto);
            }).then((response) => {
                response.forEach((r) => {
                    ctrl.formConfigurations[ctrl.listValueResponseMap[r.sequence]]['listValueFieldValue'] = JSON.stringify(r.result);
                });
                if (ctrl.formObject != null) {
                    ctrl.setFormIndexes(ctrl.formObject, "");
                    ctrl.createFormObjectsInCtrlScope(ctrl.formObject, ctrl);
                }
                let formLoadConfig = JSON.parse(ctrl.formLoadConfigurations || null);
                if (Array.isArray(formLoadConfig) && formLoadConfig.length) {
                    let actions = MedplatFormConfiguratorUtil.configureActions(formLoadConfig, { ctrl });
                    if (actions.length) {
                        MedplatFormConfiguratorUtil.executeActionFunction(actions).then(() => {
                            ctrl.loadForm = true;
                            $scope.$apply();
                        }).catch((error) => {
                            GeneralUtil.showMessageOnApiCallFailure(error);
                            console.error(error);
                            window.history.back();
                        })
                    }
                }
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        ctrl.setListValueConfigs = () => {
            Object.keys(ctrl.formConfigurations).forEach((property, index) => {
                if (ctrl.formConfigurations[property].hasOwnProperty('listValueField')) {
                    ctrl.listValueFieldsDto.push({
                        code: 'fetch_listvalue_detail_from_field',
                        parameters: {
                            field: ctrl.formConfigurations[property].listValueField
                        },
                        sequence: index
                    });
                    ctrl.listValueResponseMap[index] = property;
                }
            });
        }

        ctrl.createFormObjectsInCtrlScope = (nodes, parent) => {
            nodes.forEach((node) => {
                let title = MedplatFormConfiguratorUtil.replaceRootObject(node.title);
                parent[title] = node.isArray ? [] : {};
                if (Array.isArray(node.nodes) && node.nodes.length && !node.isArray) {
                    ctrl.createFormObjectsInCtrlScope(node.nodes, parent[title]);
                }
            })
        }

        ctrl.getChildByNodesPath = (nodes, path) => {
            for (let node of nodes) {
                if (node.path === path) {
                    return node.nodes;
                }
                if (Array.isArray(node.nodes) && node.nodes.length) {
                    let childNodes = ctrl.getChildByNodesPath(node.nodes, path);
                    if (childNodes != null) {
                        return childNodes;
                    }
                }
            }
            return [];
        }

        ctrl.setFormIndexes = (nodes, prefix) => {
            nodes.forEach(node => {
                if (node.isArray) {
                    ctrl.formIndexes[`$${node.indexAlias}$`] = `${prefix}${node.title}`
                }
                if (Array.isArray(node.nodes) && node.nodes.length) {
                    ctrl.setFormIndexes(node.nodes, node.isArray ? `${prefix}${node.title}[$${node.indexAlias}$].` : `${prefix}${node.title}.`);
                }
            });
        }


        ctrl.extractMetaDataValueKeys = (obj) => {
            let result = [];
            if (Array.isArray(obj)) {
                for (let item of obj) {
                    result = result.concat(ctrl.extractMetaDataValueKeys(item));
                }
            } else if (typeof obj === 'object' && obj !== null) {
                if (obj.type === 'META_DATA' && obj.valueKey) {
                    result.push(obj.valueKey);
                }
                for (let key in obj) {
                    if (obj.hasOwnProperty(key)) {
                        result = result.concat(ctrl.extractMetaDataValueKeys(obj[key]));
                    }
                }
            }
            return result;
        }

        ctrl.removeExtraData = (obj) => {
            let o = obj
            Object.keys(o).forEach(key => {
                if (typeof key === 'object') {
                    ctrl.removeExtraData(key);
                } else if (typeof key === 'array') {
                    for (let i = 0; i < key.length; i++) {
                        if (typeof key[i] === 'object') {
                            ctrl.removeExtraData(key[i]);
                        }
                    }
                } else if (key.startsWith('__extra')) {
                    delete o[key];
                }
            })
        }


        ctrl.submit = () => {
            let formData = angular.copy(ctrl.formData);
            ctrl.removeExtraData(formData);
            let metaDataList = ctrl.extractMetaDataValueKeys(ctrl.queryConfig);
            let metaData = {};
            metaDataList.forEach(data => {
                metaData[data] = eval(MedplatFormConfiguratorUtil.replaceFormConfigParamsWithValues(data, $scope.iteratorIndicesMap, ctrl.formIndexes));
            });
            let medplatFormDto = { formData, metaData };
            console.log(medplatFormDto);
            Mask.show();
            MedplatFormServiceV2.saveMedplatFormDataByFormCode($state.params.config.formCode, medplatFormDto).then((response) => {
                console.log(response);
                toaster.pop('success','Form saved successfully')
                window.history.back();
            }).catch(error => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            })
        }

        ctrl.retrieveAllQueries = function () {
            Mask.show();
            QueryDAO.retrieveAllConfigured().then(function (res) {
                ctrl.configuredQueries = res;
                ctrl.queryUUIDToCodeMap = {};
                ctrl.configuredQueries.forEach((q) => {
                    if (q.state == 'ACTIVE') {
                        ctrl.queryUUIDToCodeMap[q.uuid] = q.code;
                    }
                });
                ctrl.init();
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        };

        // ctrl.init();
        ctrl.retrieveAllQueries();
    }
    angular.module('imtecho.controllers').controller('GenericFormController', GenericFormController);
})();