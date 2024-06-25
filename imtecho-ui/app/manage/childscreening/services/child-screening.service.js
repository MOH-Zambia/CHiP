(function () {
    function ChildScreeningService($resource, APP_CONFIG) {
        var api = $resource(APP_CONFIG.apiPath + '/childcmtcnrc/:action/:subaction/:id', {},
            {
                create: {
                    method: 'POST'
                },
                retrieveScreeningDetails: {
                    method: 'GET'
                },
                retrieveAllScreenedChildren: {
                    method: 'GET',
                    isArray: true
                },
                retrieveAllReferredChildren: {
                    method: 'GET',
                    isArray: true
                },
                retrieveAllAdmittedChildren: {
                    method: 'GET',
                    isArray: true
                },
                retrieveAllDefaulterChildren: {
                    method: 'GET',
                    isArray: true
                },
                retrieveAllDischargedChildren: {
                    method: 'GET',
                    isArray: true
                },
                retrieveTreatmentCompletedChildren: {
                    method: 'GET',
                    isArray: true
                },
                updateWeightOfChild: {
                    method: 'POST'
                },
                retrieveAdmissionDetailById: {
                    method: 'GET'
                },
                retrieveWeightList: {
                    method: 'GET',
                    isArray: true
                },
                retrieveLaboratoryList: {
                    method: 'GET',
                    isArray: true
                },
                retrieveSdScore: {
                    method: 'GET'
                },
                saveDeathDetails: {
                    method: 'PUT'
                },
                saveDischargeDetails: {
                    method: 'POST'
                },
                saveDefaulterDetails: {
                    method: 'POST'
                },
                saveLaboratoryTests: {
                    method: 'POST'
                },
                saveMedicines: {
                    method: 'POST'
                },
                saveFollowUp: {
                    method: 'POST'
                },
                getLastFollowUpVisit: {
                    method: 'GET'
                },
                getDischargeDetails: {
                    method: 'GET'
                },
                retrieveRchChildServiceDetailsByMemberId: {
                    method: 'GET'
                },
                getBlockList: {
                    method: 'GET',
                    isArray: true
                },
                createChildScreening: {
                    method: 'POST'
                },
                checkAdmissionIndicator: {
                    method: 'GET'
                },
                retrieveAshaPhoneNumber: {
                    method: 'GET',
                    isArray: true
                },
                retrieveLastLaboratoryTest: {
                    method: 'GET'
                },
                retrieveMedicalComplications: {
                    method: 'GET'
                },
                createMoVerification: {
                    method: 'POST'
                },
                createChildScreeningForMo: {
                    method: 'POST'
                },
                updateScreeningState: {
                    method: 'POST'
                },
                deleteChildScreeningByChildId: {
                    method: 'DELETE'
                },
                checkAdmissionValidity: {
                    method: 'GET'
                }
            });
        return {
            create: function (childCmtcNrcAdmissionDto) {
                return api.create({ action: 'admit' }, childCmtcNrcAdmissionDto).$promise;
            },
            retrieveScreeningDetails: function (childId) {
                return api.retrieveScreeningDetails({ action: 'screeningdetails', childId: childId }, {}).$promise;
            },
            retrieveAllScreenedChildren: function (params) {
                return api.retrieveAllScreenedChildren({ action: 'screenedlist', limit: params.limit, offset: params.offset }, {}).$promise;
            },
            retrieveAllReferredChildren: function (params) {
                return api.retrieveAllReferredChildren({ action: 'referredlist', limit: params.limit, offset: params.offset }, {}).$promise;
            },
            retrieveAllAdmittedChildren: function (params) {
                return api.retrieveAllAdmittedChildren({ action: 'admittedlist', limit: params.limit, offset: params.offset }, {}).$promise;
            },
            retrieveAllDefaulterChildren: function (params) {
                return api.retrieveAllDefaulterChildren({ action: 'defaulterlist', limit: params.limit, offset: params.offset }, {}).$promise;
            },
            retrieveAllDischargedChildren: function (params) {
                return api.retrieveAllDischargedChildren({ action: 'dischargelist', limit: params.limit, offset: params.offset }, {}).$promise;
            },
            retrieveTreatmentCompletedChildren: function (params) {
                return api.retrieveTreatmentCompletedChildren({ action: 'treatmentCompletedList', limit: params.limit, offset: params.offset }, {}).$promise;
            },
            updateWeightOfChild: function (childCmtcNrcWeightDto) {
                return api.updateWeightOfChild({ action: 'recordweight' }, childCmtcNrcWeightDto).$promise;
            },
            retrieveAdmissionDetailById: function (id) {
                return api.retrieveAdmissionDetailById({ action: 'retrievebyId', admissionId: id }).$promise;
            },
            retrieveWeightList: function (id) {
                return api.retrieveWeightList({ action: 'weightlist', admissionId: id }).$promise;
            },
            retrieveLaboratoryList: function (id) {
                return api.retrieveLaboratoryList({ action: 'laboratorylist', admissionId: id }).$promise;
            },
            retrieveSdScore: function (gender, height, weight) {
                return api.retrieveSdScore({ action: 'getsdscore', gender: gender, height: height, weight: weight }).$promise;
            },
            saveDeathDetails: function (child) {
                return api.saveDeathDetails({ action: 'savedeath' }, child).$promise;
            },
            saveDischargeDetails: function (childDto) {
                return api.saveDischargeDetails({ action: 'savedischarge' }, childDto).$promise;
            },
            saveDefaulterDetails: function (child) {
                return api.saveDefaulterDetails({ action: 'savedefaulter' }, child).$promise;
            },
            saveLaboratoryTests: function (child) {
                return api.saveLaboratoryTests({ action: 'savelaboratorytests' }, child).$promise;
            },
            saveMedicines: function (child) {
                return api.saveMedicines({ action: 'savemedicines' }, child).$promise;
            },
            saveFollowUp: function (child) {
                return api.saveFollowUp({ action: 'savefollowup' }, child).$promise;
            },
            getLastFollowUpVisit: function (childId, admissionId) {
                return api.getLastFollowUpVisit({ action: 'getlastfollowup', childId: childId, admissionId: admissionId }).$promise;
            },
            getDischargeDetails: function (dischargeId) {
                return api.getDischargeDetails({ action: 'retrievedischargebyid', dischargeId: dischargeId }).$promise;
            },
            retrieveRchChildServiceDetailsByMemberId: function (childId) {
                return api.retrieveRchChildServiceDetailsByMemberId({ action: 'retrieverchchildservice', childId: childId }).$promise;
            },
            getBlockList: function (userId) {
                return api.getBlockList({ action: 'getblocks', userId: userId }).$promise;
            },
            createChildScreening: function (child) {
                return api.createChildScreening({ action: 'createchildscreening' }, child).$promise;
            },
            checkAdmissionIndicator: function (childId, admissionDate) {
                return api.checkAdmissionIndicator({ action: 'checkadmissionindicator', childId: childId, admissionDate: admissionDate }).$promise;
            },
            retrieveAshaPhoneNumber: function (memberId) {
                return api.retrieveAshaPhoneNumber({ action: 'retrieveashaphonenumber', memberId: memberId }).$promise;
            },
            retrieveLastLaboratoryTest: function (admissionId) {
                return api.retrieveLastLaboratoryTest({ action: 'retrievelastlaboratorytest', admissionId: admissionId }).$promise;
            },
            retrieveMedicalComplications: function (memberId) {
                return api.retrieveMedicalComplications({ action: 'retrievemedicalcomplications', memberId: memberId }).$promise;
            },
            createMoVerification: function (verificationDto) {
                return api.createMoVerification({ action: 'moverification' }, verificationDto).$promise;
            },
            createChildScreeningForMo: function (verificationDto) {
                return api.createChildScreeningForMo({ action: 'childscreeningmo' }, verificationDto).$promise;
            },
            updateScreeningState: function (screeningId, state, discardDate) {
                return api.updateScreeningState({ action: 'screeningstate' , screeningId: screeningId, state: state, discardDate: discardDate}, {}).$promise;
            },
            deleteChildScreeningByChildId: function (childId) {
                return api.deleteChildScreeningByChildId({ action: 'deletescreening', childId: childId }, {}).$promise;
            },
            checkAdmissionValidity: function (childId) {
                return api.checkAdmissionValidity({ action: 'checkadmissionvalidity', childId: childId }, {}).$promise;
            }
        };
    }
    angular.module('imtecho.service').factory('ChildScreeningService', ['$resource', 'APP_CONFIG', ChildScreeningService]);
})();
