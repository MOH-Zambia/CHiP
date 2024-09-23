(function () {
    function MedplatForms(Mask, GeneralUtil, $state, MedplatFormService, MedplatFormServiceV2, UUIDgenerator, QueryDAO, $uibModal, AuthenticateService, toaster) {
        let ctrl = this;
        ctrl.withoutTranslationLabelComponents = ['INFORMATION_DISPLAY', 'INFORMATION_TEXT', 'CUSTOM_HTML', 'TABLE'];
        ctrl.canChangeStableVersion = false;

        const _init = function () {
            ctrl.selectedTab = 'manage-form-configs';
            Mask.show();
            AuthenticateService.getLoggedInUser()
            .then(function (res) {
                ctrl.user = res.data;
                if (ctrl.user != null) {
                    AuthenticateService.getAssignedFeature('techo.admin.medplatForms').then((res) => {
                        if (res) {
                            ctrl.canChangeStableVersion = res.featureJson?.canChangeStableVersion ? res.featureJson.canChangeStableVersion : false;
                        }
                        ctrl.getSystemConstraintForms();
                    })
                }
            })
            .then(function() {}).catch(GeneralUtil.showMessageOnApiCallFailure)
            .finally(function() {
                Mask.hide();
            });

        };

        ctrl.getSystemConstraintForms = function () {
            Mask.show();
            $state.go('.', { selectedTab: ctrl.selectedTab }, { notify: false });
            MedplatFormServiceV2.getMedplatForms().then(function (response) {
                ctrl.systemConstraintForms = response;
                ctrl.systemConstraintForms.forEach(form => {
                    form.availableVersion = form.availableVersion.substring(1, form.availableVersion.length - 1).split(',');
                    let draft = form.availableVersion.filter(item => item === "DRAFT");
                    let numbers = form.availableVersion.filter(item => item !== "DRAFT");
                    numbers.sort((a, b) => b - a);
                    form.availableVersion = draft.concat(numbers);
                })
            }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide());
        };

        ctrl.changeFormVersion = (form, version) => {
            var modalInstance = $uibModal.open({
                templateUrl: 'app/common/views/confirmation.modal.html',
                controller: 'ConfirmModalController',
                windowClass: 'cst-modal',
                size: 'med',
                resolve: {
                    message: function () {
                        return `This will change the current version of <b>${form.formCode}</b> to <b>${version}</b>`;
                    }
                }
            });
            modalInstance.result.then(function () {
                let dto = {
                    formMasterUuid: form.uuid,
                    version: version,
                };
                Mask.show();
                MedplatFormServiceV2.updateMedplatFormVersion(dto).then(function (response) {
                    toaster.pop("success", `Form Version Changed Successfully.`);
                    ctrl.getSystemConstraintForms();
                }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide());
            }, function () {
            });
        }


        ctrl.downloadFlyway = (form) => {
            var modalInstance = $uibModal.open({
                templateUrl: 'app/admin/applicationmanagement/medplatformconfigurator/views/medplat-form-flyway-modal.html',
                controller: 'MedplatFormFlywayController',
                windowClass: 'cst-modal',
                size: 'med',
                resolve: {
                    config: () => {
                        return {
                            form: form,
                            type: 'FLYWAY'
                        }
                    }
                }
            });
            modalInstance.result.then(function () {                
            }, function () {
            });
        }


        ctrl.resetDraft = (form) => {
            var modalInstance = $uibModal.open({
                templateUrl: 'app/admin/applicationmanagement/medplatformconfigurator/views/medplat-form-flyway-modal.html',
                controller: 'MedplatFormFlywayController',
                windowClass: 'cst-modal',
                size: 'med',
                resolve: {
                    config: () => {
                        return {
                            form: form,
                            type: 'RESET'
                        }
                    }
                }
            });
            modalInstance.result.then(function () {                
            }, function () {
            });
        }


        ctrl.navigateToAdd = function () {
            $state.go("techo.admin.medplatForm");
        };

        ctrl.navigateToEdit = function (idOrUuid) {
            $state.go("techo.admin.medplatForm", { uuid: idOrUuid });
        };

        ctrl.navigateToEditDynamicTemplate = function (uuid) {
            $state.go("techo.admin.medplatFormWebLayout", { uuid });
        };

        ctrl.navigateToEditMobileTemplate = function (uuid) {
            $state.go("techo.admin.medplatFormMobileLayout", { uuid });
        };

        _init();
    }
    angular.module('imtecho.controllers').controller('MedplatForms', MedplatForms);
})();
