(function () {
    let generateRepeatableTemplateDirective = function (MedplatFormConfiguratorUtil, $templateCache, $timeout, toaster) {
        return {
            restrict: 'E',
            scope: {
                element: '<',
                elementIndex: '<',
                siblingElements: '<',
                iteratorIndicesMap: '<',
                cardClasses: '<',
                rowClasses: '<',
                colClasses: '<',
                constraintConfig: '<'
            },
            require: '^ngController',
            template: $templateCache.get('app/admin/applicationmanagement/medplatformconfigurator/directives/generators/repeatable/generate-repeatable-template.html'),
            link: function (scope, elements, attributes, ctrl) {
                scope.ctrl = ctrl;
                scope.iterator = [];

                const _init = () => {
                    if (scope.element.config.isRepeatable) {
                        if (scope.element.config.iterationType === 'FIXED') {
                            scope.iterator = eval(MedplatFormConfiguratorUtil.replaceFormConfigParamsWithValues(scope.element.config.source, scope.iteratorIndicesMap, ctrl.formIndexes));
                            if (scope.element.config.source !== scope.element.config.ngModel && scope.iterator?.length > 0) {
                                let bindTo = eval(MedplatFormConfiguratorUtil.replaceFormConfigParamsWithValues(scope.element.config.ngModel, scope.iteratorIndicesMap, ctrl.formIndexes));
                                let propertiesToBind = scope.element.config.propertiesToBind || [];
                                scope.childNodes = scope.ctrl.getChildByNodesPath(scope.ctrl.formObject, scope.element.config.ngModel)
                                if (bindTo.length < scope.iterator.length) {
                                    for (let i = bindTo.length; i < scope.iterator.length; i++) {
                                        bindTo.push(scope.createIteratorChild(scope.childNodes, {}));
                                        propertiesToBind.forEach((property) => {
                                            bindTo[i][property] = scope.iterator[i][property];
                                        })
                                    }
                                }
                            }
                        } else {
                            scope.iterator = eval(MedplatFormConfiguratorUtil.replaceFormConfigParamsWithValues(scope.element.config.ngModel, scope.iteratorIndicesMap, ctrl.formIndexes));
                            scope.childNodes = scope.ctrl.getChildByNodesPath(scope.ctrl.formObject, scope.element.config.ngModel)
                            if (scope.iterator.length < scope.element.config.initialIteratorLength) {
                                for (let i = scope.iterator.length; i < scope.element.config.initialIteratorLength; i++) {
                                    scope.iterator.push(scope.createIteratorChild(scope.childNodes, {}));
                                }
                            }
                        }
                    }
                }

                scope.addElement = () => {
                    if (scope.iterator.length < scope.element.config.maxIteratorLength) {
                        scope.iterator.push(scope.createIteratorChild(scope.childNodes, {}));
                    } else {
                        toaster.pop('error', `Maximum limit reached. You cannot add more than ${scope.element.config.maxIteratorLength} elements`)
                    }
                }

                scope.$on('deleteElementFromIterator', function (event, indexToBeDeleted) {
                    event.stopPropagation();
                    let data = angular.copy(scope.iterator);
                    data.splice(indexToBeDeleted, 1);
                    scope.iterator.splice(0, scope.iterator.length);
                    $timeout(() => {
                        scope.iterator.push(...data);
                    })
                })

                scope.createIteratorChild = (childNodes, parent) => {
                    childNodes.forEach((child) => {
                        let title = MedplatFormConfiguratorUtil.replaceRootObject(child.title);
                        parent[title] = child.isArray ? [] : {};
                        if (Array.isArray(child.nodes) && child.nodes.length && !child.isArray) {
                            scope.createIteratorChild(child.nodes, parent[title]);
                        }
                    })
                    return parent;
                }

                _init();
            }
        };
    };
    angular.module('imtecho.directives').directive('generateRepeatableTemplateDirective', generateRepeatableTemplateDirective);
})();
