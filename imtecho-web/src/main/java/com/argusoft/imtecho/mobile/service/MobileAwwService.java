package com.argusoft.imtecho.mobile.service;

import com.argusoft.imtecho.mobile.dto.LogInRequestParamDetailDto;
import com.argusoft.imtecho.mobile.dto.LoggedInUserPrincipleDto;

public interface MobileAwwService {

    LoggedInUserPrincipleDto getDetails(LogInRequestParamDetailDto paramDetailDto, Integer apkVersion);
}
