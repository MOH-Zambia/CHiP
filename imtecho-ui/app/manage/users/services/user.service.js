(function () {
    function UserDAO($resource, APP_CONFIG) {
        let api = $resource(APP_CONFIG.apiPath + '/user/:action/:subaction/:id', {},
            {
                createOrUpdate: {
                    method: 'POST',
                    isArray: true

                },
                retrieveById: {
                    method: 'GET'

                },
                isUsernameAvailable: {
                    method: 'GET',
                    params: {
                        action: 'checkusername'
                    },
                    transformResponse: function (res) {
                        return { result: res };
                    }
                },
                fetchAvailableUsername: {
                    method: 'GET',
                    params: {
                        action: 'availableUsername'
                    }, transformResponse: function (res) {
                        return { result: res };
                    }
                },
                retrieveAllUsers: {
                    method: 'GET',
                    isArray: true
                },
                toggleActive: {
                    method: 'PUT'
                },
                retrieveUsersByIds: {
                    method: 'GET',
                    isArray: true,
                    params: {
                        action: 'ids'
                    }
                },
                verifypassword: {
                    method: 'GET',
                    transformResponse: function (res) {
                        return { result: res };
                    }
                },
                changePassword: {
                    method: 'PUT'
                },
                retrieveByCriteria: {
                    method: 'GET',
                    isArray: true,
                    params: {
                        action: 'retrievebycriteria'
                    }
                },
                validateAndGenerateOtp: {
                    method: 'PUT',
                    params: {
                        action: 'forgotpassword',
                        subaction: 'generateotp'
                    },
                    transformResponse: function (res) {
                        return { result: res };
                    },
                },
                verifyOtp: {
                    method: 'PUT',
                    params: {
                        action: 'forgotpassword',
                        subaction: 'verifyotp'
                    }
                },
                resetPassword: {
                    method: 'PUT',
                    params: {
                        action: 'forgotpassword',
                        subaction: 'resetpassword'
                    }
                },
                changePasswordOldtoNew: {
                    method: 'PUT'
                },
                checkPhone: {
                    method: 'GET'

                },
                generateLoginCode: {
                    method: 'GET',
                    params: {
                        action: 'generateLoginCode'
                    }, transformResponse: function (res) {
                        return { result: res };
                    }
                },
                retrieveUsers: {
                    method: 'GET',
                    params: {
                        action: 'retrieveUsers'
                    },
                    isArray: true
                }
            });
        return {
            createOrUpdate: function (userDto) {
                return api.createOrUpdate({}, userDto).$promise;
            },
            retrieveById: function (id) {

                return api.retrieveById({ id: id }).$promise;
            },
            retrieveAllUsers: function () {
                return api.query().$promise;
            },
            isUsernameAvailable: function (username, userId) {
                let params = {
                    username: username,
                    user_id: userId
                };
                return api.isUsernameAvailable(params).$promise;
            },
            fetchAvailableUsername: function (username) {
                let params = {
                    username: username
                };
                return api.fetchAvailableUsername(params).$promise;
            },
            retireveAll: function (isActive) {
                return api.query({ "is_active": isActive }).$promise;
            },
            toggleActive: function (userDto, isActive) {
                return api.toggleActive({ is_active: isActive }, userDto).$promise;
            },
            retrieveUsersByIds: function (ids) {
                let params = {
                    userIds: ids
                };
                return api.retrieveUsersByIds(params).$promise;
            },
            verifyPassword: function (password, userId) {
                return api.verifypassword({ action: 'verifypassword' }, { oldPassword: password, userId: userId }).$promise;
            },
            changePassword: function (password, userId) {
                return api.changePassword({ action: 'changepassword' }, { oldPassword: password, userId: userId }).$promise;
            },
            retrieveByCriteria: function (params) {
                return api.retrieveByCriteria(params, {}).$promise;
            },
            validateAndGenerateOtp: function (username) {
                return api.validateAndGenerateOtp({}, { username: username }).$promise.then(function (response) {
                    let mobileNumber = response.result;
                    return mobileNumber;
                  });;
            },
            verifyOtp: function (username, otp, noOfAttempts) {
                return api.verifyOtp({}, { username: username, otp: otp, noOfAttempts:noOfAttempts }).$promise;
            },
            resetPassword: function (username, otp, password) {
                return api.resetPassword({}, { username: username, otp: otp, password: password }).$promise;
            },
            changePasswordOldtoNew: function (oldPassword, newPassword) {
                return api.changePasswordOldtoNew({ action: 'selfchangepassword' }, { oldPassword: oldPassword, newPassword: newPassword }).$promise;
            },
            checkPhone: function (phoneNumber, userId) {
                return api.checkPhone({ action: 'checkphone', phone: phoneNumber, userId: userId }, {}).$promise;
            },
            validateaoi: function (roleId, locationIds, toBeAdded, userId) {
                return api.get({ action: 'validateaoi', userId: userId, roleId: roleId, locationIds: locationIds, toBeAdded: toBeAdded }).$promise;
            },
            generateLoginCode: function (userId) {
                let params = {
                    userId: userId
                };
                return api.generateLoginCode(params).$promise;
            },
            retrieveAllActiveUsers: function () {
                return api.query({ action: 'all' }).$promise;
            },
            validateHealthInfra: function (object) {
                return api.get(object).$promise;
            },
            retrieveUsers: function (params) {
                return api.retrieveUsers({
                    username:params.byUsername,
                    contactNumber:params.byContactNumber,
                    name:params.byName,
                    location:params.byLocation,
                    locationId:params.locationId,
                    searchString:params.searchString,
                    roleId: 247,
                    limit:params.limit,
                    offSet:params.offSet}).$promise;
            }
        };
    }
    angular.module('imtecho.service').factory('UserDAO', ['$resource', 'APP_CONFIG', UserDAO]);
})();