(function (angular) {
    function LabelController(data, QueryDAO, TranslationDAO, toaster, $uibModalInstance, Mask, GeneralUtil) {
        labelController = this;
        labelController.editModal = false;
        labelController.addAppFlag = false;
        labelController.alreadyExistsLabel = null;
        labelController.langValuePair = [];
        labelController.dtoList = [];
        labelController.appList = data[0];
        labelController.languageList = data[1];

        if (data[2]) {
            labelController.addAppFlag = true
            labelController.fieldsData = data[2]
            labelController.key = data[2][0].key;   
            const key = labelController.key.replace(/'/g, "''");
            let queryDto = {
                code: 'labels_selected_apps_for_editing',
                parameters: { key }
            }
            QueryDAO.executeQuery(queryDto).then((res) => {
                labelController.existingApps = res.result.map((item) => {
                    return  item.appvalue
                }).filter((item, index, self) => {
                    return index === self.findIndex((t) => (
                       t === item
                    ));
                }).join(', ')
            })  
        }



        labelController.languagesChanged = function () {
            let languageIds = labelController.languages.map((lang) => {
                return lang.id
            })
            labelController.langValuePair = labelController.langValuePair.filter((pair) => {
                return languageIds.indexOf(pair.language) != -1
            })
        }

        labelController.valueChanged = function (id, value) {
            let found = false;
            angular.forEach(labelController.langValuePair, function (item) {
                if (item.language === id) {
                    item.value = value;
                    found = true;
                }
            });
            if (!found) {
                labelController.langValuePair.push({
                    language: id,
                    value: value
                });
            }
        }
        labelController.translate = function () {
            Mask.show();  
            let targetLangs = labelController.languageList
                                .filter((element) => element.languageKey !== 'en')
                                .map((element) => element.id).join(',');

            TranslationDAO.translateText(targetLangs, labelController.englishValue).then((res) => {
                labelController.translations = res;
            }).finally(()=>{
                Mask.hide();
            });
        }
        labelController.save = function () {
            labelController.languageForm.$setSubmitted();
            if (labelController.languageForm.$valid) {
                labelController.key = labelController.englishValue.toUpperCase().replace(/ /g, "")
                for (appValue of labelController.apps) {
                    labelController.dtoList.push({ language: 65, value: labelController.englishValue, app: appValue, isActive: true, key: labelController.key });
                   if(labelController.translations === undefined){
                    for (pair of labelController.langValuePair){
                        let dto = { language: pair.language, value: pair.value, app: appValue, isActive: true, key: labelController.key }
                        labelController.dtoList.push(dto);
                    }
                   }else{
                        for (pair of labelController.translations) {
                            let dto = { language: pair.id, value: pair.translation, app: appValue, isActive: true, key: labelController.key }
                            labelController.dtoList.push(dto);
                        }
                    }

                }
                labelController.alreadyExistsLabel = null;
                for (let label of labelController.dtoList) {
                    if (label) {
                        var curLabel = label;
                        let labelCheckDto = {
                            code: 'translation_label_app_language_key_check',
                            parameters: {
                                key: curLabel?.key,
                                language: curLabel?.language,
                                app: curLabel?.app,
                            }
                        }
                        Mask.show();
                        QueryDAO.execute(labelCheckDto).then(function (response) {
                            if (response.result.length > 0) {
                                toaster.pop('error', 'The Label containing Same App,Language and Key Already Exists.');
                                Mask.hide();
                                labelController.alreadyExistsLabel = curLabel;
                                labelController.dtoList = [];
                            }
                            if (labelController.dtoList.indexOf(label) == labelController.dtoList.length - 1) {

                                if (!labelController.alreadyExistsLabel) {
                                    Mask.show();
                                    TranslationDAO.creatingLabel(labelController.dtoList).then(() => {
                                        toaster.pop('success', 'Labels added successfully')
                                    }, (error) => {
                                        GeneralUtil.showMessageOnApiCallFailure(error);
                                    }).finally(() => {
                                        Mask.hide();
                                        labelController.close();
                                    })
                                }
                            }
                        }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide);
                    }
                }
            }
        }

        labelController.addApps = function () {
            labelController.languageForm.$setSubmitted();
            if (labelController.languageForm.$valid) {
                Mask.show();
                for (appValue of labelController.apps) {
                    for (data of labelController.fieldsData) {
                        let dto = { language: data.language, value: data.value, app: appValue, isActive: true, key: labelController.key }
                        labelController.dtoList.push(dto);
                    }
                }
                TranslationDAO.creatingLabel(labelController.dtoList).then(() => {
                    toaster.pop('success', 'Labels added successfully')
                }, (error) => {
                    GeneralUtil.showMessageOnApiCallFailure(error);
                }).finally(() => {
                    Mask.hide();
                    labelController.close();
                })
            }
        }
       labelController.addAppTranslate = function(obj){
        if(obj.language === 65){
            Mask.show();  
            let targetLangs = labelController.languageList
                                .filter((element) => element.languageKey !== 'en')
                                .map((element) => element.id).join(',');

            TranslationDAO.translateText(targetLangs,obj.value).then((res) => {
               labelController.fieldsData.forEach((element)=>{
                for(translation of res){
                    if(translation.id===element.language){
                        element.value = translation.translation
                    }
                }
               })
            }).finally(()=>{
                Mask.hide();
            });
        }
       }

        labelController.close = function () {
            $uibModalInstance.close();
        }
   
        if (labelController.appList.length === 0) {
            toaster.pop('info', 'Label present in all apps')
            $uibModalInstance.close();
        }
    }
    angular.module('imtecho.controllers').controller('LabelController', LabelController);
})(window.angular);