(function () {
    function UserHealthApprovalService($resource, APP_CONFIG) {
        var api = $resource(APP_CONFIG.apiPath + '/mobile/:action/:subaction/:id', {}, {
            updateUserState: {
                method: 'GET',
                params: {
                    action: 'activeCode'
                }
            },
            disApproveUser: {
                method: 'GET',
                params: {
                    action: 'inActiveCode'
                }
            }
        });
        return {
            updateUserState: function (code, locationId) {
                var params = {
                    code: code,
                    location: locationId
                }
                return api.updateUserState(params).$promise;
            },
            disApproveUser: function (code, reason) {
                var params = {
                    code: code,
                    reason: reason
                }
                return api.disApproveUser(params).$promise;
            }
        };
    }
    angular.module('imtecho.service').factory('UserHealthApprovalService', ['$resource', 'APP_CONFIG', UserHealthApprovalService]);
})();
