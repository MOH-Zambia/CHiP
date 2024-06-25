/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.migration.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.fhs.dto.MemberDto;
import com.argusoft.imtecho.migration.dto.MigratedMembersDataBean;
import com.argusoft.imtecho.migration.model.MigrationEntity;
import java.util.List;

/**
 *
 * @author kunjan
 */
public interface MigrationEntityDao extends GenericDao<MigrationEntity, Integer> {

    List<MigratedMembersDataBean> retrieveMigrationByLocation(Integer userId);

    List<MigrationEntity> retrieveMigrationForCreatingTemporaryMembers(Boolean fromCron);

    List<MigrationEntity> retrieveMigrationOutWithNoResponse();

    List<MigrationEntity> retrieveMigrationInWithNoResponse();

    List<Integer> retrieveSimilarMemberIds(MigrationEntity migrationEntity);

    List<MigrationEntity> retrieveMigrationInMembers(Boolean isUnverifiedOnly);

    List<MemberDto> retrieveSimilarMembersFound(Integer migrationId);

    List<MigrationEntity> retrieveMigrationInWithoutPhoneNumber();

    boolean checkIfMigrationOutAlreadyReported(Integer memberId);
}
