-- Added rights for edit and print button
update menu_config set feature_json = '{"isShowReferredAdmissionTab":false,
"isShowSuspectAdmittedCasesTab":false,
"isShowConfirmedAdmittedCasesTab":false,
"isShowAdmitButton":false,
"isShowCheckUpButton":false,
"isShowDischargeButton":false,
"isShowNewAdmissionButton":false,
"isShowReferInTab":false,
"isShowReferOutTab":false,
"isShowReferInAdmitButton":false,
"isShowEditButton":false,
"isShowPrintButton":false}'
where navigation_state = 'techo.manage.covidAdmission';

