alter table gvk_high_risk_follow_up_responce   
add column gvk_call_previous_state varchar(255);


update gvk_high_risk_follow_up_usr_info set call_attempt = 0 
where id in 
( select gvk_high_risk_usr_id  from gvk_high_risk_follow_up_responce where   
gvk_call_response_status = 'com.argusoft.imtecho.gvk.call.not-interested-in-treatment')