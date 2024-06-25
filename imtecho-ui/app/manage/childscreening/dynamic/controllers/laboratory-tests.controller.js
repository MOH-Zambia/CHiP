(function () {
    function LaboratoryTestsController(ChildScreeningService, Mask, toaster, $state, QueryDAO, GeneralUtil, AuthenticateService, $q) {
        var ctrl = this;
        const FEATURE = 'techo.manage.childscreeninglist';
        const LABORATORY_FORM_CONFIGURATION_KEY = 'NUTRITION_LABORATORY_TEST';
        ctrl.formData = {};
        ctrl.laboratoryList = [];
        ctrl.laboratoryDates = [];
        ctrl.today = moment().startOf('day');

        ctrl.init = () => {
            Mask.show();
            QueryDAO.execute({
                code: 'child_cmtc_nrc_screening_details',
                parameters: {
                    childId: Number($state.params.id)
                }
            }).then((response) => {
                ctrl.currentChild = response.result[0];
                return ChildScreeningService.retrieveAdmissionDetailById(ctrl.currentChild.admissionId);
            }).then((response) => {
                ctrl.currentChild.admissionDate = moment(response.admissionDate);
                if (moment().diff(ctrl.currentChild.admissionDate, 'days') >= 21) {
                    ctrl.maxLaboratoryDate = moment(ctrl.currentChild.admissionDate).add(20, 'days');
                } else {
                    ctrl.maxLaboratoryDate = ctrl.today;
                }
                return ChildScreeningService.retrieveLaboratoryList(ctrl.currentChild.admissionId);
            }).then((response) => {
                if (response.length > 0) {
                    ctrl.laboratoryList = response
                    ctrl.laboratoryList.forEach((child) => {
                        ctrl.laboratoryDates.push(child.laboratoryDate);
                    })
                    ctrl.laboratoryList.sort((child1, child2) => {
                        return new Date(child2.laboratoryDate) - new Date(child1.laboratoryDate);
                    });
                    return ChildScreeningService.retrieveLastLaboratoryTest(ctrl.currentChild.admissionId);
                }
            }).then((response) => {
                if (response != null) {
                    ctrl.previousTest = response;
                    if (ctrl.previousTest.testOutputState === 'PENDING') {
                        Object.assign(ctrl.formData, {
                            ...ctrl.formData,
                            id: ctrl.previousTest.id
                        });
                    }
                }
                let promiseList = [];
                promiseList.push(AuthenticateService.getLoggedInUser());
                promiseList.push(AuthenticateService.getAssignedFeature(FEATURE));
                return $q.all(promiseList);
            }).then((response) => {
                ctrl.loggedInUser = response[0].data;
                ctrl.formConfigurations = response[1].systemConstraintConfigs[LABORATORY_FORM_CONFIGURATION_KEY];
                ctrl.webTemplateConfigs = response[1].webTemplateConfigs[LABORATORY_FORM_CONFIGURATION_KEY];
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
                $state.go('techo.manage.childscreeninglist');
            }).finally(() => {
                if (ctrl.currentChild != null) {
                    ctrl.currentChild.age = parseInt(moment().diff(moment(ctrl.currentChild.dob), 'months', true));
                    ctrl.currentChild.childDetails = `${moment(ctrl.currentChild.dob).format("DD-MM-YYYY")} / ${ctrl.currentChild.age} months / ${ctrl.currentChild.gender}`;
                    Mask.hide();
                } else {
                    Mask.hide();
                    $state.go('techo.manage.childscreeninglist')
                }
            });
        }

        ctrl.labTestDateChanged = () => {
            let laboratoryDate = moment(ctrl.formData.laboratoryDate).format("YYYY-MM-DD");
            if (ctrl.laboratoryDates && ctrl.laboratoryDates.includes(laboratoryDate)) {
                toaster.pop('error', 'Test has already been submitted for this date');
            }
            Object.assign(ctrl.formData, {
                ...ctrl.formData,
                hemoglobinChecked: null,
                hemoglobin: null,
                urinePusCellsChecked: null,
                urinePusCells: null,
                urineAlbuminChecked: null,
                urineAlbumin: null,
                hivChecked: null,
                hiv: null,
                sickleChecked: null,
                sickle: null,
                psForMpChecked: null,
                psForMp: null,
                psForMpValue: null,
                monotouxTestChecked: null,
                monotouxTest: null,
                xrayChestChecked: null,
                xrayChest: null,
                bloodGroup: null,
            });
        }

        ctrl.psForMpChanged = () => ctrl.formData.psForMpValue = null;

        ctrl.saveLaboratoryTest = () => {
            if (ctrl.laboratoryTestsForm.$valid) {
                ctrl.formData.admissionId = ctrl.currentChild.admissionId;
                if (ctrl.formData.bloodGroup === null) {
                    ctrl.formData.bloodGroup = ctrl.previousTest.bloodGroup;
                }
                Mask.show();
                ChildScreeningService.saveLaboratoryTests(ctrl.formData).then(() => {
                    toaster.pop('success', 'Details saved successfully');
                    $state.go("techo.manage.childscreeninglist");
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                });
            }
        }

        ctrl.goBack = () => $state.go('techo.manage.childscreeninglist');

        ctrl.init();
    }
    angular.module('imtecho.controllers').controller('LaboratoryTestsController', LaboratoryTestsController);
})();
