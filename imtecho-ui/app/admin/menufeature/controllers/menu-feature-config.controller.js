(function (angular) {
    function MenuConfigController($q, QueryDAO, $filter, $state, $uibModal, Mask, MenuConfigDAO, GeneralUtil, toaster, RoleDAO, SelectizeGenerator) {
        var menuconfig = this;
        var roleList = [], userGroupList = [], userList = [], menuConfigByTypePromises = {};
        menuconfig.displayFeatureNameMap = null;

        var extendFeatureJson = function (defaultJson, assignedJson) {
            var newJson = {};
            angular.forEach(defaultJson, function (value, key) {
                if (assignedJson && assignedJson.hasOwnProperty(key)) {
                    newJson[key] = assignedJson[key];
                } else {
                    newJson[key] = value;
                }
            });
            return newJson;
        };

        var init = function () {
            const allowedEnv = ['chip', 'imomcare']
            menuconfig.env = GeneralUtil.getEnv();
            menuconfig.isReportAllowed = allowedEnv.includes(menuconfig.env);
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
                    res.result = res.result.filter((user) => {
                        return !menuconfig.loadedConfig.rightList.some(function (f) {
                            return f.code === "User" && f.userId === user.id;
                        });
                    });
                    callback(res.result);
                }, function (err) {
                    GeneralUtil.showMessageOnApiCallFailure(err);
                    callback();
                });
            }
            menuconfig.selectizeOptions = selectizeObject.config;
            menuconfig.types = [ "training", "manage", "admin", "report"];
            // if(menuconfig.env === 'chip'){
            //     menuconfig.types.push('report')
            // }
            menuconfig.type = menuconfig.types[0];
            menuconfig.selectedTab = menuconfig.types[0];
            menuconfig.pageSet = true;
            Mask.show();
            var rolePromise = RoleDAO.retireveAll(true).then(function (data) {
                return data;
            }, GeneralUtil.showMessageOnApiCallFailure);
            $q.all([rolePromise]).then(function (data) {
                roleList = data[0];
                angular.forEach(roleList, function (designation) {
                    designation.enabled = true;
                });
            }).finally(function () {
                Mask.hide();
            });
        };

        menuconfig.loadConfig = function (config) {
            config.userIds = [];
            config.designationIds = [];
            config.groupId = [];
            menuconfig.configRetrivalRunning = true;
            Mask.show();
            MenuConfigDAO.getConfigurationTypeById({ id: parseInt(config.id) }).then(function (response) {
                var localDesignationList = angular.copy(roleList);
                var localUserGroupList = angular.copy(userGroupList);
                var localUserList = angular.copy(userList);
                response.featureJson = angular.fromJson(response.featureJson);
                if (response.userMenuItemDtos && response.userMenuItemDtos.length > 0) {
                    angular.forEach(response.userMenuItemDtos, function (right) {
                        right.featureJson = extendFeatureJson(response.featureJson, angular.fromJson(right.featureJson));
                        if (right.designationId) {
                            right.code = 'Role';
                            right.displayName = right.roleName;
                        } else {
                            right.code = 'User';
                            right.displayName = right.fullName;
                        }
                    });
                } else {
                    _.each(localDesignationList, function (desg) {
                        desg.enabled = true;
                    });
                    _.each(localUserGroupList, function (userGroup) {
                        userGroup.enabled = true;
                    });
                    _.each(localUserList, function (emp) {
                        emp.enabled = true;
                    });
                }
                config.allUsers = localUserList;
                config.allDesignation = localDesignationList;
                config.allUserGroups = localUserGroupList;
                config.rightList = response.userMenuItemDtos;
                config.allDesignation = config.allDesignation.filter((designation) => {
                    return !config.rightList.some(function (f) {
                        return f.code === "Role" && f.designationId === designation.id;
                    });
                });
                menuconfig.loadedConfig = config;
                if (menuconfig.loadedConfig.featureJson != '{}' && !!menuconfig.loadedConfig.featureJson) {
                    menuconfig.getCustomDisplayFeatureName();
                }
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
                menuconfig.configRetrivalRunning = false;
            });
        };

        menuconfig.getCustomDisplayFeatureName = function () {
            if (!!menuconfig.loadedConfig.featureJson) {
                var json = JSON.parse(menuconfig.loadedConfig.featureJson);
                var item = Object.keys(json);
                var queryDto = {
                    code: 'retrieve_display_name_for_feature',
                    parameters: {
                        feature_name_list: item, // passing array of string
                        menu_id: menuconfig.loadedConfig.id
                    }
                };
                QueryDAO.execute(queryDto).then(function (res) {
                    menuconfig.displayFeatureNameMap = null;
                    var result = res.result;
                    if (result.length > 0) {
                        menuconfig.displayFeatureNameMap = result.reduce(function (map, obj) {
                            map[obj.feature_name] = obj.display_name;
                            return map;
                        }, {});
                    }
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                });
            }
        };

        menuconfig.getTabData = function (type) {
            if (type) {
                Mask.show();
                menuconfig.type = type;
                if (!menuConfigByTypePromises[type]) {
                    menuConfigByTypePromises[type] = MenuConfigDAO.getMenuConfigByType({ action: type });
                }
                menuConfigByTypePromises[type].then(function (res) {
                    menuconfig.menuList = $filter('orderBy')(res, ['groupName', 'name']);
                    menuconfig.loadConfig(menuconfig.menuList[0]);
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                });
                menuconfig.selectedTab = type;
            }
        };

        menuconfig.saveMenuConfig = function (config) {
            var rights = {};
            if (config.designationIds && config.designationIds.length > 0) {
                rights.designationId = config.designationIds.toString();
            }
            if (config.userIds && config.userIds.length > 0) {
                rights.userId = config.userIds.toString();
            }
            if (isUserOrRoleAlreadyAdded(rights)) {
                toaster.pop('error', 'This user/role is already added. Please add another');
                config.designationIds = [];
                config.userIds = [];
            } else {
                Mask.show();
                MenuConfigDAO.saveMenuItem(config.id, rights).then(function (res) {
                    menuconfig.loadConfig(config);
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                });
            }
        };

        menuconfig.deleteConfigModal = function (rightId, config) {
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
                MenuConfigDAO.deleteConfig({ id: rightId }).then(function () {
                    menuconfig.loadConfig(config);
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                });
            }, function () { });
        };

        menuconfig.featureUpdated = function (right) {
            var copyOfRight = angular.copy(right);
            copyOfRight.featureJson = angular.toJson(copyOfRight.featureJson);
            copyOfRight.menuConfigId = menuconfig.loadedConfig.id;
            Mask.show();
            MenuConfigDAO.updateUserMenuItem(copyOfRight).then(function () {
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function (e) {
                Mask.hide();
            });
        };

        menuconfig.checkAll = function (right) {
            angular.forEach(right.featureJson, function (value, key) {
                right.featureJson[key] = true;
            });
            menuconfig.featureUpdated(right);
        };

        menuconfig.unCheckAll = function (right) {
            angular.forEach(right.featureJson, function (value, key) {
                right.featureJson[key] = false;
            });
            menuconfig.featureUpdated(right);
        };

        menuconfig.search = function (item) {
            if (!menuconfig.searchQuery ||
                item.name.toLowerCase().indexOf(menuconfig.searchQuery.toLowerCase()) !== -1 ||
                (item.groupName && item.groupName.toLowerCase().indexOf(menuconfig.searchQuery.toLowerCase()) !== -1)) {
                return true;
            }
            return false;
        };

        menuconfig.addFeatureClicked = function(){
            $state.go('techo.manage.addfeature')
        }
        menuconfig.editFeatureClicked = function(config){
            $state.go('techo.manage.addfeature',{featureId:config.id,featureType:menuconfig.type})
        }
        menuconfig.showFlywayClicked = function(config){
                var modalInstance = $uibModal.open({
                    templateUrl: 'app/admin/menufeature/views/feature-flyway-modal.html',
                    controller: 'ShowFlywayFeatureController',
                    windowClass: 'cst-modal',
                    controllerAs: 'mdctrl',
                    size: 'xl',
                    resolve: {
                        featureJson : function(){
                            return config.featureJson
                        },
                        groupName : function(){
                            return config.groupName
                        },
                        menuName : function(){
                            return config.name
                        },
                        navigationState : function(){
                            return config.navigationState
                        },
                        subgroupName : function(){
                            return config.subgroupName
                        },
                        menuType : function(){
                            return menuconfig.type
                        }
                    }
                });
                modalInstance.result.then(function () {
                });
               
        }
        const isUserOrRoleAlreadyAdded = function (rights) {
            var availableRight = _.find(menuconfig.loadedConfig.rightList, function (assignedRight) {
                if (rights.userId) {
                    return assignedRight.userId == rights.userId;
                } else if (rights.designationId) {
                    return assignedRight.designationId == rights.designationId;
                }
            });
            if (availableRight) {
                return true;
            }
            return false;
        };

        init();
    }
    angular.module('imtecho.controllers').controller('MenuConfigController', MenuConfigController);
})(window.angular);
(function(){
    function ShowFlywayFeatureController($uibModal,$uibModalInstance,toaster,UUIDgenerator,featureJson,groupName,menuName,navigationState,subgroupName,menuType){
        var mdctrl=this;
        if(featureJson && featureJson!=null){
            mdctrl.featureJson = featureJson;
        }else{
            mdctrl.featureJson = null;
        }
        mdctrl.groupName = groupName;
        mdctrl.menuName = menuName;
        mdctrl.navigationState = navigationState;
        mdctrl.subgroupName = subgroupName;
        mdctrl.menuType = menuType;
        mdctrl.uuid = UUIDgenerator.generateUUID();
        mdctrl.groupUUID;
        mdctrl.subgroupUUID;
        let groupIdString;
        if(mdctrl.groupName && mdctrl.groupName!=null){
            groupIdString = "select id from menu_group mg where group_name = '" + mdctrl.groupName + "'";
            mdctrl.groupUUID = UUIDgenerator.generateUUID();
        }else{
            groupIdString = null;
            mdctrl.groupUUID = null;
        }
        let subgroupIdString;
        if(mdctrl.subgroupName && mdctrl.subgroupName!=null){
            subgroupIdString = "select sub_group_id from menu_config mc where menu_name = '" + mdctrl.subgroupName + "'";
            mdctrl.subgroupUUID = UUIDgenerator.generateUUID();
        }else{
            subgroupIdString = null;
            mdctrl.subgroupUUID = null;
        }

        mdctrl.text = 'insert into menu_config (feature_json, group_id, active, is_dynamic_report, menu_name, navigation_state, sub_group_id,'
        mdctrl.text += '\n';
        mdctrl.text += 'menu_type,"uuid", group_name_uuid, sub_group_uuid)';
        mdctrl.text += '\n';
        mdctrl.text += 'values(';
        if(mdctrl.featureJson!=null){
            mdctrl.text += '\''+ mdctrl.featureJson + '\'';
        }else{
            mdctrl.text += 'null'
        }
        mdctrl.text += '\n';
        mdctrl.text += ',';
        if(groupIdString!=null){
            mdctrl.text += '('+ groupIdString + ')';
        }else{
            mdctrl.text += 'null'
        }
        mdctrl.text += ',';
        mdctrl.text += 'true, false,';
        mdctrl.text += '\''+ mdctrl.menuName + '\'';
        mdctrl.text += ',';
        mdctrl.text += '\n';
        mdctrl.text += '\''+ mdctrl.navigationState + '\'';
        mdctrl.text += ',';
        if(subgroupIdString!=null){
            mdctrl.text += '('+ subgroupIdString + ')';
        }else{
            mdctrl.text += 'null'
        }
        mdctrl.text += ',';
        mdctrl.text += '\''+ mdctrl.menuType + '\'';
        mdctrl.text += ',';
        mdctrl.text += '\''+ mdctrl.uuid + '\'';
        mdctrl.text += ',';
        if(mdctrl.groupUUID!=null){
            mdctrl.text += '\''+ mdctrl.groupUUID + '\'';
        }else{
            mdctrl.text += 'null';
        }
        mdctrl.text += ',';
        if(mdctrl.subgroupUUID!=null){
            mdctrl.text += '\''+ mdctrl.subgroupUUID + '\'';
        }else{
            mdctrl.text += 'null';
        }
        mdctrl.text += ')';
        mdctrl.text += '\n';
        mdctrl.text += 'on conflict(navigation_state,active) do update';
        mdctrl.text += '\n';
        mdctrl.text += 'SET feature_json = excluded.feature_json,';
        mdctrl.text += '\n';
        mdctrl.text += '	group_id= excluded.group_id,';
        mdctrl.text += '\n';
        mdctrl.text += ' 	menu_name = excluded.menu_name,';
        mdctrl.text += '\n';
        mdctrl.text += '	sub_group_id= excluded.sub_group_id,';
        mdctrl.text += '\n';
        mdctrl.text += ' 	menu_type= excluded.menu_type;'
        
        mdctrl.download = function(){
            var a = window.document.createElement('a');
            a.href = window.URL.createObjectURL(new Blob([mdctrl.text], { type: 'text/plain' }));
            var name = "V" + new Date().getTime() + "__CREATED_OR_UPDATED_feature_" + mdctrl.menuName + '.sql';
            a.download = name;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            $uibModalInstance.close();
        }
        mdctrl.copyQuery = function(){
            const selBox = document.createElement('textarea');
            selBox.style.position = 'fixed';
            selBox.style.left = '0';
            selBox.style.top = '0';
            selBox.style.opacity = '100';
            selBox.value = mdctrl.text;
            document.body.appendChild(selBox);
            selBox.focus();
            selBox.select();
            document.execCommand('copy');
            document.body.removeChild(selBox);
            $uibModalInstance.close();
            toaster.pop('success', 'Query Copied');
            
        }
        mdctrl.cancel = function(){
            $uibModalInstance.close()
        }
    }
    angular.module('imtecho.controllers').controller('ShowFlywayFeatureController',ShowFlywayFeatureController);
}())
