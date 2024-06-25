(function () {
    function StockConfigDAO($resource, APP_CONFIG) {
        let api = $resource(APP_CONFIG.apiPath + '/stockmanagement/:action/', {}, {
            updateStock: {
                method: 'PUT',
                isArray: true,
                params: {
                    action: 'update'
                }
            },
            updateInventory: {
                method: 'PUT'
            }
        });
     
        return {
            updateStock: function (data, healthInfraId, userId) {
                return api.updateStock({healthInfraId: healthInfraId, userId}, data).$promise;
            },
            updateInventory: function (data){
                console.log(data);
                return api.updateInventory({action: 'updateMedicineStock'}, data).$promise;
            }
        };
    }
    angular.module('imtecho.service').factory('StockConfigDAO', ['$resource', 'APP_CONFIG', StockConfigDAO]);
})();