-- created mobile form feature relation table
CREATE TABLE if not exists mobile_form_feature_rel
(
	form_id integer NOT NULL,
	mobile_constant text NOT NULL
);

-- inserted data for relational table
insert into mobile_form_feature_rel (form_id,mobile_constant)
select mfd.id, mffr.mobile_constant
from mobile_form_details mfd,
mobile_feature_master mffr
where mfd.form_name = 'CFHC' and mffr.mobile_constant = 'FHW_CFHC';

insert into mobile_form_feature_rel (form_id,mobile_constant)
select mfd.id, mffr.mobile_constant
from mobile_form_details mfd,
mobile_feature_master mffr
where mfd.form_name in ('IDSP_NEW_FAMILY','IDSP_MEMBER_2') and mffr.mobile_constant = 'FHW_SURVEILLANCE';

insert into mobile_form_feature_rel (form_id,mobile_constant)
select mfd.id, mffr.mobile_constant
from mobile_form_details mfd,
mobile_feature_master mffr
where mfd.form_name in ('SAM_SCREENING','TRAVELLERS_SCREENING','FHW_SAM_SCREENING_REF','CMAM_FOLLOWUP','FHW_CS') and mffr.mobile_constant = 'FHW_NOTIFICATION';

insert into mobile_form_feature_rel (form_id,mobile_constant)
select mfd.id, mffr.mobile_constant
from mobile_form_details mfd,
mobile_feature_master mffr
where mfd.form_name in ('NCD_ASHA_CBAC','NCD_FHW_HYPERTENSION','NCD_FHW_DIABETES','NCD_FHW_ORAL','NCD_FHW_BREAST','NCD_FHW_CERVICAL') and mffr.mobile_constant = 'FHW_NCD_SCREENING';

insert into mobile_form_feature_rel (form_id,mobile_constant)
select mfd.id, mffr.mobile_constant
from mobile_form_details mfd,
mobile_feature_master mffr
where mfd.form_name in ('FHW_CS','FHW_ANC') and mffr.mobile_constant = 'FHW_HIGH_RISK_WOMEN_AND_CHILD';

insert into mobile_form_feature_rel (form_id,mobile_constant)
select mfd.id, mffr.mobile_constant
from mobile_form_details mfd,
mobile_feature_master mffr
where mfd.form_name in ('MEMBER_UPDATE','FHW_RIM','LMPFU','FHW_ANC', 'FHW_WPD', 'FHW_PNC', 'FHW_CS', 'FHW_VAE', 'GMA', 'TRAVELLERS_SCREENING') and mffr.mobile_constant = 'FHW_MY_PEOPLE';

insert into mobile_form_feature_rel (form_id,mobile_constant)
select mfd.id, mffr.mobile_constant
from mobile_form_details mfd,
mobile_feature_master mffr
where mfd.form_name in ('ASHA_CS', 'ASHA_LMPFU', 'ASHA_ANC', 'ASHA_WPD', 'ASHA_PNC') and mffr.mobile_constant = 'ASHA_MY_PEOPLE';

insert into mobile_form_feature_rel (form_id,mobile_constant)
select mfd.id, mffr.mobile_constant
from mobile_form_details mfd,
mobile_feature_master mffr
where mfd.form_name in ('ASHA_LMPFU', 'ASHA_ANC', 'ASHA_PNC', 'ASHA_CS', 'ASHA_SAM_SCREENING', 'CMAM_FOLLOWUP') and mffr.mobile_constant = 'ASHA_NOTIFICATION';

insert into mobile_form_feature_rel (form_id,mobile_constant)
select mfd.id, mffr.mobile_constant
from mobile_form_details mfd,
mobile_feature_master mffr
where mfd.form_name in ('ASHA_CS','ASHA_ANC') and mffr.mobile_constant = 'ASHA_HIGH_RISK_BENEFICIARIES';

insert into mobile_form_feature_rel (form_id,mobile_constant)
select mfd.id, mffr.mobile_constant
from mobile_form_details mfd,
mobile_feature_master mffr
where mfd.form_name = 'NCD_ASHA_CBAC' and mffr.mobile_constant = 'ASHA_CBAC_ENTRY';

insert into mobile_form_feature_rel (form_id,mobile_constant)
select mfd.id, mffr.mobile_constant
from mobile_form_details mfd,
mobile_feature_master mffr
where mfd.form_name = 'NCD_ASHA_CBAC' and mffr.mobile_constant = 'ASHA_NPCB_SCREENING';