(function () {
    function DtcInterface(QueryDAO, Mask, GeneralUtil, $uibModal, toaster, AuthenticateService) {
        let ctrl = this;
        ctrl.appName = GeneralUtil.getAppName();
        ctrl.searchLocationId = null;
        ctrl.selectedLocationId = null;
        ctrl.searchIsFromImmigration = false;
        ctrl.travellers = [];
        ctrl.travellersCount = {};
        ctrl.selectedTab = 0;

        ctrl.pagingService = {
            offset: 0,
            limit: 100,
            index: 0,
            allRetrieved: false,
            pagingRetrivalOn: false
        };

        let retrieveAll = function () {
            if (ctrl.selectedLocationId && !ctrl.pagingService.pagingRetrivalOn && !ctrl.pagingService.allRetrieved) {
                ctrl.pagingService.pagingRetrivalOn = true;
                setOffsetLimit();
                let dtoList = [];
                let travellersDto = {
                    code: 'retrieve_covid_19_travellers',
                    parameters: {
                        limit: ctrl.pagingService.limit,
                        offset: ctrl.pagingService.offset,
                        locationId: ctrl.selectedLocationId,
                        isFromImmigration: ctrl.searchIsFromImmigration ? true : false,
                        retrievePending: ctrl.selectedTab === 0 ? true : false,
                        retrieveNonContactable: ctrl.selectedTab === 2 ? true : false
                    },
                    sequence: 1
                };
                dtoList.push(travellersDto);
                if (ctrl.selectedTab !== 2) {
                    let travellersCountDto = {
                        code: 'retrieve_covid_19_travellers_count',
                        parameters: {
                            locationId: ctrl.selectedLocationId,
                            isFromImmigration: ctrl.searchIsFromImmigration ? true : false
                        },
                        sequence: 2
                    };
                    dtoList.push(travellersCountDto);
                }
                Mask.show();
                QueryDAO.executeAll(dtoList).then(function (responses) {
                    let travellersResult = responses[0].result;
                    if (travellersResult.length === 0) {
                        ctrl.pagingService.allRetrieved = true;
                        if (ctrl.pagingService.index === 1) {
                            ctrl.travellers = travellersResult;
                        }
                    } else {
                        ctrl.pagingService.allRetrieved = false;
                        if (ctrl.pagingService.index > 1) {
                            ctrl.travellers = ctrl.travellers.concat(travellersResult);
                        } else {
                            ctrl.travellers = travellersResult;
                        }
                    }
                    if (ctrl.selectedTab !== 2) {
                        ctrl.travellersCount = responses[1].result[0];
                    }
                }, function (err) {
                    GeneralUtil.showMessageOnApiCallFailure(err);
                    ctrl.pagingService.allRetrieved = true;
                }).finally(function () {
                    ctrl.pagingService.pagingRetrivalOn = false;
                    Mask.hide();
                });
            }
        };

        let setOffsetLimit = function () {
            ctrl.pagingService.limit = 100;
            ctrl.pagingService.offset = ctrl.pagingService.index * 100;
            ctrl.pagingService.index = ctrl.pagingService.index + 1;
        };

        ctrl.searchData = function (toReset, toToggle, isAssignedLocation) {
            ctrl.searchForm.$setSubmitted();
            if (ctrl.searchForm.$valid || (isAssignedLocation && ctrl.selectedLocationId)) {
                if (toReset) {
                    ctrl.pagingService.index = 0;
                    ctrl.pagingService.allRetrieved = false;
                    ctrl.pagingService.pagingRetrivalOn = false;
                    ctrl.travellers = [];
                    ctrl.travellersCount = {};
                }
                if (toToggle) {
                    ctrl.selectedLocationId = ctrl.searchLocationId
                    ctrl.toggleFilter();
                }
                retrieveAll();
            }
        };

        ctrl.updateLocation = travellerObj => {
            let modalInstance = $uibModal.open({
                windowClass: 'cst-modal',
                backdrop: 'static',
                size: 'xl',
                templateUrl: 'app/manage/covid19/dtcinterface/views/update-location.modal.html',
                controllerAs: 'ctrl',
                controller: function ($uibModalInstance, traveller, loggedInUser, selectedTab) {
                    let locationModalCtrl = this;
                    locationModalCtrl.traveller = traveller;
                    locationModalCtrl.loggedInUser = loggedInUser;
                    locationModalCtrl.selectedTab = selectedTab;
                    locationModalCtrl.updateAddress = locationModalCtrl.traveller.address;
                    locationModalCtrl.isLocationFound = true;
                    locationModalCtrl.isOutOfState = false;
                    locationModalCtrl.updateLocationId = null;
                    locationModalCtrl.updateDistrictId = null;
                    locationModalCtrl.searchBy = 'organizationUnit';

                    locationModalCtrl.locationSelectizeConfig = {
                        create: false,
                        valueField: 'id',
                        labelField: 'hierarchy',
                        dropdownParent: 'body',
                        highlight: true,
                        searchField: ['_searchField'],
                        maxItems: 1,
                        render: {
                            item: function (location, escape) {
                                var returnString = "<div>" + location.hierarchy + "</div>";
                                return returnString;
                            },
                            option: function (location, escape) {
                                var returnString = "<div>" + location.hierarchy + "</div>";
                                return returnString;
                            }
                        },
                        onFocus: function () {
                            this.onSearchChange("");
                        },
                        onBlur: function () {
                            var selectize = this;
                            var value = this.getValue();
                            setTimeout(function () {
                                if (!value) {
                                    selectize.clearOptions();
                                    selectize.refreshOptions();
                                }
                            }, 200);
                        },
                        load: function (query, callback) {
                            var selectize = this;
                            var value = this.getValue();
                            if (!value) {
                                selectize.clearOptions();
                                selectize.refreshOptions();
                            }
                            var promise;
                            var queryDto = {
                                code: 'area_level_location_search_for_web',
                                parameters: {
                                    locationString: query,
                                }
                            };
                            promise = QueryDAO.execute(queryDto);
                            promise.then(function (res) {
                                angular.forEach(res.result, function (result) {
                                    result._searchField = query;
                                });
                                callback(res.result);
                            }, function () {
                                callback();
                            });
                        }
                    }

                    locationModalCtrl.submit = function () {
                        locationModalCtrl.updateLocationForm.$setSubmitted();
                        if (locationModalCtrl.updateLocationForm.$valid) {
                            let dtoList = [];
                            if ((locationModalCtrl.selectedTab === 0 && locationModalCtrl.isLocationFound) || locationModalCtrl.selectedTab === 2) {
                                if (['district', 'isOutOfState'].includes(locationModalCtrl.searchBy)) {
                                    let code = 'update_location_of_covid_19_traveller';
                                    if (locationModalCtrl.selectedTab === 2) {
                                        code = 'update_location_of_covid_19_non_contactable_traveller';
                                    }
                                    let updateLocationDto = {
                                        code,
                                        parameters: {
                                            id: locationModalCtrl.traveller.id,
                                            locationId: Number(locationModalCtrl.updateLocationId),
                                            address: locationModalCtrl.updateAddress,
                                            isOutOfState: locationModalCtrl.isOutOfState,
                                            districtId: locationModalCtrl.searchBy === 'district' && locationModalCtrl.updateDistrictId ? locationModalCtrl.updateDistrictId : locationModalCtrl.traveller.district_id
                                        },
                                        sequence: 1
                                    }
                                    dtoList.push(updateLocationDto);
                                } else if (['organizationUnit', 'areaName'].includes(locationModalCtrl.searchBy)) {
                                    let code = 'update_location_and_create_imt_member_of_covid_19_traveller';
                                    if (locationModalCtrl.selectedTab === 2) {
                                        code = 'update_location_and_create_imt_member_of_covid_19_non_contactable_traveller';
                                    }
                                    let updateLocationDto = {
                                        code,
                                        parameters: {
                                            id: locationModalCtrl.traveller.id,
                                            locationId: Number(locationModalCtrl.updateLocationId),
                                            isOutOfState: false,
                                            address: locationModalCtrl.updateAddress,
                                            dob: '01-01-1970'
                                        },
                                        sequence: 1
                                    }
                                    dtoList.push(updateLocationDto);
                                }
                            } else {
                                let updateLocationDto = {
                                    code: 'update_location_not_found_of_covid_19_traveller',
                                    parameters: {
                                        id: locationModalCtrl.traveller.id,
                                        reason: locationModalCtrl.locationNotFoundReason
                                    },
                                    sequence: 1
                                }
                                dtoList.push(updateLocationDto);
                            }
                            if (dtoList.length) {
                                Mask.show();
                                QueryDAO.executeAll(dtoList).then(function () {
                                    $uibModalInstance.close();
                                    toaster.pop('success', 'Location updated successfully.');
                                }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide);
                            }
                        }
                    }

                    locationModalCtrl.cancel = function () {
                        $uibModalInstance.dismiss();
                    }
                },
                resolve: {
                    traveller: function () {
                        return travellerObj
                    },
                    loggedInUser: function () {
                        return ctrl.loggedInUser
                    },
                    selectedTab: function () {
                        return ctrl.selectedTab
                    }
                }
            });
            modalInstance.result.then(() => {
                ctrl.searchData(true, false, true);
            }, () => { })
        }

        ctrl.showDetail = function (travellerObj) {
            let modalInstance = $uibModal.open({
                windowClass: 'cst-modal',
                backdrop: 'static',
                size: 'md',
                templateUrl: 'app/manage/covid19/dtcinterface/views/dtc-interface-detail-modal.html',
                controllerAs: 'ctrl',
                controller: function ($uibModalInstance, traveller, appName) {
                    let cntrl = this;
                    cntrl.traveller = traveller;
                    cntrl.appName = appName;

                    cntrl.ok = function () {
                        $uibModalInstance.close();
                    }
                    cntrl.cancel = function () {
                        $uibModalInstance.dismiss();
                    }
                },
                resolve: {
                    traveller: function () {
                        return travellerObj
                    },
                    appName: () => {
                        return ctrl.appName
                    }
                }
            });
            modalInstance.result
                .then(function () { }, function () { })
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
            ctrl.searchForm.$setPristine();
            ctrl.toggleFilter();
        };

        let _init = function () {
            Mask.show();
            AuthenticateService.getLoggedInUser().then(user => {
                ctrl.loggedInUser = user.data;
                if (ctrl.loggedInUser.minLocationId) {
                    ctrl.selectedLocationId = ctrl.loggedInUser.minLocationId;
                    retrieveAll();
                }
            }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide);
        }

        _init();
    }
    angular.module('imtecho.controllers').controller('DtcInterface', DtcInterface);
})();
