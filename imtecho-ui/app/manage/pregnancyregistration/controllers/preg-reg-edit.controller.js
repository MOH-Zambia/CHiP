// (function (angular) {
//     function PregnancyRegistration(Mask, toaster, QueryDAO, $uibModal, GeneralUtil) {
//         var pregreg = this;
//         pregreg.selectedTab = 'preg-reg-list';
//         pregreg.search = {};
//         pregreg.noRecordsFound = true;
//         pregreg.pagingService = {
//             offSet: 0,
//             limit: 100,
//             index: 0,
//             allRetrieved: false,
//             pagingRetrivalOn: false
//         };

//         var init = function () {
//             pregreg.memberDetails = [];
//         };

//         pregreg.toggleFilter = function () {
//             if (angular.element('.filter-div').hasClass('active')) {
//                 pregreg.modalClosed = true;
//                 angular.element('body').css("overflow", "auto");
//             } else {
//                 pregreg.modalClosed = false;
//                 angular.element('body').css("overflow", "hidden");
//             }
//             angular.element('.cst-backdrop').fadeToggle();
//             angular.element('.filter-div').toggleClass('active');
//             if (CKEDITOR.instances) {
//                 for (var ck_instance in CKEDITOR.instances) {
//                     CKEDITOR.instances[ck_instance].destroy();
//                 }
//             }
//         };

//         pregreg.retrieveFilteredMembers = function () {
//             if (pregreg.selectedLocationId == null) {
//                 toaster.pop('error', 'Please select Location')
//             } else {
//                 if (!pregreg.pagingService.pagingRetrivalOn && !pregreg.pagingService.allRetrieved) {
//                     pregreg.pagingService.pagingRetrivalOn = true;
//                     setOffsetLimit();
//                     pregreg.selectedTab = 'preg-reg-list';
//                     pregreg.noRecordsFound = true;
//                     if (pregreg.searchForm.$valid) {
//                         var queryDto = {
//                             code: 'preg_reg_date_edit_list_retrieve',
//                             parameters: {
//                                 locationId: pregreg.selectedLocationId,
//                                 from_date: moment(pregreg.getDate(pregreg.fromDate)).format('DD-MM-YYYY HH:mm:ss'),
//                                 to_date: moment(pregreg.getDate(pregreg.toDate)).format('DD-MM-YYYY HH:mm:ss'),
//                                 limit: pregreg.pagingService.limit,
//                                 offSet: pregreg.pagingService.offSet
//                             }
//                         };
//                         Mask.show();
//                         QueryDAO.execute(queryDto).then(function (response) {
//                             Mask.hide();
//                             if (response.result.length == 0 || response.result.length < pregreg.pagingService.limit) {
//                                 pregreg.pagingService.allRetrieved = true;
//                                 if (pregreg.pagingService.index === 1) {
//                                     pregreg.memberDetails = response.result;
//                                 }
//                             } else {
//                                 pregreg.pagingService.allRetrieved = false;
//                                 if (pregreg.pagingService.index > 1) {
//                                     pregreg.memberDetails = pregreg.memberDetails.concat(response.result);
//                                 } else {
//                                     pregreg.memberDetails = response.result;
//                                 }
//                             }
//                         }, function () {
//                             Mask.hide();
//                             toaster.pop('error', 'Unable to retrieve pregnant members list');
//                             pregreg.pagingService.allRetrieved = true;
//                         }).finally(function () {
//                             pregreg.pagingService.pagingRetrivalOn = false;
//                             Mask.hide();
//                         });
//                     }
//                 }
//             }
//         };

//         pregreg.searchData = function (reset) {
//             pregreg.searchForm.$setSubmitted();
//             if (pregreg.searchForm.$valid) {
//                 if (reset) {
//                     pregreg.toggleFilter();
//                     pregreg.pagingService.index = 0;
//                     pregreg.pagingService.allRetrieved = false;
//                     pregreg.pagingService.pagingRetrivalOn = false;
//                     pregreg.memberDetails = [];
//                 }
//                 pregreg.retrieveFilteredMembers();
//             }
//         };

//         var setOffsetLimit = function () {
//             pregreg.pagingService.limit = 100;
//             pregreg.pagingService.offSet = pregreg.pagingService.index * 100;
//             pregreg.pagingService.index = pregreg.pagingService.index + 1;
//         };

//         pregreg.markDateAsCorrect = function (pregId) {
//             var queryDto = {
//                 code: 'preg_reg_date_edit_mark_correct',
//                 parameters: {
//                     pregId: Number(pregId)
//                 }
//             };
//             Mask.show();
//             QueryDAO.execute(queryDto).then(function () {
//                 Mask.hide();
//                 toaster.pop('success', "Date marked as correct");
//                 pregreg.pagingService.index = 0;
//                 pregreg.pagingService.allRetrieved = false;
//                 pregreg.pagingService.pagingRetrivalOn = false;
//                 pregreg.memberDetails = [];
//                 pregreg.retrieveFilteredMembers();
//             }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
//                 Mask.hide();
//                 $uibModalInstance.close();
//             })
//         }

//         pregreg.markDateAsIncorrect = function (pregId, lmpDate, regDate, ancVisitDate) {
//             var modalInstance = $uibModal.open({
//                 templateUrl: 'app/manage/pregnancyregistration/views/preg-reg-edit-modal.html',
//                 controller: 'PregRegEditModal',
//                 windowClass: 'cst-modal',
//                 size: 'md',
//                 resolve: {
//                     pregData: function () {
//                         return {
//                             pregId: pregId,
//                             lmpDate: lmpDate,
//                             regDate: regDate,
//                             ancVisitDate: ancVisitDate
//                         }
//                     }
//                 }
//             });
//             modalInstance.result.then(function () {
//                 pregreg.pagingService.index = 0;
//                 pregreg.pagingService.allRetrieved = false;
//                 pregreg.pagingService.pagingRetrivalOn = false;
//                 pregreg.memberDetails = [];
//                 pregreg.retrieveFilteredMembers();
//             }, function () { });
//         }

//         pregreg.getDate = (date) => {
//             return new Date(
//                 date.getFullYear(),
//                 date.getMonth(),
//                 date.getDate(),
//                 00,
//                 00
//             );
//         }

//         init();
//     }
//     angular.module('imtecho.controllers').controller('PregnancyRegistration', PregnancyRegistration);
// })(window.angular);
