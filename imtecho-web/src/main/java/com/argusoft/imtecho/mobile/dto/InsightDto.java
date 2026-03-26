package com.argusoft.imtecho.mobile.dto;

public class InsightDto {

    private String title;
    private String description;
    private String severity;
    private String healthProgram;
    private String actionLabel;

    public InsightDto() {
    }

    public InsightDto(String title, String description, String severity, String healthProgram, String actionLabel) {
        this.title = title;
        this.description = description;
        this.severity = severity;
        this.healthProgram = healthProgram;
        this.actionLabel = actionLabel;
    }

    public InsightDto(String couldNotLoadInsights, String s, String medium, String system) {
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getSeverity() {
        return severity;
    }

    public void setSeverity(String severity) {
        this.severity = severity;
    }

    public String getHealthProgram() {
        return healthProgram;
    }

    public void setHealthProgram(String healthProgram) {
        this.healthProgram = healthProgram;
    }
    public String getActionLabel() { return actionLabel; }
    public void setActionLabel(String actionLabel) { this.actionLabel = actionLabel; }

}
