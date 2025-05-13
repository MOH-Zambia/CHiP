package com.argusoft.imtecho.chip.dao.impl; // Update to match your package structure

import com.argusoft.imtecho.chip.dao.StoreReferralDetailsDao;
import com.argusoft.imtecho.chip.model.StoreReferralDetails;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
@Transactional
public class StoreReferralDetailsDaoImpl extends GenericDaoImpl<StoreReferralDetails, Integer> implements StoreReferralDetailsDao {

}
