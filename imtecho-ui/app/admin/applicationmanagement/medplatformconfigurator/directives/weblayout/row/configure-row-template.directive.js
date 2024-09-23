(function () {
    let configureRowTemplateDirective = function ($uibModal, toaster,MedplatFormConfiguratorUtil) {
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
            require: '^ngController',
            templateUrl: 'app/admin/applicationmanagement/medplatformconfigurator/directives/weblayout/row/configure-row-template.html',
            link: function (scope,ele,attrs,ctrl) {
                scope.childWebComponentList = [
                    { "type": "COL", "size": "12", "name": "Add Column (1 * 12 Col)" },
                    { "type": "COL", "size": "6", "name": "Add Column (2 * 6 Col)" },
                    { "type": "COL", "size": "4", "name": "Add Column (3 * 4 Col)" },
                    { "type": "COL", "size": "3", "name": "Add Column (4 * 3 Col)" }
                ]

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
                        return f.config.fieldKey === element.config.fieldKey && f.config.fieldType === element.config.fieldType
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
                    }
                    return item
                }

                scope.manageRowConfig = function (config) {
                    let modalInstance = $uibModal.open({
                        templateUrl: 'app/admin/applicationmanagement/medplatformconfigurator/directives/weblayout/row/configure-row-template-config.modal.html',
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
                        controller: function ($uibModalInstance, arrayObjects) {
                            let manageRowConfigCtrl = this;
                            manageRowConfigCtrl.arrayObjects = arrayObjects;
                            manageRowConfigCtrl.sourceArrayObjects = MedplatFormConfiguratorUtil.filterFormStructureList(arrayObjects, (item) => {
                                return item.value.startsWith('$infoData$')
                            });
                            manageRowConfigCtrl.config = angular.copy(config);
                            manageRowConfigCtrl.queryColumnNameMap = ctrl.queryColumnNameMap;

                            manageRowConfigCtrl.isRepeatableChanged = () => {
                                manageRowConfigCtrl.config.iterationType = null;
                                manageRowConfigCtrl.iterationTypeChanged();
                            }

                            manageRowConfigCtrl.iterationTypeChanged = () => {
                                manageRowConfigCtrl.config.source = null;
                                manageRowConfigCtrl.config.ngModel = null;
                                manageRowConfigCtrl.config.initialIteratorLength = null;
                                manageRowConfigCtrl.config.showAddButton = null;
                                manageRowConfigCtrl.config.maxIteratorLength = null;
                                manageRowConfigCtrl.showAddButtonChanged();
                            }

                            manageRowConfigCtrl.showAddButtonChanged = () => {
                                manageRowConfigCtrl.config.buttonTitle = null;
                            }

                            manageRowConfigCtrl.initialIteratorLengthChanged = () => {
                                if (manageRowConfigCtrl.config.initialIteratorLength > manageRowConfigCtrl.config.maxIteratorLength) {
                                    manageRowConfigCtrl.config.maxIteratorLength = null;
                                }
                            }

                            manageRowConfigCtrl.ok = function () {
                                manageRowConfigCtrl.manageConfigForm.$setSubmitted();
                                if (manageRowConfigCtrl.manageConfigForm.$valid) {
                                    Object.assign(config, manageRowConfigCtrl.config);
                                    $uibModalInstance.close();
                                }
                            }

                            manageRowConfigCtrl.cancel = function () {
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
    angular.module('imtecho.directives').directive('configureRowTemplateDirective', configureRowTemplateDirective);
})();
