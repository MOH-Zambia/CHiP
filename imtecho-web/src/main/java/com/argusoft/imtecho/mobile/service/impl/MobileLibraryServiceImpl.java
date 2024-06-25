package com.argusoft.imtecho.mobile.service.impl;

import com.argusoft.imtecho.mobile.dao.MobileLibraryDao;
import com.argusoft.imtecho.mobile.dto.MobileLibraryDataBean;
import com.argusoft.imtecho.mobile.mapper.MobileLibraryDataBeanMapper;
import com.argusoft.imtecho.mobile.model.MobileLibraryMaster;
import com.argusoft.imtecho.mobile.service.MobileLibraryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * @author prateek on 13 Feb, 2019
 */
@Service
@Transactional
public class MobileLibraryServiceImpl implements MobileLibraryService {

    @Autowired
    MobileLibraryDao mobileLibraryDao;

    @Override
    public List<MobileLibraryDataBean> retrieveMobileLibraryDataBeans(Integer roleId, Long lastUpdateDate) {
        if (lastUpdateDate == null) {
            lastUpdateDate = 0L;
        }
        List<MobileLibraryDataBean> mobileLibraryDataBeans = new ArrayList<>();
        List<MobileLibraryMaster> mobileLibraryMasters
                = mobileLibraryDao.retrieveMobileLibraryMastersByLastUpdateDate(roleId, new Date(lastUpdateDate));

        if (mobileLibraryMasters != null && !mobileLibraryMasters.isEmpty()) {
            for (MobileLibraryMaster mobileLibraryMaster : mobileLibraryMasters) {
                mobileLibraryDataBeans.add(MobileLibraryDataBeanMapper.convertMobileLibraryMasterToLibraryDataBean(mobileLibraryMaster));
            }
        }
        return mobileLibraryDataBeans;
    }
}
