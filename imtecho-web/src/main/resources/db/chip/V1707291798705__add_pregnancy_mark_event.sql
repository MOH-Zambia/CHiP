INSERT INTO form_master(
created_by, created_on, modified_by, modified_on, code, name,state)
VALUES (1, now(), 1, now(), 'PREGNANCY_MARK', 'Pregnancy Mark', 'ACTIVE');

insert into mobile_form_details (form_name,file_name,created_on,created_by,modified_on,modified_by)
values ('STOCK_MANAGEMENT', 'STOCK_MANAGEMENT', now(), -1, now(), -1);

insert into mobile_form_feature_rel (form_id, mobile_constant)
select id, 'STOCK_MANAGEMENT' from mobile_form_details where form_name in ('STOCK_MANAGEMENT');

INSERT INTO public.listvalue_form_master(
           form_key, form, is_active, is_training_req, query_for_training_completed)
   VALUES ('STOCK_MANAGEMENT','Stock Management',TRUE,FALSE,null);


INSERT INTO listvalue_field_master(field_key, field, is_active, field_type, form)
VALUES ('listOfMedicines', 'listOfMedicines', true, 'T', 'STOCK_MANAGEMENT' );

insert into listvalue_field_form_relation (field, form_id)
select f.field, id
from
mobile_form_details mfm,
(
    values
        ('listOfMedicines')
) f(field)
where mfm.form_name = 'STOCK_MANAGEMENT';