-- insert fhw notification form feature relation
insert into mobile_form_feature_rel (form_id,mobile_constant)
select mfd.id, mffr.mobile_constant
from mobile_form_details mfd,
mobile_feature_master mffr
where mfd.file_name in ('LMPFU','FHW_ANC','TT2_ALERT','IRON_SUCROSE_ALERT','FHW_WPD','FHW_PNC','DISCHARGE', 'GMA',
 'APPETITE', 'FHW_PREG_CONF', 'FHW_DEATH_CONF', 'FHW_VAE') and mffr.mobile_constant = 'FHW_NOTIFICATION';