// 'use strict';
// (function () {
//     function UploadUserService($resource, APP_CONFIG) {
//         var api = $resource(APP_CONFIG.apiPath + '/upload/user/:action/:subaction', {},
//             {
//                 downloadSample: {
//                     method: 'GET',
//                     params: {
//                         action: 'downloadsample'
//                     },
//                     responseType: 'arraybuffer',
//                     transformResponse: function (res) {
//                         return {
//                             data: res
//                         };
//                     }
//                 },
//                 processXls: {
//                     method: 'POST',
//                     isArray: false,
//                     params: {
//                         action: 'process'
//                     }
//                 }
//             });
//         return {
//             downloadSample: function (queryId, roleId) {
//                 return api.downloadSample({ subaction: queryId, roleId: roleId }).$promise;
//             },
//             processXls: function (fileName) {
//                 return api.processXls({ subaction: fileName }, {}).$promise;
//             }

//         };
//     }
//     angular.module('imtecho.service').factory('UploadUserService', UploadUserService);
// })();
