package com.argusoft.imtecho.chip.service.impl;

import com.argusoft.imtecho.chip.dao.StoreReferralDetailsDao;
import com.argusoft.imtecho.chip.model.StoreReferralDetails;
import com.argusoft.imtecho.chip.service.StoreReferralDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.Date;


@Service
@Transactional
public class StoreReferralDetailsServiceImpl implements StoreReferralDetailsService {

    @Autowired
    private StoreReferralDetailsDao storeReferralDetailsDao;

    @Override
    public void storeDataToStoreReferralDetails(
            Integer memberId,
            Integer referredTo,
            String referredPlace,
            String referralReason,
            String serviceArea,
            String nupnId,
            Integer referredBy,
            String notes,
            Integer referredFrom,
            Date referredOn,
            Boolean syncStatus,
            Integer visitId
    ) {

        StoreReferralDetails referralDetails = new StoreReferralDetails();
        referralDetails.setMemberId(memberId);
        referralDetails.setReferredPlace(referredPlace);
        referralDetails.setReferralReason(referralReason);
        referralDetails.setServiceArea(serviceArea);
        referralDetails.setReferredBy(referredBy);
        referralDetails.setNupnId(nupnId);
        referralDetails.setReferredTo(referredTo);
        referralDetails.setSyncStatus(syncStatus);
        referralDetails.setReferredOn(referredOn);
        referralDetails.setNotes(notes);
        referralDetails.setReferredFrom(referredFrom);
        referralDetails.setVisitId(visitId);
        storeReferralDetailsDao.create(referralDetails);
    }
}



