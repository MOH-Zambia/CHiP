package com.argusoft.imtecho.common.service.impl;

import com.argusoft.imtecho.common.dao.Dhis2Dao;
import com.argusoft.imtecho.common.interceptor.Dhis2CallLogInterceptor;
import com.argusoft.imtecho.common.service.Dhis2DataService;
import com.argusoft.imtecho.common.util.Dhis2ConstantsUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.http.client.BufferingClientHttpRequestFactory;
import org.springframework.http.client.ClientHttpRequestFactory;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import java.util.*;

@Service
@Transactional
public class Dhis2DataServiceImpl implements Dhis2DataService {

    private static final ClientHttpRequestFactory factory = new BufferingClientHttpRequestFactory(new SimpleClientHttpRequestFactory());

    @Autowired
    private Dhis2Dao dhis2Dao;

    private final RestTemplate restTemplate = new RestTemplate(factory);

    @Autowired
    private Dhis2ConstantsUtil dhis2ConstantsUtil;

    private static final Logger log = LoggerFactory.getLogger(Dhis2DataServiceImpl.class);

    private static final String DHIS2_USERNAME = "CBHIS";
    private static final String DHIS2_PASSWORD = "Newp@ss2";

    @Override
    public String sendData(Date monthEnd, Integer facilityId) {
        String jsonString = dhis2Dao.getData(monthEnd, facilityId);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBasicAuth(DHIS2_USERNAME, DHIS2_PASSWORD);

        HttpEntity<String> entity = new HttpEntity<>(jsonString, headers);
        restTemplate.setInterceptors(Collections.singletonList(new Dhis2CallLogInterceptor(dhis2Dao, monthEnd)));

        ResponseEntity<String> response = restTemplate.exchange(
                dhis2ConstantsUtil.getDhis2Api(), HttpMethod.POST, entity, String.class);
        log.info("Response body: {}", response.getStatusCode());

        return response.getStatusCode().toString();
    }

    @Override
    public String sendMultipleData(Date monthEnd,List<Integer> facilityIds){
        Map<Integer, String> facilityResponses = new HashMap<>();

        for (Integer facilityId : facilityIds) {
            try {
                String response = this.sendData(monthEnd,facilityId);
                log.info("Response for facility ID {}: {}", facilityId, response);
                facilityResponses.put(facilityId, response);
            } catch (Exception e) {
                log.error("Error processing facility ID {}: {}", facilityId, e.getMessage(), e);
                facilityResponses.put(facilityId, "FAILED");
            }
        }
        if (!facilityResponses.containsValue("FAILED")) {
            log.info("All facility IDs processed successfully");
            return "200 OK";
        } else {
            return "PARTIAL_SUCCESS"; // Indicating partial success
        }
    }


    public List<Integer> getEnabledFacilities(){
        return dhis2Dao.getEnabledFacilities();
    }

}
