-- To retrieve oral disease treatment history of patient

delete from query_master where code='ncd_oral_treatment_history';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values(1, current_date, 'ncd_oral_treatment_history', 'memberId', '
select cast(ncd_member_oral_detail.screening_date as date) as "diagnosedOn",
concat(um_user.first_name, '' '', um_user.middle_name, '' '', um_user.last_name) as "diagnosedBy",
case when ncd_member_referral.status = ''MOBILE_REFERRED'' then ''Referred from mobile''
    when ncd_member_referral.status = ''SUSPECTED'' then ''Suspected''
	when ncd_member_referral.status = ''CONFIRMED'' then ''Confirmed''
	when ncd_member_referral.status = ''TREATMENT_STARTED'' then ''Treatment started''
	when ncd_member_referral.status = ''REFERRED'' then ''Referred to other facility''
	when ncd_member_referral.status = ''NO_ABNORMALITY'' then ''No abnormality'' end as status
from ncd_member_oral_detail
inner join ncd_member_referral on ncd_member_oral_detail.referral_id = ncd_member_referral.id
inner join um_user on ncd_member_oral_detail.created_by = um_user.id
where ncd_member_oral_detail.member_id = #memberId#
group by ncd_member_oral_detail.screening_date,
um_user.first_name,um_user.middle_name,um_user.last_name,ncd_member_referral.status
order by ncd_member_oral_detail.screening_date desc
', true, 'ACTIVE', 'To retrieve oral disease treatment history of patient.');