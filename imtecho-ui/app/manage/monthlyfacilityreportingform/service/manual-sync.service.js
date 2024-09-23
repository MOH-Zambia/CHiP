(function () {
    function ManualSyncService($resource, APP_CONFIG) {
        var api = $resource(APP_CONFIG.serverPath + '/chipIntegration/:action', {}, {
            sendData: {
                method: 'GET',
                params: {
                    action: 'sendData'
                },
                responseType: 'text',
                transformResponse: function (res) {
                    return {
                        data: res
                    };
                }
            }
        });
        return {
            sendData: function (month, facilityId) {

                return api.sendData({
                    monthEnd: month,
                    facilityId: facilityId
                }).$promise;
            }
        };
    }
    angular.module('imtecho.service').factory('ManualSyncService', ['$resource', 'APP_CONFIG', ManualSyncService]);
})();
