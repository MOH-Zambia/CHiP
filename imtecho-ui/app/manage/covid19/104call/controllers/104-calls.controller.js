// (function () {
//     function Calls104Controller(Mask, QueryDAO, GeneralUtil, AuthenticateService, $state) {
//         var calls104Ctrl = this;
//         calls104Ctrl.covid19Cases = [];
//         calls104Ctrl.pagingService = {
//             offSet: 0,
//             limit: 100,
//             index: 0,
//             allRetrieved: false,
//             pagingRetrivalOn: false
//         };

//         calls104Ctrl.init = () => {
//             Mask.show();
//             AuthenticateService.getLoggedInUser().then((response) => {
//                 calls104Ctrl.currentUser = response.data;
//                 calls104Ctrl.retrieveMembers(true);
//             }).catch((error) => {
//                 GeneralUtil.showMessageOnApiCallFailure(error);
//             }).finally(() => {
//                 Mask.hide();
//             });
//         };

//         calls104Ctrl.retrieveMembers = (reset) => {
//             if (reset) {
//                 calls104Ctrl.pagingService.index = 0;
//                 calls104Ctrl.pagingService.allRetrieved = false;
//                 calls104Ctrl.pagingService.pagingRetrivalOn = false;
//                 calls104Ctrl.covid19Cases = [];
//             }
//             if (!calls104Ctrl.pagingService.pagingRetrivalOn && !calls104Ctrl.pagingService.allRetrieved) {
//                 calls104Ctrl.pagingService.pagingRetrivalOn = true;
//                 setOffsetLimit();
//                 Mask.show();
//                 QueryDAO.execute({
//                     code: 'retrieve_all_gvk_covid_104_calls_response',
//                     parameters: {
//                         limit: calls104Ctrl.pagingService.limit,
//                         offSet: calls104Ctrl.pagingService.offSet
//                     }
//                 }).then((response) => {
//                     if (response.result.length == 0 || response.result.length < calls104Ctrl.pagingService.limit) {
//                         calls104Ctrl.pagingService.allRetrieved = true;
//                         if (calls104Ctrl.pagingService.index === 1) {
//                             calls104Ctrl.covid19Cases = response.result;
//                         }
//                     } else {
//                         calls104Ctrl.pagingService.allRetrieved = false;
//                         if (calls104Ctrl.pagingService.index > 1) {
//                             calls104Ctrl.covid19Cases = calls104Ctrl.covid19Cases.concat(response.result);
//                         } else {
//                             calls104Ctrl.covid19Cases = response.result;
//                         }
//                     }
//                 }).catch((error) => {
//                     GeneralUtil.showMessageOnApiCallFailure(error);
//                     calls104Ctrl.pagingService.allRetrieved = true;
//                 }).finally(() => {
//                     calls104Ctrl.pagingService.pagingRetrivalOn = false;
//                     Mask.hide();
//                 });
//             }
//         }

//         calls104Ctrl.onEdit = function (id) {
//             $state.go('techo.manage.manage104Calls', { id: id });
//         };

//         calls104Ctrl.onAdd = function () {
//             $state.go('techo.manage.manage104Calls');
//         };

//         var setOffsetLimit = () => {
//             calls104Ctrl.pagingService.limit = 100;
//             calls104Ctrl.pagingService.offSet = calls104Ctrl.pagingService.index * 100;
//             calls104Ctrl.pagingService.index = calls104Ctrl.pagingService.index + 1;
//         };

//         calls104Ctrl.init();
//     }
//     angular.module('imtecho.controllers').controller('Calls104Controller', Calls104Controller);
// })();
