package com.argusoft.imtecho.cfhc.service.impl;

import com.argusoft.imtecho.cfhc.dto.FamilyAvailabilityDataBean;
import com.argusoft.imtecho.cfhc.service.FamilyAvailabilityService;
import com.argusoft.imtecho.fhs.dao.FamilyAvailabilityDetailDao;
import com.argusoft.imtecho.fhs.model.FamilyAvailabilityDetail;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

/**
 * Defines methods for FamilyAvailabilityServiceImpl
 *
 * @author prateek
 * @since 05/06/23 2:32 pm
 */
@Service
@Transactional
public class FamilyAvailabilityServiceImpl implements FamilyAvailabilityService {

    @Autowired
    FamilyAvailabilityDetailDao familyAvailabilityDetailDao;

    public List<FamilyAvailabilityDataBean> getFamilyAvailabilityByModifiedOn(Integer userId, Long modifiedOn) {
        Date dt = null;
        if (modifiedOn != null && modifiedOn != 0L) {
            dt = new Date(modifiedOn);
        }
        return familyAvailabilityDetailDao.getFamilyAvailabilityByModifiedOn(userId, dt);
    }

    @Override
    public Integer storeFamilyAvailability(FamilyAvailabilityDataBean familyAvailabilityDataBean) {
        if (familyAvailabilityDataBean != null) {
            FamilyAvailabilityDetail familyAvailabilityDetail = familyAvailabilityDetailDao.retrieveById(familyAvailabilityDataBean.getActualId());
            if (familyAvailabilityDetail != null) {
                familyAvailabilityDetail.setAvailabilityStatus(familyAvailabilityDataBean.getAvailabilityStatus());
                familyAvailabilityDetailDao.update(familyAvailabilityDetail);
                return familyAvailabilityDetail.getId();
            }
        }
        return null;
    }

}
