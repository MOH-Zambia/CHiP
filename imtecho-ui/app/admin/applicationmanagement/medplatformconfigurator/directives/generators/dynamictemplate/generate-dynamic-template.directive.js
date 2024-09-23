(function () {
    let generateDynamicTemplateDirective = function ($sce) {
        return {
            restrict: 'E',
            scope: {
                constraintConfig: '<',
                templateConfig: '<',
                templateCss: '<',
                form: '=?',
                submit: '&'
            },
            templateUrl: 'app/admin/applicationmanagement/medplatformconfigurator/directives/generators/dynamictemplate/generate-dynamic-template.html',
            link: function (scope, elements, attrs) {
                const _init = () => {
                    if (!scope.submitBtnTxt) {
                        scope.submitBtnTxt = 'Save';
                    }
                    if (scope.backButtonReq === null || scope.backButtonReq === undefined) {
                        scope.backButtonReq = true
                    }
                    scope.css = $sce.trustAsHtml(`<style>${scope.templateCss}</style>`);
                }

                scope.submitForm = function () {
                    scope.form.$setSubmitted();
                    if (scope.form.$valid) {
                        scope.submit({});
                    }
                }

                scope.goBack = function () {
                    window.history.back();
                }

                _init();
            }
        };
    };
    angular.module('imtecho.directives').directive('generateDynamicTemplateDirective', generateDynamicTemplateDirective);
})();
