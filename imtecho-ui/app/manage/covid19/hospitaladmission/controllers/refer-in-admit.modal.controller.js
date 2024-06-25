(function () {
    function CovidReferInAdmitModalController(Mask, GeneralUtil, selectedRecord, $uibModalInstance, QueryDAO, toaster,
        wardList, $q) {
        var mdctrl = this;
        mdctrl.selectedRecord = angular.copy(selectedRecord);
        mdctrl.selectedRecord[0].admissionDate = new Date();
        mdctrl.getDate = function (date) {
            return (date.getMonth() + 1) + "-" + date.getDate() + "-" + date.getFullYear();
        };

        mdctrl.checkCaseNo = function () {
            if (mdctrl.submitted === true) {
                return;
            }
            mdctrl.submitted = true;
            if (!!mdctrl.selectedRecord[0].caseNo) {
                var defer = $q.defer();
                var caseDto = {
                    code: 'covid19_get_admission_by_health_infra_and_case_no',
                    parameters: {
                        caseNo: mdctrl.selectedRecord[0].caseNo,
                    }
                }
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
                    mdctrl.submitted = false;
                    Mask.hide();
                });
                return defer.promise;
            }
        }

        mdctrl.wardList = wardList;
        mdctrl.submitted = false;
        mdctrl.admit = function () {
            if (mdctrl.admissionform.$valid) {
                var caseDto = {
                    code: 'covid19_get_admission_by_health_infra_and_case_no',
                    parameters: {
                        caseNo: mdctrl.selectedRecord[0].caseNo,
                    }
                }
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
                    var dto = {
                        code: 'covid19_refer_in_admit',
                        parameters: {
                            admissionId: mdctrl.selectedRecord[0].admissionId,
                            id: mdctrl.selectedRecord[0].refId,
                            wardId: Number(mdctrl.selectedRecord[0].ward),
                            bedNo: mdctrl.selectedRecord[0].bedno,
                            unitNo: mdctrl.selectedRecord[0].unitno || null,
                            caseNo: mdctrl.selectedRecord[0].caseNo || null,
                            opdCaseNo: mdctrl.selectedRecord[0].opdCaseNo || null,
                            admissionDate: moment(mdctrl.selectedRecord[0].admissionDate).format("DD-MM-YYYY"),
                            travelHistory: mdctrl.selectedRecord[0].travelHistory,
                            travelledPlace: mdctrl.selectedRecord[0].travelledPlace,
                            is_abroad_in_contact: mdctrl.selectedRecord[0].is_abroad_in_contact,
                            abroad_contact_details: mdctrl.selectedRecord[0].abroad_contact_details || '',
                            flightno: mdctrl.selectedRecord[0].flightno || '',
                            inContactWithCovid19Paitent: mdctrl.selectedRecord[0].inContactWithCovid19Paitent,
                        }
                    };
                    Mask.show();
                    QueryDAO.execute(dto).then(function (referRes) {
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

        mdctrl.cancel = function () {
            $uibModalInstance.dismiss('cancel');
        };

        Mask.show();
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
    }
    angular.module('imtecho.controllers').controller('CovidReferInAdmitModalController', CovidReferInAdmitModalController);
})();
