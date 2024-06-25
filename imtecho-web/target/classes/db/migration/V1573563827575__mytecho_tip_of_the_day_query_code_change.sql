delete from query_master where code = 'mytecho_get_tip_ofthe_day';

INSERT INTO public.query_master(
            created_by,created_on,code, params, 
            query, returns_result_set, state, description)
    VALUES (1,now(),'mytecho_get_tip_ofthe_day', 'memberId,languagePreference',
 'select mconf.tittle as title,mconf.description as description,mtip.tip_id as "tipId",mtip.member_id as "memberId"
from mytecho_user_tip_of_the_day mtip 
inner join mytecho_timeline_language_wise_config_det mconf on mtip.tip_id=mconf.mt_timeline_config_id
where is_sent =false  and cast (schedule_date as date)= current_date and mconf.language=''#languagePreference#'' 
and mtip.member_id=#memberId#'
, true, 'ACTIVE', 'This query will return tip for the specified member');


delete from query_master where code = 'mytecho_mark_tip_as_read';

INSERT INTO public.query_master(
            created_by,created_on,code, params, 
            query, returns_result_set, state, description)
    VALUES (1,now(),'mytecho_mark_tip_as_read', 'memberId,tipId',
 'update mytecho_user_tip_of_the_day set is_sent =true where tip_id=#tipId# and member_id=#memberId#'
, false, 'ACTIVE', 'This query will mark tip as read for the specified member');