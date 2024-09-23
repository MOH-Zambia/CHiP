(function () {
    let resetOnHide = () => {
        return {
            restrict: 'A',
            link: function (scope, element, attrs) {
                scope.$on('$destroy', () => {
                    scope.ngModelObject[scope.configJson.fieldKey] = null;
                    if (scope.configJson.optionsType && ['queryBuilder'].includes(scope.configJson.optionsType)) {
                        scope.optionsArray.data = [];
                    }
                })
            }
        };
    };
    angular.module('imtecho.directives').directive('resetOnHide', [resetOnHide]);
})();
