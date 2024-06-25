(function () {
    function EditAdmissionController($uibModalInstance, admissionId, GeneralUtil, loggedInUserId,
        Mask, QueryDAO, toaster) {
        var ctrl = this;

        if (!!admissionId) {
            Mask.show();
            QueryDAO.execute({
                code: 'covid19_get_admitted_patients_det_for_editing',
                parameters: {
                    admissionId: admissionId
                }
            }).then((response) => {
                ctrl.selectedRecord = response.result;
                return QueryDAO.execute({
                    code: 'covid19_get_ward_detail',
                    parameters: {
                    }
                });
            }).then((response) => {
                ctrl.wardList = response.result;
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

        ctrl.submit = function () {
            ctrl.admissionEditForm.$setSubmitted();
            if (ctrl.admissionEditForm.$valid && !ctrl.isDuplicateCaseNo) {
                var dto = {
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
                        admission_date: ctrl.selectedRecord[0].admissionDate || null,
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
                        date_of_onset_symptom: ctrl.selectedRecord[0].date_of_onset_symptom || null,
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
                        otherIndications: !!ctrl.selectedRecord[0].otherIndications ? ctrl.selectedRecord[0].otherIndications : null,
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

        ctrl.checkCaseNo = function () {
            if (ctrl.submitted === true) {
                return;
            }
            ctrl.submitted = true;
            if (!!ctrl.selectedRecord[0].case_number) {
                var caseDto = {
                    code: 'covid19_get_admission_by_health_infra_and_case_no',
                    parameters: {
                        caseNo: ctrl.selectedRecord[0].case_number,
                    }
                }
                Mask.show();
                QueryDAO.execute(caseDto).then(function (res) {
                    if (res.result && res.result.length > 0) {
                        ctrl.isDuplicateCaseNo = true;
                        ctrl.caseMsg = res.result[0].resultMsg;
                    } else {
                        ctrl.isDuplicateCaseNo = false;
                        ctrl.caseMsg = '';
                    }
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                    ctrl.submitted = false;
                });
            }
        }

        ctrl.cancel = function () {
            $uibModalInstance.dismiss();
        }
    }
    angular.module('imtecho.controllers').controller('EditAdmissionController', EditAdmissionController);
})();
