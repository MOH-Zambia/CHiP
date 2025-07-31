INSERT INTO mobile_feature_master
(mobile_constant, feature_name, mobile_display_name, state, created_on, created_by, modified_on, modified_by)
VALUES('HELP_DESK', 'Help desk tool', 'Help Desk', 'ACTIVE', now(), -1, now(), -1);

insert into mobile_form_details(form_name,file_name,created_on,created_by,modified_on,modified_by)
values ('HELP_DESK', 'HELP_DESK', now(), -1, now(), -1);

insert into mobile_form_feature_rel (form_id, mobile_constant)
select id, 'HELP_DESK' from mobile_form_details where form_name = 'HELP_DESK';

INSERT INTO public.listvalue_form_master(
form_key, form, is_active, is_training_req, query_for_training_completed)
VALUES ('HELP_DESK','Help Desk',TRUE,FALSE,null);

INSERT INTO listvalue_field_master(field_key, field, is_active, field_type, form)
VALUES ('listOfIssueTypes', 'listOfIssueTypes', true, 'T', 'HELP_DESK' );

insert into listvalue_field_form_relation (field, form_id)
select f.field, id
from
mobile_form_details mfm,
(
values
('listOfIssueTypes')
) f(field)
where mfm.form_name = 'HELP_DESK';


drop table if exists help_desk_details;
create table help_desk_details (
id serial not null,
user_id int4 not null,
issue_type text not null,
module_type text,
other_module text,
issue_description text,
status text DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'COMPLETED')),
created_by int4 not null,
created_on timestamp not null,
modified_by int4 null,
modified_on timestamp null
);