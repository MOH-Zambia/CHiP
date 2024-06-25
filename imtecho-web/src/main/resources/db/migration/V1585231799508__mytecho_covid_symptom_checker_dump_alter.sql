alter table mytecho_covid_symptom_checker_dump
drop column if exists mt_member_id,
add column mt_member_id integer;