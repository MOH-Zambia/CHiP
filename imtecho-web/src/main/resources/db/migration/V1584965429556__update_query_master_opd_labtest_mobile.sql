update query_master set query = '
with max_ver as (
    select sfc.form_id, max(sfc.version) from system_form_configuration sfc
    inner join system_form_master sfm on sfm.id = sfc.form_id and sfm.form_code = ''#formCode#'' group by sfc.form_id
)
select sfc.form_config_json as "formConfigJson", sfc.version from system_form_configuration sfc
inner join max_ver m on m.form_id = sfc.form_id and m.max = sfc.version
' where code = 'retrieve_lab_test_form_opd_lab_test'