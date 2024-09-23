(function () {
    let configureColTemplateDirective = function ($uibModal, GeneralUtil, toaster) {
        return {
            restrict: 'E',
            scope: {
                config: '<',
                elements: '<',
                siblingElements: '<',
                elementIndex: '<',
                formFieldList: '<',
                fields: '=',
                arrayObjects: '<',
                onChildWebComponentChanged: '&'
            },
            templateUrl: 'app/admin/applicationmanagement/medplatformconfigurator/directives/weblayout/col/configure-col-template.html',
            link: function (scope) {
                scope.onChildWebComponentChangedDir = function (childWebComponent, elements, element, parentComponentType) {
                    scope.onChildWebComponentChanged({ childWebComponent, elements, element, parentComponentType });
                }

                scope.onRemoveWebComponent = function () {
                    scope.checkForFormField(scope.elements)
                    scope.siblingElements.splice(scope.elementIndex, 1);
                }

                scope.checkForFormField = function (elements) {
                    elements.forEach(element => {
                        if (element.type === 'TECHO_FORM_FIELD') {
                            scope.enableField(element);
                            return;
                        }
                        if (element.elements && element.elements.length > 0) {
                            scope.checkForFormField(element.elements);
                        }
                    });
                }

                scope.enableField = function (element) {
                    let field = scope.fields.find((f) => {
                        return f.config.fieldKey === element.config.fieldKey && f.config.fieldType === element.config.fieldType;
                    });
                    if (field != undefined || field != null) {
                        field.isAdded = false;
                    }
                }

                scope.onDrop = function (item, event) {
                    if (item.type === 'COL') {
                        toaster.pop('warning', 'Column cannot be added in a column directly, Try adding row/card.');
                        event.stopPropagation();
                        return false
                    }
                    return item
                }

                scope.manageColConfig = function (config) {
                    let modalInstance = $uibModal.open({
                        templateUrl: 'app/admin/applicationmanagement/medplatformconfigurator/directives/weblayout/col/configure-col-template-config.modal.html',
                        windowClass: 'cst-modal',
                        backdrop: 'static',
                        keyboard: false,
                        size: 'lg',
                        controllerAs: 'ctrl',
                        resolve: {},
                        controller: function ($uibModalInstance) {
                            let manageColConfigCtrl = this;
                            manageColConfigCtrl.config = angular.copy(config);

                            manageColConfigCtrl.ok = function () {
                                manageColConfigCtrl.manageConfigForm.$setSubmitted();
                                if (manageColConfigCtrl.manageConfigForm.$valid) {
                                    Object.assign(config, manageColConfigCtrl.config);
                                    $uibModalInstance.close();
                                }
                            }

                            manageColConfigCtrl.cancel = function () {
                                $uibModalInstance.dismiss();
                            }
                        }
                    });

                    modalInstance.result
                        .then(function () { }, function () { })
                }
            }
        };
    };
    angular.module('imtecho.directives').directive('configureColTemplateDirective', configureColTemplateDirective);
})();
