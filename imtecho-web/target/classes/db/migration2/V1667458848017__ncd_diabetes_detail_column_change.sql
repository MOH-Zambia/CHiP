alter table ncd_member_diabetes_detail
DROP COLUMN IF EXISTS urine_sugar,
ADD COLUMN urine_sugar integer;

