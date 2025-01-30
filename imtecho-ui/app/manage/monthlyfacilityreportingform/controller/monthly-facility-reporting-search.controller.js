(function () {
    function 
    MonthlyFacilityReportingFormSearch(Mask, GeneralUtil, $state,ManualSyncService, AuthenticateService,PagingForQueryBuilderService, QueryDAO, $uibModal, toaster) {
        let ctrl = this;
        ctrl.month;
        ctrl.maxMonth= new Date();
        ctrl.selectedFacilities = [];
        ctrl.pagingService = PagingForQueryBuilderService.initialize();
        ctrl.init = function () {
            AuthenticateService.getLoggedInUser().then(function (res) {
                ctrl.currentUser = res.data;
                ctrl.locationId = ctrl.currentUser.minLocationId;
                
                ctrl.retrieveFacility(true);
            });
            
            ctrl.toggleFilter();
        }

        ctrl.toggleFilter = function () {
            if (angular.element('.filter-div').hasClass('active')) {
                angular.element('body').css("overflow", "auto");
            } else {
                angular.element('body').css("overflow", "hidden");
            }
            angular.element('.cst-backdrop').fadeToggle();
            angular.element('.filter-div').toggleClass('active');
        };

        ctrl.close = function () {
            ctrl.toggleFilter();
        };

        ctrl.retrieveFacility = function (reset) {
            if (reset) {
                ctrl.pagingService.resetOffSetAndVariables();
            }
            let dto = 
                {
                    code: 'get_all_health_facilities',
                    parameters: {
                        locationId: ctrl.locationId,
                        limit: ctrl.pagingService.limit,
                    offSet: ctrl.pagingService.offSet
                    }
                }
            Mask.show();

            PagingForQueryBuilderService.getNextPage(QueryDAO.execute, dto, ctrl.facilities, null).then((response) => {
                ctrl.facilities = response;
                
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
       
        }

        ctrl.searchData = function () {
            ctrl.locationId = ctrl.selectedLocationId;
            ctrl.retrieveFacility(true);
        };

        ctrl.showModal = function(facilityId){
            var modalInstance = $uibModal.open({
                templateUrl: 'app/manage/monthlyfacilityreportingform/views/monthly-sync-modal.html',
                controller: 'MonthlySyncModalController',
                controllerAs: 'mdctrl',
                windowClass: 'cst-modal',
                size: 'med',
                resolve: {
                    message: function () {
                        return "select month";
                    },
                    facilityId: function () {
                        return facilityId; 
                    }               
                }
            });
        };

        ctrl.toggleState = function (facility) {
            let changedState;
            if (facility.is_enabled === true) {
                changedState = false;
            } else {
                changedState = true;
            }

            let dto1 = 
                {
                    code: 'update_health_infra',
                    parameters: {
                        id: facility.facility_id,
                        isEnabled: changedState
                    }
                }

            var modalInstance = $uibModal.open({
                templateUrl: 'app/common/views/confirmation.modal.html',
                controller: 'ConfirmModalController',
                windowClass: 'cst-modal',
                size: 'med',
                resolve: {
                    message: function () {
                        return "Are you sure you want to change status from " + facility.is_enabled + ' to ' + changedState + '?';
                    }
                }
            });
            modalInstance.result.then(function () {
                Mask.show();
                QueryDAO.executeQuery(dto1).then(function () {
                    toaster.pop('success', 'Facility status changed from ' + facility.is_enabled + ' to ' + changedState + ' successfully');
                    ctrl.searchData();
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                });
            });
        };


        ctrl.changeSelection = function (facility,fact) {
            if (fact) {
                
                if (!ctrl.selectedFacilities.includes(facility)) {
                    ctrl.selectedFacilities.push(facility);

                    
                }
            } else {
                ctrl.selectedFacilities = ctrl.selectedFacilities.filter(function (id) {
                    return id !== facility;
                });
            }
        
            
        };

        ctrl.toggleAll = function () {

            ctrl.selectedFacilities = [];

            ctrl.facilities.forEach((facility) => {
                facility.isSelected = false;
            })
            
        
        };

        ctrl.onMonthChange = function(selectedMonth) {
            if (selectedMonth) {
                var formattedDate = moment(selectedMonth).format('MM/DD/YYYY')
                
            } 
        };

        ctrl.syncMultiple = function () {
            if (!ctrl.month) {
                toaster.pop('error', 'Error', 'Please select a month for syncing.');
                return;
            }
            if (ctrl.selectedFacilities.length == 0){
                toaster.pop('error', 'Error', 'Please select facilities for sync.');
                return;
            }

            Mask.show();
            var formattedDate = moment(ctrl.month).format('MM/DD/YYYY');

            ManualSyncService.sendMultipleData(formattedDate, ctrl.selectedFacilities).then(function (response) {
                
                toaster.pop('success', 'Success', 'Data synchronized successfully.');
                
            }).catch(function (error) {
                toaster.pop('error', 'Error', 'Data synchronization failed.');
              
            }).finally(() => {
                Mask.hide();
            });
        
            
            
        };

        ctrl.syncAll = function () {
            if (!ctrl.month) {
                toaster.pop('error', 'Error', 'Please select a month for syncing.');
                return;
            }

            Mask.show();
            var formattedDate = moment(ctrl.month).format('MM/DD/YYYY');

            ManualSyncService.sendAll(formattedDate).then(function (response) {
                
                toaster.pop('success', 'Success', 'Data synchronized successfully.');
                
            }).catch(function (error) {
                toaster.pop('error', 'Error', 'Data synchronization failed.');
              
            }).finally(() => {
                Mask.hide();
            });
        
            
            
        };


        ctrl.previewClicked=function(data){
            $state.go('techo.manage.monthlyfacilityreportingform',{"id":data})
        }
      
      
        ctrl.init();
    }
    angular.module('imtecho.controllers').controller('MonthlyFacilityReportingFormSearch', MonthlyFacilityReportingFormSearch);
})();


(function () {
    function MonthlySyncModalController($uibModalInstance, message, ManualSyncService, facilityId, toaster, Mask) {
        var mdctrl = this;
        mdctrl.maxMonth= new Date();
        
        if (angular.isString(message)) {
            this.message = message;
        } else if (angular.isObject(message)) {
            this.message = message.body;
            this.title = message.title;
        }

        this.ok = function () {
            $uibModalInstance.close();
        };
        this.cancel = function () {
            $uibModalInstance.dismiss('cancel');
        };

        this.confirmSync = function () {
            if (!mdctrl.month) {
                toaster.pop('error', 'Error', 'Please select a month for syncing.');
                return;
            }
            Mask.show();

            var formattedDate = moment(mdctrl.month).format('MM/DD/YYYY');

            ManualSyncService.sendData(formattedDate, facilityId).then(function (response) {
                toaster.pop('success', 'Success', 'Data synchronized successfully.');
                $uibModalInstance.close();  
            }).catch(function (error) {
                toaster.pop('error', 'Error', 'Data synchronization failed.');
                $uibModalInstance.close();
            }).finally(() => {
                Mask.hide();
            });
            
        };

    };
    angular.module('imtecho.controllers').controller('MonthlySyncModalController', MonthlySyncModalController);
})();