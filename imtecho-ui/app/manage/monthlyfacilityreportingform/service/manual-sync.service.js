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
            },
            sendMultipleData: {
                method: 'GET',
                params: {
                    action: 'sendMultipleData'
                },
                responseType: 'text',
                transformResponse: function (res) {
                    return {
                        data: res
                    };
                }
            },
            sendAll: {
                method: 'GET',
                params: {
                    action: 'sendAll'
                },
                responseType: 'text',
                transformResponse: function (res) {
                    return {
                        data: res
                    };
                }
            },
        });
        return {
            sendData: function (month, facilityId) {

                return api.sendData({
                    monthEnd: month,
                    facilityId: facilityId
                }).$promise;
            },
            sendMultipleData:function(month,facilityIds){
                return api.sendMultipleData({
                    monthEnd: month,
                    facilityIds: facilityIds
                }).$promise;
            },
            sendAll: function (month) {

                return api.sendAll({
                    monthEnd: month
                }).$promise;
            }
        };
    }
    angular.module('imtecho.service').factory('ManualSyncService', ['$resource', 'APP_CONFIG', ManualSyncService]);
})();
