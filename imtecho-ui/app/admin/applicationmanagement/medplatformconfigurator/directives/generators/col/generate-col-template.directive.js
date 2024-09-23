(function () {
    let generateColTemplateDirective = function ($templateCache) {
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
            template: $templateCache.get('app/admin/applicationmanagement/medplatformconfigurator/directives/generators/col/generate-col-template.html'),
            link: function (scope) {

            }
        };
    };
    angular.module('imtecho.directives').directive('generateColTemplateDirective', generateColTemplateDirective);
})();
