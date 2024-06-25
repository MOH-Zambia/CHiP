// (function () {
//     function AadhaarVerificationDao($resource, APP_CONFIG) {
//         var api = $resource(APP_CONFIG.apiPath + '/duplicate/aadhaar/:action/:id', {}, {
//             getMembers: {
//                 method: 'GET',
//                 isArray: true
//             },
//             updateAadhaar : {
//                 method: 'POST',
//             }
//         });
//         return {
//             getDuplicateAadhaarMembers: function (locationId, limit, offset) {
//                 return api.getMembers({ action: 'get-member-details', locationId, limit, offset},{}).$promise
//             },
//             updateAllAadhaarDetails: function (memberAadhaarDetails) {
//                 return api.updateAadhaar({ action: 'update-all-aadhaar-details'}, memberAadhaarDetails).$promise
//             },
//         };
//     }
//     angular.module('imtecho.service').factory('AadhaarVerificationDao', AadhaarVerificationDao);
// })();