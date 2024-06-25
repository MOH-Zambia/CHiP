package com.argusoft.imtecho.rch.service;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.fhs.dto.MemberDto;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;

import java.util.List;
import java.util.Map;

public interface AdolescentHealthScreeningService {
    Integer storeQuestionSetAnswerForMobile(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap);
    public List<MemberDto> getMembersOfSchool(Long schoolActualId, Integer standard);
    public List<MemberDto> getMembersByAdvanceSearch(Integer parentId, String searchText, Integer standard);
}
