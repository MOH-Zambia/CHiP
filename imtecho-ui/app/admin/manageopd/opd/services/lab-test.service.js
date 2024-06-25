// 'use strict';
// (function () {
//     function LabTestService($resource, APP_CONFIG) {
//         var api = $resource(APP_CONFIG.apiPath + '/rchopd/:action/:subaction/:id', {}, {
//             createLabTest: {
//                 method: 'POST',
//                 params: {
//                     action: 'createOpdLabTest'
//                 }
//             },
//             updateLabTest: {
//                 method: 'PUT',
//                 params: {
//                     action: 'updateOpdLabTest'
//                 }
//             },
//         });
//         return {
//             createLabTest: function (labTest) {
//                 return api.createLabTest({}, labTest).$promise;
//             },
//             updateLabTest: function (labTest) {
//                 return api.updateLabTest({}, labTest).$promise;
//             }
//         };
//     }
//     angular.module('imtecho.service').factory('LabTestService', LabTestService);
// })();
