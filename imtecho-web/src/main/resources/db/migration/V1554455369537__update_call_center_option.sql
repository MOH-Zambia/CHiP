update menu_config  
    set feature_json  = '{"canAbsentVerification":true,"canFamilyVerification":true,"canGvkImmunisationVerification":true,"canHighriskFollowupVerification":true,"canPregnancyRegistrationsVerification":true,"canHighriskFollowupVerificationFowFhw":false}'
        where navigation_state = 'techo.dashboard.gvkverification';