(function () {
    function EmoDashboardController(Mask, toaster, $state, QueryDAO, AuthenticateService, PagingService, GeneralUtil, CovidService, $uibModal) {
        var emo = this;
        emo.referredForCovidLabTest = [];
        emo.searchText = '';
        emo.init = () => {
            Mask.show();
            AuthenticateService.getLoggedInUser().then((user) => {
                emo.user = user.data
                return AuthenticateService.getAssignedFeature($state.current.name);
            }).then((response) => {
                emo.rights = response.featureJson
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        emo.performSearch = function () {
            if (emo.selectedTab === "referred-for-covid-lab-test-tab") {
                emo.referredForCovidLabTestTabSelected();
            } else if (emo.selectedTab === "approved-for-covid-lab-test-tab") {
                emo.approvedForCovidLabTestTabSelected();
            } else if (emo.selectedTab === "referred-patient-status-tab") {
                emo.referredPatientStatusTabSelected();
            }
        }

        emo.retrieveHealthInfrastructuresByLocation = () => {
            return QueryDAO.execute({
                code: 'retrieve_covid_hospitals_by_location',
                parameters: {
                    locationId: emo.districtlocationId
                }
            });
        }

        emo.referLocationChanged = () => {
            Mask.show();
            emo.healthInfraId = null;
            emo.retrieveHealthInfrastructuresByLocation().then((response) => {
                emo.healthInfrastructureList = response.result;
                setTimeout(() => {
                    $('#healthInfrastructure').trigger('chosen:updated');
                })
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        emo.getReferredForCovidLabTest = () => {
            emo.criteria = {
                limit: emo.retrievePagingService.limit, offset: emo.retrievePagingService.offSet,
                searchText: emo.searchText
            };
            let referredForCovidLabTest = emo.referredForCovidLabTest;
            Mask.show();
            PagingService.getNextPage(CovidService.retrieveReferredForCovidLabTest, emo.criteria, referredForCovidLabTest, null).then((response) => {
                emo.referredForCovidLabTest = response;
                emo.referredForCovidLabTest.forEach((member) => {
                    const symptomsArray = [];
                    if (member.hasCough) {
                        symptomsArray.push('Cough');
                    }
                    if (member.hasFever) {
                        symptomsArray.push('Fever')
                    }
                    if (member.hasBreathlessness) {
                        symptomsArray.push('Breathlessness')
                    }
                    member.symptoms = symptomsArray.join();
                    //member.hasTravelHistory = member.hasTravelHistory ? 'Yes' : 'No'
                })
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        emo.getApprovedForCovidLabTest = () => {
            emo.criteria = {
                limit: emo.retrievePagingService.limit, offset: emo.retrievePagingService.offSet,
                searchText: emo.searchText
            };
            let approvedForCovidLabTest = emo.approvedForCovidLabTest;
            Mask.show();
            PagingService.getNextPage(CovidService.retrieveApprovedForCovidLabTest, emo.criteria, approvedForCovidLabTest, null).then((response) => {
                emo.approvedForCovidLabTest = response;
                emo.approvedForCovidLabTest.forEach((member) => {
                    const symptomsArray = [];
                    if (member.hasCough) {
                        symptomsArray.push('Cough');
                    }
                    if (member.hasFever) {
                        symptomsArray.push('Fever')
                    }
                    if (member.hasBreathlessness) {
                        symptomsArray.push('Breathlessness')
                    }
                    member.symptoms = symptomsArray.join();
                    //member.hasTravelHistory = member.hasTravelHistory ? 'Yes' : 'No'
                })
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        emo.getReferredPatientStatusList = () => {
            emo.criteria = {
                limit: emo.retrievePagingService.limit, offset: emo.retrievePagingService.offSet,
                searchText: emo.searchText
            };
            let referredPatientStatusList = emo.referredPatientStatusList;
            Mask.show();
            PagingService.getNextPage(CovidService.retrieveReferredPatientStatusList, emo.criteria, referredPatientStatusList, null).then((response) => {
                emo.referredPatientStatusList = response;
                emo.referredPatientStatusList.forEach((member) => {
                    const symptomsArray = [];
                    if (member.hasCough) {
                        symptomsArray.push('Cough');
                    }
                    if (member.hasFever) {
                        symptomsArray.push('Fever')
                    }
                    if (member.hasBreathlessness) {
                        symptomsArray.push('Breathlessness')
                    }
                    member.symptoms = symptomsArray.join();
                    //member.hasTravelHistory = member.hasTravelHistory ? 'Yes' : 'No'
                })
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        emo.referredForCovidLabTestTabSelected = (resetSearch) => {
            if (!!resetSearch) {
                emo.searchText = '';
            }
            emo.retrievePagingService = PagingService.initialize();
            emo.getReferredForCovidLabTest();
        }

        emo.referredPatientStatusTabSelected = (resetSearch) => {
            if (!!resetSearch) {
                emo.searchText = '';
            }
            emo.retrievePagingService = PagingService.initialize();
            emo.getReferredPatientStatusList();
        }

        emo.approvedForCovidLabTestTabSelected = (resetSearch) => {
            if (!!resetSearch) {
                emo.searchText = '';
            }
            Mask.show();
            QueryDAO.execute({
                code: 'retrieve_locations_by_type',
                parameters: {
                    type: ['D', 'C']
                }
            }).then((response) => {
                emo.districtLocations = response.result;
                setTimeout(() => {
                    $('#districtlocationId').trigger("chosen:updated");
                });
                return emo.retrieveHealthInfrastructuresByLocation();
            }).then((response) => {
                emo.healthInfrastructureList = response.result;
                setTimeout(() => {
                    $('#healthInfrastructure').trigger('chosen:updated');
                });
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            })
            emo.retrievePagingService = PagingService.initialize();
            emo.getApprovedForCovidLabTest();
        }

        emo.updateResultOfLabTest = (member, result) => {
            var modalInstance = $uibModal.open({
                templateUrl: 'app/common/views/confirmation.modal.html',
                controller: 'ConfirmModalController',
                windowClass: 'cst-modal',
                size: 'med',
                resolve: {
                    message: function () {
                        return "Are you sure you want to mark the member as " + result.toLowerCase() + "?";
                    }
                }
            });
            modalInstance.result.then(() => {
                Mask.show();
                QueryDAO.execute({
                    code: 'emo_dashboard_update_lab_test_result',
                    parameters: {
                        id: member.id,
                        result: result
                    }
                }).then((response) => {
                    toaster.pop('success', "Lab test result updated successfully");
                    emo.referredForCovidLabTestTabSelected();
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                })
            });
        }

        emo.referPatient = (member) => {
            emo.currentReferMember = member;
            $("#referHealthInfrastructureModal").modal({ backdrop: 'static', keyboard: false });
        }

        emo.saveReferralDetails = () => {
            if (emo.referHealthInfrastructureForm.$valid) {
                Mask.show();
                QueryDAO.execute({
                    code: 'emo_dashboard_save_referral_details',
                    parameters: {
                        id: emo.currentReferMember.id,
                        healthInfraId: emo.healthInfraId,
                        userId: emo.user.id
                    }
                }).then((response) => {
                    toaster.pop('success', 'Details saved successfully');
                    emo.cancel();
                    emo.retrievePagingService = PagingService.initialize();
                    emo.getApprovedForCovidLabTest();
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                })
            }
        }

        emo.cancel = () => {
            $("#referHealthInfrastructureModal").modal('hide');
            emo.currentReferMember = {}
            emo.districtlocationId = null;
            emo.healthInfraId = null;
            emo.referHealthInfrastructureForm.$setPristine();
        }

        emo.init();
    }
    angular.module('imtecho.controllers').controller('EmoDashboardController', EmoDashboardController);
})();
