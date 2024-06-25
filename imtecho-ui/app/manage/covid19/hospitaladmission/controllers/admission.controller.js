(function () {
    function CovidTravellersAdmission(Mask, QueryDAO, GeneralUtil, $uibModal, AuthenticateService, toaster, $timeout, CovidService, PagingService) {
        var covidAdmissionctrl = this;
        covidAdmissionctrl.wardList = [];
        covidAdmissionctrl.isShowFeature = false;

        covidAdmissionctrl.init = function () {
            Mask.show();
            AuthenticateService.getLoggedInUser().then(function (user) {
                covidAdmissionctrl.currentUser = user.data;
                Mask.show();
                QueryDAO.execute({
                    code: 'retrieve_health_infra_for_user',
                    parameters: {
                        userId: covidAdmissionctrl.currentUser.id
                    }
                }).then(function (res) {
                    if (res.result && res.result.length > 1) {
                        covidAdmissionctrl.message = 'Multiple Health Infrastructures Assigned. Please contact administration.';
                    } else if (res.result && res.result.length === 0) {
                        covidAdmissionctrl.message = 'No Health Infrastructure Assigned. Please contact administration.';
                    } else {
                        covidAdmissionctrl.isShowFeature = true;
                        covidAdmissionctrl.getCovid19WardList();
                    }
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                });
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
            AuthenticateService.getAssignedFeature('techo.manage.covidAdmission').then(function (res) {
                if (!!res && !!res.featureJson) {
                    covidAdmissionctrl.rights = res.featureJson;
                }
            });
        };

        covidAdmissionctrl.printAdmission = function (json) {
            covidAdmissionctrl.printResultConfirmed(json.admissionId);
        };

        covidAdmissionctrl.printResultConfirmed = (ids) => {
            Mask.show();
            CovidService.downloadAdmissionReportPdf(ids).then(function (res) {
                if (res.data !== null && navigator.msSaveBlob) {
                    return navigator.msSaveBlob(new Blob([res.data], { type: "application/pdf;charset=UTF-8'" }));
                }
                var a = $("<a style='display: none;'/>");
                var url = window.URL.createObjectURL(new Blob([res.data], { type: "application/pdf;charset=UTF-8'" }));
                a.attr("href", url);
                a.attr("download", "Admission_Report_" + new Date().getTime() + ".pdf");
                $("body").append(a);
                a[0].click();
                window.URL.revokeObjectURL(url);
                a.remove();
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        };

        covidAdmissionctrl.getCovid19WardList = function () {
            let dto = {
                code: 'covid19_get_ward_detail',
                parameters: {
                }
            };
            Mask.show();
            QueryDAO.execute(dto).then(function (res) {
                covidAdmissionctrl.wardList = res.result;
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        };

        covidAdmissionctrl.performSearch = function () {
            if (covidAdmissionctrl.selectedTab === 0) {
                covidAdmissionctrl.searchPendingAdmissionData();
            } else if (covidAdmissionctrl.selectedTab === 1) {
                covidAdmissionctrl.searchSuspectedCaseData();
            } else if (covidAdmissionctrl.selectedTab === 2) {
                covidAdmissionctrl.searchConfirmedCaseData();
            } else if (covidAdmissionctrl.selectedTab === 3) {
                covidAdmissionctrl.searchReferInCaseData();
            } else if (covidAdmissionctrl.selectedTab === 4) {
                covidAdmissionctrl.searchReferOutCaseData();
            }
        };

        covidAdmissionctrl.searchPendingAdmissionData = (resetSearch) => {
            if (!!resetSearch) {
                covidAdmissionctrl.searchText = '';
            }
            covidAdmissionctrl.retrievePagingService = PagingService.initialize();
            covidAdmissionctrl.getPendingAdmissionData();
        };

        covidAdmissionctrl.getPendingAdmissionData = () => {
            covidAdmissionctrl.criteria = {
                limit: covidAdmissionctrl.retrievePagingService.limit,
                offset: covidAdmissionctrl.retrievePagingService.offSet, searchText: covidAdmissionctrl.searchText
            };
            let covidAdmissionCases = covidAdmissionctrl.covidAdmissionCases;
            Mask.show();
            PagingService.getNextPage(CovidService.getPendingAdmissionforLabTest, covidAdmissionctrl.criteria,
                covidAdmissionCases, null).then((response) => {
                    covidAdmissionctrl.covidAdmissionCases = response;
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                });
        };

        covidAdmissionctrl.searchSuspectedCaseData = (resetSearch) => {
            if (!!resetSearch) {
                covidAdmissionctrl.searchText = '';
            }
            covidAdmissionctrl.retrievePagingService = PagingService.initialize();
            covidAdmissionctrl.getCovid19SuspectCases();
        };

        covidAdmissionctrl.getCovid19SuspectCases = () => {
            covidAdmissionctrl.markAll = false;
            covidAdmissionctrl.criteria = {
                limit: covidAdmissionctrl.retrievePagingService.limit,
                offset: covidAdmissionctrl.retrievePagingService.offSet, searchText: covidAdmissionctrl.searchText
            };
            let covid19SuspectedCases = covidAdmissionctrl.covid19SuspectedCases;
            Mask.show();
            PagingService.getNextPage(CovidService.getSuspectedAdmittedPatientList, covidAdmissionctrl.criteria,
                covid19SuspectedCases, null).then((response) => {
                    covidAdmissionctrl.covid19SuspectedCases = response;
                    covidAdmissionctrl.markAll ? covidAdmissionctrl.selectMarkAll(covidAdmissionctrl.covid19SuspectedCases) : null;
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                });
        };

        covidAdmissionctrl.selectMarkAll = (list) => {
            if (covidAdmissionctrl.markAll) {
                list.forEach((member) => {
                    member.markedForAction = true;
                });
            } else {
                list.forEach((member) => {
                    member.markedForAction = false;
                });
            }
        };

        covidAdmissionctrl.printConfirmList = function () {
            Mask.show();
            covidAdmissionctrl.retrieveMarkedMembersList(CovidService.getConfirmedAdmittedPatientList, covidAdmissionctrl.covid19ConfirmedCases).then(() => {
                const ids = covidAdmissionctrl.markedMembersList.map(result => result.admissionId).join();
                covidAdmissionctrl.printResultConfirmed(ids);
            }).catch((error) => {
                $timeout(function () {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                });
            }).finally(() => {
                Mask.hide();
            });
        };

        covidAdmissionctrl.printSuspectList = function () {
            Mask.show();
            covidAdmissionctrl.retrieveMarkedMembersList(CovidService.getSuspectedAdmittedPatientList, covidAdmissionctrl.covid19SuspectedCases).then(() => {
                const ids = covidAdmissionctrl.markedMembersList.map(result => result.admissionId).join();
                covidAdmissionctrl.printResultConfirmed(ids);
            }).catch((error) => {
                $timeout(function () {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                });
            }).finally(() => {
                Mask.hide();
            });
        };

        covidAdmissionctrl.retrieveMarkedMembersList = (method, list) => {
            return new Promise((resolve, reject) => {
                if (covidAdmissionctrl.markAll) {
                    var criteria = { limit: 107374182, offset: 0, searchText: '' };
                    let temp = [];
                    Mask.show();
                    PagingService.getNextPage(method, criteria, temp, null).then((response) => {
                        covidAdmissionctrl.markedMembersList = response;
                        Array.isArray(covidAdmissionctrl.markedMembersList) && covidAdmissionctrl.markedMembersList.length > 0 ? resolve() : reject({ data: { message: 'Please select an admission first' } });
                    }).catch((error) => {
                        GeneralUtil.showMessageOnApiCallFailure(error);
                    }).finally(() => {
                        Mask.hide();
                    });
                } else if (Array.isArray(list)) {
                    covidAdmissionctrl.markedMembersList = list.filter((member) => {
                        return member.markedForAction;
                    });
                    Array.isArray(covidAdmissionctrl.markedMembersList) && covidAdmissionctrl.markedMembersList.length > 0 ? resolve() : reject({ data: { message: 'Please select an admission first' } });
                }
            });
        };

        covidAdmissionctrl.searchConfirmedCaseData = (resetSearch) => {
            covidAdmissionctrl.markAll = false;
            if (!!resetSearch) {
                covidAdmissionctrl.searchText = '';
            }
            covidAdmissionctrl.retrievePagingService = PagingService.initialize();
            covidAdmissionctrl.getCovid19ConfirmedCases();
        };

        covidAdmissionctrl.getCovid19ConfirmedCases = () => {
            covidAdmissionctrl.criteria = {
                limit: covidAdmissionctrl.retrievePagingService.limit,
                offset: covidAdmissionctrl.retrievePagingService.offSet, searchText: covidAdmissionctrl.searchText
            };
            let covid19ConfirmedCases = covidAdmissionctrl.covid19ConfirmedCases;
            Mask.show();
            PagingService.getNextPage(CovidService.getConfirmedAdmittedPatientList, covidAdmissionctrl.criteria,
                covid19ConfirmedCases, null).then((response) => {
                    covidAdmissionctrl.covid19ConfirmedCases = response;
                    covidAdmissionctrl.markAll ? covidAdmissionctrl.selectMarkAll(covidAdmissionctrl.covid19ConfirmedCases) : null;
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                });
        };

        covidAdmissionctrl.searchReferInCaseData = (resetSearch) => {
            if (!!resetSearch) {
                covidAdmissionctrl.searchText = '';
            }
            covidAdmissionctrl.retrievePagingService = PagingService.initialize();
            covidAdmissionctrl.getCovid19ReferInCases();
        };

        covidAdmissionctrl.getCovid19ReferInCases = () => {
            covidAdmissionctrl.criteria = {
                limit: covidAdmissionctrl.retrievePagingService.limit,
                offset: covidAdmissionctrl.retrievePagingService.offSet, searchText: covidAdmissionctrl.searchText
            };
            let covid19ReferInCases = covidAdmissionctrl.covid19ReferInCases;
            Mask.show();
            PagingService.getNextPage(CovidService.getReferInPatientList, covidAdmissionctrl.criteria,
                covid19ReferInCases, null).then((response) => {
                    covidAdmissionctrl.covid19ReferInCases = response;
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                });
        };

        covidAdmissionctrl.searchReferOutCaseData = (resetSearch) => {
            if (!!resetSearch) {
                covidAdmissionctrl.searchText = '';
            }
            covidAdmissionctrl.retrievePagingService = PagingService.initialize();
            covidAdmissionctrl.getCovid19ReferOutCase();
        };

        covidAdmissionctrl.getCovid19ReferOutCase = () => {
            covidAdmissionctrl.criteria = {
                limit: covidAdmissionctrl.retrievePagingService.limit,
                offset: covidAdmissionctrl.retrievePagingService.offSet, searchText: covidAdmissionctrl.searchText
            };
            let covid19ReferOutCase = covidAdmissionctrl.covid19ReferOutCase;
            Mask.show();
            PagingService.getNextPage(CovidService.getReferOutPatientList, covidAdmissionctrl.criteria,
                covid19ReferOutCase, null).then((response) => {
                    covidAdmissionctrl.covid19ReferOutCase = response;
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                });
        }

        covidAdmissionctrl.onAdmitClick = function (id) {
            covidAdmissionctrl.selectedRecord = covidAdmissionctrl.covidAdmissionCases && _.filter(covidAdmissionctrl.covidAdmissionCases, (d) => {
                return d.id === id;
            });
            covidAdmissionctrl.selectedRecord[0].loggedInUser = covidAdmissionctrl.currentUser.id;
            var modalInstance = $uibModal.open({
                templateUrl: 'app/manage/covid19/hospitaladmission/views/pending-case-admit.modal.html',
                controllerAs: 'mdctrl',
                controller: 'CovidTravellerAdmissionDetailsController',
                windowClass: 'cst-modal',
                size: 'lg',
                backdrop: 'static',
                resolve: {
                    selectedRecord: function () {
                        return covidAdmissionctrl.selectedRecord;
                    },
                    wardList: function () {
                        return covidAdmissionctrl.wardList;
                    }
                }
            });
            modalInstance.result.then(function (res) {
                covidAdmissionctrl.searchPendingAdmissionData();
            }, function () {

            });
        };

        covidAdmissionctrl.onReferInAdmitClick = function (admissionId) {
            covidAdmissionctrl.selectedRecord = covidAdmissionctrl.covid19ReferInCases && _.filter(covidAdmissionctrl.covid19ReferInCases, (d) => {
                return d.admissionId === admissionId
            });
            covidAdmissionctrl.selectedRecord[0].loggedInUser = covidAdmissionctrl.currentUser.id;
            var modalInstance = $uibModal.open({
                templateUrl: 'app/manage/covid19/hospitaladmission/views/refer-in-admit.modal.html',
                controllerAs: 'mdctrl',
                controller: 'CovidReferInAdmitModalController',
                windowClass: 'cst-modal',
                size: 'lg',
                backdrop: 'static',
                resolve: {
                    selectedRecord: function () {
                        return covidAdmissionctrl.selectedRecord;
                    },
                    wardList: function () {
                        return covidAdmissionctrl.wardList;
                    }
                }
            });
            modalInstance.result.then(function (res) {
                covidAdmissionctrl.searchReferInCaseData();
            }, function () {

            });
        };

        covidAdmissionctrl.onNewAdmissionClick = function () {
            covidAdmissionctrl.selectedRecord = [];
            covidAdmissionctrl.selectedRecord.push({});
            covidAdmissionctrl.selectedRecord[0].loggedInUser = covidAdmissionctrl.currentUser.id;
            var modalInstance = $uibModal.open({
                templateUrl: 'app/manage/covid19/hospitaladmission/views/new-admission.modal.html',
                controllerAs: 'mdctrl',
                controller: 'CovidNewAdmissionDetailsController',
                windowClass: 'cst-modal',
                backdrop: 'static',
                size: 'lg',
                resolve: {
                    selectedRecord: function () {
                        return covidAdmissionctrl.selectedRecord;
                    },
                    wardList: function () {
                        return covidAdmissionctrl.wardList;
                    }
                }
            });
            modalInstance.result.then(function (res) {
                covidAdmissionctrl.searchSuspectedCaseData();
            }, function () { });
        };

        covidAdmissionctrl.editCase = async function (covidCase, index, screen) {
            let patientsdto = {
                code: 'covid19_get_admitted_patients_det_for_editing',
                parameters: {
                    admissionId: covidCase.admissionId
                }
            };
            Mask.show();
            await QueryDAO.execute(patientsdto).then(function (res) {
                covidAdmissionctrl.covid19SelectedSuspectedCasesForEdit = res.result;
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });

            var modalInstance = $uibModal.open({
                templateUrl: 'app/manage/covid19/hospitaladmission/views/edit-admission.modal.html',
                windowClass: 'cst-modal',
                backdrop: 'static',
                size: 'lg',
                controllerAs: 'ctrl',
                controller: function ($uibModalInstance, covid19SuspectedSelectedCases, district_loc, country_list, wardList) {
                    let ctrl = this;
                    ctrl.selectedRecord = covid19SuspectedSelectedCases;
                    ctrl.districtLocations = district_loc;
                    ctrl.countryList = country_list;
                    ctrl.wardList = wardList;

                    ctrl.submit = function () {
                        if (
                            (ctrl.selectedRecord[0].firstname ? ctrl.selectedRecord[0].firstname.length : 0) +
                            (ctrl.selectedRecord[0].middlename ? ctrl.selectedRecord[0].middlename.length : 0) +
                            (ctrl.selectedRecord[0].lastname ? ctrl.selectedRecord[0].lastname.length : 0) > 99) {
                            toaster.pop('danger', 'Full Name length should be less than 99 Chars');
                            return;
                        }
                        ctrl.admissionEditForm.$setSubmitted();
                        if (ctrl.admissionEditForm.$valid) {
                            let dto = {
                                code: 'covid19_update_admitted_patients_det_for_editing',
                                parameters: {
                                    firstname: !!ctrl.selectedRecord[0].firstname ? ctrl.selectedRecord[0].firstname : null,
                                    middlename: !!ctrl.selectedRecord[0].middlename ? ctrl.selectedRecord[0].middlename : null,
                                    lastname: !!ctrl.selectedRecord[0].lastname ? ctrl.selectedRecord[0].lastname : null,
                                    address: !!ctrl.selectedRecord[0].address ? ctrl.selectedRecord[0].address : null,
                                    pincode: ctrl.selectedRecord[0].pinCode || null,
                                    occupation: ctrl.selectedRecord[0].occupation || null,
                                    travel_history: ctrl.selectedRecord[0].travelHistory || null,
                                    travelled_place: ctrl.selectedRecord[0].travelledPlace || null,
                                    flight_no: ctrl.selectedRecord[0].flightno || null,
                                    is_abroad_in_contact: ctrl.selectedRecord[0].is_abroad_in_contact || null,
                                    in_contact_with_covid19_paitent: ctrl.selectedRecord[0].inContactWithCovid19Paitent || null,
                                    abroad_contact_details: !!ctrl.selectedRecord[0].abroad_contact_details ? ctrl.selectedRecord[0].abroad_contact_details : null,
                                    admission_date: moment(ctrl.selectedRecord[0].admissionDate).format("DD-MM-YYYY") || null,
                                    case_no: !!ctrl.selectedRecord[0].case_number ? ctrl.selectedRecord[0].case_number : null,
                                    opd_case_no: !!ctrl.selectedRecord[0].opdCaseNo ? ctrl.selectedRecord[0].opdCaseNo : null,
                                    contact_number: '' + ctrl.selectedRecord[0].contact_no || null,
                                    gender: ctrl.selectedRecord[0].gender || null,
                                    pregnancy_status: ctrl.selectedRecord[0].pregnancy_status || null,
                                    age: ctrl.selectedRecord[0].age,
                                    is_fever: ctrl.selectedRecord[0].hasFever || null,
                                    is_cough: ctrl.selectedRecord[0].hasCough || null,
                                    is_breathlessness: ctrl.selectedRecord[0].hasShortnessBreath || null,
                                    is_sari: ctrl.selectedRecord[0].isSari || null,
                                    is_hiv: ctrl.selectedRecord[0].isHIV || null,
                                    is_heart_patient: ctrl.selectedRecord[0].isHeartPatient || null,
                                    is_diabetes: ctrl.selectedRecord[0].isDiabetes || null,
                                    is_copd: ctrl.selectedRecord[0].isCOPD || null,
                                    is_hypertension: ctrl.selectedRecord[0].isHypertension || null,
                                    is_renal_condition: ctrl.selectedRecord[0].isRenalCondition || null,
                                    is_immunocompromized: ctrl.selectedRecord[0].isImmunocompromized || null,
                                    is_malignancy: ctrl.selectedRecord[0].isMalignancy || null,
                                    is_other_co_mobidity: ctrl.selectedRecord[0].isOtherCoMobidity || null,
                                    other_co_mobidity: !!ctrl.selectedRecord[0].otherCoMobidity ? ctrl.selectedRecord[0].otherCoMobidity : null,
                                    indications: ctrl.selectedRecord[0].indications || null,
                                    date_of_onset_symptom: !!ctrl.selectedRecord[0].date_of_onset_symptom ? moment(ctrl.selectedRecord[0].date_of_onset_symptom).format("DD-MM-YYYY") : null,
                                    refer_from_hospital: !!ctrl.selectedRecord[0].referFromHosital ? ctrl.selectedRecord[0].referFromHosital : null,
                                    current_bed_no: !!ctrl.selectedRecord[0].bedno ? ctrl.selectedRecord[0].bedno : null,
                                    unit_no: !!ctrl.selectedRecord[0].unitno ? ctrl.selectedRecord[0].unitno : null,
                                    health_status: ctrl.selectedRecord[0].healthstatus || null,
                                    emergency_contact_name: !!ctrl.selectedRecord[0].emergencyContactName ? ctrl.selectedRecord[0].emergencyContactName : null,
                                    emergency_contact_no: ctrl.selectedRecord[0].emergencyContactNo || null,
                                    location_id: ctrl.selectedRecord[0].districtLocationId || null,
                                    current_ward_id: ctrl.selectedRecord[0].ward_id || null,
                                    admissionId: ctrl.selectedRecord[0].id,
                                    ageMonth: ctrl.selectedRecord[0].ageMonth,
                                    isMigrant: ctrl.selectedRecord[0].isMigrant,
                                    otherIndications: !!ctrl.selectedRecord[0].otherIndications ? ctrl.selectedRecord[0].otherIndications : null
                                }
                            };
                            Mask.show();
                            QueryDAO.execute(dto).then(function (res) {
                                toaster.pop('success', 'COVID-19 Data updated Successfully');
                                if (screen === 'suspected') {
                                    covidAdmissionctrl.covid19SuspectedCases = [];
                                    covidAdmissionctrl.searchSuspectedCaseData();
                                } else if (screen === 'confirmed') {
                                    covidAdmissionctrl.covid19ConfirmedCases = [];
                                    covidAdmissionctrl.searchConfirmedCaseData();
                                }
                            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                                Mask.hide();
                            });
                            $uibModalInstance.close();
                        }
                    };

                    ctrl.cancel = function () {
                        $uibModalInstance.close();
                    };

                    ctrl.onselectHealthStatus = function () {
                        if (ctrl.selectedRecord[0].healthstatus === 'Asymptomatic') {
                            ctrl.selectedRecord[0].date_of_onset_symptom = null;
                        }
                    };
                },
                resolve: {
                    covid19SuspectedSelectedCases: function () {
                        return covidAdmissionctrl.covid19SelectedSuspectedCasesForEdit;
                    },
                    district_loc: function () {
                        return QueryDAO.execute({
                            code: 'retrieve_locations_by_type',
                            parameters: {
                                type: ['D','C']
                            }
                        }).then((response) => {
                            return response.result;
                        }).catch((error) => {
                            GeneralUtil.showMessageOnApiCallFailure(error);
                        }).finally(() => {
                            Mask.hide();
                        });
                    },
                    country_list: function () {
                        return QueryDAO.execute({
                            code: 'fetch_listvalue_detail_from_field',
                            parameters: {
                                field: 'Countries list'
                            }
                        }).then((response) => {
                            return response.result;
                        }).catch((error) => {
                            GeneralUtil.showMessageOnApiCallFailure(error);
                        }).finally(() => {
                            Mask.hide();
                        });
                    },
                    wardList: function () {
                        return covidAdmissionctrl.wardList;
                    }
                }
            });
            modalInstance.result.then(() => { });
        };

        covidAdmissionctrl.onAddDaliyStatus = function (covidCase, screen) {
            var modalInstance = $uibModal.open({
                templateUrl: 'app/manage/covid19/hospitaladmission/views/daily-checkup.modal.html',
                controller: 'covid19AdmittedCaseDailyStatusModalCtrl',
                controllerAs: 'covid19ACDStatusModalCtrl',
                windowClass: 'cst-modal',
                backdrop: 'static',
                size: 'lg',
                resolve: {
                    covidCase: function () {
                        return covidCase;
                    },
                    wardList: function () {
                        return covidAdmissionctrl.wardList;
                    }
                }
            });
            modalInstance.result.then(() => {
                if (screen === 'suspected') {
                    covidAdmissionctrl.covid19SuspectedCases = [];
                    covidAdmissionctrl.searchSuspectedCaseData();
                } else if(screen === 'confirmed'){
                    covidAdmissionctrl.covid19ConfirmedCases = [];
                    covidAdmissionctrl.searchConfirmedCaseData();
                }
            });
        };

        covidAdmissionctrl.discharge = function (covidCase, isSuspected) {
            covidCase.isSuspected = isSuspected;
            var modalInstance = $uibModal.open({
                templateUrl: 'app/manage/covid19/hospitaladmission/views/discharge.modal.html',
                controller: 'DischargeModalCtrl',
                controllerAs: 'dischargeModalCtrl',
                windowClass: 'cst-modal',
                backdrop: 'static',
                size: 'lg',
                resolve: {
                    covidCase: function () {
                        return covidCase;
                    },
                    loggedInUser: function () {
                        return covidAdmissionctrl.currentUser;
                    }
                }
            });
            modalInstance.result.then(() => {
                if (isSuspected) {
                    covidAdmissionctrl.searchSuspectedCaseData();
                } else {
                    covidAdmissionctrl.searchConfirmedCaseData();
                }
            });
        };

        covidAdmissionctrl.init();

    }
    angular.module('imtecho.controllers').controller('CovidTravellersAdmission', CovidTravellersAdmission);
})();

// $uib model Addmit On Pending Admission
(function () {
    function CovidTravellerAdmissionDetailsController(Mask, GeneralUtil, selectedRecord, wardList, $uibModalInstance, QueryDAO,
        toaster, $q) {
        var mdctrl = this;
        mdctrl.selectedRecord = selectedRecord;
        mdctrl.wardList = wardList;
        mdctrl.selectedRecord[0].admissionDate = new Date();
        mdctrl.selectedRecord[0].pregnancy_status = 'no';
        mdctrl.selectedRecord[0].contact_no = Number(mdctrl.selectedRecord[0].contact_no);
        mdctrl.selectedRecord[0].emergencyContactNo = mdctrl.selectedRecord[0].emergencyContactNo ? Number(mdctrl.selectedRecord[0].emergencyContactNo) : '';
        mdctrl.today = new Date();
        mdctrl.submitted = false;
        mdctrl.getDate = function (date) {
            return (date.getMonth() + 1) + "-" + date.getDate() + "-" + date.getFullYear();
        };

        mdctrl.checkCaseNo = function () {
            if (mdctrl.submitted === true) {
                return;
            }
            mdctrl.submitted = true;
            if (!!mdctrl.selectedRecord[0].case_number) {
                var defer = $q.defer();
                var caseDto = {
                    code: 'covid19_get_admission_by_health_infra_and_case_no',
                    parameters: {
                        caseNo: mdctrl.selectedRecord[0].case_number,
                    }
                };
                Mask.show();
                QueryDAO.execute(caseDto).then(function (res) {
                    if (res.result && res.result.length > 0) {
                        mdctrl.isDuplicateCaseNo = true;
                        mdctrl.caseMsg = res.result[0].resultMsg;
                        defer.reject();
                    } else {
                        mdctrl.isDuplicateCaseNo = false;
                        mdctrl.caseMsg = '';
                        defer.resolve();
                    }
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                    mdctrl.submitted = false;
                });
                return defer.promise;
            }
        };

        mdctrl.submit = function () {
            if (
                ( mdctrl.selectedRecord[0].firstname ? mdctrl.selectedRecord[0].firstname.length : 0) +
                ( mdctrl.selectedRecord[0].middlename ? mdctrl.selectedRecord[0].middlename.length : 0) +
                ( mdctrl.selectedRecord[0].lastname ? mdctrl.selectedRecord[0].lastname.length : 0) > 99 ) {
                    toaster.pop('danger', 'Full Name length should be less than 99 Chars');
                    return;
                }

            mdctrl.admissionform.$setSubmitted();
            if (mdctrl.admissionform.$valid && mdctrl.selectedRecord[0].memberId && mdctrl.selectedRecord[0].type === 'refer') {
                let caseDto = {
                    code: 'covid19_get_admission_by_health_infra_and_case_no',
                    parameters: {
                        caseNo: mdctrl.selectedRecord[0].case_number,
                    }
                }
                Mask.show();
                QueryDAO.execute(caseDto).then(function (caseRes) {
                    if (caseRes.result && caseRes.result.length > 0) {
                        mdctrl.isDuplicateCaseNo = true;
                        mdctrl.caseMsg = caseRes.result[0].resultMsg;
                        return;
                    } else {
                        mdctrl.isDuplicateCaseNo = false;
                        mdctrl.caseMsg = '';
                    }
                    mdctrl.selectedRecord[0].wardId = JSON.parse(mdctrl.selectedRecord[0].ward).id;
                    mdctrl.selectedRecord[0].health_infra_id = JSON.parse(mdctrl.selectedRecord[0].ward).health_infra_type_id;

                    let dto = {
                        code: 'insert_covid19_new_admission_detail',
                        parameters: {
                            member_id: mdctrl.selectedRecord[0].memberId,
                            districtLocationId: mdctrl.selectedRecord[0].districtLocationId,
                            health_infra_id: mdctrl.selectedRecord[0].health_infra_id,
                            covid19_lab_test_recommendation_id: mdctrl.selectedRecord[0].id,
                            case_number: mdctrl.selectedRecord[0].case_number,
                            ward_no: mdctrl.selectedRecord[0].wardId,
                            bed_no: mdctrl.selectedRecord[0].bedno,
                            unitno: mdctrl.selectedRecord[0].unitno || null,
                            health_status: mdctrl.selectedRecord[0].healthstatus,
                            admission_date: moment(mdctrl.selectedRecord[0].admissionDate).format("DD-MM-YYYY"),
                            hasFever: mdctrl.selectedRecord[0].hasFever,
                            hasCough: mdctrl.selectedRecord[0].hasCough,
                            hasShortnessBreath: mdctrl.selectedRecord[0].hasShortnessBreath,
                            isHIV: mdctrl.selectedRecord[0].isHIV,
                            isHeartPatient: mdctrl.selectedRecord[0].isHeartPatient,
                            isDiabetes: mdctrl.selectedRecord[0].isDiabetes,
                            occupation: mdctrl.selectedRecord[0].occupation,
                            isCOPD: mdctrl.selectedRecord[0].isCOPD,
                            isRenalCondition: mdctrl.selectedRecord[0].isRenalCondition,
                            isHypertension: mdctrl.selectedRecord[0].isHypertension,
                            isImmunocompromized: mdctrl.selectedRecord[0].isImmunocompromized,
                            isMalignancy: mdctrl.selectedRecord[0].isMalignancy,
                            pregnancy_status: mdctrl.selectedRecord[0].pregnancy_status,
                            emergencyContactName: mdctrl.selectedRecord[0].emergencyContactName || null,
                            emergencyContactNo: mdctrl.selectedRecord[0].emergencyContactNo,
                            date_of_onset_symptom: !!mdctrl.selectedRecord[0].date_of_onset_symptom ? moment(mdctrl.selectedRecord[0].date_of_onset_symptom).format("DD-MM-YYYY") : null,
                            loggedIn_user: mdctrl.selectedRecord[0].loggedInUser,
                            opdCaseNo: mdctrl.selectedRecord[0].opdCaseNo,
                            isSari: mdctrl.selectedRecord[0].isSari,
                            otherCoMobidity: mdctrl.selectedRecord[0].otherCoMobidity || null,
                            indications: mdctrl.selectedRecord[0].indications,
                            otherIndications: mdctrl.selectedRecord[0].otherIndications || null,
                            isMigrant: mdctrl.selectedRecord[0].isMigrant,
                            firstname: mdctrl.selectedRecord[0].firstname,
                            middlename: mdctrl.selectedRecord[0].middlename,
                            lastname: mdctrl.selectedRecord[0].lastname,
                            contact_no: mdctrl.selectedRecord[0].contact_no,
                            address: mdctrl.selectedRecord[0].address,
                            gender: mdctrl.selectedRecord[0].gender,
                            age: mdctrl.selectedRecord[0].age,
                            ageMonth: mdctrl.selectedRecord[0].ageMonth
                        }
                    };
                    Mask.show();
                    QueryDAO.execute(dto).then(function (res) {
                        toaster.pop('success', 'COVID-19 Data Created Successfully');
                    }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                        Mask.hide();
                        $uibModalInstance.close();
                    });
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                    mdctrl.submitted = false;
                });
            } else if (mdctrl.admissionform.$valid && mdctrl.selectedRecord[0].type === 'opdAdmit') {
                let caseDto = {
                    code: 'covid19_get_admission_by_health_infra_and_case_no',
                    parameters: {
                        caseNo: mdctrl.selectedRecord[0].case_number,
                    }
                };
                Mask.show();
                QueryDAO.execute(caseDto).then(function (res) {
                    if (res.result && res.result.length > 0) {
                        mdctrl.isDuplicateCaseNo = true;
                        mdctrl.caseMsg = res.result[0].resultMsg;
                        return;
                    } else {
                        mdctrl.isDuplicateCaseNo = false;
                        mdctrl.caseMsg = '';
                    }
                    mdctrl.selectedRecord[0].wardId = JSON.parse(mdctrl.selectedRecord[0].ward).id;
                    mdctrl.selectedRecord[0].health_infra_id = JSON.parse(mdctrl.selectedRecord[0].ward).health_infra_type_id;

                    let dto = {
                        code: 'update_covid19_new_admission_detail',
                        parameters: {
                            admissionId: mdctrl.selectedRecord[0].id,
                            districtLocationId: mdctrl.selectedRecord[0].districtLocationId,
                            health_infra_id: mdctrl.selectedRecord[0].health_infra_id,
                            case_number: mdctrl.selectedRecord[0].case_number,
                            ward_no: mdctrl.selectedRecord[0].wardId,
                            bed_no: mdctrl.selectedRecord[0].bedno,
                            unitno: mdctrl.selectedRecord[0].unitno || null,
                            admission_date: moment(mdctrl.selectedRecord[0].admissionDate).format("DD-MM-YYYY"),
                            hasFever: mdctrl.selectedRecord[0].hasFever,
                            hasCough: mdctrl.selectedRecord[0].hasCough,
                            hasShortnessBreath: mdctrl.selectedRecord[0].hasShortnessBreath,
                            isHIV: mdctrl.selectedRecord[0].isHIV,
                            isHeartPatient: mdctrl.selectedRecord[0].isHeartPatient,
                            isDiabetes: mdctrl.selectedRecord[0].isDiabetes,
                            occupation: mdctrl.selectedRecord[0].occupation,
                            isCOPD: mdctrl.selectedRecord[0].isCOPD,
                            isRenalCondition: mdctrl.selectedRecord[0].isRenalCondition,
                            isHypertension: mdctrl.selectedRecord[0].isHypertension,
                            isImmunocompromized: mdctrl.selectedRecord[0].isImmunocompromized,
                            isMalignancy: mdctrl.selectedRecord[0].isMalignancy,
                            pregnancy_status: mdctrl.selectedRecord[0].pregnancy_status,
                            emergencyContactName: mdctrl.selectedRecord[0].emergencyContactName || null,
                            emergencyContactNo: mdctrl.selectedRecord[0].emergencyContactNo,
                            date_of_onset_symptom: !!mdctrl.selectedRecord[0].date_of_onset_symptom ? moment(mdctrl.selectedRecord[0].date_of_onset_symptom).format("DD-MM-YYYY") : null,
                            opdCaseNo: mdctrl.selectedRecord[0].opdCaseNo,
                            isSari: mdctrl.selectedRecord[0].isSari,
                            otherCoMobidity: mdctrl.selectedRecord[0].otherCoMobidity || null,
                            indications: mdctrl.selectedRecord[0].indications,
                            otherIndications: mdctrl.selectedRecord[0].otherIndications || null,
                            isMigrant: mdctrl.selectedRecord[0].isMigrant,
                            firstname: mdctrl.selectedRecord[0].firstname,
                            middlename: mdctrl.selectedRecord[0].middlename,
                            lastname: mdctrl.selectedRecord[0].lastname,
                            contact_no: mdctrl.selectedRecord[0].contact_no,
                            address: mdctrl.selectedRecord[0].address,
                            gender: mdctrl.selectedRecord[0].gender,
                            age: mdctrl.selectedRecord[0].age,
                            ageMonth: mdctrl.selectedRecord[0].ageMonth
                        }
                    };
                    Mask.show();
                    QueryDAO.execute(dto).then(function (admissionRes) {
                        toaster.pop('success', 'COVID-19 Data Created Successfully');
                    }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                        Mask.hide();
                        $uibModalInstance.close();
                    });
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                    mdctrl.submitted = false;
                });
            }
        };

        mdctrl.onselectHealthStatus = function () {
            if (mdctrl.selectedRecord[0].healthstatus === 'Asymptomatic') {
                mdctrl.selectedRecord[0].date_of_onset_symptom = null;
            }
        };

        mdctrl.cancel = function () {
            $uibModalInstance.dismiss('cancel');
        };
    }
    angular.module('imtecho.controllers').controller('CovidTravellerAdmissionDetailsController', CovidTravellerAdmissionDetailsController);
})();


// $uib model New Admission
(function () {
    function CovidNewAdmissionDetailsController(Mask, GeneralUtil, selectedRecord, wardList, $uibModalInstance, QueryDAO, LocationService, toaster,
        $q) {
        var mdctrl = this;
        mdctrl.selectedRecord = selectedRecord;
        mdctrl.wardList = wardList;
        mdctrl.selectedRecord[0].admissionDate = new Date();
        mdctrl.today = new Date();
        mdctrl.submitted = false;
        mdctrl.selectedRecord[0].pregnancy_status = 'no';
        mdctrl.getDate = function (date) {
            return (date.getMonth() + 1) + "-" + date.getDate() + "-" + date.getFullYear();

        };

        mdctrl.checkCaseNo = function () {
            if (mdctrl.submitted === true) {
                return;
            }
            mdctrl.submitted = true;
            if (!!mdctrl.selectedRecord[0].case_number) {
                var defer = $q.defer();
                let caseDto = {
                    code: 'covid19_get_admission_by_health_infra_and_case_no',
                    parameters: {
                        caseNo: mdctrl.selectedRecord[0].case_number,
                    }
                };
                Mask.show();
                QueryDAO.execute(caseDto).then(function (res) {
                    if (res.result && res.result.length > 0) {
                        mdctrl.isDuplicateCaseNo = true;
                        mdctrl.caseMsg = res.result[0].resultMsg;
                        defer.reject();
                    } else {
                        mdctrl.isDuplicateCaseNo = false;
                        mdctrl.caseMsg = '';
                        defer.resolve();
                    }
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                    mdctrl.submitted = false;
                });
                return defer.promise;
            }
        };

        mdctrl.admit = function () {
            if (
                ( mdctrl.selectedRecord[0].firstname ? mdctrl.selectedRecord[0].firstname.length : 0) +
                ( mdctrl.selectedRecord[0].middlename ? mdctrl.selectedRecord[0].middlename.length : 0) +
                ( mdctrl.selectedRecord[0].lastname ? mdctrl.selectedRecord[0].lastname.length : 0) > 99 ) {
                    toaster.pop('danger', 'Full Name length should be less than 99 Chars');
                    return;
                }
            mdctrl.admissionform.$setSubmitted();
            if (mdctrl.admissionform.$valid) {
                let caseDto = {
                    code: 'covid19_get_admission_by_health_infra_and_case_no',
                    parameters: {
                        caseNo: mdctrl.selectedRecord[0].case_number,
                    }
                };
                Mask.show();
                QueryDAO.execute(caseDto).then(function (res) {
                    if (res.result && res.result.length > 0) {
                        mdctrl.isDuplicateCaseNo = true;
                        mdctrl.caseMsg = res.result[0].resultMsg;
                        return;
                    } else {
                        mdctrl.isDuplicateCaseNo = false;
                        mdctrl.caseMsg = '';
                    }

                    mdctrl.selectedRecord[0].wardId = mdctrl.selectedRecord[0].ward.id;
                    mdctrl.selectedRecord[0].health_infra_id = mdctrl.selectedRecord[0].ward.health_infra_type_id;
                    let dto = {
                        code: 'insert_covid19_new_admission_detail',
                        parameters: {
                            contact_no: mdctrl.selectedRecord[0].contact_no,
                            address: mdctrl.selectedRecord[0].address,
                            case_number: mdctrl.selectedRecord[0].case_number,
                            firstname: mdctrl.selectedRecord[0].firstname,
                            middlename: mdctrl.selectedRecord[0].middlename,
                            lastname: mdctrl.selectedRecord[0].lastname,
                            age: mdctrl.selectedRecord[0].age,
                            ageMonth: mdctrl.selectedRecord[0].ageMonth,
                            gender: mdctrl.selectedRecord[0].gender,
                            hasFever: mdctrl.selectedRecord[0].hasFever,
                            hasCough: mdctrl.selectedRecord[0].hasCough,
                            hasShortnessBreath: mdctrl.selectedRecord[0].hasShortnessBreath,
                            health_infra_id: mdctrl.selectedRecord[0].health_infra_id,
                            ward_no: mdctrl.selectedRecord[0].wardId,
                            bed_no: mdctrl.selectedRecord[0].bedno,
                            unitno: !!mdctrl.selectedRecord[0].unitno ? mdctrl.selectedRecord[0].unitno : null,
                            health_status: mdctrl.selectedRecord[0].healthstatus,
                            admission_date: moment(mdctrl.selectedRecord[0].admissionDate).format("DD-MM-YYYY"),
                            isHIV: mdctrl.selectedRecord[0].isHIV,
                            isHeartPatient: mdctrl.selectedRecord[0].isHeartPatient,
                            isDiabetes: mdctrl.selectedRecord[0].isDiabetes,
                            isCOPD: mdctrl.selectedRecord[0].isCOPD,
                            isRenalCondition: mdctrl.selectedRecord[0].isRenalCondition,
                            isHypertension: mdctrl.selectedRecord[0].isHypertension,
                            isImmunocompromized: mdctrl.selectedRecord[0].isImmunocompromized,
                            isMalignancy: mdctrl.selectedRecord[0].isMalignancy,
                            loggedIn_user: mdctrl.selectedRecord[0].loggedInUser,
                            districtLocationId: mdctrl.selectedRecord[0].districtLocationId,
                            talukaLocationId: mdctrl.selectedRecord[0].talukaLocationId,
                            pinCode: mdctrl.selectedRecord[0].pinCode,
                            emergencyContactName: !!mdctrl.selectedRecord[0].emergencyContactName ? mdctrl.selectedRecord[0].emergencyContactName : '',
                            emergencyContactNo: mdctrl.selectedRecord[0].emergencyContactNo,
                            pregnancy_status: mdctrl.selectedRecord[0].pregnancy_status,
                            occupation: mdctrl.selectedRecord[0].occupation,
                            date_of_onset_symptom: !!mdctrl.selectedRecord[0].date_of_onset_symptom ? moment(mdctrl.selectedRecord[0].date_of_onset_symptom).format("DD-MM-YYYY") : null,
                            travelHistory: mdctrl.selectedRecord[0].travelHistory,
                            travelledPlace: mdctrl.selectedRecord[0].travelledPlace,
                            is_abroad_in_contact: mdctrl.selectedRecord[0].is_abroad_in_contact,
                            abroad_contact_details: !!mdctrl.selectedRecord[0].abroad_contact_details ? mdctrl.selectedRecord[0].abroad_contact_details : '',
                            referFromHosital: !!mdctrl.selectedRecord[0].referFromHosital ? mdctrl.selectedRecord[0].referFromHosital : '',
                            flightno: !!mdctrl.selectedRecord[0].flightno ? mdctrl.selectedRecord[0].flightno : '',
                            inContactWithCovid19Paitent: mdctrl.selectedRecord[0].inContactWithCovid19Paitent,
                            opdCaseNo: mdctrl.selectedRecord[0].opdCaseNo,
                            isSari: mdctrl.selectedRecord[0].isSari,
                            otherCoMobidity: !!mdctrl.selectedRecord[0].otherCoMobidity ? mdctrl.selectedRecord[0].otherCoMobidity : null,
                            indications: mdctrl.selectedRecord[0].indications,
                            isMigrant: mdctrl.selectedRecord[0].isMigrant,
                            otherIndications: !!mdctrl.selectedRecord[0].otherIndications ? mdctrl.selectedRecord[0].otherIndications : null
                        }
                    };
                    if (dto.parameters.gender !== 'F') {
                        delete dto.parameters.pregnancy_status;
                    }
                    if (dto.parameters.is_abroad_in_contact !== 'yes') {
                        delete dto.parameters.abroad_contact_details;
                    }
                    if (dto.parameters.travelHistory !== 'interstate' && dto.parameters.travelHistory !== 'international') {
                        delete dto.parameters.travelledPlace;
                    }
                    Mask.show();
                    QueryDAO.execute(dto).then(function (admissionRes) {
                        toaster.pop('success', 'COVID-19 New Admission Created Successfully');
                        $uibModalInstance.close();
                    }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                        Mask.hide();
                    });
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                    mdctrl.submitted = false;
                });
            }
        };

        QueryDAO.execute({
            code: 'fetch_listvalue_detail_from_field',
            parameters: {
                field: 'Countries list'
            }
        }).then((response) => {
            mdctrl.countryList = response.result;
        }).catch((error) => {
            GeneralUtil.showMessageOnApiCallFailure(error);
        }).finally(() => {
            Mask.hide();
        });

        Mask.show();
        QueryDAO.execute({
            code: 'retrieve_locations_by_type',
            parameters: {
                type: ['D','C']
            }
        }).then((response) => {
            mdctrl.districtLocations = response.result;
        }).catch((error) => {
            GeneralUtil.showMessageOnApiCallFailure(error);
        }).finally(() => {
            Mask.hide();
        });

        mdctrl.cancel = function () {
            $uibModalInstance.dismiss('cancel');
        };

        mdctrl.onselectHealthStatus = function () {
            if (mdctrl.selectedRecord[0].healthstatus === 'Asymptomatic') {
                mdctrl.selectedRecord[0].date_of_onset_symptom = null;
            }
        };
    }
    angular.module('imtecho.controllers').controller('CovidNewAdmissionDetailsController', CovidNewAdmissionDetailsController);
})();
