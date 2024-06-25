(function () {
    function ManagelocationClusterMangement(Mask, QueryDAO, GeneralUtil, $stateParams, UserDAO, toaster, $state, AuthenticateService) {
        var manageLocationClusterMangementCtrl = this;
        manageLocationClusterMangementCtrl.controls = [];

        manageLocationClusterMangementCtrl.init = () => {
            Mask.show();
            AuthenticateService.getLoggedInUser().then((response) => {
                manageLocationClusterMangementCtrl.currentUser = response.data;
                if (!!$stateParams.id) {
                    manageLocationClusterMangementCtrl.locationClusterId = $stateParams.id;
                    manageLocationClusterMangementCtrl.headerText = 'Update Cluster'
                    manageLocationClusterMangementCtrl.getLocationCluster();
                } else {
                    manageLocationClusterMangementCtrl.locationCluster = {};
                    manageLocationClusterMangementCtrl.locationCluster.locations = [];
                    manageLocationClusterMangementCtrl.headerText = 'Add Cluster';
                }
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
                $state.go('techo.manage.locationClusterManagement');
            }).finally(() => {
                Mask.hide();
            });
        };

        manageLocationClusterMangementCtrl.getLocationCluster = () => {
            Mask.show();
            QueryDAO.execute({
                code: 'covid19_get_location_cluster_by_id',
                parameters: {
                    id: Number(manageLocationClusterMangementCtrl.locationClusterId)
                }
            }).then((response) => {
                manageLocationClusterMangementCtrl.locationCluster = {
                    id: response.result[0].clusterId,
                    name: response.result[0].clusterName,
                    population: response.result[0].population,
                    locations: response.result.map((result) => {
                        return {
                            locationId: result.locationId,
                            type: result.locationType,
                            level: result.locationLevel,
                            name: result.locationName,
                            locationFullName: result.locationFullName
                        }
                    })
                }
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        manageLocationClusterMangementCtrl.save = () => {
            if (!!manageLocationClusterMangementCtrl.mangeCovid19CaseForm.$valid) {
                let locationStr;
                if (Array.isArray(manageLocationClusterMangementCtrl.locationCluster.locations) && manageLocationClusterMangementCtrl.locationCluster.locations.length) {
                    locationStr = "{" + manageLocationClusterMangementCtrl.locationCluster.locations.map(location => location.locationId).join() + "}";
                } else {
                    manageLocationClusterMangementCtrl.noLocationSelected = true;
                    return;
                }
                Mask.show();
                if (!!manageLocationClusterMangementCtrl.locationCluster.id) {
                    QueryDAO.execute({
                        code: 'covid19_update_location_cluster_master',
                        parameters: {
                            name: manageLocationClusterMangementCtrl.locationCluster.name,
                            population: manageLocationClusterMangementCtrl.locationCluster.population,
                            userId: manageLocationClusterMangementCtrl.currentUser.id,
                            id: manageLocationClusterMangementCtrl.locationCluster.id
                        }
                    }).then((response) => {
                        return QueryDAO.execute({
                       code: 'covid19_insert_location_cluster_mapping_detail',
                            parameters: {
                                clusterId: manageLocationClusterMangementCtrl.locationCluster.id,
                                locations: locationStr,
                                userId: manageLocationClusterMangementCtrl.currentUser.id
                            }
                        });
                    }).then((response) => {
                        toaster.pop('success', 'Details saved successfully');
                        $state.go('techo.manage.locationClusterManagement');
                    }).catch((error) => {
                        GeneralUtil.showMessageOnApiCallFailure(error);
                    }).finally(() => {
                        Mask.hide();
                    });
                } else {
                    QueryDAO.execute({
                        code: 'covid19_insert_location_cluster_master',
                        parameters: {
                            name: manageLocationClusterMangementCtrl.locationCluster.name,
                            population: manageLocationClusterMangementCtrl.locationCluster.population,
                            userId: manageLocationClusterMangementCtrl.currentUser.id
                        }
                    }).then((response) => {
                        return QueryDAO.execute({
                            code: 'covid19_insert_location_cluster_mapping_detail',
                            parameters: {
                                clusterId: response.result[0].id,
                                locations: locationStr,
                                userId: manageLocationClusterMangementCtrl.currentUser.id
                            }
                        });
                    }).then((response) => {
                        toaster.pop('success', 'Details saved successfully');
                        $state.go('techo.manage.locationClusterManagement');
                    }).catch((error) => {
                        GeneralUtil.showMessageOnApiCallFailure(error);
                    }).finally(() => {
                        Mask.hide();
                    });
                }
            }
        }

        manageLocationClusterMangementCtrl.selectedArea = function () {
            manageLocationClusterMangementCtrl.locationForm.$setSubmitted();
            if (manageLocationClusterMangementCtrl.selectedLocation.finalSelected !== null) {
                let selectedobj;
                if (manageLocationClusterMangementCtrl.selectedLocation.finalSelected.optionSelected) {
                    selectedobj = {
                        locationId: manageLocationClusterMangementCtrl.selectedLocation.finalSelected.optionSelected.id,
                        type: manageLocationClusterMangementCtrl.selectedLocation.finalSelected.optionSelected.type,
                        level: manageLocationClusterMangementCtrl.selectedLocation.finalSelected.level,
                        name: manageLocationClusterMangementCtrl.selectedLocation.finalSelected.optionSelected.name

                    };
                } else {
                    selectedobj = {
                        locationId: manageLocationClusterMangementCtrl.selectedLocation["level" + (manageLocationClusterMangementCtrl.selectedLocation.finalSelected.level - 1)].id,
                        type: manageLocationClusterMangementCtrl.selectedLocation["level" + (manageLocationClusterMangementCtrl.selectedLocation.finalSelected.level - 1)].type,
                        level: manageLocationClusterMangementCtrl.selectedLocation.finalSelected.level - 1,
                        name: manageLocationClusterMangementCtrl.selectedLocation["level" + (manageLocationClusterMangementCtrl.selectedLocation.finalSelected.level - 1)].name

                    };
                }
                manageLocationClusterMangementCtrl.duplicateEntry = false;
                for (let i = 0; i < manageLocationClusterMangementCtrl.locationCluster.locations.length; i++) {
                    if (manageLocationClusterMangementCtrl.locationCluster.locations[i].locationId === selectedobj.locationId) {
                        manageLocationClusterMangementCtrl.duplicateEntry = true;
                        manageLocationClusterMangementCtrl.isLocationButtonDisabled = false;
                    }

                }
                if (!manageLocationClusterMangementCtrl.duplicateEntry) {
                    manageLocationClusterMangementCtrl.isNotAllowedLocation = false;
                    if (!manageLocationClusterMangementCtrl.locationCluster.locations) {
                        manageLocationClusterMangementCtrl.locationCluster.locations = [];
                    }
                    var itteratingLevel = 1,
                        locationFullName = '';
                    while (itteratingLevel < manageLocationClusterMangementCtrl.selectedLocation.finalSelected.level) {
                        if (manageLocationClusterMangementCtrl.selectedLocation['level' + itteratingLevel]) {
                            locationFullName = locationFullName.concat(manageLocationClusterMangementCtrl.selectedLocation['level' + itteratingLevel].name + ',');
                        }
                        itteratingLevel = itteratingLevel + 1;
                    }
                    if (manageLocationClusterMangementCtrl.selectedLocation.finalSelected.optionSelected) {
                        locationFullName = locationFullName.concat(manageLocationClusterMangementCtrl.selectedLocation.finalSelected.optionSelected.name);
                    } else {
                        locationFullName = locationFullName.substring(0, locationFullName.length - 1);
                    }
                    selectedobj.locationFullName = locationFullName;

                    var selectedLocationIds = _.pluck(manageLocationClusterMangementCtrl.locationCluster.locations, "locationId");
                    UserDAO.validateaoi(null, selectedLocationIds, selectedobj.locationId, null).then(function (res) {

                        if (res.errorcode === 2) {
                            if (!res.data) {
                                manageLocationClusterMangementCtrl.errorMsg = res.message;
                                manageLocationClusterMangementCtrl.errorCode = res.errorcode;
                                return;
                            }
                        }
                        manageLocationClusterMangementCtrl.locationCluster.locations.push(selectedobj);
                        delete manageLocationClusterMangementCtrl.errorMsg;
                        delete manageLocationClusterMangementCtrl.errorCode;
                        if (manageLocationClusterMangementCtrl.locationCluster.locations.length > 0) {
                            manageLocationClusterMangementCtrl.noLocationSelected = false;
                        }
                    }, GeneralUtil.showMessageOnApiCallFailure)
                        .finally(function () {
                            manageLocationClusterMangementCtrl.isLocationButtonDisabled = false;
                        });
                }
            }

        };
        manageLocationClusterMangementCtrl.removeSelectedArea = function (index) {
            manageLocationClusterMangementCtrl.locationCluster.locations.splice(index, 1);
            if (manageLocationClusterMangementCtrl.locationCluster.locations.length <= 0) {
                manageLocationClusterMangementCtrl.noLocationSelected = true;
                manageLocationClusterMangementCtrl.duplicateEntry = false;
                manageLocationClusterMangementCtrl.isNotAllowedLocation = false;
            }
        };

        manageLocationClusterMangementCtrl.cancel = function () {
            $state.go('techo.manage.locationClusterManagement');
        };

        manageLocationClusterMangementCtrl.init();
    }
    angular.module('imtecho.controllers').controller('ManagelocationClusterMangement', ManagelocationClusterMangement);
})();
