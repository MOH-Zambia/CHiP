// (function (angular) {
//     function DuplicateAadhaarVerificationController(Mask, toaster, GeneralUtil, AadhaarVerificationDao) {
//         var ctrl = this;
//         ctrl.duplicateData = [];
//         ctrl.items = [];
//         ctrl.pagingService = {
//             offSet: 0,
//             limit: 100,
//             index: 0,
//             allRetrieved: false,
//             pagingRetrivalOn: false
//         };
//         ctrl.selectedData = {};

//         ctrl.searchData = function (reset, toggle) {
//             ctrl.searchForm.$setSubmitted();
//             if (ctrl.searchForm.$valid) {
//                 if (reset) {
//                     if (toggle) {
//                         ctrl.toggleFilter();
//                     }
//                     ctrl.pagingService.index = 0;
//                     ctrl.pagingService.allRetrieved = false;
//                     ctrl.pagingService.pagingRetrivalOn = false;
//                     ctrl.duplicateData = [];
//                 }
//                 ctrl.retrieveDuplicateAadhaarRecords();
//             }
//         }

//         let setOffsetLimit = function () {
//             ctrl.pagingService.limit = 100;
//             ctrl.pagingService.offSet = ctrl.pagingService.index * 100;
//             ctrl.pagingService.index = ctrl.pagingService.index + 1;
//         };

//         ctrl.retrieveDuplicateAadhaarRecords = function () {
//             if (!ctrl.pagingService.pagingRetrivalOn && !ctrl.pagingService.allRetrieved) {
//                 ctrl.pagingService.pagingRetrivalOn = true;
//                 setOffsetLimit();
//                 Mask.show();
//                 AadhaarVerificationDao.getDuplicateAadhaarMembers(ctrl.selectedLocationId, ctrl.pagingService.limit, ctrl.pagingService.offSet).then((res) => {
//                     if (res.length === 0 || res.length < ctrl.pagingService.limit) {
//                         ctrl.pagingService.allRetrieved = true;
//                         ctrl.duplicateData = ctrl.duplicateData.concat(res);
//                     } else {
//                         ctrl.pagingService.allRetrieved = false;
//                         ctrl.duplicateData = ctrl.duplicateData.concat(res);
//                     }
//                     if (ctrl.duplicateData.length == 0) {
//                         toaster.pop('danger', 'No Record found')
//                     }
//                 }).catch((error) => {
//                     GeneralUtil.showMessageOnApiCallFailure(error);
//                     ctrl.pagingService.allRetrieved = true;
//                 }).finally(function () {
//                     ctrl.pagingService.pagingRetrivalOn = false;
//                     Mask.hide();
//                 });

//             }
//         }

//         ctrl.saveAadhaarDetails = function () {
//             ctrl.aadhaarVerificationForm.$setSubmitted()
//             if (ctrl.aadhaarVerificationForm.$valid) {
//                 const areAadhaarNumbersUnique = ctrl.hasUniqueAadhaarNumbers(ctrl.selectedData.memberDetails);
//                 if (areAadhaarNumbersUnique) {
//                     const updatedAadhaarArr = ctrl.selectedData.memberDetails.map(member => ({
//                         id: member.id,
//                         uniqueHealthId: member.uniqueHealthId,
//                         aadhaarNumber: member.aadhaarNumber,
//                         nameAsPerAadhaar: member.nameAsPerAadhaar,
//                         name: member.firstName + ' ' + member.lastName
//                     }))

//                     Mask.show();
//                     AadhaarVerificationDao.updateAllAadhaarDetails({ memberDetails: updatedAadhaarArr }).then((res) => {
//                         toaster.pop("success", "Aadhaar updated successfully");
//                         ctrl.closeModal();
//                         ctrl.searchData(true, false);
//                     }).catch((error) => {
//                         GeneralUtil.showMessageOnApiCallFailure(error);
//                     }).finally(Mask.hide);

//                 } else {
//                     toaster.pop('error', 'Same Aadhaar Number Found for different members.');
//                     return;
//                 }
//             }
//         }

//         ctrl.hasUniqueAadhaarNumbers = function (memberDetails) {
//             const aadhaarNumbersSet = new Set();
//             for (const member of memberDetails) {
//                 const aadhaarNumber = member.aadhaarNumber;
//                 if (aadhaarNumbersSet.has(aadhaarNumber)) {
//                     // Duplicate Aadhaar number found
//                     return false;
//                 }
//                 aadhaarNumbersSet.add(aadhaarNumber);
//             }
//             return true;
//         }

//         ctrl.downloadExcelFunc = function() 
//         {
//             ctrl.items = [];
//              for (let i = 0; i < ctrl.duplicateData.length; i++) {
//                 var members = [];
//                 var memberDetails = "";
//                 for(let j = 0; j < ctrl.duplicateData[i].memberDetails.length; j++)
//                 {
//                   memberDetails += (j+1) + ") " + (ctrl.duplicateData[i].memberDetails[j].uniqueHealthId) + " (" + (ctrl.duplicateData[i].memberDetails[j].familyId) + ") " +  (ctrl.duplicateData[i].memberDetails[j].firstName) + " " + (ctrl.duplicateData[i].memberDetails[j].middleName) + " " +(ctrl.duplicateData[i].memberDetails[j].lastName) + ", " + 
//                    "(" + (ctrl.duplicateData[i].memberDetails[j].mobileNumber || "N.A") +") " + ", " + "(DOB :-" + moment((ctrl.duplicateData[i].memberDetails[j].dob)).format('DD/MM/YYYY') + ")" + "\n";
//                 }
//                 members.push(memberDetails);
//                  var excelObj = {
//                 "Sr No": (i+1),
//                 "Masked Aadhaar Number": (ctrl.duplicateData[i].maskedAadhaarNumber || "N.A" ),
//                 "Members": members };
//                ctrl.items.push(excelObj);
//               }

//             ctrl.pdffilename = "Duplicate Aadhaar Details of " + ctrl.selectedLocation?.finalSelected?.optionSelected?.name;
      


//             var mystyle = {
//                 headers: true,
//                 column: { style: { Font: { Bold: "1" } } }
//             };
//             alasql('SELECT * INTO XLSX("' + ctrl.pdffilename + '",?) FROM ?', [mystyle, ctrl.items]);
       



//         }

//         ctrl.close = function () {
//             ctrl.searchForm.$setPristine();
//             ctrl.toggleFilter();
//         };

//         ctrl.closeModal = function () {
//             if (ctrl.selectedData && ctrl.selectedData.memberDetails) {
//                 ctrl.selectedData.memberDetails.forEach(member => {
//                     delete member.aadhaarNumber;
//                     delete member.nameAsPerAadhaar;
//                 })
//             }
//             ctrl.selectedData = {};
//             ctrl.aadhaarVerificationForm.$setPristine();
//             $("#duplicateAadhaar").modal('hide');
//         }

//         /**
//          * Show assigned new feature modal
//          */
//         ctrl.aadhaarVerificationModal = function (data) {
//             ctrl.selectedData = data;
//             $("#duplicateAadhaar").modal({ backdrop: 'static', keyboard: false });
//         }

//         ctrl.toggleFilter = function () {
//             if (angular.element('.filter-div').hasClass('active')) {
//                 angular.element('body').css("overflow", "auto");
//             } else {
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
//     }
//     angular.module('imtecho.controllers').controller('DuplicateAadhaarVerificationController', DuplicateAadhaarVerificationController);
// })(window.angular);