
--

update menu_config
set feature_json = '{"canManageRegistration":false,"canManageTreatment":false,"canManageMedicines":false}'
where menu_name = 'Out-Patient Treatment (OPD)';
