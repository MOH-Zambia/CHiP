(function (angular) {
    let FormObjectModalController = function ($scope, $uibModalInstance, $uibModal, config, toaster) {

        $scope.init = () => {
            if (config.formObject != null) {
                $scope.rootObject = config.formObject;
            } else {
                $scope.rootObject = [{
                    "title": "$formData$",
                    "isArray": false,
                    "nodes": [],
                    "path": "$formData$"
                }, {
                    "title": "$infoData$",
                    "isArray": false,
                    "nodes": [],
                    "path": "$infoData$"
                }];
            }

            $scope.addPaths($scope.rootObject);
            $scope.addBackendConfigPath($scope.rootObject);
            $scope.uniqueAlias = $scope.extractIndexAliases($scope.rootObject);
        }

        $scope.extractIndexAliases = (nodes, aliasSet = new Set()) => {
            for (const node of nodes) {
                if (node.indexAlias) {
                    aliasSet.add(node.indexAlias);
                }
                if (node.nodes && node.nodes.length > 0) {
                    $scope.extractIndexAliases(node.nodes, aliasSet);
                }
            }
            return aliasSet;
        };

        $scope.addNode = (scope) => {
            let modalInstance = $uibModal.open({
                templateUrl: 'app/admin/applicationmanagement/medplatformconfigurator/modals/form-object/edit-form-object.modal.html',
                controller: 'EditFormObjectModalController',
                windowClass: 'cst-modal',
                backdrop: 'static',
                size: 'xl',
                resolve: {
                    config: () => {
                        return {
                            node: null,
                            uniqueAlias: $scope.uniqueAlias
                        }
                    }
                }
            });
            modalInstance.result.then(function (data) {
                scope.$modelValue.nodes.push({
                    "title": data.node.title,
                    "isArray": data.node.isArray,
                    "nodes": [],
                    "indexAlias": data.node.isArray ? data.node.indexAlias : null
                })
                $scope.uniqueAlias = $scope.extractIndexAliases($scope.rootObject);
            }, () => {
            });
        }

        $scope.editNode = (node) => {
            let modalInstance = $uibModal.open({
                templateUrl: 'app/admin/applicationmanagement/medplatformconfigurator/modals/form-object/edit-form-object.modal.html',
                controller: 'EditFormObjectModalController',
                windowClass: 'cst-modal',
                backdrop: 'static',
                keyboard: false,
                size: 'xl',
                resolve: {
                    config: () => {
                        return {
                            node,
                            uniqueAlias: $scope.uniqueAlias
                        }
                    }
                }
            });
            modalInstance.result.then(function (data) {
                node.title = data.node.title
                node.isArray = data.node.isArray
                node.indexAlias = data.node.indexAlias
                $scope.uniqueAlias = $scope.extractIndexAliases($scope.rootObject);
            }, () => {
            });
        }

        $scope.deleteNode = (node, scope) => {
            if (['$formData$', '$infoData$', '$utilityData$'].includes(node.title)) {
                toaster.pop('error', 'Cannot delete roots');
                return
            }
            let modalInstance = $uibModal.open({
                templateUrl: 'app/common/views/confirmation.modal.html',
                controller: 'ConfirmModalController',
                windowClass: 'cst-modal',
                size: 'med',
                resolve: {
                    message: function () {
                        return "Are you sure you want to remove this?";
                    }
                }
            });
            modalInstance.result.then(function () {
                scope.remove();
                $scope.uniqueAlias.delete(node.indexAlias);
            }, () => {
            });
        }

        $scope.addPaths = (nodes, parentPath = '', parentAliasIndex = '') => {
            nodes.forEach(node => {
                if (parentPath) {
                    if (parentAliasIndex) {
                        node.path = `${parentPath}[$${parentAliasIndex}$].${node.title}`;    
                    } else {
                        node.path = `${parentPath}.${node.title}`;
                    }
                } else {
                    node.path = node.title;
                }
                if (node.isArray) {
                    if (node.nodes && node.nodes.length > 0) {
                    } else {
                        if (node.nodes && node.nodes.length > 0) {
                            node.path += `[$${node.indexAlias}$]`;
                        }
                    }
                }
                if (node.nodes && node.nodes.length > 0) {
                    $scope.addPaths(node.nodes, node.path, node.indexAlias);
                }
            });
        }

        $scope.addBackendConfigPath = (nodes, parentPath = "") => {
            nodes.forEach(node => {
                node.backendConfigPath = parentPath ? `${parentPath}.${node.title}` : node.title;
                if (node.nodes && node.nodes.length > 0) {
                    $scope.addBackendConfigPath(node.nodes, node.backendConfigPath);
                }
            });
        }


        $scope.save = () => {
            $scope.addPaths($scope.rootObject);
            $scope.addBackendConfigPath($scope.rootObject);
            $uibModalInstance.close({
                formObject: JSON.stringify($scope.rootObject)
            })
        }

        $scope.cancel = () => {
            $uibModalInstance.dismiss();
        }

        $scope.init();

    };
    angular.module('imtecho.controllers').controller('FormObjectModalController', FormObjectModalController);
})(window.angular);
