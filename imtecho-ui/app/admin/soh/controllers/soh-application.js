(function (angular) {
    function SohApp($cookies) {
        let ctrl = this;

        const _init = function () {
            if ($cookies.getObject('token')) {
                ctrl.token = $cookies.getObject('token');
                ctrl.url = "soh-staging/index.html?token=" + ctrl.token.access_token + "&rtoken=" + ctrl.token.refresh_token
            }
        }

        _init();
    }
    angular.module('imtecho.controllers').controller('SohApp', SohApp);
})(window.angular);
