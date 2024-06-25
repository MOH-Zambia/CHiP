create table if not exists rch_data_migration 
(
  id bigserial NOT NULL,
  created_by bigint NOT NULL,
  created_on timestamp without time zone,
  modified_by bigint,
  modified_on timestamp without time zone,
  location_id bigint,
  executed_on date,
  state varchar(255),
  CONSTRAINT rch_data_migration_pkey PRIMARY KEY (id) 	
);

INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values 
('RCH Data Migration','manage',TRUE,'techo.manage.rchdatamigration','{}');

insert into query_master(created_by, created_on, modified_by, modified_on, code, params, query,returns_result_set,state)
values (1027,localtimestamp,null,null,'rch_data_migration_fetchlist','userId,locationId', 'select rdm.id,concat(us.first_name,'' '',us.last_name,''('',us.user_name,'')'') as "createdBy",rdm.created_on,
string_agg(lm1.name,''> '' order by lhcd1.depth desc) as location,to_char(rdm.executed_on,''DD/MM/YYYY'') as executed_on,
rdm.state 
from rch_data_migration rdm inner join location_hierchy_closer_det lhcd on
rdm.location_id = lhcd.child_id inner join location_master lm on lm.id = lhcd.child_id
inner join location_hierchy_closer_det lhcd1 on lhcd1.child_id = lhcd.child_id
inner join location_master lm1 on lm1.id = lhcd1.parent_id
inner join um_user us on rdm.created_by = us.id
where 
((#locationId# is not null and lhcd.parent_id = #locationId#) or 
(#locationId# is null and lhcd.parent_id in (select loc_id from um_user_location where state = ''ACTIVE'' and user_id = #userId#)))
group by lhcd1.child_id,rdm.id,us.first_name,us.last_name,us.user_name',true,'ACTIVE');

insert into query_master(created_by, created_on, modified_by, modified_on, code, params, query,returns_result_set,state)
values (1027,localtimestamp,null,null,'rch_data_migration_fetchdetails','locationId', 'select * from rch_data_migration where location_id = #locationId# and state = ''PENDING''
union
(select * from rch_data_migration where location_id = #locationId# and state = ''EXECUTED'' order by created_on desc limit 1)',true,'ACTIVE');

insert into query_master(created_by, created_on, modified_by, modified_on, code, params, query,returns_result_set,state)
values (1027,localtimestamp,null,null,'rch_data_migration_creation','locationId,user_id', 'INSERT INTO rch_data_migration(
            created_by, created_on, modified_by, modified_on, location_id, 
            executed_on, state)
values 
(#user_id#,localtimestamp,null,null,#locationId#,null,''PENDING'')',false,'ACTIVE');