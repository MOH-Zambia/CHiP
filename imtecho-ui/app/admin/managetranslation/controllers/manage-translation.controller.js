(function (angular) {
    function TranslationController($uibModal, $filter, TranslationDAO, QueryDAO, Mask, AuthenticateService, PagingForQueryBuilderService, GeneralUtil, toaster, AuthenticateService) {
        translator = this;
        translator.pagingService = PagingForQueryBuilderService.initialize();
        translator.toggleFlag = false;
        translator.addAppFlag = false;
        translator.showInactive = false;

        translator.init = function () {
            translator.refresh();
            translator.editLabel = false;
            AuthenticateService.getAssignedFeature('techo.manage.manageTranslation').then((res) => {
                Mask.show();
                if (res) {
                    translator.rights = res.featureJson;
                }
            }, (error) => {
                GeneralUtil.showMessageOnApiCallFailure(error)
            }).finally(() => {
                Mask.hide();
            })
        }

        translator.refresh = function () {
            TranslationDAO.getAllApps().then((res) => {
                translator.apps = res.filter((app) => {
                    return app.isActive === true
                });
            })
            TranslationDAO.getAllLanguages().then((res) => {
                translator.languages =$filter('orderBy')(res.filter((lang) => {
                    return lang.active === true
                }),'languageValue')
            })
        }

        translator.manageLanguages = function () {
            let modalInstance = $uibModal.open({
                templateUrl: 'app/admin/managetranslation/views/language.modal.html',
                controller: 'LanguageController',
                controllerAs: 'language',
                windowClass: 'app-modal-window',
                backdrop: 'static',
                size: 'lg',
                resolve: {
                    languages: () => {
                        return translator.languages;
                    }
                }
            })
            modalInstance.result.then(() => {
                translator.refresh();
                translator.searchTranslations(true);
            });
        }

        translator.manageApps = function () {
            let modalInstance = $uibModal.open({
                templateUrl: 'app/admin/managetranslation/views/app.modal.html',
                controller: 'AppController',
                controllerAs: 'appController',
                windowClass: 'app-modal-window',
                backdrop: 'static',
                size: 'lg',
                resolve: {
                    languages: () => {
                        return translator.languages;
                    }
                }
            })
            modalInstance.result.then(() => {
                translator.searchTranslations(true);
                translator.refresh();
            });
        }

        translator.addLabel = function () {
            let modalInstance = $uibModal.open({
                templateUrl: 'app/admin/managetranslation/views/label.modal.html',
                controller: 'LabelController',
                controllerAs: 'labelController',
                windowClass: 'app-modal-window',
                backdrop: 'static',
                size: 'xl',
                resolve: {
                    data: () => {
                        return [translator.apps, translator.languages]
                    }
                }
            })
            modalInstance.result.then(() => {
                translator.editLabel = false;
                translator.searchTranslations(true);
            });
        }

        translator.editModal = function () {
            let modalInstance = $uibModal.open({
                templateUrl: 'app/admin/managetranslation/views/label-edit.modal.html',
                controller: 'LabelEditController',
                controllerAs: 'ctrl',
                windowClass: 'cst-modal',
                backdrop: 'static',
                size: 'xl',
                resolve: {
                    data: () => {
                        return translator.key
                    }
                }
            })
            modalInstance.result.then(() => {
                translator.editLabel = false;
                translator.searchTranslations(true);
            });
        }

        translator.searchTranslations = function (reset) {
            if (reset) {
                translator.pagingService.resetOffSetAndVariables();
            }
            let searchText = translator.searchString ? translator.searchString.replace("'","''") : '';
            let queryDto = {
                code: 'labels_fetch_translations',
                parameters: {
                    appId: translator.filterApp ? translator.filterApp.id : null,
                    searchString: searchText,
                    startsWith:translator.startsWith ? translator.startsWith : '',
                    showInactive:translator.showInactive,
                    limit: translator.pagingService.limit,
                    offset: translator.pagingService.offSet,
                }
            }
            if (!translator.allRetrieved) {
                translator.pagingService.getNextPage(QueryDAO.executeQuery, queryDto, translator.searchData, null).then(function (res) {
                    Mask.show();
                    if (res.length === 0) {
                        translator.pagingService.allRetrieved = true
                    } else {
                        translator.pagingService.allRetrieved = false
                    }
                    translator.searchData = res
                    translator.searchResult = _.groupBy(translator.searchData, (element) => {
                        return element.key + '-' + element.app
                    });
                }, (error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error)
                }).finally(() => {
                    Mask.hide();
                });
            }

        }

        translator.editTranslation = function (result) {
            translator.editLabel = true;
            translator.editObject = result;
            translator.editModal();
        }

        translator.toggleActive = function () {
            let modalInstance = $uibModal.open({
                templateUrl: 'app/admin/managetranslation/views/toggle-state.modal.html',
                controller: 'ToggleController',
                controllerAs: 'ctrl',
                windowClass: 'cst-modal',
                backdrop: 'static',
                size: 'md',
                resolve: {
                    data: () => {
                        return [translator.editApp, translator.key]
                    }
                }
            })
            modalInstance.result.then(() => {
                translator.refresh();
                translator.searchTranslations(true);
            });
        };

        translator.selectedApps = function (editObj) {
            translator.key = editObj.key
            const key = editObj.key.replace(/'/g, "''");
            QueryDAO.executeQuery({
                code: 'labels_selected_apps_for_editing',
                parameters: { key }
            }).then((res) => {
                translator.editApp = res.result;
                if (!translator.addAppFlag) {
                    if (translator.toggleFlag === true) {
                        translator.toggleActive();
                        translator.toggleFlag = false;
                    } else {
                        translator.editTranslation(editObj);
                    }
                } else {
                    translator.addApp(editObj)
                }
            }, (error) => {
                GeneralUtil.showMessageOnApiCallFailure(error)
            }).finally(() => {
                Mask.hide();
            });
        }

        translator.addApp = function (editObj) {
            let queryDto = {
                code: 'labels_app_data_for_prepopulating',
                parameters: {
                    key: editObj.key,
                    appValue: editObj.app
                }
            }
            translator.editAppIds = translator.editApp.map((item) => {
                return item.app
            })
            translator.appList = translator.apps.filter((app) => {
                return translator.editAppIds.indexOf(app.id) === -1
            })
            if (translator.appList.length > 0) {
                QueryDAO.executeQuery(queryDto).then((res) => {
                    let modalInstance = $uibModal.open({
                        templateUrl: 'app/admin/managetranslation/views/label.modal.html',
                        controller: 'LabelController',
                        controllerAs: 'labelController',
                        windowClass: 'app-modal-window',
                        backdrop: 'static',
                        size: 'lg',
                        resolve: {
                            data: () => {
                                return [translator.appList, translator.languages, res.result, translator.editApp]
                            }
                        }
                    })
                    modalInstance.result.then(() => {
                        translator.addAppFlag = false;
                        translator.searchTranslations(true);
                    });
                })
            } else {
                toaster.pop('info', 'Label already present in all apps')
                translator.addAppFlag = false;
            }


        }
        translator.toggleState = function(labels){
            let isActive = true
            for(label of labels){
                if(label.is_active!=null){
                    isActive = label.is_active
                    break;
                }
            }
            let modalInstance = $uibModal.open({
                templateUrl: 'app/common/views/confirmation.modal.html',
                controller: 'ConfirmModalController',
                windowClass: 'cst-modal',
                size: 'med',
                resolve: {
                  message: function () {
                    return "Are you sure you want to change the state from " + (isActive ? 'Active' : 'Inactive') + ' to ' + (!isActive ? 'Active' : 'Inactive') + '? ';
                  }
                }
              });
              modalInstance.result.then(function () {
            let dtoList = [];
            Mask.show();
            TranslationDAO.toggleActive(labels[0].key,!isActive,labels[0].appid).then(() => {
                toaster.pop('success','State changed successfully');
            }, (error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
                error = true
            }).finally(() => {
              
                translator.searchTranslations(true);
                Mask.hide();
            })
        }, function () { });
        }

        translator.init();
    }
    angular.module('imtecho.controllers').controller('TranslationController', TranslationController);
})(window.angular);
