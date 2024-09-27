package com.argusoft.imtecho.formconfigurator.dao.impl;

import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.exception.ImtechoUserException;
import com.argusoft.imtecho.formconfigurator.dao.MedplatFormMasterDao;
import com.argusoft.imtecho.formconfigurator.dto.MedplatFormMasterDto;
import com.argusoft.imtecho.formconfigurator.models.MedplatFormMaster;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.transform.Transformers;
import org.hibernate.type.StandardBasicTypes;
import org.springframework.stereotype.Repository;
import org.springframework.util.CollectionUtils;

import javax.persistence.criteria.Predicate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Repository
public class MedplatFormMasterDaoImpl extends GenericDaoImpl<MedplatFormMaster, UUID> implements MedplatFormMasterDao {
    @Override
    public List<MedplatFormMasterDto> getMedplatForms(Integer menuConfigId) {
        String query = "with forms_data as (\n" +
                "\tselect \n" +
                "\tmedplat_form_master.\"uuid\",\n" +
                "\tmedplat_form_master.form_name as \"formName\",\n" +
                "\tmedplat_form_master.form_code as \"formCode\",\n" +
                "\tmedplat_form_master.current_version as \"currentVersion\",\n" +
                "\tmedplat_form_master.menu_config_id as \"menuConfigId\",\n" +
                "\tmedplat_form_master.state,\n" +
                "\tmedplat_form_master.description,\n" +
                "\tmenu_config.menu_name as \"menuName\", \n" +
                "\tcast(array_agg(medplat_form_version_history.version) as text) as \"availableVersion\"  \n" +
                "\tfrom medplat_form_master \n" +
                "\tinner join menu_config on medplat_form_master.menu_config_id = menu_config.id\n" +
                "\tinner join medplat_form_version_history on medplat_form_master.uuid = medplat_form_version_history.form_master_uuid \n" +
                "\twhere medplat_form_master.state = 'ACTIVE'  group by 1,2,3,4,5,6,7,8\n" +
                "\torder by medplat_form_master.menu_config_id\n" +
                "), latest_modified_data as (\n" +
                "\tselect \n" +
                "\tmedplat_form_master.\"uuid\" as \"uuid2\",\n" +
                "\tmedplat_form_version_history.modified_by,\n" +
                "\tmedplat_form_version_history.modified_on\n" +
//                "\tconcat(concat_ws(' ', um_user.first_name, um_user.middle_name, um_user.last_name), '<br>',  '(', um_user.user_name, ')' ) as \"user\"\n" +
                "\tfrom medplat_form_master \n" +
                "\tinner join medplat_form_version_history on medplat_form_master.uuid = medplat_form_version_history.form_master_uuid \n" +
//                "\tinner join um_user on um_user.id = medplat_form_version_history.modified_by \n" +
                "\twhere medplat_form_master.state = 'ACTIVE' and medplat_form_version_history.version = 'DRAFT'\n" +
                ") select * from latest_modified_data inner join forms_data on latest_modified_data.uuid2 = forms_data.uuid ";

        if (menuConfigId != null) query += "where forms_data.\"menuConfigId\" = :menuConfigId\n";

        query += "order by forms_data.\"menuConfigId\" ;";

        Session session = sessionFactory.getCurrentSession();
        SQLQuery sqlQuery = session.createSQLQuery(query);

        if (menuConfigId != null) sqlQuery.setParameter("menuConfigId", menuConfigId);

        sqlQuery.addScalar("uuid", StandardBasicTypes.UUID_CHAR)
                .addScalar("formName", StandardBasicTypes.STRING)
                .addScalar("formCode", StandardBasicTypes.STRING)
                .addScalar("currentVersion", StandardBasicTypes.STRING)
                .addScalar("state", StandardBasicTypes.STRING)
                .addScalar("menuConfigId", StandardBasicTypes.INTEGER)
                .addScalar("menuName", StandardBasicTypes.STRING)
                .addScalar("availableVersion", StandardBasicTypes.STRING)
                .addScalar("description", StandardBasicTypes.STRING)
//                .addScalar("user", StandardBasicTypes.STRING)
                .addScalar("modified_by", StandardBasicTypes.INTEGER)
                .addScalar("modified_on", StandardBasicTypes.DATE)
                .setResultTransformer(Transformers.aliasToBean(MedplatFormMasterDto.class));

        return sqlQuery.list();
    }

    @Override
    public MedplatFormMasterDto getMedplatFormByUuid(UUID uuid) {
        String query = "select \n" +
                "medplat_form_master.\"uuid\",\n" +
                "medplat_form_master.form_name as \"formName\",\n" +
                "medplat_form_master.form_code as \"formCode\",\n" +
                "medplat_form_master.current_version as \"currentVersion\",\n" +
                "medplat_form_master.menu_config_id as \"menuConfigId\",\n" +
                "medplat_form_master.state,\n" +
                "medplat_form_master.description,\n" +
                "menu_config.menu_name as \"menuName\" \n" +
                "from medplat_form_master \n" +
                "inner join menu_config on medplat_form_master.menu_config_id = menu_config.id\n" +
                "where cast(medplat_form_master.uuid as text) = :uuid ;";

        Session session = sessionFactory.getCurrentSession();
        SQLQuery sqlQuery = session.createSQLQuery(query);

        sqlQuery.addScalar("uuid", StandardBasicTypes.UUID_CHAR)
                .addScalar("formName", StandardBasicTypes.STRING)
                .addScalar("formCode", StandardBasicTypes.STRING)
                .addScalar("currentVersion", StandardBasicTypes.STRING)
                .addScalar("state", StandardBasicTypes.STRING)
                .addScalar("menuConfigId", StandardBasicTypes.INTEGER)
                .addScalar("menuName", StandardBasicTypes.STRING)
                .addScalar("description", StandardBasicTypes.STRING)
                .setResultTransformer(Transformers.aliasToBean(MedplatFormMasterDto.class));

        return (MedplatFormMasterDto) sqlQuery.uniqueResult();
    }

    @Override
    public String getMedplatFormConfigByUuid(UUID uuid) {
        Session session = sessionFactory.getCurrentSession();
        String query = "select\n" +
                "    cast(json_build_object(\n" +
                "        'medplatFormMasterDto',\n" +
                "        json_build_object(\n" +
                "            'uuid',\n" +
                "            form.uuid,\n" +
                "            'formName',\n" +
                "            form.\"form_name\",\n" +
                "            'formCode',\n" +
                "            form.\"form_code\",\n" +
                "            'menuConfigId',\n" +
                "            form.\"menu_config_id\",\n" +
                "            'menuName',\n" +
                "            menu.menu_name,\n" +
                "            'state',\n" +
                "            form.\"state\",\n" +
                "            'createdBy',\n" +
                "            form.\"created_by\",\n" +
                "            'createdOn',\n" +
                "            form.\"created_on\",\n" +
                "            'currentVersion',\n" +
                "            form.current_version,\n" +
                "            'versionHistoryUUID',\n" +
                "            mfvh.\"uuid\",\n" +
                "            'formObject',\n" +
                "            mfvh.form_object,\n" +
                "            'webTemplateConfig',\n" +
                "            mfvh.template_config,\n" +
                "            'templateCss',\n" +
                "            mfvh.template_css,\n" +
                "            'formVm',\n" +
                "            mfvh.form_vm,\n" +
                "            'queryConfig',\n" +
                "            mfvh.query_config,\n" +
                "            'executionSequence',\n" +
                "            mfvh.execution_sequence\n" +
                "        ),\n" +
                "        'medplatFieldConfigs',\n" +
                "        (\n" +
                "            select cast(mfvh.field_config as jsonb)\n" +
                "           )\n" +
                "    ) as text)\n" +
                "from\n" +
                "\tmedplat_form_master form\n" +
                "inner join\n" +
                "    menu_config menu on\n" +
                "\tmenu.id = form.menu_config_id\n" +
                "inner join medplat_form_version_history mfvh on form.\"uuid\" = mfvh.form_master_uuid \n" +
                "where\n" +
                "    cast(form.uuid as text) = :uuid\n" +
                "    and \n" +
                "    form.current_version = mfvh.\"version\" ;";

        SQLQuery sqlQuery = session.createSQLQuery(query);
        sqlQuery.setParameter("uuid", uuid.toString());
        List<String> strings = sqlQuery.list();
        if (CollectionUtils.isEmpty(strings)) {
            throw new ImtechoUserException("Form not found!", 0);
        }
        return strings.get(0);
    }

    @Override
    public String getMedplatConfigsByMenuConfigId(Integer menuConfigId) {
        Session session = sessionFactory.getCurrentSession();
        String query = "select mfvh.field_config  \n" +
                "from medplat_form_master mfm \n" +
                "inner join medplat_form_version_history mfvh \n" +
                "on mfm.uuid = mfvh.form_master_uuid and mfm.current_version = mfvh.version\n" +
                "where mfm.menu_config_id = :menuConfigId and mfm.state = 'ACTIVE';";

        SQLQuery sqlQuery = session.createSQLQuery(query);
        sqlQuery.setParameter("menuConfigId", menuConfigId);
        List<String> strings = sqlQuery.list();
        if (CollectionUtils.isEmpty(strings)) {
            throw new ImtechoUserException("Menu not found!", 0);
        }
        return strings.get(0);
    }

    @Override
    public String getMedplatFormConfigByUuidAndVersion(UUID uuid, String version) {
        Session session = sessionFactory.getCurrentSession();
        String query = "select\n" +
                "    cast(json_build_object(\n" +
                "        'medplatFormMasterDto',\n" +
                "        json_build_object(\n" +
                "            'uuid',\n" +
                "            form.uuid,\n" +
                "            'formName',\n" +
                "            form.\"form_name\",\n" +
                "            'formCode',\n" +
                "            form.\"form_code\",\n" +
                "            'menuConfigId',\n" +
                "            form.\"menu_config_id\",\n" +
                "            'menuName',\n" +
                "            menu.menu_name,\n" +
                "            'state',\n" +
                "            form.\"state\",\n" +
                "            'createdBy',\n" +
                "            form.\"created_by\",\n" +
                "            'createdOn',\n" +
                "            form.\"created_on\",\n" +
                "            'formObject',\n" +
                "            mfvh.form_object,\n" +
                "            'webTemplateConfig',\n" +
                "            mfvh.template_config,\n" +
                "            'templateCss',\n" +
                "            mfvh.template_css,\n" +
                "            'formVm',\n" +
                "            mfvh.form_vm,\n" +
                "            'queryConfig',\n" +
                "            mfvh.query_config,\n" +
                "            'executionSequence',\n" +
                "            mfvh.execution_sequence\n" +
                "        ),\n" +
                "        'medplatFieldConfigs',\n" +
                "        (\n" +
                "            select cast(mfvh.field_config as jsonb)\n" +
                "           )\n" +
                "    ) as text)\n" +
                "from\n" +
                "\tmedplat_form_master form\n" +
                "inner join\n" +
                "    menu_config menu on\n" +
                "\tmenu.id = form.menu_config_id\n" +
                "inner join medplat_form_version_history mfvh on form.\"uuid\" = mfvh.form_master_uuid \n" +
                "where\n" +
                "    cast(form.uuid as text) = :uuid\n" +
                "    and mfvh.\"version\" = :version ;";

        SQLQuery sqlQuery = session.createSQLQuery(query);
        sqlQuery.setParameter("uuid", uuid.toString());
        sqlQuery.setParameter("version", version);
        List<String> strings = sqlQuery.list();
        if (CollectionUtils.isEmpty(strings)) {
            throw new ImtechoUserException("Form not found!", 0);
        }
        return strings.get(0);
    }

    @Override
    public String getMedplatFormConfigByUuidForEdit(UUID uuid) {
        Session session = sessionFactory.getCurrentSession();
        String query = "select\n" +
                "    cast(json_build_object(\n" +
                "        'medplatFormMasterDto',\n" +
                "        json_build_object(\n" +
                "            'uuid',\n" +
                "            form.uuid,\n" +
                "            'formName',\n" +
                "            form.\"form_name\",\n" +
                "            'formCode',\n" +
                "            form.\"form_code\",\n" +
                "            'menuConfigId',\n" +
                "            form.\"menu_config_id\",\n" +
                "            'menuName',\n" +
                "            menu.menu_name,\n" +
                "            'state',\n" +
                "            form.\"state\",\n" +
                "            'createdBy',\n" +
                "            form.\"created_by\",\n" +
                "            'createdOn',\n" +
                "            form.\"created_on\",\n" +
                "            'currentVersion',\n" +
                "            form.current_version,\n" +
                "            'versionHistory',\n" +
                "            mfvh.\"version\",\n" +
                "            'versionHistoryUUID',\n" +
                "            mfvh.\"uuid\",\n" +
                "            'formObject',\n" +
                "            mfvh.form_object,\n" +
                "            'webTemplateConfig',\n" +
                "            mfvh.template_config,\n" +
                "            'templateCss',\n" +
                "            mfvh.template_css,\n" +
                "            'formVm',\n" +
                "            mfvh.form_vm,\n" +
                "            'executionSequence',\n" +
                "            mfvh.execution_sequence,\n" +
                "            'queryConfig',\n" +
                "            mfvh.query_config,\n" +
                "            'description',\n" +
                "            form.description\n" +
                "        ),\n" +
                "        'medplatFieldConfigs',\n" +
                "        (\n" +
                "            select cast(mfvh.field_config as jsonb)\n" +
                "           )\n" +
                "    ) as text)\n" +
                "from\n" +
                "\tmedplat_form_master form\n" +
                "inner join\n" +
                "    menu_config menu on\n" +
                "\tmenu.id = form.menu_config_id\n" +
                "inner join medplat_form_version_history mfvh on form.\"uuid\" = mfvh.form_master_uuid \n" +
                "where\n" +
                "    cast(form.uuid as text) = :uuid \n" +
                "    and \n" +
                "    mfvh.\"version\" = 'DRAFT' ;";

        SQLQuery sqlQuery = session.createSQLQuery(query);
        sqlQuery.setParameter("uuid", uuid.toString());
        List<String> strings = sqlQuery.list();
        if (CollectionUtils.isEmpty(strings)) {
            throw new ImtechoUserException("Form not found!", 0);
        }
        return strings.get(0);
    }

    @Override
    public String getMedplatFormConfigByFormCode(String formCode) {
        Session session = sessionFactory.getCurrentSession();
        String query = "select\n" +
                "    cast(json_build_object(\n" +
                "        'medplatFormMasterDto',\n" +
                "        json_build_object(\n" +
                "            'uuid',\n" +
                "            form.uuid,\n" +
                "            'formName',\n" +
                "            form.\"form_name\",\n" +
                "            'formCode',\n" +
                "            form.\"form_code\",\n" +
                "            'menuConfigId',\n" +
                "            form.\"menu_config_id\",\n" +
                "            'menuName',\n" +
                "            menu.menu_name,\n" +
                "            'state',\n" +
                "            form.\"state\",\n" +
                "            'createdBy',\n" +
                "            form.\"created_by\",\n" +
                "            'createdOn',\n" +
                "            form.\"created_on\",\n" +
                "            'currentVersion',\n" +
                "            form.current_version,\n" +
                "            'versionHistoryUUID',\n" +
                "            mfvh.\"uuid\",\n" +
                "            'formObject',\n" +
                "            mfvh.form_object,\n" +
                "            'webTemplateConfig',\n" +
                "            mfvh.template_config,\n" +
                "            'templateCss',\n" +
                "            mfvh.template_css,\n" +
                "            'formVm',\n" +
                "            mfvh.form_vm,\n" +
                "            'executionSequence',\n" +
                "            mfvh.execution_sequence,\n" +
                "            'queryConfig',\n" +
                "            mfvh.query_config,\n" +
                "            'description',\n" +
                "            form.description\n" +
                "        ),\n" +
                "        'medplatFieldConfigs',\n" +
                "        (\n" +
                "            select cast(mfvh.field_config as jsonb)\n" +
                "           )\n" +
                "    ) as text)\n" +
                "from\n" +
                "\tmedplat_form_master form\n" +
                "inner join\n" +
                "    menu_config menu on\n" +
                "\tmenu.id = form.menu_config_id\n" +
                "inner join medplat_form_version_history mfvh on form.\"uuid\" = mfvh.form_master_uuid \n" +
                "where\n" +
                "    form.form_code = :formCode\n" +
                "    and \n" +
                "    form.current_version = mfvh.\"version\" ;";

        SQLQuery sqlQuery = session.createSQLQuery(query);
        sqlQuery.setParameter("formCode", formCode);
        List<String> strings = sqlQuery.list();
        if (CollectionUtils.isEmpty(strings)) {
            throw new ImtechoUserException("Form not found!", 0);
        }
        return strings.get(0);
    }

    @Override
    public MedplatFormMaster retrieveByFormCode(String formCode) {
        return super.findEntityByCriteriaList((root, criteriaBuilder, criteriaQuery) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(criteriaBuilder.equal(root.get("formCode"), formCode));
            return predicates;
        });
    }
}
