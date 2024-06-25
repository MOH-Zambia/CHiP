(function () {
    function HealthInfraService($resource, APP_CONFIG) {
        var api = $resource(APP_CONFIG.apiPath + '/health-infra/:action/:id', {}, {
            getData: {
                method: 'GET'
            },
            postData: {
                method: 'POST'
            },
            deleteHealthInfra: {
                method: 'DELETE',
                params: {
                    action: 'deleteHealthInfra'
                }
            },
            toggleActive: {
                method: 'POST',
                params: {
                    action: 'toggleactive'
                }
            }
        });
        return {
            getHealthInfrastructureById: function (healthInfraId) {
                return api.getData({ action: 'get-health-infra-by-id',id: healthInfraId }).$promise
            },
            deleteHealthInfra: function (id) {
                return api.deleteHealthInfra(id).$promise;
            },
            toggleActive: function (id, state) {
                return api.toggleActive({id:id,state:state},{}).$promise;
            }
        };
    }
    angular.module('imtecho.service').factory('HealthInfraService', HealthInfraService);
})();