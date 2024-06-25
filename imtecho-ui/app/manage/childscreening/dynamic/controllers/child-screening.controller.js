(function () {
    function ChildScreeningController(ChildScreeningService, Mask, $state, toaster, AuthenticateService, QueryDAO, GeneralUtil, $uibModal, $filter, $q) {
        let ctrl = this;
        ctrl.env = GeneralUtil.getEnv();
        const FEATURE = 'techo.manage.childscreeninglist';
        const NUTRITION_ADM_DIS_FOLL_FORM_CONFIGURATION_KEY = 'NUTRITION_ADM_DIS_FOLL';
        ctrl.formData = {};
        ctrl.weightList = [];
        ctrl.laboratoryList = [];
        ctrl.formData.illness = [];
        ctrl.today = moment().startOf('day');
        ctrl.minAdmissionDate = moment().subtract(3, 'days');
        $(".modal-backdrop").remove();
        $("body").removeClass("modal-open");

        ctrl.init = () => {
            ctrl.setForm();
            let diffInDischargeAndTodayDate = 0;
            let promiseList = [];
            promiseList.push(AuthenticateService.getLoggedInUser());
            promiseList.push(AuthenticateService.getAssignedFeature("techo.manage.childscreeninglist"));
            Mask.show();
            $q.all(promiseList).then((response) => {
                console.log(response);
                ctrl.loggedInUserId = response[0].data.id;
                ctrl.currentUser = response[0].data;
                
                if (!!response[1]) {
                    ctrl.rights = response[1].featureJson;
                    ctrl.rights.canAdd ? ctrl.canAdd = true : ctrl.canAdd = false;
                }

                return QueryDAO.executeAll([{
                    code: 'retrieve_screening_centers_cmtc',
                    parameters: {
                        userId: ctrl.loggedInUserId
                    },
                    sequence: 1
                }, {
                    code: 'retrieve_cmtc_centers_by_user_assigned_location',
                    parameters: {
                        userId: ctrl.loggedInUserId
                    },
                    sequence: 2
                }]);
            }).then((response) => {
                ctrl.assignedCentersList = response[0].result;
                ctrl.followUpCentersList = response[1].result;
                return QueryDAO.execute({
                    code: 'child_cmtc_nrc_screening_details',
                    parameters: {
                        childId: Number($state.params.id)
                    }
                });
            }).then((response) => {
                if (response.result.length === 1) {
                    ctrl.matchedChildFlag = true;
                    ctrl.currentChild = response.result[0];
                    return Promise.resolve();
                } else {
                    ctrl.matchedChildFlag = false;
                    return QueryDAO.execute({
                        code: 'child_cmtc_nrc_screening_details_for_direct_admission',
                        parameters: {
                            childId: Number($state.params.id)
                        }
                    });
                }
            }).then((response) => {
                if (!ctrl.matchedChildFlag && response != null && response.result.length === 1) {
                    ctrl.currentChild = response.result[0];
                    return Promise.resolve();
                } else if (ctrl.matchedChildFlag && ctrl.currentChild.admissionId != null) {
                    return ChildScreeningService.retrieveAdmissionDetailById(ctrl.currentChild.admissionId);
                } else if (!ctrl.matchedChildFlag && response != null && response.result.length === 0) {
                    return Promise.reject();
                } else {
                    return Promise.resolve();
                }
            }).then((response) => {
                if (response != null) {
                    Object.assign(ctrl.currentChild, {
                        ...ctrl.currentChild,
                        admissionDate: response.admissionDate,
                        noOfTimesAmoxicillinGiven: response.noOfTimesAmoxicillinGiven,
                        consecutive3DaysWeightGain: response.consecutive3DaysWeightGain,
                        weightAtAdmission: response.weightAtAdmission
                    });
                    ctrl.minimumDischargeDate = moment(ctrl.currentChild.admissionDate).add(6, 'days');
                }
                if (ctrl.isFollowUpForm) {
                    return ChildScreeningService.getDischargeDetails(ctrl.currentChild.dischargeId);
                } else if (ctrl.isDischargeForm) {
                    return ChildScreeningService.retrieveWeightList(ctrl.currentChild.admissionId);
                } else {
                    return Promise.resolve();
                }
            }).then((response) => {
                if (response != null) {
                    if (ctrl.isFollowUpForm) {
                        ctrl.dischargeDetails = response;
                        ctrl.currentChild.dischargeDate = response.dischargeDate;
                        diffInDischargeAndTodayDate = moment().diff(moment(response.dischargeDate), 'days');
                        return ChildScreeningService.getLastFollowUpVisit($state.params.id, ctrl.currentChild.admissionId)
                    } else if (ctrl.isDischargeForm) {
                        ctrl.weightList = response;
                        return ChildScreeningService.retrieveLaboratoryList(ctrl.currentChild.admissionId);
                    }
                } else {
                    return Promise.resolve();
                }
            }).then((response) => {
                if (response != null) {
                    if (ctrl.isFollowUpForm) {
                        if (response.followUpVisit == null) {
                            if (diffInDischargeAndTodayDate < 29) {
                                ctrl.formData.followUpVisit = 1;
                                ctrl.minFollowUpDate = moment(ctrl.currentChild.dischargeDate).add(12, 'days');
                                ctrl.maxFollowUpDate = moment(ctrl.currentChild.dischargeDate).add(28, 'days');
                            } else {
                                ctrl.formData.followUpVisit = 2;
                                ctrl.minFollowUpDate = moment(ctrl.currentChild.dischargeDate).add(29, 'days');
                                ctrl.maxFollowUpDate = moment(ctrl.currentChild.dischargeDate).add(43, 'days');
                            }
                        } else {
                            ctrl.currentChild.lastFollowUpVisitDate = response.followUpDate;
                            if (response.followUpVisit === 1) {
                                if (diffInDischargeAndTodayDate < 44) {
                                    ctrl.formData.followUpVisit = 2;
                                    ctrl.minFollowUpDate = moment(response.followUpDate).add(6, 'days');
                                    ctrl.maxFollowUpDate = moment(ctrl.currentChild.dischargeDate).add(43, 'days');
                                } else {
                                    ctrl.formData.followUpVisit = 3;
                                    ctrl.minFollowUpDate = moment(ctrl.currentChild.dischargeDate).add(44, 'days');
                                    ctrl.maxFollowUpDate = moment(ctrl.currentChild.dischargeDate).add(59, 'days');
                                }
                            } else if (response.followUpVisit === 2) {
                                ctrl.formData.followUpVisit = 3;
                                ctrl.minFollowUpDate = moment(response.followUpDate).add(6, 'days');
                                ctrl.maxFollowUpDate = moment(ctrl.currentChild.dischargeDate).add(59, 'days');
                            }
                        }
                        if (ctrl.maxFollowUpDate > moment()) {
                            ctrl.maxFollowUpDate = moment();
                        }
                    } else if (ctrl.isDischargeForm) {
                        ctrl.laboratoryList = response
                    }
                }
                return AuthenticateService.getAssignedFeature(FEATURE);
            }).then((response) => {
                ctrl.formConfigurations = response.systemConstraintConfigs[NUTRITION_ADM_DIS_FOLL_FORM_CONFIGURATION_KEY];
                ctrl.webTemplateConfigs = response.webTemplateConfigs[NUTRITION_ADM_DIS_FOLL_FORM_CONFIGURATION_KEY];
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
                $state.go('techo.manage.childscreeninglist')
            }).finally(() => {
                if (ctrl.currentChild) {
                    ctrl.currentChild.age = parseInt(moment().diff(moment(ctrl.currentChild.dob), 'months', true));
                    ctrl.currentChild.ageInDays = parseInt(moment().diff(moment(ctrl.currentChild.dob), 'days', true));
                    ctrl.applyAgeFilters();
                    ctrl.currentChild.childDetails = `${moment(ctrl.currentChild.dob).format("DD-MM-YYYY")} / ${ctrl.currentChild.age} months / ${ctrl.currentChild.gender}`;
                    ctrl.formData.dischargeStatus = "--";
                    ctrl.formData.sdScore = "--";
                    Mask.hide();
                } else {
                    Mask.hide();
                    $state.go('techo.manage.childscreeninglist');
                }
            });
        }

        ctrl.setForm = () => {
            if ($state.params.action == 'admission') {
                ctrl.isAdmissionForm = true;
                ctrl.formTitle = 'CHILD ADMISSION';
                $state.current.title = 'Child Screening Admission'
            } else if ($state.params.action == 'discharge') {
                ctrl.isDischargeForm = true;
                ctrl.formTitle = 'CHILD DISCHARGE';
                $state.current.title = 'Child Discharge'
            } else if ($state.params.action == 'followup') {
                ctrl.isFollowUpForm = true;
                ctrl.formTitle = 'FOLLOW-UP VISIT';
                $state.current.title = 'Follow Up Visit'
            }
        }

        ctrl.applyAgeFilters = () => {
            if (ctrl.currentChild.ageInDays !== null && ctrl.currentChild.ageInDays < 28) {
                ctrl.below28Days = true;
                ctrl.below6Months = true;
                ctrl.above6Months = false;
                ctrl.filteredAssignedCentersList = ctrl.assignedCentersList.filter((center) => {
                    return center.is_sncu
                });
                ctrl.filteredFollowUpCentersList = ctrl.followUpCentersList.filter((center) => {
                    return center.is_sncu
                });
            } else if (ctrl.currentChild.ageInDays !== null && ctrl.currentChild.ageInDays < 180) {
                ctrl.below28Days = false;
                ctrl.below6Months = true;
                ctrl.above6Months = false;
                ctrl.filteredAssignedCentersList = ctrl.assignedCentersList.filter((center) => {
                    return center.is_nrc
                });
                ctrl.filteredFollowUpCentersList = ctrl.followUpCentersList.filter((center) => {
                    return center.is_nrc
                });
            } else if (ctrl.currentChild.ageInDays !== null && ctrl.currentChild.ageInDays >= 180) {
                ctrl.below28Days = false;
                ctrl.below6Months = false;
                ctrl.above6Months = true;
                ctrl.filteredAssignedCentersList = ctrl.assignedCentersList.filter((center) => {
                    return center.is_cmtc || center.is_nrc
                });
                ctrl.filteredFollowUpCentersList = ctrl.followUpCentersList.filter((center) => {
                    return center.is_cmtc || center.is_nrc
                });
            }
        }

        ctrl.onAllComponentsLoaded = () => {
            if (Array.isArray(ctrl.filteredAssignedCentersList) && ctrl.filteredAssignedCentersList.length && 'screeningCenterList' in ctrl.formData) {
                ctrl.formData.screeningCenterList.data = ctrl.transformArrayToKeyValue(ctrl.filteredAssignedCentersList, 'id', 'name');
            }
            if (Array.isArray(ctrl.filteredFollowUpCentersList) && ctrl.filteredFollowUpCentersList.length && 'followupOtherCenterList' in ctrl.formData) {
                ctrl.formData.followupOtherCenterList.data = ctrl.transformArrayToKeyValue(ctrl.filteredFollowUpCentersList, 'id', 'name');
            }
        }

        ctrl.checkAdmissionIndicator = () => {
            Mask.show();
            ChildScreeningService.checkAdmissionIndicator($state.params.id, moment(ctrl.formData.admissionDate).format("DD/MM/YYYY")).then((response) => {
                ctrl.formData.typeOfAdmission = response.admissionType;
                ctrl.isTypeOfAdmission = true;
            }).catch((error) => {
                ctrl.isTypeOfAdmission = false;
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        ctrl.calculateSdScore = () => {
            if (ctrl.currentChild.gender && ctrl.formData.height && ctrl.formData.weightAtAdmission) {
                Mask.show();
                ChildScreeningService.retrieveSdScore(ctrl.currentChild.gender, ctrl.formData.height, ctrl.formData.weightAtAdmission).then((response) => {
                    switch (response.sdScore) {
                        case 'SD4':
                            ctrl.formData.sdScore = "SD4";
                            break;
                        case 'SD3':
                            ctrl.formData.sdScore = "SD3";
                            break;
                        case 'SD2':
                            ctrl.formData.sdScore = "SD2";
                            break;
                        case 'SD1':
                            ctrl.formData.sdScore = "SD1";
                            break;
                        case 'MEDIAN':
                            ctrl.formData.sdScore = "MEDIAN";
                            break;
                        default:
                            ctrl.formData.sdScore = "NONE";
                            break;
                    }
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                });
            } else if (!ctrl.currentChild.gender) {
                toaster.pop('error', 'Could not calculate SD Score. Gender not found');
            }
            ctrl.showWasting = ctrl.below6Months && ctrl.formData.height && ctrl.formData.height < 45;
            ctrl.formData.visibleWasting = null;
        }

        ctrl.determineChildState = () => {
            let screeningObj = {
                belowSixMonths: ctrl.below6Months,
                apetiteTest: ctrl.formData.apetiteTest === 'PASS' ? true : false,
                bilateralPittingOedema: ctrl.formData.bilateralPittingOedema,
                medicalComplicationsPresent: !!ctrl.formData.illness && ctrl.formData.illness.length === 0 ? false : true,
                midUpperArmCircumference: ctrl.formData.midUpperArmCircumference,
                sdScore: ctrl.formData.sdScore,
                breastSuckingProblems: ctrl.formData.problemInBreastFeeding
            }
            let childState = GeneralUtil.getChildState(screeningObj);
            if (childState === 'NORMAL') {
                childState = 'NOTSAM';
            }
            return childState;
        }

        ctrl.calculateGain = () => {
            if (ctrl.formData.weightAtAdmission && ctrl.currentChild.weightAtAdmission) {
                ctrl.formData.gain = `${((ctrl.formData.weightAtAdmission - ctrl.currentChild.weightAtAdmission) * 100 / ctrl.currentChild.weightAtAdmission).toFixed(2)}%`;
                ctrl.formData.averageWeightGain = (((ctrl.formData.weightAtAdmission - ctrl.currentChild.weightAtAdmission) / (ctrl.currentChild.weightAtAdmission * 15)) * 1000).toFixed(2);
                ctrl.calculateDischargeStatus();
            }
        }

        ctrl.calculateDischargeStatus = () => {
            if (ctrl.isDischargeForm) {
                if (ctrl.formData.midUpperArmCircumference < 11.5 || ctrl.formData.sdScore === 'SD4' || ctrl.formData.sdScore === 'SD3') {
                    ctrl.formData.dischargeStatus = "SAM_TO_SAM";
                } else if (ctrl.formData.midUpperArmCircumference < 12.5 || ctrl.formData.sdScore === 'SD2') {
                    ctrl.formData.dischargeStatus = "SAM_TO_MAM";
                } else if (ctrl.formData.midUpperArmCircumference >= 12.5 || ctrl.formData.sdScore === 'SD1' || ctrl.formData.sdScore === 'MEDIAN' || ctrl.formData.sdScore === 'NONE') {
                    ctrl.formData.dischargeStatus = "SAM_TO_NORMAL";
                }
            }
        }

        ctrl.followUpAtOtherCenterChanged = () => {
            ctrl.formData.followupOtherCenter = null;
        }

        ctrl.followUpDateChanged = () => {
            ctrl.formData.dischargeFromProgram = null;
        }

        ctrl.kmcProvidedChanged = () => {
            ctrl.formData.noOfTimesKmcDone = null
        }

        ctrl.retrieveHospitalsByInstitutionType = () => {
            ctrl.formData.higherFacilityReferralPlaceList.data = [];
            ctrl.formData.higherFacilityReferralPlace = null;
            ctrl.minimumDischargeDate = moment(ctrl.currentChild.admissionDate);
            Mask.show();
            QueryDAO.execute({
                code: 'retrieve_hospitals_by_infra_type',
                parameters: {
                    infraType: Number(ctrl.formData.institutionType)
                }
            }).then((response) => {
                if (Array.isArray(response.result) && response.result.length) {
                    ctrl.higherFacilityHospitalError = false;
                    response.result = response.result.filter((institute) => institute.id != ctrl.currentChild.screeningCenter);
                    if (ctrl.below28Days) {
                        ctrl.formData.higherFacilityReferralPlaceList.data = ctrl.transformArrayToKeyValue(response.result.filter((institute) => institute.is_sncu), 'id', 'name');
                    } else if (ctrl.below6Months) {
                        ctrl.formData.higherFacilityReferralPlaceList.data = ctrl.transformArrayToKeyValue(response.result.filter((institute) => institute.is_nrc), 'id', 'name');
                    } else if (ctrl.above6Months) {
                        ctrl.formData.higherFacilityReferralPlaceList.data = ctrl.transformArrayToKeyValue(response.result.filter((institute) => institute.is_cmtc || institute.is_nrc), 'id', 'name');
                    }
                    if (ctrl.formData.higherFacilityReferralPlaceList.data.length === 0) {
                        toaster.pop('error', 'Could not find any hospital under this type');
                        ctrl.higherFacilityHospitalError = true;
                    } else {
                        ctrl.higherFacilityHospitalError = false;
                    }
                } else {
                    toaster.pop('error', 'Could not find any hospital under this type');
                    ctrl.higherFacilityHospitalError = true;
                }
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        ctrl.saveForm = () => {
            if (ctrl.childScreeningForm.$valid) {
                ctrl.formData.screeningId = ctrl.currentChild.screeningId;
                ctrl.formData.childId = $state.params.id;
                ctrl.formData.referredBy = ctrl.loggedInUserId;
                if (ctrl.isDischargeForm) {
                    if (ctrl.formData.bilateralPittingOedema !== 'NOTPRESENT') {
                        toaster.pop('error', "Edema is not cured");
                    } else if (Array.isArray(ctrl.formData.illness) && ctrl.formData.illness.length) {
                        toaster.pop('error', "Child cannot be discharged if any illness is present");
                    } else if (ctrl.currentChild.noOfTimesAmoxicillinGiven < 5) {
                        toaster.pop('error', "Amoxicillin is not given for atleast 5 days");
                    } else if (ctrl.higherFacilityHospitalError) {
                        toaster.pop('error', 'Higher Facility Referral Hospital is not selected');
                    } else if (!ctrl.currentChild.consecutive3DaysWeightGain) {
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
                            ctrl.saveDischargeDetails();
                        });
                    } else {
                        ctrl.saveDischargeDetails();
                    }
                } else if (ctrl.isAdmissionForm) {
                    if (ctrl.isAdmissionValid()) {
                        if (ctrl.formData.admissionDate < moment().startOf('day')) {
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
                                ctrl.saveAdmissionDetails();
                            }, () => {
                            });
                        } else {
                            ctrl.saveAdmissionDetails();
                        }
                    }
                } else if (ctrl.isFollowUpForm) {
                    ctrl.formData.admissionId = ctrl.currentChild.admissionId;
                    ctrl.formData.weight = ctrl.formData.weightAtAdmission;
                    ctrl.formData.caseId = ctrl.formData.screeningId;
                    Mask.show();
                    ChildScreeningService.saveFollowUp(ctrl.formData).then(() => {
                        toaster.pop('success', 'Details saved successfully');
                        $state.go('techo.manage.childscreeninglist');
                    }).catch((error) => {
                        GeneralUtil.showMessageOnApiCallFailure(error);
                    }).finally(() => {
                        Mask.hide();
                    });
                }
            }
        }

        ctrl.isAdmissionValid = () => {
            ctrl.childState = ctrl.determineChildState(); 
            if (!ctrl.isTypeOfAdmission) {
                toaster.pop('error', 'Type of Admission could not be identified');
                return false;
            } else if ((ctrl.env !== 'dnhdd' &&
                (ctrl.formData.midUpperArmCircumference != null
                && ctrl.formData.midUpperArmCircumference > 11.5
                && ctrl.formData.sdScore !== 'SD3' && ctrl.formData.sdScore !== 'SD4'
                && ctrl.formData.bilateralPittingOedema === 'NOTPRESENT')) ||
                (ctrl.env === 'dnhdd' && (ctrl.childState === 'NOTSAM' || ctrl.childState === 'MAM'))) {
                let modalInstance = $uibModal.open({
                    templateUrl: 'app/common/views/alert.modal.html',
                    controller: 'alertModalController',
                    windowClass: 'cst-modal',
                    title: '',
                    size: 'med',
                    resolve: {
                        message: () => {
                            return 'As per the details filled, the child is not identified as SAM. The admission will be discarded and the child will be removed from screening list if exists. Are you sure you want to proceed?';
                        }
                    }
                });
                modalInstance.result.then(() => {
                    if (ctrl.env !== 'dnhdd') {
                        Mask.show();
                        ChildScreeningService.deleteChildScreeningByChildId($state.params.id).then(() => {
                            toaster.pop('error', 'Admission discarded successfully');
                            $state.go('techo.manage.childscreeninglist');
                        }).catch((error) => {
                            GeneralUtil.showMessageOnApiCallFailure(error);
                        }).finally(() => {
                            Mask.hide();
                        });
                    } else if (ctrl.env === 'dnhdd' && ctrl.childState === 'MAM') {
                        Mask.show();
                        ChildScreeningService.updateScreeningState(ctrl.formData.screeningId, ctrl.childState, moment(ctrl.formData.admissionDate).format("DD-MM-YYYY")).then(() => {
                            toaster.pop('error', 'Admission discarded successfully');
                            $state.go('techo.manage.childscreeninglist');
                        }).catch((error) => {
                            GeneralUtil.showMessageOnApiCallFailure(error);
                        }).finally(() => {
                            Mask.hide();
                        });
                    } else if (ctrl.env === 'dnhdd' && ctrl.childState === 'NOTSAM') {
                        Mask.show();
                        ChildScreeningService.updateScreeningState(ctrl.formData.screeningId, ctrl.childState, moment(ctrl.formData.admissionDate).format("DD-MM-YYYY")).then(() => {
                            toaster.pop('error', 'Admission discarded successfully');
                            $state.go('techo.manage.childscreeninglist');
                        }).catch((error) => {
                            GeneralUtil.showMessageOnApiCallFailure(error);
                        }).finally(() => {
                            Mask.hide();
                        });
                    }
                }, () => {
                });
                return false;
            } else {
                return true;
            }
        }

        ctrl.saveAdmissionDetails = () => {
            if (!ctrl.matchedChildFlag) {
                ctrl.formData.isDirectAdmission = true;
                ctrl.formData.locationId = ctrl.currentChild.locationId;
            } else {
                ctrl.formData.caseId = ctrl.formData.screeningId;
            }
            ctrl.formData.state = 'ACTIVE';
            Mask.show();
            ChildScreeningService.create(ctrl.formData).then(() => {
                toaster.pop('success', 'Details saved successfully');
                $state.go('techo.manage.childscreeninglist');
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        ctrl.saveDischargeDetails = () => {
            ctrl.formData.admissionId = ctrl.currentChild.admissionId;
            ctrl.formData.weight = ctrl.formData.weightAtAdmission;
            ctrl.formData.state = 'DISCHARGE';
            ctrl.formData.caseId = ctrl.formData.screeningId;
            ctrl.calculateDischargeStatus();
            
            Mask.show();
            ChildScreeningService.saveDischargeDetails(ctrl.formData).then(() => {
                let memberObj = {
                    memberId: ctrl.currentChild.childId,
                    mobileNumber: ctrl.currentChild.mobileNumber,
                    name: ctrl.currentChild.childName
                }
                toaster.pop('success', 'Details saved successfully');
                $state.go('techo.manage.childscreeninglist');
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        ctrl.transformArrayToKeyValue = (array, keyProperty, valueProperty) => {
            return array.map((element) => {
                return {
                    key: element[keyProperty],
                    value: element[valueProperty]
                }
            });
        }

        ctrl.goBack = () => $state.go("techo.manage.childscreeninglist");

        ctrl.init();
    }
    angular.module('imtecho.controllers').controller('ChildScreeningController', ChildScreeningController);
})();
