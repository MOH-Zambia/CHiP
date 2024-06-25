drop table if exists mobile_number_filter_master;

create table mobile_number_filter_master
(
    id serial primary key,
    mobile_number character varying(10) not null,
    type character varying(50) not null,
    reference_id integer
);

begin;
insert into mobile_number_filter_master(mobile_number,type,reference_id)
select contact_number,'USER',id
from um_user
where state = 'ACTIVE'
and contact_number is not null;

insert into system_configuration (system_key,is_active,key_value)
values ('LAST_EXECUTION_MOBILE_NUMBER_FILTER',true,cast(now() as text));
commit;