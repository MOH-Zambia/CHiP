
update query_master set query= 'select * from imt_member where id in 
(select member_id from rch_pregnancy_registration_det where delivery_date > now() - interval ''60 days''
and state = ''DELIVERY_DONE''
and member_id in (select id from imt_member where unique_health_id in (''#memberId#'')))
and ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))'
where code = 'pnc_retrieve_mother_list_by_member_id'


