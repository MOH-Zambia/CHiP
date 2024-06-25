package com.argusoft.imtecho.migration.service;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.migration.dto.FamilyMigrationInConfirmationDataBean;
import com.argusoft.imtecho.migration.dto.FamilyMigrationOutDataBean;
import com.argusoft.imtecho.migration.dto.MigratedFamilyDataBean;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;

import java.util.List;

/**
 * @author prateek on Aug 19, 2019
 */
public interface FamilyMigrationService {

    Integer storeFamilyMigrationOut(ParsedRecordBean parsedRecordBean, FamilyMigrationOutDataBean familyMigrationOutDataBean, UserMaster userMaster);

    Integer storeFamilyMigrationInConfirmation(FamilyMigrationInConfirmationDataBean familyMigrationInConfirmation, UserMaster user);

    public List<MigratedFamilyDataBean> retrieveMigrationByLocation(Integer userId);

    public Integer revertMigration(MigratedFamilyDataBean migratedFamilyDataBean, UserMaster user);

}
