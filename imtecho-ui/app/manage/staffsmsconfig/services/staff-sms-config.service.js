(function () {
    function StaffSmsConfigDAO($resource, APP_CONFIG) {
        var api = $resource(APP_CONFIG.apiPath + '/staffsms/:action/:id', {}, {
            createOrUpdate: {
                method: 'POST',
                isArray: true

            },
            createOrUpdateExcelConf: {
                method: 'POST',
                isArray: true
            },
            retrieveById: {
                method: 'GET'
            },
            markStateActiveOrInActive: {
                method: 'GET',
                params: {
                    action: 'updatestate'
                }
            }
        });
        var documentApi = $resource(APP_CONFIG.apiPath + '/document/:action/:id', {}, {
            removeFile: {
                method: 'PUT',
                params: {
                    action: 'removedocument'
                }
            },
            getFile: {
                method: 'GET',
            },
            getDocumentDetail: {
                method: 'GET',
                params: {
                    action: 'getdocumentdetail'
                }
            }
        });
        return {
            createOrUpdate: function (smsStaffConfigDto) {
                return api.createOrUpdate({}, smsStaffConfigDto).$promise;
            },
            retrieveAll: function () {
                return api.query().$promise;
            },
            retrieveById: function (id) {
                return api.retrieveById({ id: id }).$promise;
            },
            markStateActiveOrInActive: function (state, id) {
                return api.markStateActiveOrInActive({ action: 'updatestate', staffsmsid: id, state: state }, {}).$promise;
            },
            createOrUpdateExcelConf: function (smsStaffConfigDto) {
                return api.createOrUpdateExcelConf({ action: 'saveexcelconf' }, smsStaffConfigDto).$promise;
            },
            getFile: function (id) {
                return documentApi.getFile({ action: 'getfile', id: id }).$promise;
            },
            removeFile: function (id) {
                return documentApi.removeFile({ id: id }, {}).$promise;
            },
            getDocumentDetail: function (id) {
                return documentApi.getDocumentDetail({ id: id }, {}).$promise;
            }
        };
    }
    angular.module('imtecho.service').factory('StaffSmsConfigDAO', ['$resource', 'APP_CONFIG', StaffSmsConfigDAO]);
})();
