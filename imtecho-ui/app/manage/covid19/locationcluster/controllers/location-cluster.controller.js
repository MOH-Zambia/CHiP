(function () {
    function LocationClusterMangementCtrl(Mask, QueryDAO, GeneralUtil, $uibModal, AuthenticateService, toaster, $state) {
        var locationClusterMangementCtrl = this;
        locationClusterMangementCtrl.locationClusters = [];

        locationClusterMangementCtrl.init = () => {
            Mask.show();
            AuthenticateService.getLoggedInUser().then((response) => {
                locationClusterMangementCtrl.currentUser = response.data;
                locationClusterMangementCtrl.getLocationClusters();
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        };

        locationClusterMangementCtrl.getLocationClusters = () => {
            Mask.show();
            QueryDAO.execute({
                code: 'covid19_get_location_clusters',
                parameters: {}
            }).then((response) => {
                locationClusterMangementCtrl.locationClusters = response.result;
            }).catch((error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            });
        };

        locationClusterMangementCtrl.onAddEditClick = (id) => {
            $state.go('techo.manage.manageLocationClusterManagement', { id: id });
        };

        locationClusterMangementCtrl.toggleLocationCluster = (locationCluster) => {
            var modalInstance = $uibModal.open({
                templateUrl: 'app/common/views/confirmation.modal.html',
                controller: 'ConfirmModalController',
                windowClass: 'cst-modal',
                size: 'med',
                resolve: {
                    message: () => {
                        return "Are you sure you want to change the status of this cluster ?";
                    }
                }
            });
            modalInstance.result.then(() => {
                Mask.show();
                QueryDAO.execute({
                    code: 'covid19_update_location_cluster_state',
                    parameters: {
                        state: locationCluster.toggle === 'Active' ? 'ACTIVE' : 'INACTIVE',
                        id: locationCluster.id
                    }
                }).then((response) => {
                    toaster.pop('success', "Cluster status changed successfully.");
                    locationCluster.state = locationCluster.toggle.toUpperCase();
                }).catch((error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                });
            });
        };

        locationClusterMangementCtrl.init();

    }
    angular.module('imtecho.controllers').controller('LocationClusterMangementCtrl', LocationClusterMangementCtrl);
})();
