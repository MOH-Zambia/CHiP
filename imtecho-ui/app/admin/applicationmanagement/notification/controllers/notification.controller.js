(function () {
    function NotificationController($timeout, NotificationDAO, Mask, toaster, $uibModal, RoleService, SelectizeGenerator, GeneralUtil,syncWithServerService,AuthenticateService) {
        var notificationcontroller = this;
        notificationcontroller.counter = 1;
        notificationcontroller.notificationList = [];
        notificationcontroller.toggle = null;
        notificationcontroller.isFilterOpen = false
        notificationcontroller.updateMode = false;
        notificationcontroller.notificationObject = {};
        notificationcontroller.currentUser={}

        notificationcontroller.getNotifications = function () {
            Mask.show();
            NotificationDAO.retrieveAllNotifications().then(function (res) {
                notificationcontroller.notificationList = res;
            }).finally(function () {
                Mask.hide();
            });
        };

        notificationcontroller.addLevel = function () {
            var lastEscalationLevel = notificationcontroller.notificationObject.escalationLevels[notificationcontroller.notificationObject.escalationLevels.length - 1]
            if (lastEscalationLevel.name != null && lastEscalationLevel.roles != null && lastEscalationLevel.roles.length > 0) {
                notificationcontroller.counter++;
                notificationcontroller.notificationObject.escalationLevels.push({
                    counter: notificationcontroller.counter
                })
            }
        }

        notificationcontroller.removeEscalationLevel = function (level) {
            notificationcontroller.notificationObject.escalationLevels.forEach(function (iteratedLevel, index) {
                if (iteratedLevel.counter === level.counter) {
                    notificationcontroller.notificationObject.escalationLevels.splice(index, 1);
                }
            })
        }

        notificationcontroller.generateEscalationRoleList = function () {
            notificationcontroller.escalationRoleList = notificationcontroller.roleList.filter(function (role) {
                return notificationcontroller.notificationObject.roles.includes(role.id);
            });
            var selectizeObject = SelectizeGenerator.generateUserSelectize(notificationcontroller.notificationObject.roles);
            notificationcontroller.selectizeOptions = selectizeObject.config;
        }

        notificationcontroller.toggleNotification = function (notification) {
            let changedState, isActive;
            if (notification.state === "ACTIVE") {
                changedState = 'inactive';
                isActive = false;
            } else {
                isActive = true;
                changedState = 'active';
            }
            var modalInstance = $uibModal.open({
                templateUrl: 'app/common/views/confirmation.modal.html',
                controller: 'ConfirmModalController',
                windowClass: 'cst-modal',
                size: 'med',
                resolve: {
                    message: function () {
                        return "Are you sure you want to change the state " + notification.state.toLowerCase() + ' to ' + changedState + '?';
                    }
                }
            });
            modalInstance.result.then(function () {
                Mask.show();
                NotificationDAO.toggleActive(notification.id, isActive).then(function () {
                    notificationcontroller.getNotifications();
                    toaster.pop('success', 'State is successfully changed ' + notification.state.toLowerCase() + ' to ' + changedState);
                }).finally(function () {
                    Mask.hide();
                });
            }, function () { });
        };

        notificationcontroller.changeFiledsOnTypeChange = function () {
            if (notificationcontroller.notificationObject.notificationType != 'WEB')
                notificationcontroller.notificationObject.isLocationFilterRequired = false;
        }

        notificationcontroller.saveOrUpdateNotification = function () {
            if (notificationcontroller.notificationUpdateForm.$valid) {
                if (notificationcontroller.notificationObject.actionBase === 'MODAL') {
                    notificationcontroller.notificationObject.modalBasedAction = true;
                } else if (notificationcontroller.notificationObject.actionBase === 'URL') {
                    notificationcontroller.notificationObject.urlBasedAction = true;
                } else {
                    notificationcontroller.notificationObject.modalBasedAction = false;
                    notificationcontroller.notificationObject.urlBasedAction = false;
                }

                if (notificationcontroller.notificationObject.notificationType != 'WEB') {
                    notificationcontroller.notificationObject.isLocationFilterRequired = false;
                    notificationcontroller.notificationObject.fetchUptoLevel = null;
                    notificationcontroller.notificationObject.requiredUptoLevel = null;
                    notificationcontroller.notificationObject.isFetchAccordingAOI = true;
                }
                Mask.show();
                NotificationDAO.createOrUpdate(notificationcontroller.notificationObject).then(function (res) {
                    if (notificationcontroller.updateMode) {
                        toaster.pop('success', 'Notification updated successfully');
                    } else {
                        toaster.pop('success', 'Notification added successfully');
                    }
                    Mask.hide();
                    notificationcontroller.toggleFilter();
                    notificationcontroller.getNotifications();
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                });
            }
        }

        notificationcontroller.orderByNameFlag = true;
        notificationcontroller.orderByName = function () {
            if (notificationcontroller.orderByNameFlag) {
                notificationcontroller.orderByNameFlag = false;
            } else {
                notificationcontroller.orderByNameFlag = true;
            }
        };

        notificationcontroller.orderByCodeFlag = true;
        notificationcontroller.orderByCode = function () {
            if (notificationcontroller.orderByCodeFlag) {
                notificationcontroller.orderByCodeFlag = false;
            } else {
                notificationcontroller.orderByCodeFlag = true;
            }
        };

        notificationcontroller.orderByStateFlag = true;
        notificationcontroller.orderByState = function () {
            if (notificationcontroller.orderByStateFlag) {
                notificationcontroller.orderByStateFlag = false;
            } else {
                notificationcontroller.orderByStateFlag = true;
            }
        };

        notificationcontroller.toggleFilter = function (updateMode, notificationObject) {
            if (updateMode) {
                notificationcontroller.updateMode = true;
                notificationcontroller.notificationObject = notificationObject;
                if (notificationcontroller.notificationObject.modalBasedAction) {
                    notificationcontroller.notificationObject.actionBase = 'MODAL'
                } else if (notificationcontroller.notificationObject.urlBasedAction) {
                    notificationcontroller.notificationObject.actionBase = 'URL'
                } else {
                    notificationcontroller.notificationObject.actionBase = 'ACTION'
                }
                notificationcontroller.generateEscalationRoleList();
            } else {
                notificationcontroller.updateMode = false;
                notificationcontroller.notificationObject = {};
                notificationcontroller.notificationObject.notificationType = 'MO';
                notificationcontroller.notificationObject.escalationLevels = [];
                notificationcontroller.notificationObject.escalationLevels.push({
                    counter: notificationcontroller.counter,
                    name: 'Default'
                });
            }
            notificationcontroller.isFilterOpen = !notificationcontroller.isFilterOpen
            if (angular.element('.filter-div').hasClass('active')) {
                angular.element('body').css("overflow", "auto");
            } else {
                angular.element('body').css("overflow", "hidden");
            }
            angular.element('.cst-backdrop').fadeToggle();
            angular.element('.filter-div').toggleClass('active');
        };

        $timeout(function () {
            $(".header-fixed").tableHeadFixer();
        });

        
        notificationcontroller.syncWithServer = function(notification){
            notificationcontroller.syncModel = syncWithServerService.syncWithServer(notification.uuid);
        }

        notificationcontroller.showFlywayQuery = function(notification){
            var modalInstance = $uibModal.open({
                templateUrl: 'app/admin/applicationmanagement/notification/views/manage-notification-flyway-modal.html',
                controller: 'ShowFlywayNotificationController',
                windowClass: 'cst-modal',
                controllerAs: 'mdctrl',
                size: 'xl',
                resolve: {
                    notification: function () {
                        return notification;
                    },
                    currentUserId : function() {
                        return notificationcontroller.currentUser.id;
                    },
                    roleList : function() {
                        return notificationcontroller.roleList;
                    }
                }
            });
            modalInstance.result.then(function () {
            });
        }

        notificationcontroller.init = function () {
            AuthenticateService.getLoggedInUser().then(function(res){
                notificationcontroller.currentUser=res.data

            })
            var selectizeObject = SelectizeGenerator.generateUserSelectize();
            notificationcontroller.selectizeOptions = selectizeObject.config;
            notificationcontroller.getNotifications();
            RoleService.getAllRoles().then(function (res) {
                notificationcontroller.roleList = res;
            }).finally(function () {
                Mask.hide();

            });
        };

        notificationcontroller.init();
    }
    angular.module('imtecho.controllers').controller('NotificationController', NotificationController);
})();

(function(){
    function ShowFlywayNotificationController(notification,$uibModal,$uibModalInstance,toaster,currentUserId,roleList){
        var mdctrl=this;
        mdctrl.notification = notification
        mdctrl.isPublicKeyword = false
        mdctrl.currentUserId = currentUserId
        mdctrl.roleList = roleList
        var roleIdsSet = new Set(mdctrl.notification.roles);
        mdctrl.roleMappingArray = mdctrl.roleList.filter((object) => roleIdsSet.has(object.id));
        var selfRoleList = mdctrl.roleList.filter((object) => object.id == mdctrl.notification.roleId);
        mdctrl.selfRole = selfRoleList[0]?.name?selfRoleList[0].name:null;
        mdctrl.roleMapping = {}
        mdctrl.roleMappingArray.forEach((obj)=>{
           this.roleMapping[obj.id]=obj.name;
        })
        mdctrl.text=''
        mdctrl.text+='begin;'
        mdctrl.text+='\n'
        mdctrl.text+='DO $$'
        mdctrl.text+='\n'
        mdctrl.text+='DECLARE'
        mdctrl.text+='\n'
        mdctrl.text+='var_notification_type_id integer;'
        mdctrl.text+='\n'
        mdctrl.text+= 'var_escalation_level_id integer;'
        mdctrl.text+='\n'
        mdctrl.text+= 'old_notification_type_id integer;'
        mdctrl.text+='\n'
        mdctrl.text+= 'old_escalation_level_id integer;'
        mdctrl.text+='\n'
        mdctrl.text+='BEGIN'
        mdctrl.text+='\n'

        if(mdctrl.notification.code!==null || mdctrl.notification.code!==undefined){
            mdctrl.text += 'DELETE FROM notification_type_master WHERE code = \'' + mdctrl.notification.code + '\''+ 'returning id into old_notification_type_id;'
            mdctrl.text += '\n'
            mdctrl.text += '\n'
            mdctrl.text += 'INSERT INTO notification_type_master ('
            mdctrl.text += 'created_by,created_on,modified_by,modified_on,code,"name","type",role_id,state,notification_for,action_on_role_id,data_query,action_query,order_no,color_code,data_for,url_based_action,url,modal_based_action,modal_name,is_location_filter_required,fetch_up_to_level,required_up_to_level,is_fetch_according_aoi,"uuid"'
            mdctrl.text += ')'
            mdctrl.text += '\n'
            mdctrl.text += 'VALUES ('
            mdctrl.text += mdctrl.currentUserId + ','
            mdctrl.text += 'now(),'
            mdctrl.text += mdctrl.currentUserId + ','
            mdctrl.text += 'now(),'
            mdctrl.text += mdctrl.notification.code?'\''+ mdctrl.notification.code + '\',':'null,'
            mdctrl.text += mdctrl.notification.notificationName?'\''+ mdctrl.notification.notificationName + '\',':'null,'
            mdctrl.text += mdctrl.notification.notificationType?'\''+ mdctrl.notification.notificationType + '\',':'null,'
            if(mdctrl.notification.roleId!==null){
                mdctrl.text += mdctrl.notification.roleId + ','
            }
            else{
                mdctrl.text += 'null,'
            }
            mdctrl.text += mdctrl.notification.state?'\''+ mdctrl.notification.state + '\',':'null,'
            mdctrl.text += mdctrl.notification.notificationFor?'\''+ mdctrl.notification.notificationFor + '\',':'null,'
            mdctrl.text += 'null,'
            if(mdctrl.notification.dataQuery!==null){
                mdctrl.text += '\''+ mdctrl.notification.dataQuery.replace(/[']/g, "''") + '\','
            }
            else{
            mdctrl.text += 'null,'
            }
            if(mdctrl.notification.actionQuery!==null){
                mdctrl.text += '\''+ mdctrl.notification.actionQuery.replace(/[']/g, "''") + '\','
            }else{
            mdctrl.text += 'null,'
            }
            if(mdctrl.notification.orderNo!==null){
                mdctrl.text += mdctrl.notification.orderNo+','
            }else{
            mdctrl.text += 'null,'
            }
            if(mdctrl.notification.colorCode!==null){
                mdctrl.text += '\''+ mdctrl.notification.colorCode + '\','
            }else{
                mdctrl.text += 'null,'
            }
            if(mdctrl.notification.dataFor!==null){
                mdctrl.text += '\''+ mdctrl.notification.dataFor + '\','
            }else{
                mdctrl.text += 'null,'
            }
            mdctrl.text += mdctrl.notification.urlBasedAction ? mdctrl.notification.urlBasedAction+',': mdctrl.notification.urlBasedAction===false?'false,':'null,'
            if(mdctrl.notification.url!==null){
                mdctrl.text += '\''+ mdctrl.notification.url + '\','
            }else{
                mdctrl.text += 'null,'
            }
            mdctrl.text += mdctrl.notification.modalBasedAction?mdctrl.notification.modalBasedAction+',': mdctrl.notification.modalBasedAction===false?'false,':'null,'
            if(mdctrl.notification.modalName!==null){
                mdctrl.text += '\''+ mdctrl.notification.modalName + '\','
            }else{
                mdctrl.text += 'null,'
            }
            mdctrl.text += mdctrl.notification.isLocationFilterRequired?mdctrl.notification.isLocationFilterRequired+',':'null,'
            if(mdctrl.notification.fetchUptoLevel!==null){
                mdctrl.text += mdctrl.notification.fetchUptoLevel+','
            }else{
                mdctrl.text += 'null,'
            }
            if(mdctrl.notification.requiredUptoLevel!==null){
                mdctrl.text += mdctrl.notification.requiredUptoLevel+','
            }else{
                mdctrl.text += 'null,'
            }
            mdctrl.text += mdctrl.notification.isFetchAccordingAOI?mdctrl.notification.isFetchAccordingAOI+',':'null,'
            if(mdctrl.notification.uuid!==null){
                mdctrl.text += '\''+ mdctrl.notification.uuid + '\''
            }else{
                mdctrl.text += 'null'
            }
            mdctrl.text += ')'
            mdctrl.text += 'returning id into var_notification_type_id;'
            mdctrl.text += '\n'
            mdctrl.text += '\n'
            mdctrl.text += 'DELETE FROM notification_type_role_rel WHERE notification_type_id = old_notification_type_id;'
            mdctrl.text += '\n'
            mdctrl.text += '\n'
            mdctrl.text += 'INSERT INTO notification_type_role_rel (notification_type_id, role_id)'
            mdctrl.text += '\n'
            mdctrl.text += 'SELECT var_notification_type_id, id'
            mdctrl.text += '\n'
            mdctrl.text += 'FROM um_role_master'
            mdctrl.text += '\n'
            mdctrl.text += 'WHERE name IN ('
            let notificationRoleLength = mdctrl.notification.roles.length
            let notificationCount = 0;
            if(mdctrl.notification.roles.length>0){
                mdctrl.notification.roles.forEach(val=>{
                    notificationCount += 1;
                    if(mdctrl.roleMapping[val]!= undefined){
                        mdctrl.text += '\''+mdctrl.roleMapping[val]+'\' ';
                    }
                    if(notificationCount === notificationRoleLength){
                        mdctrl.text += ');'
                    }else{
                        mdctrl.text += ','
                    }
                    mdctrl.text += '\n'
                })
            }
            else {
                notificationCount += 1;
                    mdctrl.text +=  '\''+mdctrl.selfRole+'\' '
                    mdctrl.text += ');'
                    mdctrl.text += '\n'
            }
            if(mdctrl.notification.escalationLevels.length>0){
                mdctrl.notification.escalationLevels.forEach(obj=>{
                    let isPerformActionValid = false;
                    mdctrl.text += '\n'
                    mdctrl.text += 'DELETE FROM escalation_level_master WHERE uuid = '+ '\''+obj.uuid+'\' returning id into old_escalation_level_id;'
                    mdctrl.text += '\n'
                    mdctrl.text += '\n'
                    mdctrl.text += 'INSERT INTO escalation_level_master ("name", notification_type_id, created_by, created_on, modified_by, modified_on,uuid)'
                    mdctrl.text += 'VALUES ('
                    mdctrl.text += '\''+obj.name+'\','
                    mdctrl.text += 'var_notification_type_id,'
                    mdctrl.text += mdctrl.currentUserId + ','
                    mdctrl.text += 'now(),'
                    mdctrl.text += mdctrl.currentUserId + ','
                    mdctrl.text += 'now(),'
                    mdctrl.text += '\''+obj.uuid+'\''
                    mdctrl.text += ')'
                    mdctrl.text += 'returning id into var_escalation_level_id;'
                    mdctrl.text += '\n'
                    mdctrl.text += '\n'
                    mdctrl.text += 'DELETE FROM escalation_level_role_rel WHERE escalation_level_id = ' + 'old_escalation_level_id ;'
                    mdctrl.text += '\n'
                    mdctrl.text += '\n'
                    if(obj.performAction != null && Object.keys(obj.performAction).length > 0){
                        for(const key in obj.performAction){
                            if(mdctrl.roleMapping[key]!= undefined){
                                isPerformActionValid = true;
                                break;
                            }
                        }
                    }
                    if(isPerformActionValid)
                    {
                        mdctrl.text += 'INSERT INTO escalation_level_role_rel (escalation_level_id, role_id, can_perform_action)'
                        mdctrl.text += '\n'
                        mdctrl.text += 'SELECT var_escalation_level_id, id, '
                        let escalationLength = Object.keys(obj.performAction).length;
                        mdctrl.text += '\n'
                        mdctrl.text += 'CASE'
                        mdctrl.text += '\n'
                        let escalationCount = 0;
                            for(const key in obj.performAction)
                              {  
                                escalationCount++;
                                if(mdctrl.roleMapping[key]!=undefined){
                                    mdctrl.text += 'WHEN um_role_master.name = '+ '\''+mdctrl.roleMapping[key]+'\' ' + 'THEN '+obj.performAction[key]
                                }
                                if(escalationCount===escalationLength){
                                    mdctrl.text += '\n';
                                    mdctrl.text += 'ELSE false';
                                    mdctrl.text += '\n';
                                    mdctrl.text += 'END';
                                    mdctrl.text += '\n'
                                }else{
                                    mdctrl.text += '\n'
                                }
                            }
                                escalationCount = 0
                                mdctrl.text += 'FROM um_role_master'
                                mdctrl.text += '\n';
                                mdctrl.text += 'WHERE name IN ('
                            for(const key in obj.performAction)
                              {  
                                escalationCount++;
                                if(mdctrl.roleMapping[key]!==undefined){
                                    mdctrl.text +=  '\''+mdctrl.roleMapping[key]+'\' ';
                                }
                                if(escalationCount===escalationLength){
                                    mdctrl.text += ');'
                                }else{
                                    mdctrl.text += ','
                                }
                                mdctrl.text += '\n'}
                    }
               
                })
            }       
            mdctrl.text += 'END $$;'
            mdctrl.text += '\n'
            mdctrl.text += 'commit;'
            
        }

        mdctrl.askForConfirmation = function(){
            var modalInstance = $uibModal.open({
                templateUrl: 'app/common/views/confirmation.modal.html',
                controller: 'ConfirmModalController',
                windowClass: 'cst-modal',
                size: 'med',
                resolve: {
                    message: function () {
                        return "This Flyway contains keyword 'public'. Are You sure want to download?";
                    }
                }
            });
            modalInstance.result.then(function () {
                mdctrl.download();
            },function(){});
        }

        mdctrl.downloadCheckForPublicKeyword = function(){
            if(mdctrl.isPublicKeyword== true){
                mdctrl.askForConfirmation();
            }
            else{
                mdctrl.download();
            }
        }
        mdctrl.download = function(){
            var a = window.document.createElement('a');
            a.href = window.URL.createObjectURL(new Blob([mdctrl.text], { type: 'text/plain' }));
            var name = "V" + new Date().getTime() + "__CREATED_OR_UPDATED_" + mdctrl.notification.code + '.sql';
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
    angular.module('imtecho.controllers').controller('ShowFlywayNotificationController',ShowFlywayNotificationController);
}())