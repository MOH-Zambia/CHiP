(function (angular) {
    let MedplatFormFlywayController = function ($scope, config, $uibModalInstance, $uibModal, toaster, MedplatFormServiceV2, Mask, GeneralUtil, UUIDgenerator, QueryDAO) {

        $scope.init = () => {
            $scope.form = config.form;
            $scope.type = config.type;
            $scope.versionList = [];
            $scope.selectedVersion = null;
            $scope.form.availableVersion.forEach(v=>{
                if (!isNaN(v)) {
                    $scope.versionList.push(v);
                }
            });
            $scope.versionList.sort(function(a, b){return a-b});
            $scope.versionList.reverse();
        }

        $scope.download = () => {
            $scope.versionForm.$setSubmitted();
            if ($scope.versionForm.$valid) {
                Mask.show();
                MedplatFormServiceV2.getMedplatFormConfigByUuidAndVersion($scope.form.uuid, $scope.versionForm.selectedVersion.$modelValue).then((res) => {
                    $scope.medplatFormMasterDto = res;

                    $scope.flywayFieldConfig = $scope.medplatFormMasterDto.medplatFieldConfigs ? JSON.stringify($scope.medplatFormMasterDto.medplatFieldConfigs) : null;
                    $scope.flywayFormObject = $scope.medplatFormMasterDto.medplatFormMasterDto.formObject ? $scope.medplatFormMasterDto.medplatFormMasterDto.formObject : null;
                    $scope.flywayTemplateCss = $scope.medplatFormMasterDto.medplatFormMasterDto.templateCss ? $scope.medplatFormMasterDto.medplatFormMasterDto.templateCss : null;
                    $scope.flywayTemplateConfig = $scope.medplatFormMasterDto.medplatFormMasterDto.webTemplateConfig ? $scope.medplatFormMasterDto.medplatFormMasterDto.webTemplateConfig : null;
                    $scope.flywayFormVm = $scope.medplatFormMasterDto.medplatFormMasterDto.formVm ? $scope.medplatFormMasterDto.medplatFormMasterDto.formVm : null;
                    $scope.flywayExecutionSequence = $scope.medplatFormMasterDto.medplatFormMasterDto.executionSequence ? $scope.medplatFormMasterDto.medplatFormMasterDto.executionSequence : null;
                    $scope.flywayQueryConfig = $scope.medplatFormMasterDto.medplatFormMasterDto.queryConfig ? $scope.medplatFormMasterDto.medplatFormMasterDto.queryConfig : null;
                    $scope.flywayUser = $scope.medplatFormMasterDto.medplatFormMasterDto.createdBy;
                    $scope.flywayFormUUID = UUIDgenerator.generateUUID();
                    $scope.flywayFormUUIDStable = UUIDgenerator.generateUUID();

                    $scope.flywayQuery = "";

                    $scope.flywayQuery += 'with insert_into_medplat_form_master as (\n';
                    $scope.flywayQuery += "\tINSERT INTO medplat_form_master\n";
                    $scope.flywayQuery += "\t(\"uuid\", form_name, form_code, current_version, state, created_by, created_on, modified_by, modified_on, menu_config_id)\n";
                    $scope.flywayQuery += "\tSELECT \n";
                    $scope.flywayQuery += `\t\t'${$scope.form.uuid}',\n`;
                    $scope.flywayQuery += `\t\t'${$scope.form.formName}',\n`;
                    $scope.flywayQuery += `\t\t'${$scope.form.formCode}',\n`;
                    $scope.flywayQuery += `\t\t'1',\n`;
                    $scope.flywayQuery += `\t\t'${$scope.form.state}',\n`;
                    $scope.flywayQuery += `\t\t${$scope.flywayUser},\n`;
                    $scope.flywayQuery += `\t\tnow(),\n`;
                    $scope.flywayQuery += `\t\t${$scope.flywayUser},\n`;
                    $scope.flywayQuery += `\t\tnow(),\n`;
                    $scope.flywayQuery += `\t\t${$scope.form.menuConfigId}\n`;
                    $scope.flywayQuery += "\tON CONFLICT (form_code)\n";
                    $scope.flywayQuery += "\tDO UPDATE \n";
                    $scope.flywayQuery += "\tSET\n";
                    $scope.flywayQuery += "\t\tuuid=EXCLUDED.\"uuid\",\n";
                    $scope.flywayQuery += "\t\tform_name=EXCLUDED.form_name,\n";
                    // $scope.flywayQuery += "\t\tcurrent_version=cast(cast(coalesce(medplat_form_master.current_version,'0') as integer) + 1 as text),\n";
                    $scope.flywayQuery += "\t\tcurrent_version=cast(cast(coalesce((select max(cast(medplat_form_version_history.version as integer)) from medplat_form_master inner join medplat_form_version_history on medplat_form_master.uuid  = medplat_form_version_history.form_master_uuid where medplat_form_master.form_code = EXCLUDED.form_code and medplat_form_version_history.version <> 'DRAFT'),'0') as integer) + 1 as text),\n";
                    $scope.flywayQuery += "\t\tstate=EXCLUDED.state,\n";
                    $scope.flywayQuery += "\t\tcreated_by=EXCLUDED.created_by, \n";
                    $scope.flywayQuery += "\t\tcreated_on=EXCLUDED.created_on, \n";
                    $scope.flywayQuery += "\t\tmodified_by=EXCLUDED.modified_by, \n";
                    $scope.flywayQuery += "\t\tmodified_on=EXCLUDED.modified_on, \n";
                    $scope.flywayQuery += "\t\tmenu_config_id=EXCLUDED.menu_config_id\n";
                    $scope.flywayQuery += "\treturning medplat_form_master.current_version\n";
                    $scope.flywayQuery += ")\n";

                    $scope.flywayQuery += "INSERT INTO medplat_form_version_history\n";
                    $scope.flywayQuery += "(\"uuid\", form_master_uuid, template_config, field_config, \"version\", created_by, created_on, modified_by, modified_on, form_object, template_css, form_vm, execution_sequence, query_config)\n";
                    $scope.flywayQuery += "SELECT\n";
                    $scope.flywayQuery += `\t'${$scope.flywayFormUUIDStable}',\n`;
                    $scope.flywayQuery += `\t'${$scope.form.uuid}',\n`;
                    if ($scope.flywayTemplateConfig != null) {
                        $scope.flywayQuery += `\t${'\'' + $scope.flywayTemplateConfig.replace(/[']/g, "''")+ '\''},\n`;
                    } else {
                        $scope.flywayQuery += "\tnull,\n";
                    }
                    if ($scope.flywayFieldConfig != null) {
                        $scope.flywayQuery += `\t${'\'' + $scope.flywayFieldConfig.replace(/[']/g, "''")+ '\''},\n`;
                    } else {
                        $scope.flywayQuery += "\tnull,\n";
                    }
                    $scope.flywayQuery += "\tcurrent_version,\n";
                    $scope.flywayQuery += `\t${$scope.flywayUser},\n`;
                    $scope.flywayQuery += `\tnow(),\n`;
                    $scope.flywayQuery += `\t${$scope.flywayUser},\n`;
                    $scope.flywayQuery += `\tnow(),\n`;
                    if ($scope.flywayFormObject != null) {
                        $scope.flywayQuery += `\t${'\'' + $scope.flywayFormObject.replace(/[']/g, "''")+ '\''},\n`;
                    } else {
                        $scope.flywayQuery += "\tnull,\n";
                    }
                    if ($scope.flywayTemplateCss != null) {
                        $scope.flywayQuery += `\t${'\'' + $scope.flywayTemplateCss.replace(/[']/g, "''")+ '\''},\n`;
                    } else {
                        $scope.flywayQuery += "\tnull,\n";
                    }
                    if ($scope.flywayFormVm != null) {
                        $scope.flywayQuery += `\t${'\'' + $scope.flywayFormVm.replace(/[']/g, "''")+ '\''},\n`;
                    } else {
                        $scope.flywayQuery += "\tnull,\n";
                    }
                    if ($scope.flywayExecutionSequence != null) {
                        $scope.flywayQuery += `\t${'\'' + $scope.flywayExecutionSequence.replace(/[']/g, "''")+ '\''},\n`;
                    } else {
                        $scope.flywayQuery += "\tnull,\n";
                    }
                    if ($scope.flywayQueryConfig != null) {
                        $scope.flywayQuery += `\t${'\'' + $scope.flywayQueryConfig.replace(/[']/g, "''")+ '\''}\n`;
                    } else {
                        $scope.flywayQuery += "\tnull\n";
                    }
                    $scope.flywayQuery += "FROM insert_into_medplat_form_master;\n";

                    $scope.flywayQuery += "\n\n";

                    $scope.flywayQuery += `INSERT INTO medplat_form_version_history\n`;
                    $scope.flywayQuery += `("uuid", form_master_uuid, template_config, field_config, "version", created_by, created_on, modified_by, modified_on, form_object, template_css, form_vm, execution_sequence, query_config)\n`;
                    $scope.flywayQuery += `SELECT\n`;
                    $scope.flywayQuery += `\t'${$scope.flywayFormUUID}',\n`;
                    $scope.flywayQuery += `\t'${$scope.form.uuid}',\n`;
                    if ($scope.flywayTemplateConfig != null) {
                        $scope.flywayQuery += `\t${'\'' + $scope.flywayTemplateConfig.replace(/[']/g, "''")+ '\''},\n`;
                    } else {
                        $scope.flywayQuery += "\tnull,\n";
                    }
                    if ($scope.flywayFieldConfig != null) {
                        $scope.flywayQuery += `\t${'\'' + $scope.flywayFieldConfig.replace(/[']/g, "''")+ '\''},\n`;
                    } else {
                        $scope.flywayQuery += "\tnull,\n";
                    }
                    $scope.flywayQuery += "\t'DRAFT',\n";
                    $scope.flywayQuery += `\t${$scope.flywayUser},\n`;
                    $scope.flywayQuery += `\tnow(),\n`;
                    $scope.flywayQuery += `\t${$scope.flywayUser},\n`;
                    $scope.flywayQuery += `\tnow(),\n`;
                    if ($scope.flywayFormObject != null) {
                        $scope.flywayQuery += `\t${'\'' + $scope.flywayFormObject.replace(/[']/g, "''")+ '\''},\n`;
                    } else {
                        $scope.flywayQuery += "\tnull,\n";
                    }
                    if ($scope.flywayTemplateCss != null) {
                        $scope.flywayQuery += `\t${'\'' + $scope.flywayTemplateCss.replace(/[']/g, "''")+ '\''},\n`;
                    } else {
                        $scope.flywayQuery += "\tnull,\n";
                    }
                    if ($scope.flywayFormVm != null) {
                        $scope.flywayQuery += `\t${'\'' + $scope.flywayFormVm.replace(/[']/g, "''")+ '\''},\n`;
                    } else {
                        $scope.flywayQuery += "\tnull,\n";
                    }
                    if ($scope.flywayExecutionSequence != null) {
                        $scope.flywayQuery += `\t${'\'' + $scope.flywayExecutionSequence.replace(/[']/g, "''")+ '\''},\n`;
                    } else {
                        $scope.flywayQuery += "\tnull,\n";
                    }
                    if ($scope.flywayQueryConfig != null) {
                        $scope.flywayQuery += `\t${'\'' + $scope.flywayQueryConfig.replace(/[']/g, "''")+ '\''}\n`;
                    } else {
                        $scope.flywayQuery += "\tnull\n";
                    }
                    $scope.flywayQuery += `ON CONFLICT (form_master_uuid, "version")\n`;
                    $scope.flywayQuery += `DO UPDATE\n`;
                    $scope.flywayQuery += `SET\n`;
                    $scope.flywayQuery += `\tform_master_uuid=EXCLUDED.form_master_uuid,\n`;
                    $scope.flywayQuery += `\ttemplate_config=EXCLUDED.template_config, \n`;
                    $scope.flywayQuery += `\tfield_config=EXCLUDED.field_config, \n`;
                    $scope.flywayQuery += `\t"version"=EXCLUDED."version", \n`;
                    $scope.flywayQuery += `\tcreated_by=EXCLUDED.created_by,\n`;
                    $scope.flywayQuery += `\tcreated_on=EXCLUDED.created_on,\n`;
                    $scope.flywayQuery += `\tmodified_by=EXCLUDED.modified_by,\n`;
                    $scope.flywayQuery += `\tmodified_on=EXCLUDED.modified_on,\n`;
                    $scope.flywayQuery += `\tform_object=EXCLUDED.form_object,\n`;
                    $scope.flywayQuery += `\ttemplate_css=EXCLUDED.template_css,\n`;
                    $scope.flywayQuery += `\tform_vm=EXCLUDED.form_vm,\n`;
                    $scope.flywayQuery += `\texecution_sequence=EXCLUDED.execution_sequence,\n`;
                    $scope.flywayQuery += `\tquery_config=EXCLUDED.query_config;\n`;


                    let a = window.document.createElement('a');
                    a.href = window.URL.createObjectURL(new Blob([$scope.flywayQuery], { type: 'text/plain' }));
                    let name = `${$scope.form.formCode}__V_${$scope.versionForm.selectedVersion.$modelValue}__stable_form_configuration.sql`;
                    a.download = name;
                    document.body.appendChild(a);
                    a.click();
                    document.body.removeChild(a);
                    $uibModalInstance.close(Mask.hide());
                }, GeneralUtil.showMessageOnApiCallFailure).finally(Mask.hide());
            } else {
                Mask.hide();
            }
        }

        $scope.resetDraft = () => {
            $scope.versionForm.$setSubmitted();
            if ($scope.versionForm.$valid) {
                let dto = {
                    code: 'reset_draft_medplat_form_version_history_from_stable',
                    parameters: {
                        uuid: $scope.form.uuid,
                        version: $scope.versionForm.selectedVersion.$modelValue
                    }
                };
                Mask.show();
                QueryDAO.execute(dto).then(function (res) {
                    toaster.pop("success", `Draft Version Updated Successfully.`);
                    $uibModalInstance.close();
                }, GeneralUtil.showMessageOnApiCallFailure).finally(function () {
                    Mask.hide();
                });
            }
        }

        $scope.cancel = () => {
            $uibModalInstance.dismiss();
        }

        $scope.init();

    };
    angular.module('imtecho.controllers').controller('MedplatFormFlywayController', MedplatFormFlywayController);
})(window.angular);
