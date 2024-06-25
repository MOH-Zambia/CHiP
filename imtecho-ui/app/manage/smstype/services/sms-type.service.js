(function () {
    function SmsTypeService($resource, APP_CONFIG) {
        var api = $resource(APP_CONFIG.apiPath + '/smstype/:action/:subaction', {}, {
            getAllSmsTypes: {
                method: 'GET',
                isArray: true
            },
            updateSmsTypeState: {
                method: 'PUT',
                params: {
                    action: 'toggleState'
                }
            },
            createSmsType: {
                method: 'POST',
                params: {
                    action: 'create'
                }
            },
            updateSmsType: {
                method: 'PUT',
                params: {
                    action: 'updateSmsType'
                }
            },
            getSmsTypeByType: {
                method: 'GET'
            }
        });
        return {
            getAllSmsTypes: function () {
                return api.getAllSmsTypes({
                    action: 'getAllSmsTypes'
                }, {}).$promise;
            },
            updateSmsTypeState: function (smsType, isActive) {
                return api.updateSmsTypeState({is_active: isActive}, smsType).$promise
            },
            createSmsType: function (smsType) {
                return api.createSmsType({}, smsType).$promise;
            },
            updateSmsType: function (smsType) {
                return api.updateSmsType({}, smsType).$promise
            },
            getSmsTypeByType: function (type) {
                return api.getSmsTypeByType({
                    action: 'getSmsTypeByType',
                    type: type
                }, {}).$promise;
            }
        };
    }
    angular.module('imtecho.service').factory('SmsTypeService', ['$resource', 'APP_CONFIG', SmsTypeService]);
})();
