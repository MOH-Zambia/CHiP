
insert into mobile_form_feature_rel (form_id,mobile_constant)
select mfd.id, mffr.mobile_constant
from mobile_form_details mfd,
mobile_feature_master mffr
where mfd.file_name = 'ASHA_NPCB' and mffr.mobile_constant = 'ASHA_NPCB_SCREENING';
