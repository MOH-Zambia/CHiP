package com.argusoft.imtecho.chip.service;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;

import java.util.Map;

public interface HouseHoldLineListService {

    Map<String, String> storeHouseHoldLineListForm(ParsedRecordBean parsedRecordBean, UserMaster user);

}
