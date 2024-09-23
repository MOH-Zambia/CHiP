(function () {
    function 
    MonthlyFacilityReportingFormSearch(Mask, GeneralUtil, $state, AuthenticateService, QueryDAO, $uibModal, toaster) {
        let ctrl = this;
        ctrl.month;

        ctrl.init = function () {
            AuthenticateService.getLoggedInUser().then(function (res) {
                ctrl.currentUser = res.data;
                ctrl.locationId = ctrl.currentUser.minLocationId;
                ctrl.retrieveFacility();
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

        ctrl.retrieveFacility = function () {
            let dto = 
                {
                    code: 'get_all_health_facilities',
                    parameters: {
                        locationId: ctrl.locationId
                    }
                }
            Mask.show();
            QueryDAO.executeQuery(dto).then(function(res) {
                
                     ctrl.facilities = res.result;
                    }
                
            , GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        }

        ctrl.searchData = function () {
            ctrl.locationId = ctrl.selectedLocationId;
            ctrl.retrieveFacility();
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


        ctrl.previewClicked=function(data){
            $state.go('techo.manage.monthlyfacilityreportingform',{"id":data})
        }
      
      
        ctrl.init();
    }
    angular.module('imtecho.controllers').controller('MonthlyFacilityReportingFormSearch', MonthlyFacilityReportingFormSearch);
})();


(function () {
    function MonthlySyncModalController($uibModalInstance, message, ManualSyncService, facilityId, toaster) {
        var mdctrl = this;
        
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

            var formattedDate = moment(mdctrl.month).format('MM/DD/YYYY');

            ManualSyncService.sendData(formattedDate, facilityId).then(function (response) {
                toaster.pop('success', 'Success', 'Data synchronized successfully.');
                $uibModalInstance.close();  
            }).catch(function (error) {
                toaster.pop('error', 'Error', 'Data synchronization failed.');
                $uibModalInstance.close();
            });
            
        };

    };
    angular.module('imtecho.controllers').controller('MonthlySyncModalController', MonthlySyncModalController);
})();