/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.migration.controller;

import com.argusoft.imtecho.fhs.dto.MemberDto;
import com.argusoft.imtecho.fhs.service.FamilyHealthSurveyService;
import com.argusoft.imtecho.migration.model.MigrationEntity;
import com.argusoft.imtecho.migration.service.MigrationService;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 *
 * @author vaishali
 */
@RestController
@RequestMapping(value = "api/migration")
public class MigrationController {

    @Autowired
    private MigrationService migrationService;

    @Autowired
    private FamilyHealthSurveyService familyHealthSurveyService;

    @GetMapping(value = "/similarmembers/{migrationId}")
    public List<MemberDto> retrieveSimilarMembers(@PathVariable Integer migrationId) {
        return migrationService.retrieveSimilarMembers(migrationId);
    }

    @GetMapping(value = "/migratedIn")
    public List<MigrationEntity> retrieveMigratedInMembers() {
        return migrationService.retrieveMigratedInMembers();
    }

    @GetMapping(value = "/searchMembers")
    public List<MemberDto> fetchByUniqueHealthId(@RequestParam(value = "searchString") String searchString,@RequestParam(value = "searchBy") String searchBy,@RequestParam(value = "limit")Integer limit,@RequestParam(value = "offset")Integer offset) {
        return familyHealthSurveyService.searchMembers( searchString, searchBy,limit,offset);
    }

    @PostMapping(value = "/confirmMember/{migrationId}")
    public void confirmMember(@RequestBody MemberDto memberDto, @PathVariable Integer migrationId) {
        migrationService.confirmMember(memberDto, migrationId);
    }

    @PostMapping(value = "/temporaryMember/{migrationId}")
    public void createTempMember(@PathVariable Integer migrationId) {
        migrationService.createTemporaryMember(migrationId);
    }

}
