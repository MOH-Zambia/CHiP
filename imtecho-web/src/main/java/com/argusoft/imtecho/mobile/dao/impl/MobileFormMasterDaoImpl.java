package com.argusoft.imtecho.mobile.dao.impl;

import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.mobile.dao.MobileFormMasterDao;
import com.argusoft.imtecho.mobile.dto.ComponentTagDto;
import com.argusoft.imtecho.mobile.model.MobileFormMaster;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.hibernate.type.StandardBasicTypes;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class MobileFormMasterDaoImpl extends GenericDaoImpl<MobileFormMaster, Integer> implements MobileFormMasterDao {

    @Override
    public List<ComponentTagDto> retrieveComponentTagDtoBySheet(String sheet) {
        String query = "select mfm.id, mfm.title, mfm.subtitle, mfm.instruction, mfm.question, mfm.\"type\", \n" +
                "mfm.is_mandatory as \"ismandatory\", mfm.mandatory_message as \"mandatorymessage\",\n" +
                "mfm.\"length\", mfm.validation as \"validations\", mfm.formula as \"formulas\", mfm.datamap, mfm.\"options\", \n" +
                "mfm.\"next\", mfm.subform, mfm.related_property_name as \"relatedpropertyname\", mfm.is_hidden as \"ishidden\", mfm.\"event\", \n" +
                "mfm.binding, mfm.page, mfm.hint, mfm.help_video as \"helpvideofield\", mfm.\"row\" \n" +
                "from mobile_form_master mfm\n" +
                "where form_code = :sheet\n" +
                "order by mfm.form_code, mfm.\"row\"";

        SQLQuery sqlQuery = getCurrentSession().createSQLQuery(query)
                .addScalar("id", StandardBasicTypes.INTEGER)
                .addScalar("title", StandardBasicTypes.STRING)
                .addScalar("subtitle", StandardBasicTypes.STRING)
                .addScalar("instruction", StandardBasicTypes.STRING)
                .addScalar("question", StandardBasicTypes.STRING)
                .addScalar("type", StandardBasicTypes.STRING)
                .addScalar("ismandatory", StandardBasicTypes.STRING)
                .addScalar("mandatorymessage", StandardBasicTypes.STRING)
                .addScalar("length", StandardBasicTypes.INTEGER)
                .addScalar("validations", StandardBasicTypes.STRING)
                .addScalar("formulas", StandardBasicTypes.STRING)
                .addScalar("datamap", StandardBasicTypes.STRING)
                .addScalar("options", StandardBasicTypes.STRING)
                .addScalar("next", StandardBasicTypes.STRING)
                .addScalar("subform", StandardBasicTypes.STRING)
                .addScalar("relatedpropertyname", StandardBasicTypes.STRING)
                .addScalar("ishidden", StandardBasicTypes.STRING)
                .addScalar("event", StandardBasicTypes.STRING)
                .addScalar("binding", StandardBasicTypes.STRING)
                .addScalar("page", StandardBasicTypes.STRING)
                .addScalar("hint", StandardBasicTypes.STRING)
                .addScalar("helpvideofield", StandardBasicTypes.STRING)
                .addScalar("row", StandardBasicTypes.INTEGER);
        sqlQuery.setParameter("sheet", sheet);

        return (List<ComponentTagDto>) sqlQuery.setResultTransformer(Transformers.aliasToBean(ComponentTagDto.class)).list();
    }
}
