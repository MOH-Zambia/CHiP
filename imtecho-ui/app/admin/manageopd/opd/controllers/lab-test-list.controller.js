// (function (angular) {
//     function LabTestList(Mask, GeneralUtil, QueryDAO, $uibModal, toaster) {
//         var labTestConfiguration = this;
//         labTestConfiguration.labTestList = [];

//         var init = function () {
//             console.log('Hello')
//             labTestConfiguration.fetchLabTestDetails();
//         };

//         labTestConfiguration.fetchLabTestDetails = function () {
//             Mask.show();
//             QueryDAO.execute({
//                 code: 'get_all_lab_test',
//             }).then(function (res) {
//                 labTestConfiguration.labTestList = res.result;
//                 Mask.hide();
//             }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
//                 Mask.hide();
//             })
//         }

//         labTestConfiguration.toggleActive = function (labtest) {
//             var modalInstance = $uibModal.open({
//                 templateUrl: 'app/common/views/confirmation.modal.html',
//                 controller: 'ConfirmModalController',
//                 windowClass: 'cst-modal',
//                 size: 'med',
//                 resolve: {
//                     message: function () {
//                         return "Are you sure you want to change the state from " + (labtest.isActive ? 'ACTIVE' : 'INACTIVE') + ' to ' +
//                             (!labtest.isActive ? 'ACTIVE' : 'INACTIVE') + '? ';
//                     }
//                 }
//             });
//             modalInstance.result.then(function () {
//                 Mask.show();
//                 QueryDAO.execute({
//                     code: 'update_opd_lab_test_state',
//                     parameters: {
//                         state: !labtest.isActive,
//                         id: labtest.id
//                     }
//                 }).then(function (res) {
//                     labTestConfiguration.fetchLabTestDetails();
//                     Mask.hide();
//                     toaster.pop('success', 'State updated successfully!');

//                 }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
//                     Mask.hide();
//                 })
//             }, function () { });
//         };

//         init();
//     }
//     angular.module('imtecho.controllers').controller('LabTestList', LabTestList);
// })(window.angular);
