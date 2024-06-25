'use strict';
(function () {
    function UploadLocationService($resource, APP_CONFIG) {
        var api = $resource(APP_CONFIG.apiPath + '/upload/location/:action/:fileName', {},
            {
                processXls: {
                    method: 'POST',
                    isArray: false
                }
            });
        return {
            processXls: function (fileName) {
                return api.processXls({ action: 'process', fileName: fileName }, {}).$promise;
            }

        };
    }
    angular.module('imtecho.service').factory('UploadLocationService', UploadLocationService);
})();
