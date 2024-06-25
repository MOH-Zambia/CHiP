(function (angular) {
    var ReasonModalAttendanceCtrl = function ($uibModalInstance, selectedParticipant) {
        var $ctrl = this;
        $ctrl.participants = selectedParticipant;
        $ctrl.reasonsList = ["Not Well", "Other Work", "Unknown"];

        $ctrl.submitReason = function () {
            $ctrl.participants.present = false;
            $ctrl.participants = null;
            $uibModalInstance.close();
        };

        $ctrl.cancelReason = function () {
            $ctrl.participants.present = true;
            $ctrl.participants.reason = null;
            $ctrl.participants.remarks = null;
            $ctrl.participants = null;
            $uibModalInstance.dismiss('cancel');
        };

        $ctrl.cancel = function () {
            $uibModalInstance.dismiss('cancel');
        };
    };
    angular.module('imtecho.controllers').controller('ReasonModalAttendanceCtrl', ReasonModalAttendanceCtrl);
})(window.angular);
