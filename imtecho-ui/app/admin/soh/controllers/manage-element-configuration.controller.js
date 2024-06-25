(function (angular) {
    function ManageSohElementConfiguration($state, Mask, toaster, GeneralUtil, SohElementConfigurationDAO, AuthenticateService, APP_CONFIG, $uibModal, QueryDAO, $q, SelectizeGenerator, RoleDAO, PermissionType, DocumentDAO) {
        let ctrl = this;
        ctrl.isEditMode = false;
        ctrl.elementId = $state.params.id ? Number($state.params.id) : null;
        ctrl.pieChartFields = [];
        ctrl.elementFields = [];
        ctrl.tabFields = [];
        ctrl.allowedFileExtns = ['jpg', 'png', 'jpeg'];
        ctrl.filePayload = { file: {} };
        ctrl.isFileRemoving = {};
        ctrl.isFileUploadProcessing = {};

        ctrl.fileUploadOptions = {
            singleFile: true,
            testChunks: false,
            allowDuplicateUploads: false,
            simultaneousUploads: 1,
            chunkSize: 10 * 1024 * 1024 * 1024,
            headers: {
                Authorization: 'Bearer ' + AuthenticateService.getToken()
            },
            uploadMethod: 'POST'
        };

        const _fetchElementById = function () {
            Mask.show();
            AuthenticateService.getAssignedFeature("techo.manage.sohElementConfiguration").then(function (res) {
                ctrl.rights = res.featureJson;
                if (ctrl.rights.normal || ctrl.rights.advanced) {
                    let promises = [];
                    promises.push(SohElementConfigurationDAO.getElementById(ctrl.elementId));
                    promises.push(SohElementConfigurationDAO.getElementModules(true));
                    promises.push(AuthenticateService.getLoggedInUser());
                    $q.all(promises).then(function (responses) {
                        ctrl.elementObj = responses[0];
                        ctrl.elementModuleList = responses[1];
                        ctrl.loggedInUser = responses[2].data;
                        ctrl.fetchRolesDetails();
                        ctrl.getPermissionDetails();
                        ctrl.getImageById(ctrl.elementObj.fileId);
                        try {
                            ctrl.tabFields = ctrl.elementObj.tabsJson ? JSON.parse(ctrl.elementObj.tabsJson) : [];
                        } catch (error) {
                            console.log('Error while parsing tabsJson JSON :: ', error);
                            ctrl.tabFields = [];
                        }
                    }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide);
                } else {
                    toaster.pop('error', 'You don\'t have rights to access this page.');
                    Mask.hide();
                }
            }, function () {
                GeneralUtil.showMessageOnApiCallFailure();
                Mask.hide();
            });
        }

        ctrl.getImageById = function (id) {
            console.log(ctrl.elementObj)
            SohElementConfigurationDAO.getFileById(id).then(res => {
                ctrl.isFileUploaded = true;
                ctrl.attachmentImage = URL.createObjectURL(res.data)
            }, err => {
                ctrl.attachmentImage = null;
            })
        }

        const _init = function () {
            console.log(PermissionType)
            ctrl.permissionType = PermissionType;
            var selectizeObject = SelectizeGenerator.generateUserSelectize();
            selectizeObject.config.load = function (query, callback) {
                var selectize = this;
                var value = this.getValue();
                if (!value) {
                    selectize.clearOptions();
                    selectize.refreshOptions();
                }

                var promise;

                var queryDto = {
                    code: 'user_search_for_selectize',
                    parameters: {
                        searchString: query
                    }
                };

                promise = QueryDAO.execute(queryDto);
                promise.then(function (res) {
                    angular.forEach(res.result, function (result) {
                        result._searchField = query;
                    });
                    callback(res.result);

                }, function (err) {
                    GeneralUtil.showMessageOnApiCallFailure(err);
                    callback();
                });
            }
            ctrl.selectizeOptions = selectizeObject.config;
            var userList = []
            var localUserList = angular.copy(userList);
            _.each(localUserList, function (emp) {
                emp.enabled = true;

            });
            ctrl.allUsers = localUserList;
            if (ctrl.elementId) {
                ctrl.isEditMode = true;
                _fetchElementById();
            } else {
                Mask.show();
                AuthenticateService.getAssignedFeature("techo.manage.sohElementConfiguration").then(function (res) {
                    ctrl.rights = res.featureJson;
                    if (ctrl.rights.advanced) {
                        let promises = [];
                        promises.push(SohElementConfigurationDAO.getElementModules(true));
                        promises.push(AuthenticateService.getLoggedInUser());
                        $q.all(promises).then(function (responses) {
                            ctrl.elementModuleList = responses[0];
                            ctrl.loggedInUser = responses[1].data;
                        }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide);
                    } else {
                        toaster.pop('error', 'You don\'t have rights to access this page.');
                        Mask.hide();
                    }
                }, function () {
                    GeneralUtil.showMessageOnApiCallFailure();
                    Mask.hide();
                });
            }
        };

        ctrl.getPermissionDetails = function () {
            Mask.show();
            QueryDAO.execute({
                code: 'fetch_soh_element_permissions_details',
                parameters: {
                    element_id: ctrl.elementId
                }
            }).then(function (res) {
                ctrl.permissionDetailsList = res.result;
                if (ctrl.elementObj && ctrl.permissionDetailsList.length > 0 && ctrl.permissionDetailsList.find(x => x.permission_type == ctrl.permissionType.ALL)) {
                    ctrl.elementObj.permissionType = ctrl.permissionType.ALL;
                }
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        }

        ctrl.fetchRolesDetails = function () {
            var roleList = [];
            Mask.show();
            var rolePromise = RoleDAO.retireveAll(true).then(function (data) {
                return data;
            }, GeneralUtil.showMessageOnApiCallFailure);
            $q.all([rolePromise]).then(function (data) {
                roleList = data[0];
                _.each(roleList, function (userGroup) {
                    userGroup.enabled = true;
                });
                ctrl.allDesignation = angular.copy(roleList);
                angular.forEach(roleList, function (designation) {
                    designation.enabled = true;
                });
            }).finally(function () {
                Mask.hide();
            });
        }

        let _preparePayload = function () {
            ctrl.tabFields.forEach(tab => {
                tab.fields.sort(function (a, b) {
                    let firstSeq = a.sequence;
                    let secondSeq = b.sequence;
                    return (firstSeq === null || firstSeq === '') - (secondSeq === null || secondSeq === '') || (firstSeq - secondSeq);
                })
            });
            ctrl.payload = {
                id: ctrl.elementId,
                elementName: ctrl.elementObj.elementName,
                elementDisplayShortName: ctrl.elementObj.elementDisplayShortName,
                elementDisplayName: ctrl.elementObj.elementDisplayName,
                elementDisplayNamePostfix: ctrl.elementObj.elementDisplayNamePostfix,
                order: ctrl.elementObj.elementOrder || null,
                isPublic: ctrl.elementObj.isPublic,
                isHidden: ctrl.elementObj.isHidden,
                isTimelineEnable: ctrl.elementObj.isTimelineEnable,
                enableReporting: ctrl.elementObj.enableReporting,
                upperBound: ctrl.elementObj.upperBound,
                lowerBound: ctrl.elementObj.lowerBound,
                upperBoundForRural: ctrl.elementObj.upperBoundForRural,
                lowerBoundForRural: ctrl.elementObj.lowerBoundForRural,
                isSmallValuePositive: ctrl.elementObj.isSmallValuePositive,
                fieldName: ctrl.elementObj.fieldName,
                module: ctrl.elementObj.module,
                state: ctrl.elementObj.state,
                target: ctrl.elementObj.target,
                targetForRural: ctrl.elementObj.targetForRural,
                targetForUrban: ctrl.elementObj.targetForUrban,
                targetMid: ctrl.elementObj.targetMid,
                targetMidEnable: ctrl.elementObj.targetMidEnable,
                tabsJson: ctrl.tabFields ? JSON.stringify(ctrl.tabFields) : '',
                modifiedBy: ctrl.loggedInUser.id,
                modifiedOn: moment().utcOffset('+05:30').format(),
                showAnalyticsButton: ctrl.elementObj.showAnalyticsButton,
                permissionType: ctrl.elementObj.permissionType === ctrl.permissionType.ALL ? ctrl.permissionType.ALL : null,
                userIds: ctrl.elementObj.userIds ? ctrl.elementObj.userIds.split() : [],
                designationIds: ctrl.elementObj.designationIds ? ctrl.elementObj.designationIds : [],
                footerDescription: ctrl.elementObj.footerDescription,
                isFilterEnable: ctrl.elementObj.isFilterEnable,
                rankFieldName: ctrl.elementObj.rankFieldName,
                showInMenu: ctrl.elementObj.showInMenu
            };
        }

        ctrl.addOrEditElementDetails = function () {
            ctrl.manageSohElementConfigurationForm.$setSubmitted();
            if (ctrl.manageSohElementConfigurationForm.$valid) {
                Mask.show();
                _preparePayload();
                if (!ctrl.isEditMode) {
                    ctrl.payload.createdBy = ctrl.loggedInUser.id;
                    ctrl.payload.createdOn = moment().utcOffset('+05:30').format();
                    ctrl.payload.fileId = ctrl.filePayload.file.id ? ctrl.filePayload.file.id : null
                } else {
                    ctrl.payload.createdBy = ctrl.elementObj.createdBy;
                    ctrl.payload.createdOn = ctrl.elementObj.createdOn;
                    ctrl.payload.fileId = ctrl.filePayload.file.id ? ctrl.filePayload.file.id : ctrl.elementObj.fileId
                }
                SohElementConfigurationDAO.createOrUpdateElement(ctrl.payload).then(function () {
                    if (ctrl.isEditMode) {
                        toaster.pop('success', 'Element Edited Successfully!');
                    } else {
                        toaster.pop('success', 'Element Added Successfully!');
                    }
                    $state.go('techo.manage.sohElementConfiguration', { selectedTab: 0 });
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                });
            }else{
                let invalidFields = [];
                Object.keys(ctrl.manageSohElementConfigurationForm).forEach(key => {
                    if(typeof(ctrl.manageSohElementConfigurationForm[key]) === 'object' &&
                    !['$$animate', '$$classCache', '$$controls', '$$element', '$$parentForm', '$$success', '$error'].includes(key)){
                        invalidFields.push(ctrl.manageSohElementConfigurationForm[key]);
                    }
                })
                ctrl.invalidFields = invalidFields.filter(field => field.$invalid);
                ctrl.invalidFields.forEach(field => {
                    field.error = Object.keys(field.$error)[0];
                })
            }
        }

        ctrl.addTabFields = function () {
            if (ctrl.tabFields === undefined) {
                ctrl.tabFields = [];
            }
            ctrl.tabFields.push({
                tabName: '',
                tabNameStyle: null,
                elementName: '',
                elementNameStyle: null,
                elementDisplayNamePostfix: '',
                elementDisplayNamePostfixStyle: null,
                fieldName: '',
                fieldNameStyle: null,
                elementLineListLable: '',
                elementLineListLableStyle: null,
                noOfHeading: null,
                noOfHeadingStyle: null,
                headingLabel1: '',
                headingLabel1Style: null,
                headingField1: '',
                headingField1Style: null,
                headingLabel2: '',
                headingLabel2Style: null,
                headingField2: '',
                headingField2Style: null,
                sortField: '',
                sortFieldStyle: null,
                footerDescription: '',
                minLocationLevel: null,
                maxLocationLevel: null,
                colorField: '',
                colorFieldStyle: null,
                lineList: {
                    elementLineListLable: null,
                    elementLineListLableStyle: null,
                    isEnable: null,
                    field: '',
                    fieldStyle: null,
                    query: '',
                    queryStyle: null,
                    lastLevel: null,
                    paginationEnable: null,
                    limit: null,
                    isSearchingEnable: null,
                    lastLevelStyle: null
                },
                help: {
                    text: '',
                    textStyle: null
                },
                isHeatMapEnable: null,
                isAnalyticsPanelEnable: null,
                analyticsPanels: [],
                map: {
                    isEnable: null,
                    level: null,
                    levelStyle: null,
                    field: '',
                    fieldStyle: null,
                    isOpacityEnable: null,
                    isSmallValuePositive: null
                },
                isPublic: null,
                isTimelineEnable: null,
                showAnalyticsButton: null,
                isMarkerReportEnable: null,
                isCovidHealthInfraReportEnable: null,
                isSummarizingViewEnable: null,
                summarizingMinLocationLevel: null,
                summarizingMaxLocationLevel: null,
                pieChart: {
                    isEnable: null,
                    fields: []
                },
                fields: []
            });
        }

        ctrl.removeTabField = function (index) {
            ctrl.tabFields.splice(index, 1);
        }

        ctrl.addPieChartField = function (index) {
            if (ctrl.tabFields[index].pieChart.fields === undefined) {
                ctrl.tabFields[index].pieChart.fields = [];
            }
            ctrl.tabFields[index].pieChart.fields.push({
                field: '',
                fieldStyle: null,
                color: '',
                colorStyle: null,
                name: '',
                nameStyle: null
            });
        }

        ctrl.removePieChartField = function (index, parentIndex) {
            ctrl.tabFields[parentIndex].pieChart.fields.splice(index, 1);
        }


        ctrl.addAnalyticsPanel = function (index) {
            if (ctrl.tabFields[index].analyticsPanels === undefined) {
                ctrl.tabFields[index].analyticsPanels = [];
            }
            ctrl.tabFields[index].analyticsPanels.push({
                title: '',
                titleStyle: null,
                query: '',
                queryStyle: null,
                note: '',
                noteStyle: null
            });
        }

        ctrl.removeAnalyticsPanel = function (index, parentIndex) {
            ctrl.tabFields[parentIndex].analyticsPanels.splice(index, 1);
        }

        ctrl.addElementField = function (index) {
            if (ctrl.tabFields[index].fields === undefined) {
                ctrl.tabFields[index].fields = [];
            }
            ctrl.tabFields[index].fields.push({
                name: '',
                nameStyle: null,
                shortName: '',
                shortNameStyle: null,
                fieldName: '',
                fieldNameStyle: null,
                fieldType: '',
                isColorField: null,
                isTimelineEnable: null,
                isDBField: null,
                value: '',
                valueStyle: null,
                isPublic: null,
                help: '',
                helpStyle: null,
                isPrimary: null,
                primaryMinLevel: null,
                primaryMinLevelStyle: null,
                primaryMaxLevel: null,
                primaryMaxLevelStyle: null,
                isSecondary: null,
                paginationEnable: null,
                isSearchingEnable: null,
                secondaryMinLevel: null,
                secondaryMinLevelStyle: null,
                secondaryMaxLevel: null,
                isSummarizingView: null,
                secondaryMaxLevelStyle: null,
                query: '',
                queryStyle: null,
                queryLevel: null,
                queryLevelStyle: null,
                limit: null,
                sequence: null,
                showAnalyticsButton: null
            });
        }

        ctrl.removeElementField = function (index, parentIndex) {
            ctrl.tabFields[parentIndex].fields.splice(index, 1);
        }

        ctrl.onFileAdded = function ($file, $event, $flow) {
            ctrl.responseMessage = {};
            if (!ctrl.allowedFileExtns.includes($file.getExtension())) {
                ctrl.filePayload.isError = true;
                ctrl.filePayload.errorMessage = `Only .${ctrl.allowedFileExtns.join(', .')} files supported!`;
                $event.preventDefault();
                return false;
            }
            delete ctrl.filePayload.errorMessage;
            ctrl.filePayload.isError = false;
            $flow.opts.target = `${APP_CONFIG.apiPath}/document/uploaddocument/TECHO/false`;
        };

        ctrl.onFileSubmitted = function ($files, $event, $flow) {
            if (!$files || $files.length === 0) {
                return;
            }

            Mask.show();
            AuthenticateService.refreshAccessToken().then(function () {
                $flow.opts.headers.Authorization = 'Bearer ' + AuthenticateService.getToken();
                ctrl.filePayload.flow = ($flow);
                $flow.upload();
                if (!ctrl.filePayload.isError) {
                    ctrl.isFileUploading = true;
                    $files.forEach(file => ctrl.isFileUploadProcessing[file.name] = true)
                }
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        };

        ctrl.onFileSuccess = function ($file, $message, $flow) {
            ctrl.isFileUploading = false;
            ctrl.isFileUploadProcessing[$file.name] = false;
            ctrl.getImageById(JSON.parse($message).id);
            ctrl.filePayload.file = {
                id: JSON.parse($message).id,
                name: $file.name
            };
        };

        ctrl.onFileError = function ($file, $message) {
            ctrl.isFileUploading = false;
            ctrl.isFileUploadProcessing[$file.name] = false;
            ctrl.filePayload.flow.files = ctrl.filePayload.flow.files.filter(e => e.name !== $file.name);
            toaster.pop('danger', 'Error in file upload!');
        };

        function _removeFile(fileName) {
            if (ctrl.filePayload.flow && ctrl.filePayload.flow.files) {
                ctrl.filePayload.flow.files = ctrl.filePayload.flow.files
                    .filter(e => e.name !== fileName);
            }
            ctrl.attachmentImage = null;
            ctrl.filePayload.file = {}
        }

        ctrl.onRemoveFile = function (fileName) {
            if (ctrl.filePayload.file.id) {
                ctrl.isFileRemoving[fileName] = true;
                DocumentDAO.removeFile(ctrl.filePayload.file.id)
                    .then(function () {
                        _removeFile(fileName);
                    }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                        ctrl.isFileRemoving[fileName] = false;
                    });
            } else {
                _removeFile(fileName);
            }
        };

        ctrl.analyzeElement = function () {
            let modalInstance = $uibModal.open({
                templateUrl: 'app/admin/soh/views/analyze-element-modal.html',
                windowClass: 'cst-modal',
                backdrop: 'static',
                size: 'xl',
                controllerAs: 'analyzeCtrl',
                controller: function ($uibModalInstance) {
                    let analyzeCtrl = this;
                    analyzeCtrl.selectedTimelineType;
                    analyzeCtrl.timelineTypes = [{
                        key: 'LAST_7_DAYS',
                        value: 'Last 7 days'
                    }, {
                        key: 'LAST_30_DAYS',
                        value: 'Last 30 days'
                    }, {
                        key: 'LAST_365_DAYS',
                        value: 'Last 365 days'
                    }, {
                        key: 'YEAR_04_2019',
                        value: 'Current FY'
                    }];
                    analyzeCtrl.submit = function () {
                        if (analyzeCtrl.analyzeElementForm.$valid) {
                            const _validatePropertyValue = function (propertyValue) {
                                return propertyValue !== null && propertyValue !== undefined && propertyValue !== '' ? propertyValue : null;
                            }
                            let payload = {
                                elementName: _validatePropertyValue(ctrl.elementObj.elementName),
                                upperBound: _validatePropertyValue(ctrl.elementObj.upperBound),
                                lowerBound: _validatePropertyValue(ctrl.elementObj.lowerBound),
                                upperBoundForRural: _validatePropertyValue(ctrl.elementObj.upperBoundForRural),
                                lowerBoundForRural: _validatePropertyValue(ctrl.elementObj.lowerBoundForRural),
                                target: _validatePropertyValue(ctrl.elementObj.target),
                                targetMid: _validatePropertyValue(ctrl.elementObj.targetMid),
                                targetForUrban: _validatePropertyValue(ctrl.elementObj.targetForUrban),
                                targetForRural: _validatePropertyValue(ctrl.elementObj.targetForRural),
                                targetMidEnable: _validatePropertyValue(ctrl.elementObj.targetMidEnable),
                                timelineType: _validatePropertyValue(analyzeCtrl.selectedTimelineType)
                            }
                            Mask.show();
                            QueryDAO.execute({
                                code: 'soh_element_analysis',
                                parameters: payload
                            }).then(function (res) {
                                analyzeCtrl.analyzedData = res.result;
                            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                                Mask.hide();
                            });
                        }
                    }
                    analyzeCtrl.ok = function () {
                        $uibModalInstance.close();
                    }
                    analyzeCtrl.cancel = function () {
                        $uibModalInstance.dismiss();
                    }
                },
                resolve: {
                }
            });
            modalInstance.result
                .then(function () { }, function () { })
        }

        ctrl.manageStyle = function (propertyLabel, propertyModelObj, propertyModelName) {
            let modalInstance = $uibModal.open({
                templateUrl: 'app/admin/soh/views/manage-property-style-modal.html',
                windowClass: 'cst-modal',
                backdrop: 'static',
                size: 'md',
                controllerAs: 'manageStyleCtrl',
                controller: function ($uibModalInstance) {
                    let manageStyleCtrl = this;
                    manageStyleCtrl.propertyLabel = propertyLabel;
                    manageStyleCtrl.propertyModel = propertyModelObj[propertyModelName];
                    manageStyleCtrl.stylePropertyLabel = 'Style of ' + propertyLabel + (manageStyleCtrl.propertyModel ? ' (' + manageStyleCtrl.propertyModel + ')' : '');
                    manageStyleCtrl.stylePropertyModel = propertyModelObj[propertyModelName + 'Style'] ? JSON.stringify(propertyModelObj[propertyModelName + 'Style']) : null;

                    manageStyleCtrl.ok = function () {
                        try {
                            let parsedJson = manageStyleCtrl.stylePropertyModel ? JSON.parse(manageStyleCtrl.stylePropertyModel) : null;
                            propertyModelObj[propertyModelName + 'Style'] = parsedJson;
                            toaster.pop('success', 'JSON parsed successfully.');
                            $uibModalInstance.close();
                        } catch (error) {
                            console.error('Error while parsing JSON ::: ', error);
                            toaster.pop('error', 'Error while parsing JSON. Please try again.');
                        }
                    }
                    manageStyleCtrl.cancel = function () {
                        $uibModalInstance.dismiss();
                    }
                },
                resolve: {
                }
            });
            modalInstance.result
                .then(function () { }, function () { })
        }

        ctrl.showImageDescription = function (url) {
            console.log('clicked')
            let modalInstance2 = $uibModal.open({
                templateUrl: 'app/admin/soh/views/manage-image-description-modal.html',
                windowClass: 'cst-modal',
                backdrop: 'static',
                controllerAs: 'manageImageDescriptionCtrl',
                controller: function ($uibModalInstance) {
                    let manageImageDescriptionCtrl = this;
                    manageImageDescriptionCtrl.imageUrl = "img/soh/" + url;

                    manageImageDescriptionCtrl.ok = function () {
                        $uibModalInstance.close();
                    }
                    manageImageDescriptionCtrl.cancel = function () {
                        $uibModalInstance.dismiss();
                    }
                },
                resolve: {
                }
            });
            modalInstance2.result
                .then(function () { }, function () { })
        }

        ctrl.savePermission = function () {
            let dtoList = [];
            let sequence = 0;
            if (ctrl.elementObj.designationIds && ctrl.elementObj.designationIds.length > 0) {
                sequence = sequence + 1;
                let rolePermission = {
                    code: 'insert_soh_element_permissions',
                    parameters: {
                        elementId: ctrl.elementId,
                        permissionType: ctrl.permissionType.ROLE,
                        ref_ids: ctrl.elementObj.designationIds
                    },
                    sequence: sequence
                };
                dtoList.push(rolePermission);
            }
            if (ctrl.elementObj.userIds) {
                sequence = sequence + 1;
                let userPermission = {
                    code: 'insert_soh_element_permissions',
                    parameters: {
                        elementId: ctrl.elementId,
                        permissionType: ctrl.permissionType.USER,
                        ref_ids: ctrl.elementObj.userIds.split()
                    },
                    sequence: sequence
                };
                dtoList.push(userPermission);
            }

            Mask.show();
            QueryDAO.executeAllQuery(dtoList).then(function (res) {
                ctrl.elementObj.designationIds = [];
                ctrl.elementObj.userIds = null;
                ctrl.getPermissionDetails();
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        }

        ctrl.saveAllPermission = function () {
            if (ctrl.permissionDetailsList.find(x => x.permission_type == ctrl.permissionType.ALL)) {
                return;
            }
            Mask.show();
            QueryDAO.execute({
                code: 'insert_all_soh_element_permissions',
                parameters: {
                    elementId: ctrl.elementId,
                    permissionType: ctrl.permissionType.ALL
                }
            }).then(function (res) {
                ctrl.getPermissionDetails();
            }, GeneralUtil.showMessageOnApiCallFailure)
                .finally(function () {
                    Mask.hide();
                });
        }

        ctrl.deleteConfigModal = function (refId) {
            var modalInstance = $uibModal.open({
                templateUrl: 'app/common/views/confirmation.modal.html',
                controller: 'ConfirmModalController',
                windowClass: 'cst-modal',
                size: 'med',
                resolve: {
                    message: function () {
                        return "Are you sure you want to delete this?";
                    }
                }
            });
            modalInstance.result.then(function () {
                Mask.show();
                QueryDAO.execute({
                    code: 'delete_soh_element_permissions_detail',
                    parameters: {
                        ref_id: refId
                    }
                }).then(function (res) {
                    toaster.pop('success', "Permission removed successfully");
                    ctrl.getPermissionDetails();
                }, GeneralUtil.showMessageOnApiCallFailure)
                    .finally(function () {
                        Mask.hide();
                    });
            }, function () {
            });
        };

        _init();
    }
    angular.module('imtecho.controllers').controller('ManageSohElementConfiguration', ManageSohElementConfiguration);
})(window.angular);
