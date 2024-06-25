
package com.argusoft.imtecho.common.service.impl;

import com.argusoft.imtecho.common.dao.SequenceDao;
import com.argusoft.imtecho.common.service.SequenceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Implements methods of SequenceService
 * @author kunjan
 * @since 28/08/2020 4:30
 */

@Service
@Transactional
public class SequenceServiceImpl  implements SequenceService {

    @Autowired
    SequenceDao sequenceDao;
    
    /**
     * {@inheritDoc}
     */
    @Override
    public Integer getNextValueBySequenceName(String sequenceName) {
        return sequenceDao.getNextValueBySequenceName(sequenceName);
    }
}
