DELETE FROM QUERY_MASTER WHERE CODE='cm_dashboard_expected_delivery_target_report';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'2a18be02-3dd5-46bb-ba27-5836b6922259', 60512,  current_date , 60512,  current_date , 'cm_dashboard_expected_delivery_target_report',
'financialYear',
'-----------cm_dashboard_expected_delivery_target_report------
select dist.location_code as "DCODE",
	block.location_code as "Tcode",
	dist.english_name as "District",
	block.english_name as "Taluka",
	phc.english_name as "Phc",
	coalesce(cmetd.expected_mother_reg, 0) as "Expected_Mthr_Reg",
	coalesce(cmetd.expected_delivery_reg, 0) as "Expected_Del_Reg",
	coalesce(cmetd.ela_dpt_opv_mes_vita_1dose, 0) as "ELA_DPT_OPV_Mes_VitA_1Dose",
	dist.type as "District_Corp"

from location_master as phc
inner join location_master as block
on phc.parent = block.id
inner join location_master as dist
on dist.id = block.parent
left join location_wise_expected_target cmetd on
cmetd.location_id = phc.id and cmetd.financial_year = ''#financialYear#''
where
 phc.type in (''SC'',''ANM'')
and phc.name not ilike ''%delete%''
and block.name not ilike ''%delete%''
and dist.name not ilike ''%delete%''',
'To get data for CM dashboard expected delivery target report',
true, 'ACTIVE');