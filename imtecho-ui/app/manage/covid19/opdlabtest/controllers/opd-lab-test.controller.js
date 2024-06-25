(function () {
    function CovidLabTestEntry(Mask, QueryDAO, GeneralUtil, $uibModal, AuthenticateService, $state,
        CovidService, PagingService, $sessionStorage) {
        var covidLabTestEntryCtrl = this;
        covidLabTestEntryCtrl.wardList = [];
        covidLabTestEntryCtrl.searchText = '';
        covidLabTestEntryCtrl.isShowFeature = false;
        covidLabTestEntryCtrl.init = function () {
            AuthenticateService.getLoggedInUser().then(function (user) {
                covidLabTestEntryCtrl.currentUser = user.data;
                Mask.show();
                QueryDAO.execute({
                    code: 'retrieve_health_infra_for_user',
                    parameters: {
                        userId: covidLabTestEntryCtrl.currentUser.id
                    }
                }).then(function (res) {
                    if (res.result && res.result.length === 0) {
                        covidLabTestEntryCtrl.message = 'No Health Infrastructure Assigned. Please contact administration.';
                    } else {
                        covidLabTestEntryCtrl.isShowFeature = true;
                        covidLabTestEntryCtrl.searchSuspectedCaseData();
                    }
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                });
            });
            AuthenticateService.getAssignedFeature('techo.manage.covidAdmission').then(function (res) {
                if (!!res && !!res.featureJson) {
                    covidLabTestEntryCtrl.rights = res.featureJson;
                }
            });
        };

        covidLabTestEntryCtrl.getCovid19WardList = function () {
            var dto = {
                code: 'covid19_get_ward_detail',
                parameters: {
                }
            };
            Mask.show();
            QueryDAO.execute(dto).then(function (res) {
                covidLabTestEntryCtrl.wardList = res.result;
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        };

        covidLabTestEntryCtrl.performSearch = function () {
            covidLabTestEntryCtrl.searchSuspectedCaseData();
        }

        covidLabTestEntryCtrl.searchPendingAdmissionData = () => {
            covidLabTestEntryCtrl.retrievePagingService = PagingService.initialize();
            covidLabTestEntryCtrl.getPendingAdmissionData();
        }

        covidLabTestEntryCtrl.getPendingAdmissionData = () => {
            covidLabTestEntryCtrl.criteria = {
                limit: covidLabTestEntryCtrl.retrievePagingService.limit,
                offset: covidLabTestEntryCtrl.retrievePagingService.offSet
            };
            let covidAdmissionCases = covidLabTestEntryCtrl.covidAdmissionCases;
            Mask.show();
            PagingService.getNextPage(CovidService.getPendingAdmissionforLabTest, covidLabTestEntryCtrl.criteria,
                covidAdmissionCases, null).then((response) => {
                    covidLabTestEntryCtrl.covidAdmissionCases = response;
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                });
        }

        covidLabTestEntryCtrl.searchSuspectedCaseData = () => {
            covidLabTestEntryCtrl.retrievePagingService = PagingService.initialize();
            covidLabTestEntryCtrl.getCovid19SuspectCases();
        }

        covidLabTestEntryCtrl.getCovid19SuspectCases = () => {
            covidLabTestEntryCtrl.criteria = {
                limit: covidLabTestEntryCtrl.retrievePagingService.limit,
                offset: covidLabTestEntryCtrl.retrievePagingService.offSet, searchText: covidLabTestEntryCtrl.searchText
            };
            let covid19SuspectedCases = covidLabTestEntryCtrl.covid19SuspectedCases;
            Mask.show();
            PagingService.getNextPage(CovidService.getOpdLabTesttList, covidLabTestEntryCtrl.criteria,
                covid19SuspectedCases, null).then((response) => {
                    covidLabTestEntryCtrl.covid19SuspectedCases = response;
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                });
        }

        covidLabTestEntryCtrl.searchConfirmedCaseData = () => {
            covidLabTestEntryCtrl.retrievePagingService = PagingService.initialize();
            covidLabTestEntryCtrl.getCovid19ConfirmedCases();
        }

        covidLabTestEntryCtrl.getCovid19ConfirmedCases = () => {
            covidLabTestEntryCtrl.criteria = {
                limit: covidLabTestEntryCtrl.retrievePagingService.limit,
                offset: covidLabTestEntryCtrl.retrievePagingService.offSet
            };
            let covid19ConfirmedCases = covidLabTestEntryCtrl.covid19ConfirmedCases;
            Mask.show();
            PagingService.getNextPage(CovidService.getConfirmedAdmittedPatientList, covidLabTestEntryCtrl.criteria,
                covid19ConfirmedCases, null).then((response) => {
                    covidLabTestEntryCtrl.covid19ConfirmedCases = response;
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                });
        }

        covidLabTestEntryCtrl.searchReferInCaseData = () => {
            covidLabTestEntryCtrl.retrievePagingService = PagingService.initialize();
            covidLabTestEntryCtrl.getCovid19ReferInCases();
        }

        covidLabTestEntryCtrl.getCovid19ReferInCases = () => {
            covidLabTestEntryCtrl.criteria = {
                limit: covidLabTestEntryCtrl.retrievePagingService.limit,
                offset: covidLabTestEntryCtrl.retrievePagingService.offSet
            };
            let covid19ReferInCases = covidLabTestEntryCtrl.covid19ReferInCases;
            Mask.show();
            PagingService.getNextPage(CovidService.getReferInPatientList, covidLabTestEntryCtrl.criteria,
                covid19ReferInCases, null).then((response) => {
                    covidLabTestEntryCtrl.covid19ReferInCases = response;
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                });
        }

        covidLabTestEntryCtrl.searchReferOutCaseData = () => {
            covidLabTestEntryCtrl.retrievePagingService = PagingService.initialize();
            covidLabTestEntryCtrl.getCovid19ReferOutCase();
        }

        covidLabTestEntryCtrl.getCovid19ReferOutCase = () => {
            covidLabTestEntryCtrl.criteria = {
                limit: covidLabTestEntryCtrl.retrievePagingService.limit,
                offset: covidLabTestEntryCtrl.retrievePagingService.offSet
            };
            let covid19ReferOutCase = covidLabTestEntryCtrl.covid19ReferOutCase;
            Mask.show();
            PagingService.getNextPage(CovidService.getReferOutPatientList, covidLabTestEntryCtrl.criteria,
                covid19ReferOutCase, null).then((response) => {
                    covidLabTestEntryCtrl.covid19ReferOutCase = response;
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                });
        }

        covidLabTestEntryCtrl.onAdmitClick = function (id) {
            covidLabTestEntryCtrl.selectedRecord = covidLabTestEntryCtrl.covidAdmissionCases && _.filter(covidLabTestEntryCtrl.covidAdmissionCases, (d) => {
                return d.id == id
            });
            covidLabTestEntryCtrl.selectedRecord[0].loggedInUser = covidLabTestEntryCtrl.currentUser.id;
            var modalInstance = $uibModal.open({
                templateUrl: 'app/manage/covid19/views/covidadmissiondetailsform.html',
                controllerAs: 'mdctrl',
                controller: 'CovidTravellerAdmissionDetailsController',
                windowClass: 'cst-modal',
                size: 'lg',
                backdrop: 'static',
                resolve: {
                    selectedRecord: function () {
                        return covidLabTestEntryCtrl.selectedRecord;
                    },
                    wardList: function () {
                        return covidLabTestEntryCtrl.wardList;
                    }
                }
            });
            modalInstance.result.then(function (res) {
                covidLabTestEntryCtrl.searchPendingAdmissionData();
            }, function () { });
        };

        covidLabTestEntryCtrl.onReferInAdmitClick = function (id) {
            covidLabTestEntryCtrl.selectedRecord = covidLabTestEntryCtrl.covid19ReferInCases && _.filter(covidLabTestEntryCtrl.covid19ReferInCases, (d) => {
                return d.id == id
            });
            covidLabTestEntryCtrl.selectedRecord[0].loggedInUser = covidLabTestEntryCtrl.currentUser.id;
            var modalInstance = $uibModal.open({
                templateUrl: 'app/manage/covid19/views/covidReferInAdmit.modal.html',
                controllerAs: 'mdctrl',
                controller: 'CovidReferInAdmitModalController',
                windowClass: 'cst-modal',
                size: 'lg',
                backdrop: 'static',
                resolve: {
                    selectedRecord: function () {
                        return covidLabTestEntryCtrl.selectedRecord;
                    },
                    wardList: function () {
                        return covidLabTestEntryCtrl.wardList;
                    }
                }
            });
            modalInstance.result.then(function (res) {
                covidLabTestEntryCtrl.searchReferInCaseData();
            }, function () { });
        };

        covidLabTestEntryCtrl.addReportPermission = (codes) => {
            codes.forEach((code) => {
                let state = `techo.report.view/{"id":"${code}","type":"code","queryParams":null}`;
                if ($sessionStorage.asldkfjlj) {
                    $sessionStorage.asldkfjlj[state] = true;
                } else {
                    $sessionStorage.asldkfjlj = {};
                    $sessionStorage.asldkfjlj[state] = true;
                }
            });
        }

        covidLabTestEntryCtrl.openReport = (code, locationId) => {
            let temp = `techo.report.view({"id":"${code}","type":"code","queryParams":{"location_id":"${locationId}"}})`;
            let parameters = JSON.parse(temp.substring(temp.indexOf('(') + 1, temp.length - 1));
            let state = temp.substring(0, temp.indexOf('(')) + '/' + angular.toJson(parameters);
            if ($sessionStorage.asldkfjlj) {
                $sessionStorage.asldkfjlj[state] = true;
            } else {
                $sessionStorage.asldkfjlj = {};
                $sessionStorage.asldkfjlj[state] = true;
            }
            let url = $state.href(temp.substring(0, temp.indexOf('(')), parameters, { inherit: false, absolute: false });
            sessionStorage.setItem('linkClick', 'true')
            window.open(url, '_blank');
        }

        covidLabTestEntryCtrl.getCollection = () => {
            covidLabTestEntryCtrl.addReportPermission(['userwise_sample_info']);
            covidLabTestEntryCtrl.openReport('userwise_sample_info', 2)
        }

        covidLabTestEntryCtrl.onNewLabTestClick = function () {
            covidLabTestEntryCtrl.selectedRecord = [];
            covidLabTestEntryCtrl.selectedRecord.push({});
            covidLabTestEntryCtrl.selectedRecord[0].loggedInUser = covidLabTestEntryCtrl.currentUser.id;
            var modalInstance = $uibModal.open({
                templateUrl: 'app/manage/covid19/opdlabtest/views/new-opd-lab-test.modal.html',
                controllerAs: 'mdctrl',
                controller: 'CovidNewLabTestDetailsController',
                windowClass: 'cst-modal',
                backdrop: 'static',
                size: 'lg',
                resolve: {
                    selectedRecord: function () {
                        return covidLabTestEntryCtrl.selectedRecord;
                    },
                    wardList: function () {
                        return covidLabTestEntryCtrl.wardList;
                    }
                }
            });
            modalInstance.result.then(function (res) {
                covidLabTestEntryCtrl.searchSuspectedCaseData();
            }, function () { });
        };

        covidLabTestEntryCtrl.onAddDaliyStatus = function (covidCase) {
            var modalInstance = $uibModal.open({
                templateUrl: 'app/manage/covid19/views/covid19AdmittedCaseDailyStatus.modal.html',
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
                        return covidLabTestEntryCtrl.wardList;
                    }
                }
            });
            modalInstance.result.then(() => {
                covidLabTestEntryCtrl.searchSuspectedCaseData();
                covidLabTestEntryCtrl.searchConfirmedCaseData();
            });
        }

        covidLabTestEntryCtrl.discharge = function (covidCase, isSuspected) {
            covidCase.isSuspected = isSuspected;
            var modalInstance = $uibModal.open({
                templateUrl: 'app/manage/covid19/views/discharge.modal.html',
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
                        return covidLabTestEntryCtrl.currentUser;
                    }
                }
            });
            modalInstance.result.then(() => {
                covidLabTestEntryCtrl.searchSuspectedCaseData();
                covidLabTestEntryCtrl.searchConfirmedCaseData();
            });
        }

        covidLabTestEntryCtrl.printPdf = (covidCase) => {
            Mask.show();
            CovidService.downloadOpdLabSrfPdf([covidCase.labTestId]).then(function (res) {
                if (res.data !== null && navigator.msSaveBlob) {
                    return navigator.msSaveBlob(new Blob([res.data], { type: "application/pdf;charset=UTF-8'" }));
                }
                var a = $("<a style='display: none;'/>");
                var url = window.URL.createObjectURL(new Blob([res.data], { type: "application/pdf;charset=UTF-8'" }));
                a.attr("href", url);
                var pdfName = covidCase.labTestIdFromLabTest ? (covidCase.labTestIdFromLabTest + "_" + covidCase.memberDetail + ".pdf") : (covidCase.memberDetail + ".pdf");
                a.attr("download", pdfName);
                $("body").append(a);
                a[0].click();
                window.URL.revokeObjectURL(url);
                a.remove();
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        }

        covidLabTestEntryCtrl.init();

    }
    angular.module('imtecho.controllers').controller('CovidLabTestEntry', CovidLabTestEntry);
})();

// $uib model Addmit On Pending Admission
(function () {
    function CovidTravellerAdmissionDetailsController(Mask, GeneralUtil, selectedRecord, wardList, $uibModalInstance, QueryDAO, toaster) {
        var mdctrl = this;
        mdctrl.selectedRecord = selectedRecord;
        mdctrl.wardList = wardList;
        mdctrl.selectedRecord[0].admissionDate = new Date();
        mdctrl.selectedRecord[0].pregnancy_status = 'no';
        mdctrl.getDate = function (date) {
            return (date.getMonth() + 1) + "-" + date.getDate() + "-" + date.getFullYear();
        };

        mdctrl.submit = function () {
            mdctrl.admissionform.$setSubmitted();
            if (mdctrl.admissionform.$valid && mdctrl.selectedRecord[0].memberId) {
                mdctrl.selectedRecord[0].wardId = JSON.parse(mdctrl.selectedRecord[0].ward).id;
                mdctrl.selectedRecord[0].health_infra_id = JSON.parse(mdctrl.selectedRecord[0].ward).health_infra_type_id;

                var dto = {
                    code: 'covid_19_save_only_lab_test_admission',
                    parameters: {
                        member_id: mdctrl.selectedRecord[0].memberId,
                        districtLocationId: mdctrl.selectedRecord[0].locationId,
                        health_infra_id: mdctrl.selectedRecord[0].health_infra_id,
                        covid19_lab_test_recommendation_id: mdctrl.selectedRecord[0].id,
                        case_number: mdctrl.selectedRecord[0].case_number,
                        unitno: !!mdctrl.selectedRecord[0].unitno ? mdctrl.selectedRecord[0].unitno : null,
                        health_status: mdctrl.selectedRecord[0].healthstatus,
                        admission_date: mdctrl.selectedRecord[0].admissionDate,
                        hasFever: mdctrl.selectedRecord[0].hasFever,
                        hasCough: mdctrl.selectedRecord[0].hasCough,
                        hasShortnessBreath: mdctrl.selectedRecord[0].hasShortnessBreath,
                        isHIV: mdctrl.selectedRecord[0].isHIV,
                        isHeartPatient: mdctrl.selectedRecord[0].isHeartPatient,
                        isDiabetes: mdctrl.selectedRecord[0].isDiabetes,
                        isCOPD: mdctrl.selectedRecord[0].isCOPD,
                        isRenalCondition: mdctrl.selectedRecord[0].isRenalCondition,
                        isHypertension: mdctrl.selectedRecord[0].isHypertension,
                        isImmunocompromized: mdctrl.selectedRecord[0].isImmunocompromized,
                        isMalignancy: mdctrl.selectedRecord[0].isMalignancy,
                        pregnancy_status: mdctrl.selectedRecord[0].pregnancy_status,
                        emergencyContactName: !!mdctrl.selectedRecord[0].emergencyContactName ? mdctrl.selectedRecord[0].emergencyContactName : '',
                        emergencyContactNo: mdctrl.selectedRecord[0].emergencyContactNo,
                        date_of_onset_symptom: !!mdctrl.selectedRecord[0].date_of_onset_symptom ? mdctrl.getDate(mdctrl.selectedRecord[0].date_of_onset_symptom) : null,
                        loggedIn_user: mdctrl.selectedRecord[0].loggedInUser,
                        opdCaseNo: mdctrl.selectedRecord[0].opdCaseNo,
                        isMigrant: mdctrl.selectedRecord[0].isMigrant,
                        otherIndications: !!mdctrl.selectedRecord[0].otherIndications ? mdctrl.selectedRecord[0].otherIndications : null,
                    }
                };
                Mask.show();
                QueryDAO.execute(dto).then(function (res) {
                    toaster.pop('success', 'COVID-19 Data Created Successfully');
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                    $uibModalInstance.close();
                });
            }
        }

        mdctrl.cancel = function () {
            $uibModalInstance.dismiss('cancel');
        }
    }
    angular.module('imtecho.controllers').controller('CovidTravellerAdmissionDetailsController', CovidTravellerAdmissionDetailsController);
})();


// $uib model New Admission
(function () {
    function CovidNewLabTestDetailsController(Mask, AuthenticateService, GeneralUtil, selectedRecord, wardList, $uibModalInstance, QueryDAO, toaster) {
        var mdctrl = this;
        mdctrl.selectedRecord = selectedRecord;
        mdctrl.wardList = wardList;
        mdctrl.selectedRecord[0].admissionDate = new Date();
        mdctrl.collectionDate = new Date();
        mdctrl.today = new Date();
        mdctrl.collectionTime = new Date(
            moment().year(),
            moment().month(),
            moment().date(),
            moment().hours(),
            moment().minutes()
        );
        Mask.show();
        AuthenticateService.getLoggedInUser().then((response) => {
            mdctrl.currentUser = response.data
            return QueryDAO.execute({
                code: 'retrieve_health_infra_for_user',
                parameters: {
                    userId: mdctrl.currentUser.id
                }
            })
        }).then((response) => {
            mdctrl.healthInfras = response.result;
            setTimeout(() => {
                $('#hospital').trigger("chosen:updated")
            })
            if (response.result.length === 1) {
                mdctrl.selectedRecord[0].health_infra_id = response.result[0].id
            }
        }).catch((error) => {
            GeneralUtil.showMessageOnApiCallFailure(error);
        }).finally(() => {
            Mask.hide();
        })
        mdctrl.selectedRecord[0].pregnancy_status = 'no';
        mdctrl.getDate = function (date) {
            return (date.getMonth() + 1) + "-" + date.getDate() + "-" + date.getFullYear();

        };
        mdctrl.admit = function () {
            mdctrl.admissionform.$setSubmitted();
            if (mdctrl.admissionform.$valid && (mdctrl.selectedRecord[0].firstname.length +
                                              (mdctrl.selectedRecord[0].middlename ? mdctrl.selectedRecord[0].middlename.length : 0) +
                                        mdctrl.selectedRecord[0].lastname.length)  <= 99) {
                const collectionDate = moment(mdctrl.getDateTime(mdctrl.collectionDate, mdctrl.collectionTime)).format('DD/MM/YYYY HH:mm:ss');
                var dto = {
                    code: 'covid_19_save_only_lab_test_admission',
                    parameters: {
                        contact_no: mdctrl.selectedRecord[0].contact_no,
                        address: mdctrl.selectedRecord[0].address,
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
                        unitno: !!mdctrl.selectedRecord[0].unitno ? mdctrl.selectedRecord[0].unitno : null,
                        health_status: mdctrl.selectedRecord[0].healthstatus,
                        admission_date: collectionDate,
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
                        date_of_onset_symptom: !!mdctrl.selectedRecord[0].date_of_onset_symptom ? mdctrl.getDate(mdctrl.selectedRecord[0].date_of_onset_symptom) : null,
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
                        otherIndications: !!mdctrl.selectedRecord[0].otherIndications ? mdctrl.selectedRecord[0].otherIndications : null,
                        suggestedHealthInfra: mdctrl.selectedRecord[0].suggestedHealthInfra,
                        labHealthInfraId: mdctrl.labHealthInfraId || null,
                        collectionDate: collectionDate,
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
                QueryDAO.execute(dto).then(function (res) {
                    toaster.pop('success', 'Lab Test Entry successfully submitted');
                    $uibModalInstance.close();
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                });
            }
        };

        mdctrl.onselectHealthStatus = function () {
            if (mdctrl.selectedRecord[0].healthstatus === 'Asymptomatic') {
                mdctrl.selectedRecord[0].date_of_onset_symptom = null;
            }
        }

        mdctrl.retrieveLabTestByLocation = (locationId) => {
            return QueryDAO.execute({
                code: 'retrieve_covid_lab_test_by_location',
                parameters: {
                    locationId: locationId || null
                }
            });
        }

        mdctrl.retrieveCovidHospitalByLocation = (locationId) => {
            return QueryDAO.execute({
                code: 'retrieve_covid_hospitals_by_location',
                parameters: {
                    locationId: locationId || null
                }
            });
        }

        mdctrl.labLocationChanged = () => {
            Mask.show();
            mdctrl.healthInfraId = null;
            mdctrl.retrieveLabTestByLocation(mdctrl.labLocationId).then((response) => {
                mdctrl.labList = response.result;
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        mdctrl.hospitalLocationChanged = () => {
            Mask.show();
            mdctrl.healthInfraId = null;
            mdctrl.retrieveCovidHospitalByLocation(mdctrl.covidHospitalLocationId).then((response) => {
                mdctrl.covidHospitalList = response.result;
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        mdctrl.getDateTime = (date, time) => {
            return new Date(
                date.getFullYear(),
                date.getMonth(),
                date.getDate(),
                time.getHours(),
                time.getMinutes(),
            );
        }

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

        Mask.show();
        QueryDAO.execute({
            code: 'covid19_retrieve_lab_location',
            parameters: {
                type: ['D','C']
            }
        }).then((response) => {
            mdctrl.labLocations = response.result;
        }).catch((error) => {
            GeneralUtil.showMessageOnApiCallFailure(error);
        }).finally(() => {
            Mask.hide();
        });

        Mask.show();
        QueryDAO.execute({
            code: 'covid19_retrieve_covid_hospital_location',
            parameters: {
                type: ['D','C']
            }
        }).then((response) => {
            mdctrl.covidHospitalLocations = response.result;
        }).catch((error) => {
            GeneralUtil.showMessageOnApiCallFailure(error);
        }).finally(() => {
            Mask.hide();
        });

        mdctrl.cancel = function () {
            $uibModalInstance.dismiss('cancel');
        };
    }
    angular.module('imtecho.controllers').controller('CovidNewLabTestDetailsController', CovidNewLabTestDetailsController);
})();
