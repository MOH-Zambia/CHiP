(function () {
    function DocumentDAO($resource, APP_CONFIG) {

        var attachmentApi = $resource(APP_CONFIG.apiPath + '/document/:action/:id', {},
            {
                removeFile: {
                    method: 'PUT'
                },
                downloadFile: {
                    method: 'GET',
                    responseType: 'arraybuffer',
                    transformResponse: function (res) {
                        return {
                            data: res
                        };
                    }
                }
            });
        return {
            removeFile: function (id) {
                return attachmentApi.removeFile({
                    action: 'removedocument', id
                }, {}).$promise;
            },
            downloadFile: function (id) {
                return attachmentApi.downloadFile({
                    action: 'getfile', id
                }, {}).$promise;
            }
        };
    }
    angular.module('imtecho.service').factory('DocumentDAO', DocumentDAO);
})();
