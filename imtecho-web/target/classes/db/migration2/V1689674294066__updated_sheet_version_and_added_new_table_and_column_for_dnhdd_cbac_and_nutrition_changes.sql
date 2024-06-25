
create TABLE if not exists ncd_cbac_nutrition_master
(
  id serial primary key,
  member_id integer,
  family_id integer,
  cbac_table_id text,
  child_nutrition_table_id text,
  created_by integer null,
  created_on timestamp without time zone NULL,
  modified_by integer NULL,
  modified_on timestamp without time zone NULL);

  alter table  ncd_member_cbac_detail  drop column if exists cbac_and_nutrition_master_id,
  add column cbac_and_nutrition_master_id integer;

  alter table  child_nutrition_sam_screening_master drop column if exists hmis_id,
  add column hmis_id bigint;

  alter table  child_nutrition_sam_screening_master drop column if exists cloudy_vision,
  add column cloudy_vision boolean;

  alter table  child_nutrition_sam_screening_master drop column if exists blurred_vision_eye,
  add column blurred_vision_eye text;

  alter table  child_nutrition_sam_screening_master drop column if exists fits_history,
  add column fits_history boolean;

  alter table  child_nutrition_sam_screening_master drop column if exists hearing_difficulty,
  add column hearing_difficulty boolean;

  alter table  child_nutrition_sam_screening_master  drop column if exists cbac_and_nutrition_master_id,
  add column cbac_and_nutrition_master_id integer;

  insert into listvalue_field_form_relation (field, form_id)
  select 'eyeIssueList', id
  from mobile_form_details where form_name = 'DNHDD_NCD_CBAC_AND_NUTRITION';

  insert into listvalue_field_form_relation (field, form_id)
  select 'chronicDiseaseList', id
  from mobile_form_details where form_name = 'DNHDD_NCD_CBAC_AND_NUTRITION';

  insert into listvalue_field_form_relation (field, form_id)
  select 'educationStatusList', id
  from mobile_form_details where form_name = 'DNHDD_NCD_CBAC_AND_NUTRITION';

  update system_configuration set key_value = '84' where system_key = 'MOBILE_FORM_VERSION';