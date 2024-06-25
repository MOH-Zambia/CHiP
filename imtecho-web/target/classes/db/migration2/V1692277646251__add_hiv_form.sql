insert into mobile_form_details(form_name,file_name,created_on,created_by,modified_on,modified_by)
values ('HIV_POSITIVE', 'HIV_POSITIVE', now(), -1, now(), -1);

insert into mobile_form_feature_rel (form_id, mobile_constant)
select id, 'FHW_MY_PEOPLE' from mobile_form_details where form_name = 'HIV_POSITIVE';

insert into listvalue_field_master(field_key, field, is_active, field_type, form, role_type)
values('hivCounsellingVideo', 'hivCounsellingVideo', true, 'M', 'FHW_ANC', 'A,F');

insert into listvalue_field_form_relation(field, form_id)
select 'hivCounsellingVideo', id from mobile_form_details where form_name = 'HIV_POSITIVE';

drop table if exists rch_preg_hiv_positive_master;

create table if not exists rch_preg_hiv_positive_master(
	id serial primary key,
	member_id integer,
	expected_delivery_place character varying(100),
	is_art_done boolean,
	is_referral_done boolean,
	referral_place text,
	created_by integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    modified_by integer,
    modified_on timestamp without time zone
);


