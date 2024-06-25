(function () {
    function DischargeModalCtrl($uibModalInstance, QueryDAO, Mask, GeneralUtil, toaster,
        covidCase, loggedInUser) {
        var dischargeModalCtrl = this;
        dischargeModalCtrl.dischargeDate = new Date();
        dischargeModalCtrl.deathDate = new Date();
        dischargeModalCtrl.loggedInUser = loggedInUser;
        dischargeModalCtrl.covidCase = covidCase;
        dischargeModalCtrl.admissionDate = moment(dischargeModalCtrl.covidCase.admissionDate,"DD/MM/YYYY").toDate();        
        dischargeModalCtrl.today = new Date();
        dischargeModalCtrl.cancel = function () {
            $uibModalInstance.dismiss('cancel');
        };


        dischargeModalCtrl.getDate = (date, time) => {
            return new Date(
                date.getFullYear(),
                date.getMonth(),
                date.getDate(),
                time.getHours(),
                time.getMinutes(),
            );
        }
        dischargeModalCtrl.resetDischargeDate = function(){
            dischargeModalCtrl.dischargeDate = new Date();
        }
        dischargeModalCtrl.submit = function () {
            if (!!dischargeModalCtrl.dischargeModalCtrlForm.$valid) {
                if (!dischargeModalCtrl.isReferedToAnotherHospital && !dischargeModalCtrl.isDeath
                    && !dischargeModalCtrl.isDischarge && !dischargeModalCtrl.isDAMALAMA) {
                    toaster.pop('danger', "Please select any one option");
                    return;
                }
                if (!!dischargeModalCtrl.isDeath) {
                    var deathDateTime = moment(dischargeModalCtrl.getDate(dischargeModalCtrl.deathDate, dischargeModalCtrl.deathTime)).format('MM-DD-YYYY HH:mm:ss');
                }
                var admissionStatus = dischargeModalCtrl.isDischarge ? 'DISCHARGE' : dischargeModalCtrl.isDeath ? 'DEATH' :
                    dischargeModalCtrl.isReferedToAnotherHospital ? 'REFER' : dischargeModalCtrl.isDAMALAMA ? 'DAMA/LAMA' : '';
                var referralState = dischargeModalCtrl.isReferedToAnotherHospital ? 'PENDING' : 'COMPLETED'
                let dto = {
                    code: 'covid19_admission_discharge',
                    parameters: {
                        admissionId: dischargeModalCtrl.covidCase.admissionId,
                        dischargeDate: !!dischargeModalCtrl.isDeath ? deathDateTime : moment(dischargeModalCtrl.dischargeDate).format("DD-MM-YYYY"),
                        deathCause: !!dischargeModalCtrl.isDeath ? dischargeModalCtrl.deathCause : '',
                        tohealthInfraId: !!dischargeModalCtrl.isReferedToAnotherHospital ? dischargeModalCtrl.tohealthInfraId : null,
                        dischargeRemark: !!dischargeModalCtrl.dischargeRemark ? dischargeModalCtrl.dischargeRemark : '',
                        admissionStatus: admissionStatus,
                        referralState: referralState
                    }
                };
                Mask.show();
                QueryDAO.execute(dto).then(function (res) {
                    toaster.pop('success', 'Outcome submitted successfully');
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                    $uibModalInstance.close();
                });
            }
        }

        dischargeModalCtrl.retrieveHealthInfrastructuresByLocation = () => {
            return QueryDAO.execute({
                code: 'retrieve_covid_hospitals_by_location',
                parameters: {
                    locationId: dischargeModalCtrl.districtlocationId
                }
            });
        }

        dischargeModalCtrl.referLocationChanged = () => {
            Mask.show();
            dischargeModalCtrl.healthInfraId = null;
            dischargeModalCtrl.retrieveHealthInfrastructuresByLocation().then((response) => {
                dischargeModalCtrl.healthInfrastructureList = response.result;
                setTimeout(() => {
                    $('#healthInfrastructure').trigger('chosen:updated');
                })
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }

        Mask.show();
        QueryDAO.execute({
            code: 'retrieve_locations_by_type',
            parameters: {
                type: ['D','C']
            }
        }).then((response) => {
            dischargeModalCtrl.districtLocations = response.result;
            setTimeout(() => {
                $('#districtlocationId').trigger("chosen:updated");
            });
            return dischargeModalCtrl.retrieveHealthInfrastructuresByLocation();
        }).catch((error) => {
            GeneralUtil.showMessageOnApiCallFailure(error);
        }).finally(() => {
            Mask.hide();
        })

    }
    angular.module('imtecho.controllers').controller('DischargeModalCtrl', DischargeModalCtrl);
})();
