// (function () {
//     function ServiceDeliveryLocationController(QueryDAO, Mask, GeneralUtil, toaster, AuthenticateService, $uibModal, LocationService) {
//         var ctrl = this;
//         ctrl.lineChart = {};
//         ctrl.showbar = true;
//         ctrl.labelIdMapping = [];
//         ctrl.locationHistory = [];
//         ctrl.selectedLocation = undefined;
//         ctrl.selectedLocationInfo = undefined;

//         ctrl.back = function () {
//             ctrl.locationHistory.pop();
//             ctrl.selectedLocationId = ctrl.locationHistory[ctrl.locationHistory.length - 1];
//             ctrl.retrieveLineChartData();
//             ctrl.retrieveBarChartData();
//         }

//         ctrl.onClickBarChartFunction = function (data) {
//             if (data.length > 0) {
//                 var label = data[0]._model.label;
//                 for (var index = 0; index < ctrl.labelIdMapping.length; index++) {
//                     if (ctrl.labelIdMapping[index].name == label) {
//                         var selectedElement = ctrl.labelIdMapping[index].data;
//                         if (selectedElement.type == 'A' || selectedElement.type == 'AA') {
//                             ctrl.showLineList(selectedElement);
//                         } else {
//                             ctrl.selectedLocationId = selectedElement.parent_id;
//                             ctrl.locationHistory.push(ctrl.selectedLocationId);
//                             ctrl.retrieveLineChartData();
//                             ctrl.retrieveBarChartData();
//                         }
//                         break;
//                     }
//                 }
//             }
//         }

//         ctrl.setBargraph = function (locationData) {
//             if (locationData.length > 0) {
//                 ctrl.emptyDataMassageFlag = false;
//                 ctrl.labels = [];
//                 ctrl.correct = [];
//                 ctrl.incorrect = [];
//                 ctrl.notfound = [];
//                 ctrl.labelIdMapping = [];
//                 for (var i = 0; i < locationData.length; i++) {
//                     ctrl.correct.push(locationData[i].correct || null);
//                     ctrl.incorrect.push(locationData[i].incorrect || null);
//                     ctrl.notfound.push(locationData[i].notfound || null);
//                     ctrl.labels.push(locationData[i].name);
//                     var json = {};
//                     json['name'] = locationData[i].name
//                     json['data'] = locationData[i];
//                     ctrl.labelIdMapping.push(json);
//                 }
//                 ctrl.bars = [ctrl.correct, ctrl.incorrect, ctrl.notfound];
//             } else {
//                 ctrl.locationHistory.pop();
//                 toaster.pop('error', 'No data found');
//                 ctrl.emptyDataMassageFlag = true;
//                 ctrl.emptyDataMassage = "No records found...";
//             }
//         };

//         ctrl.setLineChart = function (response) {
//             response.result.forEach(function (res) {
//                 ctrl.lineChart.labels.push(res.service_date_view);
//                 if (res.correct != null) {
//                     ctrl.lineChart.correctData.push(res.correct);
//                 } else {
//                     ctrl.lineChart.correctData.push(0);
//                 }
//                 if (res.incorrect != null) {
//                     ctrl.lineChart.incorrectData.push(res.incorrect);
//                 } else {
//                     ctrl.lineChart.incorrectData.push(0);
//                 }
//                 if (res.notfound != null) {
//                     ctrl.lineChart.notfoundData.push(res.notfound);
//                 } else {
//                     ctrl.lineChart.notfoundData.push(0);
//                 }
//             });
//             ctrl.lineChart.data = [ctrl.lineChart.correctData, ctrl.lineChart.incorrectData, ctrl.lineChart.notfoundData]
//         }

//         ctrl.initBarChart = function () {
//             ctrl.showbar = true;
//             ctrl.series = ['Correct', 'Incorrect', 'Not known'];
//             ctrl.chartOptions = {
//                 legend: {
//                     display: true
//                 },
//                 plugins: {
//                     labels: {
//                         fontSize: 10 // fix label overlapping issue
//                     }
//                 },
//                 scales: {
//                     yAxes: [{
//                         id: 'y-axis-1', type: 'linear', position: 'left',
//                         ticks: {
//                             min: 0,
//                             beginAtZero: true,
//                             callback: function (value, index, values) {
//                                 if (Math.floor(value) === value) {
//                                     return value;
//                                 }
//                             }
//                         },
//                         scaleLabel: {
//                             display: true,
//                             labelString: 'Services'
//                         }
//                     }],
//                     xAxes: [
//                         {
//                             scaleLabel: {
//                                 display: true,
//                                 labelString: 'Locations'
//                             },
//                             ticks: {
//                                 autoSkip: false,
//                             }
//                         }
//                     ]
//                 }
//             };
//             ctrl.colors = [
//                 {
//                     backgroundColor: '#4caf50' // bar chart color for importedFromEmamta -rgba(247,70,74,1)
//                 },
//                 {
//                     backgroundColor: '#ff4d4d'// bar chart color for Verified - #46BFBD
//                 },
//                 {
//                     backgroundColor: '#ffdb4d' // bar chart color for Archived - #DCDCDC
//                 },
//                 {
//                     backgroundColor: '#F2AF29' // bar chart color for unverified - #868e96
//                 },
//                 {
//                     backgroundColor: '#90BE6D' // bar chart color for New Families Added - #2db54f(Green)
//                 }
//             ];
//         }

//         ctrl.initLineChart = function () {
//             ctrl.lineChart.labels = [];
//             ctrl.lineChart.series = ['Correct', 'Incorrect', 'Not known'];
//             ctrl.lineChart.options = {
//                 scales: {
//                     yAxes: [
//                         {
//                             id: 'y-axis-1',
//                             type: 'linear',
//                             display: true,
//                             scaleLabel: {
//                                 display: true,
//                                 labelString: 'Services'
//                             }
//                         }
//                     ],
//                     xAxes: [
//                         {
//                             scaleLabel: {
//                                 display: true,
//                                 labelString: 'Service Date'
//                             },
//                             ticks: {
//                                 autoSkip: true,
//                             }
//                         }
//                     ]
//                 }, elements: {
//                     line: {
//                         fill: false
//                     }
//                 }, legend: {
//                     display: false,
//                 }
//             };
//             ctrl.lineChart.datasetOverride = [{ yAxisID: 'y-axis-1' }];
//             ctrl.lineChart.data = [];
//             ctrl.lineChart.correctData = [];
//             ctrl.lineChart.incorrectData = [];
//             ctrl.lineChart.notfoundData = [];
//         }

//         ctrl.createLineChart = function (response) {
//             ctrl.initLineChart();
//             ctrl.setLineChart(response);
//         }

//         ctrl.createBarChart = function (response) {
//             ctrl.initBarChart();
//             ctrl.setBargraph(response.result);
//         }

//         ctrl.retrieveLineChartData = function () {
//             var serviceDateDto = {
//                 code: "get_service_by_service_date",
//                 parameters: {
//                     locationId: ctrl.selectedLocationId,
//                     fromDate: ctrl.fromDate,
//                     toDate: ctrl.toDate
//                 }
//             };
//             Mask.show();
//             QueryDAO.execute(serviceDateDto).then(function (response) {
//                 Mask.hide();
//                 ctrl.createLineChart(response);
//             }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
//                 Mask.hide();
//             });
//         }
//         ctrl.retrieveBarChartData = function () {
//             LocationService.retrieveById(ctrl.selectedLocationId).then(function (res) {
//                 ctrl.selectedLocationInfo = res;
//             });
//             var locationDto = {
//                 code: "get_service_by_location",
//                 parameters: {
//                     locationId: ctrl.selectedLocationId,
//                     fromDate: ctrl.fromDate,
//                     toDate: ctrl.toDate
//                 }
//             };
//             Mask.show();
//             QueryDAO.execute(locationDto).then(function (response) {
//                 Mask.hide();
//                 ctrl.createBarChart(response);
//             }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
//                 Mask.hide();
//             });
//         }

//         ctrl.searchData = function () {
//             ctrl.searchForm.$setSubmitted();
//             if (ctrl.searchForm.$valid) {
//                 ctrl.locationHistory = [];
//                 ctrl.toDate = moment().format("DD-MM-YYYY");
//                 if (ctrl.dateFilter === 'last7Days') {
//                     ctrl.fromDate = moment().subtract(7, 'days').format("DD-MM-YYYY");
//                     ctrl.dateFilterText = 'last 7 days';
//                 } else if (ctrl.dateFilter === 'last30Days') {
//                     ctrl.fromDate = moment().subtract(30, 'days').format("DD-MM-YYYY");
//                     ctrl.dateFilterText = 'last 30 days';
//                 } else if (ctrl.dateFilter === 'last60Days') {
//                     ctrl.fromDate = moment().subtract(60, 'days').format("DD-MM-YYYY");
//                     ctrl.dateFilterText = 'last 60 days';
//                 } else if (ctrl.dateFilter === 'last90Days') {
//                     ctrl.dateFilterText = 'last 90 days';
//                     ctrl.fromDate = moment().subtract(90,'days').format('DD-MM-YYYY');
//                 }
//                 ctrl.locationHistory.push(ctrl.selectedLocationId);
//                 ctrl.retrieveLineChartData();
//                 ctrl.retrieveBarChartData();
//                 ctrl.toggleFilter()
//             }
//         }

//         ctrl.toggleFilter = function () {
//             if (angular.element('.filter-div').hasClass('active')) {
//                 ctrl.modalClosed = true;
//                 angular.element('body').css("overflow", "auto");
//             } else {
//                 ctrl.modalClosed = false;
//                 angular.element('body').css("overflow", "hidden");
//             }
//             angular.element('.cst-backdrop').fadeToggle();
//             angular.element('.filter-div').toggleClass('active');
//             if (CKEDITOR.instances) {
//                 for (var ck_instance in CKEDITOR.instances) {
//                     CKEDITOR.instances[ck_instance].destroy();
//                 }
//             }
//         };

//         ctrl.showLineList = function (location) {
//             ctrl.showLineListModel(location);
//         }

//         ctrl.showLineListModel = function (location) {
//             var modalInstance = $uibModal.open({
//                 templateUrl: 'app/manage/servicedeliverylocation/views/service-delivery-line-list.html',
//                 controller: 'ServiceDeliveryLineListController as serviceDeliveryLineList',
//                 windowClass: 'cst-modal',
//                 size: 'xl',
//                 resolve: {
//                     location: function () {
//                         location.fromDate = ctrl.fromDate;
//                         location.toDate = ctrl.toDate;
//                         return location;
//                     }
//                 }
//             });
//             modalInstance.result.then(function () {
//                 Mask.show();
//                 MigrationDAO.confirmMember(ctrl.inMemberMigrationDto.id, member).then(function () {
//                     toaster.pop('success', "Member Confirmed Successfully");
//                 }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
//                     Mask.hide();
//                 });

//             }, function () {

//             });
//         };

//         ctrl.init = function () {
//             AuthenticateService.getLoggedInUser().then(function (user) {
//                 ctrl.selectedLocationId = user.data.minLocationId;
//                 ctrl.dateFilter = 'last7Days';
//                 ctrl.dateFilterText = 'last 7 days';
//                 ctrl.toDate = moment().format("DD-MM-YYYY");
//                 ctrl.fromDate = moment().subtract(7, 'days').format("DD-MM-YYYY");
//                 ctrl.locationHistory.push(ctrl.selectedLocationId);
//                 ctrl.retrieveLineChartData();
//                 ctrl.retrieveBarChartData();
//             });
//         };

//         ctrl.init();

//     }
//     angular.module('imtecho.controllers').controller('ServiceDeliveryLocationController', ServiceDeliveryLocationController);

// })();
