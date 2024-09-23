(function () {
    let generateRowTemplateDirective = function ($templateCache) {
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
            template: $templateCache.get('app/admin/applicationmanagement/medplatformconfigurator/directives/generators/row/generate-row-template.html'),
            link: function (scope) {

            }
        };
    };
    angular.module('imtecho.directives').directive('generateRowTemplateDirective', generateRowTemplateDirective);
})();
