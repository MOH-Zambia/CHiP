(function () {
    function UpdateUserProfileController(AuthenticateService, UserDAO, toaster, Mask, updateUserObj, RoleDAO, $uibModalInstance, GeneralUtil) {
        var updateProfile = this;

        var initPage = function () {
            updateProfile.checkuser = null;
            updateProfile.userObj = updateUserObj;
            updateProfile.userFormSubmitted = false;
            updateProfile.res = {};
            GeneralUtil.getAllActiveLanguages().then(languageList => {
                updateProfile.languageList = languageList;
                let preferredLanguage = updateProfile.userObj.prefferedLanguage;
                if (preferredLanguage) {
                    updateProfile.userObj.prefferedLanguage = GeneralUtil.getNewPreferredLanguage(preferredLanguage).toLowerCase();
                    if (updateProfile.languageList && updateProfile.languageList.length > 0) {
                        const isPreferredLanguageInList = updateProfile.languageList.some(language =>
                            language.languageKey.toLowerCase() === updateProfile.userObj.prefferedLanguage
                        );
                        if (!isPreferredLanguageInList) {
                            updateProfile.userObj.prefferedLanguage = 'en';
                        }
                    }
                }
            });
            updateProfile.localLanguage = GeneralUtil.getLocalLanguage();
        };

        AuthenticateService.getAssignedFeature("techo.manage.users").then(function (res) {
            if (!!res && !!res.featureJson) {
                updateProfile.rights = res.featureJson;
            } else {
                updateProfile.rights = {};
            }
            updateProfile.getAllActiveRoles();
        });

        updateProfile.updateUser = function (form) {
            if (updateProfile.userObj.prefferedLanguage) {
                var userDto = angular.copy(updateProfile.userObj);
                Mask.show();
                UserDAO.createOrUpdate(userDto).then(function (res) {
                    if (!!res) {
                        toaster.pop('success', 'Your Profile Updated Successfully!');
                        $uibModalInstance.close();
                    }
                }).catch((err) => {
                    toaster.pop('error', `${err.data.message} ${err.data.data}. Please change it from manage users or contact system administrator.`);
                }).finally(function () {
                    Mask.hide();
                });
            } else {
                toaster.pop('error', 'Please select preferred Language')
            }
        };

        // method used for toggling the icon in the password.
        updateProfile.getAllActiveRoles = function () {
            Mask.show();
            RoleDAO.retieveRolesByRoleId(updateProfile.rights.isAdmin).then(function (res) {
                updateProfile.roleList = res;
                updateProfile.getAssignedRoleName();
            }).finally(function () {
                Mask.hide();
            });
        };

        updateProfile.getAssignedRoleName = function () {
            _.each(updateProfile.roleList, function (list) {
                if (list.id == updateProfile.userObj.roleId)
                    updateProfile.userObj.assignedRoleName = list.name;
            });
        };

        updateProfile.cancel = function () {
            $uibModalInstance.dismiss('cancel');
        };

        initPage();
    }
    angular.module('imtecho.controllers').controller('UpdateUserProfileController', UpdateUserProfileController);
})();
