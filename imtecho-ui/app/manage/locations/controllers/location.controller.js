(function () {
    function LocationController(Mask, LocationService, $timeout, $uibModal, AuthenticateService, $state, $q, QueryDAO, GeneralUtil, toaster) {
        var ctrl = this;
        ctrl.selectedLocation = null;
        ctrl.locationList = [];
        ctrl.editableLocationTypes = [];
        ctrl.deletetableLocationTypes = [];

        ctrl.init = () => {
            let promises = [
                AuthenticateService.getLoggedInUser(),
                AuthenticateService.getAssignedFeature($state.current.name),
            ];
            Mask.show();
            $q.all(promises).then((response) => {
                ctrl.loggedInUser = response[0];
                ctrl.rights = response[1].featureJson;
                if (!ctrl.rights) {
                    ctrl.rights = {};
                }
                ctrl.manageLocationActions();
            })
        }

        ctrl.manageLocationActions = () => {
            let promises = [
                QueryDAO.execute({
                    code: 'retrieve_location_types_rights_by_role_action',
                    parameters: {
                        roleId: ctrl.loggedInUser.data.roleId,
                        action: 'canUpdate'
                    }
                }), QueryDAO.execute({
                    code: 'retrieve_location_types_rights_by_role_action',
                    parameters: {
                        roleId: ctrl.loggedInUser.data.roleId,
                        action: 'canDelete'
                    }
                })
            ]

            $q.all(promises).then((response) => {
                if (response[0] && Array.isArray(response[0].result) && response[0].result.length) {
                    ctrl.editableLocationTypes = response[0].result.map(r => r.location_type);
                }
                if (response[1] && Array.isArray(response[1].result) && response[1].result.length) {
                    ctrl.deletetableLocationTypes = response[1].result.map(r => r.location_type);
                }
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        ctrl.submit = function () {
            if (ctrl.locationId != null) {
                Mask.show();
                LocationService.retrieveNextLevelOfGivenLocationId(ctrl.locationId).then(function (res) {
                    ctrl.locationList = res;
                    ctrl.toggleFilter();
                }).finally(function () {
                    $timeout(function () {
                        $(".header-fixed").tableHeadFixer();
                    });
                    Mask.hide();
                })
            }
        }

        ctrl.toggleFilter = function () {
            if (angular.element('.filter-div').hasClass('active')) {
                angular.element('body').css("overflow", "auto");
            } else {
                angular.element('body').css("overflow", "hidden");
            }
            angular.element('.cst-backdrop').fadeToggle();
            angular.element('.filter-div').toggleClass('active');
        }

        ctrl.editLocation = function (id, location) {
            var modalInstance = $uibModal.open({
                templateUrl: 'app/manage/locations/views/edit-location.html',
                controller: 'EditLocationController',
                controllerAs: 'editlocationctrl',
                windowClass: 'cst-modal',
                size: 'lg',
                resolve: {
                    location: function () {
                        return location;
                    },
                    id: function () {
                        return id;
                    },
                    rights: function () {
                        return ctrl.rights;
                    }
                }
            });
            modalInstance.result.then(function () { }, function (e) {
                if (e == 'success') {
                    ctrl.fetch();
                }
            });

            ctrl.fetch = function () {
                if (ctrl.selectedLocation.finalSelected.optionSelected != null) {
                    Mask.show();
                    LocationService.retrieveNextLevelOfGivenLocationId(ctrl.selectedLocation.finalSelected.optionSelected.id).then(function (res) {
                        ctrl.locationList = res;
                    }).finally(function () {
                        $timeout(function () {
                            $(".header-fixed").tableHeadFixer();
                        });
                        Mask.hide();
                    })
                }
            }
        };

        ctrl.closeModal = () => {
            ctrl.confirmToDelete = false;
            ctrl.deleteLocationObj = null;
            ctrl.childLocationAvailableMsg = null;
            $("#deleteHealthInfrastructureModal").modal('hide');
        }

        ctrl.locationToBeDelete = (location) => {
            Mask.show();
            QueryDAO.execute({
                code: 'is_child_locations_available',
                parameters: {
                    location_id: location.id
                }
            }).then(function (res) {
                if (res.result && res.result.length > 1) {
                    ctrl.deleteLocationObj = null;
                    $("#deleteHealthInfrastructureModal").modal({ backdrop: 'static', keyboard: false });
                    ctrl.childLocationAvailableMsg = "There are child locations available for this location. First delete the child locations."
                } else {
                    ctrl.childLocationAvailableMsg = null;
                    ctrl.retrieveLocationUsagesPlaces(location);
                }
            }).finally(function () {
                Mask.hide();
            })
        }

        ctrl.retrieveLocationUsagesPlaces = (location) => {
            Mask.show();
            QueryDAO.execute({
                code: 'get_locations_usages_places_for_delete_location',
                parameters: {
                    location_id: location.id
                }
            }).then(function (res) {
                let result = res.result.length > 0 && res.result[0];
                let nonZeroValue = Object
                    .keys(result)
                    .filter(key => result[key] !== 0)
                $("#deleteHealthInfrastructureModal").modal({ backdrop: 'static', keyboard: false });
                if (nonZeroValue && nonZeroValue.length > 0) {
                    ctrl.confirmToDelete = false;
                    ctrl.availableUsagePlaces = result;
                    ctrl.deleteLocationObj = {
                        locationName: location.name,
                        locationId: location.id
                    }
                } else {
                    ctrl.deleteLocationObj = {
                        locationName: location.name,
                        locationId: location.id
                    }
                    ctrl.confirmToDelete = true;
                }
            }).finally(function () {
                Mask.hide();
            })
        }

        ctrl.deleteLocation = (locationId) => {
            Mask.show();
            QueryDAO.execute({
                code: 'delete_location_by_location_id',
                parameters: {
                    location_id: locationId
                }
            }).then(function (res) {
                toaster.pop("success", "Location deleted successfully!");
                ctrl.closeModal();
                ctrl.confirmToDelete = false;
                ctrl.submit(false);
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(Mask.hide);
        }

        ctrl.init();
    }
    angular.module('imtecho.controllers').controller('LocationController', LocationController);
})();
