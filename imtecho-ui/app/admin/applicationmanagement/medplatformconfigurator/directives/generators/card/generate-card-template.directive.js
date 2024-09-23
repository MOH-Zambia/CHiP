(function () {
    let generateCardTemplateDirective = function (UUIDgenerator, $templateCache) {
        return {
            restrict: 'E',
            scope: {
                config: '<',
                elementIndex: '<',
                siblingElements: '<',
                elements: '<',
                iteratorIndicesMap: '<',
                constraintConfig: '<'
            },
            require: '^^generateElementTemplateDirective',
            template: $templateCache.get('app/admin/applicationmanagement/medplatformconfigurator/directives/generators/card/generate-card-template.html'),
            link: function (scope, elements, attributes, elemScope) {
                scope.elemScope = elemScope.getScope();
                scope.uuid = UUIDgenerator.generateUUID();

                scope.deleteElement = () => {
                    scope.$emit('deleteElementFromIterator', scope.elemScope.iteratorIndex);
                }
            }
        };
    };
    angular.module('imtecho.directives').directive('generateCardTemplateDirective', generateCardTemplateDirective);
})();
