(function () {
    function MobileFeatureManagementController(Mask, GeneralUtil, QueryDAO, toaster, $uibModal) {
        let ctrl = this;

        ctrl.pagingService = {
            offset: 0,
            limit: 100,
            index: 0,
            allRetrieved: false,
            pagingRetrivalOn: false
        };

        let setOffsetLimit = function () {
            ctrl.pagingService.limit = 100;
            ctrl.pagingService.offset = ctrl.pagingService.index * 100;
            ctrl.pagingService.index = ctrl.pagingService.index + 1;
        };

        let retrieveAll = function () {
            if (!ctrl.pagingService.pagingRetrivalOn && !ctrl.pagingService.allRetrieved) {
                ctrl.pagingService.pagingRetrivalOn = true;
                setOffsetLimit();
                var queryDto = {
                    code: 'mobile_features',
                    parameters: {
                        limit: ctrl.pagingService.limit,
                        offset: ctrl.pagingService.offset,
                        search: ctrl.featureName
                    }
                };
                Mask.show();
                QueryDAO.executeQuery(queryDto).then(function (response) {
                    if (response.result.length === 0) {
                        ctrl.pagingService.allRetrieved = true;
                        if (ctrl.pagingService.index === 1) {
                            ctrl.features = response.result;
                        }
                    } else {
                        ctrl.pagingService.allRetrieved = false;
                        if (ctrl.pagingService.index > 1) {
                            ctrl.features = ctrl.features.concat(response.result);
                        } else {
                            ctrl.features = response.result;
                        }
                    }
                }, function (err) {
                    GeneralUtil.showMessageOnApiCallFailure(err);
                    ctrl.pagingService.allRetrieved = true;
                }).finally(function () {
                    ctrl.pagingService.pagingRetrivalOn = false;
                    Mask.hide();
                });
            }
        };

        ctrl.searchData = function (reset) {
            if (reset) {
                ctrl.pagingService.index = 0;
                ctrl.pagingService.allRetrieved = false;
                ctrl.pagingService.pagingRetrivalOn = false;
            }
            retrieveAll();
        };

        var init = function () {
            retrieveAll();
        }

        ctrl.changeStatusOfFeature = function (featureObject) {
            const modalInstance = $uibModal.open({
                templateUrl: 'app/common/views/confirmation.modal.html',
                controller: 'ConfirmModalController',
                windowClass: 'cst-modal',
                size: 'med',
                resolve: {
                    message: function () {
                        return "Are you sure you want to change status of this feature?";
                    }
                }
            });
            modalInstance.result.then(function () {
                const queryDto = {
                    code: 'update_mobile_feature_state',
                    parameters: {
                        feature: featureObject.mobile_constant,
                        state: (featureObject.state === 'ACTIVE' ? 'INACTIVE' : 'ACTIVE')
                    }
                };
                Mask.show();
                QueryDAO.executeQuery(queryDto).then(function (response) {
                    ctrl.searchData(true);
                    toaster.pop('success', 'Mobile Feature status changed Successfully.');
                }, function (err) {
                    GeneralUtil.showMessageOnApiCallFailure(err);
                }).finally(function () {
                    Mask.hide();
                });
            }, function () { });
        }

        ctrl.updateFeature = function (mobile_constant) {
            var modalInstance = $uibModal.open({
                templateUrl: 'app/manage/mobileFeatureManagement/views/mobile-feature.modal.html',
                controller: 'UpdateMobileFeatureModalController',
                controllerAs: '$ctrl',
                windowClass: 'cst-modal',
                size: 'lg',
                resolve: {
                    mobile_constant: function () {
                        return mobile_constant;
                    }
                }
            });
            modalInstance.result.then(function () {
                ctrl.searchData(true);
            }, function () { });
        };

        init();
    }

    angular.module('imtecho.controllers').controller('MobileFeatureManagementController', MobileFeatureManagementController);
})();
