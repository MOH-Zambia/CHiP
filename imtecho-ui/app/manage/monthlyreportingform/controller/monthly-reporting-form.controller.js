(function () {
    function MonthlyReportingForm(QueryDAO, Mask, GeneralUtil, $state, AssociationsConstants) {
        let ctrl = this;

        ctrl.init = function () {
            ctrl.formObj = {};
            ctrl.getUserData();
        }

        ctrl.getUserData = function () {
            let dto = {
                code: 'retrieve_mrf_user_details',
                parameters: {
                    userId: $state.params.id
                }
            }
            Mask.show();
            QueryDAO.execute(dto).then(function(res) {
                ctrl.formObj.chw = res.result[0].chw;
                ctrl.formObj.zone = res.result[0].zone;
                ctrl.formObj.zonewiseHHCount = res.result[0].zonewiseHHCount;
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        }

        ctrl.getFormData = function () {
            let dtoList = [
                {
                    code: 'retrieve_mrf_family_details',
                    parameters: {
                        userId: $state.params.id,
                        month: ctrl.month
                    },
                    sequence: 0
                },
                {
                    code: 'retrieve_mrf_member_details',
                    parameters: {
                        userId: $state.params.id,
                        month: ctrl.month
                    },
                    sequence: 1
                },
                {
                    code: 'retrieve_mrf_anc_details',
                    parameters: {
                        userId: $state.params.id,
                        month: ctrl.month
                    },
                    sequence: 2
                },
                {
                    code: 'retrieve_mrf_wpd_details',
                    parameters: {
                        userId: $state.params.id,
                        month: ctrl.month
                    },
                    sequence: 3
                },
                {
                    code: 'retrieve_mrf_pnc_details',
                    parameters: {
                        userId: $state.params.id,
                        month: ctrl.month
                    },
                    sequence: 4
                },
                {
                    code: 'retrieve_mrf_csv_details',
                    parameters: {
                        userId: $state.params.id,
                        month: ctrl.month
                    },
                    sequence: 5
                },
                {
                    code: 'retrieve_mrf_tb_details',
                    parameters: {
                        userId: $state.params.id,
                        month: ctrl.month
                    },
                    sequence: 6
                },
                {
                    code: 'retrieve_mrf_malaria_details',
                    parameters: {
                        userId: $state.params.id,
                        month: ctrl.month
                    },
                    sequence: 7
                },
                {
                    code: 'retrieve_mrf_hiv_details',
                    parameters: {
                        userId: $state.params.id,
                        month: ctrl.month
                    },
                    sequence: 8
                },
                {
                    code: 'retrieve_mrf_pregnancy_details',
                    parameters: {
                        userId: $state.params.id,
                        month: ctrl.month
                    },
                    sequence: 9
                }
            ];
            Mask.show();
            QueryDAO.executeAll(dtoList).then(function(res) {
                for (let val = 0; val < dtoList.length; val++){
                    for (let key in res[val].result[0]) {
                        ctrl.formObj[key] = res[val].result[0][key];
                    }
                }
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
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
    angular.module('imtecho.controllers').controller('MonthlyReportingForm', MonthlyReportingForm);
})();