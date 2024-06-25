insert into listvalue_field_master(field_key, field, is_active, field_type, form, role_type)
values('childSymptomsFhwCs', 'childSymptomsFhwCs', true, 'T', 'FHW_CS', 'A,F');

insert into listvalue_field_form_relation(field, form_id)
select 'childSymptomsFhwCs', id from mobile_form_details where form_name = 'FHW_CS';

insert into listvalue_field_master(field_key, field, is_active, field_type, form, role_type)
values('childDelays0to3', 'childDelays0to3', true, 'T', 'FHW_CS', 'A,F');
insert into listvalue_field_form_relation(field, form_id)
select 'childDelays0to3', id from mobile_form_details where form_name = 'FHW_CS';


insert into listvalue_field_master(field_key, field, is_active, field_type, form, role_type)
values('childDelays3to6', 'childDelays3to6', true, 'T', 'FHW_CS', 'A,F');
insert into listvalue_field_form_relation(field, form_id)
select 'childDelays3to6', id from mobile_form_details where form_name = 'FHW_CS';

insert into listvalue_field_master(field_key, field, is_active, field_type, form, role_type)
values('childDelays6to9', 'childDelays6to9', true, 'T', 'FHW_CS', 'A,F');
insert into listvalue_field_form_relation(field, form_id)
select 'childDelays6to9', id from mobile_form_details where form_name = 'FHW_CS';

insert into listvalue_field_master(field_key, field, is_active, field_type, form, role_type)
values('childDelays9to12', 'childDelays9to12', true, 'T', 'FHW_CS', 'A,F');
insert into listvalue_field_form_relation(field, form_id)
select 'childDelays9to12', id from mobile_form_details where form_name = 'FHW_CS';

insert into listvalue_field_master(field_key, field, is_active, field_type, form, role_type)
values('childDelays12to18', 'childDelays12to18', true, 'T', 'FHW_CS', 'A,F');
insert into listvalue_field_form_relation(field, form_id)
select 'childDelays12to18', id from mobile_form_details where form_name = 'FHW_CS';

insert into listvalue_field_master(field_key, field, is_active, field_type, form, role_type)
values('childDelays18to24', 'childDelays18to24', true, 'T', 'FHW_CS', 'A,F');
insert into listvalue_field_form_relation(field, form_id)
select 'childDelays18to24', id from mobile_form_details where form_name = 'FHW_CS';

insert into listvalue_field_master(field_key, field, is_active, field_type, form, role_type)
values('childDelays24to36', 'childDelays24to36', true, 'T', 'FHW_CS', 'A,F');
insert into listvalue_field_form_relation(field, form_id)
select 'childDelays24to36', id from mobile_form_details where form_name = 'FHW_CS';

insert into listvalue_field_master(field_key, field, is_active, field_type, form, role_type)
values('childDelaysAbove36', 'childDelaysAbove36', true, 'T', 'FHW_CS', 'A,F');
insert into listvalue_field_form_relation(field, form_id)
select 'childDelaysAbove36', id from mobile_form_details where form_name = 'FHW_CS';

