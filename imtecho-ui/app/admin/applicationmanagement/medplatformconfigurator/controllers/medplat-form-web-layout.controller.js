(function () {
    function MedplatFormWebLayout($state, toaster, Mask, GeneralUtil, MedplatFormServiceV2, $uibModal,MedplatFormConfiguratorUtil) {
        let ctrl = this;
        const defaultConfigObject = {
            cssStyles: null,
            cssClasses: null,
            isRepeatable: false,
            showAddRemoveButton: false,
            ngModel: null,
            isConditional: false,
            ngIf: null
        };

        const _prepareFormFieldList = function (formFields) {
            return formFields.map(field => ({
                type: "TECHO_FORM_FIELD",
                fieldKey: field.fieldKey,
                name: field.fieldName,
                fieldType: field.fieldType
            })).sort((a, b) => {
                let fieldKeyA = a.fieldKey.toUpperCase();
                let fieldKeyB = b.fieldKey.toUpperCase();
                if (fieldKeyA < fieldKeyB) {
                    return -1;
                }
                if (fieldKeyA > fieldKeyB) {
                    return 1;
                }
                return 0;
            });
        }

        const _init = function () {
            ctrl.editMode = false;
            ctrl.fields = [];
            ctrl.formFieldList = [];
            ctrl.webTemplateConfig = [];
            ctrl.formMasterUuid = $state.params.uuid ? $state.params.uuid : null;
            if (ctrl.formMasterUuid) {
                ctrl.editMode = true;
            } else {
                ctrl.goBack();
                return;
            }
            if (ctrl.editMode) {
                Mask.show();
                MedplatFormServiceV2.getMedplatFormConfigByUuidForEdit(ctrl.formMasterUuid).then(response => {
                    ctrl.medplatFormMasterDto = response.medplatFormMasterDto;
                    ctrl.fieldConfigDtos = response.medplatFieldConfigs;
                    ctrl.formObject = JSON.parse(ctrl.medplatFormMasterDto.formObject || null);
                    ctrl.arrayObjects = [];
                    ctrl.setArrayObjects(ctrl.formObject, "")
                    ctrl.tempMedplatFormMasterDto = [];
                    if (ctrl.fieldConfigDtos != null) {
                        for (config in ctrl.fieldConfigDtos[ctrl.medplatFormMasterDto.formCode]) {
                            ctrl.tempMedplatFormMasterDto.push(ctrl.fieldConfigDtos[ctrl.medplatFormMasterDto.formCode][config]);
                        }
                    }
                    ctrl.formFieldList = _prepareFormFieldList(ctrl.tempMedplatFormMasterDto);
                    try {
                        ctrl.webTemplateConfig = ctrl.medplatFormMasterDto.webTemplateConfig ? JSON.parse(ctrl.medplatFormMasterDto.webTemplateConfig) : [];
                    } catch (error) {
                        console.error('Error while parsing JSON ::: ', error);
                    }
                    ctrl.formFieldList.forEach((formField) => {
                        ctrl.fields.push({
                            "type": 'TECHO_FORM_FIELD',
                            "elements": [],
                            "isAdded": ctrl.isAdded(formField),
                            "config": {
                                "fieldKey": formField.fieldKey,
                                "fieldName": formField.name,
                                "fieldType": formField.fieldType,
                                ...defaultConfigObject
                            }
                        })
                    })
                    MedplatFormConfiguratorUtil.setQueryColumnNameMap(JSON.parse(ctrl.medplatFormMasterDto.formVm).formQueries).then((res)=>{
                        ctrl.queryColumnNameMap = res;
                    })
                }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide);
            }

            ctrl.webComponents = [{
                "type": 'CARD',
                "config": {
                    "title": null,
                    "size": "12",
                    ...defaultConfigObject,
                    isCollapsible: false
                },
                "elements": []
            }, {
                "type": 'ROW',
                "config": {
                    "size": "12",
                    ...defaultConfigObject
                },
                "elements": []
            }]
        };

        const _addChildWebComponent = function (childWebComponent, elements) {
            switch (childWebComponent.type) {
                case 'COL':
                    for (let index = 1; index <= 12; index += Number(childWebComponent.size)) {
                        elements.push({
                            "type": angular.copy(childWebComponent.type),
                            "config": {
                                "size": angular.copy(childWebComponent.size),
                                ...defaultConfigObject
                            },
                            "elements": []
                        })
                    }
                    break;
            }
        }

        ctrl.onChildWebComponentChanged = function (childWebComponent, elements, element, parentComponentType) {
            if (!childWebComponent)
                return;
            _addChildWebComponent(childWebComponent, elements);
        }

        ctrl.save = function () {
            ctrl.manageWebDynamicTemplate.$setSubmitted();
            if (ctrl.manageWebDynamicTemplate.$valid) {
                ctrl.medplatFormMasterDto.formMasterUuid = ctrl.medplatFormMasterDto.uuid;
                ctrl.medplatFormMasterDto.templateConfig = angular.toJson(ctrl.webTemplateConfig);
                Mask.show();
                MedplatFormServiceV2.updateMedplatFormConfigurationFormTemplateConfig(ctrl.medplatFormMasterDto).then(() => {
                    ctrl.goBack();
                    toaster.pop("success", `Form Web Layout Configured Successfully.`);
                }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide);
            }
        }

        ctrl.goBack = function () {
            window.history.back();
        };

        ctrl.fieldAdded = function (field) {
            field.isAdded = true;
        }

        ctrl.onDrop = function (item) {
            if (item.type === 'TECHO_FORM_FIELD') {
                toaster.pop('warning', 'Fields can be added in columns only')
                return false
            }
            if(item.type === 'COL'){
                toaster.pop('warning','Columns can be added in rows only');
                event.stopPropagation();
                return false;
            }
            return item
        }

        ctrl.isAdded = function (field) {
            return ctrl.webTemplateConfig.some((component) => {
                if (component.elements && component.elements.length > 0) {
                    return ctrl.checkInChildElements(component.elements, field);
                }
            })
        }

        ctrl.checkInChildElements = function (elements, field) {
            return elements.some((element) => {
                if (element.type === 'TECHO_FORM_FIELD' && element.config.fieldKey === field.fieldKey && element.config.fieldType === field.fieldType) {
                    return true
                } else if (element.elements && element.elements.length > 0) {
                    return ctrl.checkInChildElements(element.elements, field)
                } else {
                    return false
                }
            })

        }
        ctrl.configureCss = () => {
            let modalInstance = $uibModal.open({
                templateUrl: 'app/admin/applicationmanagement/medplatformconfigurator/modals/template-css/medplat-form-template-css.modal.html',
                controller: 'MedplatFormTemplateCssModalController',
                windowClass: 'cst-modal',
                backdrop: 'static',
                keyboard: false,
                size: 'xl',
                resolve: {
                    config: () => {
                        return {
                            css: ctrl.medplatFormMasterDto.templateCss ? ctrl.medplatFormMasterDto.templateCss : ""
                        }
                    }
                }
            });
            modalInstance.result.then(function (data) {
                ctrl.medplatFormMasterDto.templateCss = data.css;
            }, () => {
            });
        }

        ctrl.setArrayObjects = (nodes, prefix) => {
            if (nodes) {
                nodes.forEach((node) => {
                    if (node.isArray) {
                        ctrl.arrayObjects.push({
                            value: `${prefix}${node.title}`,
                            alias: null
                        })
                    }
                    if (Array.isArray(node.nodes) && node.nodes.length) {
                        ctrl.setArrayObjects(node.nodes, node.isArray ? `${prefix}${node.title}[$${node.indexAlias}$].` : `${prefix}${node.title}.`);
                    }
                })
            }
        }

        _init();
    }
    angular.module('imtecho.controllers').controller('MedplatFormWebLayout', MedplatFormWebLayout);
})();
