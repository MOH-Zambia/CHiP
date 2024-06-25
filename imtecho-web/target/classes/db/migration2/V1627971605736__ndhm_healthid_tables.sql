drop table if exists ndhm_health_id_user_details;
create table ndhm_health_id_user_details (
	id serial,
	member_id Integer,
	health_id varchar(250),
    health_id_number varchar(250) NOT NULL,
    name varchar(250),
    first_name varchar(250),
    middle_name varchar(250),
    last_name varchar(250),
    gender varchar(1),
    email varchar(250),
    mobile varchar(250),
    day_of_birth varchar(2),
    month_of_birth varchar(2),
    year_of_birth varchar(4),
    kyc_verified boolean,
    kyc_photo bytea,
    profile_photo bytea,
    card_doc_id bigint,
    address varchar(250),
    pincode varchar(50),
    town_code varchar(50),
    town_name varchar(50),
    village_code varchar(50),
    village_name varchar(50),
    district_code varchar(50),
    district_name varchar(50),
    state_code varchar(50),
    state_name varchar(50),
    ward_code varchar(50),
    ward_name varchar(50),
    sub_district_code varchar(50),
    sub_district_name varchar(50),
    tag_prop_1 varchar(50),
    tag_prop_2 varchar(50),
    tag_prop_3 varchar(50),
    created_by Integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    modified_by Integer,
    modified_on timestamp without time zone,
    CONSTRAINT ndhm_health_id_user_details_pkey PRIMARY KEY(id)
);

drop table if exists ndhm_health_id_auth_method;
create table ndhm_health_id_auth_method (
    id serial,
 	health_id varchar(250),
    health_id_number varchar(250),
    auth_method varchar(250),
    created_by Integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    modified_by Integer,
    modified_on timestamp without time zone,
    CONSTRAINT ndhm_health_id_auth_method_pkey PRIMARY KEY(id)
);

drop table if exists ndhm_health_id_tag;
