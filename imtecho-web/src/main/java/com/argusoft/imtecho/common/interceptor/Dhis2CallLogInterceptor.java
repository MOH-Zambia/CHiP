package com.argusoft.imtecho.common.interceptor;

import com.argusoft.imtecho.common.dao.Dhis2Dao;
import com.argusoft.imtecho.common.model.Dhis2CallLog;
import com.argusoft.imtecho.exception.ImtechoSystemException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.client.ClientHttpRequestExecution;
import org.springframework.http.client.ClientHttpRequestInterceptor;
import org.springframework.http.client.ClientHttpResponse;
import org.springframework.scheduling.annotation.Async;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.ResourceAccessException;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Date;

public class Dhis2CallLogInterceptor implements ClientHttpRequestInterceptor {

    private static final Logger log = LoggerFactory.getLogger(Dhis2CallLogInterceptor.class);
    private final Dhis2Dao dhis2Dao;
    private final Date month;

    public Dhis2CallLogInterceptor(Dhis2Dao dhis2Dao, Date month) {
        this.dhis2Dao = dhis2Dao;
        this.month = month;
    }

    @Async
    @Transactional(noRollbackFor = ImtechoSystemException.class)
    public void saveCallLog(String requestBody,String responseBody,Integer httpStatus, Date month) {
        Dhis2CallLog dhis2CallLog = new Dhis2CallLog();
        dhis2CallLog.setRequestBody(requestBody);
        dhis2CallLog.setResponseBody(responseBody);
        dhis2CallLog.setCreatedOn(new Date());
        dhis2CallLog.setHttpStatus(httpStatus);
        dhis2CallLog.setMonth(month);
        dhis2Dao.create(dhis2CallLog);
        dhis2Dao.flush();
    }

    @Override
    public ClientHttpResponse intercept(HttpRequest request, byte[] body, ClientHttpRequestExecution execution) {
        ClientHttpResponse response;
        log.info("Dhis2 Request body: {} => {}", new String(body, StandardCharsets.UTF_8), request.getURI());

        try {
            response = execution.execute(request, body);
            saveCallLog(new String(body, StandardCharsets.UTF_8), new String(response.getBody().readAllBytes(), StandardCharsets.UTF_8), response.getStatusCode().value(), month);
            return response;

        }
        catch (ResourceAccessException | HttpClientErrorException | IOException | HttpServerErrorException e) {
            saveCallLog(new String(body, StandardCharsets.UTF_8), e.getLocalizedMessage() , HttpStatus.BAD_REQUEST.value(), month);
            throw new ImtechoSystemException("Error! Might be a client or server error caught!", e);
        }
    }

}
