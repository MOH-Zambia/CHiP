delete from query_master where code='retrieve_cmtc_nrc_centers_for_rbsk';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'retrieve_cmtc_nrc_centers_for_rbsk','userId','
select * from health_infrastructure_details where location_id in (
	select child_id from location_hierchy_closer_det where parent_id in (
		select parent_id from location_hierchy_closer_det where child_id in (
			select loc_id from um_user_location where user_id = #userId# and state = ''ACTIVE''
		) and parent_loc_type = ''D''
	)
) and (is_cmtc = true or is_nrc=true)
',true,'ACTIVE');