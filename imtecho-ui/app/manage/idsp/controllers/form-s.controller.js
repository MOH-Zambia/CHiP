// (function () {
//     function IDSPFormS(QueryDAO, Mask, GeneralUtil, FormSConstants, $scope, AuthenticateService, IDSPService) {
//         let ctrl = this;
//         ctrl.isPrintClicked = false;
//         ctrl.searchLocationId = null;
//         ctrl.today = new Date();
//         ctrl.reportFromDate = ctrl.today;
//         ctrl.reportToDate = ctrl.today;
//         ctrl.formSData = null;
//         ctrl.formSDataMap = {};
//         ctrl.formSOtherDetails = null;
//         ctrl.constants = FormSConstants;

//         const _init = function () {
//             Mask.show();
//             AuthenticateService.getLoggedInUser().then(user => {
//                 ctrl.loggedInUser = user.data;
//             }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide);
//         }

//         ctrl.searchData = function (reset, toggle) {
//             ctrl.searchForm.$setSubmitted();
//             if (!ctrl.searchForm.$valid) {
//                 return;
//             }
//             let dtoList = [];
//             let dataDto = {
//                 code: 'idsp_from_s_data_retrival',
//                 parameters: {
//                     location_id: ctrl.searchLocationId,
//                     report_from_date: ctrl.reportFromDate,
//                     report_to_date: ctrl.reportToDate
//                 },
//                 sequence: 1
//             };
//             dtoList.push(dataDto);
//             let otherDetailsDto = {
//                 code: 'idsp_from_s_other_detail',
//                 parameters: {
//                     location_id: ctrl.searchLocationId
//                 },
//                 sequence: 2
//             };
//             dtoList.push(otherDetailsDto);
//             Mask.show();
//             QueryDAO.executeAllQuery(dtoList).then(function (responses) {
//                 ctrl.formSData = responses[0].result;
//                 ctrl.formSData.forEach(e => ctrl.formSDataMap[e.reason] = e);
//                 ctrl.formSOtherDetails = responses[1].result[0];
//                 ctrl.toggleFilter();
//             }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide);
//         };

//         ctrl.downloadPdf = function () {
//             ctrl.isPrintClicked = true;
//             $("thead tr th").css("position", "inherit");
//             Mask.show();
//             $('#printableBlock').printThis({
//                 importCSS: false,
//                 loadCSS: 'styles/css/idsp-form-s-printable.css',
//                 header: '',
//                 footer: '',
//                 base: "./",
//                 printDelay: 333,
//                 pageTitle: '',
//                 afterPrint: function () {
//                     $scope.$apply(function () {
//                         Mask.hide();
//                         ctrl.isPrintClicked = false;
//                     })
//                 }
//             })
//         }

//         ctrl.downloadExcel = function () {
//             Mask.show();
//             IDSPService.downloadFormSExcel(ctrl.searchLocationId, ctrl.reportFromDate, ctrl.reportToDate).then(function (res) {
//                 if (res.data !== null && navigator.msSaveBlob) {
//                     return navigator.msSaveBlob(new Blob([res.data], { type: '' }));
//                 }
//                 let a = $("<a style='display: none;'/>");
//                 let url = window.URL.createObjectURL(new Blob([res.data], { type: 'application/vnd.ms-excel' }));
//                 a.attr("href", url);
//                 a.attr("download", "IDSP - Form S (" + moment(new Date(ctrl.reportFromDate)).format('DD-MM-YYYY') + " to " + moment(new Date(ctrl.reportToDate)).format('DD-MM-YYYY') + ").xlsx");
//                 $("body").append(a);
//                 a[0].click();
//                 window.URL.revokeObjectURL(url);
//                 a.remove();
//             }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
//                 Mask.hide();
//             });
//         }

//         ctrl.toggleFilter = function () {
//             if (angular.element('.filter-div').hasClass('active')) {
//                 angular.element('body').css("overflow", "auto");
//             } else {
//                 angular.element('body').css("overflow", "hidden");
//             }
//             angular.element('.cst-backdrop').fadeToggle();
//             angular.element('.filter-div').toggleClass('active');
//         };

//         ctrl.close = function () {
//             ctrl.searchForm.$setPristine();
//             ctrl.toggleFilter();
//         };

//         _init();
//     }
//     angular.module('imtecho.controllers').controller('IDSPFormS', IDSPFormS);
// })();
