package com.argusoft.imtecho.common.service;

import java.util.Date;
import java.util.List;

public interface Dhis2DataService {

    String sendData(Date monthEnd, Integer facilityId);

    List<Integer> getEnabledFacilities();
}
