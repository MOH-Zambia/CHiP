(function () {
    function DynamicFormBuilderController(Mask, QueryDAO, GeneralUtil, $uibModal, AuthenticateService, toaster, $state, $stateParams) {

        var dFormCtrl = this;
        dFormCtrl.formConfigs = [];
        dFormCtrl.updateMode = false;
        dFormCtrl.timelineConfigObject = {};

        dFormCtrl.init = function () {
            dFormCtrl.getForms();
            AuthenticateService.getLoggedInUser().then(function (res) {
                dFormCtrl.currentUser = res.data;
            });
        };

        dFormCtrl.getForms = function () {
            var dto = {
                code: 'dynamic_form_select_all',
                parameters: {
                }
            };
            Mask.show();
            QueryDAO.execute(dto).then(function (res) {
                dFormCtrl.forms = res.result;
                if (!!$stateParams.formId) {
                    dFormCtrl.selectedFormId = Number($stateParams.formId);
                    dFormCtrl.getFormConfigs();
                }
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        };

        dFormCtrl.getFormConfigs = function () {
            if (!!dFormCtrl.selectedFormId) {
                var dto = {
                    code: 'dynamic_form_configs_select_by_formid',
                    parameters: {
                        form_id: dFormCtrl.selectedFormId
                    }
                };
                Mask.show();
                QueryDAO.execute(dto).then(function (res) {
                    dFormCtrl.formConfigs = res.result;
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                });
            } else {
                dFormCtrl.formConfigs = [];
            }
        };

        dFormCtrl.onAddEditClick = function (formId, formConfigId) {
            $state.go('techo.manage.dynamicformconfig', { formConfigId: formConfigId, formId: formId });
        };

        dFormCtrl.copyFormConfig = function (formConfig) {
            var modalInstanceProperties = {
                controllerAs: 'cpfm',
                controller: ['$scope', '$uibModalInstance', function ($scope, $uibModalInstance) {
                    var cpfm = this;
                    cpfm.version = '';
                    cpfm.ok = function () {
                        if (!!cpfm.version) {
                            var dto = {
                                code: 'dynamic_form_config_insert_data',
                                parameters: {
                                    version: cpfm.version,
                                    form_id: formConfig.form_id,
                                    form_config_json: formConfig.form_config_json,
                                }
                            };
                            Mask.show();
                            QueryDAO.execute(dto).then(function (res) {
                                toaster.pop('success', 'Form Configuration Copied Successfully');
                                dFormCtrl.getFormConfigs();
                            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                                Mask.hide();
                                $uibModalInstance.close();
                            });
                        }
                    };
                    cpfm.cancel = function () {
                        $uibModalInstance.dismiss('cancel');
                    };
                }],
                windowClass: 'cst-modal',
                backdrop: 'static',
                size: 'md',
                templateUrl: 'app/admin/dynamicformbuilder/views/copy-dynamic-form-config.modal.html'
            };
            var modalInstance = $uibModal.open(modalInstanceProperties);
            modalInstance.result.then(function () { });
        };

        dFormCtrl.init();
    }
    angular.module('imtecho.controllers').controller('DynamicFormBuilderController', DynamicFormBuilderController);
})();
