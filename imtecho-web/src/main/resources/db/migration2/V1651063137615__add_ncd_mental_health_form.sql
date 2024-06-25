insert into mobile_form_details(form_name,file_name,created_on,created_by,modified_on,modified_by)
values ('NCD_FHW_MENTAL_HEALTH', 'NCD_FHW_MENTAL_HEALTH', now(), -1, now(), -1);

insert into mobile_form_role_rel(form_id, role_id)
select mfd.id, urm.id
from mobile_form_details mfd,
um_role_master urm
where urm.code in ('FHW','MPHW') and mfd.form_name = 'NCD_FHW_MENTAL_HEALTH';

insert into mobile_form_feature_rel (form_id,mobile_constant)
select mfd.id, mffr.mobile_constant
from mobile_form_details mfd,
mobile_feature_master mffr
where mfd.form_name = 'NCD_FHW_MENTAL_HEALTH' and mffr.mobile_constant = 'FHW_NCD_SCREENING';
