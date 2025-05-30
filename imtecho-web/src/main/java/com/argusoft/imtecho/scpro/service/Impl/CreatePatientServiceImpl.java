package com.argusoft.imtecho.scpro.service.Impl;

import com.argusoft.imtecho.common.dao.SystemConfigurationDao;
import com.argusoft.imtecho.common.model.SystemConfiguration;
import com.argusoft.imtecho.fhs.dto.ReferralDto;
import com.argusoft.imtecho.scpro.dao.PatientDao;
import com.argusoft.imtecho.scpro.dao.ReferralDao;
import com.argusoft.imtecho.scpro.dto.*;
import com.argusoft.imtecho.scpro.model.PatientData;
import com.argusoft.imtecho.scpro.model.ReferralData;
import com.argusoft.imtecho.scpro.service.CreatePatientService;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import lombok.extern.slf4j.Slf4j;
import org.jetbrains.annotations.NotNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDateTime;
import java.util.Base64;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@Transactional
public class CreatePatientServiceImpl implements CreatePatientService {
    private String accessToken = "";

    private final RestTemplate restTemplate;

    @Autowired
    PatientDao patientDao;
    @Autowired
    ReferralDao referralDao;
    @Autowired
    SystemConfigurationDao systemConfigurationDao;

    public CreatePatientServiceImpl(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }


    @Override
    public void createPatient(MemberDetailsDTO memberDetailsDTO){
        ObjectMapper objectMapper = new ObjectMapper();

        String apiUrl = "http://10.52.45.59:8080/api/v1/patient";
        //String accessToken = "eyJhbGciOiJIUzUxMiJ9.eyJwZXJtaXNzaW9ucyI6WyJHRVRfUEFUSUVOVF9TVEFUVVMiLCJQT1NUX1JFRkVSUkFMIiwiUE9TVF9QQVRJRU5UIiwiR0VUX1JFRkVSUkFMX1NUQVRVUyIsIlNVQlNDUklCRSJdLCJzdWIiOiJzeXN0ZW1AZW1haWwuY28uem0iLCJpYXQiOjE3NDc4MTQxODMsImV4cCI6MTc0Nzg0Mjk4M30.Fds9VvnCoUavO6877zlUfnyxaECDEvNrVKwvlhSoZgKh9m6qi2VMJiXT3iJdHoR06lCp-Ji4E1YylMr2hyxdnw";

        try {
            if (isTokenExpired()) {
                fetchNewAccessToken(); // Refresh the token if expired
            }
            HttpHeaders headers = new HttpHeaders();
            headers.set("Content-Type", "application/json");
            headers.set("x-msg-format","message format");
            headers.set("Authorization", "Bearer " + accessToken);

            HttpEntity<MemberDetailsDTO> request = new HttpEntity<>(memberDetailsDTO, headers);

            ResponseEntity<String> response = restTemplate.exchange(
                    apiUrl,
                    HttpMethod.POST,
                    request,
                    String.class
            );

            // Parse the response body
            String responseBody = response.getBody();
            JsonNode rootNode = objectMapper.readTree(responseBody);

            if (rootNode.has("data")) {
                JsonNode dataNode = rootNode.get("data");

                // Extract fields from the response and DTO
                String referralId = dataNode.get("id").asText();
                String timestamp = dataNode.get("timestamp").asText();
                LocalDateTime createdOn = LocalDateTime.parse(timestamp); // Adjust parsing format if necessary
                String nrc = memberDetailsDTO.getNrc();

                PatientData pd = new PatientData();
                pd.setReferralId(referralId);
                //pd.setCreatedOn(createdOn);
                pd.setNrc(nrc);
                //pd.setCreatedBy(-1);

                patientDao.create(pd);




                log.info("Patient saved successfully.");
            } else {
                System.out.println("No 'data' field found in the response.");
            }


//            if (rootNode.has("data")) {
//                JsonNode dataNode = rootNode.get("data");
//                System.out.println("Data: " + dataNode.toString());
//            } else {
//                System.out.println("No 'data' field found in the response.");
//            }

        } catch (Exception ex) {
            // Handle errors gracefully
            System.err.println("Error while calling API: " + ex.getMessage());
        }


    }

    @Override
    @Scheduled(fixedDelay = 1000*60*5)
    public void getPatientStatus()
    {
        ObjectMapper objectMapper = new ObjectMapper();

        String apiUrl = "http://10.52.45.59:8080/api/v1/patient/";
        //String accessToken = "eyJhbGciOiJIUzUxMiJ9.eyJwZXJtaXNzaW9ucyI6WyJHRVRfUEFUSUVOVF9TVEFUVVMiLCJQT1NUX1JFRkVSUkFMIiwiUE9TVF9QQVRJRU5UIiwiR0VUX1JFRkVSUkFMX1NUQVRVUyIsIlNVQlNDUklCRSJdLCJzdWIiOiJzeXN0ZW1AZW1haWwuY28uem0iLCJpYXQiOjE3NDc4MTQxODMsImV4cCI6MTc0Nzg0Mjk4M30.Fds9VvnCoUavO6877zlUfnyxaECDEvNrVKwvlhSoZgKh9m6qi2VMJiXT3iJdHoR06lCp-Ji4E1YylMr2hyxdnw"; // Replace with the actual token

        try {
            if (isTokenExpired()) {
                fetchNewAccessToken(); // Refresh the token if expired
            }
            List<ReferralNrcDTO> requestIdList = patientDao.getPatientId();

            HttpHeaders headers = new HttpHeaders();
            headers.set("Content-Type", "application/json");
            headers.set("Authorization", "Bearer " + accessToken);
            headers.set("x-msg-format", "json");

            HttpEntity<Void> requestEntity = new HttpEntity<>(headers);

            for (ReferralNrcDTO request : requestIdList) {
                String requestId = request.getReferralId();

                StringBuilder urlBuilder = new StringBuilder(apiUrl);
                urlBuilder.append(requestId);

                String finalUrl = urlBuilder.toString();

                try {
                    ResponseEntity<String> response = restTemplate.exchange(
                            finalUrl,
                            HttpMethod.GET,
                            requestEntity,
                            String.class
                    );

                    // Check response validity
                    if (response != null && response.getBody() != null) {
                        String responseBody = response.getBody();

                        JsonNode rootNode = objectMapper.readTree(responseBody);
                        JsonNode dataNode = rootNode.path("data");

                        // Check if "data" exists and contains "nupn"
                        if (dataNode != null && dataNode.has("data")) {
                            JsonNode innerDataNode = dataNode.path("data");
                            String retrievedRequestId = dataNode.path("requestId").asText();

                            if (innerDataNode != null && innerDataNode.has("nupn")) {

                                String nupn = innerDataNode.path("nupn").asText();
                                String nrc = innerDataNode.path("nrc").asText();
                                log.info("Extracted nupn: {}", nupn);
                                patientDao.setNUPN(nupn,nrc);
                                patientDao.deleteReferralId(retrievedRequestId);

                                // Additional processing with nupn if needed
                            } else {
                                log.warn("'nupn' field is missing in 'data' for request: {}", requestId);
                                patientDao.updateSyncDate(retrievedRequestId);
                                log.info("Processed Request ID: {}", requestId);
                            }
                        } else {
                            log.warn("'data' node is empty or missing for request: {}", requestId);
                        }

                        // Optionally, update the sync date

                    } else {
                        log.warn("Empty or null response for request: {}", requestId);
                    }
                } catch (Exception e) {
                    log.error("Error processing request ID: {}", requestId, e);
                }
            }
        } catch (Exception e) {
            log.error("Error fetching patient IDs", e);
        }

    }

    @Override
    public  void createReferral(ReferralDTO referralDTO){
        ObjectMapper objectMapper = new ObjectMapper();
        String apiUrl = "http://10.52.45.59:8080/api/v1/referral";
        //String accessToken = "eyJhbGciOiJIUzUxMiJ9.eyJwZXJtaXNzaW9ucyI6WyJHRVRfUEFUSUVOVF9TVEFUVVMiLCJQT1NUX1JFRkVSUkFMIiwiUE9TVF9QQVRJRU5UIiwiR0VUX1JFRkVSUkFMX1NUQVRVUyIsIlNVQlNDUklCRSJdLCJzdWIiOiJzeXN0ZW1AZW1haWwuY28uem0iLCJpYXQiOjE3NDc4MTQxODMsImV4cCI6MTc0Nzg0Mjk4M30.Fds9VvnCoUavO6877zlUfnyxaECDEvNrVKwvlhSoZgKh9m6qi2VMJiXT3iJdHoR06lCp-Ji4E1YylMr2hyxdnw";

        try {
            if (isTokenExpired()) {
                fetchNewAccessToken(); // Refresh the token if expired
            }
            HttpHeaders headers = new HttpHeaders();
            headers.set("Content-Type", "application/json");
            headers.set("Authorization", "Bearer " + accessToken);
            headers.set("x-msg-format", "json");

            HttpEntity<ReferralDTO> request = new HttpEntity<>(referralDTO, headers);

            ResponseEntity<String> response = restTemplate.exchange(
                    apiUrl,
                    HttpMethod.POST,
                    request,
                    String.class
            );
            String responseBody = response.getBody();
            log.info(responseBody);
            JsonNode rootNode = objectMapper.readTree(responseBody);

            if (rootNode.has("data")) {
                JsonNode dataNode = rootNode.get("data");
                String referralId = dataNode.get("id").asText();
                ReferralData rd = new ReferralData();
                rd.setReferralId(referralId);
                rd.setClientNUPN(referralDTO.getNupn());
                referralDao.create(rd);
                log.info("Referral saved successfully.");
                System.out.println("Data: " + dataNode.toString());
            } else {
                System.out.println("No 'data' field found in the response.");
            }

        } catch (Exception ex) {
            log.warn("Error while calling API: " + ex.getMessage());
        }
    }
    @Override
    //@Scheduled(fixedDelay = 1000*60)
    public void getReferralStatus(){
        String apiUrl = "http://10.52.45.59:8080/api/v1/referral/{statusId}";
        ObjectMapper objectMapper = new ObjectMapper();
        try {
            if (isTokenExpired()) {
                fetchNewAccessToken(); // Refresh the token if expired
            }
            List<ReferralNupnDTO>requestIdList = referralDao.getReferredIds();
            HttpHeaders headers = new HttpHeaders();
            headers.set("Content-Type", "application/json");
            headers.set("Authorization", "Bearer " + accessToken);
            headers.set("x-msg-format", "json");

            HttpEntity<Void> requestEntity = new HttpEntity<>(headers);
            for (ReferralNupnDTO request : requestIdList) {
                String requestId = request.getReferralId();

                try {
                    ResponseEntity<String> response = restTemplate.exchange(
                            apiUrl,
                            HttpMethod.GET,
                            requestEntity,
                            String.class,
                            requestId
                    );

                    if (response != null && response.getBody() != null) {
                        String responseBody = response.getBody();

                        // Parse the response JSON
                        JsonNode rootNode = objectMapper.readTree(responseBody);
                        JsonNode dataNode = rootNode.path("data");

                        if (dataNode != null && dataNode.has("requestId")) {
                            String retrievedRequestId = dataNode.path("requestId").asText();
                            referralDao.updateSyncDate(retrievedRequestId);
                        } else {
                            System.err.println("Missing 'requestId' in response data for request: " + requestId);
                        }
                    } else {
                        System.err.println("Received empty or null response for request: " + requestId);
                    }
                } catch (Exception e) {
//                    System.err.println("Error processing request ID: " + requestId);
                    e.printStackTrace();
                }
            }

        } catch (Exception e) {
            e.printStackTrace();

        }
    }

    @Override
    @Scheduled(fixedDelay = 1000 * 60 * 60 * 24)
    public void getPatientsFromImt(){
        try {
            List<MemberDetailsDTO> members = patientDao.getPatientsFromImt();
            for (MemberDetailsDTO member : members) {
                createPatient(member);
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    //@Scheduled(fixedDelay = 1000*60)
    public void getStoredReferrals()
    {
        try {
            List<StoredReferralDTO> referrals = referralDao.getStoredReferredPatinets();
            for (StoredReferralDTO referral : referrals) {
                ReferralDTO newReferral = getReferralDTO(referral);
                createReferral(newReferral);
                referralDao.updateStoredReferral(referral.getId());
            }

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @NotNull
    private static ReferralDTO getReferralDTO(StoredReferralDTO referral) {
        ReferralDTO newReferral = new ReferralDTO();
        newReferral.setNupn(referral.getNupn());
        newReferral.setReferralType(referral.getReferralType());
        newReferral.setAdditionalComments(referral.getAdditionalComments());
        newReferral.setProvince(referral.getProvince());
        newReferral.setDistrict(referral.getDistrict());
        newReferral.setReasonForReferral(referral.getReasonForReferral());
        newReferral.setFacility(referral.getFacility());
        return newReferral;
    }

    private boolean isTokenExpired() {
        if (accessToken.isEmpty()) {
            return true; // If no token, assume expired
        }

        try {

            String[] parts = accessToken.split("\\.");
            if (parts.length != 3) {
                throw new IllegalArgumentException("Invalid JWT token format.");
            }

            String payload = new String(Base64.getUrlDecoder().decode(parts[1]));
            ObjectMapper objectMapper = new ObjectMapper();
            JsonNode payloadJson = objectMapper.readTree(payload);

            if (payloadJson.has("exp")) {
                long exp = payloadJson.get("exp").asLong();
                Date expiryDate = new Date(exp * 1000);
                return expiryDate.before(new Date());
            } else {
                throw new IllegalArgumentException("JWT token does not contain 'exp' claim.");
            }

        } catch (Exception e) {
            System.err.println("Error parsing token: " + e.getMessage());
            return true;
        }
    }

    private void fetchNewAccessToken() {
        ObjectMapper objectMapper = new ObjectMapper();
        try {
            String authUrl = "http://102.23.120.12:8080/api/v1/auth/login";
            HttpHeaders headers = new HttpHeaders();
            headers.set("Content-Type", "application/json");

            SystemConfiguration scproUserName =  systemConfigurationDao.retrieveSystemConfigurationByKey("SCPRO_USERNAME");
            SystemConfiguration scproPassword =  systemConfigurationDao.retrieveSystemConfigurationByKey("SCPRO_PASSWORD");

            Map<String, String> credentials = Map.of(
                    "username", scproUserName.getKeyValue(),
                    "password", scproPassword.getKeyValue()
            );

            HttpEntity<Map<String, String>> request = new HttpEntity<>(credentials, headers);
            ResponseEntity<String> response = restTemplate.postForEntity(authUrl, request, String.class);

            JsonNode rootNode = objectMapper.readTree(response.getBody());
            if (rootNode.has("data")) {
                JsonNode dataNode = rootNode.get("data");
                if (dataNode.has("accessToken")) {
                    accessToken = dataNode.get("accessToken").asText();
                    System.out.println("New access token fetched successfully: " + accessToken);
                } else {
                    throw new RuntimeException("Failed to fetch access token: Missing accessToken field in data.");
                }
            } else {
                throw new RuntimeException("Failed to fetch access token: Missing data field.");
            }

        } catch (Exception e) {
            throw new RuntimeException("Error fetching new access token: " + e.getMessage());
        }
    }
}
