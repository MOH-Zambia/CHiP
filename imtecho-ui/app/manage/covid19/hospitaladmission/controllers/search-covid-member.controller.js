(function (angular) {
    function SearchCovidController(Mask, toaster, AuthenticateService, QueryDAO, GeneralUtil) {
        var searchcovid = this;
        searchcovid.search = {};
        searchcovid.search.searchBy = 'member id';
        searchcovid.noRecordsFound = true;
        searchcovid.pagingService = {
            offSet: 0,
            limit: 100,
            index: 0,
            allRetrieved: false,
            pagingRetrivalOn: false
        };
        searchcovid.init = () => {
            searchcovid.memberDetails = [];
            Mask.show();
            AuthenticateService.getLoggedInUser().then((user) => {
                searchcovid.loggedInUser = user.data;
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        };
        searchcovid.toggleFilter = () => {
            if (angular.element('.filter-div').hasClass('active')) {
                searchcovid.modalClosed = true;
                angular.element('body').css("overflow", "auto");
            } else {
                searchcovid.modalClosed = false;
                angular.element('body').css("overflow", "hidden");
            }
            angular.element('.cst-backdrop').fadeToggle();
            angular.element('.filter-div').toggleClass('active');
            if (CKEDITOR.instances) {
                for (var ck_instance in CKEDITOR.instances) {
                    CKEDITOR.instances[ck_instance].destroy();
                }
            }
        };

        searchcovid.cancel = function () {
            $("#dischargeModal").modal('hide');
            searchcovid.dischargeForm.$setPristine();
        }

        searchcovid.retrieveFilteredMembers = () => {
            if ((searchcovid.search.searchBy === 'village name' || searchcovid.search.searchBy === 'location') && searchcovid.selectedLocationId == null) {
                toaster.pop('error', 'Please select Location')
            } else {
                if (!searchcovid.pagingService.pagingRetrivalOn && !searchcovid.pagingService.allRetrieved) {
                    searchcovid.pagingService.pagingRetrivalOn = true;
                    setOffsetLimit();
                    searchcovid.noRecordsFound = true;
                    if (searchcovid.searchForm.$valid) {
                        var search = {};
                        search.byId = false;
                        search.byMemberId = (searchcovid.search.searchBy === 'member id' && searchcovid.search.searchString !== '') ? true : false;
                        search.byFamilyId = (searchcovid.search.searchBy === 'family id' && searchcovid.search.searchString !== '') ? true : false;
                        search.byMobileNumber = (searchcovid.search.searchBy === 'mobile number' && searchcovid.search.searchString !== '') ? true : false;
                        search.byName = (searchcovid.search.searchBy === 'name' && searchcovid.search.searchString !== '') ? true : false;
                        search.byOrganizationUnit = ((searchcovid.search.searchBy === 'location' || searchcovid.search.searchBy === 'village name') && searchcovid.search.searchString !== '') ? true : false;
                        search.byFamilyMobileNumber = searchcovid.search.familyMobileNumber;
                        search.searchString = searchcovid.search.searchString;
                        search.locationId = searchcovid.selectedLocationId;
                        let queryDto = {};
                        if (search.byMemberId) {
                            queryDto = {
                                code: 'sickle_cell_search_by_member_id',
                                parameters: {
                                    uniqueHealthId: search.searchString,
                                    limit: searchcovid.pagingService.limit,
                                    offSet: searchcovid.pagingService.offSet
                                }
                            };
                        } else if (search.byFamilyId) {
                            queryDto = {
                                code: 'sickle_cell_search_by_family_id',
                                parameters: {
                                    familyId: search.searchString,
                                    limit: searchcovid.pagingService.limit,
                                    offSet: searchcovid.pagingService.offSet
                                }
                            };
                        } else if (search.byOrganizationUnit) {
                            queryDto = {
                                code: 'sickle_cell_search_by_location_id',
                                parameters: {
                                    locationId: search.locationId,
                                    limit: searchcovid.pagingService.limit,
                                    offSet: searchcovid.pagingService.offSet
                                }
                            };
                        } else if (search.byMobileNumber) {
                            if (search.byFamilyMobileNumber) {
                                queryDto = {
                                    code: 'sickle_cell_search_by_family_mobile_number',
                                    parameters: {
                                        mobileNumber: search.searchString.toString(),
                                        limit: searchcovid.pagingService.limit,
                                        offSet: searchcovid.pagingService.offSet
                                    }
                                };
                            } else {
                                queryDto = {
                                    code: 'sickle_cell_search_by_mobile_number',
                                    parameters: {
                                        mobileNumber: search.searchString.toString(),
                                        limit: searchcovid.pagingService.limit,
                                        offSet: searchcovid.pagingService.offSet
                                    }
                                };
                            }
                        } else if (search.byName) {
                            queryDto = {
                                code: 'sickle_cell_search_by_name',
                                parameters: {
                                    firstName: searchcovid.search.firstName,
                                    middleName: searchcovid.search.middleName,
                                    lastName: searchcovid.search.lastName,
                                    locationId: search.locationId,
                                    limit: searchcovid.pagingService.limit,
                                    offSet: searchcovid.pagingService.offSet
                                }
                            };
                        }
                        Mask.show();
                        QueryDAO.execute(queryDto).then((response) => {
                            if (response.result.length == 0 || response.result.length < searchcovid.pagingService.limit) {
                                searchcovid.pagingService.allRetrieved = true;
                                if (searchcovid.pagingService.index === 1) {
                                    searchcovid.memberDetails = response.result;
                                }
                            } else {
                                searchcovid.pagingService.allRetrieved = false;
                                if (searchcovid.pagingService.index > 1) {
                                    searchcovid.memberDetails = searchcovid.memberDetails.concat(response.result);
                                } else {
                                    searchcovid.memberDetails = response.result;
                                }
                            }
                        }).catch((error) => {
                            GeneralUtil.showMessageOnApiCallFailure(error);
                            searchcovid.pagingService.allRetrieved = true;
                        }).finally(() => {
                            searchcovid.pagingService.pagingRetrivalOn = false;
                            Mask.hide();
                        });
                    }
                }
            }
        };

        searchcovid.searchData = (reset) => {
            if (searchcovid.searchForm.$valid) {
                if (reset) {
                    searchcovid.toggleFilter();
                    searchcovid.pagingService.index = 0;
                    searchcovid.pagingService.allRetrieved = false;
                    searchcovid.pagingService.pagingRetrivalOn = false;
                    searchcovid.memberDetails = [];
                    searchcovid.suspectedMembers = [];
                }
                searchcovid.retrieveFilteredMembers();
            }
        };

        var setOffsetLimit = () => {
            searchcovid.pagingService.limit = 100;
            searchcovid.pagingService.offSet = searchcovid.pagingService.index * 100;
            searchcovid.pagingService.index = searchcovid.pagingService.index + 1;
        };

        searchcovid.addMembersAsSuspected = () => {
            searchcovid.suspectedMembers = searchcovid.memberDetails.filter((member) => {
                return member.markedAsSuspected;
            })
            if (Array.isArray(searchcovid.suspectedMembers) && searchcovid.suspectedMembers.length) {
                const queryDto = [];
                searchcovid.suspectedMembers.forEach((member, index) => {
                    queryDto.push({
                        code: 'covid19_insert_techo_member_contact_detail',
                        parameters: {
                            memberId: member.memberId,
                            name: member.name,
                            contact_no: member.mobileNumber,
                            address: member.address,
                            location: member.locationId,
                        },
                        sequence: index + 1
                    });
                });
                Mask.show();
                QueryDAO.executeAll(queryDto).then((response) => {
                    if (searchcovid.suspectedMembers.length > 1) {
                        toaster.pop('success', "Members marked as Suspected for Covid-19")
                    } else {
                        toaster.pop('success', "Member marked as Suspected for Covid-19")
                    }
                    searchcovid.suspectedMembers = [];
                    searchcovid.memberDetails.map((member) => {
                        delete member.markedAsSuspected;
                    });
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                })
            } else {
                toaster.pop('error', 'Please select a member first');
            }
        }

        searchcovid.locationSelectizeSicklecell = {
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
                    code: 'location_search_for_web',
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

        searchcovid.resetSearchString = () => {
            if (searchcovid.search.searchString != null) {
                searchcovid.search.searchString = null;
            }
            searchcovid.search.familyMobileNumber = null;
            searchcovid.selectedLocation = null;
            searchcovid.search.firstName = null;
            searchcovid.search.middleName = null;
            searchcovid.search.lastName = null;
        }

        searchcovid.init();
    }
    angular.module('imtecho.controllers').controller('SearchCovidController', SearchCovidController);
})(window.angular);
