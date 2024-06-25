(function (angular) {
    function ToggleController(data, $uibModalInstance, TranslationDAO, toaster, GeneralUtil, Mask) {
        ctrl = this
        ctrl.apps = angular.copy(data[0].map((item) => {
            return {
                app: item.app, appvalue: item.appvalue, is_active: item.is_active
            }
        }).filter((item, index, self) => {
            return index === self.findIndex((t) => (
                t.app === item.app && t.appvalue === item.appvalue
            ));
        }))
        ctrl.key = data[1]

        ctrl.update = function () {
            let error = false
            for (app of ctrl.apps) {
                Mask.show();
                TranslationDAO.toggleActive(ctrl.key, app.is_active, app.app).then(() => {
                }, (error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                    error = true
                }).finally(() => {
                    Mask.hide();
                    $uibModalInstance.close();
                })
            }
            if (!error) { toaster.pop('success', 'States updated successfully') }

        }

        ctrl.close = function () {
            $uibModalInstance.close();
        }
    } angular.module('imtecho.controllers').controller('ToggleController', ToggleController);
})(window.angular);
