ALTER TABLE mytecho_pregnant_woman_symptoms_master
DROP COLUMN IF EXISTS have_cough;
    
ALTER TABLE mytecho_pregnant_woman_symptoms_master
DROP COLUMN IF EXISTS burning_micturation;

ALTER TABLE mytecho_pregnant_woman_symptoms_master
DROP COLUMN IF EXISTS vaginal_whiteish_discharge;

ALTER TABLE mytecho_pregnant_woman_symptoms_master
DROP COLUMN IF EXISTS leaking_before_delivery;


ALTER TABLE mytecho_pregnant_woman_symptoms_master
DROP COLUMN IF EXISTS pale_eyes_palm;
----------------------------
ALTER TABLE mytecho_pregnant_woman_symptoms_master
DROP COLUMN IF EXISTS presence_of_cough,
ADD COLUMN presence_of_cough text;

ALTER TABLE mytecho_pregnant_woman_symptoms_master
DROP COLUMN IF EXISTS vision_disturbance,
ADD COLUMN vision_disturbance boolean;

ALTER TABLE mytecho_pregnant_woman_symptoms_master
DROP COLUMN IF EXISTS headache,
ADD COLUMN headache boolean;

ALTER TABLE mytecho_pregnant_woman_symptoms_master
DROP COLUMN IF EXISTS jaundice,
ADD COLUMN jaundice boolean;

ALTER TABLE mytecho_pregnant_woman_symptoms_master
DROP COLUMN IF EXISTS severe_joint_pain,
ADD COLUMN severe_joint_pain boolean;

ALTER TABLE mytecho_pregnant_woman_symptoms_master
DROP COLUMN IF EXISTS conjuctiva_and_palms_pale,
ADD COLUMN conjuctiva_and_palms_pale boolean;

ALTER TABLE mytecho_pregnant_woman_symptoms_master
DROP COLUMN IF EXISTS chills_or_rigours,
ADD COLUMN chills_or_rigours boolean;

ALTER TABLE mytecho_pregnant_woman_symptoms_master
DROP COLUMN IF EXISTS vaginal_discharge,
ADD COLUMN vaginal_discharge text;

ALTER TABLE mytecho_pregnant_woman_symptoms_master
DROP COLUMN IF EXISTS burning_urination,
ADD COLUMN burning_urination boolean;

ALTER TABLE mytecho_pregnant_woman_symptoms_master
DROP COLUMN IF EXISTS vomiting,
ADD COLUMN vomiting boolean;

ALTER TABLE mytecho_pregnant_woman_symptoms_master
DROP COLUMN IF EXISTS fever,
ADD COLUMN fever boolean;

ALTER TABLE mytecho_pregnant_woman_symptoms_master
DROP COLUMN IF EXISTS has_convulsion,
ADD COLUMN has_convulsion boolean;


-----------------------------------

ALTER TABLE mytecho_pregnant_woman_symptoms_master RENAME get_tired_household_work To short_of_breath_during_routing_householdwork;

ALTER TABLE mytecho_pregnant_woman_symptoms_master RENAME  swelling_on_face_hand_leg To swelling_on_face_hand_leg_feet;