(function () {
    function TranslationDAO(APP_CONFIG, $resource) {
        let api = $resource(APP_CONFIG.apiPath + '/translation/:action/:id', {},
            {
                createLanguage: {
                    method: 'POST',
                    params: {
                        action: 'languages'
                    }
                },
                createOrUpdateLanguages: {
                    method: 'POST',
                    params: {
                        action: 'languages'
                    }
                },
                updateLanguage: {
                    method: 'PUT',
                    params: {
                        action: 'languages'
                    }
                },
                getAllLanguages: {
                    method: 'GET',
                    params: {
                        action: 'languages'
                    },
                    isArray: true
                },
                createApp: {
                    method: 'POST',
                    params: {
                        action: 'apps'
                    }
                },
                updataApp: {
                    method: 'POST',
                    params: {
                        action: 'apps'
                    }
                },
                getAllApps: {
                    method: 'GET',
                    params: {
                        action: 'apps'
                    },
                    isArray: true
                },
                creatingLabel: {
                    method: 'POST',
                    params: {
                        action: 'labels'
                    },
                    isArray: true
                },
                getAppsById: {
                    method: 'GET',
                    params: {
                        action: 'apps-selected',
                    },
                    isArray: true
                },
                getLanguagesById: {
                    method: 'GET',
                    params: {
                        action: 'languages-selected',
                    },
                    isArray: true
                },
                toggleActive: {
                    method: 'PUT',
                    params: {
                        action: 'toggleActive'
                    }
                },
                getAvailableLanguages:{
                    method: 'GET',
                    params:{
                        action: 'languages-available'
                    },
                    isArray: true
                },
                translateText:{
                    method:'GET',
                    params:{
                        action: 'translate'
                    },
                    isArray: true
                }
            });
        return {
            createLanguage: function (languageDto) {
                return api.createLanguage(languageDto).$promise;
            },
            createOrUpdateLanguages: function (languageList) {
                return api.createOrUpdateLanguages(languageList).$promise;
            },
            updateLanguage: function (languageDto) {
                return api.updateLanguage(languageDto).$promise;
            },
            getAllLanguages: function () {
                return api.getAllLanguages().$promise;
            },
            createApp: function (appDto) {
                return api.createApp(appDto).$promise;
            },
            updateApp: function (appDto) {
                return api.updataApp(appDto).$promise;
            },
            getAllApps: function () {
                return api.getAllApps().$promise;
            },
            creatingLabel: function (dtoList) {
                return api.creatingLabel(dtoList).$promise;
            },
            getAppsById: function (ids) {
                return api.getAppsById({ ids }, {}).$promise;
            },
            getLanguagesById: function (ids) {
                return api.getLanguagesById({ ids }, {}).$promise;
            },
            toggleActive: function (key, isActive, app) {
                return api.toggleActive({ key: key, isActive: isActive, app: app }, {}).$promise;
            },
            getAvailableLanguages: function (){
                return api.getAvailableLanguages().$promise;
            },
            translateText:function(targetLangs,englishText){
                return api.translateText({targetLangs:targetLangs, englishText:englishText}).$promise
            }
        };
    }
    angular.module('imtecho.service').factory('TranslationDAO', TranslationDAO);
})();