INSERT INTO public.listvalue_form_master(
           form_key, form, is_active, is_training_req, query_for_training_completed)
   VALUES ('CHIP_COVID_SCREENING','Covid Screening',TRUE,FALSE,null);


INSERT INTO listvalue_field_master(field_key, field, is_active, field_type, form)
VALUES ('listOfEffects', 'listOfEffects', true, 'T', 'CHIP_COVID_SCREENING' );

insert into listvalue_field_form_relation (field, form_id)
select f.field, id
from
mobile_form_details mfm,
(
    values
        ('listOfEffects')
) f(field)
where mfm.form_name = 'CHIP_COVID_SCREENING';

update system_configuration set key_value = '111' where system_key = 'MOBILE_FORM_VERSION';

update system_configuration set key_value = '1.0.16' where system_key = 'ANDROID_APP_VERSION';
update system_configuration set key_value = '21st March 2024' where system_key = 'ANDROID_APP_RELEASE_DATE';
update system_configuration set key_value = 'https://chipstaging.argusoft.com/imtecho-ui/mobileapp/chip/chip_app_116.apk' where system_key = 'ANDROID_APP_LINK';