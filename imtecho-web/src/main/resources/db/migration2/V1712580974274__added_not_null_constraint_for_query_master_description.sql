update query_master
set description = 'N/A'
where description is null;

alter table if exists query_master
alter column description
set not null;