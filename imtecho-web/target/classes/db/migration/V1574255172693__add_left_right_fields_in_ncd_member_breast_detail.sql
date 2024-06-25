ALTER TABLE ncd_member_breast_detail
DROP COLUMN IF EXISTS size_change_left ,
DROP COLUMN IF EXISTS size_change_right ,
DROP COLUMN IF EXISTS retraction_of_left_nipple ,
DROP COLUMN IF EXISTS retraction_of_right_nipple ,
DROP COLUMN IF EXISTS discharge_from_left_nipple ,
DROP COLUMN IF EXISTS discharge_from_right_nipple ,
DROP COLUMN IF EXISTS left_lymphadenopathy ,
DROP COLUMN IF EXISTS right_lymphadenopathy ;

ALTER TABLE ncd_member_breast_detail
ADD COLUMN size_change_left boolean,
ADD COLUMN size_change_right boolean,
ADD COLUMN retraction_of_left_nipple boolean,
ADD COLUMN retraction_of_right_nipple boolean,
ADD COLUMN discharge_from_left_nipple boolean,
ADD COLUMN discharge_from_right_nipple boolean,
ADD COLUMN left_lymphadenopathy boolean,
ADD COLUMN right_lymphadenopathy boolean;