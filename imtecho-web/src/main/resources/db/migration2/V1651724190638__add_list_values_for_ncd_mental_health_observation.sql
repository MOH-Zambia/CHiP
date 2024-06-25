insert into listvalue_field_form_relation (field, form_id)
select f.field, id
from
mobile_form_details mfm,
(
    values
        ('mentalHealthObservationList')
) f(field)
where mfm.form_name = 'NCD_FHW_MENTAL_HEALTH';

insert into listvalue_field_master (field_key,field,is_active,field_type,form,role_type)
values ('mentalHealthObservationList','mentalHealthObservationList',true,'T','NCD','A,F');

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Presence of behaviour related symptoms','mentalHealthObservationList','ndodiya',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Presence of communication related symptoms','mentalHealthObservationList','ndodiya',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Presence of feelings related symptoms','mentalHealthObservationList','ndodiya',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Presence of sense related symptoms','mentalHealthObservationList','ndodiya',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Difficulties in the own work','mentalHealthObservationList','ndodiya',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Difficulties in the social work','mentalHealthObservationList','ndodiya',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Other-faints, etc.','mentalHealthObservationList','ndodiya',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'No mental health issues','mentalHealthObservationList','ndodiya',now(),0);
