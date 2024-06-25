DELETE FROM public.query_master where code = 'retrieve_health_infra_for_opd_lab_test';

INSERT INTO public.query_master(
    created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES (1, localtimestamp, 'retrieve_health_infra_for_opd_lab_test', 'userId',
    'select hm.id, case when u.prefered_language = ''GU'' then hm.name else hm.name_in_english end as "healthInfraName"
        from health_infrastructure_details hm ,user_health_infrastructure uh, um_user u
        where hm.id = uh.health_infrastrucutre_id and uh.user_id = u.id and uh.state = ''ACTIVE'' and u.id = #userId#',
    true, 'ACTIVE', 'This will fetch health infra assigned to user for mobile');


DELETE FROM public.query_master where code = 'retrieve_member_details_for_opd_lab_test';

INSERT INTO public.query_master(
    created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES (1, localtimestamp, 'retrieve_member_details_for_opd_lab_test', 'healthInfraId',
    'select m.unique_health_id as "healthId",
        m.family_id as "familyId",
        m.first_name as "firstName",
        m.middle_name as "middleName",
        m.last_name as "lastName",
        l.name as "villageName",
        ltm.name as "testName",
        sfm.form_code as "formCode",
        omm.health_infra_id as "healthInfraId",
        ltd.id as "labTestDetId"
        from rch_opd_member_master omm
        inner join rch_opd_lab_test_details ltd on omm.id = ltd.opd_member_master_id
        inner join rch_opd_lab_test_master ltm on ltd.lab_test_id = ltm.id
        inner join system_form_master sfm on ltm.form_id = sfm.id
        inner join imt_member m on ltd.member_id = m.id
        inner join imt_family f on m.family_id = f.family_id
        inner join location_master l on f.location_id = l.id
        where ltd.status = ''PENDING''
        and omm.health_infra_id = #healthInfraId#;',
    true, 'ACTIVE', 'This will fetch health infra assigned to user for mobile');


DELETE FROM public.query_master where code = 'retrieve_lab_test_form_opd_lab_test';

INSERT INTO public.query_master(
    created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES (1, localtimestamp, 'retrieve_lab_test_form_opd_lab_test', 'formCode',
    'with max_ver as (
	        select sfc.form_id, max(sfc.version) from system_form_configuration sfc
	        inner join system_form_master sfm on sfm.id = sfc.form_id and sfm.form_code = ''#formCode#'' group by sfc.form_id
        )
        select sfc.form_config_json as "formConfigJson" from system_form_configuration sfc
        inner join max_ver m on m.form_id = sfc.form_id and m.max = sfc.version',
    true, 'ACTIVE', 'This will fetch health infra assigned to user for mobile');