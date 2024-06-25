
(function (angular) {
    function LanguageController(languages, TranslationDAO, QueryDAO, toaster, $uibModalInstance, $uibModal, $filter, Mask, GeneralUtil) {
        language = this;
        language.languageList = languages;
        if (language.languageList.length > 0) {
            language.showFields = false
        } else {
            language.showFields = true
        }

        language.addLang = function () {   
            Mask.show();
            language.toggleFields();
            let queryDto = {
                code:'labels_get_all_ibm_languages'
            }
          QueryDAO.execute((queryDto)).then((res)=>{
            language.availableLanguages = res.result;
          }).catch((error)=>{
            GeneralUtil.showMessageOnApiCallFailure(error);
          }).finally(()=>{
            Mask.hide();
          })
          
        }

        language.orderList = () => {
            let sorted = [];
            sorted = $filter('orderBy')(language.languageList, ['languageValue']);
            return sorted;
        };

        language.saveLang = function () {
            language.form.$setSubmitted();
            if (language.form.$valid) {
                Mask.show();
                let isLtr = JSON.parse(language.languageToBeAdded.additional_detail).Orientation === 'left_to_right'? true : false
                let languageDto = { languageKey:language.languageToBeAdded.code,
                                    languageValue:language.languageToBeAdded.value,
                                    isLtr: isLtr,
                                    active: true }
                    TranslationDAO.createLanguage(languageDto).then(() => {
                        language.refresh();
                        toaster.pop('success', 'Language added successfully')
                    }, (error) => {
                        GeneralUtil.showMessageOnApiCallFailure(error);
                    }).finally(() => {
                        Mask.hide();
                        language.toggleFields();
                        language.form.$setPristine();
                    })
            }
        }

        language.cancel = function () {
            language.toggleFields();
        }

        language.toggleActive = function (lang) {
            let modalInstance = $uibModal.open({
                templateUrl: 'app/common/views/confirmation.modal.html',
                controller: 'ConfirmModalController',
                windowClass: 'cst-modal',
                size: 'med',
                resolve: {
                    message: function () {
                        return "Are you sure you want to change the state from " + (lang.active === true ? 'Active' : 'Inactive') + ' to ' + (!lang.active === true ? 'Active' : 'Inactive') + '? ';
                    }
                }
            });
            modalInstance.result.then(function () {
                Mask.show();
                let newState = !lang.active
                lang.active = newState;
                TranslationDAO.updateLanguage(lang).then(() => {
                    toaster.pop('success', 'State changed successfully');
                    language.refresh();
                }, (error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => { Mask.hide() })
            }, function () { });


        }

        language.toggleFields = function () {
            language.showFields = !language.showFields;
        }


        language.close = function () {
            $uibModalInstance.close();
        }

        language.refresh = function () {
            Mask.show();
            TranslationDAO.getAllLanguages().then((res) => {
                language.languageList = res;
                language.languageList = language.orderList();
            }, (error) => {
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(() => {
                Mask.hide();
            })
        }
        language.refresh();
    }
    angular.module('imtecho.controllers').controller('LanguageController', LanguageController);
})(window.angular);