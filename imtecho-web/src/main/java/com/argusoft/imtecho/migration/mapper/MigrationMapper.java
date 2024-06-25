///*
// * To change this license header, choose License Headers in Project Properties.
// * To change this template file, choose Tools | Templates
// * and open the template in the editor.
// */
//package com.argusoft.imtecho.migration.mapper;
//
//import com.argusoft.imtecho.migration.dto.MigrationMobileDataBean;
//import com.argusoft.imtecho.migration.model.MigrationEntity;
//
///**
// *
// * @author kunjan
// */
//public class MigrationMapper {
//
//    public static MigrationEntity convertMigrationMobileDataBeanToMigrationEntity(MigrationMobileDataBean migrationMobileDataBean) {
//        MigrationEntity migrationEntity = new MigrationEntity();
//        migrationEntity.setMemberId(migrationMobileDataBean.getMemberId());
//        migrationEntity.setReportedBy(migrationMobileDataBean.getReportedBy());
//        migrationEntity.setReportedOn(migrationMobileDataBean.getReportedOn());
//        migrationEntity.setLocationMigratedTo(migrationMobileDataBean.getLocationMigratedTo());
//        migrationEntity.setLocationMigratedFrom(migrationMobileDataBean.getLocationMigratedFrom());
//        migrationEntity.setFamilyMigratedTo(migrationMobileDataBean.getFamilyMigratedTo());
//        migrationEntity.setFamilyMigratedFrom(migrationMobileDataBean.getFamilyMigratedFrom());
//        migrationEntity.setState(migrationMobileDataBean.getState());
//        migrationEntity.setMigratedLocationNotKnown(migrationMobileDataBean.getMigratedLocationNotKnown());
//        migrationEntity.setConfirmedBy(migrationMobileDataBean.getConfirmedBy());
//        migrationEntity.setConfirmedOn(migrationMobileDataBean.getConfirmedOn());
//        migrationEntity.setType(migrationMobileDataBean.getType());
//        migrationEntity.setOtherInfo(migrationMobileDataBean.getOtherInfo());
//        return migrationEntity;
//    }
//}
