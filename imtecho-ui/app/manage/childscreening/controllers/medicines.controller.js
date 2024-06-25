/* global moment */
(function () {
    function MedicinesController(ChildScreeningService, Mask, toaster, $state, QueryDAO, AuthenticateService, GeneralUtil) {
        var medicinescontroller = this;
        medicinescontroller.todayDate = new Date();
        medicinescontroller.MS_PER_DAY = 1000 * 60 * 60 * 24;

        medicinescontroller.saveForm = () => {
            if (medicinescontroller.medicinesForm.$valid) {
                medicinescontroller.childScreeningObject.admissionId = medicinescontroller.currentChild.admissionId;
                Mask.show();
                ChildScreeningService.saveMedicines(medicinescontroller.childScreeningObject).then((response) => {
                    toaster.pop('success', 'Details saved successfully');
                    $state.go("techo.manage.childscreeninglist");
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                });
            }
        }

        medicinescontroller.init = () => {
            medicinescontroller.childScreeningObject = {};
            medicinescontroller.weightList = [];
            medicinescontroller.weightDates = [];
            Mask.show();
            AuthenticateService.getLoggedInUser().then((user) => {
                medicinescontroller.loggedInUser = user.data;
                return QueryDAO.execute({
                    code: 'fetch_listvalue_detail_from_field',
                    parameters: {
                        field: 'Health Infrastructure Type'
                    }
                });
            }).then((response) => {
                medicinescontroller.institutionTypes = response.result;
                return QueryDAO.execute({
                    code: 'child_cmtc_nrc_screening_details',
                    parameters: {
                        childId: Number($state.params.id)
                    }
                });
            }).then((response) => {
                if (response.result.length === 1) {
                    medicinescontroller.currentChild = response.result[0];
                    return ChildScreeningService.retrieveAdmissionDetailById(medicinescontroller.currentChild.admissionId);
                } else {
                    Promise.reject();
                }
            }).then((response) => {
                if (response != null) {
                    if (response.apetiteTest != null && response.apetiteTest === 'PASS') {
                        medicinescontroller.childScreeningObject.formulaGiven = "F100+RUTF";
                    }
                    medicinescontroller.currentChild.admissionDate = new Date(response.admissionDate);
                    medicinescontroller.diffBetweenAdmissionDateAndTodayDate = medicinescontroller.dateDiffInDays(medicinescontroller.currentChild.admissionDate, medicinescontroller.todayDate);
                    if (medicinescontroller.diffBetweenAdmissionDateAndTodayDate >= 21) {
                        medicinescontroller.maxSubmissionDate = moment(medicinescontroller.currentChild.admissionDate).add(20, 'days');
                    } else {
                        medicinescontroller.maxSubmissionDate = medicinescontroller.todayDate;
                    }
                    return ChildScreeningService.retrieveWeightList(medicinescontroller.currentChild.admissionId);
                } else {
                    Promise.reject();
                }
            }).then((response) => {
                if (response != null) {
                    medicinescontroller.weightList = response
                    if (medicinescontroller.weightList.length > 0) {
                        medicinescontroller.weightDates = medicinescontroller.weightList.map(weight => weight.weightDate);
                    }
                }
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
                $state.go('techo.manage.childscreeninglist')
            }).finally(() => {
                if (medicinescontroller.currentChild != null) {
                    medicinescontroller.currentChild.screenedOn = moment(medicinescontroller.currentChild.screenedOn).format("DD/MM/YYYY");
                    medicinescontroller.currentChild.bpl = medicinescontroller.currentChild.bpl ? "Yes" : "No";
                    medicinescontroller.currentChild.age = parseInt(moment().diff(moment(medicinescontroller.currentChild.dob), 'months', true));
                    medicinescontroller.currentChild.ageInDays = parseInt(moment().diff(moment(medicinescontroller.currentChild.dob), 'days', true));
                    medicinescontroller.applyAgeFilters();
                    medicinescontroller.currentChild.dob = moment(medicinescontroller.currentChild.dob).format("DD-MM-YYYY");
                    if (medicinescontroller.currentChild.immunisationGiven != null && medicinescontroller.currentChild.immunisationGiven.includes("VITAMIN_A")) {
                        medicinescontroller.currentChild.vitaminADisplayDate = moment(medicinescontroller.currentChild.immunisationGiven.split("VITAMIN_A#")[1].substr(0, 10), "DD/MM/YYYY").format("DD-MM-YYYY");
                        medicinescontroller.currentChild.vitaminAGivenDate = moment(medicinescontroller.currentChild.immunisationGiven.split("VITAMIN_A#")[1].substr(0, 10), "DD/MM/YYYY");
                    } else {
                        medicinescontroller.currentChild.vitaminADisplayDate = "--"
                    }
                    Mask.hide();
                } else {
                    Mask.hide();
                    $state.go('techo.manage.childscreeninglist')
                }
            });
        }

        medicinescontroller.calculateDays = () => {
            var submissionDate = moment(medicinescontroller.childScreeningObject.weightDate).format("YYYY-MM-DD");
            if (medicinescontroller.weightDates && medicinescontroller.weightDates.includes(submissionDate)) {
                toaster.pop('error', 'Weight has already been submitted for this date');
            } else {
                medicinescontroller.diffBetweenAdmissionDateAndWeightDate = medicinescontroller.dateDiffInDays(medicinescontroller.currentChild.admissionDate, medicinescontroller.childScreeningObject.weightDate);
                medicinescontroller.childScreeningObject.isVitaminA = "";
                medicinescontroller.childScreeningObject.isAlbendazole = "";
                medicinescontroller.childScreeningObject.isIron = "";
            }
            if (medicinescontroller.currentChild.vitaminAGivenDate != null) {
                if (moment(medicinescontroller.childScreeningObject.weightDate).diff(medicinescontroller.currentChild.vitaminAGivenDate, 'days') <= 120) {
                    medicinescontroller.vitaminAAlreadyGiven = true;
                }
            }
            if (moment(medicinescontroller.childScreeningObject.weightDate).diff(medicinescontroller.currentChild.dob, 'days') <= 60) {
                medicinescontroller.below2Months = true
            } else {
                medicinescontroller.below2Months = false
            }
        }

        medicinescontroller.dateDiffInDays = function (a, b) {
            var utc1 = Date.UTC(a.getFullYear(), a.getMonth(), a.getDate());
            var utc2 = Date.UTC(b.getFullYear(), b.getMonth(), b.getDate());

            return Math.floor((utc2 - utc1) / medicinescontroller.MS_PER_DAY);
        }

        medicinescontroller.back = () => {
            window.history.back();
        }

        medicinescontroller.retrieveHospitalsByInstitutionType = () => {
            if (medicinescontroller.childScreeningObject.institutionType != null && medicinescontroller.childScreeningObject.institutionType != "") {
                medicinescontroller.showOtherInstitutes = false;
                Mask.show();
                QueryDAO.execute({
                    code: 'retrieve_hospitals_by_infra_type',
                    parameters: {
                        infraType: Number(medicinescontroller.childScreeningObject.institutionType)
                    }
                }).then((response) => {
                    medicinescontroller.showOtherInstitutes = true;
                    medicinescontroller.otherInstitutes = response.result;
                    if (medicinescontroller.below28Days) {
                        medicinescontroller.otherInstitutes = medicinescontroller.otherInstitutes.filter((institute) => {
                            return institute.is_sncu
                        });
                    } else if (medicinescontroller.below6Months) {
                        medicinescontroller.otherInstitutes = medicinescontroller.otherInstitutes.filter((institute) => {
                            return institute.is_nrc
                        });
                    } else if (medicinescontroller.above6Months) {
                        medicinescontroller.otherInstitutes = medicinescontroller.otherInstitutes.filter((institute) => {
                            return institute.is_cmtc || institute.is_nrc
                        });
                    }
                    medicinescontroller.otherInstitutes = medicinescontroller.otherInstitutes.filter((institute) => {
                        return institute.id != medicinescontroller.currentChild.screeningCenter;
                    });
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                })
            } else {
                medicinescontroller.childScreeningObject.institutionType = null;
                medicinescontroller.childScreeningObject.higherFacilityReferralPlace = null;
            }
        }

        medicinescontroller.applyAgeFilters = () => {
            if (medicinescontroller.currentChild.ageInDays != null && medicinescontroller.currentChild.ageInDays < 28) {
                medicinescontroller.below28Days = true;
                medicinescontroller.below2Months = true;
                medicinescontroller.below6Months = true;
            } else if (medicinescontroller.currentChild.ageInDays != null && medicinescontroller.currentChild.ageInDays <= 60 && medicinescontroller.currentChild.ageInDays >= 28) {
                medicinescontroller.below2Months = true;
                medicinescontroller.below6Months = true;
            } else if (medicinescontroller.currentChild.ageInDays != null && medicinescontroller.currentChild.ageInDays < 180 && medicinescontroller.currentChild.ageInDays > 60) {
                medicinescontroller.below6Months = true
            } else if (medicinescontroller.currentChild.ageInDays != null && medicinescontroller.currentChild.ageInDays >= 180) {
                medicinescontroller.above6Months = true
            }
        }

        medicinescontroller.formulaGivenChanged = () => {
            medicinescontroller.childScreeningObject.isPotassium = null;
            medicinescontroller.childScreeningObject.isMagnesium = null;
            medicinescontroller.childScreeningObject.isZinc = null;
            medicinescontroller.childScreeningObject.multiVitaminSyrup = null;
            medicinescontroller.childScreeningObject.isIron = null;
        }

        medicinescontroller.init();
    }
    angular.module('imtecho.controllers').controller('MedicinesController', MedicinesController);
})();
