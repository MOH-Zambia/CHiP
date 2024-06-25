update menu_config
set feature_json = '{"canAccessReferredForCovidLabTest":false,"canAccessApprovedForCovidLabTest":false,"canAccessReferredPatientsStatus":false}'
where menu_name = 'Covid2019 Suspect List';