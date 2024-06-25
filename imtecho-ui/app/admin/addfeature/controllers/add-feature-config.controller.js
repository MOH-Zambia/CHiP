(function (angular) {
    function AddFeatureController(QueryDAO, $filter, $uibModal,$state, Mask, GeneralUtil, toaster,AuthenticateService,UUIDgenerator,MenuConfigDAO) {
       var ctrl=this;
       ctrl.featureTypes = [];
       ctrl.featureGroups = [];
       ctrl.featureSubgroups = [];
       ctrl.newFeatureInitials={}
       ctrl.addRequirement = false
       ctrl.featureRequirement=[{key:'',isEditable:true,value:false}]
       ctrl.editMode = false
       ctrl.featureJsonExists = false
       ctrl.menuItem = {}


       ctrl.init = function(){
        AuthenticateService.getMenuItems().then(function(res){
        ctrl.menuItems = res;
            for(let key in res){
                if(!key.toLowerCase().includes('report'))
                ctrl.featureTypes.push(key)
            }
        }).catch(function(err){
            GeneralUtil.showMessageOnApiCallFailure(err);
        }).finally(function(){
            if($state.params.featureId!=null && $state.params.featureType!=null){
                let featureId = $state.params.featureId;
                let featureType = $state.params.featureType;
                ctrl.newFeatureInitials.featureType = featureType;
                ctrl.featureTypeChanged();
                ctrl.editMode = true;
                MenuConfigDAO.getMenuConfigByType({ action: featureType }).then(function(res){
                    let menuList = res
                    menuList.forEach(function(val){
                        if(val.id == featureId){
                            ctrl.menuItem = val;
                        }
                    })
                }).catch(function(err){
                    GeneralUtil.showMessageOnApiCallFailure(err);
                }).finally(function(){
                    if(ctrl.menuItem!=null){
                        let tempRequirements;
                        ctrl.oldFeatureState = ctrl.menuItem.navigationState;
                        ctrl.newFeatureInitials['featureName'] = ctrl.menuItem.name;
                        ctrl.newFeatureInitials['featureState'] = ctrl.menuItem.navigationState;
                        if(ctrl.menuItem.featureJson && ctrl.menuItem.featureJson!='{}'){
                            ctrl.addRequirement = true;
                            ctrl.featureJsonExists = true
                            ctrl.featureRequirement = [];
                            tempRequirements=ctrl.menuItem.featureJson.split(',');
                            ctrl.existingFeatureRequirementLength = tempRequirements.length;
                            tempRequirements.forEach(function(val){
                                let tempRequirement = val.split('"');
                                if(tempRequirement[2].includes('true')){
                                    ctrl.featureRequirement.push({key:tempRequirement[1], value:true,isEditable:false});
                                }else if(tempRequirement[2].includes('false')){
                                    ctrl.featureRequirement.push({key:tempRequirement[1], value:false,isEditable:false});
                                }
                            })
                            ctrl.featureRequirement.push({key:'',isEditable:true,value:false});
                        }
                        if(ctrl.menuItem.groupName && ctrl.menuItem.groupName!= null){
                            ctrl.newFeatureInitials.featureGroup = ctrl.menuItem.groupName;
                            ctrl.featureGroupChanged();
                        }
                    }
                })
            }
        })
       
       }
       
       ctrl.addFeatureClicked = function(index){
           ctrl.featureRequirement.push({key:'',isEditable:true,value:false});
       }
       ctrl.removeFeatureClicked = function(index){
        ctrl.featureRequirement.splice(index,1);
        if(ctrl.featureRequirement.length==0){
            ctrl.addRequirement = false;
            ctrl.featureRequirement=[{key:'',isEditable:true,value:false}]
        }
       }
       ctrl.featureTypeChanged = function(){
            ctrl.featureGroups = [];
            ctrl.featureSubgroups = [];
            ctrl.menuItems[ctrl.newFeatureInitials.featureType].forEach(function(val){
                if(!!val.isGroup && val.isGroup == true){
                    ctrl.featureGroups.push({groupName:val.name,groupId:val.id});
                }
            })
       }
       ctrl.featureGroupChanged = function(){
        ctrl.featureSubgroups = [];
            ctrl.menuItems[ctrl.newFeatureInitials.featureType].forEach(function(val){
                if(!!val.isGroup && val.isGroup == true){
                    if(val.name==ctrl.newFeatureInitials.featureGroup){
                        val.subGroups.forEach((rep)=>{
                            if(rep.isSubgroup && rep.isSubgroup == true){
                                ctrl.featureSubgroups.push({subgroupName:rep.name,subgroupId:rep.id})
                            }
                        })
                    }
                }
            })
       }
       ctrl.toggleRequirement = function(){
        if(!ctrl.addRequirement){
            ctrl.featureRequirement=[{key:'',isEditable:true,value:false}]
        }
       }

       ctrl.saveClicked = function(){
        if(ctrl.featureForm.$valid){
            let UUID = UUIDgenerator.generateUUID();
        let groupUUID = UUIDgenerator.generateUUID();
        let subgroupUUID = UUIDgenerator.generateUUID();
        let groupIdString = "select id from menu_group mg where group_name = '" + ctrl.newFeatureInitials.featureGroup + "'";
        let subgroupIdString = "select sub_group_id from menu_config mc where menu_name = '" + ctrl.newFeatureInitials.featureSubgroup + "'";
        let tempFeatureRequirement = ctrl.featureRequirement.filter((rep)=>rep.key!='')
        let featureJSONString = '';
        if(tempFeatureRequirement.length > 0){
            featureJSONString += '{'
            tempFeatureRequirement.forEach(function(rep,index){
                if(rep.key!=''){
                    featureJSONString += '"';
                    featureJSONString += rep.key ;
                    featureJSONString += '"';
                    featureJSONString += ':';
                    featureJSONString += 'false' ;
                }
                if(index+1!=tempFeatureRequirement.length){
                    featureJSONString += ',';
                }
            })
            featureJSONString += '}';
        }
        var queryDto = {
            code: 'insert_menu_config',
            parameters: {
                featureJson: tempFeatureRequirement.length > 0 ?featureJSONString : null,
                groupId: ctrl.newFeatureInitials.featureGroup ? groupIdString : null,
                menuName: ctrl.newFeatureInitials.featureName,
                navigationState: ctrl.newFeatureInitials.featureState,
                subgroupId:ctrl.newFeatureInitials.featureSubgroup ? subgroupIdString : null,
                menuType: ctrl.newFeatureInitials.featureType,
                UUID: UUID,
                groupUUID:ctrl.newFeatureInitials.featureGroup? groupUUID:null,
                subgroupUUID: ctrl.newFeatureInitials.featureSubgroup? subgroupUUID :null
            }
        }
        QueryDAO.executeQuery(queryDto).then(function (res) {
          if(res.result.length > 0) {
            toaster.pop('success', 'Feature Added Successfully');
            $state.go('techo.manage.menu')
            // ctrl.featureForm.$setPristine();
            // ctrl.featureForm.$setUntouched();
            // ctrl.featureGroups = [];
            // ctrl.featureSubgroups = [];
            // ctrl.newFeatureInitials={}
            // ctrl.addRequirement = false
            // ctrl.featureRequirement=[{key:''}]

          }else{
            toaster.pop('error', 'Feature cannot be added as same feature configuration exists');
          }
        }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
            Mask.hide();
        });
        }
       }
       ctrl.cancelClicked = function(){
        $state.go('techo.manage.menu')
       }
       ctrl.editClicked = function(){
       if(ctrl.featureForm.$valid){
        let groupIdString = "select id from menu_group mg where group_name = '" + ctrl.newFeatureInitials.featureGroup + "'";
        let subgroupIdString = "select sub_group_id from menu_config mc where menu_name = '" + ctrl.newFeatureInitials.featureSubgroup + "'";
        let tempFeatureRequirement = ctrl.featureRequirement.filter((rep)=>rep.key!='')
        let featureJSONString = '';
        if(tempFeatureRequirement.length > 0){
            featureJSONString += '{'
            tempFeatureRequirement.forEach(function(rep,index){
                if(rep.key!=''){
                    featureJSONString += '"';
                    featureJSONString += rep.key ;
                    featureJSONString += '"';
                    featureJSONString += ':';
                    if(!ctrl.featureJsonExists){
                        featureJSONString += 'false' ;
                    }else if(ctrl.featureJsonExists){
                        featureJSONString += rep.value ;
                    }
                }
                if(index+1!=tempFeatureRequirement.length){
                    featureJSONString += ',';
                }
            })
            featureJSONString += '}';
        }
        var queryDto = {
            code: 'update_menu_config',
            parameters: {
                featureJson: tempFeatureRequirement.length > 0 ?featureJSONString : null,
                groupId: ctrl.newFeatureInitials.featureGroup ? groupIdString : null,
                menuName: ctrl.newFeatureInitials.featureName,
                navigationState: ctrl.newFeatureInitials.featureState,
                subgroupId:ctrl.newFeatureInitials.featureSubgroup ? subgroupIdString : null,
                menuType: ctrl.newFeatureInitials.featureType,
                featureId: $state.params.featureId,
                featureType: $state.params.featureType
            }
        }
        QueryDAO.executeQuery(queryDto).then(function (res) {
            if(res.result.length > 0) {
              toaster.pop('success', 'Feature Edited Successfully');
              $state.go('techo.manage.menu')
            }else{
              toaster.pop('error', 'Feature cannot be added as same feature configuration exists');
            }
          }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
              Mask.hide();
          });
       }
    }
       ctrl.init();
    }
    angular.module('imtecho.controllers').controller('AddFeatureController', AddFeatureController);
})(window.angular);