(function () {
    function LaboratoryTestsController(ChildScreeningService, Mask, toaster, $state, QueryDAO, GeneralUtil) {
        var laboratorytests = this;

        laboratorytests.saveForm = () => {
            if (laboratorytests.laboratoryTestsForm.$valid) {
                if (laboratorytests.alreadyEntered) {
                    toaster.pop('error', 'Test has already been submitted for this date');
                } else {
                    laboratorytests.childScreeningObject.admissionId = laboratorytests.currentChild.admissionId;
                    Mask.show();
                    ChildScreeningService.saveLaboratoryTests(laboratorytests.childScreeningObject).then((response) => {
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

        laboratorytests.init = () => {
            Mask.show();
            QueryDAO.execute({
                code: 'child_cmtc_nrc_screening_details',
                parameters: {
                    childId: Number($state.params.id)
                }
            }).then((response) => {
                if (response.result.length === 1) {
                    laboratorytests.currentChild = response.result[0];
                    return ChildScreeningService.retrieveAdmissionDetailById(laboratorytests.currentChild.admissionId);
                } else {
                    Promise.reject();
                }
            }).then((response) => {
                if (response != null) {
                    laboratorytests.currentChild.admissionDate = new Date(response.admissionDate);
                    if ((moment(laboratorytests.currentChild.admissionDate).add(20, 'days')) > moment()) {
                        laboratorytests.currentChild.maxLaboratoryDate = moment();
                    } else {
                        laboratorytests.currentChild.maxLaboratoryDate = moment(laboratorytests.currentChild.admissionDate).add(20, 'days');
                    }
                    return ChildScreeningService.retrieveLaboratoryList(laboratorytests.currentChild.admissionId);
                } else {
                    Promise.reject();
                }
            }).then((response) => {
                if (response.length > 0) {
                    laboratorytests.laboratoryList = response
                    laboratorytests.laboratoryDates = [];
                    laboratorytests.laboratoryList.forEach((child) => {
                        laboratorytests.laboratoryDates.push(child.laboratoryDate);
                    })
                    laboratorytests.laboratoryList.sort((child1, child2) => {
                        return new Date(child2.laboratoryDate) - new Date(child1.laboratoryDate);
                    });
                    return ChildScreeningService.retrieveLastLaboratoryTest(laboratorytests.currentChild.admissionId);
                } else {
                    laboratorytests.laboratoryList = [];
                    laboratorytests.laboratoryDates = [];
                    Promise.resolve();
                }
            }).then((response) => {
                if (response != null) {
                    laboratorytests.previousTest = response;
                    if (laboratorytests.previousTest.testOutputState === 'PENDING') {
                        laboratorytests.previousTest.laboratoryDisplayDate = moment(laboratorytests.previousTest.laboratoryDate).format("DD-MM-YYYY");
                        laboratorytests.childScreeningObject = {};
                        laboratorytests.childScreeningObject.id = laboratorytests.previousTest.id;
                    }
                }
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
                $state.go('techo.manage.childscreeninglist')
            }).finally(() => {
                if (laboratorytests.currentChild != null) {
                    laboratorytests.currentChild.screenedOn = moment(laboratorytests.currentChild.screenedOn).format("DD/MM/YYYY");
                    laboratorytests.currentChild.bpl = laboratorytests.currentChild.bpl ? "Yes" : "No";
                    laboratorytests.currentChild.age = parseInt(moment().diff(moment(laboratorytests.currentChild.dob), 'months', true));
                    laboratorytests.currentChild.dob = moment(laboratorytests.currentChild.dob).format("DD-MM-YYYY");
                    Mask.hide();
                } else {
                    Mask.hide();
                    $state.go('techo.manage.childscreeninglist')
                }
            });
        }

        laboratorytests.calculateDays = () => {
            var laboratoryDate = moment(laboratorytests.childScreeningObject.laboratoryDate).format("YYYY-MM-DD");
            if (laboratorytests.laboratoryDates && laboratorytests.laboratoryDates.includes(laboratoryDate)) {
                laboratorytests.alreadyEntered = true;
                toaster.pop('error', 'Test has already been submitted for this date');
            } else {
                laboratorytests.alreadyEntered = false;
            }
        }

        laboratorytests.back = () => {
            laboratorytests.laboratoryTestsForm.$setPristine();
            window.history.back();
        }

        laboratorytests.init();
    }
    angular.module('imtecho.controllers').controller('LaboratoryTestsController', LaboratoryTestsController);
})();
