(function () {
    function MonthlyReportingFormSearch(Mask, GeneralUtil, $state, SEARCH_TERM, UserDAO, PagingService, $scope, AuthenticateService, QueryDAO) {
        let ctrl = this;

        ctrl.selectedLocation = {}
        ctrl.loggedInUser = {}
        ctrl.healthFacilities;
        ctrl.selectedLocationId;
        ctrl.selectedHealthInfraId;

        
        ctrl.init = function () {
            AuthenticateService.getLoggedInUser().then(function(res){
                ctrl.loggedInUser = res.data
            })
            ctrl.pagingService = PagingService.initialize();
            ctrl.search = {};
            ctrl.terms = [
                { name: SEARCH_TERM.username, order: 1},
                { name: SEARCH_TERM.location, order: 2, config: {requiredUptoLevel: 1, isFetchAoi: true}},
                { name: SEARCH_TERM.name, order: 3, config: {requiredUptoLevel: 1, isFetchAoi: true}},
                { name: SEARCH_TERM.contactNumber, order: 4},
            ];
            ctrl.toggleFilter();

            ctrl.fetchHealthFacilities();

            // Watch for changes in selectedLocation
            ctrl.watchSelectedLocation();
        }

        ctrl.fetchHealthFacilities = function () {
            if(ctrl.selectedLocation && ctrl.selectedLocation.finalSelected && ctrl.selectedLocation.finalSelected.level === 5 && ctrl.selectedLocation.finalSelected.optionSelected != null){
                Mask.show();
                QueryDAO.executeQuery({
                    code: 'fetch_health_facilty_details_for_filter',
                    parameters: {
                        location_id: ctrl.selectedLocation.locationId,
                        loggedInUserId: ctrl.loggedInUser.id
                    }
                }).then((response) => {
                    ctrl.healthFacilities = response.result;
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                });
            }
        }

        ctrl.healthFacilityChanged = ()=>{
            ctrl.selectedLocation.healthInfraId = ctrl.selectedHealthInfraId;
        }

        ctrl.watchSelectedLocation = function () {
            $scope.$watch(
                function () {
                    return ctrl.selectedLocation;
                },
                function (newVal, oldVal) {
                    if(ctrl.selectedLocation && ctrl.selectedLocation.finalSelected && ctrl.selectedLocation.finalSelected.level === 5){
                        if(ctrl.selectedLocation.finalSelected.optionSelected == null){
                            ctrl.selectedHealthInfraId = null;
                        }
                    }else{
                        ctrl.selectedHealthInfraId = null;
                    }
                    ctrl.selectedLocation.healthInfraId = ctrl.selectedHealthInfraId;
                    if (newVal !== oldVal || (ctrl.selectedLocation && ctrl.selectedLocation.finalSelected && ctrl.selectedLocation.finalSelected.level === 5 && ctrl.selectedLocation.finalSelected.optionSelected != null)) {
                        ctrl.fetchHealthFacilities();
                    }
                },
                true // Deep watch to detect object changes
            );
        };

        ctrl.toggleFilter = function () {
            if (angular.element('.filter-div').hasClass('active')) {
                angular.element('body').css("overflow", "auto");
            } else {
                angular.element('body').css("overflow", "hidden");
            }
            angular.element('.cst-backdrop').fadeToggle();
            angular.element('.filter-div').toggleClass('active');
        };

        ctrl.retrieveFilteredUsers = function(reset){
            if (ctrl.searchForm.$valid) {
                if (reset) {
                    ctrl.pagingService.resetOffSetAndVariables();
                    ctrl.userDetails = [];
                }
                let search = {};
                search.byUsername = ctrl.search.searchBy === 'username' && ctrl.search.searchString !== '';
                search.byContactNumber = ctrl.search.searchBy === 'contact number' && ctrl.search.searchString !== '';
                search.byName = ctrl.search.searchBy === 'name' && ctrl.search.searchString !== '';
                search.byLocation = ctrl.search.searchBy === 'location' && ctrl.search.searchString !== '';
                search.locationId = ctrl.selectedLocationId;
                search.searchString = ctrl.search.searchString;
                search.limit = ctrl.pagingService.limit;
                search.offSet = ctrl.pagingService.offSet;
                search.healthInfraId = ctrl.selectedHealthInfraId;
                Mask.show();
                PagingService.getNextPage(UserDAO.retrieveUsers, search, ctrl.userDetails).then(function (res) {
                    ctrl.userDetails = res;
                    
                    if (reset) {
                        ctrl.toggleFilter();
                    }
                }).catch(function (error) {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(function () {
                    Mask.hide();
                });
            }
        }
        ctrl.previewClicked=function(data){
            $state.go('techo.manage.monthlyreportingform',{"id":data})
        }
      
      
        ctrl.init();
    }
    angular.module('imtecho.controllers').controller('MonthlyReportingFormSearch', MonthlyReportingFormSearch);
})();