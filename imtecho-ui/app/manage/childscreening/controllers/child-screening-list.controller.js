(function () {
    function ChildScreeningListController(ChildScreeningService, Mask, toaster, $state, QueryDAO, AuthenticateService, PagingService, GeneralUtil) {
        var childscreeninglist = this;
        childscreeninglist.MS_PER_DAY = 1000 * 60 * 60 * 24;
        childscreeninglist.pagingService = {
            offSet: 0,
            limit: 100,
            index: 0,
            allRetrieved: false,
            pagingRetrivalOn: false
        };
        childscreeninglist.todayDate = new Date();
        if ($state.current.backTab) {
            childscreeninglist.selectedTab = $state.current.backTab;
        }

        childscreeninglist.cancel = () => {
            $("#searchModal").modal('hide');
            $("#followUpSearchModal").modal('hide');
            $("#deathModal").modal('hide');
            $("#historyModal").modal('hide');
            childscreeninglist.searchForm.$setPristine();
            childscreeninglist.followUpSearchForm.$setPristine();
            childscreeninglist.deathForm.$setPristine();
        }

        childscreeninglist.openHealthIdModal = () => {
            childscreeninglist.searchForm.$setPristine();
            $("#searchModal").modal({ backdrop: 'static', keyboard: false });
        }

        childscreeninglist.openFollowUpSearchModal = () => {
            childscreeninglist.followUpSearchForm.$setPristine();
            $("#followUpSearchModal").modal({ backdrop: 'static', keyboard: false });
        }

        childscreeninglist.searchData = (reset) => {
            if (reset) {
                childscreeninglist.pagingService.index = 0;
                childscreeninglist.pagingService.allRetrieved = false;
                childscreeninglist.pagingService.pagingRetrivalOn = false;
                childscreeninglist.retrievedSearchList = [];
            }
            childscreeninglist.searchChild(true);
        }

        childscreeninglist.searchFollowUpData = (reset) => {
            if (reset) {
                childscreeninglist.pagingService.index = 0;
                childscreeninglist.pagingService.allRetrieved = false;
                childscreeninglist.pagingService.pagingRetrivalOn = false;
                childscreeninglist.retrievedFollowUpSearchList = [];
            }
            childscreeninglist.searchChild(false);
        }

        childscreeninglist.searchChild = (isChild) => {
            if (isChild) {
                childscreeninglist.searchForm.$setSubmitted();
            } else {
                childscreeninglist.followUpSearchForm.$setSubmitted();
            }
            if ((isChild && childscreeninglist.searchForm.$valid) || (!isChild && childscreeninglist.followUpSearchForm.$valid)) {
                if (!childscreeninglist.pagingService.pagingRetrivalOn && !childscreeninglist.pagingService.allRetrieved) {
                    childscreeninglist.pagingService.pagingRetrivalOn = true;
                    childscreeninglist.setOffsetLimit();
                    let searchDto = {};
                    if (childscreeninglist.search.searchBy === 'member id') {
                        searchDto = {
                            code: isChild ? 'cmtc_nrc_unique_health_id_search' : 'cmtc_nrc_follow_up_unique_health_id_search',
                            parameters: {
                                uniqueHealthId: childscreeninglist.search.searchString,
                                limit: childscreeninglist.pagingService.limit,
                                offSet: childscreeninglist.pagingService.offSet
                            }
                        };
                    } else if (childscreeninglist.search.searchBy === 'family id') {
                        searchDto = {
                            code: isChild ? 'cmtc_nrc_family_id_search' : 'cmtc_nrc_follow_up_family_id_search',
                            parameters: {
                                familyId: childscreeninglist.search.searchString,
                                limit: childscreeninglist.pagingService.limit,
                                offSet: childscreeninglist.pagingService.offSet
                            }
                        };
                    } else if (childscreeninglist.search.searchBy === 'mobile number') {
                        searchDto = {
                            code: isChild ? 'cmtc_nrc_mobile_number_search' : 'cmtc_nrc_follow_up_mobile_number_search',
                            parameters: {
                                mobileNumber: childscreeninglist.search.searchString.toString(),
                                limit: childscreeninglist.pagingService.limit,
                                offSet: childscreeninglist.pagingService.offSet
                            }
                        };
                    } else if (childscreeninglist.search.searchBy === 'location' || childscreeninglist.search.searchBy === 'village name'
                        || childscreeninglist.search.searchBy === 'follow up location') {
                        searchDto = {
                            code: isChild ? 'cmtc_nrc_organization_unit_search' : 'cmtc_nrc_follow_up_organization_unit_search',
                            parameters: {
                                locationId: Number(childscreeninglist.selectedLocationId),
                                limit: childscreeninglist.pagingService.limit,
                                offSet: childscreeninglist.pagingService.offSet
                            }
                        };
                    } else if (childscreeninglist.search.searchBy === 'name' || childscreeninglist.search.searchBy === 'follow up name') {
                        searchDto = {
                            code: isChild ? 'cmtc_nrc_name_search' : 'cmtc_nrc_follow_up_name_search',
                            parameters: {
                                locationId: childscreeninglist.selectedLocationId,
                                firstName: childscreeninglist.search.firstName,
                                lastName: childscreeninglist.search.lastName,
                                limit: childscreeninglist.pagingService.limit,
                                offSet: childscreeninglist.pagingService.offSet
                            }
                        };
                    }
                    Mask.show();
                    QueryDAO.execute(searchDto).then((res) => {
                        if (res.result.length === 0) {
                            childscreeninglist.pagingService.allRetrieved = true;
                            if (childscreeninglist.pagingService.index === 1) {
                                if (!!isChild) {
                                    childscreeninglist.retrievedSearchList = res.result;
                                } else {
                                    childscreeninglist.retrievedFollowUpSearchList = res.result;
                                }
                                if (res.result.length == 0) {
                                    toaster.pop('error', 'No data found');
                                }
                            }
                        } else {
                            childscreeninglist.pagingService.allRetrieved = false;
                            if (childscreeninglist.pagingService.index > 1) {
                                if (!!isChild) {
                                    childscreeninglist.retrievedSearchList = childscreeninglist.retrievedSearchList.concat(res.result);
                                } else {
                                    childscreeninglist.retrievedFollowUpSearchList = childscreeninglist.retrievedFollowUpSearchList.concat(res.result);
                                }
                            } else {
                                if (!!isChild) {
                                    childscreeninglist.retrievedSearchList = res.result;
                                } else {
                                    childscreeninglist.retrievedFollowUpSearchList = res.result;
                                }
                            }
                        }
                    }).catch((error) => {
                        GeneralUtil.showMessageOnApiCallFailure(error);
                        childscreeninglist.pagingService.allRetrieved = true;
                    }).finally(function () {
                        childscreeninglist.pagingService.pagingRetrivalOn = false;
                        Mask.hide();
                    });
                }
            }
        }

        childscreeninglist.setOffsetLimit = () => {
            childscreeninglist.pagingService.limit = 100;
            childscreeninglist.pagingService.offSet = childscreeninglist.pagingService.index * 100;
            childscreeninglist.pagingService.index = childscreeninglist.pagingService.index + 1;
        }

        childscreeninglist.markAsDead = (child) => {
            childscreeninglist.childDeath = {};
            childscreeninglist.currentDeathChild = child;
            childscreeninglist.minDeathDate = child.result.lastFollowUpDate != null ? moment(child.result.lastFollowUpDate) : child.result.dischargeDate != null ? moment(child.result.dischargeDate) : moment(child.result.admissionDate);
            Mask.show();
            QueryDAO.execute({
                code: 'retrival_listvalue_values_acc_field',
                parameters: {
                    fieldKey: '2017'
                }
            }).then((res) => {
                childscreeninglist.deathPlaces = res.result;
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
            $("#deathModal").modal({ backdrop: 'static', keyboard: false });
        }

        childscreeninglist.saveDeathDetails = () => {
            childscreeninglist.deathForm.$setSubmitted();
            if (childscreeninglist.deathForm.$valid) {
                childscreeninglist.childDeath.id = childscreeninglist.currentDeathChild.result.admissionId;
                childscreeninglist.childDeath.screeningId = childscreeninglist.currentDeathChild.result.id;
                Mask.show();
                ChildScreeningService.saveDeathDetails(childscreeninglist.childDeath).then((response) => {
                    $("#deathModal").modal('hide');
                    toaster.pop('success', 'Details saved successfully');
                    if (childscreeninglist.selectedTab === 'child-admission-tab') {
                        childscreeninglist.admissionTabSelected();
                    } else if (childscreeninglist.selectedTab === 'child-discharge-tab') {
                        childscreeninglist.dischargeTabSelected();
                    }
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                });
            }
        }

        childscreeninglist.redirectToChildScreening = (id) => {
            Mask.show();
            ChildScreeningService.checkAdmissionValidity(id).then(() => {
                $("#searchModal").modal('hide');
                $('body').removeClass('modal-backdrop');
                $state.go('techo.manage.childscreeningdynamic', { action: 'admission', id: id });
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        childscreeninglist.markAsArchive = function (id) {
            Mask.show();
            QueryDAO.execute({
                code: 'update_cmtc_archive_status',
                parameters: {
                    screeningId: id
                }
            }).then(function (res) {
                toaster.pop('success', 'Archived successfully');
                childscreeninglist.referredList = null;
                childscreeninglist.referredTabSelected();
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        childscreeninglist.init = () => {
            childscreeninglist.retrievedSearchList = [];
            childscreeninglist.retrievedFollowUpSearchList = [];
            Mask.show();
            AuthenticateService.getLoggedInUser().then((user) => {
                childscreeninglist.loggedInUserId = user.data.id;
                return QueryDAO.execute({
                    code: 'retrieve_screening_centers_cmtc',
                    parameters: {
                        userId: childscreeninglist.loggedInUserId
                    }
                })
            }).then((response) => {
                if (response.result.length === 0) {
                    childscreeninglist.noScreeningCentersAssigned = true;
                }
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error)
            }).finally(() => {
                Mask.hide();
            });
        }

        childscreeninglist.navigateToAdmissionForm = (id) => {
            $state.current.backTab = "child-screening-tab";
            $state.go("techo.manage.childscreeningdynamic", { action: 'admission', id: id });
        }

        childscreeninglist.navigateToReferredForm = (id) => {
            $state.current.backTab = "child-referred-tab";
            $state.go("techo.manage.childscreeningdynamic", { action: 'admission', id: id });
        }

        childscreeninglist.navigateToMedicinesForm = (id) => {
            $state.current.backTab = "child-admission-tab";
            $state.go("techo.manage.medicinesdynamic", { id: id });
        }

        childscreeninglist.navigateToLaboratoryForm = (id) => {
            $state.current.backTab = "child-admission-tab";
            $state.go("techo.manage.laboratorytestsdynamic", { id: id });
        }

        childscreeninglist.navigateToDischargeForm = (id) => {
            $state.current.backTab = "child-admission-tab";
            $state.go("techo.manage.childscreeningdynamic", { action: 'discharge', id: id });
        }

        childscreeninglist.navigateToFollowUpForm = (id) => {
            $state.current.backTab = "child-discharge-tab";
            $state.go("techo.manage.childscreeningdynamic", { action: 'followup', id: id });
        }

        childscreeninglist.resetSearchString = () => {
            if (childscreeninglist.search.searchString != null) {
                childscreeninglist.search.searchString = null;
            }
            childscreeninglist.selectedLocation = null;
            childscreeninglist.retrievedSearchList = [];
            childscreeninglist.retrievedFollowUpSearchList = [];
        }

        childscreeninglist.locationSelectizeNutrition = {
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

        childscreeninglist.getScreeningListByCriteria = () => {
            childscreeninglist.criteria = { limit: childscreeninglist.retrievePagingService.limit, offset: childscreeninglist.retrievePagingService.offSet };
            let screeningList = childscreeninglist.screeningList;
            Mask.show();
            PagingService.getNextPage(ChildScreeningService.retrieveAllScreenedChildren, childscreeninglist.criteria, screeningList, null).then((response) => {
                childscreeninglist.screeningList = response;
                childscreeninglist.screeningList.forEach((child) => {
                    child.age = parseInt(moment().diff(moment(child.result.dob), 'months', true));
                    child.medicalComplications = childscreeninglist.getMedicalComplications(child);
                });
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        childscreeninglist.getAdmissionListByCriteria = () => {
            childscreeninglist.criteria = { limit: childscreeninglist.retrievePagingService.limit, offset: childscreeninglist.retrievePagingService.offSet };
            let admissionList = childscreeninglist.admissionList;
            Mask.show();
            PagingService.getNextPage(ChildScreeningService.retrieveAllAdmittedChildren, childscreeninglist.criteria, admissionList, null).then((response) => {
                childscreeninglist.admissionList = response;
                childscreeninglist.admissionList.forEach((child) => {
                    child.age = parseInt(moment().diff(moment(child.result.dob), 'months', true));
                });
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        childscreeninglist.getDefaulterListByCriteria = () => {
            childscreeninglist.criteria = { limit: childscreeninglist.retrievePagingService.limit, offset: childscreeninglist.retrievePagingService.offSet };
            let defaulterList = childscreeninglist.defaulterList;
            Mask.show();
            PagingService.getNextPage(ChildScreeningService.retrieveAllDefaulterChildren, childscreeninglist.criteria, defaulterList, null).then((response) => {
                childscreeninglist.defaulterList = response;
                childscreeninglist.defaulterList.forEach((child) => {
                    child.age = parseInt(moment().diff(moment(child.result.dob), 'months', true));
                })
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        childscreeninglist.getDischargeListByCriteria = () => {
            childscreeninglist.criteria = { limit: childscreeninglist.retrievePagingService.limit, offset: childscreeninglist.retrievePagingService.offSet };
            let dischargeList = childscreeninglist.dischargeList;
            Mask.show();
            PagingService.getNextPage(ChildScreeningService.retrieveAllDischargedChildren, childscreeninglist.criteria, dischargeList, null).then((response) => {
                childscreeninglist.dischargeList = response;
                childscreeninglist.dischargeList.forEach((child) => {
                    child.age = parseInt(moment().diff(moment(child.result.dob), 'months', true));
                });
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        childscreeninglist.getTreatmentCompletedListByCriteria = () => {
            childscreeninglist.criteria = { limit: childscreeninglist.retrievePagingService.limit, offset: childscreeninglist.retrievePagingService.offSet };
            let treatmentCompletedList = childscreeninglist.treatmentCompletedList;
            Mask.show();
            PagingService.getNextPage(ChildScreeningService.retrieveTreatmentCompletedChildren, childscreeninglist.criteria, treatmentCompletedList, null).then((response) => {
                childscreeninglist.treatmentCompletedList = response;
                childscreeninglist.treatmentCompletedList.forEach((child) => {
                    child.age = parseInt(moment().diff(moment(child.result.dob), 'months', true));
                });
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        childscreeninglist.getReferredListByCriteria = () => {
            childscreeninglist.criteria = { limit: childscreeninglist.retrievePagingService.limit, offset: childscreeninglist.retrievePagingService.offSet };
            let referredList = childscreeninglist.referredList;
            Mask.show();
            PagingService.getNextPage(ChildScreeningService.retrieveAllReferredChildren, childscreeninglist.criteria, referredList, null).then((response) => {
                childscreeninglist.referredList = response;
                childscreeninglist.referredList.forEach((child) => {
                    child.age = parseInt(moment().diff(moment(child.result.dob), 'months', true));
                    child.medicalComplications = childscreeninglist.getMedicalComplications(child);
                });
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        childscreeninglist.screeningTabSelected = () => {
            childscreeninglist.retrievePagingService = PagingService.initialize();
            childscreeninglist.getScreeningListByCriteria();
        }

        childscreeninglist.admissionTabSelected = () => {
            childscreeninglist.retrievePagingService = PagingService.initialize();
            childscreeninglist.getAdmissionListByCriteria();
        }

        childscreeninglist.defaulterTabSelected = () => {
            childscreeninglist.retrievePagingService = PagingService.initialize();
            childscreeninglist.getDefaulterListByCriteria();
        }

        childscreeninglist.dischargeTabSelected = () => {
            childscreeninglist.retrievePagingService = PagingService.initialize();
            childscreeninglist.getDischargeListByCriteria();
        }

        childscreeninglist.referredTabSelected = () => {
            childscreeninglist.retrievePagingService = PagingService.initialize();
            childscreeninglist.getReferredListByCriteria();
        }

        childscreeninglist.treatmentCompletedTabSelected = () => {
            childscreeninglist.retrievePagingService = PagingService.initialize();
            childscreeninglist.getTreatmentCompletedListByCriteria();
        }

        childscreeninglist.showWeightHistory = (child) => {
            let admissionId = child.result.admissionId;
            let dischargeId = child.result.dischargeId;
            child.weightList = [];
            child.followUpsList = [];
            Mask.show();
            ChildScreeningService.retrieveWeightList(admissionId).then((response) => {
                child.weightList = response;
                if (dischargeId != null) {
                    return QueryDAO.execute({
                        code: 'retrieve_followups_by_admission_id',
                        parameters: {
                            admissionId
                        }
                    });
                } else {
                    return Promise.resolve(child);
                }
            }).then((response) => {
                if (response != null) {
                    child.followUpsList = response.result;
                }
                if (child.weightList.length === 0 && child.followUpsList.length === 0) {
                    toaster.pop('error', 'No previous history found');
                } else {
                    childscreeninglist.currentHistoryChild = child;
                    $("#historyModal").modal({ backdrop: 'static', keyboard: false });
                }
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        childscreeninglist.getMedicalComplications = (child) => {
            child.medicalComplications = [];
            if (child.result.identifiedFrom != null && child.result.identifiedFrom === 'CMAM') {
                child.medicalComplications.push("Detected From CMAM");
            } else {
                if (child.result.muac != null && child.result.muac < 11.5) {
                    child.medicalComplications.push("MUAC less than 11.5");
                }
                if (child.result.sdScore != null && child.result.sdScore == 'SD3') {
                    child.medicalComplications.push("SD score less than 3");
                }
                if (child.result.sdScore != null && child.result.sdScore == 'SD4') {
                    child.medicalComplications.push("SD score less than 4");
                }
                if (child.result.pedalEdema != null && child.result.pedalEdema) {
                    child.medicalComplications.push("Pedal Edema present");
                }
                if (child.result.breastSuckingProblems != null && child.result.breastSuckingProblems) {
                    child.medicalComplications.push("Breast Sucking Problems");
                }
            }
            return child.medicalComplications.join();
        }

        childscreeninglist.dateDiffInDays = function (a, b) {
            var utc1 = Date.UTC(a.getFullYear(), a.getMonth(), a.getDate());
            var utc2 = Date.UTC(b.getFullYear(), b.getMonth(), b.getDate());

            return Math.floor((utc2 - utc1) / childscreeninglist.MS_PER_DAY);
        }

        childscreeninglist.init();
    }
    angular.module('imtecho.controllers').controller('ChildScreeningListController', ChildScreeningListController);
})();
