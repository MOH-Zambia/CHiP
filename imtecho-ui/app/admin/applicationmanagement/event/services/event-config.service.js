(function () {
    function EventConfigDAO($resource, APP_CONFIG) {
        var api = $resource(APP_CONFIG.apiPath + '/eventconfig/:action/:id', {}, {
            saveOrUpdate: {
                method: 'POST'
            },
            retrieveManualEvents: {
                method: 'GET',
                params: {
                    action: 'manualevents'
                }
            },
            retrieveByUUID: {
                method: 'GET'
            },
            runEvent: {
                method: 'GET',
                params: {
                    action: 'run'
                }
            },
            toggleState: {
                method: 'PUT'
            }
        });
        return {
            saveOrUpdate: function (dto) {
                return api.saveOrUpdate(dto).$promise;
            },
            retrieveManualEvents: function () {
                return api.retrieveManualEvents().$promise;
            },
            retrieveAll: function (isActive = true) {
                return api.query({ isActive: isActive }).$promise;
            },
            retrieveByUUID: function (uuid) {
                return api.retrieveByUUID({ id: uuid }).$promise;
            },
            runEvent: function (id) {
                return api.runEvent({ id: id }).$promise;
            },
            run: function (id) {
                return api.get({ id: id }).$promise;
            },
            toggleState: function (dto) {
                return api.toggleState({}, dto).$promise;
            }
        };
    }
    angular.module('imtecho.service').factory('EventConfigDAO', EventConfigDAO);
})();
