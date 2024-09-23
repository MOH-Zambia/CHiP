(function () {
    function MonthlyFacilityReportingForm(QueryDAO, Mask, GeneralUtil, $state, AssociationsConstants) {
        let ctrl = this;

        ctrl.init = function () {
            ctrl.formObj = {};
        
        }


        ctrl.getFormData = function () {
            let dto = 
                {
                    code: 'retrieve_monthly_facility_details',
                    parameters: {
                        facilityId: $state.params.id,
                        month: moment(ctrl.month).format('YYYY-MM-DD HH:mm:ss')
                    }
                }
            Mask.show();
            QueryDAO.executeQuery(dto).then(function(res) {
                
                     ctrl.formObj = res.result[0];
                     console.log(ctrl.formObj)
                    }
                
            , GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                ctrl.markNA();
                Mask.hide();
            });
        }


        ctrl.printPdf = function () {
            $(document).ready(function(){
                $('#mrp-form > *').css({
                    'line-height': '0',
                    'padding': '0',
                    'font-size': '0.8rem'
                });
            
                $('#mrp-form').printThis({
                    importCSS: true,
                    formValue: true,
                    header: '',
                    base: "./",
                    pageTitle: 'Monthly Reporting Form',
                    afterPrint: function () {
                        $('#mrp-form > *').css({
                            'line-height': '',
                            'padding': '',
                            'font-size': ''
                        });
                    }
                });
            });
        }

        ctrl.printExcel = function(){
            let data = ctrl.formObj;
            let finalSet = {};
            for (let key in AssociationsConstants) {
                if (AssociationsConstants.hasOwnProperty(key)) {
                  var newKey = AssociationsConstants[key];
                  var value = data[key];
                  if(value != undefined)
                  finalSet[newKey] = value;
                }
              }
            let wb = XLSX.utils.book_new();
            let ws = XLSX.utils.json_to_sheet([]);

            let rowIndex = 0;
            for (let key in finalSet) {
                if (finalSet.hasOwnProperty(key)) {
                    let rowData = {};
                    rowData['Field'] = key; 
                    rowData['Value'] = finalSet[key];
                    XLSX.utils.sheet_add_json(ws, [rowData], { header: ['Field', 'Value'], skipHeader: true, origin: `A${++rowIndex}` });
                }
            }
            XLSX.utils.book_append_sheet(wb, ws, 'Sheet1');
            let date = new Date().toJSON();
            XLSX.writeFile(wb, `Monthly Reporting Form ${date}.xlsx`);
            
        }

        // Remove this function after all remanining datapoints are made available
        ctrl.markNA = function () {
            ctrl.formObj.totalCHA = 'N/A';
            ctrl.formObj.totalCHV = 'N/A';
            ctrl.formObj.reportedCHA = 'N/A';
            ctrl.formObj.reportedCHV = 'N/A';
            ctrl.formObj.timelyCHA = 'N/A';
            ctrl.formObj.timelyCHV = 'N/A';

            ctrl.formObj.chw1_02 = 'N/A';

            ctrl.formObj.chw2_07 = 'N/A';
            ctrl.formObj.chw2_08 = 'N/A';
            ctrl.formObj.chw2_09 = 'N/A';
            ctrl.formObj.chw2_12 = 'N/A';

            ctrl.formObj.chw3_01 = 'N/A';
            ctrl.formObj.chw3_09 = 'N/A';
            ctrl.formObj.chw3_11 = 'N/A';
            ctrl.formObj.chw3_12 = 'N/A';
            ctrl.formObj.chw3_13 = 'N/A';

            ctrl.formObj.chw4_04 = 'N/A';

            ctrl.formObj.chw5_07 = 'N/A';

            ctrl.formObj.chw7_01 = 'N/A';
            ctrl.formObj.chw7_02 = 'N/A';
            ctrl.formObj.chw7_03 = 'N/A';
            ctrl.formObj.chw7_04 = 'N/A';
            ctrl.formObj.chw7_05 = 'N/A';

            ctrl.formObj.nhcName = 'N/A';
            ctrl.formObj.nhcDesignation = 'N/A';
            ctrl.formObj.nhcSigned = 'N/A';
            
            ctrl.formObj.supervisorName = 'N/A';
            ctrl.formObj.supervisorDesignation = 'N/A';
            ctrl.formObj.supervisorSigned = 'N/A';

            ctrl.formObj.facilityStaffName = 'N/A';
            ctrl.formObj.facilityStaffDate = 'N/A';
            ctrl.formObj.facilityStaffSigned = 'N/A';
        }
        
        ctrl.init();
    }
    angular.module('imtecho.controllers').controller('MonthlyFacilityReportingForm', MonthlyFacilityReportingForm);
})();