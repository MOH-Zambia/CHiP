package com.argusoft.imtecho.mobile.service;

import com.argusoft.imtecho.mobile.dto.FamilyDataBean;
import com.argusoft.imtecho.mobile.dto.LogInRequestParamDetailDto;
import com.argusoft.imtecho.mobile.dto.LoggedInUserPrincipleDto;

import java.util.List;

/**
 *
 * @author prateek on Jul 11, 2019
 */
public interface MobileFhsrService {

    LoggedInUserPrincipleDto getDetailsForFhsr(LogInRequestParamDetailDto paramDetailDto, Integer apkVersion);

    List<FamilyDataBean> retrieveAssignedFamiliesByLocationId(LogInRequestParamDetailDto logInRequestParamDetailDto);
}
