package com.argusoft.imtecho.chip.service;

import java.util.Date;

public interface StoreReferralDetailsService {


    void storeDataToStoreReferralDetails(
            Integer memberId,
            Integer referredTo,
            String referralReason,
            String serviceArea,
            String nupnId,
            Integer referredBy,
            String notes,
            Integer referredFrom,
            Date referredOn,
            Boolean syncStatus,
            Integer visitId
    );
}
