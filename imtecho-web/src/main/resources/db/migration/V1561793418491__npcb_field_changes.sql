ALTER TABLE npcb_member_screening_master 
DROP COLUMN IF EXISTS vision_lt_6_18,
DROP COLUMN IF EXISTS retinal_migraine,
DROP COLUMN IF EXISTS lines_able_to_see,
DROP COLUMN IF EXISTS observe_flashes_of_light,
ADD COLUMN lines_able_to_see text,
ADD COLUMN observe_flashes_of_light boolean;