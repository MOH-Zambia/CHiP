(function () {
    function ManageCovidTravelHistoryController(Mask, QueryDAO, GeneralUtil, AuthenticateService,
        toaster, $state, $stateParams, LocationService) {
        var manageCovidTravelHistoryCtrl = this;
        manageCovidTravelHistoryCtrl.travelHistory = [];
        manageCovidTravelHistoryCtrl.contactHistory = [];
        manageCovidTravelHistoryCtrl.travelHistoryList = [];
        manageCovidTravelHistoryCtrl.contactHistoryList = [];

        manageCovidTravelHistoryCtrl.init = function () {
            if (!!$stateParams.contactId) {
                manageCovidTravelHistoryCtrl.getContactPerson($stateParams.contactId);
            }
            manageCovidTravelHistoryCtrl.nextElements = [{ id: -1, label: 'End' }];
            manageCovidTravelHistoryCtrl.travelHistory.push({
                id: manageCovidTravelHistoryCtrl.travelHistory.length + 1,
                contactHistory: [{ id: 1 }]
            });
            AuthenticateService.getLoggedInUser().then(function (res) {
                manageCovidTravelHistoryCtrl.currentUser = res.data;
            });
            Mask.show();
            QueryDAO.execute({
                code: 'retrieve_locations_by_type',
                parameters: {
                    type: ['D','C']
                }
            }).then((response) => {
                manageCovidTravelHistoryCtrl.districtLocations = response.result;
                setTimeout(function () {
                    $('#locationId').trigger("chosen:updated");
                });
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            })
        }

        manageCovidTravelHistoryCtrl.getContactPerson = function (id) {
            let dto = {
                code: 'covid19_get_beneficary_detail_by_id',
                parameters: {
                    id: Number(id)
                }
            };
            Mask.show();
            QueryDAO.execute(dto).then(function (res) {
                manageCovidTravelHistoryCtrl.contactPerson = res.result[0];
                if (manageCovidTravelHistoryCtrl.contactPerson != null && manageCovidTravelHistoryCtrl.contactPerson.travel_history != null) {
                    manageCovidTravelHistoryCtrl.travelHistoryList.push(...JSON.parse(manageCovidTravelHistoryCtrl.contactPerson.travel_history))
                    manageCovidTravelHistoryCtrl.contactHistoryList.push(...JSON.parse(manageCovidTravelHistoryCtrl.contactPerson.contact_person))
                }
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        };

        manageCovidTravelHistoryCtrl.addContactHistroy = function (travelHistory) {
            if (!!manageCovidTravelHistoryCtrl.manageContatDetailForm.$valid) {
                var isValid = true;
                angular.forEach(travelHistory.contactHistory, function (cHistory) {
                    if (!cHistory.selectedLocation.finalSelected) {
                        toaster.pop('danger', 'Please select location for person ' + cHistory.name);
                        isValid = false;
                    }
                });
                if (isValid) {
                    travelHistory.contactHistory.push({ id: travelHistory.contactHistory.length + 1 });
                }
            }
        };

        manageCovidTravelHistoryCtrl.addTravelHistory = function () {
            if (!!manageCovidTravelHistoryCtrl.manageCovidTravelHistoryForm.$valid) {
                manageCovidTravelHistoryCtrl.travelHistory.push({
                    id: manageCovidTravelHistoryCtrl.travelHistory.length + 1,
                    contactHistory: [{ id: 1 }]
                });
            }
        }

        manageCovidTravelHistoryCtrl.save = function () {
            if (!!manageCovidTravelHistoryCtrl.manageCovidTravelHistoryForm.$valid) {
                var isValid = true;
                var lastTravelHistory = manageCovidTravelHistoryCtrl.travelHistory[manageCovidTravelHistoryCtrl.travelHistory.lenght - 1];
                angular.forEach(lastTravelHistory.contactHistory, function (cHistory) {
                    if (!cHistory.selectedLocation.finalSelected) {
                        toaster.pop('danger', 'Please select location for person ' + cHistory.name);
                        isValid = false;
                    }
                });
                if (!isValid) {
                    return;
                }
                angular.forEach(manageCovidTravelHistoryCtrl.travelHistory, function (tHistory) {
                    let dto = {
                        code: 'covid19_save_travel_history',
                        parameters: {
                            contact_person_id: manageCovidTravelHistoryCtrl.contactPerson.id,
                            place_of_origin: tHistory.placeOfOrigin,
                            destination: tHistory.destination,
                            mode_of_transport: tHistory.modeOfTransport,
                            flight_no: tHistory.flightNo,
                            flight_seat_no: tHistory.flightSeatNo,
                            train_no: tHistory.trainNo,
                            train_seat_no: tHistory.trainSeatNo,
                            bus_detail: tHistory.busDetail,
                            travel_agency_detail: tHistory.travelAgencyDetail,
                            purpose_of_travel: tHistory.purposeOfTravel,
                            treavel_date: tHistory.travelDate,
                            other_detail: tHistory.otherTransportDetails,
                        }
                    };
                    Mask.show();
                    QueryDAO.execute(dto).then(function (res) {
                        var tId = res.result[0].id;
                        if (res.result[0].id) {
                            var dtos = [];
                            angular.forEach(tHistory.contactHistory, function (cHistory, index) {
                                let contactdto = {
                                    code: 'covid19_insert_contact_tracing_detail',
                                    parameters: {
                                        name: cHistory.name,
                                        age: cHistory.age,
                                        gender: cHistory.gender,
                                        contact_no: cHistory.contactNo,
                                        address: cHistory.address,
                                        location: cHistory.selectedLocation.finalSelected.optionSelected.id,
                                        contact_id: manageCovidTravelHistoryCtrl.contactPerson.id,
                                        parent_id: manageCovidTravelHistoryCtrl.contactPerson.parentId,
                                        travel_history_id: tId,
                                    },
                                    sequence: index + 1
                                };
                                dtos.push(contactdto);
                            })
                            Mask.show();
                            QueryDAO.executeAll(dtos).then(function () {
                                toaster.pop('success', 'Travel and Contact History are saved successfully');
                                $state.go('techo.manage.covidcases', { formId: manageCovidTravelHistoryCtrl.formId });
                            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                                Mask.hide();
                            });
                        }
                    }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                        Mask.hide();
                    });
                });
            }
        };

        manageCovidTravelHistoryCtrl.cancel = function () {
            $state.go('techo.manage.covidcases', { formId: manageCovidTravelHistoryCtrl.formId });
        };

        manageCovidTravelHistoryCtrl.saveTravelHistory = () => {
            manageCovidTravelHistoryCtrl.manageCovidTravelHistoryForm.$setSubmitted();
            if (manageCovidTravelHistoryCtrl.manageCovidTravelHistoryForm.$valid) {
                let dto = {
                    code: 'covid19_save_travel_history',
                    parameters: {
                        contact_person_id: manageCovidTravelHistoryCtrl.contactPerson.id,
                        place_of_origin: manageCovidTravelHistoryCtrl.travelHistoryObject.placeOfOrigin,
                        destination: manageCovidTravelHistoryCtrl.travelHistoryObject.destination,
                        mode_of_transport: manageCovidTravelHistoryCtrl.travelHistoryObject.modeOfTransport,
                        flight_no: manageCovidTravelHistoryCtrl.travelHistoryObject.flightNo,
                        flight_seat_no: manageCovidTravelHistoryCtrl.travelHistoryObject.flightSeatNo,
                        isFromOtherCountry: manageCovidTravelHistoryCtrl.travelHistoryObject.isFromOtherCountry,
                        train_no: manageCovidTravelHistoryCtrl.travelHistoryObject.trainNo,
                        train_seat_no: manageCovidTravelHistoryCtrl.travelHistoryObject.trainSeatNo,
                        bus_detail: manageCovidTravelHistoryCtrl.travelHistoryObject.busDetail,
                        travel_agency_detail: manageCovidTravelHistoryCtrl.travelHistoryObject.travelAgencyDetail,
                        purpose_of_travel: manageCovidTravelHistoryCtrl.travelHistoryObject.purposeOfTravel,
                        treavel_date: moment(manageCovidTravelHistoryCtrl.travelHistoryObject.travelDate).format("DD-MM-YYYY"),
                        other_detail: manageCovidTravelHistoryCtrl.travelHistoryObject.otherTransportDetails,
                    }
                };
                Mask.show();
                QueryDAO.execute(dto).then(function (res) {
                    toaster.pop('success', 'Details Saved Successfully');
                    manageCovidTravelHistoryCtrl.travelHistoryList = [];
                    manageCovidTravelHistoryCtrl.contactHistoryList = [];
                    manageCovidTravelHistoryCtrl.getContactPerson($stateParams.contactId);
                    manageCovidTravelHistoryCtrl.travelHistoryObject = {}
                    manageCovidTravelHistoryCtrl.manageCovidTravelHistoryForm.$setPristine();
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                });
            }
        };

        manageCovidTravelHistoryCtrl.saveContactHistory = () => {
            manageCovidTravelHistoryCtrl.manageContatDetailForm.$setSubmitted();
            if (manageCovidTravelHistoryCtrl.manageContatDetailForm.$valid) {
                let dto = {
                    code: 'covid19_insert_contact_tracing_detail',
                    parameters: {
                        contactDate: moment(manageCovidTravelHistoryCtrl.contactHistoryObject.contactDate).format("DD-MM-YYYY"),
                        name: manageCovidTravelHistoryCtrl.contactHistoryObject.name,
                        contact_no: manageCovidTravelHistoryCtrl.contactHistoryObject.contactNo,
                        address: manageCovidTravelHistoryCtrl.contactHistoryObject.address,
                        other_detail: manageCovidTravelHistoryCtrl.contactHistoryObject.otherDetails,
                        location: manageCovidTravelHistoryCtrl.contactHistoryObject.locationId,
                        contact_id: manageCovidTravelHistoryCtrl.contactPerson.id,
                        parent_id: manageCovidTravelHistoryCtrl.contactPerson.parentId,
                    }
                };
                Mask.show();
                QueryDAO.execute(dto).then(function (res) {
                    toaster.pop('success', 'Details Saved Successfully');
                    manageCovidTravelHistoryCtrl.travelHistoryList = [];
                    manageCovidTravelHistoryCtrl.contactHistoryList = [];
                    manageCovidTravelHistoryCtrl.getContactPerson($stateParams.contactId);
                    manageCovidTravelHistoryCtrl.contactHistoryObject = {}
                    manageCovidTravelHistoryCtrl.manageContatDetailForm.$setPristine();
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                })
            }
        }

        manageCovidTravelHistoryCtrl.deleteTravelHistory = (travel) => {
            Mask.show();
            QueryDAO.execute({
                code: 'delete_travel_history_by_id',
                parameters: {
                    travelId: travel.id
                }
            }).then(() => {
                toaster.pop('success', "Travel History Deleted successfully");
                manageCovidTravelHistoryCtrl.travelHistoryList = [];
                manageCovidTravelHistoryCtrl.contactHistoryList = [];
                manageCovidTravelHistoryCtrl.getContactPerson($stateParams.contactId);
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            })
        }

        manageCovidTravelHistoryCtrl.deleteContactHistory = (contact) => {
            Mask.show();
            QueryDAO.execute({
                code: 'delete_contact_history_by_id',
                parameters: {
                    contactId: contact.id
                }
            }).then(() => {
                toaster.pop('success', "Contact History Deleted successfully");
                manageCovidTravelHistoryCtrl.travelHistoryList = [];
                manageCovidTravelHistoryCtrl.contactHistoryList = [];
                manageCovidTravelHistoryCtrl.getContactPerson($stateParams.contactId);
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            })
        }

        manageCovidTravelHistoryCtrl.getChildLocation = function (districtlocationId) {
            if (!!districtlocationId) {
                Mask.show();
                LocationService.retrieveNextLevelOfGivenLocationId(districtlocationId).then(function (res) {
                    manageCovidTravelHistoryCtrl.talukaLocation = res;
                }).finally(function () {
                    Mask.hide();
                })
            }
        }

        manageCovidTravelHistoryCtrl.init();

    }
    angular.module('imtecho.controllers').controller('ManageCovidTravelHistoryController', ManageCovidTravelHistoryController);
})();
