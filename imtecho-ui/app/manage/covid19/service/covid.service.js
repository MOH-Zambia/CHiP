(function () {
    function CovidService($resource, APP_CONFIG) {
        var api = $resource(APP_CONFIG.apiPath + '/covid/:action/:subaction/:id', {}, {
            // uploadSheet: {
            //     method: 'POST',
            // },
            retrieveReferredForCovidLabTest: {
                method: 'GET',
                isArray: true
            },
            retrieveApprovedForCovidLabTest: {
                method: 'GET',
                isArray: true
            },
            retrieveReferredPatientStatusList: {
                method: 'GET',
                isArray: true
            },
            retrieveSampleCollectionList: {
                method: 'GET',
                isArray: true
            },
            retrieveSampleReceiveList: {
                method: 'GET',
                isArray: true
            },
            retrieveResultList: {
                method: 'GET',
                isArray: true
            },
            retrieveIndeterminateList: {
                method: 'GET',
                isArray: true
            },
            retrieveResultConfirmedList: {
                method: 'GET',
                isArray: true
            },
            downloadLabTestReportPdf: {
                method: 'POST',
                responseType: 'arraybuffer',
                transformResponse: function (res) {
                    return {
                        data: res
                    };
                }
            },
            downloadOpdLabSrfPdf: {
                method: 'POST',
                responseType: 'arraybuffer',
                transformResponse: function (res) {
                    return {
                        data: res
                    };
                }
            },
            getConfirmedAdmittedPatientList: {
                method: 'GET',
                isArray: true
            },
            getSuspectedAdmittedPatientList: {
                method: 'GET',
                isArray: true
            },
            getOpdLabTesttList: {
                method: 'GET',
                isArray: true
            },
            downloadAdmissionReportPdf: {
                method: 'POST',
                responseType: 'arraybuffer',
                transformResponse: function (res) {
                    return {
                        data: res
                    };
                }
            },
            getReferInPatientList: {
                method: 'GET',
                isArray: true
            },
            getReferOutPatientList: {
                method: 'GET',
                isArray: true
            },
            retrieveAdminLabList: {
                method: 'GET',
                isArray: true
            },
        });
        return {
            // uploadSheet: (file) => {
            //     return api.create({ action: 'uploadsheet', file: file }, {}).$promise;
            // },
            retrieveReferredForCovidLabTest: function (params) {
                return api.retrieveReferredForCovidLabTest({
                    action: 'referredforcovidlabtest', limit: params.limit, offset: params.offset,
                    searchText: params.searchText
                }, {}).$promise;
            },
            retrieveApprovedForCovidLabTest: function (params) {
                return api.retrieveApprovedForCovidLabTest({
                    action: 'approvedforcovidlabtest', limit: params.limit, offset: params.offset,
                    searchText: params.searchText
                }, {}).$promise;
            },
            retrieveReferredPatientStatusList: function (params) {
                return api.retrieveReferredPatientStatusList({
                    action: 'referredpatientstatus', limit: params.limit, offset: params.offset,
                    searchText: params.searchText
                }, {}).$promise;
            },
            retrieveSampleCollectionList: function (params) {
                return api.retrieveSampleCollectionList({ action: 'samplecollectionlist', limit: params.limit, offset: params.offset, searchText: params.search, wardId: params.wardId }, {}).$promise;
            },
            retrieveSampleReceiveList: function (params) {
                return api.retrieveSampleReceiveList({ action: 'samplereceivelist', limit: params.limit, offset: params.offset, searchText: params.search, healthInfra: params.healthInfra, collectionDate: params.collectionDate, wardId: params.wardId }, {}).$promise;
            },
            retrieveResultList: function (params) {
                return api.retrieveResultList({ action: 'resultlist', limit: params.limit, offset: params.offset, searchText: params.search, healthInfra: params.healthInfra, wardId: params.wardId, collectionDate: params.collectionDate }, {}).$promise;
            },
            retrieveIndeterminateList: function (params) {
                return api.retrieveIndeterminateList({ action: 'indeterminatelist', limit: params.limit, offset: params.offset, searchText: params.search }, {}).$promise;
            },
            retrieveResultConfirmedList: function (params) {
                return api.retrieveResultConfirmedList({ action: 'resultconfirmedlist', limit: params.limit, offset: params.offset, searchText: params.search }, {}).$promise;
            },
            downloadLabTestReportPdf: function (ids) {
                return api.downloadLabTestReportPdf({ action: 'downloadLabTestReportPdf', labIds: ids }, ids).$promise;
            },
            downloadOpdLabSrfPdf: function (ids) {
                return api.downloadLabTestReportPdf({ action: 'downloadSrfPdf', labTestIds: ids }, ids).$promise;
            },
            getPendingAdmissionforLabTest: function (params) {
                return api.retrieveResultList({
                    action: 'getpendingadmissionforlabtest', limit: params.limit,
                    offset: params.offset, searchText: params.searchText
                }, {}).$promise;
            },
            getSuspectedAdmittedPatientList: function (params) {
                return api.retrieveResultList({
                    action: 'getsuspectedadmittedpatientlist', limit: params.limit,
                    offset: params.offset, searchText: params.searchText
                }, {}).$promise;
            },
            getOpdLabTesttList: function (params) {
                return api.retrieveResultList({
                    action: 'covid_19_get_opd_only_lab_test_admission', limit: params.limit,
                    offset: params.offset, searchText: params.searchText
                }, {}).$promise;
            },

            getConfirmedAdmittedPatientList: function (params) {
                return api.retrieveResultList({
                    action: 'getconfirmedadmittedpatientlist', limit: params.limit,
                    offset: params.offset, searchText: params.searchText
                }, {}).$promise;
            },
            downloadAdmissionReportPdf: function (ids) {
                return api.downloadLabTestReportPdf({ action: 'downloadAdmissionReportPdf', admissionIds: ids }, ids).$promise;
            },
            getReferInPatientList: function (params) {
                return api.retrieveResultList({
                    action: 'getreferinpatientlist', limit: params.limit,
                    offset: params.offset, searchText: params.searchText
                }, {}).$promise;
            },
            getReferOutPatientList: function (params) {
                return api.retrieveResultList({
                    action: 'getreferoutpatientlist', limit: params.limit,
                    offset: params.offset, searchText: params.searchText
                }, {}).$promise;
            },
            retrieveAdminLabList: function (params) {
                return api.retrieveAdminLabList({
                    action: 'retrieveadminlablist', limit: params.limit,
                    offset: params.offset, searchText: params.search
                }, {}).$promise;
            },
        };
    }
    angular.module('imtecho.service').factory('CovidService', ['$resource', 'APP_CONFIG', CovidService]);
})();
