ALTER TABLE tuberculosis_screening_details
ADD COLUMN IF NOT EXISTS index_case boolean,
ADD COLUMN IF NOT EXISTS contacts_collected integer;


alter table imt_member
add column if not exists having_nhima_card boolean default false;


alter table imt_family add column if not exists vip_type text;