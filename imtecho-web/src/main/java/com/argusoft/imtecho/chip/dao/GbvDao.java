package com.argusoft.imtecho.chip.dao;

import com.argusoft.imtecho.chip.model.GbvVisit;
import com.argusoft.imtecho.database.common.GenericDao;

public interface GbvDao extends GenericDao<GbvVisit, Integer> {
    Integer updateDocumentId(String uuid, Long docId, Integer relatedId, Integer memberId);

}
