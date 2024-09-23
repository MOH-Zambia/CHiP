// immunisation contains object for each vaccine in due Immunisation.
// immunisationDtos contains object for vaccines for which are given currently. 
// immunisationGiven contains final string that needs to be appended

(() => {
    let immunisationDirective = (ImmunisationDAO, Mask, GeneralUtil) => {
        return {
            restrict: 'E',
            scope: {
                dob: '<',
                immunisationGiven: '<',
                bindTo:'=',
                iteratorIndicesMap: '=?',
            },
            templateUrl: 'app/common/directives/immunisation/immunisation-template.html',
            link: (scope) => {
                scope.form = {}
                scope.init = function () {
                    scope.immunisation = {};
                    scope.bindTo = [];

                    Mask.show();
                    ImmunisationDAO.getDueImmunisationsForChild(moment(scope.dob).valueOf(), scope.immunisationGiven).then((response) => {
                        scope.dueImmunisations = response;
                        // create object for each due vaccine in immunisation
                        scope.dueImmunisations.forEach((immu) => {
                            scope.immunisation[immu] = {};
                        });
                    }).catch((error) => {
                        GeneralUtil.showMessageOnApiCallFailure(error);
                    }).finally(() => {
                        Mask.hide();
                    });
                }

                scope.immunisationGivenChanged = (immunisation) => {
                    // Set immunisation date to null
                    scope.immunisation[immunisation].date = null;

                    // running loop for all due vaccines
                    Object.keys(scope.immunisation).forEach((key) => {
                        // if the vaccine is not given remove it from immunisationDto and immunisationGiven string
                        if (!scope.immunisation[key].given) {
                            if (scope.immunisationGiven.includes(key)) {
                                let givenImmunisationsMap = scope.immunisationGiven.split(',');
                                givenImmunisationsMap.forEach((imm, index) => {
                                    if (imm.includes(key)) {
                                        givenImmunisationsMap.splice(index, 1);
                                    }
                                });
                                scope.immunisationGiven = givenImmunisationsMap.join(',');
                                scope.setImmunisationDtos(immunisation);
                            }
                        }
                        // if the vaccine is given & the date is set for vaccine, validate the vaccination wrt all other vaccines. 
                        // The logic is written to create a temp immunisationGiven string which would contain all given 
                        // vaccines (due + already given) except the current vaccine to check validity of current vaccine.
                        else if (scope.immunisation[key].given && scope.immunisation[key].date !== null) {
                            let givenImmunisation = scope.immunisationGiven;
                            if (givenImmunisation.includes(key)) {
                                let givenImmunisationsMap = givenImmunisation.split(',');
                                givenImmunisationsMap.forEach((imm, index) => {
                                    if (imm.includes(key)) {
                                        givenImmunisationsMap.splice(index, 1);
                                    }
                                });
                                givenImmunisation = givenImmunisationsMap.join(',');
                            }
                            Mask.show();
                            ImmunisationDAO.vaccinationValidationChild(moment(scope.dob).valueOf(), moment(scope.immunisation[key].date).valueOf(), key, givenImmunisation).then((response) => {
                                if (response.result !== "" && response.result !== null) {
                                    scope.vaccinationForm[scope.dob+'-'+key + 'date'].$dirty = true;
                                    scope.vaccinationForm[scope.dob+'-'+key + 'date'].$setValidity('Invalid vaccine date', false);
                                } else {
                                    scope.vaccinationForm[scope.dob+'-'+key + 'date'].$dirty = true;
                                    scope.vaccinationForm[scope.dob+'-'+key + 'date'].$setValidity('Invalid vaccine date', true);
                                }
                            }).catch((error) => {
                                GeneralUtil.showMessageOnApiCallFailure(error);
                            }).finally(() => {
                                Mask.hide();
                            });
                        }
                    });
                }

                scope.immunisationDateChanged = (immunisation) => {
                    
                    if (!scope.immunisationGiven) {
                        scope.immunisationGiven = "";
                    }
                    // The logic is written to update immunisationGiven string which would contain all given 
                    // vaccines (due + already given) except the current vaccine to check validity of current vaccine.
                    if (scope.immunisationGiven.includes(immunisation)) {
                        let givenImmunisationsMap = scope.immunisationGiven.split(',');
                        givenImmunisationsMap.forEach((imm, i) => {
                            if (imm.includes(immunisation)) {
                                givenImmunisationsMap.splice(i, 1);
                            }
                        });
                        scope.immunisationGiven = givenImmunisationsMap.join(',');
                    }
                    Mask.show();

                    ImmunisationDAO.vaccinationValidationChild(moment(scope.dob).valueOf(), moment(scope.immunisation[immunisation].date).valueOf(), immunisation, scope.immunisationGiven).then((response) => {
                        // if the vaccination is valid then update the immunisationString otherwise no change in string. Set UI validation accordingly
                        if (response.result !== "" && response.result !== null) {
                            scope.vaccinationForm[scope.dob+'-'+immunisation + 'date'].$dirty = true;
                            scope.vaccinationForm[scope.dob+'-'+immunisation + 'date'].$setValidity('Invalid vaccine date', false);
                        } else {
                            scope.vaccinationForm[scope.dob+'-'+immunisation + 'date'].$dirty = true;
                            scope.vaccinationForm[scope.dob+'-'+immunisation + 'date'].$setValidity('Invalid vaccine date', true);
                            scope.setCurrentlyGivenVaccines(immunisation);

                            // check validity of all the vaccines again after adding the new vaccine
                            Object.keys(scope.immunisation).forEach((key) => {
                                let givenImmunisations = angular.copy(scope.immunisationGiven)
                                if (scope.immunisation[key].given && scope.immunisation[key].date !== null) {
                                    // Create a temp immunisationGiven string which would contain all given 
                                    // vaccines (due + already given) except the current vaccine to check validity of current vaccine.
                                    if (givenImmunisations.includes(key)) {
                                        let givenImmunisationsMap = givenImmunisations.split(',');
                                        givenImmunisationsMap.forEach((imm, i) => {
                                            if (imm.includes(key)) {
                                                givenImmunisationsMap.splice(i, 1);
                                            }
                                        });
                                        givenImmunisations = givenImmunisationsMap.join(',');
                                    }
                                    Mask.show();
                                    ImmunisationDAO.vaccinationValidationChild(moment(scope.dob).valueOf(), moment(scope.immunisation[key].date).valueOf(), key, givenImmunisations).then((res) => {
                                        if (res.result !== "" && res.result !== null) {
                                            scope.vaccinationForm[scope.dob+'-'+key + 'date'].$dirty = true;
                                            scope.vaccinationForm[scope.dob+'-'+key + 'date'].$setValidity('Invalid vaccine date', false);
                                        } else {
                                            scope.vaccinationForm[scope.dob+'-'+key + 'date'].$dirty = true;
                                            scope.vaccinationForm[scope.dob+'-'+key + 'date'].$setValidity('Invalid vaccine date', true);
                                        }
                                    }).catch((error) => {
                                        GeneralUtil.showMessageOnApiCallFailure(error);
                                    }).finally(() => {
                                        Mask.hide();
                                    });
                                }
                            });
                        }
                        scope.setImmunisationDtos(immunisation);
                    }).catch((error) => {
                        GeneralUtil.showMessageOnApiCallFailure(error);
                    }).finally(() => {
                        Mask.hide();
                    });

                }

                scope.setCurrentlyGivenVaccines = (immunisation) => {
                    if (scope.immunisationGiven.includes(immunisation)) {
                        let givenImmunisationsMap = scope.immunisationGiven.split(',');
                        givenImmunisationsMap.forEach((imm, index) => {
                            if (imm.includes(immunisation)) {
                                givenImmunisationsMap.splice(index, 1);
                            }
                        });
                        scope.immunisationGiven = givenImmunisationsMap.join(',');
                    }

                    if (scope.immunisationGiven === null || scope.immunisationGiven === "") {
                        scope.immunisationGiven = immunisation + "#" + moment(scope.immunisation[immunisation].date).format("DD/MM/YYYY");
                    } else {
                        scope.immunisationGiven += "," + immunisation + "#" + moment(scope.immunisation[immunisation].date).format("DD/MM/YYYY");
                    }
                }

                scope.setImmunisationDtos = function (immunisation) {
                    scope.bindTo.forEach((dto, index) => {
                        if (dto.immunisation === immunisation) {
                            scope.bindTo.splice(index, 1);
                        }
                    })
                    if (scope.immunisationGiven.includes(immunisation)) {
                        scope.bindTo.push({
                            immunisation: immunisation,
                            givenOn: moment(scope.immunisation[immunisation].date).toDate()
                        })
                    }
                }

                scope.getTransformedKey = (key) => {
                    return key.split('_').join(' ');
                }
                
                scope.init()
            }
        }
    };
    angular.module('imtecho.directives').directive('immunisationDirective', immunisationDirective)
})();

