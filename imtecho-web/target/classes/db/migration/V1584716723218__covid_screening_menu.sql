alter table covid_travellers_info
drop column if exists remarks,
add column remarks text;

insert into menu_config
(group_id,active,menu_name,navigation_state,menu_type)
values
((select id from menu_group where group_name='COVID-19'),true,'Covid Travellers Screening','techo.manage.covidtravellers','manage');