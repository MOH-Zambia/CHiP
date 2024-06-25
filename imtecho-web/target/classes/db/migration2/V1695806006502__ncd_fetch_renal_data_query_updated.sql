DELETE FROM QUERY_MASTER WHERE CODE='fetch_renal_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'eb6b996c-a815-4226-87fe-15c4aa639522', 97070,  current_date , 97070,  current_date , 'fetch_renal_data',
'member_id',
'select case
		when nut.albumin = ''0'' then ''0''
		when nut.albumin = ''TRACE'' then ''Trace''
		else cast(length(nut.albumin) as text)
	end as "albuminLevelInUrine"
from ncd_specialist_master nsm
	left join ncd_urine_test nut on nut.id = nsm.last_urine_screening_id
where nsm.member_id = cast(
		#member_id# as integer)',
null,
true, 'ACTIVE');