
(function (angular) {
    function LabelEditController(data, $uibModalInstance, QueryDAO, TranslationDAO, toaster, GeneralUtil, Mask) {
        ctrl = this
        ctrl.dtoList = []
        ctrl.key = data
        ctrl.retrieveAll = function () {
            const key = ctrl.key.replace(/'/g, "''");
            let queryDto = {
                code: 'labels_selected_apps_for_editing',
                parameters: { key }
            }
            QueryDAO.executeQuery(queryDto).then((res) => {
                ctrl.data = res.result
                ctrl.apps = ctrl.data.map((item) => {
                    return {
                        app: item.app, appvalue: item.appvalue
                    }
                }).filter((item, index, self) => {
                    return index === self.findIndex((t) => (
                        t.app === item.app && t.appvalue === item.appvalue
                    ));
                })
                ctrl.selectedTab = ctrl.apps[0]
            })
        }

        ctrl.valuesChanged = function (id, app, language, value) {
            let found = false;
            angular.forEach(ctrl.dtoList, function (item) {
                if (item.app === app && item.language === language) {
                    item.value = value;
                    found = true;
                }
            });
            if (!found) {
                ctrl.dtoList.push({
                    id: id, key: ctrl.key, app: app, language: language, isActive: true, value: value
                });
            }
        }
        ctrl.retrieveAll();
        ctrl.update = function () {
            ctrl.languageEditForm.$setSubmitted();
            if(ctrl.languageEditForm.$valid){
                TranslationDAO.creatingLabel(ctrl.dtoList).then(() => {
                    toaster.pop('success', 'values updated successfully')
                }, (error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    $uibModalInstance.close();
                })
            }
        }

        ctrl.translate = function(lang,app){
            Mask.show();
            let englishText = ctrl.data.filter((element)=>{
               return (element.languagevalue === 'English'&& element.app === app);
            }).map((element) => element.value);
            TranslationDAO.translateText(lang.language,englishText[0]).then((res)=>{
                lang.value = res[0].translation;
                ctrl.valuesChanged(lang.id,app,lang.language,lang.value);
            }).catch((error)=>{
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(()=>{
                Mask.hide();
            });
        }

        ctrl.translateAll = function(){
            Mask.show();
            let targetLangs = ctrl.data.filter((element)=>{
                return element.app === ctrl.selectedTab.app && element.languagekey != 'en';
            }).map((element)=>{
                    return element.language;
            }).join(',');

            let englishText = ctrl.data.filter((element)=>{
                return (element.languagevalue === 'English'&& element.app === ctrl.selectedTab.app);
             }).map((element) => element.value);

            TranslationDAO.translateText(targetLangs,englishText[0]).then((res)=>{
                for(item of res){
                    ctrl.data.forEach((element)=>{
                        if(element.app === ctrl.selectedTab.app && element.languagekey === item.language_key){
                            element.value = item.translation;
                            ctrl.valuesChanged(element.id, element.app, element.language, element.value);
                        }
                    })
                }
            }).catch((error)=>{
                GeneralUtil.showMessageOnApiCallFailure(error);
            }).finally(()=>{
                Mask.hide();
            })
        }
        ctrl.close = function () {
            $uibModalInstance.close();
        }
    } angular.module('imtecho.controllers').controller('LabelEditController', LabelEditController);
})(window.angular);