(function () {
    function covid19AdmittedCaseDailyStatusModalCtrl($uibModalInstance, QueryDAO, Mask, GeneralUtil, toaster,
        AuthenticateService, covidCase, wardList) {
        var covid19ACDStatusModalCtrl = this;
        covid19ACDStatusModalCtrl.covid19ACDStatus = {};
        covid19ACDStatusModalCtrl.covid19ACDStatus = angular.copy(covidCase);
        covid19ACDStatusModalCtrl.covid19ACDStatus.serviceDate = new Date();
        covid19ACDStatusModalCtrl.covid19ACDStatus.clinicallyCured = false;
        covid19ACDStatusModalCtrl.covid19ACDStatus.notReferred = true;
        covid19ACDStatusModalCtrl.wardList = wardList;
        covid19ACDStatusModalCtrl.covid19ACDStatus.isNone = true;
        AuthenticateService.getLoggedInUser().then(function (res) {
            covid19ACDStatusModalCtrl.currentUser = res.data;
        });

        covid19ACDStatusModalCtrl.onServiceDateChange = function () {
            covid19ACDStatusModalCtrl.visitDateLimit = new Date(moment(covid19ACDStatusModalCtrl.covid19ACDStatus.admissionDate, "DD-MM-YYYY"));
            covid19ACDStatusModalCtrl.visitMaxDateLimit =  new Date();
            var admissionDate = new Date(moment(covid19ACDStatusModalCtrl.covid19ACDStatus.admissionDate, "DD-MM-YYYY"));
            var Difference_In_Time = covid19ACDStatusModalCtrl.covid19ACDStatus.serviceDate.getTime() - admissionDate.getTime();
            covid19ACDStatusModalCtrl.dayNumber = Math.floor(Difference_In_Time / (1000 * 3600 * 24));
        };

        covid19ACDStatusModalCtrl.onServiceDateChange();

        covid19ACDStatusModalCtrl.cancel = function () {
            $uibModalInstance.dismiss('cancel');
        };


        covid19ACDStatusModalCtrl.submit = function () {
            if (!!covid19ACDStatusModalCtrl.covid19ACDStatusModalCtrlForm.$valid) {
                let dto = {
                    code: 'covid19_addmitted_case_daily_status_insert_data',
                    parameters: {
                        memberId: covid19ACDStatusModalCtrl.covid19ACDStatus.memberId,
                        locationId: covid19ACDStatusModalCtrl.covid19ACDStatus.locationId,
                        admissionId: covid19ACDStatusModalCtrl.covid19ACDStatus.admissionId,
                        wardId: covid19ACDStatusModalCtrl.covid19ACDStatus.wardId,
                        bedNumber: covid19ACDStatusModalCtrl.covid19ACDStatus.bedNumber,
                        healthStatus: covid19ACDStatusModalCtrl.covid19ACDStatus.healthStatus,
                        onVentilator: covid19ACDStatusModalCtrl.covid19ACDStatus.onVentilator,
                        ventilatorType1: !!covid19ACDStatusModalCtrl.covid19ACDStatus.ventilatorType1 && !!covid19ACDStatusModalCtrl.covid19ACDStatus.onVentilator ? covid19ACDStatusModalCtrl.covid19ACDStatus.ventilatorType1 : false,
                        ventilatorType2: !!covid19ACDStatusModalCtrl.covid19ACDStatus.ventilatorType2 && !!!!covid19ACDStatusModalCtrl.covid19ACDStatus.onVentilator ? covid19ACDStatusModalCtrl.covid19ACDStatus.ventilatorType2 : false,
                        onO2: covid19ACDStatusModalCtrl.covid19ACDStatus.onO2,
                        onAir: covid19ACDStatusModalCtrl.covid19ACDStatus.onAir,
                        remarks: covid19ACDStatusModalCtrl.covid19ACDStatus.remarks,
                        serviceDate: moment(covid19ACDStatusModalCtrl.covid19ACDStatus.serviceDate).format("DD-MM-YYYY"),
                        isDdead: covid19ACDStatusModalCtrl.covid19ACDStatus.isDdead,
                        isAlive: covid19ACDStatusModalCtrl.covid19ACDStatus.isAlive,
                        deathDate: covid19ACDStatusModalCtrl.covid19ACDStatus.deathDate,
                        deathTime: covid19ACDStatusModalCtrl.covid19ACDStatus.deathTime,
                        clinicallyCured: covid19ACDStatusModalCtrl.covid19ACDStatus.clinicallyCured,
                        isRefferedToAnotherHospital: covid19ACDStatusModalCtrl.covid19ACDStatus.isRefferedToAnotherHospital,
                        isHIV: covid19ACDStatusModalCtrl.covid19ACDStatus.isHIV,
                        isHeartPatient: covid19ACDStatusModalCtrl.covid19ACDStatus.isHeartPatient,
                        isDiabetes: covid19ACDStatusModalCtrl.covid19ACDStatus.isDiabetes,
                        isCOPD: covid19ACDStatusModalCtrl.covid19ACDStatus.isCOPD,
                        isRenalCondition: covid19ACDStatusModalCtrl.covid19ACDStatus.isRenalCondition,
                        isHypertension: covid19ACDStatusModalCtrl.covid19ACDStatus.isHypertension,
                        isImmunocompromized: covid19ACDStatusModalCtrl.covid19ACDStatus.isImmunocompromized,
                        isMalignancy: covid19ACDStatusModalCtrl.covid19ACDStatus.isMalignancy,
                        otherCoMobidity: !!covid19ACDStatusModalCtrl.covid19ACDStatus.otherCoMobidity ? covid19ACDStatusModalCtrl.covid19ACDStatus.otherCoMobidity.replace(/:/g, "").replace(/'/g, "''") : null,
                        hasFever: covid19ACDStatusModalCtrl.covid19ACDStatus.hasFever,
                        hasCough: covid19ACDStatusModalCtrl.covid19ACDStatus.hasCough,
                        hasShortnessBreath: covid19ACDStatusModalCtrl.covid19ACDStatus.hasShortnessBreath,
                        isSari: covid19ACDStatusModalCtrl.covid19ACDStatus.isSari,
                        temprature: covid19ACDStatusModalCtrl.covid19ACDStatus.temprature,
                        pulseRate: covid19ACDStatusModalCtrl.covid19ACDStatus.pulseRate,
                        bp: covid19ACDStatusModalCtrl.covid19ACDStatus.bp,
                        respirationRate: covid19ACDStatusModalCtrl.covid19ACDStatus.respirationRate,
                        bpSystolic: covid19ACDStatusModalCtrl.covid19ACDStatus.bpSystolic,
                        bpDialostic: covid19ACDStatusModalCtrl.covid19ACDStatus.bpDialostic,
                        sp02: covid19ACDStatusModalCtrl.covid19ACDStatus.sp02,
                        azithromycin: covid19ACDStatusModalCtrl.covid19ACDStatus.azithromycin,
                        hydroxychloroquine: covid19ACDStatusModalCtrl.covid19ACDStatus.hydroxychloroquine,
                        oseltamivir: covid19ACDStatusModalCtrl.covid19ACDStatus.oseltamivir,
                        antibiotics: covid19ACDStatusModalCtrl.covid19ACDStatus.antibiotics,
                        isXray: covid19ACDStatusModalCtrl.covid19ACDStatus.isXray,
                        isCtScan: covid19ACDStatusModalCtrl.covid19ACDStatus.isCtScan,
                        isECG: covid19ACDStatusModalCtrl.covid19ACDStatus.isECG,
                        isSerum: covid19ACDStatusModalCtrl.covid19ACDStatus.isSerum,
                        isSGPT: covid19ACDStatusModalCtrl.covid19ACDStatus.isSGPT,
                        isH1N1: covid19ACDStatusModalCtrl.covid19ACDStatus.isH1N1,
                        isBlood: covid19ACDStatusModalCtrl.covid19ACDStatus.isBlood,
                        isG6PD: covid19ACDStatusModalCtrl.covid19ACDStatus.isG6PD,
                        xRAYImpression: covid19ACDStatusModalCtrl.covid19ACDStatus.isXray ? covid19ACDStatusModalCtrl.covid19ACDStatus.xRAYImpression.replace(/:/g, "").replace(/'/g, "''") : null,
                        cTScanImpression: covid19ACDStatusModalCtrl.covid19ACDStatus.isCtScan ? covid19ACDStatusModalCtrl.covid19ACDStatus.cTScanImpression.replace(/:/g, "").replace(/'/g, "''") : null,
                        eCGImpression: covid19ACDStatusModalCtrl.covid19ACDStatus.isECG ? covid19ACDStatusModalCtrl.covid19ACDStatus.eCGImpression.replace(/:/g, "").replace(/'/g, "''") : null,
                        serumCreatinineImpression: covid19ACDStatusModalCtrl.covid19ACDStatus.isSerum ? covid19ACDStatusModalCtrl.covid19ACDStatus.serumCreatinineImpression.replace(/:/g, "").replace(/'/g, "''") : null,
                        sGPTImpression: covid19ACDStatusModalCtrl.covid19ACDStatus.isSGPT ? covid19ACDStatusModalCtrl.covid19ACDStatus.sGPTImpression.replace(/:/g, "").replace(/'/g, "''") : null,
                        h1N1TestImpression: covid19ACDStatusModalCtrl.covid19ACDStatus.isH1N1 ? covid19ACDStatusModalCtrl.covid19ACDStatus.h1N1TestImpression.replace(/:/g, "").replace(/'/g, "''") : null,
                        bloodCultureImpression: covid19ACDStatusModalCtrl.covid19ACDStatus.isBlood ? covid19ACDStatusModalCtrl.covid19ACDStatus.bloodCultureImpression.replace(/:/g, "").replace(/'/g, "''") : null,
                        G6PDImpression: covid19ACDStatusModalCtrl.covid19ACDStatus.isG6PD ? covid19ACDStatusModalCtrl.covid19ACDStatus.G6PDImpression.replace(/:/g, "").replace(/'/g, "''") : null,
                    }
                };
                Mask.show();
                QueryDAO.execute(dto).then(function (res) {
                    toaster.pop('success', 'COVID-19 Daily Status Data Created Successfully');
                    $uibModalInstance.close();
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                });

                //If Advise Lab Test
                if (!covid19ACDStatusModalCtrl.covid19ACDStatus.isLabTestInProgress &&
                    !!covid19ACDStatusModalCtrl.covid19ACDStatus.isLabTest) {
                    let labdto = {
                        code: 'insert_covid19_lab_test_detail',
                        parameters: {
                            memberId: covid19ACDStatusModalCtrl.covid19ACDStatus.memberId,
                            locationId: covid19ACDStatusModalCtrl.covid19ACDStatus.locationId,
                            admissionId: covid19ACDStatusModalCtrl.covid19ACDStatus.admissionId,
                        }
                    };
                    Mask.show();
                    QueryDAO.execute(labdto).then(function () {
                    }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                        Mask.hide();
                        $uibModalInstance.close();
                    });
                }
            }
        };
    }
    angular.module('imtecho.controllers').controller('covid19AdmittedCaseDailyStatusModalCtrl', covid19AdmittedCaseDailyStatusModalCtrl);
})();
