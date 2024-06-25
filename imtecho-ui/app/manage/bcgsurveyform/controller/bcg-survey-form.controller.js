// (function () {
//     function BcgSurveyForm($rootScope, $state, QueryDAO, Mask, GeneralUtil, AuthenticateService, toaster, $q, $uibModal, SEARCH_TERM, PagingForQueryBuilderService) {
//         let ctrl = this;

//         ctrl.listOfIneligibleMembers = []

//         ctrl.selectedLocation = {}
//         ctrl.selectedLocationId = null;
//         ctrl.pagingService = PagingForQueryBuilderService.initialize();

//         ctrl.terms = [
//             { name: SEARCH_TERM.memberId, order: 1 },
//             { name: SEARCH_TERM.familyId, order: 2 },
//             { name: SEARCH_TERM.orgUnit, order: 3, config: {isFetchAoi: true} },
//         ];

//         ctrl.search = {};


//         ctrl.init = function () {
//             Mask.show();
//             AuthenticateService.getLoggedInUser().then(function (user) {
//                 ctrl.user = user.data;
//                 // ctrl.selectedLocationId = ctrl.user.minLocationId;
//                 ctrl.minLocationId = ctrl.user.minLocationId;
//             }).catch(function (error) {
//                 GeneralUtil.showMessageOnApiCallFailure(error);
//             }).finally(function () {
//                 Mask.hide();
//             });
//         };

//         ctrl.toggleFilter = function () {
//             ctrl.searchForm.$setPristine();
//             if (angular.element('.filter-div').hasClass('active')) {
//                 ctrl.modalClosed = true;
//                 angular.element('body').css("overflow", "auto");
//             } else {
//                 ctrl.modalClosed = false;
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

//         ctrl.retrieveFilteredMembers = function(reset) {
//             ctrl.searchForm.$setSubmitted();
//             let queryDto = {};

//             ctrl.validForm = true;

            
//             if ((ctrl.search.searchBy === 'organization unit') && ctrl.selectedLocationId == null) {
//                 toaster.pop('error', 'Please select Location');
//                 ctrl.validForm = false;
//             }

            

//             if ((ctrl.search.searchBy === "member id")) {
//                 if (ctrl.search.searchString == undefined) {
//                     ctrl.validForm = false;
//                 }
//                 queryDto = {
//                     code: 'fetch_bcg_ineligible_members',
//                     parameters : {
//                         location_id : ctrl.minLocationId,
//                         filter_type : 'MEMBER',
//                         searchString : ctrl.search.searchString
//                     }
//                 }
//             }
//             if ((ctrl.search.searchBy === "family id")) {
//                 if (ctrl.search.searchString == undefined) {
//                     ctrl.validForm = false;
//                 }
//                 queryDto = {
//                     code: 'fetch_bcg_ineligible_members',
//                     parameters : {
//                         location_id : ctrl.minLocationId,
//                         filter_type : 'FAMILY',
//                         searchString : ctrl.search.searchString
//                     }
//                 }
//             }
//             if ((ctrl.search.searchBy === "organization unit")) {
//                 queryDto = {
//                     code: 'fetch_bcg_ineligible_members',
//                     parameters : {
//                         location_id : ctrl.selectedLocationId,
//                         filter_type : 'LOCATION',
//                         searchString : '',
//                         limit: ctrl.pagingService.limit,
//                         offSet: ctrl.pagingService.offSet
//                     }
//                 }
//             }

//             if (queryDto && ctrl.validForm && ctrl.searchForm.$valid) {
//                 if (reset) {
//                     ctrl.listOfIneligibleMembers = [];
//                     ctrl.pagingService.resetOffSetAndVariables();
//                 }
//                 Mask.show();
//                 ctrl.pagingService.getNextPage(QueryDAO.execute, queryDto, ctrl.listOfIneligibleMembers, null).then((response) => {
//                     ctrl.listOfIneligibleMembers = response;
//                 }).catch((error) => {
//                     GeneralUtil.showMessageOnApiCallFailure(error);
//                 }).finally(() => {
//                     Mask.hide();
//                 });
//             }
            
//         }

//         ctrl.fillForm = function (memberId, bcgId) {
//             $state.go("techo.manage.bcgsurveyfillform", { memberId: memberId, bcgId: bcgId });
//         }

//         ctrl.init();
//     }
//     angular.module('imtecho.controllers').controller('BcgSurveyForm', BcgSurveyForm);
// })();