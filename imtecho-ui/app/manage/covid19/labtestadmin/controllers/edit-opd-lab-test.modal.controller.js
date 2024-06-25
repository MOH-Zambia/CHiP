(function () {
    function EditOpdLabTestController($uibModalInstance, admissionId, GeneralUtil, loggedInUserId,
        Mask, QueryDAO, toaster) {

        var ctrl = this;
        if (!!admissionId) {
            Mask.show();
            QueryDAO.execute({
                code: 'covid_19_get_opd_lab_test_for_edit',
                parameters: {
                    admissionId: admissionId
                }
            }).then((response) => {
                ctrl.selectedRecord = response.result;
                ctrl.collectionDate = new Date(ctrl.selectedRecord[0].collectionDate);
                ctrl.collectionTime = new Date(ctrl.selectedRecord[0].collectionDate);
                return QueryDAO.execute({
                    code: 'covid19_get_ward_detail',
                    parameters: {
                    }
                });
            }).then((response) => {
                ctrl.wardList = response.result;
                return QueryDAO.execute({
                    code: 'retrieve_health_infra_for_user',
                    parameters: {
                        userId: loggedInUserId
                    }
                });
            }).then((response) => {
                ctrl.healthInfras = response.result;
                return QueryDAO.execute({
                    code: 'covid19_retrieve_lab_location',
                    parameters: {
                        type: ['D','C']
                    }
                });
            }).then((response) => {
                ctrl.labLocations = response.result;
                ctrl.labLocationChanged();
                return QueryDAO.execute({
                    code: 'covid19_retrieve_covid_hospital_location',
                    parameters: {
                        type: ['D','C']
                    }
                });
            }).then((response) => {
                ctrl.covidHospitalLocations = response.result;
                ctrl.hospitalLocationChanged();
                return QueryDAO.execute({
                    code: 'retrieve_locations_by_type',
                    parameters: {
                        type: ['D','C']
                    }
                });
            }).then((response) => {
                ctrl.districtLocations = response.result;
                return QueryDAO.execute({
                    code: 'fetch_listvalue_detail_from_field',
                    parameters: {
                        field: 'Countries list'
                    }
                });
            }).then((response) => {
                ctrl.countryList = response.result;
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            })
        }

        ctrl.retrieveLabTestByLocation = (locationId) => {
            return QueryDAO.execute({
                code: 'retrieve_covid_lab_test_by_location',
                parameters: {
                    locationId: locationId || null
                }
            });
        }

        ctrl.retrieveCovidHospitalByLocation = (locationId) => {
            return QueryDAO.execute({
                code: 'retrieve_covid_hospitals_by_location',
                parameters: {
                    locationId: locationId || null
                }
            });
        }

        ctrl.labLocationChanged = () => {
            Mask.show();
            ctrl.retrieveLabTestByLocation(ctrl.labLocationId).then((response) => {
                ctrl.labList = response.result;
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        ctrl.hospitalLocationChanged = () => {
            Mask.show();
            ctrl.retrieveCovidHospitalByLocation(ctrl.covidHospitalLocationId).then((response) => {
                ctrl.covidHospitalList = response.result;
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        ctrl.getDateTime = (date, time) => {
            return new Date(
                date.getFullYear(),
                date.getMonth(),
                date.getDate(),
                time.getHours(),
                time.getMinutes(),
            );
        }

        ctrl.getDate = function (date) {
            return (date.getMonth() + 1) + "-" + date.getDate() + "-" + date.getFullYear();
        };

        ctrl.submit = function () {
            if (
                ctrl.selectedRecord[0].firstname.length +
                ctrl.selectedRecord[0].middlename.length +
                ctrl.selectedRecord[0].lastname.length > 99 ) {
                    toaster.pop('danger', 'Full Name length should be less than 99 Chars');
                    return;
                }

            ctrl.editOpdLabTest.$setSubmitted();
            if (ctrl.editOpdLabTest.$valid) {
                const collectionDate = moment(ctrl.getDateTime(ctrl.collectionDate, ctrl.collectionTime)).format('DD-MM-YYYY HH:mm:ss');
                var dto = {
                    code: 'covid_19_edit_opd_lab_test',
                    parameters: {
                        firstname: ctrl.selectedRecord[0].firstname || null,
                        middlename: ctrl.selectedRecord[0].middlename || null,
                        lastname: ctrl.selectedRecord[0].lastname || null,
                        address: ctrl.selectedRecord[0].address || null,
                        pincode: ctrl.selectedRecord[0].pinCode || null,
                        occupation: ctrl.selectedRecord[0].occupation || null,
                        travel_history: ctrl.selectedRecord[0].travelHistory || null,
                        travelled_place: ctrl.selectedRecord[0].travelledPlace || null,
                        flight_no: ctrl.selectedRecord[0].flightno || null,
                        is_abroad_in_contact: ctrl.selectedRecord[0].is_abroad_in_contact || null,
                        in_contact_with_covid19_paitent: ctrl.selectedRecord[0].inContactWithCovid19Paitent || null,
                        abroad_contact_details: ctrl.selectedRecord[0].abroad_contact_details || null,
                        opd_case_no: ctrl.selectedRecord[0].opdCaseNo || null,
                        contact_no: ctrl.selectedRecord[0].contact_no || null,
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
                        other_co_mobidity: ctrl.selectedRecord[0].otherCoMobidity || null,
                        indications: ctrl.selectedRecord[0].indications || null,
                        date_of_onset_symptom: ctrl.selectedRecord[0].date_of_onset_symptom ? moment(ctrl.selectedRecord[0].date_of_onset_symptom).format("DD-MM-YYYY") : null,
                        refer_from_hospital: ctrl.selectedRecord[0].referFromHosital ? ctrl.selectedRecord[0].referFromHosital : null,
                        unit_no: ctrl.selectedRecord[0].unitno ? ctrl.selectedRecord[0].unitno : null,
                        health_status: ctrl.selectedRecord[0].healthstatus || null,
                        emergency_contact_name: ctrl.selectedRecord[0].emergencyContactName ? ctrl.selectedRecord[0].emergencyContactName : null,
                        emergency_contact_no: ctrl.selectedRecord[0].emergencyContactNo || null,
                        location_id: ctrl.selectedRecord[0].districtLocationId || null,
                        admissionId: ctrl.selectedRecord[0].id,
                        ageMonth: ctrl.selectedRecord[0].ageMonth,
                        isMigrant: ctrl.selectedRecord[0].isMigrant,
                        otherIndications: ctrl.selectedRecord[0].otherIndications ? ctrl.selectedRecord[0].otherIndications : null,
                        suggestedHealthInfra: ctrl.selectedRecord[0].suggestedHealthInfra,
                        labHealthInfraId: ctrl.selectedRecord[0].labHealthInfraId || null,
                        collectionDate: collectionDate,
                        healthInfraId: ctrl.selectedRecord[0].health_infra_id,
                    }
                };
                Mask.show();
                QueryDAO.execute(dto).then(function (res) {
                    toaster.pop('success', 'COVID-19 Data updated Successfully');
                    if (screen == 'suspected') {
                        covidAdmissionctrl.covid19SuspectedCases = [];
                        covidAdmissionctrl.searchSuspectedCaseData();
                    } else if (screen == 'confirmed') {
                        covidAdmissionctrl.covid19ConfirmedCases = [];
                        covidAdmissionctrl.searchConfirmedCaseData();
                    }
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                });
                $uibModalInstance.close();
            }
        }

        ctrl.cancel = function () {
            $uibModalInstance.dismiss();
        }

    }
    angular.module('imtecho.controllers').controller('EditOpdLabTestController', EditOpdLabTestController);
})();
