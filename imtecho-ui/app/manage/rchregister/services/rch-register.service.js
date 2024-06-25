(function () {
    function RchRegister($resource, APP_CONFIG) {
        var api = $resource(APP_CONFIG.apiPath + '/rchregister/:action/:subaction', {}, {
            downloadPdf: {
                method: 'POST',
                params: {
                    action: 'downloadpdf'
                },
                responseType: 'arraybuffer',
                transformResponse: function (res) {
                    return {
                        data: res
                    };
                }
            },
            downloadExcel: {
                method: 'POST',
                params: {
                    action: 'downloadexcel'
                },
                responseType: 'arraybuffer',
                transformResponse: function (res) {
                    return {
                        data: res
                    };
                }
            }
        });
        return {
            downloadPdf: function (queryDto) {
                return api.downloadPdf(queryDto).$promise;
            },
            downloadExcel: function (queryDto) {
                return api.downloadExcel(queryDto).$promise;
            }
        };
    }
    angular.module('imtecho.service').factory('RchRegister', ['$resource', 'APP_CONFIG', RchRegister]);
})();
