package com.argusoft.imtecho.location.service.impl;

import com.argusoft.imtecho.common.util.ConstantUtil;
import com.argusoft.imtecho.location.constants.LocationConstants;
import com.argusoft.imtecho.location.dao.HealthInfrastructureDetailsDao;
import com.argusoft.imtecho.location.model.*;
import com.argusoft.imtecho.location.service.HealthInfrastructureService;
import com.argusoft.imtecho.mobile.dto.HealthInfrastructureBean;
import com.google.gson.Gson;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;

/**
 * <p>
 * Define services for health infra structure.
 * </p>
 *
 * @author prateek
 * @since 26/08/20 11:00 AM
 */
@Service
@Transactional
public class HealthInfrastructureServiceImpl implements HealthInfrastructureService {

    private static final Logger logger = LoggerFactory.getLogger(HealthInfrastructureServiceImpl.class);

    @Autowired
    private HealthInfrastructureDetailsDao healthInfrastructureDetailsDao;

    /**
     * {@inheritDoc}
     */
    @Override
    public void updateAllHealthInfrastructureForMobile() {
        logger.info("Updating Cache Of Health Infrastructures For Mobile");
        LocationConstants.allHealthInfrastructureForMobile = healthInfrastructureDetailsDao.retrieveAllHealthInfrastructureForMobile(null);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<HealthInfrastructureBean> getHealthInfrastructurePrivateHospital(String query) {
        return healthInfrastructureDetailsDao.getHealthInfrastructureByType(ConstantUtil.PRIVATE_HOSPITAL_FIELD_ID, query);
    }


//    /**
//     * {@inheritDoc}
//     */
//    @Override
//    public HealthInfrastructureHFRDetails getHealthInfrastructureById(Integer id) {
//        HealthInfrastructureHFRDetails healthInfrastructureHFRDetails = new HealthInfrastructureHFRDetails();
//        HealthInfrastructureDetails details = healthInfrastructureDetailsDao.retrieveById(id);
//        healthInfrastructureHFRDetails.setHealthInfrastructureDetails(details);
//
//        HealthInfrastructureLocationName locationName = healthInfrastructureDetailsDao.getLocationName(details.getLocationId());
//        healthInfrastructureHFRDetails.setLocationName(locationName.getLocationname());
//
//        HealthInfraStructureOtherDetails otherDetails;
//        Gson gson = new Gson();
//        if (details.getOtherDetails() != null && !details.getOtherDetails().isEmpty()) {
//            otherDetails = gson.fromJson(details.getOtherDetails(), HealthInfraStructureOtherDetails.class);
//        } else {
//            otherDetails = new HealthInfraStructureOtherDetails();
//        }
//
//        healthInfrastructureHFRDetails.setTimingsOfFacility(otherDetails.getTimingsOfFacility());
//        healthInfrastructureHFRDetails.setGeneralInformation(otherDetails.getGeneralInformation());
//        healthInfrastructureHFRDetails.setLinkedProgramIds(otherDetails.getLinkedProgramIds());
//        healthInfrastructureHFRDetails.setSpecialities(otherDetails.getSpecialities());
//        healthInfrastructureHFRDetails.setMedicalInfrastructure(otherDetails.getMedicalInfrastructure());
//        healthInfrastructureHFRDetails.setPharmacyDetails(otherDetails.getPharmacyDetails());
//        healthInfrastructureHFRDetails.setBloodBankDetails(otherDetails.getBloodBankDetails());
//        healthInfrastructureHFRDetails.setImagingServices(otherDetails.getImagingServices());
//        healthInfrastructureHFRDetails.setDiagnosticServices(otherDetails.getDiagnosticServices());
//        return healthInfrastructureHFRDetails;
//    }
//
    @Override
    public void toggleActive(Integer healthInfraId, String state) {
        healthInfrastructureDetailsDao.toggleActive(healthInfraId, state);
    }
}
