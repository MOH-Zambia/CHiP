// (function () {
//     function AnemiaSurveyListController($state, $window, toaster, AnemiaSurveyDAO, $stateParams, PagingForQueryBuilderService, GeneralUtil, AuthenticateService, QueryDAO, Mask) {
//         var ctrl = this;

//         var init = function () {
//             Mask.show();
//             AuthenticateService.getLoggedInUser().then(function (res) {
//                 ctrl.user = res.data;
//                 ctrl.getMemberList('ALL', null);
//             }).finally(function () {
//                 Mask.hide();
//             });
//         }

//         ctrl.getMemberList = (status, location) => {
//             Mask.show();
//             var queryDto = {
//                 code: 'get_anemia_survey_member_list',
//                 parameters: {
//                     status: status,
//                     location_id: location
//                 }
//             };

//             QueryDAO.execute(queryDto).then(function (res) {
//                 if (res.result) {
//                     ctrl.memberList = res.result
//                 }
//                 if (!ctrl.modalClosed) {
//                     ctrl.toggleFilter();
//                 }
//             }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
//                 Mask.hide();
//             });
//         }

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
//         };

//         ctrl.searchMembers = function (status, location) {
//             ctrl.searchForm.$setSubmitted();
//             if (ctrl.searchForm.$valid) {
//                 ctrl.getMemberList(status, location);
//             }
//         };

//         ctrl.openDetails = function (id) {
//             let url = $state.href('techo.manage.anemiasurveydetail', { id: id });
//             sessionStorage.setItem('linkClick', 'true')
//             $window.open(url, '_blank');
//         };

//         ctrl.downloadFile = (memberObj) => {
//             if (memberObj.uuid) {
//                 Mask.show();
//                 AnemiaSurveyDAO.downloadMultipleFolders(memberObj.uuid).then(function (res) {
//                     toaster.pop('success', 'File downloaded successfully!');
//                     if (res.data !== null && navigator.msSaveBlob) {
//                         return navigator.msSaveBlob(new Blob([res.data], { type: "application/zip" }));
//                     }
//                     let a = $("<a style='display: none;'/>");
//                     let url = window.URL.createObjectURL(new Blob([res.data], { type: "application/zip" }));
//                     a.attr("href", url);
//                     a.attr("download", 'download.zip');
//                     $("body").append(a);
//                     a[0].click();
//                     window.URL.revokeObjectURL(url);
//                     a.remove();
//                 }).catch((error) => {
//                     GeneralUtil.showMessageOnApiCallFailure(error.data);
//                 }).finally(function () {
//                     Mask.hide();
//                 });

//             } else {
//                 toaster.pop("error", "This Member Does not have UUID,Please add UUID.");
//             }


//         }
//         init();

//     }
//     angular.module('imtecho.controllers').controller('AnemiaSurveyListController', AnemiaSurveyListController);
// })();
