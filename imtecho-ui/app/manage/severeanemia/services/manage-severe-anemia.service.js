// (function () {
//     function ManageSevereAnemiaDAO($resource, APP_CONFIG) {
//         var api = $resource(APP_CONFIG.apiPath + '/memberAnemiaSurvey/:action/:subaction/:id', {},
//             {
//                 storeAnemiaSurveyDetails: {
//                     method: 'POST'
//                 },
//                 retrieveAnemiaStatus: {
//                     method: 'GET'
//                 }
//             });
//         return {
//             storeAnemiaSurveyDetails: function (memberAnemiaSurveyDetailsDto) {
//                 return api.storeAnemiaSurveyDetails({ action: 'create' }, memberAnemiaSurveyDetailsDto).$promise;
//             },
//             retrieveAnemiaStatus: function (gender, haemoglobin, dob, is_pregnant) {
//                 return api.retrieveAnemiaStatus({ action: 'getanemiastatus', gender: gender, haemoglobin: haemoglobin, dob: dob, is_pregnant:is_pregnant }).$promise;
//             }
//         };
//     }
//     angular.module('imtecho.service').factory('ManageSevereAnemiaDAO', ['$resource', 'APP_CONFIG', ManageSevereAnemiaDAO]);
// })();