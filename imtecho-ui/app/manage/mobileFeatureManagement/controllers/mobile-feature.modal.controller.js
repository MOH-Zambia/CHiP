(function (angular) {
    var UpdateMobileFeatureModalController = function ($uibModalInstance, mobile_constant, toaster, Mask, QueryDAO, GeneralUtil, AuthenticateService) {
        var $ctrl = this;
        $ctrl.createFeatureFlag = false;
        $ctrl.updateFeatureFlag = false;
    
        if (mobile_constant === null) {
            $ctrl.createFeatureFlag = true;

            $ctrl.featureObject = {
                mobile_constant: '',
                feature_name: '',
                mobile_display_name: '',
                bean: [],
                form: []
            };
        } else {
            $ctrl.updateFeatureFlag = true;

            var queryDto = {
                code: 'mobile_feature_details',
                parameters: {
                    feature: mobile_constant
                }
            };
            Mask.show();
            QueryDAO.execute(queryDto).then(function (response) {
                Mask.hide();
                var result = response.result[0];
                $ctrl.featureObject = {
                    ...result,
                    bean: (result.bean === null ? [] : result.bean.replace('{','').replace('}','').split(',')),
                    form: (result.form === null ? [] : result.form.replace('{','').replace('}','').split(',').map((x) => parseInt(x, 10)))
                }
            }, function (err) {
                GeneralUtil.showMessageOnApiCallFailure(err);
            }).finally(function () {
                Mask.hide();
            });
        }

        $ctrl.getAllForms = function () {
            Mask.show();
            QueryDAO.execute({
                code: "mobile_form_list",
                parameters: {
                }
            }).then(function (res) {
                $ctrl.formsList = res.result;
            }).finally(function () {
                Mask.hide();

            });
        };

        $ctrl.getAllBeans = function () {
            Mask.show();
            QueryDAO.execute({
                code: "mobile_bean_list",
                parameters: {
                }
            }).then(function (res) {
                $ctrl.beansList = res.result;
            }).finally(function () {
                Mask.hide();

            });
        };

        $ctrl.ok = function () {
            $ctrl.featureUpdateForm.$setSubmitted();
            if ($ctrl.featureUpdateForm.$valid) {
                AuthenticateService.getLoggedInUser().then(function (user) {
                    var queryDto = {
                        code: 'insert_update_mobile_feature',
                        parameters: {
                            mobileConstant: $ctrl.featureObject.mobile_constant.trim().toUpperCase().replaceAll(' ', '_'),
                            featureName: $ctrl.featureObject.feature_name,
                            mobileDisplayName: $ctrl.featureObject.mobile_display_name,
                            beans: ($ctrl.featureObject.bean.length == 0 ? null : $ctrl.featureObject.bean.join()),
                            forms: ($ctrl.featureObject.form.length == 0 ? null : $ctrl.featureObject.form.join()),
                            userId: user.data.id
                        }
                    };
                    Mask.show();
                    QueryDAO.execute(queryDto).then(function (response) {
                        Mask.hide();
                        if (response) {
                            if ($ctrl.createFeatureFlag) {
                                toaster.pop('success', 'Feature added successfully');
                            } else {
                                toaster.pop('success', 'Feature updated successfully');
                            }
                        }
                        $uibModalInstance.close($ctrl.featureObject);
                    }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                        Mask.hide();
                    });
                });
            }
        };

        $ctrl.cancel = function () {
            $uibModalInstance.dismiss('cancel');
        };
        $ctrl.getAllForms();
        $ctrl.getAllBeans();
    };
    angular.module('imtecho.controllers').controller('UpdateMobileFeatureModalController', UpdateMobileFeatureModalController);
})(window.angular);
