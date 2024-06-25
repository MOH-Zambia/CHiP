(function () {
    function ManageDynamicFormBuilderController(Mask, QueryDAO, GeneralUtil, $stateParams, $filter, toaster, $state,
        AuthenticateService, $uibModal) {

        var mdFormCtrl = this;
        mdFormCtrl.controls = [];
        mdFormCtrl.allformConfigs = [];
        mdFormCtrl.init = function () {
            if (!!$stateParams.formId && !!$stateParams.formConfigId) {
                mdFormCtrl.formId = Number($stateParams.formId);
                mdFormCtrl.formConfigId = Number($stateParams.formConfigId);
                mdFormCtrl.getFormConfig();
                mdFormCtrl.getForm();
            } else if (!!$stateParams.formId && !$stateParams.formConfigId) {
                mdFormCtrl.formId = Number($stateParams.formId);
                mdFormCtrl.getForm();
                mdFormCtrl.controls.push({ id: 1, page: 1, options: [{}] });
                mdFormCtrl.nextElements = [{ id: -1, label: 'End' }];
            } else {
                mdFormCtrl.nextElements = [{ id: -1, label: 'End' }];
                mdFormCtrl.controls.push({ id: 1, page: 1, options: [{}] });
            }
            AuthenticateService.getLoggedInUser().then(function (res) {
                mdFormCtrl.currentUser = res.data;
            });
            if (!!$stateParams.formId) {
                mdFormCtrl.getAllFormConfigByForms();
            }
        };

        mdFormCtrl.getFormConfig = function (id) {
            var dto = {
                code: 'dynamic_form_config_select_by_id',
                parameters: {
                    id: mdFormCtrl.formConfigId
                }
            };
            Mask.show();
            QueryDAO.execute(dto).then(function (res) {
                mdFormCtrl.formConfig = res.result[0];
                mdFormCtrl.controls = JSON.parse(res.result[0].form_config_json);
                mdFormCtrl.nextElements = [];
                mdFormCtrl.nextElements = !!mdFormCtrl.controls ? mdFormCtrl.controls.map(function (a) {
                    if (!a.next) {
                        a.next = -1;
                    }
                    return { id: a.id, label: a.question };
                }) : [];
                mdFormCtrl.controls = mdFormCtrl.controls.map(function (a) {
                    a.ismandatory = a.ismandatory === 'T' ? true : false;
                    return a;
                });
                mdFormCtrl.nextElements.push({ id: -1, label: 'End' });
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        };

        mdFormCtrl.getForm = function (formId) {
            var dto = {
                code: 'dynamic_form_select_by_id',
                parameters: {
                    id: mdFormCtrl.formId
                }
            };
            Mask.show();
            QueryDAO.execute(dto).then(function (res) {
                mdFormCtrl.form = res.result[0];
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        };

        mdFormCtrl.getFormByCode = function (code) {
            mdFormCtrl.isNotUniqueCode = false;
            if (!!code) {
                var dto = {
                    code: 'dynamic_form_select_by_code',
                    parameters: {
                        code: code
                    }
                };
                QueryDAO.execute(dto).then(function (res) {
                    if (!!res.result && (res.result.length > 1 ||
                        (res.result.length === 1 && res.result[0].id !== mdFormCtrl.form.id))) {
                        mdFormCtrl.isNotUniqueCode = true;
                    }
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                });
            }
        };

        mdFormCtrl.getAllFormConfigByForms = function () {
            var dto = {
                code: 'dynamic_form_configs_select_by_formid',
                parameters: {
                    form_id: mdFormCtrl.formId
                }
            };
            Mask.show();
            QueryDAO.execute(dto).then(function (res) {
                mdFormCtrl.allformConfigs = res.result;
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        };

        mdFormCtrl.checkUniqueVersion = function () {
            mdFormCtrl.isNotUniqueVersion = false;
            if (!!mdFormCtrl.formConfig.version) {
                var filterObj = $filter('filter')(mdFormCtrl.allformConfigs, { version: mdFormCtrl.formConfig.version }, true);
                if ((filterObj.length === 1 && !!mdFormCtrl.formConfig.id && filterObj[0].id !== mdFormCtrl.formConfig.id) ||
                    (filterObj.length === 1 && !mdFormCtrl.formConfig.id)
                    || filterObj.length > 1) {
                    mdFormCtrl.isNotUniqueVersion = true;
                }
            }
        };

        mdFormCtrl.saveForm = function () {
            if (!!mdFormCtrl.dynamicFormBuilder.$valid) {
                let dto;
                if (!!mdFormCtrl.form.id) {
                    dto = {
                        code: 'dynamic_form_update_data',
                        parameters: {
                            form_name: mdFormCtrl.form.form_name,
                            form_code: mdFormCtrl.form.form_code,
                            id: mdFormCtrl.form.id
                        }
                    };
                    Mask.show();
                    QueryDAO.execute(dto).then(function (res) {
                        toaster.pop('success', 'Form Updated Successfully');
                        mdFormCtrl.getForm();
                    }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                        Mask.hide();
                    });
                } else {
                    dto = {
                        code: 'dynamic_form_insert_data',
                        parameters: {
                            form_name: mdFormCtrl.form.form_name,
                            form_code: mdFormCtrl.form.form_code,
                        }
                    };
                    Mask.show();
                    QueryDAO.execute(dto).then(function (res) {
                        var formId = res.result[0].id;
                        if (!!formId) {
                            mdFormCtrl.formId = formId;
                            mdFormCtrl.getForm();
                            toaster.pop('success', 'Form Saved Successfully');
                        }
                    }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                        Mask.hide();
                    });
                }
            }
        }

        mdFormCtrl.save = function () {
            if (!!mdFormCtrl.dynamicFormConfigBuilder.$valid && mdFormCtrl.controls.length > 0) {
                var isInvalid = false;
                angular.forEach(mdFormCtrl.controls, function (control) {
                    // changes Value of ismandatory from True or False to "T" or "F"
                    if (control.ismandatory !== undefined) {
                        control.ismandatory = control.ismandatory === true ? "T" : "F";
                    }

                    if (!control.next && !isInvalid) {
                        toaster.pop('danger', "Please set Next of " + control.question + " element");
                        isInvalid = true;
                    } else if (control.type === 'RB' && control.options.length <= 1 && !isInvalid) {
                        toaster.pop('danger', 'At least two options are required for radion button.');
                        isInvalid = true;
                    }
                    control.event = '';
                })
                if (!!isInvalid) {
                    return;
                }
                var filterObj = $filter('filter')(mdFormCtrl.controls, { next: -1 })[0];
                if (!!filterObj) {
                    filterObj.event = 'Save Form';
                    delete filterObj.next;
                    var index = mdFormCtrl.controls.findIndex(x => x.id === filterObj.id);
                    var lastControl = mdFormCtrl.controls.splice(index, 1);
                    if (lastControl.length > 0) {
                        mdFormCtrl.controls.push(lastControl[0]);
                    }
                } else {
                    toaster.pop('danger', "End is not set as next element to any control");
                    return;
                }

                let dto;
                if (!!mdFormCtrl.formConfig.id) {
                    dto = {
                        code: 'dynamic_form_config_update_data',
                        parameters: {
                            version: mdFormCtrl.formConfig.version,
                            form_config_json: JSON.stringify(mdFormCtrl.controls),
                            form_id: mdFormCtrl.form.id,
                            id: mdFormCtrl.formConfig.id
                        }
                    };
                    Mask.show();
                    QueryDAO.execute(dto).then(function (res) {
                        toaster.pop('success', 'Form Configuration Updated Successfully');
                        $state.go('techo.manage.dynamicform', { formId: mdFormCtrl.formId });
                    }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                        Mask.hide();
                    });
                } else {
                    dto = {
                        code: 'dynamic_form_config_insert_data',
                        parameters: {
                            version: mdFormCtrl.formConfig.version,
                            form_id: mdFormCtrl.form.id,
                            form_config_json: JSON.stringify(mdFormCtrl.controls),
                        }
                    };
                    Mask.show();
                    QueryDAO.execute(dto).then(function (res) {
                        toaster.pop('success', 'Form Configuration Saved Successfully');
                        $state.go('techo.manage.dynamicform', { formId: mdFormCtrl.formId });
                    }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                        Mask.hide();
                    });
                }
            }
        }

        mdFormCtrl.addControl = function (id) {
            if (!!mdFormCtrl.dynamicFormConfigBuilder.$valid) {
                mdFormCtrl.controls.push({ id: mdFormCtrl.controls[mdFormCtrl.controls.length - 1].id + 1, page: 1, options: [{}] });
            }
        };

        mdFormCtrl.removeControl = function (control, index) {
            var filterObj = $filter('filter')(mdFormCtrl.controls, { next: control.id }, true)[0];
            if (!!filterObj) {
                toaster.pop('danger', 'Please Update Next field of ' + filterObj.question + " to remove this element");
            } else {
                var modalInstance = $uibModal.open({
                    templateUrl: 'app/common/views/confirmation.modal.html',
                    controller: 'ConfirmModalController',
                    windowClass: 'cst-modal',
                    size: 'med',
                    resolve: {
                        message: function () {
                            return "Are you sure remove " + control.question + ' element ? ';
                        }
                    }
                });
                modalInstance.result.then(function () {
                    mdFormCtrl.controls.splice(index, 1);
                    var nextEleindex = mdFormCtrl.nextElements.findIndex(x => x.id === control.id);
                    mdFormCtrl.nextElements.splice(nextEleindex, 1);
                });
            }
        };

        mdFormCtrl.addOptions = function (control, index, flag) {
            if (!flag) {
                control.options.push({});
            } else {
                control.options.splice(index, 1);
            }
        };

        mdFormCtrl.labelTextChanged = function (control) {
            var filterObj = $filter('filter')(mdFormCtrl.nextElements, { id: control.id }, true)[0];
            if (!!filterObj) {
                filterObj.label = control.question;
            } else {
                mdFormCtrl.nextElements.push({ id: control.id, label: control.question });
            }
        };

        mdFormCtrl.skipValues = function (control) {
            return function (value, index, array) {
                if (value.id === control.id) {
                    return false;
                } else {
                    var filterObj = $filter('filter')(mdFormCtrl.controls, { next: value.id }, true);
                    if (filterObj.length === 0) {
                        return true;
                    } else if (filterObj.length === 1 && filterObj[0].next === control.next) {
                        return true;
                    } else {
                        return false;
                    }
                }
            };
        };

        mdFormCtrl.cancel = function () {
            $state.go('techo.manage.dynamicform', { formId: mdFormCtrl.formId });
        };

        mdFormCtrl.init();
    }
    angular.module('imtecho.controllers').controller('ManageDynamicFormBuilderController', ManageDynamicFormBuilderController);
})();
