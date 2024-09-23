package com.argusoft.imtecho.formconfigurator.controller;

import com.argusoft.imtecho.formconfigurator.dto.MedplatFieldKeyMapDto;
import com.argusoft.imtecho.formconfigurator.dto.MedplatFormConfigurationDto;
import com.argusoft.imtecho.formconfigurator.dto.MedplatFormMasterDto;
import com.argusoft.imtecho.formconfigurator.service.MedplatFormDataService;
import com.argusoft.imtecho.formconfigurator.service.MedplatFormService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/medplatform")
public class MedplatFormController {

    @Autowired
    private MedplatFormService medplatFormService;

    @Autowired
    private MedplatFormDataService medplatFormDataService;

    @PostMapping(value = "/savemedplatform")
    public void saveMedplatFormConfiguration(@RequestBody MedplatFormConfigurationDto medplatFormConfigurationDto) {
        medplatFormService.saveMedplatFormConfiguration(medplatFormConfigurationDto);
    }

    @PostMapping(value = "/savemedplatformstable")
    public void saveMedplatFormConfigurationStable(@RequestBody MedplatFormConfigurationDto medplatFormConfigurationDto) {
        medplatFormService.saveMedplatFormConfigurationStable(medplatFormConfigurationDto);
    }

    @PutMapping(value = "/updatemedplatformasdraft")
    public void updateMedplatFormConfigurationAsDraft(@RequestBody MedplatFormConfigurationDto medplatFormConfigurationDto) {
        medplatFormService.updateMedplatFormVersionHistoryByField(medplatFormConfigurationDto, "FIELD_CONFIG");
    }

    @PutMapping(value = "/updatemedplatformversion")
    public void updateMedplatFormVersion(@RequestBody MedplatFormConfigurationDto medplatFormConfigurationDto) {
        medplatFormService.updateMedplatFormVersion(medplatFormConfigurationDto);
    }

    @PutMapping(value = "/updatemedplatformobject")
    public void updateMedplatFormConfigurationFormObject(@RequestBody MedplatFormConfigurationDto medplatFormConfigurationDto) {
        medplatFormService.updateMedplatFormVersionHistoryByField(medplatFormConfigurationDto, "FORM_OBJECT");
    }

    @PutMapping(value = "/updatemedplatformtemplateconfig")
    public void updateMedplatFormConfigurationFormTemplateConfig(@RequestBody MedplatFormConfigurationDto medplatFormConfigurationDto) {
        medplatFormService.updateMedplatFormVersionHistoryByField(medplatFormConfigurationDto, "FORM_TEMPLATE_CONFIG");
    }

    @PutMapping(value = "/updatemedplatformvm")
    public void updateMedplatFormConfigurationFormVm(@RequestBody MedplatFormConfigurationDto medplatFormConfigurationDto) {
        medplatFormService.updateMedplatFormVersionHistoryByField(medplatFormConfigurationDto, "FORM_VM");
    }

    @PutMapping(value = "/updatemedplatformqueryconfig")
    public void updateMedplatFormConfigurationFormQueryConfig(@RequestBody MedplatFormConfigurationDto medplatFormConfigurationDto) {
        medplatFormService.updateMedplatFormVersionHistoryByField(medplatFormConfigurationDto, "FORM_QUERY_CONFIG");
    }

    @PostMapping(value = "/updatemedplatform")
    public void updateMedplatFormConfiguration(@RequestBody MedplatFormConfigurationDto medplatFormConfigurationDto) {
        medplatFormService.updateMedplatFormConfiguration(medplatFormConfigurationDto);
    }

    @GetMapping(value = "/fieldkeymap")
    public List<MedplatFieldKeyMapDto> getMedplatFieldKeyMap(@RequestParam(value = "fieldCode", required = false) String fieldCode) {
        return medplatFormService.getMedplatFieldKeyMap(fieldCode);
    }

    @RequestMapping(value = "/forms", method = RequestMethod.GET)
    public List<MedplatFormMasterDto> getMedplatForms() {
        return medplatFormService.getMedplatForms(null);
    }

    @RequestMapping(value = "/forms/{menuConfigId}", method = RequestMethod.GET)
    public List<MedplatFormMasterDto> getMedplatFormsByMenuConfigId(@PathVariable Integer menuConfigId) {
        return medplatFormService.getMedplatForms(menuConfigId);
    }

    @RequestMapping(value = "/form/{uuid}", method = RequestMethod.GET)
    public MedplatFormMasterDto getMedplatFormByUuid(@PathVariable UUID uuid) {
        return medplatFormService.getMedplatFormByUuid(uuid);
    }

    @RequestMapping(value = "/formConfig/{uuid}", method = RequestMethod.GET)
    public String getMedplatFormConfigByUuid(@PathVariable UUID uuid) {
        return medplatFormService.getMedplatFormConfigByUuid(uuid);
    }

    @RequestMapping(value = "/formConfigEdit/{uuid}", method = RequestMethod.GET)
    public String getMedplatFormConfigByUuidForEdit(@PathVariable UUID uuid) {
        return medplatFormService.getMedplatFormConfigByUuidForEdit(uuid);
    }

    @RequestMapping(value = "/formConfig/{uuid}/{version}", method = RequestMethod.GET)
    public String getMedplatFormConfigByUuidAndVersion(@PathVariable UUID uuid, @PathVariable String version) {
        return medplatFormService.getMedplatFormConfigByUuidAndVersion(uuid, version);
    }

    @PostMapping(value = "/updateFormVersion")
    public void updateFormVersion(@RequestBody MedplatFormConfigurationDto medplatFormConfigurationDto) {
        medplatFormService.updateMedplatFormVersionHistoryByField(medplatFormConfigurationDto, "EXECUTION_SEQUENCE");
    }

    @RequestMapping(value = "/dynamicform/{formCode}", method = RequestMethod.GET)
    public String getMedplatFormConfigByFormCode(@PathVariable String formCode) {
        return medplatFormService.getMedplatFormConfigByFormCode(formCode);
    }

    @PostMapping(value = "/savedata/{formCode}")
    public void saveMedplatFormDataByFormCodeV2(@PathVariable String formCode, @RequestBody String data) {
        Integer masterId = medplatFormDataService.dumpFormData(formCode, data);
        medplatFormDataService.saveFormData(formCode, data, masterId);
    }

}
