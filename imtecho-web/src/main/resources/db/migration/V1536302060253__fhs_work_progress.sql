update query_master  set query  = 'select to_char(vf.created_on,''dd-mm-yyyy'') as created_on,round((sum(vf.verified)*100)/sum(vf.total),1) as percentage,
sum(vf.verified) as verified,sum(vf.total) as total from 
location_hierchy_closer_det lhcd inner join  verfied_families_village_wise_records vf
on lhcd.child_id = vf.loc_id
where 
((#locationId# is not null and parent_id = #locationId#) or
(#locationId# is null and parent_id in (select loc_id from um_user_location where user_id = #loggedInUserId# and state = ''ACTIVE'')))
group by vf.created_on order by vf.created_on desc limit 10'
where code = 'fhs_verifification_percentage';