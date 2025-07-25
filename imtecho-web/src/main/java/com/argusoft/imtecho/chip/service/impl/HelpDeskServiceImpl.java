package com.argusoft.imtecho.chip.service.impl;

import com.argusoft.imtecho.chip.dao.HelpDeskDao;
import com.argusoft.imtecho.chip.model.HelpDeskEntity;
import com.argusoft.imtecho.chip.service.HelpDeskService;
import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

@Service
@Transactional
public class HelpDeskServiceImpl implements HelpDeskService {

    @Autowired
    HelpDeskDao helpDeskDao;

    @Override
    public Integer storeHelpDeskForm(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap) {
        HelpDeskEntity helpDeskEntity = new HelpDeskEntity();
        helpDeskEntity.setUserId(user.getId());
        for (Map.Entry<String, String> entrySet : keyAndAnswerMap.entrySet()) {
            String key = entrySet.getKey();
            String answer = entrySet.getValue();
            this.setAnswerToDB(key, answer, helpDeskEntity);
        }
        helpDeskDao.create(helpDeskEntity);
        return helpDeskEntity.getId();
    }

    @Override
    public void updateRecord(String status, Integer recordId) {
        HelpDeskEntity helpDeskEntity = helpDeskDao.retrieveById(recordId);
        helpDeskEntity.setStatus(status);
        helpDeskDao.createOrUpdate(helpDeskEntity);
    }

    private void setAnswerToDB(String key, String answer, HelpDeskEntity helpDeskEntity) {
        switch (key) {
            case "2":
                helpDeskEntity.setModuleType(answer);
                break;
            case "7":
                helpDeskEntity.setIssueType(answer);
                break;
            case "3":
                helpDeskEntity.setIssueDesc(answer);
                break;
            case "4":
                helpDeskEntity.setOtherDesc(answer);
                break;
            default:
                break;
        }
    }
}
