package com.argusoft.imtecho.scpro.service.Impl;

import com.argusoft.imtecho.scpro.dao.PatientDao;
import com.argusoft.imtecho.scpro.dao.ReferralDao;
import com.argusoft.imtecho.scpro.dto.MemberDetailsDTO;
import com.argusoft.imtecho.scpro.dto.ReferralDTO;
import com.argusoft.imtecho.scpro.dto.ReferralNrcDTO;
import com.argusoft.imtecho.scpro.dto.ReferralNupnDTO;
import com.argusoft.imtecho.scpro.model.PatientData;
import com.argusoft.imtecho.scpro.model.ReferralData;
import com.argusoft.imtecho.scpro.service.CreatePatientService;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
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
import java.util.List;

@Slf4j
@Service
@Transactional
public class CreatePatientServiceImpl implements CreatePatientService {

    private final RestTemplate restTemplate;

    @Autowired
    PatientDao patientDao;
    @Autowired
    ReferralDao referralDao;
    public CreatePatientServiceImpl(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }


    @Override
    public void createPatient(MemberDetailsDTO memberDetailsDTO){
        ObjectMapper objectMapper = new ObjectMapper();

        String apiUrl = "http://102.23.120.12:8080/api/v1/patient";
        String accessToken = "eyJhbGciOiJIUzUxMiJ9.eyJwZXJtaXNzaW9ucyI6WyJHRVRfUEFUSUVOVF9TVEFUVVMiLCJQT1NUX1JFRkVSUkFMIiwiUE9TVF9QQVRJRU5UIiwiR0VUX1JFRkVSUkFMX1NUQVRVUyIsIlNVQlNDUklCRSJdLCJzdWIiOiJzeXN0ZW1AZW1haWwuY28uem0iLCJpYXQiOjE3NDYxNzcyMDEsImV4cCI6MTc0NjIwNjAwMX0.g1cciFeYpR5QAP2eaQa2kWYuOFT2QUNTk-lqqaQb-NPDXCMxUErjAYeYbSYXeTFF3fiy9PBzKxzd2ZpQXfNFtw";

        try {
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
    @Scheduled(fixedDelay = 1000*60)
    public void getPatientStatus()
    {
        ObjectMapper objectMapper = new ObjectMapper();

        String apiUrl = "http://102.23.120.12:8080/api/v1/patient/";
        String accessToken = "eyJhbGciOiJIUzUxMiJ9.eyJwZXJtaXNzaW9ucyI6WyJHRVRfUEFUSUVOVF9TVEFUVVMiLCJQT1NUX1JFRkVSUkFMIiwiUE9TVF9QQVRJRU5UIiwiR0VUX1JFRkVSUkFMX1NUQVRVUyIsIlNVQlNDUklCRSJdLCJzdWIiOiJzeXN0ZW1AZW1haWwuY28uem0iLCJpYXQiOjE3NDYxNzcyMDEsImV4cCI6MTc0NjIwNjAwMX0.g1cciFeYpR5QAP2eaQa2kWYuOFT2QUNTk-lqqaQb-NPDXCMxUErjAYeYbSYXeTFF3fiy9PBzKxzd2ZpQXfNFtw"; // Replace with the actual token

        try {
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
        String apiUrl = "http://102.23.120.12:8080/api/v1/referral";
        String accessToken = "eyJhbGciOiJIUzUxMiJ9.eyJwZXJtaXNzaW9ucyI6WyJHRVRfUEFUSUVOVF9TVEFUVVMiLCJQT1NUX1JFRkVSUkFMIiwiUE9TVF9QQVRJRU5UIiwiR0VUX1JFRkVSUkFMX1NUQVRVUyIsIlNVQlNDUklCRSJdLCJzdWIiOiJzeXN0ZW1AZW1haWwuY28uem0iLCJpYXQiOjE3NDY0MjEyODQsImV4cCI6MTc0NjQ1MDA4NH0.mlYBPejpYxcjtmTeqxH8K9idrYuDA3mqsjCPTnzLG-CPEkxcXYNuqD-H0p7HfmvoPMkLqKi044s2CsxraJLH4Q";

        try {
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
    @Scheduled(fixedDelay = 1000*60)
    public void getReferralStatus(){
        String apiUrl = "http://102.23.120.12:8080/api/v1/referral/{statusId}";
        String accessToken = "eyJhbGciOiJIUzUxMiJ9.eyJwZXJtaXNzaW9ucyI6WyJHRVRfUEFUSUVOVF9TVEFUVVMiLCJQT1NUX1JFRkVSUkFMIiwiUE9TVF9QQVRJRU5UIiwiR0VUX1JFRkVSUkFMX1NUQVRVUyIsIlNVQlNDUklCRSJdLCJzdWIiOiJzeXN0ZW1AZW1haWwuY28uem0iLCJpYXQiOjE3NDY0MjEyODQsImV4cCI6MTc0NjQ1MDA4NH0.mlYBPejpYxcjtmTeqxH8K9idrYuDA3mqsjCPTnzLG-CPEkxcXYNuqD-H0p7HfmvoPMkLqKi044s2CsxraJLH4Q"; // Replace with the actual token
        ObjectMapper objectMapper = new ObjectMapper();
        try {
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

                            System.out.println(responseBody);
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
    public void getPatientsFromImt(){
        try {
            List<MemberDetailsDTO> members= patientDao.getPatientsFromImt();
            for(int i=0;i<members.size();i++)
            {
                createPatient(members.get(i));
            }
            log.info("Patiens created");
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
