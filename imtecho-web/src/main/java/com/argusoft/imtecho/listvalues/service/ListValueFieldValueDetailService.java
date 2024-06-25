package com.argusoft.imtecho.listvalues.service;

public interface ListValueFieldValueDetailService {

    /**
     * Retrieves list value field value details.
     *
     * @param id Id of list value field value.
     * @return Returns result of list value field value.
     */
    String retrieveValueFromId(Integer id);

    Integer retrieveIdOfListValueByConstant(String constant);
}