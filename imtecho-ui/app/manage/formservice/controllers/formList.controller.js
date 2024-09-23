(function () {
    function FormListController(Mask, $uibModal, AuthenticateService, $state, $q, QueryDAO,  toaster) {
        let ctrl = this;

        ctrl.init = function (){
            ctrl.toggleFilter();
        }

        ctrl.toggleFilter = function () {
            if (angular.element('.filter-div').hasClass('active')) {
                angular.element('body').css("overflow", "auto");
            } else {
                angular.element('body').css("overflow", "hidden");
            }
            angular.element('.cst-backdrop').fadeToggle();
            angular.element('.filter-div').toggleClass('active');
        };

        ctrl.search = function() {
            const formattedFromDate = new Date(ctrl.fromDate).toLocaleDateString('en-US', { month: '2-digit', day: '2-digit', year: 'numeric' });
            const formattedToDate = new Date(ctrl.toDate).toLocaleDateString('en-US', { month: '2-digit', day: '2-digit', year: 'numeric' });
            ctrl.currFromDate=formattedFromDate
            ctrl.currToDate=formattedToDate

            let dto = {
                code : 'fetch_list_of_services',
                parameters : {
                    location_id: ctrl.locationId,
                    from_date : formattedFromDate,
                    to_date : formattedToDate
                }
            }
            QueryDAO.executeQuery(dto).then((res) => {
                ctrl.list = res.result;
              
                ctrl.toggleFilter();
            })
        }

        ctrl.openList = function(formName, obj) {
            const formattedFromDate = new Date(ctrl.fromDate).toLocaleDateString('en-US', { month: '2-digit', day: '2-digit', year: 'numeric' });
            const formattedToDate = new Date(ctrl.toDate).toLocaleDateString('en-US', { month: '2-digit', day: '2-digit', year: 'numeric' });
            
            // Construct the URL with the parameters
            const url = $state.href('techo.manage.userdetails', {
                formName: formName,
                locationId: obj.hidden_location_id,
                fromDate: formattedFromDate,
                toDate: formattedToDate
            });

            sessionStorage.setItem('linkClick', 'true');
            
            // Open the URL in a new tab
            window.open(url, '_blank');
        };

        ctrl.today = new Date()


        ctrl.init();
    }
    angular.module('imtecho.controllers').controller('FormListController', FormListController);
})();