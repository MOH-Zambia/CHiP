(function () {
    let generateElementTemplateDirective = function ($templateCache) {
        return {
            restrict: 'E',
            scope: {
                element: '<',
                elementIndex: '<',
                siblingElements: '<',
                iteratorIndex: '<',
                iteratorIndicesMap: '<',
                cardClasses: '<',
                rowClasses: '<',
                colClasses: '<',
                constraintConfig: '<'
            },
            template: $templateCache.get('app/admin/applicationmanagement/medplatformconfigurator/directives/generators/element/generate-element-template.html'),
            controller: function ($scope) {
                this.getScope = () => {
                    return $scope;
                }
            },
            link: function (scope) {

                const _init = function () {
                    if (scope.element.config.isRepeatable) {
                        if (!scope.iteratorIndicesMap) {
                            scope.iteratorIndicesMap = {};
                        } else {
                            scope.iteratorIndicesMap = angular.copy(scope.iteratorIndicesMap);
                        }
                        scope.iteratorIndicesMap[scope.element.config.ngModel] = scope.iteratorIndex;
                        if (scope.element.config.source != null) {
                            scope.iteratorIndicesMap[scope.element.config.source] = scope.iteratorIndex;
                        }
                    }
                }

                scope.deleteElement = () => {
                    scope.$emit('deleteElementFromIterator', scope.iteratorIndex);
                }

                _init();
            }
        };
    };
    angular.module('imtecho.directives').directive('generateElementTemplateDirective', generateElementTemplateDirective);
})();
