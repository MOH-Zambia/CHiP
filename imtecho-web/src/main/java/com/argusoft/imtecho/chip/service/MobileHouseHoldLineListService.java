package com.argusoft.imtecho.chip.service;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.fhs.model.MemberEntity;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;

import java.util.Map;

public interface MobileHouseHoldLineListService {
    Map<String, String> storeHouseHoldLineListForm(ParsedRecordBean parsedRecordBean, UserMaster user);
    Map<String, String> storeMemberUpdateFormZambia(ParsedRecordBean parsedRecordBean, UserMaster user);
    MemberEntity retrieveMemberByUuid(String uuid);
}

