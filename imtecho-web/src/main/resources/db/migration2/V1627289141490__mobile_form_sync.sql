-- created mobile form details table
CREATE TABLE if not exists mobile_form_details
(
	id serial primary key,
	form_name character varying(255) unique,
	file_name character varying(255) unique,
	created_on timestamp without time zone,
	created_by integer,
	modified_on timestamp without time zone,
	modified_by integer
);

-- created mobile form relation table with role
CREATE TABLE if not exists mobile_form_role_rel
(
	form_id integer NOT NULL,
	role_id integer NOT NULL
);

--insert data in mobile form details
insert into mobile_form_details(form_name,file_name,created_on,created_by,modified_on,modified_by)
select f.c, f.c, now(), -1, now(), -1
from (
    values
        ('FHS'),
        ('CFHC'),
        ('MEMBER_UPDATE'),
        ('FHW_PREG_CONF'),
        ('FHW_DEATH_CONF'),
        ('LMPFU'),
        ('FHW_ANC'),
        ('FHW_WPD'),
        ('FHW_PNC'),
        ('FHW_CI'),
        ('FHW_CS'),
        ('FHW_VAE'),
        ('FHW_RIM'),
        ('DISCHARGE'),
        ('APPETITE'),
        ('SAM_SCREENING'),
        ('FHW_SAM_SCREENING_REF'),
        ('TRAVELLERS_SCREENING'),
        ('GMA'),
        ('IDSP_MEMBER'),
        ('IDSP_NEW_FAMILY'),
        ('IDSP_MEMBER_2'),
        ('NCD_FHW_HYPERTENSION'),
        ('NCD_FHW_DIABETES'),
        ('NCD_FHW_ORAL'),
        ('NCD_FHW_BREAST'),
        ('NCD_FHW_CERVICAL'),
        ('TT2_ALERT'),
        ('IRON_SUCROSE_ALERT'),
        ('ASHA_LMPFU'),
        ('ASHA_ANC'),
        ('ASHA_WPD'),
        ('ASHA_PNC'),
        ('ASHA_CS'),
        ('ASHA_SAM_SCREENING'),
        ('CMAM_FOLLOWUP'),
        ('ANCMORB'),
        ('PNCMORB'),
        ('CCMORB'),
        ('NCD_ASHA_CBAC'),
        ('ASHA_NPCB'),
        ('AWW_CS'),
        ('AWW_THR'),
        ('AWW_DAILY_NUTRITION')
) as f(c);

--insert data in role relation table
insert into mobile_form_role_rel(form_id,role_id)
select mfd.id, urm.id
from mobile_form_details mfd,
um_role_master urm
where urm.code = 'ASHA' and mfd.form_name in ('NCD_ASHA_CBAC',
'ASHA_LMPFU',
'ASHA_PNC',
'ASHA_CS',
'ASHA_NPCB',
'FHS',
'ASHA_ANC',
'ASHA_WPD',
'ANCMORB',
'PNCMORB',
'CCMORB',
'ASHA_SAM_SCREENING',
'CMAM_FOLLOWUP',
'TRAVELLERS_SCREENING',
'IDSP_MEMBER',
'IDSP_NEW_FAMILY',
'IDSP_MEMBER_2');


insert into mobile_form_role_rel(form_id,role_id)
select mfd.id, urm.id
from mobile_form_details mfd,
um_role_master urm
where urm.code = 'AWW' and mfd.form_name in ('AWW_CS',
'AWW_THR',
'AWW_DAILY_NUTRITION');

insert into mobile_form_role_rel(form_id,role_id)
select mfd.id, urm.id
from mobile_form_details mfd,
um_role_master urm
where urm.code in ('FHW','CHO-HWC','MPHW') and mfd.form_name in ('FHS',
'CFHC',
'FHW_PREG_CONF',
'FHW_DEATH_CONF',
'LMPFU',
'FHW_ANC',
'FHW_WPD',
'FHW_PNC',
'FHW_CI',
'FHW_CS',
'FHW_VAE',
'FHW_RIM',
'MEMBER_UPDATE',
'DISCHARGE',
'APPETITE',
'NCD_ASHA_CBAC',
'NCD_FHW_HYPERTENSION',
'NCD_FHW_DIABETES',
'NCD_FHW_ORAL',
'NCD_FHW_BREAST',
'NCD_FHW_CERVICAL',
'TT2_ALERT',
'IRON_SUCROSE_ALERT',
'SAM_SCREENING',
'FHW_SAM_SCREENING_REF',
'CMAM_FOLLOWUP',
'TRAVELLERS_SCREENING',
'GMA',
'IDSP_MEMBER',
'IDSP_NEW_FAMILY',
'IDSP_MEMBER_2');

