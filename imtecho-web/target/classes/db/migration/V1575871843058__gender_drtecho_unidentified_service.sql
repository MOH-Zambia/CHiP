alter table public.drtecho_unidentified_service_master
drop column if exists gender,
add column gender character varying(2);