--Table: public.ncd_member_initial_assessment_detail
ALTER TABLE public.ncd_member_initial_assessment_detail
RENAME COLUMN flag TO consultant_flag;

ALTER TABLE public.ncd_member_diabetes_detail
DROP COLUMN IF EXISTS urine_sugar,
ADD COLUMN urine_sugar boolean;

--Table: public.ncd_member_hypertension_detail
ALTER TABLE public.ncd_member_hypertension_detail
DROP COLUMN IF EXISTS does_suffering,
ADD COLUMN does_suffering boolean;

--Table: public.ncd_member_general_detail
ALTER TABLE public.ncd_member_general_detail
RENAME COLUMN flag TO consultant_flag;

ALTER TABLE public.ncd_member_general_detail
DROP COLUMN diagnosed_earlier,
DROP COLUMN  currently_under_treatement,
DROP COLUMN   refferal_done,
DROP COLUMN current_treatment_place,
DROP COLUMN   is_continue_treatment_from_current_place;

ALTER TABLE public.ncd_member_general_detail
DROP COLUMN IF EXISTS other_details,
ADD COLUMN other_details text;

ALTER TABLE public.ncd_member_general_detail
DROP COLUMN IF EXISTS does_required_ref,
ADD COLUMN does_required_ref boolean;

ALTER TABLE public.ncd_member_general_detail
DROP COLUMN IF EXISTS refferral_reason,
ADD COLUMN refferral_reason text;

ALTER TABLE public.ncd_member_general_detail
DROP COLUMN IF EXISTS medicine_name,
ADD COLUMN medicine_name text;

ALTER TABLE public.ncd_member_general_detail
DROP COLUMN IF EXISTS frequency,
ADD COLUMN frequency INTEGER;

ALTER TABLE public.ncd_member_general_detail
DROP COLUMN IF EXISTS quantity,
ADD COLUMN quantity INTEGER;

ALTER TABLE public.ncd_member_general_detail
DROP COLUMN IF EXISTS duration,
ADD COLUMN duration INTEGER;

ALTER TABLE public.ncd_member_general_detail
DROP COLUMN IF EXISTS special_instruction,
ADD COLUMN special_instruction text;

--Table: public.ncd_member_breast_detail
ALTER TABLE public.ncd_member_breast_detail
RENAME COLUMN flag TO consultant_flag;

--Table: public.ncd_member_cervical_detail
ALTER TABLE public.ncd_member_cervical_detail
RENAME COLUMN flag TO consultant_flag;

ALTER TABLE public.ncd_member_cervical_detail
RENAME COLUMN other TO other_symptoms;

ALTER TABLE public.ncd_member_cervical_detail
RENAME COLUMN others TO other_symptoms_description;

ALTER TABLE public.ncd_member_cervical_detail
RENAME COLUMN onther_finding TO other_finding;

ALTER TABLE public.ncd_member_cervical_detail
RENAME COLUMN onther_findings TO other_finding_description;

--Table: public.ncd_drug_inventory_detail
ALTER TABLE public.ncd_drug_inventory_detail
RENAME COLUMN isissued TO is_issued;

ALTER TABLE public.ncd_drug_inventory_detail
RENAME COLUMN isreceived TO is_received;

ALTER TABLE public.ncd_drug_inventory_detail
DROP COLUMN flag;

--Table: public.ncd_mbbsmo_review_detail
ALTER TABLE public.ncd_mbbsmo_review_detail
DROP COLUMN flag;

INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values
('Drug Inventory','ncd',TRUE,'techo.ncd.druginventory','{}');

INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values
('Consultant Followup Screen members','ncd',TRUE,'techo.ncd.followupscreenlisting','{}');

INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values
('MBBS MO Review Screen','ncd',TRUE,'techo.ncd.moreviewscreen','{}');

INSERT INTO listvalue_field_master (field_key,field,is_active,field_type,form,role_type)
VALUES('generalMedicine','generalMedicine',true,'T','WEB','F');

INSERT INTO listvalue_field_value_detail (file_size,last_modified_on,last_modified_by,is_archive,is_active,value,field_key)
VALUES
(0,now(),-1,false,true,'Amlodipine 2.5 mg','generalMedicine'),
(0,now(),-1,false,true,'Amlodipine 5 mg','generalMedicine'),
(0,now(),-1,false,true,'LAmlodipine 5mg+Hydrochlorothiazide 12.5mg','generalMedicine'),
(0,now(),-1,false,true,'Atenolol 25 mg','generalMedicine'),
(0,now(),-1,false,true,'Atenolol 50 mg','generalMedicine'),
(0,now(),-1,false,true,'Enalapril 2.5mg','generalMedicine'),
(0,now(),-1,false,true,'Enalapril 5mg','generalMedicine'),
(0,now(),-1,false,true,'Losartan 25mg','generalMedicine'),
(0,now(),-1,false,true,'Losartan 50mg','generalMedicine'),
(0,now(),-1,false,true,'Losartan 50mg+ Hydrochlorothiazide 12.5mg','generalMedicine'),
(0,now(),-1,false,true,'Furosemide 40','generalMedicine'),
(0,now(),-1,false,true,'Hydrochlorothiazide 12.5mg','generalMedicine'),
(0,now(),-1,false,true,'Telmiride AM','generalMedicine'),
(0,now(),-1,false,true,'Glimepiride 1mg','generalMedicine'),
(0,now(),-1,false,true,'Glimepiride 2mg','generalMedicine'),
(0,now(),-1,false,true,'Metformin 500','generalMedicine'),
(0,now(),-1,false,true,'Metformin 750 mg','generalMedicine'),
(0,now(),-1,false,true,'Metformin 1000 mg','generalMedicine'),
(0,now(),-1,false,true,'Glipizide 5 mg','generalMedicine'),
(0,now(),-1,false,true,'Salbutamol 2mg','generalMedicine'),
(0,now(),-1,false,true,'Salbutamol 4mg','generalMedicine'),
(0,now(),-1,false,true,'Escitalopram','generalMedicine'),
(0,now(),-1,false,true,'Clonazepam 0.25','generalMedicine'),
(0,now(),-1,false,true,'Olanzapine 5mg','generalMedicine');

UPDATE public.query_master
SET query = ' select cast(ncd_member_mental_health_detail.screening_date as date) as "diagnosedOn",
concat(um_user.first_name, '' '', um_user.middle_name, '' '', um_user.last_name) as "diagnosedBy",
case when ncd_member_referral.status = ''MOBILE_REFERRED'' then ''Referred from mobile''
    when ncd_member_referral.status = ''SUSPECTED'' then ''Suspected''
	when ncd_member_referral.status = ''CONFIRMED'' then ''Confirmed''
	when ncd_member_referral.status = ''UNCONTROLLED'' then ''Uncontrolled''
    when ncd_member_referral.status = ''CONTROLLED'' then ''Controlled''
	when ncd_member_referral.status = ''TREATMENT_STARTED'' then ''Treatment started''
	when ncd_member_referral.status = ''REFERRED'' then ''Referred to other facility''
	when ncd_member_referral.status = ''NO_ABNORMALITY'' then ''No abnormality'' end as status,
string_agg(medicine_master.name,'', '') as "medicines"
from ncd_member_mental_health_detail
inner join ncd_member_referral on ncd_member_mental_health_detail.referral_id = ncd_member_referral.id
inner join um_user on ncd_member_mental_health_detail.created_by = um_user.id
left join ncd_member_disesase_medicine on ncd_member_mental_health_detail.id = ncd_member_disesase_medicine.reference_id
left join medicine_master on ncd_member_disesase_medicine.medicine_id = medicine_master.id
where ncd_member_mental_health_detail.member_id = #memberId#
group by ncd_member_mental_health_detail.screening_date,
um_user.first_name,um_user.middle_name,um_user.last_name,ncd_member_referral.status
order by ncd_member_mental_health_detail.screening_date desc'
where code='ncd_mentalHealth_treatment_history';


UPDATE public.query_master
SET query = 'select cast(ncd_member_general_detail.screening_date as date) as "diagnosedOn",
concat(um_user.first_name, '' '', um_user.middle_name, '' '', um_user.last_name) as "diagnosedBy",
case when ncd_member_referral.status = ''MOBILE_REFERRED'' then ''Referred from mobile''
    when ncd_member_referral.status = ''SUSPECTED'' then ''Suspected''
	when ncd_member_referral.status = ''CONFIRMED'' then ''Confirmed''
	when ncd_member_referral.status = ''REFER_NO_VISIT'' then ''Referred No visit''
	when ncd_member_referral.status = ''TREATMENT_STARTED'' then ''Treatment started''
	when ncd_member_referral.status = ''REFERRED'' then ''Referred to other facility''
	when ncd_member_referral.status = ''NO_ABNORMALITY'' then ''No abnormality'' end as status,
string_agg(medicine_master.name,'', '') as "medicines"
from ncd_member_general_detail
inner join ncd_member_referral on ncd_member_general_detail.referral_id = ncd_member_referral.id
inner join um_user on ncd_member_general_detail.created_by = um_user.id
left join ncd_member_disesase_medicine on ncd_member_general_detail.id = ncd_member_disesase_medicine.reference_id
left join medicine_master on ncd_member_disesase_medicine.medicine_id = medicine_master.id
where ncd_member_general_detail.member_id = #memberId#
group by ncd_member_general_detail.screening_date,
um_user.first_name,um_user.middle_name,um_user.last_name,ncd_member_referral.status
order by ncd_member_general_detail.screening_date desc'
where code='ncd_general_treatment_history';
