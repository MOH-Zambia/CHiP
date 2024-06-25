package com.argusoft.imtecho.location.service;

import com.argusoft.imtecho.location.model.HealthInfraStructureOtherDetails;
import com.argusoft.imtecho.location.model.HealthInfrastructureHFRDetails;
import com.argusoft.imtecho.location.model.HealthInfrastructureMatchDetail;
import com.argusoft.imtecho.mobile.dto.HealthInfrastructureBean;

import java.util.List;

/**
 * <p>
 * Define services for health infra structure.
 * </p>
 *
 * @author prateek
 * @since 26/08/20 11:00 AM
 */
public interface HealthInfrastructureService {

    /**
     * Update all health infrastructure for mobile.
     */
    void updateAllHealthInfrastructureForMobile();

    /**
     * Retrieves private health infrastructure by name.
     *
     * @param query Name of health infrastructure.
     * @return Returns list of health infrastructure details.
     */
    List<HealthInfrastructureBean> getHealthInfrastructurePrivateHospital(String query);


//    /**
//     * get health infrastructure by given id
//     *
//     * @param id An id of  health infrastructure.
//     * @return an instance of HealthInfrastructureHFRDetails.
//     */
//    HealthInfrastructureHFRDetails getHealthInfrastructureById(Integer id);

//    /**
//     * Link hfrFacilityId with bridgeID if not linked with other facility
//     *
//     * @param id            An id of  private health infrastructure.
//     * @param hfrFacilityId A facilityID of health infrastructure.
//     * @return an instance of HealthInfrastructureMatchDetail.
//     */
//    HealthInfrastructureMatchDetail saveAndLinkHFRId(Integer id, String hfrFacilityId);

    public void toggleActive(Integer courseId,String state);
}
