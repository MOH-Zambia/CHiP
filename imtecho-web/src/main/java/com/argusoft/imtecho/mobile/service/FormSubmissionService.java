/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.mobile.service;

import com.argusoft.imtecho.mobile.dto.RecordStatusBean;

import java.util.HashMap;
import java.util.List;
import java.util.Set;

/**
 *
 * @author prateek
 */
public interface FormSubmissionService {

    RecordStatusBean[] recordsEntryFromMobileToDBServer(String token, String[] records);


}
