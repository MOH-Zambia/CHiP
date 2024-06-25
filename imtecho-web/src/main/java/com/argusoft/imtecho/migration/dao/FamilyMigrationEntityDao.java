package com.argusoft.imtecho.migration.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.migration.dto.MigratedFamilyDataBean;
import com.argusoft.imtecho.migration.model.FamilyMigrationEntity;

import java.util.List;

/**
 *
 * @author prateek on Aug 19, 2019
 */
public interface FamilyMigrationEntityDao extends GenericDao<FamilyMigrationEntity, Integer> {

    public List<MigratedFamilyDataBean> retrieveMigrationByLocation(Integer userId);
}
