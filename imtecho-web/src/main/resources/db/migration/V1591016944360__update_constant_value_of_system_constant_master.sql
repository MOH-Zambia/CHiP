UPDATE system_constant_master
SET VALUE = (
    CASE WHEN constant = 'HEPATITIS_B_1' THEN 'Hepatitis B 1'
     	 WHEN constant = 'HEPATITIS_B_2' THEN 'Hepatitis B 2'
     	 WHEN constant = 'HEPATITIS_B_3' THEN 'Hepatitis B 3'
     	 WHEN constant = 'HEPATITIS_A_1' THEN 'Hepatitis A 1'
     	 WHEN constant = 'HEPATITIS_A_2' THEN 'Hepatitis A 2'
    END
) WHERE constant IN (
        'HEPATITIS_B_1',
        'HEPATITIS_B_2',
        'HEPATITIS_B_3',
        'HEPATITIS_A_1',
        'HEPATITIS_A_2'
    );