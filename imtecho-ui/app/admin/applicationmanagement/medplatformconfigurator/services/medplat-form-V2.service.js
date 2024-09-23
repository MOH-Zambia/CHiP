(function () {
    function MedplatFormServiceV2($resource, APP_CONFIG) {
        let api = $resource(APP_CONFIG.apiPath + '/medplatform/:action/:subAction/:id', {}, {
            getMedplatForms: {
                method: 'GET',
                isArray: true
            },
            getMedplatFormByUuid: {
                method: 'GET'
            },
            getMedplatFieldKeyMap: {
                method: "GET",
                isArray: true
            },
            saveMedplatFormConfiguration: {
                method: 'POST'
            },
            updateMedplatFormConfigurationAsDraft: {
                method: 'PUT'
            },
            updateMedplatFormConfigurationFormObject: {
                method: 'PUT'
            },
            updateMedplatFormConfigurationFormTemplateConfig: {
                method: 'PUT'
            },
            updateMedplatFormConfigurationFormVm: {
                method: 'PUT'
            },
            getMedplatFormConfigByUuid: {
                method: 'GET'
            },
            getMedplatFormConfigByUuidAndVersion: {
                method: 'GET'
            },
            updateMedplatFormVersion: {
                method: 'PUT'
            },
            saveMedplatFormConfigurationStable: {
                method: 'POST'
            },
            getMedplatFormConfigByUuidForEdit: {
                method: 'GET'
            },
            updateFormVersion: {
                method: 'POST'
            },
            getMedplatFormConfigByFormCode: {
                method: 'GET'
            },
            updateMedplatFormConfiguration: {
                method: 'POST'
            },
            saveMedplatFormDataByFormCode: {
                method: 'POST'
            },
            updateMedplatFormConfigurationFormQueryConfig: {
                method: 'PUT'
            },
        });
        return {
            getMedplatForms: function () {
                return api.getMedplatForms({
                    action: 'forms'
                }, {}).$promise;
            },
            getMedplatFormsByMenuConfigId: function (menuConfigId) {
                return api.getMedplatForms({
                    action: 'forms',
                    subAction: menuConfigId
                }, {}).$promise;
            },
            getMedplatFormByUuid: function (uuid) {
                return api.getMedplatFormByUuid({
                    action: 'form',
                    subAction: uuid
                }, {}).$promise;
            },
            getMedplatFieldKeyMap: function () {
                return api.getMedplatFieldKeyMap({
                    action: 'fieldkeymap',
                }, {}).$promise;
            },
            saveMedplatFormConfiguration: function (dto) {
                return api.saveMedplatFormConfiguration({
                    action: 'savemedplatform',
                }, dto).$promise;
            },
            updateMedplatFormConfigurationAsDraft: function (dto) {
                return api.updateMedplatFormConfigurationAsDraft({
                    action: 'updatemedplatformasdraft',
                }, dto).$promise;
            },
            updateMedplatFormConfigurationFormObject: function (dto) {
                return api.updateMedplatFormConfigurationFormObject({
                    action: 'updatemedplatformobject',
                }, dto).$promise;
            },
            updateMedplatFormConfigurationFormTemplateConfig: function (dto) {
                return api.updateMedplatFormConfigurationFormTemplateConfig({
                    action: 'updatemedplatformtemplateconfig',
                }, dto).$promise;
            },
            updateMedplatFormConfigurationFormVm: function (dto) {
                return api.updateMedplatFormConfigurationFormVm({
                    action: 'updatemedplatformvm',
                }, dto).$promise;
            }, updateFormVersion: function (dto) {
                return api.updateFormVersion({
                    action: 'updateFormVersion',
                }, dto).$promise;
            },
            getMedplatFormConfigByUuid: function (uuid) {
                return api.getMedplatFormConfigByUuid({
                    action: 'formConfig',
                    subAction: uuid
                }, {}).$promise;
            },
            getMedplatFormConfigByUuidAndVersion: function (uuid, version) {
                return api.getMedplatFormConfigByUuidAndVersion({
                    action: 'formConfig',
                    subAction: uuid,
                    id: version
                }, {}).$promise;
            },
            updateMedplatFormVersion: function (dto) {
                return api.updateMedplatFormVersion({
                    action: 'updatemedplatformversion',
                }, dto).$promise;
            },
            saveMedplatFormConfigurationStable: function (dto) {
                return api.saveMedplatFormConfigurationStable({
                    action: 'savemedplatformstable',
                }, dto).$promise;
            },
            getMedplatFormConfigByUuidForEdit: function (uuid) {
                return api.getMedplatFormConfigByUuidForEdit({
                    action: 'formConfigEdit',
                    subAction: uuid
                }, {}).$promise;
            },
            getMedplatFormConfigByFormCode: function (formCode) {
                return api.getMedplatFormConfigByFormCode({
                    action: 'dynamicform',
                    subAction: formCode
                }, {}).$promise;
            },
            updateMedplatFormConfiguration: function (dto) {
                return api.updateMedplatFormConfiguration({
                    action: 'updatemedplatform',
                }, dto).$promise;
            },
            saveMedplatFormDataByFormCode: function (formCode, data) {
                return api.updateMedplatFormConfiguration({
                    action: 'savedata',
                    subAction: formCode
                }, data).$promise;
            },
            updateMedplatFormConfigurationFormQueryConfig: function (dto) {
                return api.updateMedplatFormConfigurationFormQueryConfig({
                    action: 'updatemedplatformqueryconfig',
                }, dto).$promise;
            },
        };
    }
    angular.module('imtecho.service')
        .factory('MedplatFormServiceV2', ['$resource', 'APP_CONFIG', MedplatFormServiceV2]);
})();
