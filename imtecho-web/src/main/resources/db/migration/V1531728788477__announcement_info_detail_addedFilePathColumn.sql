alter table announcement_info_detail
drop column if exists media_path, 
add column media_path character varying(200);