ALTER TABLE rch_wpd_mother_master
DROP COLUMN IF EXISTS cortico_steroid_given,
ADD COLUMN cortico_steroid_given boolean;

ALTER TABLE rch_wpd_child_master
DROP COLUMN IF EXISTS type_of_delivery,
ADD COLUMN type_of_delivery character varying(15),
DROP COLUMN IF EXISTS breast_feeding_in_one_hour,
ADD COLUMN breast_feeding_in_one_hour boolean;