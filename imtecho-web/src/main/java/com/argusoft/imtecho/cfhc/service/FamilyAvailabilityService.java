package com.argusoft.imtecho.cfhc.service;

import com.argusoft.imtecho.cfhc.dto.FamilyAvailabilityDataBean;

import java.util.List;
import java.util.Map;

/**
 * Defines methods for FamilyAvailabilityService
 *
 * @author prateek
 * @since 05/06/23 2:32 pm
 */
public interface FamilyAvailabilityService {

    List<FamilyAvailabilityDataBean> getFamilyAvailabilityByModifiedOn(Integer userId, Long modifiedOn);

    Integer storeFamilyAvailability(FamilyAvailabilityDataBean familyAvailabilityDataBean);
}
