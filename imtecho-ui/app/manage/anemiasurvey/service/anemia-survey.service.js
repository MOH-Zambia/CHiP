// (function () {
//     function AnemiaSurveyDAO($resource, APP_CONFIG) {
//         var api = $resource(APP_CONFIG.apiPath + '/minio/:action', {},
//             {

//                 downloadMultipleFolders: {
//                     params: {
//                         action: 'download'
//                     },
//                     method: 'get',
//                     isArray: false,
//                     responseType: 'arraybuffer',
//                     transformResponse: function (res) {
//                         return {
//                             data: res
//                         };
//                     }
//                 },
//                 examineImage: {
//                     method: 'get',
//                     isArray: false,
//                     responseType: 'json',
//                     transformResponse: function (res) {
//                         return {
//                             data: res
//                         };
//                     }
//                 },
//                 getImages: {
//                     method: 'get',
//                     isArray: false,
//                     responseType: 'json',
//                     transformResponse: function (res) {
//                         return {
//                             data: res
//                         };
//                     }
//                 },
//                 deleteImages: {
//                     method: 'delete'
//                 }

//             });

//         return {
//             downloadMultipleFolders: function (uuid) {
//                 return api.downloadMultipleFolders({ uuid: uuid }).$promise;
//             },
//             examineImage: function (uuid) {
//                 return api.examineImage({ action: 'examine', uuid: uuid }).$promise;
//             },
//             getImages: function (uuid) {
//                 return api.getImages({ action: 'images', uuid: uuid }).$promise;
//             },
//             deleteImages: function ( uuid, folders) {
//                 return api.deleteImages({ action: 'delete', uuid: uuid, folders: folders }).$promise;
//             }

//         };
//     }
//     angular.module('imtecho.service').factory('AnemiaSurveyDAO', ['$resource', 'APP_CONFIG', AnemiaSurveyDAO]);
// })();

