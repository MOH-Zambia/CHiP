(function () {
    function LabTestAdminController(Mask, QueryDAO, GeneralUtil, $uibModal, AuthenticateService, toaster, PagingService, CovidService) {
        var lbtCtrl = this;
        lbtCtrl.locationClusters = [];

        lbtCtrl.init = () => {
            Mask.show();
            AuthenticateService.getLoggedInUser().then((response) => {
                lbtCtrl.currentUser = response.data;
                lbtCtrl.initializeList();
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });

        };

        lbtCtrl.initializeList = () => {
            lbtCtrl.retrievePagingService = PagingService.initialize();
            lbtCtrl.retrieveAdminLabList();
        }

        lbtCtrl.retrieveAdminLabList = () => {
            lbtCtrl.criteria = {
                limit: lbtCtrl.retrievePagingService.limit,
                offset: lbtCtrl.retrievePagingService.offSet,
                search: lbtCtrl.searchText
            };

            let adminLabList = lbtCtrl.adminLabList;
            Mask.show();
            PagingService.getNextPage(CovidService.retrieveAdminLabList, lbtCtrl.criteria, adminLabList, null).then((response) => {
                lbtCtrl.adminLabList = response;
                lbtCtrl.adminLabList.forEach((sample) => {
                    sample.labTestGeneratedNumber = sample.labTestNumber && sample.labTestNumber != 'null' ? `${sample.labTestId}(${sample.labTestNumber})` : sample.labTestId;
                });
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        }


        lbtCtrl.delete = (member) => {
            var modalInstance = $uibModal.open({
                templateUrl: 'app/common/views/confirmation.modal.html',
                controller: 'ConfirmModalController',
                windowClass: 'cst-modal',
                backdrop: 'static',
                size: 'med',
                resolve: {
                    message: () => {
                        return "Are you sure you want to delete this record ?";
                    }
                }
            });
            modalInstance.result.then(() => {
                Mask.show();
                QueryDAO.execute({
                    code: 'covid19_admin_delete_lab_test',
                    parameters: {
                        admissionId: member.admissionId,

                    }
                }).then((response) => {
                    toaster.pop('success', "Data deleted successfully.");
                    lbtCtrl.initializeList();
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                });
            });
        };

        lbtCtrl.revertOutCome = (member) => {
            var modalInstance = $uibModal.open({
                templateUrl: 'app/common/views/confirmation.modal.html',
                controller: 'ConfirmModalController',
                windowClass: 'cst-modal',
                backdrop: 'static',
                size: 'med',
                resolve: {
                    message: () => {
                        return "Are you sure you want to revert outcome of this record ?";
                    }
                }
            });
            modalInstance.result.then(() => {
                Mask.show();
                QueryDAO.execute({
                    code: 'covid19_admin_revert_outcome',
                    parameters: {
                        admissionId: member.admissionId,

                    }
                }).then((response) => {
                    toaster.pop('success', "Changes reverted successfully.");
                    lbtCtrl.initializeList();
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                });
            });
        }

        lbtCtrl.editAmission = function (member) {
            var modalInstance = $uibModal.open({
                templateUrl: 'app/manage/covid19/hospitaladmission/views/edit-admission.modal.html',
                windowClass: 'cst-modal',
                backdrop: 'static',
                size: 'lg',
                controllerAs: 'ctrl',
                controller: 'EditAdmissionController',
                resolve: {
                    admissionId: () => {
                        return member.admissionId
                    },
                    loggedInUserId: () => {
                        return lbtCtrl.currentUser.id
                    }
                }
            });
            modalInstance.result.then(() => {
                lbtCtrl.initializeList();
            });
        }

        lbtCtrl.editOpdLabTest = function (member) {
            var modalInstance = $uibModal.open({
                templateUrl: 'app/manage/covid19/labtestadmin/views/edit-opd-lab-test.modal.html',
                windowClass: 'cst-modal',
                backdrop: 'static',
                size: 'lg',
                controllerAs: 'ctrl',
                controller: 'EditOpdLabTestController',
                resolve: {
                    admissionId: () => {
                        return member.admissionId
                    },
                    loggedInUserId: () => {
                        return lbtCtrl.currentUser.id
                    }
                }
            });
            modalInstance.result.then(() => {
                lbtCtrl.initializeList();
            });
        }

        lbtCtrl.transfer = function (member, isTrasfer) {
            var modalInstance = $uibModal.open({
                templateUrl: 'app/manage/covid19/labtestadmin/views/trasfer-hospital.modal.html',
                windowClass: 'cst-modal',
                backdrop: 'static',
                size: 'lg',
                controllerAs: 'ctrl',
                controller: 'TrasferHospitalController',
                resolve: {
                    admissionId: () => {
                        return member.admissionId
                    },
                    isTrasfer: () => {
                        return isTrasfer
                    }
                }
            });
            modalInstance.result.then(() => {
                lbtCtrl.initializeList();
            });
        }


        lbtCtrl.searchChanged = () => {
            lbtCtrl.initializeList();
        }

        lbtCtrl.init();

    }
    angular.module('imtecho.controllers').controller('LabTestAdminController', LabTestAdminController);
})();
