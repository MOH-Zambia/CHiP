(function () {
    function TrasferHospitalController(Mask, QueryDAO, GeneralUtil, admissionId, toaster, $uibModalInstance, isTrasfer) {
        var ctrl = this;
        ctrl.isTrasfer = isTrasfer;
        ctrl.cancel = function () {
            $uibModalInstance.dismiss('cancel');
        };

        ctrl.submit = function () {
            if (!!ctrl.transferForm.$valid) {
                var code = 'covid19_admin_transfer_hospital';
                if (!ctrl.isTrasfer) {
                    code = 'covid19_admin_update_suggested_hospital';
                }
                var dto = {
                    code: code,
                    parameters: {
                        admissionId: admissionId,
                        healthInfaId: ctrl.healthInfraId
                    }
                };
                Mask.show();
                QueryDAO.execute(dto).then(function (res) {
                    toaster.pop('success', 'Date Saved Successfully');
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                    $uibModalInstance.close();
                });
            }
        }

        ctrl.retrieveHealthInfrastructuresByLocation = () => {
            return QueryDAO.execute({
                code: 'retrieve_covid_hospitals_by_location',
                parameters: {
                    locationId: ctrl.districtlocationId
                }
            });
        }

        ctrl.referLocationChanged = () => {
            Mask.show();
            ctrl.healthInfraId = null;
            ctrl.retrieveHealthInfrastructuresByLocation().then((response) => {
                ctrl.healthInfrastructureList = response.result;
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
            ctrl.districtLocations = response.result;
        }).catch((error) => {
            GeneralUtil.showMessageOnApiCallFailure(error);
        }).finally(() => {
            Mask.hide();
        })
    }
    angular.module('imtecho.controllers').controller('TrasferHospitalController', TrasferHospitalController);
})();
