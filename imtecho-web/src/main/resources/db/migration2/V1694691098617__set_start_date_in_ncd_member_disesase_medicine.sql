UPDATE ncd_member_disesase_medicine
SET start_date = diagnosed_on
WHERE start_date is null;