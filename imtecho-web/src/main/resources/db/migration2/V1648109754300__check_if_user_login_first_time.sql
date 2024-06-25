alter table um_user
drop column if exists first_time_password_changed,
add column first_time_password_changed boolean default false;

DELETE FROM QUERY_MASTER WHERE CODE='check_if_user_login_first_time';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'332d6d22-5109-4446-8303-13e46381db36', 60512,  current_date , 60512,  current_date , 'check_if_user_login_first_time',
'userId',
'select first_time_password_changed as "firstTimePasswordChanged" from um_user where id = #userId#',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='update_first_login_user_personal_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'8e5e1e5c-c101-4479-b403-42b5c4eb4f38', 60512,  current_date , 60512,  current_date , 'update_first_login_user_personal_details',
'firstName,lastName,mobileNumber,userId',
'update um_user
set
first_time_password_changed = true
where id = #userId#;',
null,
false, 'ACTIVE');