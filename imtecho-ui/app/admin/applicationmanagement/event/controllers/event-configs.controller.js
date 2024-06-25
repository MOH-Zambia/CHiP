(function () {
    function EventConfigurationsController($state, $filter, Mask, GeneralUtil, toaster, $uibModal, EventConfigDAO ,syncWithServerService) {
        var eventConfigs = this;
        var init = function () {
            eventConfigs.retrieveAll(true);
        };


        eventConfigs.refresh = function () {
            var isActive = eventConfigs.showInactive ? false : true;
            eventConfigs.retrieveAll(isActive);
        };

        eventConfigs.retrieveAll = function (isActive) {
            Mask.show();
            EventConfigDAO.retrieveAll(isActive).then(function (res) {
                eventConfigs.configuredEvents = res;
                eventConfigs.configuredEvents = $filter('orderBy')(eventConfigs.configuredEvents, ['-trigerWhen', 'day', 'hour', 'minute']);
            }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                Mask.hide();
            });
        };
        // Event listener for the showInactive checkbox
        eventConfigs.showInactiveCheckboxChanged = function () {
            var isActive = eventConfigs.showInactive ? false : true;
            eventConfigs.retrieveAll(isActive);
           
        };
        eventConfigs.runConfig = function (dto) {
            var modalInstance = $uibModal.open({
                templateUrl: 'app/common/views/confirmation.modal.html',
                controller: 'ConfirmModalController',
                windowClass: 'cst-modal',
                size: 'med',
                resolve: {
                    message: function () {
                        return "Are you sure you want to run <b>" + dto.name + "</b> event config now?";
                    }
                }
            });
            modalInstance.result.then(function () {
                Mask.show();
                EventConfigDAO.runEvent(dto.uuid).then(function (res) {
                    toaster.pop("success", "Event configured for run now");
                    eventConfigs.retrieveAll(false);
                }).catch(function () {
                }).then(function () {
                    Mask.hide();
                });
            }, function () {
            });
        };

        eventConfigs.syncWithServer = function(eventConfig) {
            eventConfigs.syncModel = syncWithServerService.syncWithServer(eventConfig.uuid);
        }

        eventConfigs.navigateToEditEvent = function(eventConfig) {
            let url = $state.href('techo.notification.config', {id:eventConfig.uuid});
            sessionStorage.setItem('linkClick', 'true')
            window.open(url, '_blank');
        }

        eventConfigs.delete = function (dto) {
            var modalInstance = $uibModal.open({
                templateUrl: 'app/common/views/confirmation.modal.html',
                controller: 'ConfirmModalController',
                windowClass: 'cst-modal',
                size: 'med',
                resolve: {
                    message: function () {
                        return "Are you sure you want to delete this event config?";
                    }
                }
            });
            modalInstance.result.then(function () {
                Mask.show();
                EventConfigDAO.toggleState(dto).then(function (res) {
                    toaster.pop("success", "Event configured status changed");
                    eventConfigs.retrieveAll();
                }).catch(function () {
                }).then(function () {
                    Mask.hide();
                });
            }, function () {
            });
        };

        eventConfigs.openExceptionsModal=function(dto){
            $uibModal.open({
                templateUrl: 'app/admin/applicationmanagement/event/views/event-exception.modal.html',
                controller: 'EventExceptionModalController',
                windowClass: 'cst-modal',
                size: 'xl',
                resolve: {
                    eventConfigId: function () {
                        return dto.id;
                    }
                }
            });
        }

        eventConfigs.generateFlyway = function (eventObj) {
            var modalInstance = $uibModal.open({
                templateUrl: 'app/admin/applicationmanagement/event/views/show-flyway-query.modal.html',
                controller: 'ShowEventFlywayQueryController',
                windowClass: 'cst-modal',
                controllerAs: 'mdctrl',
                size: 'xl',
                resolve: {
                    eventObj: function () {
                        return eventObj;
                    }
                }
            });
            modalInstance.result.then(function () {
            });
        }

        init();
    }
    angular.module('imtecho.controllers').controller('EventConfigurationsController', EventConfigurationsController);
})();

(function () {
    function ShowFlywayQueryController(eventObj, $uibModalInstance,$uibModal, toaster) {
        var mdctrl = this;
        mdctrl.eventObj = eventObj;
        mdctrl.isPublicKeyword = false;
        console.log(JSON.stringify(eventObj.configJson));

        mdctrl.init = function () {
            mdctrl.text = '';
            mdctrl.isPublicKeyword = mdctrl.eventObj.configJson.includes('public');
            mdctrl.text += 'DELETE FROM EVENT_CONFIGURATION WHERE uuid = \'' + mdctrl.eventObj.uuid + '\';';
            mdctrl.text += '\n';
            mdctrl.text += '\n';
            mdctrl.text += 'INSERT INTO EVENT_CONFIGURATION(created_by, created_on, modified_by, modified_on, day, description, event_type, event_type_detail_id, form_type_id, hour, minute, name, config_json, state, trigger_when, event_type_detail_code, uuid)'
            mdctrl.text += '\n';
            mdctrl.text += 'VALUES ( ';
            mdctrl.text += '\n';
            mdctrl.text += mdctrl.eventObj.createdBy + ', ';
            mdctrl.text += ' current_date ' + ', ';
            mdctrl.text += mdctrl.eventObj.createdBy + ', ';
            mdctrl.text += ' current_date ' + ', ';
            if (mdctrl.eventObj.day === undefined || mdctrl.eventObj.day === null) {
                mdctrl.text += 'null, ';
            } else {
                mdctrl.text += mdctrl.eventObj.day + ', ';
            }
            if (mdctrl.eventObj.description === undefined || mdctrl.eventObj.description === null) {
                mdctrl.text += 'null, ';
            } else {
                mdctrl.text += '\'' + mdctrl.eventObj.description.replace(/[']/g, "''") + '\', ';
            }
            mdctrl.text += '\'' + mdctrl.eventObj.eventType + '\', ';
            if (mdctrl.eventObj.eventTypeDetailId === undefined || mdctrl.eventObj.eventTypeDetailId === null) {
                mdctrl.text += 'null, ';
            } else {
                mdctrl.text += mdctrl.eventObj.eventTypeDetailId + ', ';
            }
            if (mdctrl.eventObj.formTypeId === undefined || mdctrl.eventObj.formTypeId === null) {
                mdctrl.text += 'null, ';
            } else {
                mdctrl.text += mdctrl.eventObj.formTypeId + ', ';
            }
            if (mdctrl.eventObj.hour === undefined || mdctrl.eventObj.hour === null) {
                mdctrl.text += 'null, ';
            } else {
                mdctrl.text += mdctrl.eventObj.hour + ', ';
            }
            if (mdctrl.eventObj.minute === undefined || mdctrl.eventObj.minute === null) {
                mdctrl.text += 'null, ';
            } else {
                mdctrl.text += mdctrl.eventObj.minute + ', ';
            }
            mdctrl.text += '\'' + mdctrl.eventObj.name.replace(/[']/g, "''") + '\', ';
            mdctrl.text += '\'' + mdctrl.eventObj.configJson.replace(/[']/g, "''") + '\'' + ', ';
            mdctrl.text += '\'' + mdctrl.eventObj.state + '\', ';
            if (mdctrl.eventObj.trigerWhen === undefined || mdctrl.eventObj.trigerWhen === null) {
                mdctrl.text += 'null, ';
            } else {
                mdctrl.text += '\'' + mdctrl.eventObj.trigerWhen + '\', ';
            }
            if (mdctrl.eventObj.eventTypeDetailCode === undefined || mdctrl.eventObj.eventTypeDetailCode === null) {
                mdctrl.text += 'null, ';
            } else {
                mdctrl.text += mdctrl.eventObj.eventTypeDetailCode + ', ';
            }
            mdctrl.text += '\'' + mdctrl.eventObj.uuid + '\');';
            if (mdctrl.eventObj.eventType === 'TIMMER_BASED' && mdctrl.eventObj.state !== 'INACTIVE') {
                let nextDate = moment();
                switch (mdctrl.eventObj.trigerWhen) {
                    case 'MONTHLY':
                        nextDate.add(1, "months");
                        nextDate.set("date", mdctrl.eventObj.day);
                        if (mdctrl.eventObj.hour != null) {
                            nextDate.set("hour", mdctrl.eventObj.hour);
                        } else {
                            nextDate.set("hour", 0);
                        }
                        if (mdctrl.eventObj.minute != null) {
                            nextDate.set("minute", mdctrl.eventObj.hour);
                        } else {
                            nextDate.set("minute", 0);
                        }
                        nextDate.set("second", 0);
                        break;
                    case 'DAILY':
                        nextDate.add(mdctrl.getNextDate(mdctrl.eventObj), "days");
                        if (mdctrl.eventObj.hour != null) {
                            nextDate.set("hour", mdctrl.eventObj.hour);
                        } else {
                            nextDate.set("hour", 0);
                        }
                        if (mdctrl.eventObj.minute != null) {
                            nextDate.set("minute", mdctrl.eventObj.minute);
                        } else {
                            nextDate.set("minute", 0);
                        }
                        nextDate.set("second", 0);
                        break;
                    case 'HOURLY':
                        nextDate.add(1, "hours");
                        nextDate.set("minute", mdctrl.getNextDate(eventObj));
                        nextDate.set("second", 0);
                        break;
                    case 'MINUTE':
                        nextDate.add(mdctrl.eventObj.minute, "minutes");
                        nextDate.set("second", 0);
                        break;
                    default:
                }
                mdctrl.text += '\n';
                mdctrl.text += '\n';
                mdctrl.text += 'DELETE FROM TIMER_EVENT WHERE event_config_uuid =\'' + mdctrl.eventObj.uuid + '\' and status = \'NEW\';';
                mdctrl.text += '\n';
                mdctrl.text += '\n';
                mdctrl.text += 'INSERT INTO timer_event(event_config_uuid, processed, status, type, system_trigger_on)';
                mdctrl.text += '\n';
                mdctrl.text += 'VALUES ( ';
                mdctrl.text += '\n';
                mdctrl.text += '\'' + mdctrl.eventObj.uuid + '\', ';
                mdctrl.text += 'false, \'NEW\', \'TIMER_EVENT\', ';
                mdctrl.text += '\'' + nextDate.format('MM-DD-yyyy HH:mm:ss') + '\');';
            }
            if (mdctrl.eventObj.configJson !== null) {
                let notificationConfigs = JSON.parse(mdctrl.eventObj.configJson);
                let firstDelete = true;
                notificationConfigs.forEach(function (config) {
                    if (config.conditions !== null && config.conditions.length > 0) {
                        config.conditions.forEach(function (condition) {
                            if (condition.notificaitonConfigsType !== null && condition.notificaitonConfigsType.length > 0) {
                                if (firstDelete) {
                                    mdctrl.text += '\n';
                                    mdctrl.text += '\n';
                                    mdctrl.text += 'DELETE FROM EVENT_CONFIGURATION_TYPE WHERE event_config_uuid =\'' + mdctrl.eventObj.uuid + '\';';
                                    firstDelete = false;
                                }
                                condition.notificaitonConfigsType.forEach(function (configType) {
                                    mdctrl.text += '\n';
                                    mdctrl.text += '\n';
                                    mdctrl.text += 'INSERT INTO EVENT_CONFIGURATION_TYPE(id, base_date_field_name, event_config_uuid, day, email_subject, email_subject_parameter, hour, minute, mobile_notification_type, template, template_parameter, triger_when, type, user_field_name, family_field_name, member_field_name, query_master_id, query_master_param_json, query_code, sms_config_json, push_notification_config_json)'
                                    mdctrl.text += '\n';
                                    mdctrl.text += 'VALUES ( ';
                                    mdctrl.text += '\n';
                                    mdctrl.text += '\'' + configType.id + '\', ';
                                    if (configType.baseDateFieldName === undefined || configType.baseDateFieldName === null) {
                                        mdctrl.text += 'null, ';
                                    } else {
                                        mdctrl.text += '\'' + configType.baseDateFieldName + '\', ';
                                    }
                                    mdctrl.text += '\'' + mdctrl.eventObj.uuid + '\', ';
                                    if (configType.day === undefined || configType.day === null) {
                                        mdctrl.text += 'null, ';
                                    } else {
                                        mdctrl.text += configType.day + ', ';
                                    }
                                    if (configType.emailSubject === undefined || configType.emailSubject === null) {
                                        mdctrl.text += 'null, ';
                                    } else {
                                        mdctrl.text += '\'' + configType.emailSubject.replace(/[']/g, "''") + '\', ';
                                    }
                                    if (configType.emailSubjectParameter === undefined || configType.emailSubjectParameter === null) {
                                        mdctrl.text += 'null, ';
                                    } else {
                                        mdctrl.text += '\'' + configType.emailSubjectParameter + '\', ';
                                    }
                                    if (configType.hour === undefined || configType.hour === null) {
                                        mdctrl.text += 'null, ';
                                    } else {
                                        mdctrl.text += configType.hour + ', ';
                                    }
                                    if (configType.miniute === undefined || configType.miniute === null) {
                                        mdctrl.text += 'null, ';
                                    } else {
                                        mdctrl.text += configType.miniute + ', ';
                                    }
                                    if (configType.mobileNotificationType === undefined || configType.mobileNotificationType === null) {
                                        mdctrl.text += 'null, ';
                                    } else {
                                        mdctrl.text += configType.mobileNotificationType + ', ';
                                    }
                                    if (configType.template === undefined || configType.template === null) {
                                        mdctrl.text += 'null, ';
                                    } else {
                                        mdctrl.text += '\'' + configType.template.replace(/[']/g, "''") + '\', ';
                                    }
                                    if (configType.templateParameter === undefined || configType.templateParameter === null) {
                                        mdctrl.text += 'null, ';
                                    } else {
                                        mdctrl.text += '\'' + configType.templateParameter.replace(/[']/g, "''") + '\', ';
                                    }
                                    if (configType.trigerWhen === undefined || configType.trigerWhen === null) {
                                        mdctrl.text += 'null, ';
                                    } else {
                                        mdctrl.text += '\'' + configType.trigerWhen + '\', ';
                                    }
                                    if (configType.type === undefined || configType.type === null) {
                                        mdctrl.text += 'null, ';
                                    } else {
                                        mdctrl.text += '\'' + configType.type + '\', ';
                                    }
                                    if (configType.userFieldName === undefined || configType.userFieldName === null) {
                                        mdctrl.text += 'null, ';
                                    } else {
                                        mdctrl.text += '\'' + configType.userFieldName + '\', ';
                                    }
                                    if (configType.familyFieldName === undefined || configType.familyFieldName === null) {
                                        mdctrl.text += 'null, ';
                                    } else {
                                        mdctrl.text += '\'' + configType.familyFieldName + '\', ';
                                    }
                                    if (configType.memberFieldName === undefined || configType.memberFieldName === null) {
                                        mdctrl.text += 'null, ';
                                    } else {
                                        mdctrl.text += '\'' + configType.memberFieldName + '\', ';
                                    }
                                    if (configType.queryMasterId === undefined || configType.queryMasterId === null) {
                                        mdctrl.text += 'null, ';
                                    } else {
                                        mdctrl.text += configType.queryMasterId + ', ';
                                    }
                                    if (configType.queryMasterParamJson === undefined || configType.queryMasterParamJson === null) {
                                        mdctrl.text += 'null, ';
                                    } else {
                                        mdctrl.text += '\'' + JSON.stringify(configType.queryMasterParamJson).replace(/[']/g, "''") + '\', ';
                                    }
                                    if (configType.queryCode === undefined || configType.queryCode === null) {
                                        mdctrl.text += 'null, ';
                                    } else {
                                        mdctrl.text += '\'' + configType.queryCode + '\', ';
                                    }
                                    if (configType.smsConfigJson === undefined || configType.smsConfigJson === null) {
                                        mdctrl.text += 'null, ';
                                    } else {
                                        mdctrl.text += '\'' + JSON.stringify(configType.smsConfigJson).replace(/[']/g, "''") + '\', ';
                                    }
                                    if (configType.pushNotificationConfigJson === undefined || configType.pushNotificationConfigJson === null) {
                                        mdctrl.text += 'null);';
                                    } else {
                                        mdctrl.text += '\'' + JSON.stringify(configType.pushNotificationConfigJson).replace(/[']/g, "''") + '\');';
                                    }
                                    if (configType.mobileNotificationConfigs !== null && configType.mobileNotificationConfigs.length > 0) {
                                        mdctrl.text += '\n';
                                        mdctrl.text += '\n';
                                        mdctrl.text += 'DELETE FROM EVENT_MOBILE_CONFIGURATION WHERE notification_type_config_id =\'' + configType.id + '\';';
                                        configType.mobileNotificationConfigs.forEach(function (mobileConfig) {
                                            mdctrl.text += '\n';
                                            mdctrl.text += '\n';
                                            mdctrl.text += 'INSERT INTO EVENT_MOBILE_CONFIGURATION(id, notification_code, notification_type_config_id, number_of_days_added_for_due_date, number_of_days_added_for_expiry_date, number_of_days_added_for_on_date)'
                                            mdctrl.text += '\n';
                                            mdctrl.text += 'VALUES ( ';
                                            mdctrl.text += '\n';
                                            mdctrl.text += '\'' + mobileConfig.id + '\', ';
                                            mdctrl.text += '\'' + mobileConfig.notificationCode + '\', ';
                                            mdctrl.text += '\'' + mobileConfig.notificationTypeConfigId + '\', ';
                                            mdctrl.text += mobileConfig.numberOfDaysAddedForDueDate + ', ';
                                            mdctrl.text += mobileConfig.numberOfDaysAddedForExpiryDate + ', ';
                                            mdctrl.text += mobileConfig.numberOfDaysAddedForOnDate + ');';
                                        });
                                    }
                                });
                            }
                        })
                    }
                })
            }
            let eventConfigObj = {
                id: mdctrl.eventObj.id,
                name: mdctrl.eventObj.name,
                description: mdctrl.eventObj.description,
                eventType: mdctrl.eventObj.eventType,
                eventTypeDetailId: mdctrl.eventObj.eventTypeDetailId,
                formTypeId: mdctrl.eventObj.formTypeId,
                eventTypeDetailCode: mdctrl.eventObj.eventTypeDetailCode,
                trigerWhen: mdctrl.eventObj.trigerWhen,
                day: mdctrl.eventObj.day,
                hour: mdctrl.eventObj.hour,
                minute: mdctrl.eventObj.minute,
                state: mdctrl.eventObj.state,
                createdBy: mdctrl.eventObj.createdBy,
                createdOn: moment().valueOf(),
                notificationConfigDetails: JSON.parse(mdctrl.eventObj.configJson),
                status: null,
                completionTime: null,
                configJson: null,
                uuid: mdctrl.eventObj.uuid
            }
            mdctrl.text += '\n';
            mdctrl.text += '\n';
            mdctrl.text += 'INSERT INTO SYNC_SYSTEM_CONFIGURATION_MASTER(feature_type, config_json, created_on, created_by, feature_uuid, feature_name)';
            mdctrl.text += '\n';
            mdctrl.text += 'VALUES ( ';
            mdctrl.text += '\n';
            mdctrl.text += '\'EVENT_BUILDER\', ';
            mdctrl.text += '\'' + JSON.stringify(eventConfigObj).replace(/[']/g, "''") + '\'' + ', ';
            mdctrl.text += ' current_date ' + ', ';
            mdctrl.text += mdctrl.eventObj.createdBy + ', ';
            mdctrl.text += '\'' + mdctrl.eventObj.uuid + '\', ';
            mdctrl.text += '\'' + mdctrl.eventObj.name + '\');';
        }

        mdctrl.getNextDate = function(eventObj) {
            if (eventObj.hour > moment().hours()
                    || (moment().hours() === eventObj.hour && eventObj.minute > moment().minutes())) {
                return 0;
            } else {
                return 1;
            }
        }

        mdctrl.copyQuery = function () {
            const selBox = document.createElement('textarea');
            selBox.style.position = 'fixed';
            selBox.style.left = '0';
            selBox.style.top = '0';
            selBox.style.opacity = '0';
            selBox.value = mdctrl.text;
            document.body.appendChild(selBox);
            selBox.focus();
            selBox.select();
            document.execCommand('copy');
            document.body.removeChild(selBox);
            $uibModalInstance.close();
            toaster.pop('success', 'Query Copied');
        };

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

        mdctrl.download = function () {
            var a = window.document.createElement('a');
            a.href = window.URL.createObjectURL(new Blob([mdctrl.text], { type: 'text/plain' }));
            var name = "V" + new Date().getTime() + "__CHANGE_IN_" + mdctrl.eventObj.code + '.sql';
            a.download = name;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            $uibModalInstance.close();
        };

        mdctrl.cancel = function () {
            $uibModalInstance.close();
        };

        mdctrl.init();
    }
    angular.module('imtecho.controllers').controller('ShowEventFlywayQueryController', ShowFlywayQueryController);
})();