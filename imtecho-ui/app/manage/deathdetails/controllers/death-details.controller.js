// (function (angular) {
//     function DeathDetailsController (QueryDAO, Mask, GeneralUtil, $scope, toaster) {
//         const ctrl = this;
//         ctrl.appName = GeneralUtil.getAppName();
//         $scope.ctrl = ctrl;
//         ctrl.requiredLocationLevel = 4; // Block Level
//         ctrl.fileNamePrefix = "Death_Details_";
//         ctrl.noDataFound = true;
//         ctrl.showMemberDetBtn = false;
//         ctrl.showFamilyDetBtn = false;

//         ctrl.onSearch = () => {
//             ctrl.filterForm.$setSubmitted();
//             if (ctrl.selectedLocation && ctrl.requiredLocationLevel <= ctrl.selectedLocation.finalSelected.level && ctrl.filterForm.$valid) {
//                 let dtoList = [];
//                 let dto = {
//                     code: 'retrieve_deathdet_member_details',
//                     parameters: {
//                         from_date: moment(ctrl.fromDate).format('MM/DD/YYYY'),
//                         to_date: moment(ctrl.toDate).format('MM/DD/YYYY'),
//                         locationId: ctrl.selectedLocationId
//                     },
//                     sequence: 1
//                 };
//                 dtoList.push(dto);
//                 let dto1 = {
//                     code: 'retrieve_deathdet_family_contact_details',
//                     parameters: {
//                         from_date: moment(ctrl.fromDate).format('MM/DD/YYYY'),
//                         to_date: moment(ctrl.toDate).format('MM/DD/YYYY'),
//                         locationId: ctrl.selectedLocationId
//                     },
//                     sequence: 2
//                 }
//                 dtoList.push(dto1);

//                 Mask.show();
//                 QueryDAO.executeAll(dtoList).then(response => {
//                     if (Array.isArray(response[0].result) && response[0].result.length > 0) {
//                         ctrl.memberData = response[0].result;
//                     }       
//                     if (Array.isArray(response[1].result) && response[1].result.length > 0) {
//                         ctrl.familyDetData = response[1].result;
//                     }
//                     if (ctrl.memberData || ctrl.familyDetData) {
//                         toaster.pop('Success', "Click button to download .csv file");
//                     }
//                 }, GeneralUtil.showMessageOnApiCallFailure)
//                 .finally(() => { Mask.hide(); ctrl.toggleFilter(); });
//             }
//         };

//         ctrl.toggleFilter = () => {
//             if (angular.element('.filter-div').hasClass('active')) {
//                 angular.element('body').css("overflow", "auto");
//             } else {
//                 angular.element('body').css("overflow", "hidden");
//             }
//             angular.element('.cst-backdrop').fadeToggle();
//             angular.element('.filter-div').toggleClass('active');
//         };

//         ctrl.generateExcel = (entity) => {
//             ctrl.fileName = '';
//             ctrl.excelObjects = [];
//             if (entity === 'MEMBER') {
//                 ctrl.fileName = ctrl.fileNamePrefix + 'Death_Person_Details';
//                 ctrl.memberData.forEach(obj => {
//                     ctrl.excelObjects.push({
//                         "unique_health_id": obj.unique_health_id,
//                         "family_id": obj.family_id,
//                         "areaId": obj.areaId,
//                         "Latitude": obj.latitude,
//                         "Longitude": obj.longitude,
//                         "contact_person": obj.contact_person,
//                         "contact_number": obj.contact_number,
//                         "address": obj.address,
//                         "death_name": obj.death_name,
//                         "dob": obj.dob,
//                         "age": obj.age,
//                         "dod": obj.dod,
//                         "health_worker": obj.health_worker,
//                         "hw_contac": obj.hw_contact,
//                         "sex":obj.sex
//                     });
//                 })
//             } else if (entity === 'FAMILY') {
//                 ctrl.fileName = ctrl.fileNamePrefix + 'Family_Contact_Details';
//                 ctrl.familyDetData.forEach(obj => {
//                     ctrl.excelObjects.push({
//                         "family_id": obj.family_id,
//                         "unique_health_id": obj.unique_health_id,
//                         "member_name": obj.member_name,
//                         "contact_number": obj.contact_number,
//                         "dob": obj.dob,
//                         "age": obj.age
//                     });
//                 })
//             }
//             ctrl.downloadExcel(ctrl.excelObjects);
//         };

//         ctrl.downloadExcel = (data) => {
//             let customStyle = {
//                 headers: true
//             };  
//             let dataCopy = angular.copy(data);
//             dataCopy = JSON.parse(JSON.stringify(dataCopy));
            
//             alasql('SELECT * INTO CSV("' + ctrl.fileName + '",?) FROM ?', [customStyle, dataCopy]);
//         }
//     }
//     angular.module('imtecho.controllers').controller('DeathDetailsController', DeathDetailsController);
// })(window.angular);