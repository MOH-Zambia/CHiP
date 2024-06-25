/* global moment */
(function () {
    function MedicinesController(ChildScreeningService, Mask, toaster, $state, QueryDAO, AuthenticateService, GeneralUtil, $q) {
        var ctrl = this;
        const FEATURE = 'techo.manage.childscreeninglist';
        const MEDICINES_FORM_CONFIGURATION_KEY = 'NUTRITION_DAILY_WEIGHT_MEDICINES_UPDATION';
        ctrl.formData = {};
        ctrl.today = moment().startOf('day');

        ctrl.init = () => {
            ctrl.weightList = [];
            ctrl.weightDates = [];
            Mask.show();
            QueryDAO.execute({
                code: 'child_cmtc_nrc_screening_details',
                parameters: {
                    childId: Number($state.params.id)
                }
            }).then((response) => {
                ctrl.currentChild = response.result[0];
                return ChildScreeningService.retrieveAdmissionDetailById(ctrl.currentChild.admissionId);
            }).then((response) => {
                if (response.apetiteTest === 'PASS') {
                    ctrl.formData.formulaGiven = "F100+RUTF";
                }
                ctrl.currentChild.admissionDate = moment(response.admissionDate);
                if (moment().diff(ctrl.currentChild.admissionDate, 'days') >= 21) {
                    ctrl.maxSubmissionDate = moment(ctrl.currentChild.admissionDate).add(20, 'days');
                } else {
                    ctrl.maxSubmissionDate = ctrl.today;
                }
                return ChildScreeningService.retrieveWeightList(ctrl.currentChild.admissionId);
            }).then((response) => {
                ctrl.weightList = response
                if (Array.isArray(ctrl.weightList) && ctrl.weightList.length) {
                    ctrl.weightDates = ctrl.weightList.map(weight => weight.weightDate);
                }
                let promiseList = [];
                promiseList.push(AuthenticateService.getLoggedInUser());
                promiseList.push(AuthenticateService.getAssignedFeature(FEATURE));
                return $q.all(promiseList);
            }).then((response) => {
                ctrl.loggedInUser = response[0].data;
                ctrl.formConfigurations = response[1].systemConstraintConfigs[MEDICINES_FORM_CONFIGURATION_KEY];
                ctrl.webTemplateConfigs = response[1].webTemplateConfigs[MEDICINES_FORM_CONFIGURATION_KEY];
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
                $state.go('techo.manage.childscreeninglist')
            }).finally(() => {
                if (ctrl.currentChild) {
                    ctrl.currentChild.age = parseInt(moment().diff(moment(ctrl.currentChild.dob), 'months', true));
                    ctrl.currentChild.ageInDays = parseInt(moment(ctrl.currentChild.admissionDate).diff(moment(ctrl.currentChild.dob), 'days', true));
                    ctrl.applyAgeFilters();
                    if (ctrl.currentChild.immunisationGiven && ctrl.currentChild.immunisationGiven.includes("VITAMIN_A")) {
                        ctrl.currentChild.vitaminAGivenDate = moment(ctrl.currentChild.immunisationGiven.split("VITAMIN_A#")[1].substr(0, 10), "DD/MM/YYYY").valueOf();
                    }
                    ctrl.currentChild.childDetails = `${moment(ctrl.currentChild.dob).format("DD-MM-YYYY")} / ${ctrl.currentChild.age} months / ${ctrl.currentChild.gender}`;
                    Mask.hide();
                } else {
                    Mask.hide();
                    $state.go('techo.manage.childscreeninglist')
                }
            });
        }

        ctrl.applyAgeFilters = () => {
            if (ctrl.currentChild.ageInDays < 28) {
                ctrl.below28Days = true;
                ctrl.below2Months = true;
                ctrl.below6Months = true;
                ctrl.above6Months = false;
            } else if (ctrl.currentChild.ageInDays < 60) {
                ctrl.below28Days = false;
                ctrl.below2Months = true;
                ctrl.below6Months = true;
                ctrl.above6Months = false;
            } else if (ctrl.currentChild.ageInDays < 180) {
                ctrl.below28Days = false;
                ctrl.below2Months = false;
                ctrl.below6Months = true;
                ctrl.above6Months = false;
            } else {
                ctrl.below28Days = false;
                ctrl.below2Months = false;
                ctrl.below6Months = false;
                ctrl.above6Months = true;
            }
        }

        ctrl.weightDateChanged = () => {
            let submissionDate = moment(ctrl.formData.weightDate).format("YYYY-MM-DD");
            if (Array.isArray(ctrl.weightDates) && ctrl.weightDates.length && ctrl.weightDates.includes(submissionDate)) {
                toaster.pop('error', 'Weight has already been submitted for this date');
            } else {
                ctrl.diffBetweenAdmissionDateAndWeightDate = moment(ctrl.formData.weightDate).diff(moment(ctrl.currentChild.admissionDate), 'days');
                ctrl.vitaminAAlreadyGiven = ctrl.currentChild.vitaminAGivenDate && moment(ctrl.formData.weightDate).diff(ctrl.currentChild.vitaminAGivenDate, 'days') <= 120
            }
            Object.assign(ctrl.formData, {
                ...ctrl.formData,
                weight: null,
                bilateralPittingOedema: null,
                midUpperArmCircumference: null,
                isMotherCouncelling: null,
                nightStay: null,
                kmcProvided: null,
                noOfTimesKmcDone: null,
                institutionType: null,
                higherFacilityReferralPlace: null,
                referralReason: null,
                isAmoxicillin: null,
                otherHigherNutrientsGiven: null,
                isVitaminA: null,
                isSugarSolution: null,
                isAlbendazole: null,
                isFolicAcid: null,
                isMagnesium: null,
                isZinc: null,
                multiVitaminSyrup: null,
                isIron: null
            });
        }

        ctrl.retrieveHospitalsByInstitutionType = () => {
            ctrl.formData.higherFacilityReferralPlaceList.data = [];
            ctrl.formData.higherFacilityReferralPlace = null;
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
                        ctrl.formData.higherFacilityReferralPlaceList.data = ctrl.transformArrayToKeyValue(response.result.filter((institute) => institute.is_nrc || institute.is_cmtc), 'id', 'name');
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
            })
        }

        ctrl.amoxicillinGivenChanged = () => ctrl.formData.otherHigherNutrientsGiven = null;

        ctrl.formulaGivenChanged = () => {
            ctrl.formData.isPotassium = null;
            ctrl.formData.isMagnesium = null;
            ctrl.formData.isZinc = null;
            ctrl.formData.multiVitaminSyrup = null;
            ctrl.formData.isIron = null;
        }

        ctrl.saveMedicines = () => {
            if (ctrl.medicinesForm.$valid) {
                if (ctrl.higherFacilityHospitalError) {
                    toaster.pop('error', 'Higher Facility Referral Hospital is not selected');
                } else {
                    ctrl.formData.admissionId = ctrl.currentChild.admissionId;
                    Mask.show();
                    ChildScreeningService.saveMedicines(ctrl.formData).then((response) => {
                        toaster.pop('success', 'Details saved successfully');
                        $state.go("techo.manage.childscreeninglist");
                    }).catch((error) => {
                        GeneralUtil.showMessageOnApiCallFailure(error);
                    }).finally(() => {
                        Mask.hide();
                    });
                }
            }
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
    angular.module('imtecho.controllers').controller('MedicinesController', MedicinesController);
})();
