alter table imt_member
add column if not exists abha_status text,
add column if not exists aadhar_status text,
add column if not exists other_hof_relation text;