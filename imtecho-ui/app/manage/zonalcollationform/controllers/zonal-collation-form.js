(function () {
    function ZonalCollationForm(QueryDAO, Mask, GeneralUtil, $state,AssociationsConstantsZonalForm) {
        let ctrl = this;

        ctrl.init = function () {
            ctrl.formObj = {};
            ctrl.getUserData();
        }

        ctrl.getUserData = function () {
            let dto = {
                code: 'retrieve_zcf_user_details',
                parameters: {
                    userId: $state.params.id
                }
            }
            Mask.show();
            QueryDAO.execute(dto).then(function(res) {
                ctrl.formObj.facility = res.result[0].facility || 'N/A';
                ctrl.formObj.zone = res.result[0].zone || 'N/A';
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
                        month:ctrl.formObj.month
                    },
                    sequence: 0
                },
                {
                    code: 'retrieve_mrf_member_details',
                    parameters: {
                        userId: $state.params.id,
                        month:ctrl.formObj.month
                    },
                    sequence: 1
                },
                {
                    code: 'retrieve_mrf_anc_details',
                    parameters: {
                        userId: $state.params.id,
                        month:ctrl.formObj.month
                    },
                    sequence: 2
                },
                {
                    code: 'retrieve_mrf_wpd_details',
                    parameters: {
                        userId: $state.params.id,
                        month:ctrl.formObj.month
                    },
                    sequence: 3
                },
                {
                    code: 'retrieve_mrf_pnc_details',
                    parameters: {
                        userId: $state.params.id,
                        month:ctrl.formObj.month
                    },
                    sequence: 4
                },
                {
                    code: 'retrieve_mrf_csv_details',
                    parameters: {
                        userId: $state.params.id,
                        month:ctrl.formObj.month
                    },
                    sequence: 5
                },
                {
                    code: 'retrieve_mrf_tb_details',
                    parameters: {
                        userId: $state.params.id,
                        month:ctrl.formObj.month
                    },
                    sequence: 6
                },
                {
                    code: 'retrieve_mrf_malaria_details',
                    parameters: {
                        userId: $state.params.id,
                        month:ctrl.formObj.month
                    },
                    sequence: 7
                },
                {
                    code: 'retrieve_mrf_hiv_details',
                    parameters: {
                        userId: $state.params.id,
                        month:ctrl.formObj.month
                    },
                    sequence: 8
                },
                {
                    code: 'retrieve_mrf_pregnancy_details',
                    parameters: {
                        userId: $state.params.id,
                        month:ctrl.formObj.month
                    },
                    sequence: 9
                }
                //queries not written for section with chw9.xx code 
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
                $('#zcf-form > *').css({
                    'line-height' : '0',
                    'padding' : '0',
                    'font-size' : '0.8rem'
                });
    
                $('#zcf-form').printThis({
                    importCSS: true,
                    formValue : true,
                    header: '',
                    base: "./",
                    pageTitle: 'Zonal Collation Form',
                    afterPrint: function () {
                        $('#zcf-form > *').css({
                            'line-height' : '',
                            'padding' : '',
                            'font-size' : ''
                        });
                    }
                }); 
            });
           
        };

        ctrl.printExcel = function(){
            let data = ctrl.formObj;
            let finalSet = {};
            for (let key in AssociationsConstantsZonalForm) {
                if (AssociationsConstantsZonalForm.hasOwnProperty(key)) {
                  var newKey = AssociationsConstantsZonalForm[key];
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
            XLSX.writeFile(wb, `Zonal Collation Form ${date}.xlsx`);
            
        }

        // Remove this function after all remanining datapoints are made available
        ctrl.markNA = function () {
            ctrl.formObj.facility = 'N/A';
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

            ctrl.formObj.chw8_01 = 'N/A';
            ctrl.formObj.chw8_02 = 'N/A';
            ctrl.formObj.chw8_03 = 'N/A';
            ctrl.formObj.chw8_04 = 'N/A';
            ctrl.formObj.chw9_01 = 'N/A';
            ctrl.formObj.chw9_02 = 'N/A';
            ctrl.formObj.chw9_04 = 'N/A';
            ctrl.formObj.chw9_05 = 'N/A';
            ctrl.formObj.chw9_07 = 'N/A';
            ctrl.formObj.chw9_08 = 'N/A';
            ctrl.formObj.chw9_10 = 'N/A';
            ctrl.formObj.chw9_11 = 'N/A';
            ctrl.formObj.chw9_16 = 'N/A';
            ctrl.formObj.chw9_17 = 'N/A';
            ctrl.formObj.chw9_19 = 'N/A';
            ctrl.formObj.chw9_20 = 'N/A';
            ctrl.formObj.chw9_22 = 'N/A';
            ctrl.formObj.chw9_23 = 'N/A';
            ctrl.formObj.chw9_25 = 'N/A';
            ctrl.formObj.chw9_26 = 'N/A';
            ctrl.formObj.chw9_28 = 'N/A';
            ctrl.formObj.chw9_29 = 'N/A';
            ctrl.formObj.chw9_31 = 'N/A';
            ctrl.formObj.chw9_32 = 'N/A';
            ctrl.formObj.chw9_34 = 'N/A';
            ctrl.formObj.chw9_35 = 'N/A';
            ctrl.formObj.chw9_61 = 'N/A';
            ctrl.formObj.chw9_62 = 'N/A';
            ctrl.formObj.chw9_63 = 'N/A';
            ctrl.formObj.chw9_64 = 'N/A';
            ctrl.formObj.chw9_65 = 'N/A';
            ctrl.formObj.chw9_66 = 'N/A';
            ctrl.formObj.chw9_67 = 'N/A';
            ctrl.formObj.chw9_68 = 'N/A';
            ctrl.formObj.chw9_69 = 'N/A';
            ctrl.formObj.chw9_70 = 'N/A';
            ctrl.formObj.chw9_71 = 'N/A';
            ctrl.formObj.chw9_72 = 'N/A';
            ctrl.formObj.chw9_73 = 'N/A';
            ctrl.formObj.chw9_74 = 'N/A';

        }
        
        ctrl.init();
    }
    angular.module('imtecho.controllers').controller('ZonalCollationForm', ZonalCollationForm);
})();