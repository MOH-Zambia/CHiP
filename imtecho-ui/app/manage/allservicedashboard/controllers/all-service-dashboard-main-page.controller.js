(function () {
    function AllServiceDashboardMainPageController() {
        var ctrl = this;
        ctrl.toggleMenu = false

        ctrl.init = () => {
            ctrl.selectedTab = 'household'
            
        }

        ctrl.onSelectedTabChange = (tabname) => {
            ctrl.selectedTab = tabname
        }

        ctrl.init();

    }
    angular.module('imtecho.controllers').controller('AllServiceDashboardMainPageController', AllServiceDashboardMainPageController);
})();
