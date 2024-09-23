package com.argusoft.imtecho.formconfigurator.service;

public interface MedplatFormDataService {

    Integer dumpFormData(String formCode, String data);

    void saveFormData(String formCode, String data, Integer masterId);
}
