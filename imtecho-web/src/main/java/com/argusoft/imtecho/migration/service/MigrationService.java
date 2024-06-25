/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.migration.service;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.fhs.dto.MemberDto;
import com.argusoft.imtecho.migration.dto.MigratedMembersDataBean;
import com.argusoft.imtecho.migration.dto.MigrationInConfirmationDataBean;
import com.argusoft.imtecho.migration.dto.MigrationInDataBean;
import com.argusoft.imtecho.migration.dto.MigrationOutConfirmationDataBean;
import com.argusoft.imtecho.migration.dto.MigrationOutDataBean;
import com.argusoft.imtecho.migration.model.MigrationEntity;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;

import java.util.List;

/**
 * @author kunjan
 */
public interface MigrationService {

    List<MigratedMembersDataBean> retrieveMigrationDetailsDataBean(Integer userId);

    Integer revertMigration(MigratedMembersDataBean migratedMembersDataBean, UserMaster user);

    Integer createMigrationIn(MigrationInDataBean migrationInDataBean, UserMaster user);

    Integer createMigrationOut(ParsedRecordBean parsedRecordBean, MigrationOutDataBean migrationOutDataBean, UserMaster user);

    Integer createMigrationOutConfirmation(MigrationOutConfirmationDataBean migrationOutConfirmation, UserMaster user);

    Integer createMigrationInConfirmation(MigrationInConfirmationDataBean migrationInConfirmation, UserMaster user);

//    void cronForCreatingTemporaryMember();

    void cronForMigrationOutWithNoResponse();

//    void cronForMigrationInWithNoResponse();

    List<MemberDto> retrieveSimilarMembers(Integer migrationId);

    List<MigrationEntity> retrieveMigratedInMembers();

    void confirmMember(MemberDto memberDto, Integer migrationId);

    void createTemporaryMember(Integer migrationId);

    void createTemporaryMemberForMigrationInWithoutPhoneNumber();
}
