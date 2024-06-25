alter table imt_family
add column if not exists eligible_women_count integer,
add column if not exists eligible_children_count integer,
add column if not exists is_hold_id_poor boolean;

alter table imt_member
add column if not exists have_nssf boolean,
add column if not exists nssf_card_number character varying(17);
