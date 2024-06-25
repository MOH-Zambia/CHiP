// 'use strict';
// (function () {
//     function IDSPService($resource, APP_CONFIG) {
//         let api = $resource(APP_CONFIG.apiPath + '/idsp/:action/:subaction/:id', {}, {
//             downloadFormSExcel: {
//                 method: 'GET',
//                 params: {
//                     action: 'form-s',
//                     subaction: 'download-excel'
//                 },
//                 responseType: 'arraybuffer',
//                 transformResponse: function (res) {
//                     return {
//                         data: res
//                     };
//                 }
//             }
//         });
//         return {
//             downloadFormSExcel: function (locationId, reportFromDate, reportToDate) {
//                 return api.downloadFormSExcel({ locationId, reportFromDate, reportToDate }).$promise;
//             }
//         };
//     }
//     angular.module('imtecho.service').factory('IDSPService', IDSPService);
// })();
