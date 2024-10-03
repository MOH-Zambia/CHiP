(function () {
    function UserDetailsController(Mask, $uibModal, PagingForQueryBuilderService, $state, QueryDAO,  toaster, GeneralUtil) {
        let ctrl = this;
        ctrl.formCodeQueries = [
            {
                formCode : 'COVID_19_SCREENING',
                queryCode : 'covid_19_screening'
            },
            {
                formCode : 'HIV_POSITIVE',
                queryCode : 'hiv_positive'
            },
            {
                formCode : 'MALARIA_INDEX',
                queryCode : 'malaria_index'
            },
            {
                formCode : 'MALARIA_NON_INDEX',
                queryCode : 'malaria_non_index'
            },
            {
                formCode : 'CHIP_GBV_SCREENING',
                queryCode : 'chip_gbv_screening'
            },
            {
                formCode : 'ACTIVE_MALARIA',
                queryCode : 'active_malaria'
            },
            {
                formCode : 'PASSIVE_MALARIA',
                queryCode : 'passive_malaria'
            },
            {
                formCode : 'KNOWN_POSITIVE',
                queryCode : 'hiv_known'
            },
            {
                formCode : 'HIV_SCREENING',
                queryCode : 'hiv_screening'
            },
            {
                formCode : 'CHIP_TB',
                queryCode : 'chip_tb'
            },
            {
                formCode : 'EMTCT',
                queryCode : 'emtct'
            },
            {
                formCode : 'CHIP_TB_FOLLOW_UP',
                queryCode : 'chip_tb_follow_up'
            },
            {
                formCode : 'FHW_VAE',
                queryCode : 'fhw_vae'
            },
            {
                formCode : 'FHW_RIM',
                queryCode : 'fhw_rim'
            },
            {
                formCode : 'CHIP_FP_FOLLOW_UP',
                queryCode : 'fp_follow_up'
            },
            {
                formCode: 'HOUSEHOLD_LINE_LIST',
                queryCode:'household_linelist'
            }, 
            {
                formCode : 'FHW_WPD',
                queryCode : 'fhw_wpd'
            }, 
            {
                formCode : 'FHW_ANC',
                queryCode : 'fhw_anc'
            },
            {
                formCode: 'RCH_FACILITY_PNC',
                queryCode: 'fhw_pnc'
            },
            {
                formCode:'FHW_CS',
                queryCode:'fhw_cs'
            }
            




        ]
        ctrl.formattedFromDate = new Date($state.params.fromDate).toLocaleDateString('en-US', { month: '2-digit', day: '2-digit', year: 'numeric' });
        ctrl.formattedToDate = new Date( $state.params.toDate).toLocaleDateString('en-US', { month: '2-digit', day: '2-digit', year: 'numeric' });

        ctrl.init = function(){
            ctrl.pagingService = PagingForQueryBuilderService.initialize();
            ctrl.userDetails = [];
            ctrl.fetchList();
        }

        ctrl.customFilter = function (item) {
            if (!ctrl.searchText) {
                return true;
            }
        
            const searchTextLower = ctrl.searchText.toLowerCase();
            
            
            return (
                item.health_id.toLowerCase().includes(searchTextLower) ||
                item.full_name.toLowerCase().includes(searchTextLower)
            );
        };
        

        ctrl.fetchList = function (){
            Mask.show();
            ctrl.qCode = ctrl.formCodeQueries.find((item) => item.formCode == $state.params.formName);

            ctrl.nameOfForm=ctrl.qCode.formCode
            ctrl.nameOfForm=ctrl.nameOfForm.replace('CHIP', '').replace(/_/g, ' ')
            
            let dto = {
                code : ctrl.qCode.queryCode,
                parameters : {
                    from_date : ctrl.formattedFromDate,
                    to_date : ctrl.formattedToDate,
                    location_id : parseInt($state.params.locationId),
                    limit: ctrl.pagingService.limit,
                    offset: ctrl.pagingService.offSet
                }
            }
            
            ctrl.pagingService.getNextPage(QueryDAO.execute, dto,  ctrl.userDetails, null ).then((response) => {
                if (response.length === 0 || response.length === ctrl.userDetails.length) {
                    ctrl.pagingService.allRetrieved = true;
                }else{
                    ctrl.pagingService.allRetrieved = false;
                }
                ctrl.userDetails = response;
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });

        }

       

        ctrl.openForm = function(memberId) {
            // Construct the URL with the parameters
            const url = $state.href("techo.admin.genericForm", {
                config: {
                    id: memberId,
                    formCode: ctrl.qCode.formCode
                }
            });

            sessionStorage.setItem('linkClick', 'true');

        
            // Open the URL in a new tab
            window.open(url, '_blank');
        };

        ctrl.init();
    }
    angular.module('imtecho.controllers').controller('UserDetailsController', UserDetailsController);
})();