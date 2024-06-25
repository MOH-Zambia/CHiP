drop table if exists rbsk_defect_configuration_stabilization_info_rel;
drop table if exists rbsk_defect_configuration;
create table rbsk_defect_configuration (
    id serial primary key,
    defect_name text,
    defect_image text,
    description text,
    body_part text,
    photo_required boolean,
    referral_required boolean,
    created_by bigint,
    created_on timestamp without time zone NOT NULL,
    modified_on timestamp without time zone NOT NULL,
    modified_by bigint
);

CREATE TABLE rbsk_defect_configuration_stabilization_info_rel
(
  defect_id integer NOT NULL,
  stabilization_info_code text NOT NULL,
  PRIMARY KEY (defect_id, stabilization_info_code),
  FOREIGN KEY (defect_id)
      REFERENCES rbsk_defect_configuration (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

drop table if exists rbsk_defect_stabilization_info;
create table rbsk_defect_stabilization_info (
    code text primary key,
    description text
);

drop table if exists rbsk_head_to_toe_screening;
create table rbsk_head_to_toe_screening(
    id serial primary key,
    member_id integer,
    family_id integer,
    location_id integer,
    created_by bigint,
    created_on timestamp without time zone NOT NULL,
    modified_on timestamp without time zone NOT NULL,
    modified_by bigint,
    screening_date timestamp without time zone NOT NULL,
    done_from text
);

drop table if exists rbsk_head_to_toe_screening_defect_details;
create table rbsk_head_to_toe_screening_defect_details(
    id serial primary key,
    screening_id integer,
    member_id integer,
    defect_id integer,
    photo bigint
);


