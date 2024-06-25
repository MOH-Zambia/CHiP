(function (angular, Math) {
    angular.module('imtecho.service').factory('GeneralUtil', function (toaster, ENV, $http, APP_CONFIG) {
        var GeneralUtil = {};
        /**
         * General error message will be shown based on responseError.data. If undefined errorMsg will be shown.
         *
         * @param {Object} responseError - Error response from $responce api
         * @param {String} errorMsg
         * @returns {undefined}
         */
        GeneralUtil.showMessageOnApiCallFailure = function (responseError, errorMsg) {
            if (responseError && responseError.status === 499) {
                toaster.warning('Multiple actions detected', 'You might have clicked same button twice.');
            } else {
                if (responseError && responseError.status === 401 && responseError.data.error === "invalid_token") {
                    toaster.pop({
                        type: 'error',
                        title: 'Your Session has Expired!'
                    });
                } else if (responseError && responseError.data && angular.isDefined(responseError.data.message) && responseError.data.message) {
                    toaster.pop({
                        type: 'error',
                        body: responseError.data.message
                    });
                } else if (errorMsg) {
                    toaster.pop({
                        type: 'error',
                        body: errorMsg
                    });
                } else {
                    toaster.pop({
                        type: 'error',
                        title: 'Operation unsuccessful',
                        body: 'Something went wrong.'
                    });
                }
            }
        };

        GeneralUtil.getPropByPath = (obj, path) => {
            if (!obj || !path) {
                return obj;
            }
            path = path.replace(/\[(\w+)\]/g, '.$1'); // convert indexes to properties
            path = path.replace(/^\./, '');           // strip a leading dot
            var a = path.split('.');
            for (var i = 0; i < a.length; ++i) {
                var k = a[i];
                if (k in obj) {
                    obj = obj[k];
                } else {
                    return;
                }
            }
            return obj;
        };

        GeneralUtil.getObjAndPropByPath = (obj, path) => {
            if (!obj || !path) {
                return obj;
            }
            path = path.replace(/\[(\w+)\]/g, '.$1'); // convert indexes to properties
            path = path.replace(/^\./, '');           // strip a leading dot
            var a = path.split('.');
            if (a.length > 1) {
                for (var i = 0; i < (a.length - 1); ++i) {
                    var k = a[i];
                    if (k in obj) {
                        obj = obj[k];
                    } else {
                        return;
                    }
                }
            }
            return [obj, a[a.length - 1]];
        }

        GeneralUtil.moveElementOfArrayByIndex = (array, index, delta) => {
            let newIndex = index + delta;
            if (array.length < 2) {
                toaster.pop({
                    type: 'error',
                    title: 'Insufficient elements present in array to move!'
                });
                return; // Insufficient elements present.
            }
            if (newIndex < 0 || newIndex == array.length) {
                toaster.pop({
                    type: 'error',
                    title: 'Element is at extreme end of array to move!'
                });
                return; // Already at the top or bottom.
            }
            let indexes = [index, newIndex].sort((a, b) => a - b); // Sort the indices
            array.splice(indexes[0], 2, array[indexes[1]], array[indexes[0]]); // Replace from lowest index, two elements, reverting the order
        };

        const STRENGTH = {
            0: { text: "Too Short", description: "Password must be of minimum 8 characters" },
            1: { text: "Weak", description: "Password should contain at least one lowercase letter, one uppercase letter, one number and one special character." },
            2: { text: "Fair", description: "Password should not contain three or more consecutive same characters" },
            3: { text: "Good", description: "Password should not contain user name or application name" },
            4: { text: "Strong", description: "Password is strong enough" }
        }

        GeneralUtil.checkPassword = (passwordField, passwordValue, userName) => {
            var password = document.getElementById(passwordField);
            var meter = document.getElementById('password-strength-meter');
            var text = document.getElementById('password-strength-text');
            meter.value = null;
            var val = password.value;

            let lowerPassword = passwordValue && passwordValue.toLowerCase();


            if (!passwordValue || passwordValue && passwordValue.length < 8) {
                meter.value = 0;
            } else if (!/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^a-zA-Z0-9])(?!.*\s).{8,}$/.test(passwordValue)) {
                meter.value = 1;
            } else if (!GeneralUtil.checkForConsecutive(passwordValue)) {
                meter.value = 2;
            } else if (lowerPassword && (lowerPassword.includes('techo') || lowerPassword.includes('medplat') ||
                lowerPassword.includes('ekavach') || lowerPassword.includes('impacthealth') || lowerPassword.includes(userName))) {
                meter.value = 3;
            } else {
                meter.value = 4;
            }

            if (val !== "") {
                text.innerHTML = "<strong>" + STRENGTH[meter.value].text + ":" + "</strong>" + "<span class='feedback'>" + STRENGTH[meter.value].description + "</span";
            }
            else {
                text.innerHTML = "";
            }

            return {
                value: meter.value,
                text: text.innerHTML
            }
        }

        GeneralUtil.checkForConsecutive = function (passwordValue) {
            // Check for sequential digits
            for (var i in passwordValue) {
                if (+passwordValue[+i + 1] == +passwordValue[i] + 1 &&
                    +passwordValue[+i + 2] == +passwordValue[i] + 2) {
                    return false;
                }
            }

            // Check for sequential alphabetical characters
            for (var i in passwordValue) {
                if (String.fromCharCode(passwordValue.charCodeAt(i) + 1) == passwordValue[+i + 1] &&
                    String.fromCharCode(passwordValue.charCodeAt(i) + 2) == passwordValue[+i + 2]) {
                    return false;
                }
            }

            return true;
        }

        GeneralUtil.getImagesPath = () => {

            return 'img/chip/';
        }

        GeneralUtil.getLogoImages = () => {
            let imagesPath = GeneralUtil.getImagesPath();
            let logoImages = [{
                link: "https://chipstaging.argusoft.com/",
                source: `${imagesPath}ZDCHP.png`
            }];
            
            
            return [imagesPath, logoImages];
        }

        GeneralUtil.getLocalLanguage = () => {
            
            return 'English';
        }

        GeneralUtil.getAppName = () => {
            
            return 'chip';
        }

        GeneralUtil.getEnv = () => {
            return ENV.implementation
        }

        GeneralUtil.transformArrayToKeyValue = (array, keyProperty, valueProperty) => {
            return array.map((element) => {
                return {
                    key: element[keyProperty],
                    value: element[valueProperty]
                }
            });
        }
        
        GeneralUtil.getChildState = (screeningObj) => {
            if (screeningObj.belowSixMonths === false &&
                screeningObj.apetiteTest === true &&
                !!screeningObj.bilateralPittingOedema &&
                screeningObj.bilateralPittingOedema === 'NOTPRESENT' &&
                screeningObj.medicalComplicationsPresent === false &&
                ((screeningObj.midUpperArmCircumference >= 11.5 && screeningObj.midUpperArmCircumference <= 12.5) ||
                (screeningObj.sdScore === 'SD2' && screeningObj.sdScore != 'SD3' && screeningObj.sdScore != 'SD4'))) {
                return 'MAM';
            } else if (screeningObj.belowSixMonths === false &&
                ( screeningObj.apetiteTest === false ||
                  screeningObj.midUpperArmCircumference < 11.5  ||
                  screeningObj.sdScore === 'SD3' ||
                  screeningObj.sdScore === 'SD4' ||
                  (!!screeningObj.bilateralPittingOedema &&
                    screeningObj.bilateralPittingOedema !== 'NOTPRESENT') ||
                    screeningObj.medicalComplicationsPresent === true)) {
                return 'SAM';
            } else if (screeningObj.belowSixMonths === true &&
                ( screeningObj.breastSuckingProblems === true ||
                  screeningObj.sdScore === 'SD3' ||
                  screeningObj.sdScore === 'SD4')) {
                return 'SAM';    
            } else {
                return 'NORMAL';
            }
        }

        GeneralUtil.getAllActiveLanguages = () => {
            return $http.get(APP_CONFIG.apiPath + "/translation/activeLanguages").then(response => {
                if (response && response.data && response.data.length > 0) {
                    return response.data;
                } else {
                    return [];
                }
            }).catch(error => {
                return [];
            })
        }

        GeneralUtil.getNewPreferredLanguage = (preferredLanguage) => {
            // if (preferredLanguage && preferredLanguage === 'GU') {
            //     switch (ENV.implementation) {
            //         case 'medplat':
            //         case 'sewa_rural':
            //             return 'gu';

            //         case 'telangana':
            //             return 'te';

            //         default:
            //             return 'hi';
            //     }
            // } else {
            //     return preferredLanguage;
            // }
            return preferredLanguage;
        }

        return GeneralUtil;
    });
})(window.angular, window.Math);
