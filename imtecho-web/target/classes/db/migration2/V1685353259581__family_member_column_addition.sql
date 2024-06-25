alter table imt_family
add column if not exists ration_card_color text,
add column if not exists residence_status text,
add column if not exists native_state text;

alter table imt_member
add column if not exists alternate_number text,
add column if not exists physical_disability text,
add column if not exists cataract_surgery text,
add column if not exists sickle_cell_status text,
add column if not exists pension_scheme text;