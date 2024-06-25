update system_configuration set key_value = '49' where system_key = 'MOBILE_FORM_VERSION';

ALTER TABLE imt_member
DROP COLUMN if exists hospitalized_earlier, ADD COLUMN hospitalized_earlier boolean;


insert into mobile_form_role_rel(form_id, role_id)
select mfd.id, urm.id
from mobile_form_details mfd,
um_role_master urm
where urm.code in ('VLHW', 'ASHA') and mfd.form_name = 'MEMBER_UPDATE';


insert into mobile_form_feature_rel (form_id,mobile_constant)
select mfd.id, mffr.mobile_constant
from mobile_form_details mfd,
mobile_feature_master mffr
where mfd.form_name = 'MEMBER_UPDATE' and mffr.mobile_constant = 'ASHA_MY_PEOPLE';
