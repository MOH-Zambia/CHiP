(function (angular) {
    var ReasonModalTopicCtrl = function ($uibModalInstance, selectedTopic) {
        var $ctrl = this;
        $ctrl.topics = selectedTopic;
        $ctrl.topicReasonsList = ["Technical Issues", "Time not sufficient", "Have doubts myself", "Other Reasons"];

        $ctrl.submitTopicReason = function () {
            $ctrl.topics.completed = false;
            $ctrl.topics.completedOn = null;
            $ctrl.topics = null;
            $uibModalInstance.close();
        };

        $ctrl.cancelTopicReason = function () {
            $ctrl.topics.completed = true;
            $ctrl.topics.reason = null;
            $ctrl.topics.remarks = null;
            $ctrl.topics = null;
            $uibModalInstance.dismiss('cancel');
        };

        $ctrl.cancel = function () {
            $uibModalInstance.dismiss('cancel');
        };
    };
    angular.module('imtecho.controllers').controller('ReasonModalTopicCtrl', ReasonModalTopicCtrl);
})(window.angular);
