// (function () {
//     function DailyActivityRegisterSearch(Mask, GeneralUtil, $state, SEARCH_TERM, UserDAO, PagingService) {
//         let ctrl = this;
        
//         ctrl.init = function () {
//             ctrl.pagingService = PagingService.initialize();
//             ctrl.search = {};
//             ctrl.terms = [
//                 { name: SEARCH_TERM.username, order: 1},
//                 { name: SEARCH_TERM.location, order: 2, config: {requiredUptoLevel: 1, isFetchAoi: true}},
//                 { name: SEARCH_TERM.name, order: 3, config: {requiredUptoLevel: 1, isFetchAoi: true}},
//                 { name: SEARCH_TERM.contactNumber, order: 4},
//             ];
//             ctrl.toggleFilter();
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

//         ctrl.retrieveFilteredUsers = function(reset){
//             if (ctrl.searchForm.$valid) {
//                 if (reset) {
//                     ctrl.pagingService.resetOffSetAndVariables();
//                     ctrl.userDetails = [];
//                 }
//                 let search = {};
//                 search.byUsername = ctrl.search.searchBy === 'username' && ctrl.search.searchString !== '';
//                 search.byContactNumber = ctrl.search.searchBy === 'contact number' && ctrl.search.searchString !== '';
//                 search.byName = ctrl.search.searchBy === 'name' && ctrl.search.searchString !== '';
//                 search.byLocation = ctrl.search.searchBy === 'location' && ctrl.search.searchString !== '';
//                 search.locationId = ctrl.selectedLocationId;
//                 search.searchString = ctrl.search.searchString;
//                 search.limit = ctrl.pagingService.limit;
//                 search.offSet = ctrl.pagingService.offSet;
//                 Mask.show();
//                 PagingService.getNextPage(UserDAO.retrieveUsers, search, ctrl.userDetails).then(function (res) {
//                     ctrl.userDetails = res;
//                     if (reset) {
//                         ctrl.toggleFilter();
//                     }
//                 }).catch(function (error) {
//                     GeneralUtil.showMessageOnApiCallFailure(error);
//                 }).finally(function () {
//                     Mask.hide();
//                 });
//             }
//         }
//         ctrl.previewClicked=function(data){
//             $state.go('techo.manage.integrateddailyregister',{"id":data})
//         }
      
      
//         ctrl.init();
//     }
//     angular.module('imtecho.controllers').controller('DailyActivityRegisterSearch', DailyActivityRegisterSearch);
// })();