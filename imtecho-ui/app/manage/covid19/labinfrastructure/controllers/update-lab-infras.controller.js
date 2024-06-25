(function () {
    function Labinfrastructure($stateParams, Mask, QueryDAO, toaster, $state, AuthenticateService, GeneralUtil) {
        var labinfrastructure = this;
        labinfrastructure.today = moment();
        labinfrastructure.testingKitsList = labinfrastructure.componentList = [];
        Labinfrastructure.senderList = [];

        labinfrastructure.init = () => {
            Mask.show();
            AuthenticateService.getLoggedInUser().then((user) => {
                labinfrastructure.user = user.data;
                return QueryDAO.execute({
                    code: 'health_infrastructure_retrieve_by_id',
                    parameters: {
                        id: Number($stateParams.id)
                    }
                });
            }).then((response) => {
                labinfrastructure.healthInfraDisplayDetails = response.result[0];
                labinfrastructure.getTestingKitDetails();
                labinfrastructure.getComponentDetails();
                labinfrastructure.getSenderInfo();
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
                $state.go("techo.manage.labinfrastructure");
            }).finally(() => {
                Mask.hide();
            });
        };

        labinfrastructure.getTestingKitDetails = () => {
            Mask.show();
            QueryDAO.execute({
                code: 'covid19_retrieve_lab_infrastructure_testing_details',
                parameters: {
                    healthInfraId: Number($stateParams.id)
                }
            }).then((response) => {
                labinfrastructure.testingKitsList = response.result;
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            })
        }

        labinfrastructure.getComponentDetails = () => {
            Mask.show();
            QueryDAO.execute({
                code: 'covid19_retrieve_lab_infrastructure_component_details',
                parameters: {
                    healthInfraId: Number($stateParams.id)
                }
            }).then((response) => {
                labinfrastructure.componentList = response.result;
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            })
        }

        labinfrastructure.getSenderInfo = () => {
            Mask.show();
            QueryDAO.execute({
                code: 'covid19_retrieve_kit_sender_list',
                parameters: {
                }
            }).then((response) => {
                labinfrastructure.senderList = response.result;
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            })
        }

        labinfrastructure.saveKit = () => {
            labinfrastructure.testingKitsReceivedForm.$setSubmitted();
            if (labinfrastructure.testingKitsReceivedForm.$valid) {
                Mask.show();
                QueryDAO.execute({
                    code: 'covid19_insert_lab_infrastructure_kit_details',
                    parameters: {
                        healthInfraId: Number($stateParams.id),
                        receiptDate: moment(labinfrastructure.testingKitObject.receiptDate).format('DD-MM-YYYY'),
                        receivedFrom: Number(labinfrastructure.testingKitObject.receivedFrom),
                        kitsList: labinfrastructure.testingKitObject.kitsList,
                        userId: labinfrastructure.user.id
                    }
                }).then((response) => {
                    toaster.pop('success', 'Details saved successfully');
                    labinfrastructure.testingKitsList = [];
                    labinfrastructure.getTestingKitDetails();
                    labinfrastructure.testingKitObject = {};
                    labinfrastructure.testingKitsReceivedForm.$setPristine();
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                });
            }
        }

        labinfrastructure.saveComponent = () => {
            labinfrastructure.componentAvailabilityForm.$setSubmitted();
            if (labinfrastructure.componentAvailabilityForm.$valid) {
                let queryDto = {};
                queryDto.parameters = {
                    healthInfraId: Number($stateParams.id),
                    receiptDate: moment(labinfrastructure.componentObject.receiptDate).format('DD-MM-YYYY'),
                    rnaExtraction: labinfrastructure.componentObject.rnaExtraction,
                    eg: labinfrastructure.componentObject.eg,
                    confirmatoryAssay: labinfrastructure.componentObject.confirmatoryAssay,
                    agPath: labinfrastructure.componentObject.agPath,
                    testCapacity: labinfrastructure.componentObject.testCapacity,
                    userId: labinfrastructure.user.id
                }
                if (labinfrastructure.editMode) {
                    queryDto.code = 'covid19_update_lab_infrastructure_component_details'
                    queryDto.parameters.id = labinfrastructure.componentObject.id
                } else {
                    queryDto.code = 'covid19_insert_lab_infrastructure_component_details'
                }
                Mask.show();
                QueryDAO.execute(queryDto).then((response) => {
                    toaster.pop('success', 'Details saved successfully');
                    labinfrastructure.componentList = [];
                    labinfrastructure.getComponentDetails();
                    labinfrastructure.componentObject = {};
                    labinfrastructure.componentAvailabilityForm.$setPristine();
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                });
            }
        }

        labinfrastructure.checkComponentDateValidity = () => {
            const reportingDate = labinfrastructure.componentObject.receiptDate;
            Mask.show();
            QueryDAO.execute({
                code: 'covid19_component_details_by_date_and_infra',
                parameters: {
                    healthInfraId: Number($stateParams.id),
                    receiptDate: moment(labinfrastructure.componentObject.receiptDate).format('DD-MM-YYYY')
                }
            }).then((response) => {
                if (Array.isArray(response.result) && response.result.length) {
                    labinfrastructure.editMode = true;
                    labinfrastructure.componentObject = Object.assign({}, {
                        id: response.result[0].id,
                        rnaExtraction: response.result[0].rna_extraction,
                        eg: response.result[0].eg_available,
                        confirmatoryAssay: response.result[0].confirmatory_assay,
                        agPath: response.result[0].ag_path,
                        testCapacity: response.result[0].test_capacity,
                        receiptDate: reportingDate
                    })
                } else {
                    labinfrastructure.editMode = false;
                    labinfrastructure.componentObject = {};
                    labinfrastructure.componentObject.receiptDate = reportingDate
                }
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            })
        }

        labinfrastructure.goBack = () => $state.go("techo.manage.labinfrastructure");

        labinfrastructure.init();
    }
    angular.module('imtecho.controllers').controller('Labinfrastructure', Labinfrastructure);
})();
