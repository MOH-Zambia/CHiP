package com.argusoft.imtecho.common.service;

import com.argusoft.imtecho.common.model.UserHealthInfrastructure;

import java.util.List;

public interface UserHealthInfrastructureService {

    List<UserHealthInfrastructure> retrieveByUserId(Integer userId, Long modifiedOn);

}
