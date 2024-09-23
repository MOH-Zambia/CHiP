(function () {
    let configureCardTemplateDirective = function ($uibModal, toaster) {
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
            require:'^ngController',
            templateUrl: 'app/admin/applicationmanagement/medplatformconfigurator/directives/weblayout/card/configure-card-template.html',
            link: function (scope,ele,attr,ctrl) {
                scope.onChildWebComponentChangedDir = function (childWebComponent, elements, element, parentComponentType) {
                    scope.onChildWebComponentChanged({ childWebComponent, elements, element, parentComponentType });
                }

                scope.onRemoveWebComponent = function () {
                    scope.checkForFormField(scope.elements);
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
                    if (item.type === 'TECHO_FORM_FIELD') {
                        toaster.pop('warning', 'Fields can be added in columns only');
                        event.stopPropagation();
                        return false
                    } if(item.type === 'COL'){
                        toaster.pop('warning','Columns can be added in rows only');
                        event.stopPropagation();
                        return false;
                    }
                    return item
                }

                scope.manageCardConfig = function (config) {
                    let modalInstance = $uibModal.open({
                        templateUrl: 'app/admin/applicationmanagement/medplatformconfigurator/directives/weblayout/card/configure-card-template-config.modal.html',
                        windowClass: 'cst-modal',
                        backdrop: 'static',
                        keyboard: false,
                        size: 'xl',
                        controllerAs: 'ctrl',
                        resolve: {
                            arrayObjects: () => {
                                return scope.arrayObjects;
                            }
                        },
                        controller: function ($uibModalInstance, MedplatFormConfiguratorUtil, arrayObjects) {
                            let manageCardConfigCtrl = this;
                            manageCardConfigCtrl.sourceArrayObjects = MedplatFormConfiguratorUtil.filterFormStructureList(arrayObjects, (item) => {
                                return item.value.startsWith('$infoData$') || item.value.startsWith('$formData$')
                            });
                            manageCardConfigCtrl.queryColumnNameMap = ctrl.queryColumnNameMap;
                            manageCardConfigCtrl.bindToArrayObjects = MedplatFormConfiguratorUtil.filterFormStructureList(arrayObjects, (item) => {
                                return !item.value.startsWith('$infoData$')
                            });
                            manageCardConfigCtrl.config = angular.copy(config);

                            manageCardConfigCtrl.isRepeatableChanged = () => {
                                manageCardConfigCtrl.config.iterationType = null;
                                manageCardConfigCtrl.iterationTypeChanged();
                            }

                            manageCardConfigCtrl.iterationTypeChanged = () => {
                                manageCardConfigCtrl.config.source = null;
                                manageCardConfigCtrl.config.ngModel = null;
                                manageCardConfigCtrl.config.initialIteratorLength = null;
                                manageCardConfigCtrl.config.showAddButton = null;
                                manageCardConfigCtrl.config.maxIteratorLength = null;
                                manageCardConfigCtrl.showAddButtonChanged();
                            }

                            manageCardConfigCtrl.showAddButtonChanged = () => {
                                manageCardConfigCtrl.config.buttonTitle = null;
                            }

                            manageCardConfigCtrl.initialIteratorLengthChanged = () => {
                                if (manageCardConfigCtrl.config.initialIteratorLength > manageCardConfigCtrl.config.maxIteratorLength) {
                                    manageCardConfigCtrl.config.maxIteratorLength = null;
                                }
                            }

                            manageCardConfigCtrl.ok = function () {
                                manageCardConfigCtrl.manageConfigForm.$setSubmitted();
                                if (manageCardConfigCtrl.manageConfigForm.$valid) {
                                    Object.assign(config, manageCardConfigCtrl.config);
                                    $uibModalInstance.close();
                                }
                            }

                            manageCardConfigCtrl.cancel = function () {
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
    angular.module('imtecho.directives').directive('configureCardTemplateDirective', configureCardTemplateDirective);
})();
