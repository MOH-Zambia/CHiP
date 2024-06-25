
package com.argusoft.imtecho.common.service.impl;

import com.argusoft.imtecho.common.dao.SmsResponseDao;
import com.argusoft.imtecho.common.service.NicSmsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Implements methods of NicSmsService
 * @author ashish
 * @since 28/08/2020 4:30
 */
@Service
@Transactional
public class NicSmsServiceimpl implements NicSmsService {

    @Autowired
    SmsResponseDao smsResponseDao;

    /**
     * {@inheritDoc}
     */
    @Override
    public void smsResponse(String a2wackid, String a2wstatus, String carrierstatus, String lastutime, String custref, String submitdt, String mnumber, String acode, String senderid) {
        smsResponseDao.createOrUpdate(a2wackid, a2wstatus, carrierstatus, lastutime, custref, submitdt, mnumber, acode, senderid);
    }
}
