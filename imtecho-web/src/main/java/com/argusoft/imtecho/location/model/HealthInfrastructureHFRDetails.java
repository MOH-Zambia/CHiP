package com.argusoft.imtecho.location.model;

import lombok.Data;

import java.util.List;

@Data
public class HealthInfrastructureHFRDetails {

    private String locationName;
    private HealthInfrastructureDetails healthInfrastructureDetails;
    private List<String> diagnosticServices;

}
