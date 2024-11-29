package com.argusoft.imtecho.scpro.service.Impl;

import com.argusoft.imtecho.scpro.dao.PatientDao;
import com.argusoft.imtecho.scpro.dto.MemberDetailsDTO;
import com.argusoft.imtecho.scpro.dto.ReferralDTO;
import com.argusoft.imtecho.scpro.dto.ReferralNrcDTO;
import com.argusoft.imtecho.scpro.model.PatientData;
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
    public CreatePatientServiceImpl(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }


    @Override
    public void createPatient(MemberDetailsDTO memberDetailsDTO){
        ObjectMapper objectMapper = new ObjectMapper();

        String apiUrl = "http://102.23.120.12:8080/api/v1/patient";
        String accessToken = "eyJhbGciOiJIUzUxMiJ9.eyJwZXJtaXNzaW9ucyI6WyJQT1NUX1JFRkVSUkFMIiwiR0VUX1BBVElFTlRfU1RBVFVTIiwiVVBEQVRFX1VTRVIiLCJQT1NUX1BBVElFTlQiLCJHRVRfUkVGRVJSQUxfU1RBVFVTIiwiR0VUX1VTRVIiXSwic3ViIjoic3lzdGVtQGVtYWlsLmNvLnptIiwiaWF0IjoxNzMyNTk4MzczLCJleHAiOjE3MzI2MjcxNzN9.nc0Y1QO5HCkQkZUmOUWEqFSHqtnWA6ZIdjYZNG6xfFdKgX6joUdf-cvIwYFHmy6OupEgycsgVhE9Im-xv2g1yg";

        try {
            HttpHeaders headers = new HttpHeaders();
            headers.set("Content-Type", "application/json");
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




                log.info("Referral saved successfully.");
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

        String apiUrl = "http://102.23.120.12:8080/api/v1/patient/status/{statusId}";
        String accessToken = "eyJhbGciOiJIUzUxMiJ9.eyJwZXJtaXNzaW9ucyI6WyJQT1NUX1JFRkVSUkFMIiwiR0VUX1BBVElFTlRfU1RBVFVTIiwiVVBEQVRFX1VTRVIiLCJQT1NUX1BBVElFTlQiLCJHRVRfUkVGRVJSQUxfU1RBVFVTIiwiR0VUX1VTRVIiXSwic3ViIjoic3lzdGVtQGVtYWlsLmNvLnptIiwiaWF0IjoxNzMyNTk4MzczLCJleHAiOjE3MzI2MjcxNzN9.nc0Y1QO5HCkQkZUmOUWEqFSHqtnWA6ZIdjYZNG6xfFdKgX6joUdf-cvIwYFHmy6OupEgycsgVhE9Im-xv2g1yg"; // Replace with the actual token

        try {
            // Set up headers
           List<ReferralNrcDTO> requestIdList = patientDao.getPatientId();

            HttpHeaders headers = new HttpHeaders();
            headers.setBearerAuth(accessToken);

            HttpEntity<Void> requestEntity = new HttpEntity<>(headers);

            // Call the API with the provided statusId
            for(int i=0;i<requestIdList.size();i++)
            {
                String requestId = requestIdList.get(i).getReferralId();

                ResponseEntity<String> response = restTemplate.exchange(
                        apiUrl,
                        HttpMethod.GET,
                        requestEntity,
                        String.class,
                        requestId // Pass the statusId as a path variable
                );

                // Return the response body
                String responseBody = response.getBody();
//                ObjectMapper objectMapper = new ObjectMapper();
                JsonNode rootNode = objectMapper.readTree(responseBody);

                JsonNode dataNode = rootNode.path("data");

                String retreivedRequestId = dataNode.path("requestId").asText();
                patientDao.updateSyncDate(retreivedRequestId);

                log.info(requestId);
//               JsonNode rootNode = objectMapper.readTree(responseBody);

//                if (rootNode.has("data")) {
//                    JsonNode dataNode = rootNode.get("data");
//                    patientDao.setNUPN("1234567",requestIdList.get(i).getNrc());
//                    if(String.valueOf(dataNode.get("data"))==null)
//                    {
//                        //patientDao.setNUPN("1234567",requestIdList.get(i).getNrc());
//                    }
////                    log.info();
//                }

            }


        } catch (Exception e) {
            // Handle errors gracefully
            e.printStackTrace();

        }
    }

    @Override
    public  void createReferral(ReferralDTO referralDTO){
        ObjectMapper objectMapper = new ObjectMapper();
        String apiUrl = "http://102.23.120.12:8080/api/v1/referral";
        String accessToken = "eyJhbGciOiJIUzUxMiJ9.eyJwZXJtaXNzaW9ucyI6WyJQT1NUX1JFRkVSUkFMIiwiR0VUX1BBVElFTlRfU1RBVFVTIiwiVVBEQVRFX1VTRVIiLCJQT1NUX1BBVElFTlQiLCJHRVRfUkVGRVJSQUxfU1RBVFVTIiwiR0VUX1VTRVIiXSwic3ViIjoic3lzdGVtQGVtYWlsLmNvLnptIiwiaWF0IjoxNzMyMTgzNDc2LCJleHAiOjE3MzIyMTIyNzZ9.u8-Wi4BmRAix0CxUw_iKupkINSvTKXvpqUtgDdHLso8nBM6RgzLZWAo0_RzwVJkZ47H9NyNY-ls6F5iNHe6wqA";

        try {
            HttpHeaders headers = new HttpHeaders();
            headers.set("Content-Type", "application/json");
            headers.set("Authorization", "Bearer " + accessToken);

            HttpEntity<ReferralDTO> request = new HttpEntity<>(referralDTO, headers);

            ResponseEntity<String> response = restTemplate.exchange(
                    apiUrl,
                    HttpMethod.POST,
                    request,
                    String.class
            );
            String responseBody = response.getBody();
            JsonNode rootNode = objectMapper.readTree(responseBody);

            if (rootNode.has("data")) {
                JsonNode dataNode = rootNode.get("data");
                System.out.println("Data: " + dataNode.toString());
            } else {
                System.out.println("No 'data' field found in the response.");
            }

//            System.out.println("API Response: " + response.getBody());
        } catch (Exception ex) {
            // Handle errors gracefully
            System.err.println("Error while calling API: " + ex.getMessage());
        }
    }
    @Override
    public void getReferralStatus( String requestId){
        String apiUrl = "http://102.23.120.12:8080/api/v1/referral/status/{statusId}";
        String accessToken = "eyJhbGciOiJIUzUxMiJ9.eyJwZXJtaXNzaW9ucyI6WyJQT1NUX1JFRkVSUkFMIiwiR0VUX1BBVElFTlRfU1RBVFVTIiwiVVBEQVRFX1VTRVIiLCJQT1NUX1BBVElFTlQiLCJHRVRfUkVGRVJSQUxfU1RBVFVTIiwiR0VUX1VTRVIiXSwic3ViIjoic3lzdGVtQGVtYWlsLmNvLnptIiwiaWF0IjoxNzMyMjU1NTg0LCJleHAiOjE3MzIyODQzODR9.q6Z57O6ZmOQ7GmoXrf8eTgFHTHj8BH4Unsg44nxBBy_d-9j8TeI4yg3hP6cIWfT9_ST1jS_bnTu3TiQfbShc6g"; // Replace with the actual token

        try {
            // Set up headers
            HttpHeaders headers = new HttpHeaders();
            headers.setBearerAuth(accessToken);

            HttpEntity<Void> requestEntity = new HttpEntity<>(headers);

            // Call the API with the provided statusId
            ResponseEntity<String> response = restTemplate.exchange(
                    apiUrl,
                    HttpMethod.GET,
                    requestEntity,
                    String.class,
                    requestId // Pass the statusId as a path variable
            );

            // Return the response body
            System.out.println(response.getBody());

        } catch (Exception e) {
            // Handle errors gracefully
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
