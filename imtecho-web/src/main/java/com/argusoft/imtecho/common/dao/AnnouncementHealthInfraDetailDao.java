package com.argusoft.imtecho.common.dao;

import com.argusoft.imtecho.common.model.AnnouncementHealthInfraDetail;
import com.argusoft.imtecho.common.model.AnnouncementHealthInfraDetailPKey;
import com.argusoft.imtecho.database.common.GenericDao;

import java.util.List;

public interface AnnouncementHealthInfraDetailDao extends GenericDao<AnnouncementHealthInfraDetail, Integer> {

    List<AnnouncementHealthInfraDetail> retrieveById(AnnouncementHealthInfraDetailPKey announcementHealthInfraDetailPKey);
}
