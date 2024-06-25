(function () {
    function ManageCovidCasesController(Mask, QueryDAO, GeneralUtil, $stateParams, toaster, $state,
        AuthenticateService, LocationService) {
        var manageCovidCasesCtrl = this;
        manageCovidCasesCtrl.controls = [];

        manageCovidCasesCtrl.init = function () {
            if (!!$stateParams.id) {
                manageCovidCasesCtrl.covid19CaseId = Number($stateParams.id);
                manageCovidCasesCtrl.headerText = 'Update COVID-19 Case'
                manageCovidCasesCtrl.getCovid19Cases();
            } else {
                manageCovidCasesCtrl.covid19Case = {};
                manageCovidCasesCtrl.covid19Case.locations = [];
                manageCovidCasesCtrl.headerText = 'Add COVID-19 Case'
                    ;
            }
            AuthenticateService.getLoggedInUser().then(function (res) {
                manageCovidCasesCtrl.currentUser = res.data;
            });
            Mask.show();
            QueryDAO.execute({
                code: 'retrieve_locations_by_type',
                parameters: {
                    type: ['D','C']
                }
            }).then((response) => {
                manageCovidCasesCtrl.districtLocations = response.result;
                setTimeout(function () {
                    $('#locationId').trigger("chosen:updated");
                });
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            })
        };

        manageCovidCasesCtrl.getCovid19Cases = function () {
            var dto = {
                code: 'covid19_get_beneficary_detail_by_id',
                parameters: {
                    id: manageCovidCasesCtrl.covid19CaseId
                }
            };
            Mask.show();
            QueryDAO.execute(dto).then(function (res) {
                manageCovidCasesCtrl.covid19Case = res.result[0];
                if (!!manageCovidCasesCtrl.covid19Case.location) {
                    // Set preselection for district and taluka
                    LocationService.getParent(manageCovidCasesCtrl.covid19Case.locationId).then(function (res1) {
                        manageCovidCasesCtrl.districtlocationId = res1 ? res1.id : '';
                        manageCovidCasesCtrl.getChildLocation(manageCovidCasesCtrl.districtlocationId);
                    }).finally(function () {
                        Mask.hide();
                    })
                }
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        }

        manageCovidCasesCtrl.save = function () {
            if (!!manageCovidCasesCtrl.mangeCovid19CaseForm.$valid) {
                if (!!manageCovidCasesCtrl.covid19Case.id) {
                    let dto = {
                        code: 'covid19_contatct_tracing_update_beneficary_detail',
                        parameters: {
                            name: manageCovidCasesCtrl.covid19Case.name.replace(/:/g, "").replace(/'/g, "''"),
                            age: manageCovidCasesCtrl.covid19Case.age,
                            gender: manageCovidCasesCtrl.covid19Case.gender,
                            contact_no: manageCovidCasesCtrl.covid19Case.contact_no,
                            address: manageCovidCasesCtrl.covid19Case.address.replace(/:/g, "").replace(/'/g, "''"),
                            state: manageCovidCasesCtrl.covid19Case.state,
                            location: manageCovidCasesCtrl.covid19Case.locationId,
                            modified_by: manageCovidCasesCtrl.currentUser.id,
                            id: manageCovidCasesCtrl.covid19Case.id
                        }
                    };
                    Mask.show();
                    QueryDAO.execute(dto).then(function (res) {
                        toaster.pop('success', 'covid19Cases Updated Successfully');
                        $state.go('techo.manage.covidcases');
                    }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                        Mask.hide();
                    });
                } else {
                    let dto = {
                        code: 'covid19_contact_tracing_insert_beneficary_data',
                        parameters: {
                            name: manageCovidCasesCtrl.covid19Case.name,
                            age: manageCovidCasesCtrl.covid19Case.age,
                            gender: manageCovidCasesCtrl.covid19Case.gender,
                            contact_no: manageCovidCasesCtrl.covid19Case.contact_no,
                            address: manageCovidCasesCtrl.covid19Case.address,
                            state: manageCovidCasesCtrl.covid19Case.state,
                            location: manageCovidCasesCtrl.covid19Case.locationId,
                        }
                    };
                    Mask.show();
                    QueryDAO.execute(dto).then(function (res) {
                        var caseId = res.result[0].id;
                        if (!!caseId) {
                            toaster.pop('success', 'COVID-19 Case Saved Successfully');
                        }
                        $state.go('techo.manage.covidcases');
                    }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                        Mask.hide();
                    });
                }
            }
        }

        manageCovidCasesCtrl.selectedArea = function () {
            manageCovidCasesCtrl.locationForm.$setSubmitted();
            if (manageCovidCasesCtrl.selectedLocation.finalSelected !== null) {
                let selectedobj;
                if (manageCovidCasesCtrl.selectedLocation.finalSelected.optionSelected) {
                    selectedobj = {
                        locationId: manageCovidCasesCtrl.selectedLocation.finalSelected.optionSelected.id,
                        type: manageCovidCasesCtrl.selectedLocation.finalSelected.optionSelected.type,
                        level: manageCovidCasesCtrl.selectedLocation.finalSelected.level,
                        name: manageCovidCasesCtrl.selectedLocation.finalSelected.optionSelected.name
                    };
                } else {
                    selectedobj = {
                        locationId: manageCovidCasesCtrl.selectedLocation["level" + (manageCovidCasesCtrl.selectedLocation.finalSelected.level - 1)].id,
                        type: manageCovidCasesCtrl.selectedLocation["level" + (manageCovidCasesCtrl.selectedLocation.finalSelected.level - 1)].type,
                        level: manageCovidCasesCtrl.selectedLocation.finalSelected.level - 1,
                        name: manageCovidCasesCtrl.selectedLocation["level" + (manageCovidCasesCtrl.selectedLocation.finalSelected.level - 1)].name
                    };
                }
                manageCovidCasesCtrl.duplicateEntry = false;
                for (let i = 0; i < manageCovidCasesCtrl.covid19Case.locations.length; i++) {
                    if (manageCovidCasesCtrl.covid19Case.locations[i].locationId === selectedobj.locationId) {
                        manageCovidCasesCtrl.duplicateEntry = true;
                        manageCovidCasesCtrl.isLocationButtonDisabled = false;
                    }
                }
                if (!manageCovidCasesCtrl.duplicateEntry) {
                    manageCovidCasesCtrl.isNotAllowedLocation = false;
                    if (!manageCovidCasesCtrl.covid19Case.locations) {
                        manageCovidCasesCtrl.covid19Case.locations = [];
                    }
                    var itteratingLevel = 1,
                        locationFullName = '';
                    while (itteratingLevel < manageCovidCasesCtrl.selectedLocation.finalSelected.level) {
                        if (manageCovidCasesCtrl.selectedLocation['level' + itteratingLevel]) {
                            locationFullName = locationFullName.concat(manageCovidCasesCtrl.selectedLocation['level' + itteratingLevel].name + ',');
                        }
                        itteratingLevel = itteratingLevel + 1;
                    }
                    if (manageCovidCasesCtrl.selectedLocation.finalSelected.optionSelected) {
                        locationFullName = locationFullName.concat(manageCovidCasesCtrl.selectedLocation.finalSelected.optionSelected.name);
                    } else {
                        locationFullName = locationFullName.substring(0, locationFullName.length - 1);
                    }
                    selectedobj.locationFullName = locationFullName;
                    manageCovidCasesCtrl.covid19Case.locations.push(selectedobj);
                    delete manageCovidCasesCtrl.errorMsg;
                    delete manageCovidCasesCtrl.errorCode;
                    if (manageCovidCasesCtrl.covid19Case.locations.length > 0) {
                        manageCovidCasesCtrl.noLocationSelected = false;
                    }
                }
            }
        };

        manageCovidCasesCtrl.removeSelectedArea = function (index) {
            manageCovidCasesCtrl.covid19Case.locations.splice(index, 1);
            if (manageCovidCasesCtrl.covid19Case.locations.length <= 0) {
                manageCovidCasesCtrl.noLocationSelected = true;
                manageCovidCasesCtrl.duplicateEntry = false;
                manageCovidCasesCtrl.isNotAllowedLocation = false;
            }
        };

        manageCovidCasesCtrl.cancel = function () {
            $state.go('techo.manage.covidcases');
        };

        manageCovidCasesCtrl.getChildLocation = function (districtlocationId) {
            if (!!districtlocationId) {
                Mask.show();
                LocationService.retrieveNextLevelOfGivenLocationId(districtlocationId).then(function (res) {
                    manageCovidCasesCtrl.talukaLocation = res;
                }).finally(function () {
                    Mask.hide();
                })
            }
        }

        manageCovidCasesCtrl.init();
    }
    angular.module('imtecho.controllers').controller('ManageCovidCasesController', ManageCovidCasesController);
})();
