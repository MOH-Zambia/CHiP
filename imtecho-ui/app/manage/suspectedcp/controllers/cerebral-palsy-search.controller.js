// (function (angular) {
//     function CerebralPalsySearchController(Mask, AuthenticateService, QueryDAO, GeneralUtil) {
//         var cerebralpalsysearch = this;
//         cerebralpalsysearch.selectedTab = null;
//         cerebralpalsysearch.pagingService = {
//             offSet: 0,
//             limit: 100,
//             index: 0,
//             allRetrieved: false,
//             pagingRetrivalOn: false
//         };

//         var init = function () {
//             Mask.show();
//             AuthenticateService.getLoggedInUser().then(function (user) {
//                 Mask.hide();
//                 cerebralpalsysearch.loggedInUserId = user.data.id;
//                 cerebralpalsysearch.selectedTab = 'cp-list';
//             }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
//                 Mask.hide();
//             });
//         };

//         cerebralpalsysearch.retrieveFilteredMembers = function (searchTab) {
//             if (searchTab === 'cpData') {
//                 if (!cerebralpalsysearch.pagingService.pagingRetrivalOn && !cerebralpalsysearch.pagingService.allRetrieved) {
//                     cerebralpalsysearch.pagingService.pagingRetrivalOn = true;
//                     setOffsetLimit();
//                     let queryDto = {
//                         code: 'cerebral_palsy_cp_list_retrieve',
//                         parameters: {
//                             userId: cerebralpalsysearch.loggedInUserId,
//                             limit: cerebralpalsysearch.pagingService.limit,
//                             offSet: cerebralpalsysearch.pagingService.offSet,
//                         }
//                     };
//                     Mask.show();
//                     QueryDAO.execute(queryDto).then(function (response) {
//                         if (response.result.length === 0) {
//                             cerebralpalsysearch.pagingService.allRetrieved = true;
//                             if (cerebralpalsysearch.pagingService.index === 1) {
//                                 cerebralpalsysearch.cpList = response.result;
//                             }
//                         } else {
//                             cerebralpalsysearch.pagingService.allRetrieved = false;
//                             if (cerebralpalsysearch.pagingService.index > 1) {
//                                 cerebralpalsysearch.cpList = cerebralpalsysearch.cpList.concat(response.result);
//                             } else {
//                                 cerebralpalsysearch.cpList = response.result;
//                             }
//                         }
//                     }, function (err) {
//                         GeneralUtil.showMessageOnApiCallFailure(err);
//                         cerebralpalsysearch.pagingService.allRetrieved = true;
//                     }).finally(function () {
//                         cerebralpalsysearch.cpList.forEach(function (member) {
//                             if (!member.formatChanged) {
//                                 member.dob = moment(member.dob).format("DD-MM-YYYY");
//                                 member.formatChanged = true;
//                             }
//                         })
//                         cerebralpalsysearch.pagingService.pagingRetrivalOn = false;
//                         Mask.hide();
//                     });
//                 }
//             } else if (searchTab === 'statusData') {
//                 if (!cerebralpalsysearch.pagingService.pagingRetrivalOn && !cerebralpalsysearch.pagingService.allRetrieved) {
//                     cerebralpalsysearch.pagingService.pagingRetrivalOn = true;
//                     setOffsetLimit();
//                     let queryDto = {
//                         code: 'cerebral_palsy_status_list_retrieve',
//                         parameters: {
//                             userId: cerebralpalsysearch.loggedInUserId,
//                             limit: cerebralpalsysearch.pagingService.limit,
//                             offSet: cerebralpalsysearch.pagingService.offSet,
//                         }
//                     };
//                     Mask.show();
//                     QueryDAO.execute(queryDto).then(function (response) {
//                         if (response.result.length === 0) {
//                             cerebralpalsysearch.pagingService.allRetrieved = true;
//                             if (cerebralpalsysearch.pagingService.index === 1) {
//                                 cerebralpalsysearch.statusList = response.result;
//                             }
//                         } else {
//                             cerebralpalsysearch.pagingService.allRetrieved = false;
//                             if (cerebralpalsysearch.pagingService.index > 1) {
//                                 cerebralpalsysearch.statusList = cerebralpalsysearch.statusList.concat(response.result);
//                             } else {
//                                 cerebralpalsysearch.statusList = response.result;
//                             }
//                         }
//                     }, function (err) {
//                         GeneralUtil.showMessageOnApiCallFailure(err);
//                         cerebralpalsysearch.pagingService.allRetrieved = true;
//                     }).finally(function () {
//                         cerebralpalsysearch.statusList.forEach(function (member) {
//                             if (!member.formatChanged) {
//                                 member.dob = moment(member.dob).format("DD-MM-YYYY");
//                                 member.formatChanged = true;
//                             }
//                             if (member.status === 'NORMAL_DEVELOPMENT') {
//                                 member.status = 'Normal Development';
//                             } else if (member.status === 'TREATMENT_COMMENCED') {
//                                 member.status = 'Treatment Commenced';
//                             } else if (member.status === 'DELAYED_DEVELOPMENT') {
//                                 member.status = "Delayed Development";
//                             }
//                         })
//                         cerebralpalsysearch.pagingService.pagingRetrivalOn = false;
//                         Mask.hide();
//                     });
//                 }
//             }
//         };

//         cerebralpalsysearch.cpTabSelected = function () {
//             cerebralpalsysearch.pagingService = {
//                 offSet: 0,
//                 limit: 100,
//                 index: 0,
//                 allRetrieved: false,
//                 pagingRetrivalOn: false
//             };
//             cerebralpalsysearch.retrieveFilteredMembers("cpData");
//         }

//         cerebralpalsysearch.statusTabSelected = function () {
//             cerebralpalsysearch.pagingService = {
//                 offSet: 0,
//                 limit: 100,
//                 index: 0,
//                 allRetrieved: false,
//                 pagingRetrivalOn: false
//             };
//             cerebralpalsysearch.retrieveFilteredMembers("statusData");
//         }

//         var setOffsetLimit = function () {
//             cerebralpalsysearch.pagingService.limit = 100;
//             cerebralpalsysearch.pagingService.offSet = cerebralpalsysearch.pagingService.index * 100;
//             cerebralpalsysearch.pagingService.index = cerebralpalsysearch.pagingService.index + 1;
//         };

//         init();
//     }
//     angular.module('imtecho.controllers').controller('CerebralPalsySearchController', CerebralPalsySearchController);
// })(window.angular);
