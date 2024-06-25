ALTER TABLE if exists location_wise_expected_target
ADD COLUMN if not exists expected_family integer,
ADD COLUMN if not exists expected_population integer;