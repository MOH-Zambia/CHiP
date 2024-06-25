// (function (angular) {
//     function DuplicateMemberVerificationController($uibModal, QueryDAO, AuthenticateService, Mask, PagingService, toaster, GeneralUtil, $timeout) {
//         var dmv = this;
//         dmv.reports = [];
//         dmv.pagingService = PagingService.initialize();
//         dmv.pageVal = {};
//         dmv.currentUser = {};
//         var init = function () {
//             dmv.selectedLocation = null;
//             //for get logged in user data
//             AuthenticateService.getLoggedInUser().then(function (res) {
//                 dmv.currentUser = res.data;
//                 //this is for fixed header for table at initial page load
//                 $timeout(function () {
//                     $(".header-fixed").tableHeadFixer();
//                 });
//                 dmv.retrieveAll();
//             });
//         };
//         //Retrieve duplicate member details
//         dmv.retrieveAll = function (reset) {
//             Mask.show();
//             if (reset) {
//                 dmv.pagingService.resetOffSetAndVariables();
//                 dmv.duplicateData = [];
//             }
//             var dto = {
//                 code: 'retrieve_duplicate_member_det',
//                 parameters: {
//                     logged_in_user: dmv.currentUser.id,
//                     limit: dmv.pagingService.limit,
//                     offset: dmv.pagingService.offSet
//                 }
//             };
//             PagingService.getNextPage(QueryDAO.executeQueryForFamilyReport, dto, dmv.duplicateData).then(function (res) {
//                 if (res) {
//                     dmv.duplicateData = res;
//                     _.each(dmv.duplicateData, function (data) {
//                         data.inValidMember1 = false;
//                         data.inValidMember2 = false;
//                     });
//                 }
//                 Mask.hide();
//             });
//         };
//         //        dmv.retrieveFilteredReports = function () {
//         //            dmv.locationForm.$setSubmitted();
//         //            if (dmv.locationForm.$valid) {
//         //                dmv.toggleFilter();
//         //                dmv.retrieveAll(true);
//         //            }
//         //        };
//         dmv.toggleFilter = function () {
//             if (angular.element('.filter-div').hasClass('active')) {
//                 angular.element('body').css("overflow", "auto");
//             } else {
//                 angular.element('body').css("overflow", "hidden");
//             }
//             angular.element('.cst-backdrop').fadeToggle();
//             angular.element('.filter-div').toggleClass('active');
//         };
//         dmv.onShowMoreDetail = function (dataObject, index) {
//             dataObject.showDetials = !dataObject.showDetials;
//             //for scrolling the details after selected row
//             $('html, tbody').animate({
//                 scrollTop: $('.table .cst-tbody').find('tr').eq(index * 2).offset().top
//             }, 800);
//         };
//         //If member is valid or not that will be save here
//         dmv.saveVerification = function (dataObject) {
//             if (dataObject) {
//                 if (dataObject.inValidMember2 && dataObject.inValidMember1) {
//                     toaster.pop('error', "You can not mark both members as invalid");
//                     return;
//                 }
//                 var modalInstance;
//                 if (!dataObject.inValidMember2 && !dataObject.inValidMember1) {
//                     modalInstance = $uibModal.open({
//                         templateUrl: 'app/common/views/confirmation.modal.html',
//                         controller: 'ConfirmModalController',
//                         size: 'med',
//                         resolve: {
//                             message: function () {
//                                 return 'Are you sure both the members are valid?';
//                             }
//                         }
//                     });
//                 } else {
//                     modalInstance = $uibModal.open({
//                         templateUrl: 'app/common/views/confirmation.modal.html',
//                         controller: 'ConfirmModalController',
//                         size: 'med',
//                         resolve: {
//                             message: function () {
//                                 return 'Are you sure you want to mark this member as duplicate?';
//                             }
//                         }
//                     });
//                 }
//                 modalInstance.result.then(function () {
//                     var dtoList = [];
//                     var dto1 = {
//                         code: 'save_duplicate_member_det',
//                         parameters: {
//                             id: dataObject.id,
//                             is_member1_valid: !dataObject.inValidMember1,
//                             is_member2_valid: !dataObject.inValidMember2,
//                             action_by: dmv.currentUser.id
//                         },
//                         sequence: 1
//                     };
//                     dtoList.push(dto1);
//                     if (dataObject.inValidMember2 || dataObject.inValidMember1) {
//                         var member_id = '';
//                         if (dataObject.inValidMember2) {
//                             member_id = dataObject.member2_id;
//                         } else {
//                             member_id = dataObject.member1_id;
//                         }
//                         var dto2 = {
//                             code: 'mark_member_as_duplicate',
//                             parameters: {
//                                 member_id: member_id,
//                                 action_by: dmv.currentUser.id
//                             },
//                             sequence: 2
//                         };
//                         dtoList.push(dto2);
//                     }
//                     Mask.show();
//                     QueryDAO.executeAllQuery(dtoList).then(function (res) {
//                         dataObject.showDetials = false;
//                         dmv.retrieveAll(true);
//                     }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
//                         Mask.hide();
//                     });
//                 });
//             }
//         };
//         init();
//     }
//     angular.module('imtecho.controllers').controller('DuplicateMemberVerificationController', DuplicateMemberVerificationController);
// })(window.angular);