(function () {
    function HelpDeskDao($resource, APP_CONFIG) {
        let api = $resource(APP_CONFIG.apiPath + '/helpdesk/update', {}, {
            updateStatus: {
                method: 'POST',
                params: {
                    recordId: '@recordId',
                    status: '@status'
                }
            },
        });

        return {
            updateStatus: function (status, recordId) {
                return api.updateStatus({ status: status, recordId: recordId }).$promise;
            },
        };
    }

    angular.module('imtecho.service').factory('HelpDeskDao', ['$resource', 'APP_CONFIG', HelpDeskDao]);
})();
