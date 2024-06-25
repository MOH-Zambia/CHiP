// (function (angular) {
//     var PregRegEditModal = function ($scope, $uibModalInstance, pregData, toaster, QueryDAO, Mask, GeneralUtil) {
//         $scope.pregId = pregData.pregId;
//         $scope.lmpDate = moment(pregData.lmpDate);
//         $scope.regDate = moment(pregData.regDate).format("MM-DD-YYYY");
//         $scope.ancDate = pregData.ancVisitDate;
//         if ($scope.ancDate) {
//             $scope.maxDate = moment($scope.ancDate, 'DD/MM/YYYY');
//         } else {
//             $scope.maxDate = $scope.regDate
//         }
//         $scope.preg = {};

//         $scope.ok = function () {
//             $scope.pregDateForm.$setSubmitted();
//             if ($scope.pregDateForm.$valid) {
//                 var queryDto = {
//                     code: 'preg_reg_date_edit_mark_incorrect',
//                     parameters: {
//                         pregId: Number($scope.pregId),
//                         pregDate: moment($scope.getDate($scope.preg.pregDate)).format('DD-MM-YYYY HH:mm:ss')
//                     }
//                 };
//                 Mask.show();
//                 QueryDAO.execute(queryDto).then(function (response) {
//                     Mask.hide();
//                     toaster.pop('success', "Date changed successfully");
//                     $uibModalInstance.close();
//                 }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
//                     Mask.hide();
//                     $uibModalInstance.close();
//                 });
//             }
//         };

//         $scope.getDate = (date) => {
//             return new Date(
//                 date.getFullYear(),
//                 date.getMonth(),
//                 date.getDate(),
//                 00,
//                 00
//             );
//         }

//         $scope.cancel = function () {
//             $uibModalInstance.dismiss('cancel');
//         };
//     };
//     angular.module('imtecho.controllers').controller('PregRegEditModal', PregRegEditModal);
// })(window.angular);
