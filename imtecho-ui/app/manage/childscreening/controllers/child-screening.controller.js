(function () {
    function ChildScreeningController(ChildScreeningService, Mask, $state, toaster, AuthenticateService, QueryDAO, GeneralUtil, $uibModal, $filter) {
        var childscreening = this;
        childscreening.todayDate = new Date();
        childscreening.MS_PER_DAY = 1000 * 60 * 60 * 24;
        childscreening.minAdmissionDate = new Date(moment().subtract('days', 3));
        let illness = [];
        $(".modal-backdrop").remove();
        $("body").removeClass("modal-open");

        childscreening.saveForm = () => {
            if (childscreening.childScreeningForm.$valid) {
                childscreening.childScreeningObject.screeningId = childscreening.currentChild.screeningId;
                childscreening.childScreeningObject.childId = $state.params.id;
                childscreening.childScreeningObject.referredBy = childscreening.loggedInUserId;
                if (childscreening.isDischargeForm) {
                    childscreening.childScreeningObject.admissionId = childscreening.currentChild.admissionId;
                    childscreening.childScreeningObject.weight = childscreening.childScreeningObject.weightAtAdmission;
                    if (childscreening.childScreeningObject.bilateralPittingOedema != 'NOTPRESENT') {
                        toaster.pop('error', "Oedema is not cured");
                    } else if (!childscreening.childScreeningObject.illness.includes('NONE')) {
                        toaster.pop('error', "Child cannot be discharged if any illness is present");
                    } else if (childscreening.currentChild.noOfTimesAmoxicillinGiven < 5) {
                        toaster.pop('error', "Amoxicillin is not given for atleast 5 days");
                    } else {
                        if (!childscreening.currentChild.consecutive3DaysWeightGain) {
                            let modalInstance = $uibModal.open({
                                templateUrl: 'app/common/views/confirmation.modal.html',
                                controller: 'ConfirmModalController',
                                windowClass: 'cst-modal',
                                backdrop: 'static',
                                keyboard: false,
                                title: '',
                                size: 'med',
                                resolve: {
                                    message: () => {
                                        return 'Weight growth has not achieved the target of 5gm/kg/day for 3 consecutive days. Are you sure you want to proceed with the discharge?';
                                    }
                                }
                            });
                            modalInstance.result.then(() => {
                                childscreening.saveDischargeDetails();
                            });
                        } else {
                            childscreening.saveDischargeDetails();
                        }
                    }
                } else if (childscreening.isAdmissionForm) {
                    if (childscreening.childScreeningObject.midUpperArmCircumference != null
                        && childscreening.childScreeningObject.midUpperArmCircumference > 11.5
                        && childscreening.childScreeningObject.sdScore !== 'SD3' && childscreening.childScreeningObject.sdScore !== 'SD4'
                        && childscreening.childScreeningObject.bilateralPittingOedema === 'NOTPRESENT') {
                        Mask.show();
                        ChildScreeningService.deleteChildScreeningByChildId($state.params.id).then(() => {
                            toaster.pop('error', 'Only SAM child can be admitted. Child will be removed from screening list if exists.');
                            $state.go('techo.manage.childscreeninglist');
                        }).catch((error) => {
                            GeneralUtil.showMessageOnApiCallFailure(error);
                        }).finally(() => {
                            Mask.hide();
                        });
                    } else {
                        if (!childscreening.matchedChildFlag) {
                            childscreening.childScreeningObject.isDirectAdmission = true;
                            childscreening.childScreeningObject.locationId = childscreening.currentChild.locationId;
                        } else {
                            childscreening.childScreeningObject.caseId = childscreening.childScreeningObject.screeningId;
                        }
                        childscreening.childScreeningObject.screeningCenter = childscreening.screeningCenter;
                        childscreening.childScreeningObject.state = 'ACTIVE';
                        if (childscreening.childScreeningObject.admissionDate < moment().startOf('day')) {
                            let modalInstance = $uibModal.open({
                                templateUrl: 'app/common/views/alert.modal.html',
                                controller: 'alertModalController',
                                windowClass: 'cst-modal',
                                title: '',
                                size: 'med',
                                resolve: {
                                    message: () => {
                                        return 'Please make sure to enter the daily weight details till the current date to prevent child from going into defaulter.';
                                    }
                                }
                            });
                            modalInstance.result.then(() => {
                                childscreening.checkIllness();
                                Mask.show();
                                ChildScreeningService.create(childscreening.childScreeningObject).then((response) => {
                                    toaster.pop('success', 'Details saved successfully');
                                    $state.go('techo.manage.childscreeninglist');
                                }).catch((error) => {
                                    childscreening.childScreeningObject.illness = illness;
                                    GeneralUtil.showMessageOnApiCallFailure(error);
                                }).finally(() => {
                                    Mask.hide();
                                })
                            }, () => {
                            });
                        } else {
                            childscreening.checkIllness();
                            Mask.show();
                            ChildScreeningService.create(childscreening.childScreeningObject).then((response) => {
                                toaster.pop('success', 'Details saved successfully');
                                $state.go('techo.manage.childscreeninglist');
                            }).catch((error) => {
                                childscreening.childScreeningObject.illness = illness;
                                GeneralUtil.showMessageOnApiCallFailure(error);
                            }).finally(() => {
                                Mask.hide();
                            });
                        }
                    }
                } else if (childscreening.isFollowUpForm) {
                    childscreening.childScreeningObject.admissionId = childscreening.currentChild.admissionId;
                    childscreening.childScreeningObject.weight = childscreening.childScreeningObject.weightAtAdmission;
                    childscreening.childScreeningObject.followUpVisit = childscreening.followUpVisit;
                    childscreening.childScreeningObject.caseId = childscreening.childScreeningObject.screeningId;
                    childscreening.checkIllness();
                    Mask.show();
                    ChildScreeningService.saveFollowUp(childscreening.childScreeningObject).then((response) => {
                        // Update fhir json by adding follow up details
                        toaster.pop('success', 'Details saved successfully');
                        $state.go('techo.manage.childscreeninglist');
                    }).catch((error) => {
                        childscreening.childScreeningObject.illness = illness;
                        GeneralUtil.showMessageOnApiCallFailure(error);
                    }).finally(() => {
                        Mask.hide();
                    })
                }
            }
        }

        childscreening.calculateSdScore = () => {
            if (childscreening.currentChild.gender != null) {
                if (childscreening.childScreeningObject.height != null && childscreening.childScreeningObject.weightAtAdmission != null) {
                    if (Number.isInteger(childscreening.childScreeningObject.height)) {
                        Mask.show();
                        ChildScreeningService.retrieveSdScore(childscreening.currentChild.gender, childscreening.childScreeningObject.height, childscreening.childScreeningObject.weightAtAdmission).then((response) => {
                            switch (response.sdScore) {
                                case 'SD4':
                                    childscreening.childScreeningObject.sdScore = "SD4";
                                    childscreening.childScreeningObject.sdScoreDisplay = "Less than -4";
                                    break;
                                case 'SD3':
                                    childscreening.childScreeningObject.sdScore = "SD3";
                                    childscreening.childScreeningObject.sdScoreDisplay = "-4 to -3";
                                    break;
                                case 'SD2':
                                    childscreening.childScreeningObject.sdScore = "SD2";
                                    childscreening.childScreeningObject.sdScoreDisplay = "-3 to -2";
                                    break;
                                case 'SD1':
                                    childscreening.childScreeningObject.sdScore = "SD1";
                                    childscreening.childScreeningObject.sdScoreDisplay = "-2 to -1";
                                    break;
                                case 'MEDIAN':
                                    childscreening.childScreeningObject.sdScore = "MEDIAN";
                                    childscreening.childScreeningObject.sdScoreDisplay = "MEDIAN";
                                    break;
                                default:
                                    childscreening.childScreeningObject.sdScore = "NONE";
                                    childscreening.childScreeningObject.sdScoreDisplay = "NONE";
                                    break;
                            }
                        }).catch((error) => {
                            GeneralUtil.showMessageOnApiCallFailure(error);
                        }).finally(() => {
                            Mask.hide();
                        });
                    } else {
                        toaster.pop('error', 'Height not allowed in decimal value');
                        childscreening.childScreeningObject.height = null;
                    }
                }
            } else {
                toaster.pop('error', 'Gender Not Found');
            }
            if (childscreening.below6Months && childscreening.childScreeningObject.height != null && childscreening.childScreeningObject.height < 45) {
                childscreening.showWasting = true;
            } else {
                childscreening.showWasting = false;
            }
            childscreening.childScreeningObject.visibleWasting = null
        }

        childscreening.checkAdmissionIndicator = () => {
            Mask.show();
            ChildScreeningService.checkAdmissionIndicator($state.params.id, moment(childscreening.childScreeningObject.admissionDate).format("DD/MM/YYYY")).then((response) => {
                childscreening.childScreeningObject.typeOfAdmission = response.admissionType;
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            })
        }

        childscreening.init = () => {
            if ($state.params.action == 'admission') {
                childscreening.isAdmissionForm = true;
                $state.current.title = 'Child Screening Admission'
            } else if ($state.params.action == 'discharge') {
                childscreening.isDischargeForm = true;
                $state.current.title = 'Child Discharge'
            } else if ($state.params.action == 'followup') {
                childscreening.isFollowUpForm = true;
                $state.current.title = 'Follow Up Visit'
            }
            let diffInDischargeAndTodayDate = 0;
            Mask.show();
            AuthenticateService.getLoggedInUser().then((user) => {
                childscreening.loggedInUserId = user.data.id;
                return QueryDAO.execute({
                    code: 'fetch_listvalue_detail_from_field',
                    parameters: {
                        field: 'Health Infrastructure Type'
                    }
                });
            }).then((response) => {
                childscreening.institutionTypes = response.result;
                return QueryDAO.execute({
                    code: 'retrieve_screening_centers_cmtc',
                    parameters: {
                        userId: childscreening.loggedInUserId
                    }
                });
            }).then((response) => {
                if (response.result.length > 0) {
                    childscreening.chooseCmtcCenter = true;
                    childscreening.assignedCentersList = response.result;
                    return QueryDAO.execute({
                        code: 'retrieve_cmtc_centers_by_user_assigned_location',
                        parameters: {
                            userId: childscreening.loggedInUserId
                        }
                    });
                } else {
                    Promise.reject();
                }
            }).then((response) => {
                childscreening.screeningCentersList = response.result;
                return QueryDAO.execute({
                    code: 'child_cmtc_nrc_screening_details',
                    parameters: {
                        childId: Number($state.params.id)
                    }
                });
            }).then((response) => {
                if (response.result.length === 1) {
                    childscreening.matchedChildFlag = true;
                    childscreening.currentChild = response.result[0];
                    return Promise.resolve();
                } else {
                    childscreening.matchedChildFlag = false;
                    return QueryDAO.execute({
                        code: 'child_cmtc_nrc_screening_details_for_direct_admission',
                        parameters: {
                            childId: Number($state.params.id)
                        }
                    });
                }
            }).then((response) => {
                if (!childscreening.matchedChildFlag && response != null && response.result.length === 1) {
                    childscreening.currentChild = response.result[0];
                    return Promise.resolve();
                } else if (childscreening.matchedChildFlag && childscreening.currentChild.admissionId != null) {
                    return ChildScreeningService.retrieveAdmissionDetailById(childscreening.currentChild.admissionId);
                } else if (!childscreening.matchedChildFlag && response != null && response.result.length === 0) {
                    return Promise.reject();
                } else {
                    return Promise.resolve();
                }
            }).then((response) => {
                if (response != null) {
                    childscreening.currentChild.admissionDate = new Date(response.admissionDate);
                    childscreening.currentChild.minimumDischargeDate = moment(childscreening.currentChild.admissionDate).add(6, 'days');
                    childscreening.currentChild.displayAdmissionDate = moment(childscreening.currentChild.admissionDate).format("DD-MM-YYYY");
                    childscreening.currentChild.noOfTimesAmoxicillinGiven = response.noOfTimesAmoxicillinGiven;
                    childscreening.currentChild.consecutive3DaysWeightGain = response.consecutive3DaysWeightGain;
                    childscreening.displayWeightAtAdmission = response.weightAtAdmission;
                }
                if (childscreening.isFollowUpForm) {
                    return ChildScreeningService.getDischargeDetails(childscreening.currentChild.dischargeId);
                } else if (childscreening.isDischargeForm) {
                    return ChildScreeningService.retrieveWeightList(childscreening.currentChild.admissionId);
                } else {
                    return Promise.resolve();
                }
            }).then((response) => {
                if (response != null) {
                    if (childscreening.isFollowUpForm) {
                        childscreening.dischargeDetails = response;
                        childscreening.childDischargeDate = moment(response.dischargeDate);
                        childscreening.childDischargeDisplayDate = moment(response.dischargeDate).format("DD-MM-YYYY");
                        diffInDischargeAndTodayDate = childscreening.dateDiffInDays(new Date(response.dischargeDate), new Date());
                        return ChildScreeningService.getLastFollowUpVisit($state.params.id, childscreening.currentChild.admissionId)
                    } else if (childscreening.isDischargeForm) {
                        childscreening.weightList = response;
                        return ChildScreeningService.retrieveLaboratoryList(childscreening.currentChild.admissionId);
                    }
                } else {
                    return Promise.resolve();
                }
            }).then((response) => {
                if (response != null) {
                    if (childscreening.isFollowUpForm) {
                        if (response.followUpVisit == null) {
                            if (diffInDischargeAndTodayDate < 29) {
                                childscreening.followUpVisit = 1;
                                childscreening.minFollowUpDate = moment(childscreening.childDischargeDate).add(12, 'days');
                                childscreening.maxFollowUpDate = moment(childscreening.childDischargeDate).add(28, 'days');
                            } else {
                                childscreening.followUpVisit = 2;
                                childscreening.minFollowUpDate = moment(childscreening.childDischargeDate).add(29, 'days');
                                childscreening.maxFollowUpDate = moment(childscreening.childDischargeDate).add(43, 'days');
                            }
                        } else {
                            childscreening.lastFollowUpVisitDate = response.followUpDate;
                            childscreening.lastFollowUpVisitDisplayDate = moment(response.followUpDate).format("DD-MM-YYYY");
                            childscreening.followUpVisitWeight = response.weight;
                            childscreening.followUpVisitHeight = response.height;
                            childscreening.followUpVisitMidUpperArmCircumference = response.midUpperArmCircumference;
                            if (response.followUpVisit === 1) {
                                if (diffInDischargeAndTodayDate < 44) {
                                    childscreening.followUpVisit = 2;
                                    childscreening.minFollowUpDate = moment(response.followUpDate).add(6, 'days');
                                    childscreening.maxFollowUpDate = moment(childscreening.childDischargeDate).add(43, 'days');
                                } else {
                                    childscreening.followUpVisit = 3;
                                    childscreening.minFollowUpDate = moment(childscreening.childDischargeDate).add(44, 'days');
                                    childscreening.maxFollowUpDate = moment(childscreening.childDischargeDate).add(59, 'days');
                                }
                            } else if (response.followUpVisit === 2) {
                                childscreening.followUpVisit = 3;
                                childscreening.minFollowUpDate = moment(response.followUpDate).add(6, 'days');
                                childscreening.maxFollowUpDate = moment(childscreening.childDischargeDate).add(59, 'days');
                            }
                        }
                        if (childscreening.maxFollowUpDate > moment()) {
                            childscreening.maxFollowUpDate = moment();
                        }
                    } else if (childscreening.isDischargeForm) {
                        childscreening.laboratoryList = response
                    }
                }
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
                $state.go('techo.manage.childscreeninglist')
            }).finally(() => {
                if (childscreening.currentChild != null) {
                    if (childscreening.matchedChildFlag) {
                        childscreening.currentChild.screenedOn = moment(childscreening.currentChild.screenedOn).format("DD/MM/YYYY");
                    } else {
                        childscreening.currentChild.screenedOn = "N/A";
                        childscreening.currentChild.referredBy = "N/A";
                    }
                    childscreening.currentChild.bpl = childscreening.currentChild.bpl ? "Yes" : "No";
                    childscreening.currentChild.age = parseInt(moment().diff(moment(childscreening.currentChild.dob), 'months', true));
                    childscreening.currentChild.ageInDays = parseInt(moment().diff(moment(childscreening.currentChild.dob), 'days', true));
                    childscreening.applyAgeFilters();
                    childscreening.currentChild.dob = moment(childscreening.currentChild.dob).format("DD-MM-YYYY");
                    childscreening.childScreeningObject = {};
                    childscreening.childScreeningObject.illness = [];
                    childscreening.childScreeningObject.typeOfAdmission = "--"
                    childscreening.childScreeningObject.dischargeStatus = "--";
                    childscreening.childScreeningObject.referredBy = "FHW";
                    Mask.hide();

                    
                    Mask.show()
                    AuthenticateService.getAssignedFeature("techo.manage.childscreeninglist").then(function (res) {
                        childscreening.rights = res.featureJson;
                        if (!childscreening.rights) {
                            childscreening.rights = {};
                        }
                    }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                        Mask.hide();
                    })
                } else {
                    Mask.hide();
                    $state.go('techo.manage.childscreeninglist');
                }
            });
        }

        childscreening.calculateDischargeStatus = () => {
            if (childscreening.isDischargeForm) {
                if (childscreening.childScreeningObject.midUpperArmCircumference != null) {
                    if (childscreening.childScreeningObject.midUpperArmCircumference < 11.5
                        || childscreening.childScreeningObject.sdScore === 'SD4'
                        || childscreening.childScreeningObject.sdScore === 'SD3') {
                        childscreening.childScreeningObject.dischargeStatus = "SAM_TO_SAM"
                    } else if ((childscreening.childScreeningObject.midUpperArmCircumference >= 11.5 && childscreening.childScreeningObject.midUpperArmCircumference < 12.5)
                        || childscreening.childScreeningObject.sdScore === 'SD2') {
                        childscreening.childScreeningObject.dischargeStatus = "SAM_TO_MAM";
                    } else if (childscreening.childScreeningObject.midUpperArmCircumference >= 12.5
                        || childscreening.childScreeningObject.sdScore === 'SD1'
                        || childscreening.childScreeningObject.sdScore === 'MEDIAN'
                        || childscreening.childScreeningObject.sdScore === 'NONE') {
                        childscreening.childScreeningObject.dischargeStatus = "SAM_TO_NORMAL";
                    }
                }
            }
        }

        childscreening.calculateGain = () => {
            childscreening.gain = ((childscreening.childScreeningObject.weightAtAdmission - childscreening.displayWeightAtAdmission) * 100 / childscreening.displayWeightAtAdmission).toFixed(2);
            childscreening.averageWeightGain = (((childscreening.childScreeningObject.weightAtAdmission - childscreening.displayWeightAtAdmission) / (childscreening.displayWeightAtAdmission * 15)) * 1000).toFixed(2);
        }

        childscreening.dateDiffInDays = (a, b) => {
            var utc1 = Date.UTC(a.getFullYear(), a.getMonth(), a.getDate());
            var utc2 = Date.UTC(b.getFullYear(), b.getMonth(), b.getDate());

            return Math.floor((utc2 - utc1) / childscreening.MS_PER_DAY);
        }

        childscreening.retrieveHospitalsByInstitutionType = () => {
            if (childscreening.childScreeningObject.institutionType != null && childscreening.childScreeningObject.institutionType != "") {
                childscreening.currentChild.minimumDischargeDate = moment(childscreening.currentChild.admissionDate);
                childscreening.showOtherInstitutes = false;
                Mask.show();
                QueryDAO.execute({
                    code: 'retrieve_hospitals_by_infra_type',
                    parameters: {
                        infraType: Number(childscreening.childScreeningObject.institutionType)
                    }
                }).then((res) => {
                    childscreening.showOtherInstitutes = true;
                    childscreening.otherInstitutes = res.result;
                    if (childscreening.below28Days) {
                        childscreening.otherInstitutes = childscreening.otherInstitutes.filter((institute) => {
                            return institute.is_sncu
                        });
                    } else if (childscreening.below6Months) {
                        childscreening.otherInstitutes = childscreening.otherInstitutes.filter((institute) => {
                            return institute.is_nrc
                        });
                    } else if (childscreening.above6Months) {
                        childscreening.otherInstitutes = childscreening.otherInstitutes.filter((institute) => {
                            return institute.is_cmtc || institute.is_nrc
                        });
                    }
                    childscreening.otherInstitutes = childscreening.otherInstitutes.filter((institute) => {
                        return institute.id != childscreening.currentChild.screeningCenter
                    });
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                })
            } else {
                childscreening.childScreeningObject.institutionType = null;
                childscreening.childScreeningObject.higherFacilityReferralPlace = null;
                childscreening.currentChild.minimumDischargeDate = moment(childscreening.currentChild.admissionDate).add(6, 'days');
                childscreening.childScreeningObject.dischargeDate = null;
            }
        }

        childscreening.saveDischargeDetails = () => {
            childscreening.childScreeningObject.state = 'DISCHARGE';
            childscreening.childScreeningObject.caseId = childscreening.childScreeningObject.screeningId;
            childscreening.checkIllness();
            Mask.show();
            ChildScreeningService.saveDischargeDetails(childscreening.childScreeningObject).then((response) => {
                let memberObj = {
                    memberId: childscreening.currentChild.childId,
                    mobileNumber: childscreening.currentChild.mobileNumber,
                    name: childscreening.currentChild.name,
                    preferredHealthId: childscreening.prefferedHealthId,
                    healthIdsData: childscreening.healthIdsData
                }
                $state.go('techo.manage.childscreeninglist');
                toaster.pop('success', 'Details saved successfully');
            }).catch((error) => {
                childscreening.childScreeningObject.illness = illness;
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally((response) => {
                Mask.hide();
            });
        }

        
        childscreening.applyAgeFilters = () => {
            if (childscreening.currentChild.ageInDays != null && childscreening.currentChild.ageInDays < 28) {
                childscreening.below28Days = true;
                childscreening.below6Months = true;
                childscreening.assignedCentersList = childscreening.assignedCentersList.filter((center) => {
                    return center.is_sncu
                });
                childscreening.screeningCentersList = childscreening.screeningCentersList.filter((center) => {
                    return center.is_sncu
                });
            } else if (childscreening.currentChild.ageInDays != null && childscreening.currentChild.ageInDays < 180 && childscreening.currentChild.ageInDays >= 28) {
                childscreening.below6Months = true
                childscreening.assignedCentersList = childscreening.assignedCentersList.filter((center) => {
                    return center.is_nrc
                });
                childscreening.screeningCentersList = childscreening.screeningCentersList.filter((center) => {
                    return center.is_nrc
                });
            } else if (childscreening.currentChild.ageInDays != null && childscreening.currentChild.ageInDays >= 180) {
                childscreening.above6Months = true
                childscreening.assignedCentersList = childscreening.assignedCentersList.filter((center) => {
                    return center.is_cmtc || center.is_nrc
                });
                childscreening.screeningCentersList = childscreening.screeningCentersList.filter((center) => {
                    return center.is_cmtc || center.is_nrc
                });
            }
            setTimeout(() => {
                $('#hospital').trigger("chosen:updated");
                $('#followUpHospital').trigger("chosen:updated");
            });
        }

        childscreening.checkIllness = () => {
            illness = childscreening.childScreeningObject.illness;
            if (childscreening.childScreeningObject.illness.includes('NONE')) {
                delete childscreening.childScreeningObject.illness;
            }
        }

        childscreening.breastFeedingChanged = () => {
            if (childscreening.childScreeningObject != null) {
                childscreening.childScreeningObject.problemInBreastFeeding = null;
                childscreening.childScreeningObject.milkInjectionProblem = null;
                childscreening.childScreeningObject.visibleWasting = null;
            }
        }

        childscreening.kmcProvidedChanged = () => {
            if (childscreening.childScreeningObject != null) {
                childscreening.childScreeningObject.noOfTimesKmcDone = null
            }
        }

        childscreening.followUpDateChanged = () => {
            childscreening.childScreeningObject.dischargeFromProgram = null;
        }

        childscreening.back = () => {
            window.history.back();
        }

        childscreening.init();
    }
    angular.module('imtecho.controllers').controller('ChildScreeningController', ChildScreeningController);
})();
