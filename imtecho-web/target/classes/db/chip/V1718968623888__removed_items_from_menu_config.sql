DELETE FROM user_menu_item
WHERE menu_config_id IN (
    SELECT id FROM menu_config
    WHERE menu_name IN (
        'Consultant Followup Screen members',
        'MBBS MO Review Screen',
        'Manage PNC visit',
        'MO specialist patient list',
        'Cardiologist patient list',
        'Ophthalmologist patient list',
        'MO Review Screen',
        'MO Review followup Screen',
        'Family QR Code Generation',
        'Create Healthcare Professional ID',
        'Login Healthcare Professional ID',
        'Profile Healthcare Professional ID',
        'Register Health Facility',
        'Login Health Facility Registry',
        'Dashboard Health Facility Registry',
        'District Factsheet',
        'Web Tasks',
        'Upload Location',
        'System Code Management Tool',
        'Manage Feature Syncing',
        'Sync Server Management',
        'Upload User',
        'GVK : Call Effectiveness Reports',
        'Server Management',
        'GVK Successful Call Dashboard',
        'JE Vaccine Due List',
        'Feature Usage Analytics',
        'Performance Dashboard',
        'Generate Dynamic Template',
        'JE Vaccine Offline Entry',
        'Auto Schedule Appointments',
        'Manage On-Spot CoWIN Slots',
        'Survey for Indradhanush',
        'Create And Link Abha Number',
        'Duplicate Aadhaar Verification',
        'HIU Consent list',
        'Manage Health Infrastructure'

    )
);


DELETE FROM menu_config
WHERE menu_name IN (
    'Consultant Followup Screen members',
    'MBBS MO Review Screen',
    'Manage PNC visit',
    'MO specialist patient list',
    'Cardiologist patient list',
    'Ophthalmologist patient list',
    'MO Review Screen',
    'MO Review followup Screen',
    'Family QR Code Generation',
    'Create Healthcare Professional ID',
    'Login Healthcare Professional ID',
    'Profile Healthcare Professional ID',
    'Register Health Facility',
    'Login Health Facility Registry',
    'Dashboard Health Facility Registry',
    'District Factsheet',
    'Web Tasks',
    'Upload Location',
    'System Code Management Tool',
    'Manage Feature Syncing',
    'Sync Server Management',
    'Upload User',
    'GVK : Call Effectiveness Reports',
    'Server Management',
    'GVK Successful Call Dashboard',
    'JE Vaccine Due List',
    'Feature Usage Analytics',
    'Performance Dashboard',
    'Generate Dynamic Template',
    'JE Vaccine Offline Entry',
    'Auto Schedule Appointments',
    'Manage On-Spot CoWIN Slots',
    'Survey for Indradhanush',
    'Create And Link Abha Number',
    'Duplicate Aadhaar Verification',
    'HIU Consent list',
    'Manage Health Infrastructure'

);



