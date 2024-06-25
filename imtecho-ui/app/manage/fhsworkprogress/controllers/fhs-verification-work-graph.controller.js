// (function () {
//     function FhsWorkProgress(QueryDAO, AuthenticateService, Mask) {
//         var ctrl = this;
//         ctrl.options = {
//             scales: {
//                 yAxes: [{
//                     scaleLabel: {
//                         display: true,
//                         labelString: 'Percentage Verified',
//                         fontSize: 20
//                     },
//                     ticks: { min: 0, max: 100 }
//                 }],
//                 xAxes: [{
//                     scaleLabel: {
//                         display: true,
//                         labelString: 'Date',
//                         fontSize: 20
//                     }
//                 }]
//             }
//         };

//         ctrl.fetchData = function (locationId) {
//             if (locationId) {
//                 Mask.show();
//                 var queryDto = {
//                     code: "fhs_verifification_percentage",
//                     parameters: {
//                         locationId: locationId
//                     }
//                 }
//                 QueryDAO.execute(queryDto).then(function (res) {
//                     ctrl.result = res.result.reverse();
//                     ctrl.data = _.pluck(ctrl.result, 'percentage');
//                     ctrl.labels = _.pluck(ctrl.result, 'created_on')
//                 }).finally(function () {
//                     Mask.hide();
//                 });
//             }
//         }

//         AuthenticateService.getLoggedInUser().then(function (res) {
//             ctrl.userDetail = res.data;
//             ctrl.locationName = ctrl.userDetail.minLocationName;
//             ctrl.fetchData(res.data.minLocationId);
//         })

//         ctrl.toggleFilter = function () {
//             if (angular.element('.filter-div').hasClass('active')) {
//                 angular.element('body').css("overflow", "auto");
//             } else {
//                 angular.element('body').css("overflow", "hidden");
//             }
//             angular.element('.cst-backdrop').fadeToggle();
//             angular.element('.filter-div').toggleClass('active');
//         };

//         ctrl.submit = function () {
//             ctrl.fetchData(ctrl.selectedLocationId);
//             var level = 1;
//             var locationStr = '';
//             while (level <= ctrl.selectedLocation.finalSelected.level) {
//                 locationStr += ctrl.selectedLocation['level' + level].name + ' >';
//                 level++;
//             }
//             ctrl.locationName = locationStr.slice(0, -1);
//             ctrl.toggleFilter();
//         }
//     }
//     angular.module('imtecho.controllers').controller('FhsWorkProgress', FhsWorkProgress);
// })();
