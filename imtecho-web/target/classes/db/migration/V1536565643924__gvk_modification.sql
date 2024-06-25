alter table gvk_absent_verification
add column ref_id bigint; 


update gvk_absent_verification gav
set ref_id = auv.id 
from
absent_user_verification auv 
where auv.user_id = gav.user_id and auv.modified_on::date = gav.created_on::date;