(function () {
    function MedplatFormV2($state, $sce, Mask, toaster, GeneralUtil, $q, QueryDAO, MedplatFormServiceV2, $uibModal, AuthenticateService, MedplatFormConfiguratorUtil, $scope, UUIDgenerator) {
        let ctrl = this;

        ctrl.prevQueryBuilderCode = null;
        ctrl.dateFormatPopoverTemplate = $sce.trustAsHtml('Check available <a target ="_blank" href="https://www.w3schools.com/angular/ng_filter_date.asp">Date Formats</a>');

        ctrl.fieldValueKeyMap = {};
        ctrl.listValueFieldValueObjectMap = {};

        ctrl.removeQueryParamsFieldList = {};
        ctrl.canSaveStableVersion = false;

        ctrl.getKeyMapData = function () {
            Mask.show();
            MedplatFormServiceV2.getMedplatFieldKeyMap().then((res) => {
                ctrl.keyMap = res;
                ctrl.fieldTypesNew = [];
                ctrl.fieldKeyDtoList = [];
                ctrl.fieldValueMap = {};
                ctrl.keyMap.forEach((key) => {
                    ctrl.fieldTypesNew.push({ key: key.fieldCode, value: key.fieldName });
                    const transformedData = {};
                    transformedData[key.fieldCode] = key.fieldKeyDto;
                    if (transformedData != {}) {
                        ctrl.fieldValueMap[key.fieldCode.toString()] = key.fieldKeyDto;
                    }
                });
                ctrl.fieldTypes = ctrl.fieldTypesNew;
                _init();
            }).catch((err) => {
            }).finally(()=>{
                Mask.hide();
            });
        };


        ctrl.retrieveListValueFieldsForForm = function (form) {
            var dto = {
                code: 'retrieve_all_listvalue_active_fields',
                parameters: {}
            };
            Mask.show();
            QueryDAO.execute(dto).then(function (res) {
                ctrl.fieldsForForm = res.result;
                ctrl.listValueFieldsList = [];
                ctrl.viewListValueFieldsList = []
                ctrl.fieldsForForm.forEach((q) => {
                    ctrl.listValueFieldsList.push({
                        value: q.field,
                        fieldKeyName: q.field_key,
                        fieldKeyCode: q.field,
                        valueType: 'TEXT',
                        required: true
                    })

                    ctrl.viewListValueFieldsList.push({
                        value: q.field,
                        fieldKeyName: q.field_key,
                        fieldKeyCode: q.field_key,
                        valueType: 'TEXT',
                        required: true
                    })
                })
                ctrl.fieldValueDropdownOptionsByKey.listValueField = ctrl.listValueFieldsList;
                ctrl.viewListValueFieldsTemp = ctrl.viewListValueFieldsList;

                ctrl.viewListValueFieldsTemp.forEach((qp) => {
                    ctrl.fieldValueKeyMap[qp["value"]] = qp["fieldKeyCode"]
                });
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        };


        ctrl.retrieveMenuConfigList = function () {
            var dto = {
                code: 'retrieve_menu_config_for_form_config',
                parameters: {}
            };
            Mask.show();
            QueryDAO.execute(dto).then(function (res) {
                ctrl.menuConfigData = res.result;
                ctrl.menuConfigList = [];
                ctrl.menuConfigData.forEach(menu => {
                    ctrl.menuConfigList.push(menu.navigation_state)
                });
                ctrl.menuConfigList.push("techo.admin.genericForm");
                ctrl.menuConfigList.push("techo.admin.medplatForm");
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        };


        ctrl.setQueryBuilderList = function (formVm) {
            formVm = JSON.parse(formVm);
            ctrl.formVmQueryBuilderList = [];
            if (formVm) {
                formVm.formQueries.forEach(query => {
                    ctrl.formVmQueryBuilderList.push({
                        fieldKeyCode: query.value,
                        fieldQueryCode: query.queryCode,
                        responseSavedIn: query.response,
                        value: query.value,
                        params: query.params,
                        query: query.query,
                        isPagination: query.isPagination,
                        valueType: 'TEXT',
                        required: true
                    })
                })
                ctrl.fieldValueDropdownOptionsByKey.queryBuilder = ctrl.formVmQueryBuilderList;
                ctrl.fieldValueDropdownOptionsByKey.queryBuilderForPagination = ctrl.fieldValueDropdownOptionsByKey.queryBuilder.filter(q => q.isPagination === true);
            } else {
                ctrl.fieldValueDropdownOptionsByKey.queryBuilder = [];
                ctrl.fieldValueDropdownOptionsByKey.queryBuilderForPagination = [];
            }
        }


        ctrl.fieldConfigPlatform = "BOTH";
        ctrl.fieldValueDropdownOptionsByKey = {
            "mobileEvent": [{
                fieldKeyCode: 'SAVE',
                value: 'Save',
                valueType: 'TEXT',
                required: true
            }, {
                fieldKeyCode: 'SAVEFORM',
                value: 'Save Form',
                valueType: 'TEXT',
                required: true
            },
            {
                fieldKeyCode: 'LOOP',
                value: 'Loop',
                valueType: 'TEXT',
                required: true
            },
            {
                fieldKeyCode: 'DEFAULTLOOP',
                value: 'DefaultLoop',
                valueType: 'TEXT',
                required: true
            },
            {
                fieldKeyCode: 'SUBMIT',
                value: 'Submit',
                valueType: 'TEXT',
                required: true
            },
            {
                fieldKeyCode: 'OKAY',
                value: 'Okay',
                valueType: 'TEXT',
                required: true
            }],
            "optionsType": [{
                fieldKeyCode: 'staticOptions',
                value: 'Static Options',
                valueType: 'JSON',
                required: true
            }, {
                fieldKeyCode: 'listValueField',
                value: 'List Value Field Name',
                valueType: 'DROPDOWN',
                required: true
            }, {
                fieldKeyCode: 'queryBuilder',
                value: 'Query Builder Code',
                valueType: 'DROPDOWN',
                required: true
            }, {
                fieldKeyCode: 'variableList',
                value: 'Form Utility',
                valueType: 'DROPDOWN',
                required: true
            }],
            "templateType": [{
                fieldKeyCode: 'twoPart',
                value: 'Two Part',
                valueType: 'TEXT'
            }, {
                fieldKeyCode: 'inline',
                value: 'Inline',
                valueType: 'TEXT'
            }],
            "displayType": [{
                fieldKeyCode: 'text',
                value: 'Text',
                valueType: 'TEXT'
            }, {
                fieldKeyCode: 'boolean',
                value: 'Boolean',
                valueType: 'TEXT'
            }, {
                fieldKeyCode: 'date',
                value: 'Date',
                valueType: 'TEXT'
            }, {
                fieldKeyCode: 'dateAndTime',
                value: 'Date and Time',
                valueType: 'TEXT'
            }, {
                fieldKeyCode: 'gender',
                value: 'Gender',
                valueType: 'TEXT'
            }, {
                fieldKeyCode: 'familyPlanning',
                value: 'Family Planning',
                valueType: 'TEXT'
            }, {
                fieldKeyCode: 'sdScore',
                value: 'SD Score',
                valueType: 'TEXT'
            }],
            "buttonType": [{
                fieldKeyCode: 'button',
                value: 'Button',
                valueType: 'TEXT'
            }, {
                fieldKeyCode: 'submit',
                value: 'Submit',
                valueType: 'TEXT'
            }, {
                fieldKeyCode: 'reset',
                value: 'Reset',
                valueType: 'TEXT'
            }],
            "buttonLabelType": [{
                fieldKeyCode: 'text',
                value: 'Label with text',
                valueType: 'TEXT'
            }, {
                fieldKeyCode: 'icon',
                value: 'Label with icon',
                valueType: 'TEXT'
            }, {
                fieldKeyCode: 'textAndIcon',
                value: 'Label with text and icon',
                valueType: 'TEXT'
            }],
            "fileUploadType": [{
                fieldKeyCode: 'IMAGE',
                value: 'Image',
                valueType: 'TEXT'
            }, {
                fieldKeyCode: 'VIDEO',
                value: 'Video',
                valueType: 'TEXT'
            }, {
                fieldKeyCode: 'AUDIO',
                value: 'Audio',
                valueType: 'TEXT'
            }, {
                fieldKeyCode: 'OTHER',
                value: 'Other',
                valueType: 'TEXT'
            }],
            "queryBuilder": [{
                fieldKeyCode: 'IMAGE',
                value: 'Image',
                valueType: 'TEXT',
                required: true
            }],
            "listValueField": [{
                fieldKeyCode: 'IMAGE',
                value: 'Image',
                valueType: 'TEXT',
                required: true
            }],
            "minDateField": [{
                fieldKeyCode: JSON.stringify({
                    key: '$today$',
                    type: 'VARIABLE'
                }),
                value: '$today$',
                valueType: 'TEXT',
                required: true
            }],
            "maxDateField": [{
                fieldKeyCode: JSON.stringify({
                    key: '$today$',
                    type: 'VARIABLE'
                }),
                value: '$today$',
                valueType: 'TEXT',
                required: true
            }],
            "tableObject": [{
                fieldKeyCode: 'IMAGE',
                value: 'Image',
                valueType: 'TEXT',
                required: true
            }],
            "minDateTimeField": [{
                fieldKeyCode: JSON.stringify({
                    key: '$today$',
                    type: 'VARIABLE'
                }),
                value: '$today$',
                valueType: 'TEXT',
                required: true
            }],
            "maxDateTimeField": [{
                fieldKeyCode: JSON.stringify({
                    key: '$today$',
                    type: 'VARIABLE'
                }),
                value: '$today$',
                valueType: 'TEXT',
                required: true
            }],
            "queryBuilderForPagination": [{
                fieldKeyCode: 'IMAGE',
                value: 'Image',
                valueType: 'TEXT',
                required: true
            }],
        };

        let option = {
            type: "",
            operator: "",
            value1: "",
            value2: "",
            fieldName: "",
            queryCode: ""
        }
        let event = [{
            type: "",
            value: ""
        }];

        ctrl.medplatFormConfig = {
            medplatFormMasterDto: {},
            medplatFieldMasterDtos: []
        };

        ctrl.addEvent = (fieldConfig) => {
            ctrl.showWhenEventDialogOpened = true;
            let modalInstance = $uibModal.open({
                templateUrl: 'app/admin/applicationmanagement/medplatformconfigurator/modals/events/events.modal.html',
                controller: 'EventsModalController',
                windowClass: 'cst-modal',
                backdrop: 'static',
                keyboard: false,
                size: 'xl',
                resolve: {
                    config: () => {
                        return {
                            event: fieldConfig.events,
                            fieldName: fieldConfig.fieldName,
                            formFields: ctrl.medplatFormConfig.medplatFieldMasterDtos,
                            formVm: JSON.parse(ctrl.medplatFormConfig.medplatFormMasterDto.formVm)
                        }
                    }
                }
            });
            modalInstance.result.then(function (data) {
                fieldConfig.events = data.event
                ctrl.showWhenEventDialogOpened = false;
            }, () => {
                ctrl.showWhenEventDialogOpened = false;
            });
        }

        ctrl.deleteEvent = (fieldConfig, index) => {
            fieldConfig.events.splice(index, 1);
        }

        ctrl.addCondition = (array, fieldConfig) => {
            fieldConfig[array].conditions.options.push({ ...option });
        }

        ctrl.addGroup = (array, fieldConfig, rule) => {
            if (fieldConfig[array] && fieldConfig[array].conditions) {
                fieldConfig[array].conditions.options.push({
                    conditions: {
                        rule,
                        options: [{ ...option }]
                    }
                })
            } else {
                fieldConfig[array] = {
                    conditions: {
                        rule,
                        options: [{ ...option }]
                    }
                }
            }
        }

        ctrl.invertGroup = (array, fieldConfig) => {
            fieldConfig[array].conditions.rule = fieldConfig[array].conditions.rule === 'AND' ? 'OR' : 'AND';
        }

        ctrl.deleteGroup = (array, fieldConfig) => {
            delete fieldConfig[array];
        }


        ctrl.modifyfieldConfigUi = (fieldConfig, configurations) => {
            ctrl.hideFields = [];
            if (fieldConfig.hasOwnProperty('queryBuilder')) {
                if (fieldConfig.hasOwnProperty('additionalStaticOptionsRequired')) {
                    if (fieldConfig.additionalStaticOptionsRequired != 'true') {
                        ctrl.hideFields.push("staticOptions");
                    }
                }
                fieldConfig.medplatFieldValueMasterDtos.push(
                    {
                        fieldKeyCode: 'queryBuilder',
                        fieldKeyName: 'Query Builder Code',
                        valueType: 'DROPDOWN',
                        defaultValue: fieldConfig.queryBuilder,
                        showInUI: true,
                        required: 'true'
                    }
                );
            }

            if (fieldConfig.hasOwnProperty('variableList')) {
                ctrl.hideFields.push("staticOptions");
                let variableList = fieldConfig.medplatFieldValueMasterDtos.find(e => e.fieldKeyCode === 'variableList');
                if (variableList) {
                    variableList.showInUI = true;
                } else {
                    fieldConfig.medplatFieldValueMasterDtos.push(
                        {
                            fieldKeyCode: 'variableList',
                            fieldKeyName: 'Form Utility',
                            valueType: 'DROPDOWN',
                            defaultValue: fieldConfig.variableList,
                            showInUI: true,
                            required: 'true'
                        }
                    );
                }
            }

            if (fieldConfig.fieldType === 'RADIO' && fieldConfig.isBoolean === 'true') {
                ctrl.hideFields.push("staticOptions");
            }

            if (fieldConfig.fieldType === 'TABLE') {
                if (fieldConfig.hasOwnProperty('isPagination')) {
                    if (fieldConfig.isPagination === 'true') {
                        fieldConfig.medplatFieldValueMasterDtos.push(
                            {
                                fieldKeyCode: 'queryBuilderForPagination',
                                fieldKeyName: 'Query Builder Code For Pagination',
                                valueType: 'DROPDOWN',
                                defaultValue: fieldConfig.queryBuilderForPagination,
                                showInUI: true,
                                required: true
                            }
                        );
                    } else {
                        if (fieldConfig.hasOwnProperty('queryBuilderForPagination')) {
                            ctrl.hideFields.push("queryBuilderForPagination");
                        }
                    }
                }
            }

            if (fieldConfig.hasOwnProperty('listValueField')) {
                if (fieldConfig.hasOwnProperty('additionalStaticOptionsRequired')) {
                    if (fieldConfig.additionalStaticOptionsRequired != 'true') {
                        ctrl.hideFields.push("staticOptions");
                    }
                }
                let listValueFieldField = fieldConfig.medplatFieldValueMasterDtos.find(e => e.fieldKeyCode === 'listValueField');
                if (listValueFieldField) {
                    listValueFieldField.showInUI = true;
                } else {
                    fieldConfig.medplatFieldValueMasterDtos.push(
                        {
                            fieldKeyCode: 'listValueField',
                            fieldKeyName: 'List Value Field Name',
                            valueType: 'DROPDOWN',
                            defaultValue: fieldConfig.listValueField,
                            showInUI: true,
                            required: 'true'
                        }
                    );
                }
            }
            if (fieldConfig.hasOwnProperty('staticOptions')) {
                if (fieldConfig.hasOwnProperty('listValueField') || fieldConfig.hasOwnProperty('queryBuilder')) {
                    if (fieldConfig.hasOwnProperty('additionalStaticOptionsRequired')) {
                        if (fieldConfig.additionalStaticOptionsRequired != 'true') {
                            // ctrl.hideFields.push("additionalStaticOptionsRequired");
                        }
                    }
                } else {
                    ctrl.hideFields.push("additionalStaticOptionsRequired");
                }
            }
            if (fieldConfig.fieldType === 'NUMBER' && !fieldConfig.hasOwnProperty('hasPattern')) {
                ctrl.hideFields.push("pattern");
                ctrl.hideFields.push("patternMessage");
            }
            if (fieldConfig.hasOwnProperty('hasPattern')) {
                if (fieldConfig.hasPattern == 'false') {
                    ctrl.hideFields.push("pattern");
                    ctrl.hideFields.push("patternMessage");
                }
            }
            if (fieldConfig.hasOwnProperty('queryParams')) {
                let tempQueryParam = typeof fieldConfig.queryParams === 'string' ? JSON.parse(fieldConfig.queryParams) : fieldConfig.queryParams;
                Object.keys(tempQueryParam).forEach(k => {
                    ctrl.removeQueryParamsFieldList[fieldConfig.fieldName] = `#${k}#`;
                    fieldConfig.medplatFieldValueMasterDtos.push({
                        fieldKeyCode: `${k}`,
                        fieldKeyName: `#${k}#`,
                        defaultValue: tempQueryParam[k],
                        forQueryCode: fieldConfig.queryBuilder,
                        valueType: 'TEXT',
                        showInUI: true,
                        required: true
                    })
                })
            }
            if (fieldConfig.hasOwnProperty('displayType')) {
                if (fieldConfig.displayType === 'date') {
                    fieldConfig.medplatFieldValueMasterDtos.push(
                        {
                            fieldKeyCode: 'dateFormat',
                            fieldKeyName: 'Date format',
                            valueType: 'TEXT',
                            defaultValue: fieldConfig.dateFormat,
                            showInUI: true,
                            required: true
                        }
                    );
                }
            }
            fieldConfig.medplatFieldValueMasterDtos.map((element) => {
                if (ctrl.hideFields.includes(element.fieldKeyCode)) {
                    element.showInUI = false;
                } else {
                    element.showInUI = true;
                    element.required = 'true'
                }
            });
            ctrl.hideFields = [];
        }


        const _init = function () {
            Mask.show();
            AuthenticateService.getLoggedInUser()
                .then(function (res) {
                    ctrl.user = res.data;
                    if (ctrl.user != null) {
                        AuthenticateService.getAssignedFeature('techo.admin.medplatForms').then((res) => {
                            if (res) {
                                ctrl.canSaveStableVersion = res.featureJson?.canSaveStableVersion ? res.featureJson.canSaveStableVersion : false;
                            }
                            ctrl.formFieldConfigData = {};
                            ctrl.generateFieldValueMap();
                            ctrl.medplatFormUuid = $state.params.uuid || null;
                            if (ctrl.medplatFormUuid) ctrl.editMode = true;
                            ctrl.manageSingleFormConfig = true;
                            ctrl.retrieveListValueFieldsForForm();
                            ctrl.retrieveMenuConfigList();
                            ctrl.getmedplatFormConfig();
                        })
                    }
                })
                .then(function () { }).catch(GeneralUtil.showMessageOnApiCallFailure)
                .finally(function () {
                    Mask.hide();
                });
        };


        ctrl._processFormFieldConfig = function (fieldMasterDto) {
            let notPresentFieldValueKeys = _.difference(_.pluck(ctrl.fieldValueMap[fieldMasterDto.fieldType], "fieldKeyCode"), _.pluck(fieldMasterDto.medplatFieldValueMasterDtos, "fieldKeyCode"));
            notPresentFieldValueKeys.forEach(fieldValueKey => {
                let fieldValueConfig = ctrl.fieldValueMapByKey[fieldMasterDto.fieldType][fieldValueKey];
                fieldMasterDto.medplatFieldValueMasterDtos.push({
                    fieldKeyCode: fieldValueKey,
                    fieldKeyName: fieldValueConfig.fieldKeyName,
                    valueType: fieldValueConfig.fieldKeyValueType,
                    value: null,
                    defaultValue: fieldMasterDto[fieldValueKey],
                    overrideValue: false,
                    order: fieldValueConfig.order,
                    required: fieldValueConfig.isRequired
                })
            })

            fieldMasterDto.medplatFieldValueMasterDtos.forEach(fieldValueMasterDto => {
                fieldValueMasterDto.overrideValue = false;
                fieldValueMasterDto.order = ctrl.fieldValueMapByKey[fieldMasterDto.fieldType][fieldValueMasterDto.fieldKeyCode] ? ctrl.fieldValueMapByKey[fieldMasterDto.fieldType][fieldValueMasterDto.fieldKeyCode].order : null;
                fieldValueMasterDto.required = ctrl.fieldValueMapByKey[fieldMasterDto.fieldType][fieldValueMasterDto.fieldKeyCode] ? ctrl.fieldValueMapByKey[fieldMasterDto.fieldType][fieldValueMasterDto.fieldKeyCode].required : false;
                switch (fieldValueMasterDto.fieldKeyCode) {
                    case 'events':
                        let events = JSON.parse(fieldValueMasterDto.defaultValue);
                        fieldMasterDto.events = events;
                        fieldValueMasterDto.defaultValue = JSON.parse(fieldValueMasterDto.defaultValue)
                        break;
                    case 'visibility':
                        if (typeof fieldValueMasterDto.defaultValue === 'string') {
                            let visibility = JSON.parse(fieldValueMasterDto.defaultValue);
                            fieldMasterDto.visibility = visibility;
                            fieldValueMasterDto.defaultValue = JSON.parse(fieldValueMasterDto.defaultValue)
                        } else {
                            fieldMasterDto.visibility = fieldValueMasterDto.defaultValue;
                        }
                        break;
                    case 'requirable':
                        if (typeof fieldValueMasterDto.defaultValue === 'string') {
                            let requirable = JSON.parse(fieldValueMasterDto.defaultValue);
                            fieldMasterDto.requirable = requirable;
                            fieldValueMasterDto.defaultValue = JSON.parse(fieldValueMasterDto.defaultValue)
                        } else {
                            fieldMasterDto.requirable = fieldValueMasterDto.defaultValue;
                        }
                        break;
                    case 'disability':
                        if (typeof fieldValueMasterDto.defaultValue === 'string') {
                            let disability = JSON.parse(fieldValueMasterDto.defaultValue);
                            fieldMasterDto.disability = disability;
                            fieldValueMasterDto.defaultValue = JSON.parse(fieldValueMasterDto.defaultValue)
                        } else {
                            fieldMasterDto.disability = fieldValueMasterDto.defaultValue;
                        }
                        break;
                    case 'staticOptions':
                        fieldMasterDto.staticOptions = fieldValueMasterDto.defaultValue;
                        fieldValueMasterDto.defaultValue = fieldValueMasterDto.defaultValue ? JSON.parse(fieldValueMasterDto.defaultValue) : null;
                        break;
                    case 'tableConfig':
                        fieldMasterDto.tableConfig = fieldValueMasterDto.defaultValue;
                        fieldValueMasterDto.defaultValue = fieldValueMasterDto.defaultValue ? JSON.parse(fieldValueMasterDto.defaultValue) : null;
                        break;
                }
            });
            fieldMasterDto.medplatFieldValueMasterDtos.sort((a, b) => (a.order === null) - (b.order === null) || (a.order - b.order));
            ctrl.modifyfieldConfigUi(fieldMasterDto, []);
            return fieldMasterDto;
        }

        ctrl._processFormConfig = function () {
            if (!ctrl.medplatFormConfig.medplatFieldMasterDtos || ctrl.medplatFormConfig.medplatFieldMasterDtos.length === 0) {
                ctrl.medplatFormConfig.medplatFieldMasterDtos = [];
                return;
            }
            ctrl.medplatFormConfig.medplatFieldMasterDtos.forEach(fieldMasterDto => {
                fieldMasterDto.medplatFieldValueMasterDtos = fieldMasterDto.medplatFieldValueMasterDtos ? fieldMasterDto.medplatFieldValueMasterDtos : [];
                fieldMasterDto = ctrl._processFormFieldConfig(fieldMasterDto);
            })
        };

        ctrl.getmedplatFormConfig = function () {
            ctrl.variableList = [];
            ctrl.dateFieldList = [];
            ctrl.dateTimeFieldList = [];
            ctrl.tableObject = [];
            ctrl.uniqueFieldNames = {};
            ctrl.jsonFieldNames = [];
            ctrl.filterDropdown = 'BOTH';
            ctrl.infoDataFieldCount = 0;
            ctrl.formDataFieldCount = 0;
            ctrl.searchString = "";
            ctrl.allFieldsWithNgModel = [];
            ctrl.formHasError = false;
            ctrl.formUtilitiesHasError = false;
            ctrl.formQueryConfigHasError = false;
            let promises = [];
            let dtoList = [];
            let getMenuItemsDto = {
                code: 'get_all_menus_for_system_constraint_form_config',
                parameters: {},
                sequence: 1
            };
            dtoList.push(getMenuItemsDto);
            promises.push(QueryDAO.executeAll(dtoList));
            if (ctrl.editMode) {
                promises.push(MedplatFormServiceV2.getMedplatFormConfigByUuidForEdit(ctrl.medplatFormUuid));
            }
            Mask.show();
            $q.all(promises).then(responses => {
                ctrl.menuItems = responses[0][0].result;
                if (ctrl.editMode) {
                    ctrl.medplatFormConfig = responses[1];
                    ctrl.fieldConfig = ctrl.medplatFormConfig.medplatFieldConfigs ? ctrl.medplatFormConfig.medplatFieldConfigs : {};
                    ctrl.formName = ctrl.medplatFormConfig.medplatFormMasterDto.formName;
                    ctrl.formMasterUUID = ctrl.medplatFormConfig.medplatFormMasterDto.uuid;
                    ctrl.formCode = ctrl.medplatFormConfig.medplatFormMasterDto.formCode;
                    ctrl.formFieldConfigData[ctrl.formCode] = {};
                    ctrl.fieldConfigDtos = ctrl.medplatFormConfig.medplatFieldConfigs !== null ? ctrl.medplatFormConfig.medplatFieldConfigs[ctrl.formCode] : null;
                    ctrl.fieldConfigDtosRetrieved = ctrl.medplatFormConfig.medplatFieldConfigs !== null ? JSON.parse(JSON.stringify(ctrl.medplatFormConfig.medplatFieldConfigs)) : null;
                    ctrl.tempMedplatFormMasterDto = [];
                    if (ctrl.medplatFormConfig.medplatFieldConfigs !== null) {
                        Object.keys(ctrl.fieldConfigDtos).forEach((config, index) => {
                            ctrl.uniqueFieldNames[index] = config;
                            ctrl.jsonFieldNames.push(config.toLowerCase());
                        });

                        for (config in ctrl.fieldConfigDtos) {
                            ctrl.tempMedplatFormMasterDto.push(ctrl.fieldConfigDtos[config]);
                            if (ctrl.fieldConfigDtos[config].fieldType === 'TABLE') {
                                ctrl.allFieldsWithNgModel.push(ctrl.fieldConfigDtos[config].tableObject);
                            } else {
                                ctrl.allFieldsWithNgModel.push(`${ctrl.fieldConfigDtos[config].ngModel}.${ctrl.fieldConfigDtos[config].fieldKey}`);
                            }
                        }
                    }
                    ctrl.medplatFormConfig.medplatFieldMasterDtos = ctrl.tempMedplatFormMasterDto;

                    ctrl.indexAliasesInFormObject = [...ctrl.extractIndexAliases(JSON.parse(ctrl.medplatFormConfig.medplatFormMasterDto.formObject) || [])];
                    ctrl.tableAvailableParameters = "Available Params : $formData$, $utilityData$, $infoData$, $stateParams$, $loggedInUserId$\n "
                    if (ctrl.indexAliasesInFormObject.length > 0) {
                        ctrl.tableAvailableParameters += "Available Indexes : ";
                        ctrl.tableAvailableParameters += ctrl.indexAliasesInFormObject.join(", ");
                    }

                    ctrl.formObjectGroupKeys = [];
                    ctrl.formObjectArrayKeysWithIndex = [];
                    ctrl.formObjectArrayKeysWithoutIndex = [];
                    ctrl.fieldValueDropdownOptionsByKey.variableList = [];
                    ctrl.fetchFromNodes(JSON.parse(ctrl.medplatFormConfig.medplatFormMasterDto.formObject), "");
                    ctrl.ngModelObjectKeys = MedplatFormConfiguratorUtil.filterFormStructureList([...ctrl.formObjectGroupKeys, ...ctrl.formObjectArrayKeysWithIndex], (item) => {
                        return item !== '$infoData$';
                    });

                    let bindToList = []
                    ctrl.ngModelObjectKeys.forEach(model => {
                        bindToList.push({
                            fieldKeyCode: model,
                            value: model,
                            valueType: 'TEXT',
                            required: true
                        })
                    })
                    ctrl.fieldValueDropdownOptionsByKey.ngModel = bindToList;
                    ctrl.fieldValueDropdownOptionsByKey.tableObject = ctrl.tableObject;

                    ctrl.setQueryBuilderList(ctrl.medplatFormConfig.medplatFormMasterDto.formVm);

                    ctrl.dateFieldList.push({
                        fieldKeyCode: JSON.stringify({
                            key: '$today$',
                            type: 'VARIABLE'
                        }),
                        value: '$today$',
                        valueType: 'TEXT',
                        required: true
                    });

                    ctrl.dateTimeFieldList.push({
                        fieldKeyCode: JSON.stringify({
                            key: '$today$',
                            type: 'VARIABLE'
                        }),
                        value: '$today$',
                        valueType: 'TEXT',
                        required: true
                    })

                    if (ctrl.medplatFormConfig.medplatFormMasterDto.formVm) {
                        ctrl.tempFormVm = JSON.parse(ctrl.medplatFormConfig.medplatFormMasterDto.formVm);
                        if (ctrl.tempFormVm.hasOwnProperty('formVariables')) {
                            ctrl.tempFormVm.formVariables.forEach((fv) => {
                                ctrl.variableList.push(`${fv.bindTo}.${fv.value}`);
                                ctrl.fieldValueDropdownOptionsByKey.variableList.push({
                                    fieldKeyCode: `${fv.bindTo}.${fv.value}`,
                                    value: `${fv.bindTo}.${fv.value}`,
                                    valueType: 'TEXT',
                                    required: true
                                })
                                if (fv.type === 'DATE') {
                                    ctrl.dateFieldList.push({
                                        fieldKeyCode: JSON.stringify({
                                            key: `${fv.bindTo}.${fv.value}`,
                                            type: 'VARIABLE'
                                        }),
                                        value: `${fv.bindTo}.${fv.value}`,
                                        valueType: 'TEXT',
                                        required: true
                                    })
                                }

                                if (fv.type === 'DATE_AND_TIME') {
                                    ctrl.dateTimeFieldList.push({
                                        fieldKeyCode: JSON.stringify({
                                            key: `${fv.bindTo}.${fv.value}`,
                                            type: 'VARIABLE'
                                        }),
                                        value: `${fv.bindTo}.${fv.value}`,
                                        valueType: 'TEXT',
                                        required: true
                                    })
                                }
                            })
                        }
                    }

                    for (prop in ctrl.fieldConfig[ctrl.formCode]) {
                        if (ctrl.fieldConfig[ctrl.formCode][prop].fieldType === 'DATE') {
                            ctrl.dateFieldList.push({
                                fieldKeyCode: JSON.stringify({
                                    key: `${ctrl.fieldConfig[ctrl.formCode][prop].ngModel}.${ctrl.fieldConfig[ctrl.formCode][prop].fieldKey}`,
                                    type: 'FIELD'
                                }),
                                value: `${ctrl.fieldConfig[ctrl.formCode][prop].ngModel}.${ctrl.fieldConfig[ctrl.formCode][prop].fieldKey}`,
                                valueType: 'TEXT',
                                required: true
                            })
                        }

                        if (ctrl.fieldConfig[ctrl.formCode][prop].fieldType === 'DATE_AND_TIME') {
                            ctrl.dateTimeFieldList.push({
                                fieldKeyCode: JSON.stringify({
                                    key: `${ctrl.fieldConfig[ctrl.formCode][prop].ngModel}.${ctrl.fieldConfig[ctrl.formCode][prop].fieldKey}`,
                                    type: 'FIELD'
                                }),
                                value: `${ctrl.fieldConfig[ctrl.formCode][prop].ngModel}.${ctrl.fieldConfig[ctrl.formCode][prop].fieldKey}`,
                                valueType: 'TEXT',
                                required: true
                            })
                        }
                    }
                    ctrl.fieldValueDropdownOptionsByKey.minDateField = ctrl.dateFieldList;
                    ctrl.fieldValueDropdownOptionsByKey.maxDateField = ctrl.dateFieldList;

                    ctrl.fieldValueDropdownOptionsByKey.minDateTimeField = ctrl.dateTimeFieldList;
                    ctrl.fieldValueDropdownOptionsByKey.maxDateTimeField = ctrl.dateTimeFieldList;

                    ctrl.fieldValueDropdownOptionsByKey.tableObject = ctrl.tableObject;

                    if (ctrl.editMode) {
                        ctrl.setQueryColumnNameMap();
                    }

                    ctrl._processFormConfig();
                    ctrl.filterChange(true);
                    ctrl.checkForErrorsInFields();
                    ctrl.formHasError = false;
                    ctrl.checkFormIntegrity();

                    ctrl.checkForErrorsInFormUtilities();
                    ctrl.checkForErrorsInFormBackend();
                }
            }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide);
        }

        ctrl.saveFormConfig = function () {
            ctrl.manageMedplatForm.$setSubmitted();
            if (ctrl.manageMedplatForm.$valid) {
                Mask.show();
                MedplatFormServiceV2.saveMedplatFormConfiguration(ctrl.medplatFormConfig.medplatFormMasterDto).then(response => {
                    $state.go("techo.admin.medplatForms");
                    toaster.pop("success", `Form Config Saved Successfully.`);
                }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide);
            }
        };

        ctrl.saveStableFormConfig = function () {
            var modalInstance = $uibModal.open({
                templateUrl: 'app/common/views/confirmation.modal.html',
                controller: 'ConfirmModalController',
                windowClass: 'cst-modal',
                size: 'med',
                resolve: {
                    message: function () {
                        return `This action will create a new stable version of <b>${ctrl.medplatFormConfig.medplatFormMasterDto.formCode}</b>.`;
                    }
                }
            });
            modalInstance.result.then(function () {
                let dto = {
                    formMasterUuid: ctrl.medplatFormConfig.medplatFormMasterDto.uuid,
                    versionHistoryUuid: ctrl.medplatFormConfig.medplatFormMasterDto.versionHistoryUUID
                }
                Mask.show();
                MedplatFormServiceV2.saveMedplatFormConfigurationStable(dto).then(response => {
                    toaster.pop("success", `Form Stable Config Saved Successfully.`);
                }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide);
            }, function () {
            });
        }

        ctrl.getfieldKeyWithfieldType = function (fieldName, fieldType) {
            return fieldName;
        }

        ctrl.saveFieldConfig = function (index, fieldConfig, isFieldJson) {
            let fieldConfigObject = {};

            if (!ctrl.currentFieldConfigObject.fieldType && ctrl.currentFieldConfigTypeManual) {
                toaster.pop("error", "Please select field type first.");
                return;
            }

            ctrl.addEditFieldForm.$setSubmitted();

            if (ctrl.currentFieldConfigTypeManual) {
                let events = ctrl.currentFieldConfigObject.medplatFieldValueMasterDtos.find(dto => dto.fieldKeyCode === 'events');
                if (events && events.defaultValue !== null) {
                    if (!['CUSTOM_HTML', 'CUSTOM_COMPONENT', 'TABLE', 'INFORMATION_DISPLAY', 'FILE_UPLOAD'].includes(ctrl.currentFieldConfigObject.fieldType) && fieldConfig.fieldType) {
                        ctrl.saveCurrentEvents(fieldConfig);
                    }
                }
                let valid = true;
                Object.keys(ctrl.uniqueFieldNames).forEach((id, idx) => {
                    if (index != idx) {
                        if (ctrl.uniqueFieldNames[id] == fieldConfig.fieldName) {
                            if (isFieldJson) {
                                toaster.pop('error', 'Field name already exist')
                            }
                            else {
                                ctrl.addEditFieldForm.basicConfiguration['defaultValuefieldName' + index].$setValidity('Duplicate Field Name', false);
                            }
                            valid = false;
                        }
                    }
                })
                if (valid) {
                    ctrl.addEditFieldForm.basicConfiguration['defaultValuefieldName' + index].$setValidity('Duplicate Field Name', true);
                } else {
                    return;
                }
                if (!ctrl.addEditFieldForm.basicConfiguration.$valid) {
                    ctrl.currentFieldConfigTab = 'manage-field-basic-configuration';
                    return;
                }
                if (!['CUSTOM_HTML',  'CUSTOM_COMPONENT', 'TABLE', 'INFORMATION_DISPLAY',  'FILE_UPLOAD'].includes(fieldConfig.fieldType)) {
                    if (!ctrl.addEditFieldForm.eventsForm.$valid) {
                        ctrl.currentFieldConfigTab = 'manage-field-events-configuration';
                        return;
                    }
                }
                if (!['CUSTOM_HTML',  'CUSTOM_COMPONENT'].includes(fieldConfig.fieldType)) {
                    if (!ctrl.addEditFieldForm.visibilityConfiguration.$valid) {
                        ctrl.currentFieldConfigTab = 'manage-field-visibility-configuration';
                        return;
                    }
                }
                if (!['CUSTOM_HTML',  'CUSTOM_COMPONENT', 'TABLE', 'INFORMATION_DISPLAY'].includes(fieldConfig.fieldType)) {
                    if (!ctrl.addEditFieldForm.disabilityConfiguration.$valid) {
                        ctrl.currentFieldConfigTab = 'manage-field-disability-configuration';
                        return;
                    }
                }
                if (!['CUSTOM_HTML',  'CUSTOM_COMPONENT', 'TABLE', 'INFORMATION_DISPLAY', 'BUTTON',  'ADDED_LOCATIONS',  'FILE_UPLOAD'].includes(fieldConfig.fieldType))  {
                    if (!ctrl.addEditFieldForm.requirableConfiguration.$valid) {
                        ctrl.currentFieldConfigTab = 'manage-field-requirable-configuration';
                        return;
                    }
                }
            }

            if (!ctrl.addEditFieldForm.$valid) {
                return;
            }

            ctrl.formFieldConfigData[ctrl.formCode] = {};

            let fieldConfigRetrieved = ctrl.fieldConfigDtosRetrieved ? JSON.parse(JSON.stringify(ctrl.fieldConfigDtosRetrieved)) : ctrl.formFieldConfigData;

            if (ctrl.currentFieldConfigTypeManual) {
                let jsonData = JSON.stringify(ctrl.generateJSONFromCurrentObject(ctrl.currentFieldConfigObject));
                let currentObject = JSON.parse(jsonData);
                if (currentObject.hasOwnProperty('events')) {
                    currentObject.events = typeof currentObject.events === 'object' ? JSON.stringify(currentObject.events) : currentObject.events;
                }
                if (currentObject.hasOwnProperty('visibility')) {
                    currentObject.visibility = typeof currentObject.visibility === 'object' ? JSON.stringify(currentObject.visibility) : currentObject.visibility;
                }
                if (currentObject.hasOwnProperty('disability')) {
                    currentObject.disability = typeof currentObject.disability === 'object' ? JSON.stringify(currentObject.disability) : currentObject.disability;
                }
                if (currentObject.hasOwnProperty('requirable')) {
                    currentObject.requirable = typeof currentObject.requirable === 'object' ? JSON.stringify(currentObject.requirable) : currentObject.requirable;
                }
                if (currentObject.hasOwnProperty('tableConfig')) {
                    currentObject.tableConfig = typeof currentObject.tableConfig === 'object' ? JSON.stringify(currentObject.tableConfig) : currentObject.tableConfig;
                }
                if (currentObject.hasOwnProperty('staticOptions')) {
                    currentObject.staticOptions = currentObject.staticOptions === null ? currentObject.staticOptions : typeof currentObject.staticOptions === 'object' ? JSON.stringify(currentObject.staticOptions) : currentObject.staticOptions;
                }
                if (currentObject.hasOwnProperty('minDateField')) {
                    currentObject.minDateField = typeof currentObject.minDateField === 'object' ? JSON.stringify(currentObject.minDateField) : currentObject.minDateField;
                }
                if (currentObject.hasOwnProperty('maxDateField')) {
                    currentObject.maxDateField = typeof currentObject.maxDateField === 'object' ? JSON.stringify(currentObject.maxDateField) : currentObject.maxDateField;
                }
                if (currentObject.hasOwnProperty('minDateTimeField')) {
                    currentObject.minDateTimeField = typeof currentObject.minDateTimeField === 'object' ? JSON.stringify(currentObject.minDateTimeField) : currentObject.minDateTimeField;
                }
                if (currentObject.hasOwnProperty('maxDateTimeField')) {
                    currentObject.maxDateTimeField = typeof currentObject.maxDateTimeField === 'object' ? JSON.stringify(currentObject.maxDateTimeField) : currentObject.maxDateTimeField;
                }
                fieldConfigObject = currentObject;
            }

            if (ctrl.currentFieldConfigTypeJson) {
                let currentObject = JSON.parse(ctrl.currentFieldConfigObjectJSON);
                if (currentObject.hasOwnProperty('events')) {
                    currentObject.events = typeof currentObject.events === 'object' ? JSON.stringify(currentObject.events) : currentObject.events;
                }
                if (currentObject.hasOwnProperty('visibility')) {
                    currentObject.visibility = typeof currentObject.visibility === 'object' ? JSON.stringify(currentObject.visibility) : currentObject.visibility;
                }
                if (currentObject.hasOwnProperty('disability')) {
                    currentObject.disability = typeof currentObject.disability === 'object' ? JSON.stringify(currentObject.disability) : currentObject.disability;
                }
                if (currentObject.hasOwnProperty('requirable')) {
                    currentObject.requirable = typeof currentObject.requirable === 'object' ? JSON.stringify(currentObject.requirable) : currentObject.requirable;
                }
                if (currentObject.hasOwnProperty('tableConfig')) {
                    currentObject.tableConfig = typeof currentObject.tableConfig === 'object' ? JSON.stringify(currentObject.tableConfig) : currentObject.tableConfig;
                }
                if (currentObject.hasOwnProperty('staticOptions')) {
                    currentObject.staticOptions = currentObject.staticOptions === null ? currentObject.staticOptions : typeof currentObject.staticOptions === 'object' ? JSON.stringify(currentObject.staticOptions) : currentObject.staticOptions;
                }
                if (currentObject.hasOwnProperty('minDateField')) {
                    currentObject.minDateField = typeof currentObject.minDateField === 'object' ? JSON.stringify(currentObject.minDateField) : currentObject.minDateField;
                }
                if (currentObject.hasOwnProperty('maxDateField')) {
                    currentObject.maxDateField = typeof currentObject.maxDateField === 'object' ? JSON.stringify(currentObject.maxDateField) : currentObject.maxDateField;
                }
                if (currentObject.hasOwnProperty('minDateTimeField')) {
                    currentObject.minDateTimeField = typeof currentObject.minDateTimeField === 'object' ? JSON.stringify(currentObject.minDateTimeField) : currentObject.minDateTimeField;
                }
                if (currentObject.hasOwnProperty('maxDateTimeField')) {
                    currentObject.maxDateTimeField = typeof currentObject.maxDateTimeField === 'object' ? JSON.stringify(currentObject.maxDateTimeField) : currentObject.maxDateTimeField;
                }
                fieldConfigObject = currentObject;
            }
            // let uuidUnique = true;
            if (fieldConfigRetrieved) {
                // Object.keys(fieldConfigRetrieved[ctrl.formCode]).forEach(field => {
                //     if (fieldConfigRetrieved[ctrl.formCode][field].uuid === fieldConfigObject.uuid && fieldConfigRetrieved[ctrl.formCode][field].fieldName !== fieldConfigObject.fieldName) {
                //         uuidUnique = false;
                //     }
                // });
                if (fieldConfigRetrieved[ctrl.formCode].hasOwnProperty(fieldConfigObject.fieldName)) {
                    delete fieldConfigRetrieved[ctrl.formCode][fieldConfigObject.fieldName];
                }
            }
            fieldConfigRetrieved[ctrl.formCode][fieldConfigObject.fieldName] = fieldConfigObject;

            // if (!uuidUnique) {
            //     toaster.pop("error", "Field uuid is already used");
            //     return;
            // }

            ctrl.fieldConfigJsonString = JSON.stringify(fieldConfigRetrieved);
            ctrl.medplatFormConfig.medplatFormMasterDto.fieldConfig = ctrl.fieldConfigJsonString;
            ctrl.medplatFormConfig.medplatFormMasterDto.formMasterUuid = ctrl.medplatFormConfig.medplatFormMasterDto.uuid;

            Mask.show();
            MedplatFormServiceV2.updateMedplatFormConfigurationAsDraft(ctrl.medplatFormConfig.medplatFormMasterDto).then(response => {
                toaster.pop("success", `Field Config Saved Successfully.`);
                ctrl.closeEditOrAddFieldModal();
                ctrl.getmedplatFormConfig();
            }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide);
        };

        ctrl.addFieldConfig = function () {
            if (!ctrl.medplatFormConfig.medplatFieldMasterDtos) {
                ctrl.medplatFormConfig.medplatFieldMasterDtos = [];
            }
            ctrl.medplatFormConfig.medplatFieldMasterDtos.push({
                fieldKey: null,
                fieldName: null,
                fieldType: null,
                standardFieldMasterId: null,
                medplatFieldValueMasterDtos: [],
                showCard: true
            });
        };

        ctrl.removeFieldConfigModal = function (index, fieldConfigUuid, fieldKey, fieldType, fieldName) {
            ctrl.showWhenEventDialogOpened = true;
            var modalInstance = $uibModal.open({
                templateUrl: 'app/common/views/confirmation.modal.html',
                controller: 'ConfirmModalController',
                windowClass: 'cst-modal',
                size: 'med',
                resolve: {
                    message: function () {
                        return `Are you sure you want to delete <b>${fieldName} (${fieldType})</b> field?`;
                    }
                }
            });
            modalInstance.result.then(function () {
                if (Object.keys(ctrl.fieldConfig).length !== 0) {
                    ctrl.formFieldConfigData = { ...ctrl.fieldConfig };
                }
                delete ctrl.formFieldConfigData[ctrl.formCode][ctrl.getfieldKeyWithfieldType(fieldName, fieldType)];
                if (!fieldConfigUuid) {
                    ctrl.medplatFormConfig.medplatFieldMasterDtos.splice(index, 1);
                }

                ctrl.cloneFormFieldConfigData = JSON.parse(JSON.stringify(ctrl.formFieldConfigData));

                for (property in ctrl.cloneFormFieldConfigData[ctrl.formCode]) {
                    if (ctrl.cloneFormFieldConfigData[ctrl.formCode][property].hasOwnProperty('medplatFieldValueMasterDtos')) {
                        delete ctrl.cloneFormFieldConfigData[ctrl.formCode][property].medplatFieldValueMasterDtos;
                    }
                    if (ctrl.cloneFormFieldConfigData[ctrl.formCode][property].hasOwnProperty('$$hashKey')) {
                        delete ctrl.cloneFormFieldConfigData[ctrl.formCode][property].$$hashKey;
                    }
                }

                for (property in ctrl.cloneFormFieldConfigData[ctrl.formCode]) {
                    if (ctrl.cloneFormFieldConfigData[ctrl.formCode][property].hasOwnProperty("events")) {
                        if (typeof ctrl.cloneFormFieldConfigData[ctrl.formCode][property].events !== 'string') {
                            ctrl.cloneFormFieldConfigData[ctrl.formCode][property].events = JSON.stringify(ctrl.cloneFormFieldConfigData[ctrl.formCode][property].events);
                        }
                    }
                    if (ctrl.cloneFormFieldConfigData[ctrl.formCode][property].hasOwnProperty("disability")) {
                        if (typeof ctrl.cloneFormFieldConfigData[ctrl.formCode][property].disability === 'object') {
                            ctrl.cloneFormFieldConfigData[ctrl.formCode][property].disability = JSON.stringify(ctrl.cloneFormFieldConfigData[ctrl.formCode][property].disability);
                        }
                    }
                    if (ctrl.cloneFormFieldConfigData[ctrl.formCode][property].hasOwnProperty("visibility")) {
                        if (typeof ctrl.cloneFormFieldConfigData[ctrl.formCode][property].visibility === 'object') {
                            ctrl.cloneFormFieldConfigData[ctrl.formCode][property].visibility = JSON.stringify(ctrl.cloneFormFieldConfigData[ctrl.formCode][property].visibility);
                        }
                    }
                    if (ctrl.cloneFormFieldConfigData[ctrl.formCode][property].hasOwnProperty("requirable")) {
                        if (typeof ctrl.cloneFormFieldConfigData[ctrl.formCode][property].requirable === 'object') {
                            ctrl.cloneFormFieldConfigData[ctrl.formCode][property].requirable = JSON.stringify(ctrl.cloneFormFieldConfigData[ctrl.formCode][property].requirable);
                        }
                    }
                    if (ctrl.cloneFormFieldConfigData[ctrl.formCode][property].hasOwnProperty("listValueField")) {
                        ctrl.cloneFormFieldConfigData[ctrl.formCode][property].listValueFieldValue = ctrl.cloneFormFieldConfigData[ctrl.formCode][property].listValueFieldValue ? ctrl.cloneFormFieldConfigData[ctrl.formCode][property].listValueFieldValue : ctrl.listValueFieldValueObjectMap[ctrl.formFieldConfigData[ctrl.formCode][property].listValueField];
                    } else if (ctrl.cloneFormFieldConfigData[ctrl.formCode][property].hasOwnProperty("queryBuilder")) {
                        ctrl.cloneFormFieldConfigData[ctrl.formCode][property].queryBuilder = ctrl.cloneFormFieldConfigData[ctrl.formCode][property].queryBuilder;
                    }
                }
                ctrl.fieldConfigJsonString = JSON.stringify(ctrl.cloneFormFieldConfigData);
                ctrl.medplatFormConfig.medplatFormMasterDto.fieldConfig = ctrl.fieldConfigJsonString;
                ctrl.medplatFormConfig.medplatFormMasterDto.formMasterUuid = ctrl.medplatFormConfig.medplatFormMasterDto.uuid;
                Mask.show();
                MedplatFormServiceV2.updateMedplatFormConfigurationAsDraft(ctrl.medplatFormConfig.medplatFormMasterDto).then(response => {
                    toaster.pop("success", `Field Config Removed Successfully.`);
                    ctrl.closeEditOrAddFieldModal();
                    ctrl.showWhenEventDialogOpened = false;
                    ctrl.getmedplatFormConfig();
                }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide);
            }, function () {
                ctrl.showWhenEventDialogOpened = false;
            });
        };

        ctrl.removeFieldConfig = function (index, fieldConfigUuid, fieldKey, fieldType, fieldName) {
            if (ctrl.currentFieldConfigTypeJson) {
                toaster.pop('error', 'Go to Manual Confguration first.')
                return;
            }
            ctrl.addEditFieldForm.$setSubmitted();
            if (ctrl.addEditFieldForm.$valid && ctrl.currentFieldConfigObject.fieldType !== null) {
                ctrl.removeFieldConfigModal(index, fieldConfigUuid, fieldKey, fieldType, fieldName);
            } else {
                ctrl.medplatFormConfig.medplatFieldMasterDtos.splice(index, 1);
                ctrl.closeEditOrAddFieldModal();
                return;
            }
        };

        ctrl.onFieldNameChanged = (index, fieldConfig, fieldName) => {
            fieldConfig.fieldName = fieldName;
            // const replacedString = fieldName ? fieldName.replace(/(?:^\w|[A-Z]|\b\w)/g, (word, i) => {
            //     return i == 0 ? word.toLowerCase() : word.toUpperCase();
            // }).replace(/\s+/g, '') : null;
            // let labelKey = replacedString.concat('_' + ctrl.medplatFormConfig.medplatFormMasterDto.formCode);
            // let field = ctrl.medplatFormConfig.medplatFieldMasterDtos[index];
            // let labelIndex = field.medplatFieldValueMasterDtos.findIndex(e => e.fieldKeyCode === 'label');
            // let label = field.medplatFieldValueMasterDtos[labelIndex];
            // if (label) label.defaultValue = labelKey;
        }

        ctrl.onFieldTypeChange = function (index, fieldType, currentFieldObject) {
            let formMasterDto = ctrl.medplatFormConfig.medplatFormMasterDto;
            let fieldMasterDto = currentFieldObject;
            let fieldValueMasterDtos = currentFieldObject.medplatFieldValueMasterDtos;
            if (fieldType === 'TABLE') {
                fieldMasterDto.fieldKey = fieldType;
            } else {
                fieldMasterDto.fieldKey = fieldMasterDto.fieldName = null;
            }

            if (fieldMasterDto.hasOwnProperty('queryBuilder')) {
                delete fieldMasterDto.queryBuilder;
            }
            if (fieldMasterDto.hasOwnProperty('listValueField')) {
                delete fieldMasterDto.listValueField;
            }

            if (fieldValueMasterDtos && fieldValueMasterDtos.length) {
                fieldValueMasterDtos.forEach(fieldValueMasterDto => {
                    if (fieldValueMasterDto.uuid) {
                        if (!fieldMasterDto.fieldValueUuidsToBeRemoved) {
                            fieldMasterDto.fieldValueUuidsToBeRemoved = [];
                        }
                        fieldMasterDto.fieldValueUuidsToBeRemoved.push(fieldValueMasterDto.uuid);
                    }
                })
            }
            fieldMasterDto.medplatFieldValueMasterDtos = [];
            if (fieldType) {
                ctrl.fieldValueMap[fieldMasterDto.fieldType].forEach(fieldValueConfig => fieldMasterDto.medplatFieldValueMasterDtos.push({
                    fieldKeyCode: fieldValueConfig.fieldKeyCode,
                    fieldKeyName: fieldValueConfig.fieldKeyName,
                    valueType: fieldValueConfig.fieldKeyValueType,
                    value: null,
                    defaultValue: fieldValueConfig.defaultValue,
                    overrideValue: false,
                    order: fieldValueConfig.order,
                    required: fieldValueConfig.isRequired
                }));
                ctrl.modifyfieldConfigUi(fieldMasterDto, []);
            }
        };

        ctrl.onFieldValueDropdownOptionChange = function (index, fieldValueConfig, currentFieldObject) {
            let fieldMasterDto = currentFieldObject;
            let fieldValueMasterDtos = currentFieldObject.medplatFieldValueMasterDtos;
            switch (fieldValueConfig.fieldKeyCode) {
                case 'optionsType':
                    fieldMasterDto.medplatFieldValueMasterDtos.forEach(field => {
                        if (ctrl.removeQueryParamsFieldList[fieldMasterDto.fieldName]?.includes(field.fieldKeyName)) {
                            field.showInUI = false;
                        }
                    })
                    ctrl.fieldValueDropdownOptionsByKey[fieldValueConfig.fieldKeyCode].forEach(option => {
                        if (fieldValueConfig.value === option.fieldKeyCode || fieldValueConfig.defaultValue === option.fieldKeyCode) {
                            if (!fieldValueMasterDtos.find(filedValueMasterDto => filedValueMasterDto.fieldKeyCode === option.fieldKeyCode)) {
                                fieldValueMasterDtos.push({
                                    fieldKeyCode: option.fieldKeyCode,
                                    fieldKeyName: option.value,
                                    valueType: option.valueType,
                                    showInUI: true,
                                    required: option.required
                                })
                            } else {
                                if (fieldMasterDto.fieldType === 'DROPDOWN') {
                                    let fieldVal = fieldValueMasterDtos.find(filedValueMasterDto => filedValueMasterDto.fieldKeyCode === option.fieldKeyCode);
                                    fieldVal.showInUI = true;
                                }
                            }
                        } else {
                            fieldValueMasterDtos = fieldValueMasterDtos.filter(fieldValueMasterDto => {
                                if (fieldValueMasterDto.fieldKeyCode !== option.fieldKeyCode) {
                                    return true;
                                }
                                if (fieldValueMasterDto.uuid) {
                                    if (!fieldMasterDto.fieldValueUuidsToBeRemoved) {
                                        fieldMasterDto.fieldValueUuidsToBeRemoved = [];
                                    }
                                    fieldMasterDto.fieldValueUuidsToBeRemoved.push(fieldValueMasterDto.uuid);
                                }
                                return false;
                            });
                            if (["DROPDOWN", "CB", "SCB", "MS", "SRBD"].includes(fieldMasterDto.fieldType)) {
                                let additionalStaticOptionsRequired = fieldValueMasterDtos.find(filedValueMasterDto => filedValueMasterDto.fieldKeyCode === 'additionalStaticOptionsRequired');
                                additionalStaticOptionsRequired.defaultValue = 'false';
                                additionalStaticOptionsRequired.value = null;
                            }
                        }
                    })
                    if (fieldMasterDto.fieldType === 'DROPDOWN') {
                        if (fieldValueConfig.defaultValue == 'staticOptions') {
                            let additionalStaticOptionsRequired = fieldValueMasterDtos.find(filedValueMasterDto => filedValueMasterDto.fieldKeyCode === 'additionalStaticOptionsRequired');
                            additionalStaticOptionsRequired.defaultValue = 'false';
                            additionalStaticOptionsRequired.showInUI = false;
                            additionalStaticOptionsRequired.value = null;

                            let staticOptions = fieldValueMasterDtos.find(filedValueMasterDto => filedValueMasterDto.fieldKeyCode === 'staticOptions');
                            staticOptions.showInUI = true;
                        } else {
                            let additionalStaticOptionsRequired = fieldValueMasterDtos.find(filedValueMasterDto => filedValueMasterDto.fieldKeyCode === 'additionalStaticOptionsRequired');
                            additionalStaticOptionsRequired.defaultValue = 'false';
                            additionalStaticOptionsRequired.showInUI = true;
                            additionalStaticOptionsRequired.value = null;
                        }
                    }
                    currentFieldObject.medplatFieldValueMasterDtos = fieldValueMasterDtos;
                    break;
                case 'buttonLabelType':
                    if (fieldValueConfig.value === 'text' || fieldValueConfig.defaultValue === 'text') {
                        if (!fieldValueMasterDtos.find(filedValueMasterDto => filedValueMasterDto.fieldKeyCode === 'label')) {
                            fieldValueMasterDtos.push({
                                fieldKeyCode: 'label',
                                fieldKeyName: 'Label Key',
                                valueType: 'TEXT',
                                showInUI: true,
                                required: true
                            })
                        }
                        fieldValueMasterDtos = fieldValueMasterDtos.filter(fieldValueMasterDto => {
                            if (fieldValueMasterDto.fieldKeyCode !== 'icon') {
                                return true;
                            }
                            if (fieldValueMasterDto.uuid) {
                                if (!fieldMasterDto.fieldValueUuidsToBeRemoved) {
                                    fieldMasterDto.fieldValueUuidsToBeRemoved = [];
                                }
                                fieldMasterDto.fieldValueUuidsToBeRemoved.push(fieldValueMasterDto.uuid);
                            }
                            return false;
                        });
                    } else if (fieldValueConfig.value === 'icon' || fieldValueConfig.defaultValue === 'icon') {
                        if (!fieldValueMasterDtos.find(filedValueMasterDto => filedValueMasterDto.fieldKeyCode === 'icon')) {
                            fieldValueMasterDtos.push({
                                fieldKeyCode: 'icon',
                                fieldKeyName: 'Icon',
                                valueType: 'TEXT',
                                showInUI: true,
                                required: true
                            })
                        }
                        fieldValueMasterDtos = fieldValueMasterDtos.filter(fieldValueMasterDto => {
                            if (fieldValueMasterDto.fieldKeyCode !== 'label') {
                                return true;
                            }
                            if (fieldValueMasterDto.uuid) {
                                if (!fieldMasterDto.fieldValueUuidsToBeRemoved) {
                                    fieldMasterDto.fieldValueUuidsToBeRemoved = [];
                                }
                                fieldMasterDto.fieldValueUuidsToBeRemoved.push(fieldValueMasterDto.uuid);
                            }
                            return false;
                        });
                    } else if (fieldValueConfig.value === 'textAndIcon' || fieldValueConfig.defaultValue === 'textAndIcon') {
                        if (!fieldValueMasterDtos.find(filedValueMasterDto => filedValueMasterDto.fieldKeyCode === 'label')) {
                            fieldValueMasterDtos.push({
                                fieldKeyCode: 'label',
                                fieldKeyName: 'Label Key',
                                valueType: 'TEXT',
                                showInUI: true,
                                required: true
                            })
                        }
                        if (!fieldValueMasterDtos.find(filedValueMasterDto => filedValueMasterDto.fieldKeyCode === 'icon')) {
                            fieldValueMasterDtos.push({
                                fieldKeyCode: 'icon',
                                fieldKeyName: 'Icon',
                                valueType: 'TEXT',
                                showInUI: true,
                                required: true
                            })
                        }
                    } else {
                        fieldValueMasterDtos = fieldValueMasterDtos.filter(fieldValueMasterDto => {
                            if (fieldValueMasterDto.fieldKeyCode !== 'label' && fieldValueMasterDto.fieldKeyCode !== 'icon') {
                                return true;
                            }
                            if (fieldValueMasterDto.uuid) {
                                if (!fieldMasterDto.fieldValueUuidsToBeRemoved) {
                                    fieldMasterDto.fieldValueUuidsToBeRemoved = [];
                                }
                                fieldMasterDto.fieldValueUuidsToBeRemoved.push(fieldValueMasterDto.uuid);
                            }
                            return false;
                        });
                    }
                    currentFieldObject.medplatFieldValueMasterDtos = fieldValueMasterDtos;
                    break;
                case 'queryBuilder':
                    fieldMasterDto.medplatFieldValueMasterDtos.forEach(field => {
                        if (ctrl.removeQueryParamsFieldList[fieldMasterDto.fieldName]?.includes(field.fieldKeyName)) {
                            field.showInUI = false;
                        }
                    })
                    if (ctrl.fieldValueDropdownOptionsByKey[fieldValueConfig.defaultValue] != undefined && ctrl.fieldValueDropdownOptionsByKey[fieldValueConfig.defaultValue].length > 0) {
                        ctrl.fieldValueDropdownOptionsByKey[fieldValueConfig.defaultValue].forEach((params) => {
                            fieldValueMasterDtos.push(params);
                        })
                    }
                    if (ctrl.prevQueryBuilderCode != null) {
                        let prevQueryCode = ctrl.prevQueryBuilderCode;
                        currentFieldObject.medplatFieldValueMasterDtos = ctrl.removeExtraFieldsFrom(prevQueryCode, fieldValueMasterDtos);
                    }
                    ctrl.prevQueryBuilderCode = fieldValueConfig.defaultValue;
                    break;
                case 'displayType':
                    let dateFormatIndex = fieldValueMasterDtos.findIndex(filedValueMasterDto => filedValueMasterDto.fieldKeyCode === 'dateFormat')
                    if (fieldValueConfig.defaultValue === 'date') {
                        if (dateFormatIndex === -1) {
                            fieldValueMasterDtos.push({
                                fieldKeyCode: 'dateFormat',
                                fieldKeyName: 'Date format',
                                valueType: 'TEXT',
                                showInUI: true,
                                required: true
                            })
                        }
                    } else {
                        if (dateFormatIndex !== -1) {
                            fieldValueMasterDtos.splice(dateFormatIndex, 1);
                        }
                    }
                    currentFieldObject.medplatFieldValueMasterDtos = fieldValueMasterDtos;
                    break;
                default:
                    break;
            }
        };

        ctrl.removeExtraFieldsFrom = function (queryCode, fieldValueMasterDtos) {
            let list = [];
            fieldValueMasterDtos.forEach((dto) => {
                if (dto.hasOwnProperty('forQueryCode')) {
                    if (dto.forQueryCode !== queryCode) {
                        list.push(dto);
                    }
                } else {
                    list.push(dto);
                }
            })
            return list;
        };

        ctrl.onFieldValueRadioOptionChanged = function (index, fieldValueConfig, currentFieldObject) {
            let fieldMasterDto = currentFieldObject;
            let fieldValueMasterDtos = currentFieldObject.medplatFieldValueMasterDtos;
            switch (fieldMasterDto.fieldType) {
                case 'SHORT_TEXT':
                case 'LONG_TEXT':
                case 'PASSWORD':
                case 'NUMBER':
                    if (fieldValueConfig.fieldKeyCode === 'hasPattern') {
                        if (fieldValueConfig.value === 'true' || fieldValueConfig.defaultValue === 'true') {
                            if (!fieldValueMasterDtos.find(filedValueMasterDto => filedValueMasterDto.fieldKeyCode === 'pattern')) {
                                fieldValueMasterDtos.push({
                                    fieldKeyCode: 'pattern',
                                    fieldKeyName: 'Pattern',
                                    valueType: 'TEXT',
                                    showInUI: true,
                                    required: 'true'
                                });
                            } else {
                                let pattern = fieldValueMasterDtos.find(filedValueMasterDto => filedValueMasterDto.fieldKeyCode === 'pattern');
                                pattern.showInUI = true;
                                pattern.required = 'true';
                            }
                            if (!fieldValueMasterDtos.find(filedValueMasterDto => filedValueMasterDto.fieldKeyCode === 'patternMessage')) {
                                fieldValueMasterDtos.push({
                                    fieldKeyCode: 'patternMessage',
                                    fieldKeyName: 'Pattern Message',
                                    valueType: 'TEXT',
                                    showInUI: true,
                                    required: 'true'
                                })
                            } else {
                                let patternMessage = fieldValueMasterDtos.find(filedValueMasterDto => filedValueMasterDto.fieldKeyCode === 'patternMessage');
                                patternMessage.showInUI = true;
                                patternMessage.required = 'true';
                            }
                        } else {
                            fieldValueMasterDtos = fieldValueMasterDtos.filter(fieldValueMasterDto => {
                                if (fieldValueMasterDto.fieldKeyCode !== 'pattern' && fieldValueMasterDto.fieldKeyCode !== 'patternMessage') {
                                    return true;
                                }
                                if (fieldValueMasterDto.uuid) {
                                    if (!fieldMasterDto.fieldValueUuidsToBeRemoved) {
                                        fieldMasterDto.fieldValueUuidsToBeRemoved = [];
                                    }
                                    fieldMasterDto.fieldValueUuidsToBeRemoved.push(fieldValueMasterDto.uuid);
                                }
                                return false;
                            });
                        }
                    }
                    currentFieldObject.medplatFieldValueMasterDtos = fieldValueMasterDtos;
                    break;
                case 'RADIO':
                    let statOp = fieldMasterDto.medplatFieldValueMasterDtos.find(element => { return element.fieldKeyCode === 'staticOptions' });
                    if (fieldValueConfig.fieldKeyCode === 'isBoolean') {
                        if (fieldValueConfig.defaultValue === 'true') {
                            statOp.showInUI = false;
                            statOp.defaultValue = JSON.parse('[{"key":"true","value":"Yes"},{"key":"false","value":"No"}]');
                        } else {
                            statOp.showInUI = true;
                            statOp.defaultValue = null;
                        }
                    }
                case 'DROPDOWN':
                case 'CB':
                case 'SCB':
                case 'MS':
                case 'SRBD':
                    if (fieldValueConfig.fieldKeyCode === 'additionalStaticOptionsRequired') {
                        if (fieldValueConfig.value == 'true' || fieldValueConfig.defaultValue == 'true') {
                            if (!fieldValueMasterDtos.find(filedValueMasterDto => filedValueMasterDto.fieldKeyCode === 'staticOptions')) {
                                fieldValueMasterDtos.push({
                                    fieldKeyCode: 'staticOptions',
                                    fieldKeyName: 'Static Options',
                                    valueType: 'JSON',
                                    showInUI: true
                                });
                            } else {
                                let staticOption = fieldValueMasterDtos.find(filedValueMasterDto => filedValueMasterDto.fieldKeyCode === 'staticOptions');
                                staticOption.showInUI = true;
                            }
                        } else {
                            let optionsType = fieldValueMasterDtos.find(filedValueMasterDto => filedValueMasterDto.fieldKeyCode === 'optionsType');
                            if (optionsType.value !== 'staticOptions' && optionsType.defaultValue !== 'staticOptions') {
                                fieldValueMasterDtos = fieldValueMasterDtos.filter(fieldValueMasterDto => {
                                    if (fieldValueMasterDto.fieldKeyCode !== 'staticOptions') {
                                        return true;
                                    }
                                    if (fieldValueMasterDto.uuid) {
                                        if (!fieldMasterDto.fieldValueUuidsToBeRemoved) {
                                            fieldMasterDto.fieldValueUuidsToBeRemoved = [];
                                        }
                                        fieldMasterDto.fieldValueUuidsToBeRemoved.push(fieldValueMasterDto.uuid);
                                    }
                                    return false;
                                });
                            }
                        }
                    }
                    currentFieldObject.medplatFieldValueMasterDtos = fieldValueMasterDtos;
                    break;
                case 'TABLE':
                    if (fieldValueConfig.value == 'true' || fieldValueConfig.defaultValue == 'true') {
                        if (!fieldValueMasterDtos.find(filedValueMasterDto => filedValueMasterDto.fieldKeyCode === 'queryBuilderForPagination')) {
                            fieldValueMasterDtos.push({
                                fieldKeyCode: 'queryBuilderForPagination',
                                fieldKeyName: 'Query Builder Code For Pagination',
                                valueType: 'DROPDOWN',
                                showInUI: true,
                                required: true

                            });
                        } else {
                            let queryBuilder = fieldValueMasterDtos.find(filedValueMasterDto => filedValueMasterDto.fieldKeyCode === 'queryBuilderForPagination');
                            queryBuilder.showInUI = true;
                        }
                    } else {
                        let queryBuilder = fieldValueMasterDtos.find(filedValueMasterDto => filedValueMasterDto.fieldKeyCode === 'queryBuilderForPagination');
                        if (queryBuilder) {
                            queryBuilder.showInUI = false;
                        }
                    }
                    break;
                default:
                    break;
            }
        }

        ctrl.onOverrideValueSelection = function (fieldValueConfig, fieldConfig) {
            if (!fieldValueConfig.overrideValue) {
                fieldValueConfig.value = null;
                if (fieldValueConfig.fieldKeyCode === 'label') {
                    fieldValueConfig.enTranslationOfLabel = null;
                }
                return;
            }
        };

        ctrl.onClickOfCollapsibleHeader = function (index, fieldConfig) {
            ctrl.medplatFormConfig.medplatFieldMasterDtos.forEach(fieldMasterDto => fieldMasterDto.showContent = false);
            // if (!angular.element('#collapseConfiguration' + index).hasClass('show')) {
            //     fieldConfig.showContent = true;
            // }
            fieldConfig.showContent = true;
            ctrl.openEditOrAddFieldModal(index, fieldConfig);
        };

        ctrl.setConfigurations = (fieldConfig, isFieldJson) => {
            let events = fieldConfig.medplatFieldValueMasterDtos.find(e => e.fieldKeyCode === 'events');
            let visibility = fieldConfig.medplatFieldValueMasterDtos.find(e => e.fieldKeyCode === 'visibility');
            let requirable = fieldConfig.medplatFieldValueMasterDtos.find(e => e.fieldKeyCode === 'requirable');
            let disability = fieldConfig.medplatFieldValueMasterDtos.find(e => e.fieldKeyCode === 'disability');
            if (events) {
                Object.assign(events, {
                    defaultValue: JSON.stringify(fieldConfig.events) || "[]",
                    showInUI: true
                });
            } else {
                fieldConfig.medplatFieldValueMasterDtos.push({
                    defaultValue: JSON.stringify(fieldConfig.events) || "[]",
                    fieldKeyCode: "events",
                    valueType: "EVENTS",
                    showInUI: true
                });
            }
            if (visibility) {
                if (!isFieldJson) {
                    Object.assign(visibility, {
                        defaultValue: JSON.stringify(fieldConfig.visibility) || "{}",
                        showInUI: true
                    });
                }
            } else {
                fieldConfig.medplatFieldValueMasterDtos.push({
                    defaultValue: JSON.stringify(fieldConfig.visibility) || "{}",
                    fieldKeyCode: "visibility",
                    valueType: "VISIBILITY",
                    showInUI: true
                });
            }
            if (requirable) {
                if (!isFieldJson) {
                    Object.assign(requirable, {
                        defaultValue: JSON.stringify(fieldConfig.requirable) || "{}",
                        showInUI: true
                    });
                }
            } else {
                fieldConfig.medplatFieldValueMasterDtos.push({
                    defaultValue: JSON.stringify(fieldConfig.requirable) || "{}",
                    fieldKeyCode: "requirable",
                    valueType: "REQUIRABLE",
                    showInUI: true
                });
            }
            if (disability) {
                if (!isFieldJson) {
                    Object.assign(disability, {
                        defaultValue: JSON.stringify(fieldConfig.disability) || "{}",
                        showInUI: true
                    });
                }
            } else {
                fieldConfig.medplatFieldValueMasterDtos.push({
                    defaultValue: JSON.stringify(fieldConfig.disability) || "{}",
                    fieldKeyCode: "disability",
                    valueType: "DISABILITY",
                    showInUI: true
                });
            }
            fieldConfig.medplatFieldValueMasterDtos.forEach(fieldValueMasterDto => {
                if (fieldConfig.fieldType === "RADIO" && fieldValueMasterDto.fieldKeyCode === "isBoolean" && fieldValueMasterDto.defaultValue === "true") {
                    let statOp = fieldConfig.medplatFieldValueMasterDtos.find(element => { return element.fieldKeyCode === 'staticOptions' });
                    statOp.showInUI = true;
                    statOp.defaultValue = JSON.parse('[{"key":"true","value":"Yes"},{"key":"false","value":"No"}]');
                }
                if (!fieldValueMasterDto.defaultValue) {
                    if (!fieldConfig.fieldValueUuidsToBeRemoved) {
                        fieldConfig.fieldValueUuidsToBeRemoved = [];
                    }
                    fieldConfig.fieldValueUuidsToBeRemoved.push(fieldValueMasterDto.uuid);
                }
            })
            fieldConfig.medplatFieldValueMasterDtos = fieldConfig.medplatFieldValueMasterDtos.filter(e => e.showInUI && e.defaultValue);
        }

        ctrl.configureJson = (fieldConfig, fieldValueConfig, category) => {
            ctrl.showWhenEventDialogOpened = true;
            ctrl.currentTableTab = 'manage-table-fields';
            ctrl.currentField = fieldConfig;
            ctrl.currentFieldValue = fieldValueConfig;
            ctrl.currentCategory = category;
            ctrl.mobileValidationJson = false;
            if (ctrl.currentCategory === 'default') {
                if (ctrl.currentField.fieldType === 'TABLE') {
                    ctrl.currentFieldValue.staticOptions = ctrl.currentFieldValue.defaultValue ? ctrl.currentFieldValue.defaultValue : { "fields": [{}], "actions": [] };
                } else {
                    ctrl.currentFieldValue.staticOptions = ctrl.currentFieldValue.defaultValue ? ctrl.currentFieldValue.defaultValue : [{}];
                }
            } else if (ctrl.currentCategory === 'override') {
                ctrl.currentFieldValue.staticOptions = ctrl.currentFieldValue.value ? ctrl.currentFieldValue.value : [{}];
            }
            if (ctrl.currentField.fieldType === 'TABLE') {
                $("#configureTable").modal({ backdrop: 'static', keyboard: false });
            } else if (["mobileFormulas", "mobileValidation"].includes(ctrl.currentFieldValue.fieldKeyCode)) {
                if (ctrl.currentFieldValue.fieldKeyCode === 'mobileValidation') ctrl.mobileValidationJson = true;
                $("#configureMobileValidationsAndFormulas").modal({ backdrop: 'static', keyboard: false });
            } else {
                $("#configureStaticOptions").modal({ backdrop: 'static', keyboard: false });
            }
        }

        ctrl.addJsonOption = (staticOptions) => staticOptions.push({});

        ctrl.removeJsonOption = (staticOptions, index) => staticOptions.splice(index, 1);

        ctrl.shiftOptionUp = (staticOptions, index) => {
            let staticOption = staticOptions[index];
            staticOptions.splice(index, 1);
            staticOptions.splice(index - 1, 0, staticOption);
        }

        ctrl.shiftOptionDown = (staticOptions, index) => {
            let staticOption = staticOptions[index];
            staticOptions.splice(index, 1);
            staticOptions.splice(index + 1, 0, staticOption);
        }

        ctrl.saveJsonConfiguration = (fieldValueConfig) => {
            ctrl.staticConfigurationForm.$setSubmitted();
            ctrl.configureMobileValidationsForm.$setSubmitted();
            ctrl.tableConfigurationFormFields.$setSubmitted();
            ctrl.tableConfigurationFormActions.$setSubmitted();

            if (ctrl.currentField.fieldType === 'TABLE') {
                if (!ctrl.tableConfigurationFormFields.$valid) {
                    ctrl.currentTableTab = 'manage-table-fields';
                    toaster.pop('error', 'Atleast one option needs to be configured');
                    return;
                }

                if (fieldValueConfig.staticOptions.fields.length === 0) {
                    toaster.pop('error', 'Atleast one option needs to be configured');
                    return;
                }

                if (fieldValueConfig.staticOptions.actions.length) {
                    fieldValueConfig.staticOptions.actions.forEach((action, index) => {
                        if (action.config) {
                            ctrl.tableConfigurationFormActions['config' + index].$setValidity('invalidjson', true);
                            try {
                                let tempActionConfig = JSON.parse(action.config);
                            } catch (err) {
                                ctrl.tableConfigurationFormActions['config' + index].$setValidity('invalidjson', false);
                            }
                        }
                    })
                }

                if (!ctrl.tableConfigurationFormActions.$valid) {
                    ctrl.currentTableTab = 'manage-table-actions';
                    return;
                }

                if (ctrl.currentCategory === 'default') {
                    // fieldValueConfig.defaultValue = angular.toJson(fieldValueConfig.staticOptions);
                    fieldValueConfig.defaultValue = fieldValueConfig.staticOptions;
                } else {
                    fieldValueConfig.value = fieldValueConfig.staticOptions;
                }
                ctrl.cancelJsonConfiguration();
                toaster.pop('success', 'Options configured successfully');
            } else {
                if (ctrl.staticConfigurationForm.$valid || ctrl.configureMobileValidationsForm.$valid) {
                    if (Array.isArray(fieldValueConfig.staticOptions) && fieldValueConfig.staticOptions.length) {
                        if (ctrl.currentCategory === 'default') {
                            fieldValueConfig.defaultValue = fieldValueConfig.staticOptions;
                        } else {
                            fieldValueConfig.value = fieldValueConfig.staticOptions;
                        }
                        ctrl.cancelJsonConfiguration();
                        toaster.pop('success', 'Options configured successfully');
                    } else {
                        toaster.pop('error', 'Atleast one option needs to be configured');
                    }
                }
            }

            ctrl.showWhenEventDialogOpened = false;



            // if ((ctrl.currentField.fieldType === 'TABLE' && ctrl.tableConfigurationFormFields.$valid && ctrl.tableConfigurationFormActions.$valid)
            //     || ctrl.staticConfigurationForm.$valid || ctrl.configureMobileValidationsForm.$valid) {
            //     if (Array.isArray(fieldValueConfig.staticOptions) && fieldValueConfig.staticOptions.length) {
            //         if (ctrl.currentCategory === 'default') {
            //             fieldValueConfig.defaultValue = angular.toJson(fieldValueConfig.staticOptions);
            //         } else {
            //             fieldValueConfig.value = angular.toJson(fieldValueConfig.staticOptions);
            //         }
            //         ctrl.cancelJsonConfiguration();
            //         toaster.pop('success', 'Options configured successfully');
            //     } else {
            //         toaster.pop('error', 'Atleast one option needs to be configured');
            //     }
            // }
        }

        ctrl.cancelJsonConfiguration = () => {
            $("#configureStaticOptions").modal('hide');
            $("#configureTable").modal('hide');
            $("#configureMobileValidationsAndFormulas").modal('hide');
            ctrl.staticConfigurationForm.$setPristine();
            ctrl.currentField = null;
            ctrl.currentFieldValue = null;
            ctrl.currentCategory = null;
            ctrl.showWhenEventDialogOpened = false;
        }

        ctrl.goBack = function () {
            $state.go("techo.admin.medplatForms");
        };


        ctrl.getFieldTypeName = (fieldType) => {
            return ctrl.fieldTypes.find(fieldTypeObj => fieldTypeObj.key === fieldType).value;
        };

        ctrl.isHiddenFieldAvailable = (fieldConfig) => {
            let hiddenFieldFound = fieldConfig.medplatFieldValueMasterDtos?.find(dto => {
                return dto.fieldKeyCode === 'isHidden' && dto.defaultValue === 'true'
            });
            return hiddenFieldFound ? true : false
        };
        //** START  This block is used to show/hide field based on conditions and this will check condition 
        // in particular fields medplatFieldValueMasterDtos
        const getKeyPath = (path, obj) => {
            try {
                return obj.find(o => o.fieldKeyCode === path).defaultValue;
            } catch (e) {
                return null;
            }
        };

        const _getRuleResult = (rule, data) => {
            var result;

            var sourceValue = getKeyPath(rule[0], data);
            if (sourceValue == null || sourceValue == undefined) return false;

            const isNumber = (val) => {
                try {
                    parseFloat(val);
                    return true;
                } catch (e) {
                    return false;
                }
            };

            switch (rule[1]) {
                case "eq":
                    if (Object.prototype.toString.call(sourceValue) == "[object Array]") {
                        if (sourceValue.indexOf(rule[2]) >= 0) {
                            result = true;
                        } else {
                            result = false;
                        }
                    } else {
                        result = sourceValue == rule[2];
                    }
                    break;
                case "ne":
                case "neq":
                    if (Object.prototype.toString.call(sourceValue) == "[object Array]") {
                        if (sourceValue.indexOf(rule[2]) < 0) {
                            result = true;
                        } else {
                            result = false;
                        }
                    } else {
                        result = sourceValue != rule[2];
                    }
                    break;
                case "gt":
                    if (!isNumber(sourceValue)) {
                        result = false;
                    } else {
                        result = parseFloat(sourceValue) > parseFloat(rule[2]);
                    }
                    break;
                case "lt":
                    if (!isNumber(sourceValue)) {
                        result = false;
                    } else {
                        result = parseFloat(sourceValue) < parseFloat(rule[2]);
                    }
                    break;
                case 'gte':
                    if (!isNumber(sourceValue)) {
                        result = false;
                    } else {
                        result = parseFloat(sourceValue) >= parseFloat(rule[2]);
                    }
                    break;
                case 'lte':
                    if (!isNumber(sourceValue)) {
                        result = false;
                    } else {
                        result = parseFloat(sourceValue) <= parseFloat(rule[2]);
                    }
                    break;
                default:
                    result = false;
                    break
            }

            return result;
        };

        ctrl.checkFieldCondition = (fieldKey, config) => {
            let conditionObject = ctrl.fieldConditions[fieldKey];
            if (conditionObject && conditionObject.conditional_bool == true) {
                var result = false;

                if (!conditionObject.conditions) return true;
                if (!conditionObject.conditions.rules) return true;

                if (["ANY", "any"].indexOf(conditionObject.conditions.application) >= 0) {
                    // Only one of the rules has to pass

                    for (var conIdx in conditionObject.conditions.rules) {
                        var rule = conditionObject.conditions.rules[conIdx];

                        var tmpResult = _getRuleResult(rule, config);
                        if (result != true && tmpResult == true) result = true;
                    }

                } else {
                    var ruleCount = conditionObject.conditions.rules.length;
                    var rulePassCount = 0;

                    for (var ruleIdx in conditionObject.conditions.rules) {
                        var rule = conditionObject.conditions.rules[ruleIdx];
                        var ruleResult = _getRuleResult(rule, config);
                        if (ruleResult) rulePassCount++;
                    }

                    if (ruleCount == rulePassCount) result = true;

                }
                return result;
            } else {
                return true;
            }
        };
        ctrl.fieldConditions = {
            requiredMessage: {
                conditional_bool: true,
                conditions: {
                    condition: "all",
                    rules: [
                        ['isRequired', 'eq', 'true']
                    ]
                }
            }
        };
        //** END
        ctrl.generateFieldValueMap = () => {
            ctrl.fieldValueMapByKey = {};
            for (const property in ctrl.fieldValueMap) {
                ctrl.fieldValueMapByKey[property] = {};
                ctrl.fieldValueMap[property].forEach((config, index) => ctrl.fieldValueMapByKey[property][config.fieldKeyCode] = { ...config, order: index + 1 })
            }
        }

        ctrl.configureFormObject = () => {
            let modalInstance = $uibModal.open({
                templateUrl: 'app/admin/applicationmanagement/medplatformconfigurator/modals/form-object/form-object.modal.html',
                controller: 'FormObjectModalController',
                windowClass: 'cst-modal',
                backdrop: 'static',
                keyboard: false,
                size: 'xl',
                resolve: {
                    config: () => {
                        return {
                            formObject: JSON.parse(ctrl.medplatFormConfig.medplatFormMasterDto.formObject || null)
                        }
                    }
                }
            });
            modalInstance.result.then(function (data) {
                ctrl.medplatFormConfig.medplatFormMasterDto.formObject = data.formObject;
                ctrl.formObjectDto = {
                    formMasterUuid: ctrl.medplatFormConfig.medplatFormMasterDto.uuid,
                    formObject: ctrl.medplatFormConfig.medplatFormMasterDto.formObject
                }
                ctrl.formObjectGroupKeys = [];
                ctrl.formObjectArrayKeysWithIndex = [];
                ctrl.formObjectArrayKeysWithoutIndex = [];
                ctrl.ngModelObjectKeys = [];
                ctrl.tableObject = [];
                ctrl.fetchFromNodes(JSON.parse(ctrl.medplatFormConfig.medplatFormMasterDto.formObject), "");
                ctrl.indexAliasesInFormObject = [...ctrl.extractIndexAliases(JSON.parse(ctrl.medplatFormConfig.medplatFormMasterDto.formObject) || [])];
                ctrl.tableAvailableParameters = "Available Params : $formData$, $utilityData$, $infoData$, $stateParams$, $loggedInUserId$\n "
                if (ctrl.indexAliasesInFormObject.length > 0) {
                    ctrl.tableAvailableParameters += "Available Indexes : ";
                    ctrl.tableAvailableParameters += ctrl.indexAliasesInFormObject.join(", ");
                }
                ctrl.ngModelObjectKeys = MedplatFormConfiguratorUtil.filterFormStructureList([...ctrl.formObjectGroupKeys, ...ctrl.formObjectArrayKeysWithIndex], (item) => {
                    return item !== '$infoData$';
                });
                let bindToList = []
                    ctrl.ngModelObjectKeys.forEach(model => {
                        bindToList.push({
                            fieldKeyCode: model,
                            value: model,
                            valueType: 'TEXT',
                            required: true
                        })
                    })
                ctrl.fieldValueDropdownOptionsByKey.ngModel = bindToList;
                ctrl.fieldValueDropdownOptionsByKey.tableObject = ctrl.tableObject;
                Mask.show();
                MedplatFormServiceV2.updateMedplatFormConfigurationFormObject(ctrl.formObjectDto).then(response => {
                    ctrl.checkForErrorsInFields();
                    ctrl.formHasError = false;
                    ctrl.checkFormIntegrity();
                    toaster.pop("success", `Form Structure Saved Successfully.`);
                }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide);
            }, () => {
            });
        }


        ctrl.configureFormVMs = () => {
            let modalInstance = $uibModal.open({
                templateUrl: 'app/admin/applicationmanagement/medplatformconfigurator/modals/form-vm/form-vm.modal.html',
                controller: 'FormVmModalController',
                windowClass: 'bottom-modal fade-bottom',
                backdrop: 'static',
                keyboard: false,
                size: 'xl',
                resolve: {
                    config: () => {
                        return {
                            formVm: JSON.parse(ctrl.medplatFormConfig.medplatFormMasterDto.formVm || null),
                            formObjectArrayKeysWithIndex: ctrl.formObjectArrayKeysWithIndex,
                            formObjectArrayKeysWithoutIndex: ctrl.formObjectArrayKeysWithoutIndex,
                            formObjectGroupKeys: ctrl.formObjectGroupKeys,
                            getColumnArray: ctrl.getColumnArray,
                            indexAliases: ctrl.extractIndexAliases(JSON.parse(ctrl.medplatFormConfig.medplatFormMasterDto.formObject) || []),
                        }
                    }
                }
            });
            modalInstance.result.then(function (data) {
                ctrl.medplatFormConfig.medplatFormMasterDto.formVm = data.formVm;
                ctrl.formObjectDto = {
                    formMasterUuid: ctrl.medplatFormConfig.medplatFormMasterDto.uuid,
                    formVm: ctrl.medplatFormConfig.medplatFormMasterDto.formVm
                }
                Mask.show();
                MedplatFormServiceV2.updateMedplatFormConfigurationFormVm(ctrl.formObjectDto).then(response => {
                    ctrl.getmedplatFormConfig();
                    ctrl.variableList = [];
                    ctrl.tempFormVm = JSON.parse(ctrl.medplatFormConfig.medplatFormMasterDto.formVm);
                    if (ctrl.tempFormVm.hasOwnProperty('formVariables')) {
                        ctrl.tempFormVm.formVariables.forEach((fv) => {
                            ctrl.variableList.push(`${fv.bindTo}.${fv.value}`);
                        })
                    }
                    ctrl.checkForErrorsInFields();
                    ctrl.formHasError = false;
                    ctrl.checkFormIntegrity();
                    ctrl.checkForErrorsInFormUtilities();
                    toaster.pop("success", `Form Utilities Saved Successfully.`);
                }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide);
            }, () => {
            });
        }


        ctrl.fetchFromNodes = (nodes, prefix) => {
            if (nodes) {
                nodes.forEach((node) => {
                    if (node.isArray) {
                        ctrl.formObjectArrayKeysWithoutIndex.push(`${prefix}${node.title}`);
                        ctrl.formObjectArrayKeysWithIndex.push(`${prefix}${node.title}[$${node.indexAlias}$]`);
                        ctrl.tableObject.push({
                            fieldKeyCode: `${prefix}${node.title}`,
                            value: `${prefix}${node.title}`,
                            valueType: 'TEXT',
                            required: true
                        });
                    } else {
                        ctrl.formObjectGroupKeys.push(`${prefix}${node.title}`);
                        ctrl.tableObject.push({
                            fieldKeyCode: `${prefix}${node.title}`,
                            value: `${prefix}${node.title}`,
                            valueType: 'TEXT',
                            required: true
                        });
                    }
                    if (Array.isArray(node.nodes) && node.nodes.length) {
                        if (node.isArray) {
                            ctrl.fetchFromNodes(node.nodes, `${prefix}${node.title}[$${node.indexAlias}$].`);
                        } else {
                            ctrl.fetchFromNodes(node.nodes, `${prefix}${node.title}.`);
                        }
                    }
                });
            }
        }

        ctrl.extractIndexAliases = (nodes, aliasSet = new Set()) => {
            for (const node of nodes) {
                if (node.indexAlias) {
                    aliasSet.add(`[$${node.indexAlias}$]`);
                }
                if (node.nodes && node.nodes.length > 0) {
                    ctrl.extractIndexAliases(node.nodes, aliasSet);
                }
            }
            return aliasSet;
        }

        ctrl.setExecutionSeq = () => {
            if (ctrl.medplatFormConfig.medplatFormMasterDto.formVm != null) {
                let modalInstance = $uibModal.open({
                    templateUrl: 'app/admin/applicationmanagement/medplatformconfigurator/modals/execution-sequence/execution-sequence.html',
                    controller: 'ExecutionSequenceController',
                    windowClass: 'bottom-modal fade-bottom',
                    backdrop: 'static',
                    keyboard: false,
                    size: 'xl',
                    resolve: {
                        config: () => {
                            return {
                                executionSequence: JSON.parse(ctrl.medplatFormConfig.medplatFormMasterDto.executionSequence || null),
                                formVm: JSON.parse(ctrl.medplatFormConfig.medplatFormMasterDto.formVm || null)
                            }
                        }
                    }
                });
                modalInstance.result.then(function (data) {
                    ctrl.medplatFormConfig.medplatFormMasterDto.executionSequence = JSON.stringify(data)
                    let dto = {
                        formMasterUuid: ctrl.medplatFormConfig.medplatFormMasterDto.uuid,
                        ...ctrl.medplatFormConfig.medplatFormMasterDto
                    }
                    MedplatFormServiceV2.updateFormVersion(dto).then(() => {
                        toaster.pop("success", `Form onLoad execution configured successfully.`);
                    }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide);
                }, () => {
                });
            } else {
                toaster.pop('warning', 'Configure form utilities to set form onLoad execution');
            }
        }

        ctrl.updateFormConfig = () => {
            if (ctrl.medplatFormConfig.medplatFormMasterDto.formName && ctrl.medplatFormConfig.medplatFormMasterDto.state && ctrl.medplatFormConfig.medplatFormMasterDto.description) {
                var modalInstance = $uibModal.open({
                    templateUrl: 'app/common/views/confirmation.modal.html',
                    controller: 'ConfirmModalController',
                    windowClass: 'cst-modal',
                    size: 'med',
                    resolve: {
                        message: function () {
                            return `Are you sure you want to update form details?`;
                        }
                    }
                });
                modalInstance.result.then(function () {
                    let dto = {
                        formMasterUuid: ctrl.medplatFormConfig.medplatFormMasterDto.uuid,
                        formName: ctrl.medplatFormConfig.medplatFormMasterDto.formName,
                        menuConfigId: ctrl.medplatFormConfig.medplatFormMasterDto.menuConfigId,
                        state: ctrl.medplatFormConfig.medplatFormMasterDto.state,
                        description: ctrl.medplatFormConfig.medplatFormMasterDto.description
                    }
                    Mask.show();
                    MedplatFormServiceV2.updateMedplatFormConfiguration(dto).then(response => {
                        toaster.pop("success", `Form Updated Successfully.`);
                    }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide());
                }, function () {
                });
            }
        };


        ctrl.openEditOrAddFieldModal = (index, fieldConfig) => {
            ctrl.currentFieldConfigObject = fieldConfig;
            ctrl.currentFieldConfigIndex = index;
            ctrl.currentFieldConfigTypeJson = false;
            ctrl.currentFieldConfigTypeManual = true;
            ctrl.currentFieldConfigObjectJSON = JSON.stringify(ctrl.currentFieldConfigObject, undefined, 4);
            ctrl.currentFieldConfigTab = 'manage-field-basic-configuration';
            $("#addOrEditField").modal({ backdrop: 'static', keyboard: false });

            ctrl.eventConfig = {
                event: fieldConfig.events,
                fieldName: fieldConfig.fieldName,
                formFields: ctrl.medplatFormConfig.medplatFieldMasterDtos,
                formVm: JSON.parse(ctrl.medplatFormConfig.medplatFormMasterDto.formVm)
            }
            ctrl.initEventConfig(ctrl.eventConfig);
        }

        $scope.$watch('ctrl.addEditFieldForm.basicConfiguration', function (newValue, oldValue) {
            if (newValue) {
                ctrl.setFieldConfigValidity(ctrl.currentFieldConfigIndex, ctrl.currentFieldConfigObject);
            }
        });

        ctrl.setFieldConfigValidity = (index, fieldConfig) => {
            let errors = fieldConfig.errorMsgListKeys;
            if (errors && errors.length > 0) {
                ctrl.addEditFieldForm.$setSubmitted();
                errors.forEach(error => {
                    switch (error) {
                        case 'tableObject':
                            ctrl.addEditFieldForm.basicConfiguration['defaultValuetableObject' + index].$setValidity('required', false);
                            break;
                        case 'ngModel':
                            ctrl.addEditFieldForm.basicConfiguration['defaultValuengModel' + index].$setValidity('required', false);
                            break;
                        case 'variableList':
                            break;
                        case 'additionalStaticOptionsRequired:DO_NOT_NEED':
                            break;
                        case 'additionalStaticOptionsRequired:NEED':
                            break;
                        case 'event:Change':
                            // ctrl.addEditFieldForm.eventsForm['field' + index].$setValidity('required', false);
                            break;
                        case 'event:Blur':
                            // ctrl.addEditFieldForm.eventsForm['field' + index].$setValidity('required', false);
                            break;
                        case 'event:MouseEnter':
                            // ctrl.addEditFieldForm.eventsForm['field' + index].$setValidity('required', false);
                            break;
                        case 'event:MouseLeave':
                            // ctrl.addEditFieldForm.eventsForm['field' + index].$setValidity('required', false);
                            break;
                        case 'event:KeyPress':
                            // ctrl.addEditFieldForm.eventsForm['field' + index].$setValidity('required', false);
                            break;
                        case 'event:KeyUp':
                            // ctrl.addEditFieldForm.eventsForm['field' + index].$setValidity('required', false);
                            break;
                        case 'event:KeyDown':
                            // ctrl.addEditFieldForm.eventsForm['field' + index].$setValidity('required', false);
                            break;
                        case 'event:Click':
                            // ctrl.addEditFieldForm.eventsForm['field' + index].$setValidity('required', false);
                            break;
                        case 'visibility:FIELD':
                            break;
                        case 'visibility:VARIABLE':
                            break;
                        case 'disability:FIELD':
                            break;
                        case 'disability:VARIABLE':
                            break;
                        case 'requirable:FIELD':
                            break;
                        case 'requirable:VARIABLE':
                            break;
                    }
                })
            }
        }

        ctrl.changeConfigType = (type) => {
            if (type === 'MANUAL') {
                ctrl.generateUIObjectFromJSON(ctrl.currentFieldConfigObjectJSON);
                ctrl.currentFieldConfigTypeJson = false;
                ctrl.currentFieldConfigTypeManual = true;
            } else {
                ctrl.currentFieldConfigObjectJSON = JSON.stringify(ctrl.generateJSONFromCurrentObject(ctrl.currentFieldConfigObject), undefined, 4);
                ctrl.currentFieldConfigTypeJson = true;
                ctrl.currentFieldConfigTypeManual = false;
            }
        }

        ctrl.generateUIObjectFromJSON = (JSONObject) => {
            let currentObject = JSON.parse(JSONObject);
            if (currentObject.hasOwnProperty('events')) {
                currentObject.events = typeof currentObject.events === 'object' ? JSON.stringify(currentObject.events) : currentObject.events;
            }

            if (currentObject.hasOwnProperty('visibility')) {
                currentObject.visibility = typeof currentObject.visibility === 'object' ? JSON.stringify(currentObject.visibility) : currentObject.visibility;
            }

            if (currentObject.hasOwnProperty('disability')) {
                currentObject.disability = typeof currentObject.disability === 'object' ? JSON.stringify(currentObject.disability) : currentObject.disability;
            }

            if (currentObject.hasOwnProperty('requirable')) {
                currentObject.requirable = typeof currentObject.requirable === 'object' ? JSON.stringify(currentObject.requirable) : currentObject.requirable;
            }

            if (currentObject.hasOwnProperty('tableConfig')) {
                currentObject.tableConfig = typeof currentObject.tableConfig === 'object' ? JSON.stringify(currentObject.tableConfig) : currentObject.tableConfig;
            }

            if (currentObject.hasOwnProperty('staticOptions')) {
                currentObject.staticOptions = typeof currentObject.staticOptions === 'object' ? JSON.stringify(currentObject.staticOptions) : currentObject.staticOptions;
            }

            if (currentObject.hasOwnProperty('minDateField')) {
                currentObject.minDateField = typeof currentObject.minDateField === 'object' ? JSON.stringify(currentObject.minDateField) : currentObject.minDateField;
            }

            if (currentObject.hasOwnProperty('maxDateField')) {
                currentObject.maxDateField = typeof currentObject.maxDateField === 'object' ? JSON.stringify(currentObject.maxDateField) : currentObject.maxDateField;
            }

            if (currentObject.hasOwnProperty('minDateTimeField')) {
                currentObject.minDateTimeField = typeof currentObject.minDateTimeField === 'object' ? JSON.stringify(currentObject.minDateTimeField) : currentObject.minDateTimeField;
            }

            if (currentObject.hasOwnProperty('maxDateTimeField')) {
                currentObject.maxDateTimeField = typeof currentObject.maxDateTimeField === 'object' ? JSON.stringify(currentObject.maxDateTimeField) : currentObject.maxDateTimeField;
            }

            let fieldMasterDto = currentObject;
            fieldMasterDto.medplatFieldValueMasterDtos = [];
            fieldMasterDto = ctrl._processFormFieldConfig(fieldMasterDto);
            ctrl.modifyfieldConfigUi(fieldMasterDto, []);
            fieldMasterDto.showContent = true;
            ctrl.currentFieldConfigObject = fieldMasterDto;

            ctrl.eventConfig = {
                event: ctrl.currentFieldConfigObject.events,
                fieldName: ctrl.currentFieldConfigObject.fieldName,
                formFields: ctrl.medplatFormConfig.medplatFieldMasterDtos,
                formVm: JSON.parse(ctrl.medplatFormConfig.medplatFormMasterDto.formVm)
            }
            ctrl.initEventConfig(ctrl.eventConfig);
        }

        ctrl.generateJSONFromCurrentObject = (fieldConfig) => {
            let events = fieldConfig.medplatFieldValueMasterDtos.find(dto => dto.fieldKeyCode === 'events');
            if (events && events.defaultValue !== null) {
                if (!['CUSTOM_HTML', 'CUSTOM_COMPONENT', 'TABLE', 'INFORMATION_DISPLAY', 'FILE_UPLOAD'].includes(ctrl.currentFieldConfigObject.fieldType) && fieldConfig.fieldType) {
                    ctrl.saveCurrentEvents(fieldConfig);
                }
            }
            let fieldDto = {};
            fieldDto['fieldType'] = fieldConfig.fieldType;
            fieldConfig.medplatFieldValueMasterDtos.forEach(dto => {
                if (!["visibility", "disability", "requirable"].includes(dto.fieldKeyCode)) {
                    if (["minDateField", "maxDateField", "minDateTimeField", "maxDateTimeField"].includes(dto.fieldKeyCode)) {
                        fieldDto[dto.fieldKeyCode] = JSON.parse(dto.defaultValue);
                    } else {
                        fieldDto[dto.fieldKeyCode] = dto.defaultValue;
                    }
                }
            });
            if (fieldConfig.fieldType === 'TABLE') {
                fieldDto.fieldKey = fieldConfig.fieldName;
            }

            if (fieldConfig.optionsType === "variableList") {
                fieldDto['variableList'] = fieldConfig.variableList;
            }

            if (fieldConfig.fieldType) {
                if (fieldConfig.hasOwnProperty("visibility")) {
                    fieldDto.visibility = fieldConfig.visibility;
                } else {
                    fieldDto.visibility = null;
                }

                if (fieldConfig.hasOwnProperty("disability")) {
                    fieldDto.disability = fieldConfig.disability;
                } else {
                    fieldDto.disability = null;
                }

                if (fieldConfig.hasOwnProperty("requirable")) {
                    fieldDto.requirable = fieldConfig.requirable;
                } else {
                    fieldDto.requirable = null;
                }
            }


            // if (!fieldConfig.hasOwnProperty("uuid")){
            //     fieldDto.uuid = UUIDgenerator.generateUUID();
            // } else {
            //     fieldDto.uuid = fieldConfig.uuid;
            // }
            return fieldDto;
        }


        ctrl.configureBackendConfiguration = () => {
            let modalInstance = $uibModal.open({
                templateUrl: 'app/admin/applicationmanagement/medplatformconfigurator/modals/backend-configuration/backend-configuration.modal.html',
                controller: 'BackendConfigurationController',
                windowClass: 'bottom-modal fade-bottom',
                backdrop: 'static',
                keyboard: false,
                size: 'xl',
                resolve: {
                    config: () => {
                        return {
                            queryConfig: JSON.parse(ctrl.medplatFormConfig.medplatFormMasterDto.queryConfig || null),
                            fieldConfigs: ctrl.fieldConfigDtosRetrieved ? ctrl.fieldConfigDtosRetrieved[ctrl.formCode] : {}
                        }
                    }
                }
            });
            modalInstance.result.then(function (data) {
                ctrl.medplatFormConfig.medplatFormMasterDto.queryConfig = data.queryConfig;
                ctrl.formObjectDto = {
                    formMasterUuid: ctrl.medplatFormConfig.medplatFormMasterDto.uuid,
                    queryConfig: ctrl.medplatFormConfig.medplatFormMasterDto.queryConfig
                }
                Mask.show();
                MedplatFormServiceV2.updateMedplatFormConfigurationFormQueryConfig(ctrl.formObjectDto).then(response => {
                    toaster.pop("success", `Query Config Saved Successfully.`);
                    ctrl.checkForErrorsInFormBackend();
                }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide);
            }, () => {
            });

        }


        ctrl.pretifyFieldJson = function () {
            try {
                let fieldConfigJson = JSON.parse(ctrl.currentFieldConfigObjectJSON);
                ctrl.currentFieldConfigObjectJSON = JSON.stringify(fieldConfigJson, undefined, 4);
            } catch (err) {
                toaster.pop('error', 'Error Parsing JSON');
            }
        }

        ctrl.collapseFieldJson = function () {
            try {
                ctrl.currentFieldConfigObjectJSON = JSON.stringify(JSON.parse(ctrl.currentFieldConfigObjectJSON));
            } catch (err) {
                toaster.pop('error', 'Error Parsing JSON');
            }
        }


        ctrl.closeEditOrAddFieldModal = () => {
            ctrl.currentFieldConfigObject = null;
            ctrl.currentFieldConfigIndex = null;
            $("#addOrEditField").modal('hide');
        }

        ctrl.generateHtmlString = (visibility) => {
            let html = '';
            const generateConditionsHtml = (conditions, depth = 0) => {
                if (conditions && conditions.rule && Array.isArray(conditions.options)) {
                    html += `<div style="border: 1px solid #ccc; padding: 10px; border-radius: 5px; margin-left: ${depth * 20}px;">`;
                    html += `<div style="font-weight: bold; margin-bottom: 10px;">${conditions.rule}</div>`;
                    conditions.options.forEach((option, index) => {
                        if (option.conditions) {
                            generateConditionsHtml(option.conditions, depth + 1);
                        } else {
                            html += '<div style="margin: 10px 10px; padding: 10px; border: 1px solid #ddd; border-radius: 5px;">';
                            html += `<div style="color: blue; margin-bottom: 5px;">#Condition${index + 1}</div>`;
                            html += '<div style="display: flex; align-items: center; gap: 10px;">';
                            html += `<div style="padding: 5px;">[${option.type}] -> `;
                            if (option.fieldName) {
                                html += `${option.fieldName}`;
                            }
                            if (option.expression) {
                                html += `${option.expression}`;
                            }
                            if (option.operator) {
                                html += ` : ${option.operator} : ${option.value1 || ''}`;
                            }
                            html += '</div>';
                            html += '</div>';
                            html += '</div>';
                        }
                    });
                    html += '</div>';
                }
            };
            if (visibility && visibility.conditions) {
                generateConditionsHtml(visibility.conditions);
            }
            return html;
        };

        ctrl.generateTableHtml = (data) => {
            data = JSON.parse(data);
            let html = `<div>`;
            html += `<h6>Static Options Configured</h6>`;
            html += `<table class="table table-striped table-sm table-responsive">`;
            html += `<tr><th width="50%">Key</th><th width="50%">Display Value</th></tr>`;
            data.forEach(item => {
                html += `<tr><td>${item.key}</td><td>${item.value}</td></tr>`;
            });
            html += '</table></div>';
            return html;
        }


        ctrl.supportedEvents = [
            "Change",
            "Blur",
            "MouseEnter",
            "MouseLeave",
            "KeyPress",
            "KeyUp",
            "KeyDown",
            "Click",
            // "DoubleClick",
            // "MouseDown",
            // "MouseUp",
            // "MouseMove",
            // "MouseOver",
        ];

        ctrl.initEventConfig = (config) => {
            ctrl.currentEvents = config.event || {}
            ctrl.currentFieldName = config.fieldName;
            ctrl.currentFormFields = config.formFields || [];
            ctrl.currentFormFields = config.formFields.filter(field => field.fieldType !== 'INFORMATION_DISPLAY');
            ctrl.currentFormVm = config.formVm || {};
            if (Array.isArray(ctrl.currentFormVm.formVariables) && ctrl.currentFormVm.formVariables.length) {
                ctrl.currentFormVm.formVariables = ctrl.currentFormVm.formVariables.filter(v => v.setter);
            }
            ctrl.currentEvent = "Change";
            if (Object.keys(ctrl.currentEvents).length === 0) {
                ctrl.supportedEvents.forEach((event) => {
                    ctrl.currentEvents[event] = { actions: [] }
                })
            }
        }

        ctrl.setCurrentEvent = (e) => {
            ctrl.addEditFieldForm.eventsForm.$setSubmitted();
            if (ctrl.addEditFieldForm.eventsForm.$valid) {
                ctrl.currentEvent = e
            } else {
                toaster.pop('error', 'Please enter all the details required')
            }
        }

        ctrl.addCurrentAction = () => {
            ctrl.currentEvents[ctrl.currentEvent].actions.push({});
            ctrl.saveCurrentEvents(ctrl.currentFieldConfigObject);
        }

        ctrl.actionTypeChanged = (index, type) => {
            ctrl.currentEvents[ctrl.currentEvent].actions[index] = { type };
            ctrl.saveCurrentEvents(ctrl.currentFieldConfigObject);
        }

        ctrl.deleteCurrentEvent = (index) => {
            ctrl.currentEvents[ctrl.currentEvent].actions.splice(index, 1);
            ctrl.saveCurrentEvents(ctrl.currentFieldConfigObject);
        }

        ctrl.saveCurrentEvents = (currentFieldConfig) => {
            ctrl.addEditFieldForm.eventsForm.$setSubmitted();
            if (ctrl.addEditFieldForm.eventsForm.$valid) {
                currentFieldConfig.events = ctrl.currentEvents;
                let fieldMasterEvents = currentFieldConfig.medplatFieldValueMasterDtos.find(v => v.fieldKeyCode === 'events');
                if (fieldMasterEvents) {
                    fieldMasterEvents.defaultValue = ctrl.currentEvents;
                }
                // toaster.pop('success', 'Event configuration saved.')
            }
        }

        ctrl.filterChange = (countCheck) => {
            if (countCheck) {
                ctrl.medplatFormConfig.medplatFieldMasterDtos.forEach(fieldMasterDto => {
                    if (fieldMasterDto.fieldType === 'TABLE') {
                        if (fieldMasterDto.tableObject.startsWith('$formData$')) {
                            ctrl.formDataFieldCount += 1;
                        } else if (fieldMasterDto.tableObject.startsWith('$infoData$')) {
                            ctrl.infoDataFieldCount += 1;
                        } else { }
                    } else {
                        if (fieldMasterDto.ngModel.startsWith('$formData$')) {
                            ctrl.formDataFieldCount += 1;
                        } else if (fieldMasterDto.ngModel.startsWith('$infoData$')) {
                            ctrl.infoDataFieldCount += 1;
                        } else { }
                    }
                });
            }
            ctrl.medplatFormConfig.medplatFieldMasterDtos.forEach(fieldMasterDto => fieldMasterDto.showCard = false);
            if (ctrl.filterDropdown === 'BOTH') {
                ctrl.medplatFormConfig.medplatFieldMasterDtos.forEach(fieldMasterDto => fieldMasterDto.showCard = true);
            }
            if (ctrl.filterDropdown === 'FORM_DATA') {
                ctrl.medplatFormConfig.medplatFieldMasterDtos.forEach(fieldMasterDto => {
                    if (fieldMasterDto.fieldType === 'TABLE') {
                        if (fieldMasterDto.tableObject.startsWith('$formData$')) {
                            fieldMasterDto.showCard = true
                        }
                    } else {
                        if (fieldMasterDto.ngModel.startsWith('$formData$')) {
                            fieldMasterDto.showCard = true
                        }
                    }
                });
            }
            if (ctrl.filterDropdown === 'INFO_DATA') {
                ctrl.medplatFormConfig.medplatFieldMasterDtos.forEach(fieldMasterDto => {
                    if (fieldMasterDto.fieldType === 'TABLE') {
                        if (fieldMasterDto.tableObject.startsWith('$infoData$')) {
                            fieldMasterDto.showCard = true
                        }
                    } else {
                        if (fieldMasterDto.ngModel.startsWith('$infoData$')) {
                            fieldMasterDto.showCard = true
                        }
                    }
                });
            }
        }

        ctrl.searchStringChanged = () => {
            if (ctrl.searchString.trim()) {
                ctrl.filterDropdown = 'BOTH';
                ctrl.medplatFormConfig.medplatFieldMasterDtos.forEach(fieldMasterDto => fieldMasterDto.showCard = false);
                ctrl.medplatFormConfig.medplatFieldMasterDtos.forEach(fieldMasterDto => {
                    if (fieldMasterDto.fieldName.toLowerCase().search(ctrl.searchString.toLowerCase()) != -1) {
                        fieldMasterDto.showCard = true
                    }
                });
            } else {
                ctrl.medplatFormConfig.medplatFieldMasterDtos.forEach(fieldMasterDto => fieldMasterDto.showCard = true);
            }
        }

        ctrl.checkForErrorsInFields = () => {
            ctrl.medplatFormConfig.medplatFieldMasterDtos.forEach(fieldMasterDto => fieldMasterDto.hasError = false);
            ctrl.ngModelObjectKeys = MedplatFormConfiguratorUtil.filterFormStructureList([...ctrl.formObjectGroupKeys, ...ctrl.formObjectArrayKeysWithIndex], (item) => {
                return item !== '$infoData$';
            });
            let tableObjectKeys = [];
            ctrl.fieldValueDropdownOptionsByKey.tableObject.forEach((to) => {
                tableObjectKeys.push(to.fieldKeyCode);
            })
            let formVm = JSON.parse(ctrl.medplatFormConfig.medplatFormMasterDto.formVm || null);
            let formVmVariables = [];
            let formVmVariablesWithoutObject = [];
            let formVmMethods = [];
            let formVmQueries = [];
            let formVmApis = [];

            if (formVm) {
                formVm.formVariables.forEach((v) => {
                    formVmVariables.push(`$utilityData$.${v.value}`);
                    formVmVariablesWithoutObject.push(v.value);
                });

                formVm.formMethods.forEach((m) => {
                    formVmMethods.push(m.value);
                });

                formVm.formQueries.forEach((q) => {
                    formVmQueries.push(q.value);
                });
            }


            ctrl.medplatFormConfig.medplatFieldMasterDtos.forEach((fieldMasterDto) => {
                fieldMasterDto.hasError = false;
                fieldMasterDto.errorMsgListKeys = [];
                let flattenVisibility = [];
                if (fieldMasterDto.fieldType === 'TABLE') {
                    if (!tableObjectKeys.includes(fieldMasterDto.tableObject)) {
                        fieldMasterDto.hasError = true;
                        fieldMasterDto.errorMsgListKeys.push('tableObject');
                    }
                } else {
                    if (!ctrl.ngModelObjectKeys.includes(fieldMasterDto.ngModel)) {
                        fieldMasterDto.hasError = true;
                        fieldMasterDto.errorMsgListKeys.push('ngModel');
                    }

                    if (fieldMasterDto.optionsType === 'queryBuilder') {
                        if (formVmQueries) {
                            if (!formVmQueries.includes(fieldMasterDto.queryBuilder)) {
                                fieldMasterDto.hasError = true;
                                fieldMasterDto.errorMsgListKeys.push('queryBuilder');
                            }
                        }
                    }

                    if (fieldMasterDto.optionsType === 'variableList') {
                        if (formVmVariables) {
                            if (!formVmVariables.includes(fieldMasterDto.variableList)) {
                                fieldMasterDto.hasError = true;
                                fieldMasterDto.errorMsgListKeys.push('variableList');
                            }
                        }
                    }

                    if (fieldMasterDto.optionsType === 'staticOptions') {
                        if (fieldMasterDto.additionalStaticOptionsRequired === 'true') {
                            fieldMasterDto.hasError = true;
                            fieldMasterDto.errorMsgListKeys.push('additionalStaticOptionsRequired:DO_NOT_NEED');
                        }
                    }

                    if (fieldMasterDto.additionalStaticOptionsRequired === 'true') {
                        if (fieldMasterDto.staticOptions == null) {
                            fieldMasterDto.hasError = true;
                            fieldMasterDto.errorMsgListKeys.push('additionalStaticOptionsRequired:NEED');
                        }
                    }

                    if (fieldMasterDto.events) {
                        fieldMasterDto.events.Change.actions.forEach((ch) => {
                            if (ch.type === 'LOAD_FIELD' || ch.type === 'RESET_FIELD') {
                                if (!ctrl.medplatFormConfig.medplatFieldConfigs[ctrl.formCode].hasOwnProperty(ch.value)) {
                                    fieldMasterDto.hasError = true;
                                    fieldMasterDto.errorMsgListKeys.push('event:Change');
                                }
                            }
                            if (ch.type === 'FORM_VARIABLE_SETTER') {
                                if (!formVmVariablesWithoutObject.includes(ch.value)) {
                                    fieldMasterDto.hasError = true;
                                    fieldMasterDto.errorMsgListKeys.push('event:Change');
                                }
                            }
                            if (ch.type === 'FORM_METHOD') {
                                if (!formVmMethods.includes(ch.value)) {
                                    fieldMasterDto.hasError = true;
                                    fieldMasterDto.errorMsgListKeys.push('event:Change');
                                }
                            }
                        })

                        fieldMasterDto.events.Blur.actions.forEach((ch) => {
                            if (ch.type === 'LOAD_FIELD' || ch.type === 'RESET_FIELD') {
                                if (!ctrl.medplatFormConfig.medplatFieldConfigs[ctrl.formCode].hasOwnProperty(ch.value)) {
                                    fieldMasterDto.hasError = true;
                                    fieldMasterDto.errorMsgListKeys.push('event:Blur');
                                }
                            }
                            if (ch.type === 'FORM_VARIABLE_SETTER') {
                                if (!formVmVariablesWithoutObject.includes(ch.value)) {
                                    fieldMasterDto.hasError = true;
                                    fieldMasterDto.errorMsgListKeys.push('event:Blur');
                                }
                            }
                            if (ch.type === 'FORM_METHOD') {
                                if (!formVmMethods.includes(ch.value)) {
                                    fieldMasterDto.hasError = true;
                                    fieldMasterDto.errorMsgListKeys.push('event:Blur');
                                }
                            }
                        })

                        fieldMasterDto.events.MouseEnter.actions.forEach((ch) => {
                            if (ch.type === 'LOAD_FIELD' || ch.type === 'RESET_FIELD') {
                                if (!ctrl.medplatFormConfig.medplatFieldConfigs[ctrl.formCode].hasOwnProperty(ch.value)) {
                                    fieldMasterDto.hasError = true;
                                    fieldMasterDto.errorMsgListKeys.push('event:MouseEnter');
                                }
                            }
                            if (ch.type === 'FORM_VARIABLE_SETTER') {
                                if (!formVmVariablesWithoutObject.includes(ch.value)) {
                                    fieldMasterDto.hasError = true;
                                    fieldMasterDto.errorMsgListKeys.push('event:MouseEnter');
                                }
                            }
                            if (ch.type === 'FORM_METHOD') {
                                if (!formVmMethods.includes(ch.value)) {
                                    fieldMasterDto.hasError = true;
                                    fieldMasterDto.errorMsgListKeys.push('event:MouseEnter');
                                }
                            }
                        })

                        fieldMasterDto.events.MouseLeave.actions.forEach((ch) => {
                            if (ch.type === 'LOAD_FIELD' || ch.type === 'RESET_FIELD') {
                                if (!ctrl.medplatFormConfig.medplatFieldConfigs[ctrl.formCode].hasOwnProperty(ch.value)) {
                                    fieldMasterDto.hasError = true;
                                    fieldMasterDto.errorMsgListKeys.push('event:MouseLeave');
                                }
                            }
                            if (ch.type === 'FORM_VARIABLE_SETTER') {
                                if (!formVmVariablesWithoutObject.includes(ch.value)) {
                                    fieldMasterDto.hasError = true;
                                    fieldMasterDto.errorMsgListKeys.push('event:MouseLeave');
                                }
                            }
                            if (ch.type === 'FORM_METHOD') {
                                if (!formVmMethods.includes(ch.value)) {
                                    fieldMasterDto.hasError = true;
                                    fieldMasterDto.errorMsgListKeys.push('event:MouseLeave');
                                }
                            }
                        })

                        fieldMasterDto.events.KeyUp.actions.forEach((ch) => {
                            if (ch.type === 'LOAD_FIELD' || ch.type === 'RESET_FIELD') {
                                if (!ctrl.medplatFormConfig.medplatFieldConfigs[ctrl.formCode].hasOwnProperty(ch.value)) {
                                    fieldMasterDto.hasError = true;
                                    fieldMasterDto.errorMsgListKeys.push('event:KeyUp');
                                }
                            }
                            if (ch.type === 'FORM_VARIABLE_SETTER') {
                                if (!formVmVariablesWithoutObject.includes(ch.value)) {
                                    fieldMasterDto.hasError = true;
                                    fieldMasterDto.errorMsgListKeys.push('event:KeyUp');
                                }
                            }
                            if (ch.type === 'FORM_METHOD') {
                                if (!formVmMethods.includes(ch.value)) {
                                    fieldMasterDto.hasError = true;
                                    fieldMasterDto.errorMsgListKeys.push('event:KeyUp');
                                }
                            }
                        })

                        fieldMasterDto.events.KeyDown.actions.forEach((ch) => {
                            if (ch.type === 'LOAD_FIELD' || ch.type === 'RESET_FIELD') {
                                if (!ctrl.medplatFormConfig.medplatFieldConfigs[ctrl.formCode].hasOwnProperty(ch.value)) {
                                    fieldMasterDto.hasError = true;
                                    fieldMasterDto.errorMsgListKeys.push('event:KeyDown');
                                }
                            }
                            if (ch.type === 'FORM_VARIABLE_SETTER') {
                                if (!formVmVariablesWithoutObject.includes(ch.value)) {
                                    fieldMasterDto.hasError = true;
                                    fieldMasterDto.errorMsgListKeys.push('event:KeyDown');
                                }
                            }
                            if (ch.type === 'FORM_METHOD') {
                                if (!formVmMethods.includes(ch.value)) {
                                    fieldMasterDto.hasError = true;
                                    fieldMasterDto.errorMsgListKeys.push('event:KeyDown');
                                }
                            }
                        })

                        fieldMasterDto.events.Click.actions.forEach((ch) => {
                            if (ch.type === 'LOAD_FIELD' || ch.type === 'RESET_FIELD') {
                                if (!ctrl.medplatFormConfig.medplatFieldConfigs[ctrl.formCode].hasOwnProperty(ch.value)) {
                                    fieldMasterDto.hasError = true;
                                    fieldMasterDto.errorMsgListKeys.push('event:Click');
                                }
                            }
                            if (ch.type === 'FORM_VARIABLE_SETTER') {
                                if (!formVmVariablesWithoutObject.includes(ch.value)) {
                                    fieldMasterDto.hasError = true;
                                    fieldMasterDto.errorMsgListKeys.push('event:Click');
                                }
                            }
                            if (ch.type === 'FORM_METHOD') {
                                if (!formVmMethods.includes(ch.value)) {
                                    fieldMasterDto.hasError = true;
                                    fieldMasterDto.errorMsgListKeys.push('event:Click');
                                }
                            }
                        })
                    }

                    if (fieldMasterDto.visibility) {
                        flattenVisibility = ctrl.flattenConditions(fieldMasterDto.visibility);
                        flattenVisibility.forEach(fv => {
                            if (fv.type === 'FIELD') {
                                if (!ctrl.allFieldsWithNgModel.includes(fv.fieldName)) {
                                    fieldMasterDto.hasError = true;
                                    fieldMasterDto.errorMsgListKeys.push('visibility:FIELD');
                                }
                            } else if (fv.type === 'VARIABLE') {
                                if (!formVmVariables.includes(fv.fieldName)) {
                                    fieldMasterDto.hasError = true;
                                    fieldMasterDto.errorMsgListKeys.push('visibility:VARIABLE');
                                }
                            }
                        })
                    }

                    if (fieldMasterDto.disability) {
                        flattenDisability = ctrl.flattenConditions(fieldMasterDto.disability);
                        flattenDisability.forEach(fv => {
                            if (fv.type === 'FIELD') {
                                if (!ctrl.allFieldsWithNgModel.includes(fv.fieldName)) {
                                    fieldMasterDto.hasError = true;
                                    fieldMasterDto.errorMsgListKeys.push('disability:FIELD');
                                }
                            } else if (fv.type === 'VARIABLE') {
                                if (!formVmVariables.includes(fv.fieldName)) {
                                    fieldMasterDto.hasError = true;
                                    fieldMasterDto.errorMsgListKeys.push('disability:VARIABLE');
                                }
                            }
                        })
                    }

                    if (fieldMasterDto.requirable) {
                        flattenRequirable = ctrl.flattenConditions(fieldMasterDto.requirable);
                        flattenRequirable.forEach(fv => {
                            if (fv.type === 'FIELD') {
                                if (!ctrl.allFieldsWithNgModel.includes(fv.fieldName)) {
                                    fieldMasterDto.hasError = true;
                                    fieldMasterDto.errorMsgListKeys.push('requirable:FIELD');
                                }
                            } else if (fv.type === 'VARIABLE') {
                                if (!formVmVariables.includes(fv.fieldName)) {
                                    fieldMasterDto.hasError = true;
                                    fieldMasterDto.errorMsgListKeys.push('requirable:VARIABLE');
                                }
                            }
                        })
                    }

                }
            });

        }


        ctrl.checkFormIntegrity = () => {
            ctrl.medplatFormConfig.medplatFieldMasterDtos.forEach(fieldMasterDto => {
                if (fieldMasterDto.hasError) {
                    ctrl.formHasError = true;
                    return;
                }
            });
        }


        ctrl.generateErrorMsgHtml = (errorList) => {
            errorList = [...new Set(errorList)]
            let errorHtml = "";
            errorHtml += `<div>`
            errorHtml += `<div>`
            errorHtml += `<h6 style="color: red;">Errors Found!</h6>`
            errorHtml += `</div>`
            errorHtml += `<div>`
            errorList.forEach(el => {
                switch (el) {
                    case 'tableObject':
                        errorHtml += `<li>Table object key not present in form structure</li>`;
                        break;
                    case 'ngModel':
                        errorHtml += `<li>Bind to key not present in form structure</li>`;
                        break;
                    case 'variableList':
                        errorHtml += `<li>Variable used in optionsType is not available</li>`;
                        break;
                    case 'additionalStaticOptionsRequired:DO_NOT_NEED':
                        errorHtml += `<li>Additional static options is not required</li>`;
                        break;
                    case 'additionalStaticOptionsRequired:NEED':
                        errorHtml += `<li>Additional static options is selected but staticOptions is null</li>`;
                        break;
                    case 'event:Change':
                        errorHtml += `<li>Field used in change event is not available</li>`;
                        break;
                    case 'event:Blur':
                        errorHtml += `<li>Field used in blur event is not available</li>`;
                        break;
                    case 'event:MouseEnter':
                        errorHtml += `<li>Field used in mouseenter event is not available</li>`;
                        break;
                    case 'event:MouseLeave':
                        errorHtml += `<li>Field used in mouseleave event is not available</li>`;
                        break;
                    case 'event:KeyPress':
                        errorHtml += `<li>Field used in keypress event is not available</li>`;
                        break;
                    case 'event:KeyUp':
                        errorHtml += `<li>Field used in keyup event is not available</li>`;
                        break;
                    case 'event:KeyDown':
                        errorHtml += `<li>Field used in keydown event is not available</li>`;
                        break;
                    case 'event:Click':
                        errorHtml += `<li>Field used in click event is not available</li>`;
                        break;
                    case 'visibility:FIELD':
                        errorHtml += `<li>Field used in visibility configuration is not available</li>`;
                        break;
                    case 'visibility:VARIABLE':
                        errorHtml += `<li>Variable used in visibility configuration is not available</li>`;
                        break;
                    case 'disability:FIELD':
                        errorHtml += `<li>Field used in disability configuration is not available</li>`;
                        break;
                    case 'disability:VARIABLE':
                        errorHtml += `<li>Variable used in disability configuration is not available</li>`;
                        break;
                    case 'requirable:FIELD':
                        errorHtml += `<li>Field used in requirable configuration is not available</li>`;
                        break;
                    case 'requirable:VARIABLE':
                        errorHtml += `<li>Variable used in requirable configuration is not available</li>`;
                        break;
                }
            });
            errorHtml += `</div>`
            errorHtml += `</div>`
            return errorHtml;
        }

        
        ctrl.checkForErrorsInFormUtilities = () => {
            ctrl.formUtilitiesHasError = false;
            let formUtilities = JSON.parse(ctrl.medplatFormConfig.medplatFormMasterDto.formVm || null);
            if (formUtilities) {
                ctrl.formUtilitiesErrorHtml = "";
                ctrl.formUtilitiesErrorHtml += `<div><div><h6 style="color: red;">Errors Found!</h6></div><div style="color: darkblue;">`;
                // let queriesMap = {};
                // ctrl.configuredQueries.forEach(query => {
                //     if (query.state === 'ACTIVE') {
                //         queriesMap[query.uuid] = query.params ? query.params.split(',').sort() : null;
                //     }
                // });
                let arrayVariablesList = formUtilities.formVariables.filter(fv => fv.type === 'ARRAY').map(fv => `${fv.bindTo}.${fv.value}`);
                let nonArrayVariablesList = formUtilities.formVariables.filter(fv => fv.type !== 'ARRAY').map(fv => `${fv.bindTo}.${fv.value}`);
                let defaultResponseBindToList = MedplatFormConfiguratorUtil.filterFormStructureList(
                    [...ctrl.formObjectGroupKeys, ...ctrl.formObjectArrayKeysWithIndex, ...nonArrayVariablesList], (item) => {
                        return item !== '$formData$' && item !== '$utilityData$' && item !== '$infoData$';
                    }
                );
                let arrayResponseBindToList = MedplatFormConfiguratorUtil.filterFormStructureList(
                    [...ctrl.formObjectArrayKeysWithoutIndex, ...arrayVariablesList], (item) => {
                        return item !== '$formData$' && item !== '$utilityData$' && item !== '$infoData$';
                    }
                );

                if (formUtilities.formQueries.length > 0) {
                    formUtilities.formQueries.forEach(vmQuery => {
                        // let vmQueryParam = JSON.parse(vmQuery.paramConfig);
                        // let vmQueryParamList = Object.keys(vmQueryParam).sort();
                        // let queriesMapParamsList = queriesMap[vmQuery.queryCode] || [];
                        // if (vmQuery.isPagination) {
                        //     if (queriesMapParamsList.length > 0) {
                        //         queriesMapParamsList = queriesMapParamsList.filter(qmpl => qmpl != 'limit_offset');
                        //     }
                        // }
                        // if(!_.isEqual(vmQueryParamList, queriesMapParamsList)){
                        //     ctrl.formUtilitiesHasError = true;
                        //     ctrl.formUtilitiesErrorHtml += `<div><span class="badge badge-pill badge-secondary">Queries</span> <b>${vmQuery.value}'s</b> query parameters changed</div>`;
                        // }
                        if (vmQuery.response != null) {
                            if (vmQuery.isResultArray) {
                                if (!arrayResponseBindToList.includes(vmQuery.response)) {
                                    ctrl.formUtilitiesHasError = true;
                                    ctrl.formUtilitiesErrorHtml += `<div><span class="badge badge-pill badge-secondary">Queries</span> <b>${vmQuery.value}'s</b> response field is not available</div>`;
                                }
                            } else {
                                if (!defaultResponseBindToList.includes(vmQuery.response)) {
                                    ctrl.formUtilitiesHasError = true;
                                    ctrl.formUtilitiesErrorHtml += `<div><span class="badge badge-pill badge-secondary">Queries</span> <b>${vmQuery.value}'s</b> response field is not available</div>`;
                                }
                            }
                        }
                    })
                }
            }
            ctrl.formUtilitiesErrorHtml += `</div></div>`;
        }

        ctrl.checkForErrorsInFormBackend = () => {
            if (ctrl.fieldConfigDtosRetrieved === null) {
                return;
            }
            ctrl.formQueryConfigHasError = false;
            let queryConfig = JSON.parse(ctrl.medplatFormConfig.medplatFormMasterDto.queryConfig || null);
            ctrl.formQueryConfigErrorHtml = "";
            ctrl.formQueryConfigErrorHtml += `<div><div><h6 style="color: red;">Errors Found!</h6></div><div style="color: darkblue;">`;
            let queriesMap = {};
            let missingFieldList = [];
            // ctrl.configuredQueries.forEach(query => {
            //     if (query.state === 'ACTIVE') {
            //         queriesMap[query.code] = query.params ? query.params.split(',').sort() : null;
            //     }
            // });
            let fieldConfigList = [];
            Object.keys(ctrl.fieldConfigDtosRetrieved[ctrl.formCode]).forEach(f=> {
                fieldConfigList.push(ctrl.fieldConfigDtosRetrieved[ctrl.formCode][f].fieldKey);
            });
            if (queryConfig) {
                for (let topLevelConfig of queryConfig) {
                    checkFieldValueError(topLevelConfig, missingFieldList);
                }
            }
            ctrl.formQueryConfigErrorHtml += `</div></div>`;

            function checkFieldValueError (config, missingFieldList) {
                if (config.params) {
                    // let paramKeys = config.params.map(item => item.key).sort();
                    // paramKeys = paramKeys.filter(p => p !== 'loggedInUserId');
                    // let queriesMapParamsList = queriesMap[config.queryCode];
                    // if(!_.isEqual(paramKeys, queriesMapParamsList)){
                    //     ctrl.formQueryConfigHasError = true;
                    //     ctrl.formQueryConfigErrorHtml += `<li><b>${config.queryCode}</b>'s query parameters has been changed</li>`;
                    // }
                    config.params.forEach(cp => {
                        if (cp.type === 'FIELD') {
                            if (!fieldConfigList.includes(cp.valueKey)) {
                                if (!missingFieldList.includes(cp.valueKey)){
                                    ctrl.formQueryConfigHasError = true;
                                    ctrl.formQueryConfigErrorHtml += `<li><b>${cp.valueKey}</b> field is used in config which is not available</li>`;
                                }
                                missingFieldList.push(cp.valueKey);
                            }
                        }
                    })
                }
                if (Array.isArray(config.subQueries)) {
                    for (let subQuery of config.subQueries) {
                        checkFieldValueError(subQuery, missingFieldList);
                    }
                }
            }
        }

        ctrl.getTableObjectForTableConfig = (fieldConfig) => {
            return (fieldConfig.medplatFieldValueMasterDtos.find(field => field.fieldKeyCode === 'tableObject').defaultValue);
        } 


        ctrl.copyField = function (index) {
            const fieldBox = document.createElement('textarea');
            fieldBox.style.position = 'fixed';
            fieldBox.style.left = '0';
            fieldBox.style.top = '0';
            fieldBox.style.opacity = '0';
            fieldBox.value = JSON.stringify(ctrl.medplatFormConfig.medplatFieldMasterDtos[index]);
            document.body.appendChild(fieldBox);
            fieldBox.focus();
            fieldBox.select();
            document.execCommand('copy');
            document.body.removeChild(fieldBox);
            toaster.pop('success', 'Field Copied');
        }

        ctrl.pasteField = function (index) {
            try {
                let fieldConfig = JSON.parse(ctrl.currentFieldConfigObjectJSON);
                ctrl.saveFieldConfig(index, fieldConfig, true);
            } catch (err) {
                toaster.pop('error', 'Check the JSON and try again')
            }
        }

        ctrl.pretifyJson = function () {
            try {
                let fieldConfig = JSON.parse(ctrl.pastedFieldJson);
                ctrl.pastedFieldJson = JSON.stringify(fieldConfig, undefined, 4)
            } catch (err) {
                toaster.pop('error', 'Error Parsing JSON')
            }
        }

        ctrl.closeModal = function () {
            ctrl.pastedFieldJson = null;
            ctrl.pasteFieldForm.$setPristine();
            $("#addFieldJSON").modal('hide');
        }

        ctrl.openPasteModal = function () {
            $("#addFieldJSON").modal({ backdrop: 'static', keyboard: false });
        }

        ctrl.navigateToEditDynamicTemplate = function () {
            let uuid = ctrl.medplatFormUuid;
            $state.go("techo.admin.medplatFormWebLayout", { uuid });
        };

        ctrl.setQueryColumnNameMap = function () {
            ctrl.queryColumnNameMap = {}
            if (ctrl.formVmQueryBuilderList) {
                for (let queryObj of ctrl.formVmQueryBuilderList) {
                    let queryString = queryObj.query;
                    let cte = /with\s+.*?\)\s*select/igs.exec(queryString);
                    let queryWithoutCte = cte ? queryString.substring(cte[0].length - 6) : queryString;
                    ctrl.queryColumnNameMap[queryObj.responseSavedIn] = ctrl.getColumnArray(queryWithoutCte);
                }
            }
        }

        ctrl.applyColRegex = (selectQuery) => {
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
                return column.trim().replace(/;$/, '').replaceAll('"', '');
            });
        };

        ctrl.flattenConditions = (conditions) => {
            let flattened = [];
            function recurse(condition) {
                if (condition.type) {
                    flattened.push(condition);
                } else if (condition.conditions && condition.conditions.options) {
                    condition.conditions.options.forEach(opt => recurse(opt));
                }
            }
            recurse(conditions);
            return flattened;
        }

        ctrl.getColumnArray = (query) => {
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
                return ctrl.applyColRegex(query.substring(selectIndex, fromIndex));
            }

            return [];
        };
        ctrl.getKeyMapData();
    }
    angular.module('imtecho.controllers').controller('MedplatFormV2', MedplatFormV2);
})();