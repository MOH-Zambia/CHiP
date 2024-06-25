update menu_config  
    set feature_json  = '{"canAbsentVerification":true,"canFamilyVerification":true, "canGvkImmunisationVerification":"true"}'
        where navigation_state = 'techo.dashboard.gvkverification';

UPDATE 
   user_menu_item
SET 
   feature_json = REPLACE(feature_json,'canAbsentVerication','canAbsentVerification')

