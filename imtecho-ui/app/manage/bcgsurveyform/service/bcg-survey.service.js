// (function () {
//     function BcgSurveyService($resource, APP_CONFIG) {
//         var api = $resource(APP_CONFIG.apiPath + '/bcgvaccine/:action/:subaction/', {},
//             {
//                 storeBcgFormWeb: {
//                     method: 'POST'
//                 },
//                 isNikshayIdAvailable: {
//                     method: 'GET',
//                     params: {
//                         action: 'validateNikshayId'
//                     },
//                     transformResponse: function (res) {
//                         return { result: res };
//                     }
//                 },
//             }
//         );
//         return {
//             storeBcgFormWeb: function (bcgWebFormDto) {
//                 return api.storeBcgFormWeb({action: 'storeBcgFormWeb'}, bcgWebFormDto).$promise;
//             },
//             isNikshayIdAvailable: function (nikshayId) {
//                 var params = {
//                     nikshayId: nikshayId
//                 };
//                 return api.isNikshayIdAvailable(params).$promise;
//             },
//         };
//     }
//     angular.module('imtecho.service').factory('BcgSurveyService', ['$resource', 'APP_CONFIG', BcgSurveyService]);
// })();
