(function () {
    function ForgetPasswordController(UserDAO, toaster, $state, $timeout, GeneralUtil, $scope, $interval, Mask, AuthenticateService, AESEncryptionService) {
        var forgetpassword = this;
        forgetpassword.generateOtpFlag = true;
        forgetpassword.verifyOtpFlag = false;
        forgetpassword.changePasswordFlag = false;
        forgetpassword.errorFlag = false;
        forgetpassword.noOfAttempts = 0;
        forgetpassword.incorrectOtp = false;
        [forgetpassword.imagesPath, forgetpassword.logoImages] = GeneralUtil.getLogoImages();
        forgetpassword.result;
        forgetpassword.nameusr;
        $scope.contactNumber;
        $scope.timer = 30;

        forgetpassword.generateOTP = function (username) {
            forgetpassword.nameusr = username;
            forgetpassword.hasAuthError = false;
            forgetpassword.regenerateOtpButton = false;
            $timeout(function () {
                forgetpassword.regenerateOtpButton = true;
            }, 30000);
            if (username !== undefined) {
                Mask.show();
                UserDAO.validateAndGenerateOtp(username).then(function (res) {
                    $scope.startTimer();
                    forgetpassword.generateOtpFlag = false;
                    forgetpassword.verifyOtpFlag = true;
                    forgetpassword.validate = res;
                    $scope.contactNumber = res;
                }).catch((error) => {
                    forgetpassword.hasAuthError = true;
                    if (error.data) {
                        let temp = JSON.parse(error.data['result']);
                        forgetpassword.errorMessage = temp['error']
                        if (temp['message']) {
                            forgetpassword.errorMessage = temp['message'];
                        }
                        else if (temp['error']) {
                            forgetpassword.errorMessage = temp['error'];
                        }
                    }
                    else {
                        forgetpassword.errorMessage = 'Something went wrong'
                    }
                }).finally(() => {
                    Mask.hide();
                });;
            }
        };

        forgetpassword.verifyOtp = function (username, otp) {
            if (forgetpassword.noOfAttempts <= 3) {
                if (otp !== undefined) {
                    Mask.show();
                    UserDAO.verifyOtp(username, otp, forgetpassword.noOfAttempts).then(function (res) {
                        forgetpassword.validate = res;
                        forgetpassword.verifyOtpFlag = false;
                        forgetpassword.changePasswordFlag = true;
                        forgetpassword.errorFlag = false;
                        forgetpassword.hasAuthError = false;
                    }).catch(function (error) {
                        var data = error.data;
                        forgetpassword.hasAuthError = true;
                        forgetpassword.errorMessage = data.message;
                        forgetpassword.noOfAttempts++;
                        if (forgetpassword.noOfAttempts > 3) {
                            forgetpassword.incorrectOtp = true;
                        }
                    }).finally(function () {
                        Mask.hide();
                    });
                } else {
                    forgetpassword.errorFlag = true;
                }
            }
        };

        forgetpassword.resetPassword = function (otp, password, confirmPassword, username) {
            if (password !== undefined) {
                if (password == confirmPassword) {
                    Mask.show();
                    AuthenticateService.getKeyAndIV()
                        .then(() => UserDAO.resetPassword(username, otp, AESEncryptionService.encrypt(password)))
                        .then(() => {
                            toaster.pop('success', 'Password Reset Successfull!');
                            $state.go('login');
                        })
                        .catch(GeneralUtil.showMessageOnApiCallFailure)
                        .finally(Mask.hide);
                }
            } else {
                forgetpassword.errorFlag = true;
            }
        };

        forgetpassword.checkPassword = () => {
            if (forgetpassword.newPassword && forgetpassword.newPassword.length < 8) {
                forgetpassword.forgetpassForm.newPassword.$setValidity('minlength', false);
            } else {
                forgetpassword.forgetpassForm.newPassword.$setValidity('minlength', true);
            }
            GeneralUtil.checkPassword('newPassword', forgetpassword.newPassword, forgetpassword.username);
        }

        $scope.startTimer = function () {
            var countdown = function () {
                $scope.timer = 30;
                var intervalPromise = $interval(
                    function () {
                        $scope.timer--;
                        if ($scope.timer == 0) {
                            $interval.cancel(intervalPromise);
                        }
                    },
                    1000,
                    forgetpassword.timer
                );
            };
            countdown();
        };

        $scope.getPaddedTimer = function () {
            return $scope.timer.toString().padStart(2, "0");
        };
    }
    angular.module('imtecho.controllers').controller('ForgetPasswordController', ForgetPasswordController);
})();
