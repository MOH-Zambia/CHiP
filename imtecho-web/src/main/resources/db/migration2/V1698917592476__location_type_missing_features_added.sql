create table if not exists audit_deleted_rows (
   table_id smallint,
   identifier text,
   row_details jsonb,
   deleted_at timestamp without time zone default now()
) partition by list (table_id);

create table if not exists audit_registered_rows (
    id serial,
    table_name text primary key,
    pk_name text[]
);

create or replace function capture_deleted_rows()
returns trigger as $$
declare
    t_id smallint;
    t_pk text[];
    concatenated_value text := '';
    pk_value text;
begin
    select id, pk_name from audit_registered_rows where table_name = tg_table_name into t_id, t_pk;

    if t_pk is null then
        insert into audit_deleted_rows (table_id, identifier, row_details)
        select t_id, old.id, to_jsonb(old);
    else
        for i in 1..array_length(t_pk, 1) loop
            execute format('select $1.%s', t_pk[i]) using old into pk_value;
            concatenated_value := concatenated_value || pk_value;

            if i < array_length(t_pk, 1) then
                concatenated_value := concatenated_value || '::';
            end if;
        end loop;

        insert into audit_deleted_rows (table_id, identifier, row_details)
        select t_id, concatenated_value, to_jsonb(old);
    end if;
return null;
end;
$$ language plpgsql;

create or replace function audit_register_for_delete(table_n text, pk_n text[] default null)
returns void as $$
declare
    table_id smallint;
begin

    insert into audit_registered_rows (table_name, pk_name)
    values (table_n, pk_n)
    on conflict (table_name) do update
    set pk_name = excluded.pk_name;

    select id from audit_registered_rows where table_name = table_n into table_id;

    execute ('create table if not exists audit_deleted_rows_' || table_id || ' partition of audit_deleted_rows for values in ('|| table_id ||')');

    if not exists (
        select 1 from pg_trigger
        where tgname = 'track_deleted_rows'
        and tgrelid = table_n::regclass
    ) then
    execute format(' create trigger track_deleted_rows
        after delete on %s
        for each row execute function capture_deleted_rows();', table_n);
    else
        raise notice 'The trigger already exists';
    end if;
end;
$$ language plpgsql;

select audit_register_for_delete('um_user_location');
select audit_register_for_delete('location_master');
select audit_register_for_delete('location_level_hierarchy_master');
select audit_register_for_delete('location_hierchy_closer_det');

CREATE TABLE if not exists public.location_type_role_rights_details (
	location_type text NOT NULL,
	role_id int4 NOT NULL,
	can_add bool NULL,
	can_update bool NULL,
	can_delete bool NULL,
	CONSTRAINT location_role_rights_config_pkey PRIMARY KEY (location_type, role_id)
);

CREATE TABLE if not exists public.location_type_child_parent_mapping (
	id serial4 NOT NULL,
	child_loc_type varchar(20) NULL,
	parent_loc_type varchar(20) NULL,
	state varchar(30) NULL,
	created_on timestamp NULL,
	modified_on timestamp NULL,
	CONSTRAINT location_type_child_parent_mapping_pkey PRIMARY KEY (id),
	CONSTRAINT location_type_child_parent_mapping_unique_key UNIQUE (child_loc_type, parent_loc_type)
);

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_location_type_by_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'56c03b5a-cd2d-4764-b123-31fd89634efc', 97632,  current_date , 97632,  current_date , 'retrieve_location_type_by_id',
'id',
'with type_details as (
	select id as "id",
	type as "type",
	name as "name",
	level as "level",
	is_soh_enable as "isSohEnable",
	is_active as "isActive"
	from location_type_master
	where id = cast(#id# as integer)
),rights_details as (
	select location_type_role_rights_details.location_type,
	string_agg(case when can_add then cast(role_id as text) else null end,'','') as can_add,
	string_agg(case when can_update then cast(role_id as text) else null end, '','') as can_update,
	string_agg(case when can_delete then cast(role_id as text) else null end, '','') as can_delete
	from type_details
	inner join location_type_role_rights_details on type_details.type = location_type_role_rights_details.location_type
	group by location_type_role_rights_details.location_type
),
parent_details as(
	select td.type,string_agg(distinct parent_loc_type,'','') as parent from location_type_child_parent_mapping ltcpm right join type_details td
	on td.type = ltcpm.child_loc_type and ltcpm.state=''ACTIVE'' group by td.type
)select type_details.*,
rights_details.can_add as "canAdd",
rights_details.can_update as "canUpdate",
rights_details.can_delete as "canDelete",
parent_details.parent as "parent"
from type_details
left join rights_details on type_details.type = rights_details.location_type
left join parent_details on parent_details.type = type_details.type',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='update_location_type';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'4321cba3-50e7-40b0-8786-483438d77aa0', 97632,  current_date , 97632,  current_date , 'update_location_type',
'parent,canUpdate,level,name,canAdd,isSohEnable,canDelete,loggedInUserId,id,type',
'update location_type_master
set type = #type#,
name = #name#,
level = #level#,
is_soh_enable  = #isSohEnable#,
modified_by = #loggedInUserId#,
modified_on = now()
where id = #id#;

update location_type_role_rights_details
set can_add = false,
can_update = false,
can_delete=false
where location_type = #type#;

insert into location_type_role_rights_details
(location_type,role_id,can_add)
values(#type#,cast(unnest(string_to_array(#canAdd#,'','')) as integer),true)
on conflict on constraint location_role_rights_config_pkey
do update
set can_add = true;

insert into location_type_role_rights_details
(location_type,role_id,can_update)
values(#type#,cast(unnest(string_to_array(#canUpdate#,'','')) as integer),true)
on conflict on constraint location_role_rights_config_pkey
do update
set can_update = true;

insert into location_type_role_rights_details
(location_type,role_id,can_delete)
values(#type#,cast(unnest(string_to_array(#canDelete#,'','')) as integer),true)
on conflict on constraint location_role_rights_config_pkey
do update
set can_delete = true;

update location_type_child_parent_mapping
set state = ''INACTIVE'',modified_on = now()
where child_loc_type = #type# and parent_loc_type not in (#parent#);

insert into location_type_child_parent_mapping
(child_loc_type,parent_loc_type,state,created_on,modified_on)
values(#type#,unnest(string_to_array(#parent#,'','')),''ACTIVE'',now(),now())
on conflict on constraint location_type_child_parent_mapping_unique_key
do update
set state = ''ACTIVE'';',
null,
false, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='create_location_type';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'386799aa-1e30-4ae7-ab6f-93cdd9ce6042', 97632,  current_date , 97632,  current_date , 'create_location_type',
'parent,canUpdate,level,name,canAdd,isSohEnable,canDelete,loggedInUserId,type',
'insert into location_type_master
(type,name,level,is_soh_enable,is_active,created_by,created_on,modified_by,modified_on)
values (#type#,#name#,#level#,#isSohEnable#,true,#loggedInUserId#,now(),#loggedInUserId#,now());

update location_type_role_rights_details
set can_add = false,
can_update = false,
can_delete=false
where location_type = #type#;

insert into location_type_role_rights_details
(location_type,role_id,can_add)
values(#type#,cast(unnest(string_to_array(#canAdd#,'','')) as integer),true)
on conflict on constraint location_role_rights_config_pkey
do update
set can_add = true;

insert into location_type_role_rights_details
(location_type,role_id,can_update)
values(#type#,cast(unnest(string_to_array(#canUpdate#,'','')) as integer),true)
on conflict on constraint location_role_rights_config_pkey
do update
set can_update = true;

insert into location_type_role_rights_details
(location_type,role_id,can_update)
values(#type#,cast(unnest(string_to_array(#canDelete#,'','')) as integer),true)
on conflict on constraint location_role_rights_config_pkey
do update
set can_delete = true;


update location_type_child_parent_mapping
set state = ''INACTIVE'',modified_on = now()
where child_loc_type = #type# and parent_loc_type not in (#parent#);

insert into location_type_child_parent_mapping
(child_loc_type,parent_loc_type,state,created_on,modified_on)
values(#type#,unnest(string_to_array(#parent#,'','')),''ACTIVE'',now(),now())
on conflict on constraint location_type_child_parent_mapping_unique_key
do update
set state = ''ACTIVE'';',
null,
false, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_location_types_rights_by_role_action';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'f6cc9bc1-b69c-4aba-91fc-9e1fb291cc7f', 97091,  current_date , 97091,  current_date , 'retrieve_location_types_rights_by_role_action',
'roleId,action',
'select location_type
from location_type_role_rights_details
where role_id = #roleId#
and case when #action# = ''canAdd'' then can_add
		 when #action# = ''canUpdate'' then can_update
		 when #action# = ''canDelete'' then can_delete
		 else false end',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='is_child_locations_available';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'b8fafdd7-1b92-4a94-9c5a-b284a97d06bb', 97091,  current_date , 97091,  current_date , 'is_child_locations_available',
'location_id',
'select distinct child_id as loc_id from location_hierchy_closer_det
	where parent_id in (
		select id from location_master where id = #location_id#
)',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='get_locations_usages_places_for_delete_location';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'a9b1931f-975f-427a-bfa6-0244eee86bb8', 60512,  current_date , 60512,  current_date , 'get_locations_usages_places_for_delete_location',
'location_id',
'with loc_to_delete as (
	select id as loc_id, "type" from location_master where id = #location_id#
), active_user_loc as (
	select count(*) as total  from loc_to_delete
	inner join um_user_location ul on ul.loc_id = loc_to_delete.loc_id and ul.state = ''ACTIVE''
	inner join um_user u on u.id = ul.user_id and u.state = ''ACTIVE''
),family_exists_on_loc as (
	select count(*) as total  from loc_to_delete
	inner join imt_family if2 on if2.area_id = loc_to_delete.loc_id or if2.location_id = loc_to_delete.loc_id
),
 migrated_in_member_exists as (
	select count(*) as total from migration_master mm,imt_member mem where
	mm.member_id = mem.id and mem.basic_state in (''NEW'',''VERIFIED'',''TEMPORARY'') and mm.state = ''REPORTED'' and
	location_migrated_to in (select loc_id from loc_to_delete)
),
 health_infra_exists as (
 	select count(*) as total from health_infrastructure_details  where
 	location_id in (select loc_id from loc_to_delete) and state = ''ACTIVE''
 )
select
(select total from active_user_loc) as "Active User",
(select total from family_exists_on_loc) as "Available Family",
(select total from migrated_in_member_exists) as "Migrated Member",
(select total from health_infra_exists) as "Active Health Infrastructure"',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='delete_location_by_location_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'28cc8665-8146-479e-bbb0-e4a36a99dc43', 60512,  current_date , 60512,  current_date , 'delete_location_by_location_id',
'location_id',
'begin;

delete from um_user_location
where loc_id = #location_id#
and state = ''ACTIVE'';

update location_master
set parent = null,
location_hierarchy_id = null
where id = #location_id#
and state = ''ACTIVE'';

delete from location_level_hierarchy_master
where location_id = #location_id#;

delete from location_hierchy_closer_det
where child_id = #location_id#;

delete from location_hierchy_closer_det
where parent_id = #location_id#;

delete from location_master
where id = #location_id#;

commit;',
null,
false, 'ACTIVE');

-- dynamic form configurations

insert into system_constraint_form_master(uuid, form_name, form_code, menu_config_id, web_state, created_by, created_on, modified_by, modified_on, mobile_state)
                    values (cast('c6ee39bb-3a99-4e7f-9695-0e301f48c3e1' as uuid), 'MANAGE_LOCATION_TYPE', 'MANAGE_LOCATION_TYPE', 340, 'ACTIVE', null,now(),null,now(), null)
                    on conflict(uuid) do nothing;

with field_value_master_deletion as (
                        delete from system_constraint_field_value_master
                        where field_master_uuid in (
                            select uuid
                            from system_constraint_field_master
                            where form_master_uuid = (select uuid from system_constraint_form_master where form_code = 'MANAGE_LOCATION_TYPE')
                        )
                        returning uuid
                    )
                    delete from system_constraint_field_master
                    where form_master_uuid = (select uuid from system_constraint_form_master where form_code = 'MANAGE_LOCATION_TYPE');



insert into system_constraint_field_master(uuid,form_master_uuid,field_key,field_name,field_type,ng_model,app_name,standard_field_master_uuid,created_by,created_on,modified_by,modified_on)
                         values(cast('54ec539b-87f7-4cff-8a4d-25b594ae7b33' as uuid),(select uuid from system_constraint_form_master where form_code = 'MANAGE_LOCATION_TYPE'),'level','level','NUMBER','formData','WEB',null,60512,now(),60512,now());

delete from internationalization_label_master where key = 'level_MANAGE_LOCATION_TYPE' and app_name in ('WEB');

insert into internationalization_label_master(country,key,language,created_by,created_on,custom3b,text,translation_pending,modified_on,app_name)
                                values('IN','level_MANAGE_LOCATION_TYPE','EN','60512',now(),false,'Level',false,now(),'WEB');

insert into system_constraint_field_master(uuid,form_master_uuid,field_key,field_name,field_type,ng_model,app_name,standard_field_master_uuid,created_by,created_on,modified_by,modified_on)
                         values(cast('83bdc207-b348-4c3e-8663-057f40a8555f' as uuid),(select uuid from system_constraint_form_master where form_code = 'MANAGE_LOCATION_TYPE'),'type','type','SHORT_TEXT','formData','WEB',null,60512,now(),60512,now());

delete from internationalization_label_master where key = 'type_MANAGE_LOCATION_TYPE' and app_name in ('WEB');

insert into internationalization_label_master(country,key,language,created_by,created_on,custom3b,text,translation_pending,modified_on,app_name)
                                values('IN','type_MANAGE_LOCATION_TYPE','EN','60512',now(),false,'Type',false,now(),'WEB');

insert into system_constraint_field_master(uuid,form_master_uuid,field_key,field_name,field_type,ng_model,app_name,standard_field_master_uuid,created_by,created_on,modified_by,modified_on)
                         values(cast('dd871df3-3b25-407e-a3a5-bc49c580e638' as uuid),(select uuid from system_constraint_form_master where form_code = 'MANAGE_LOCATION_TYPE'),'name','name','SHORT_TEXT','formData','WEB',null,60512,now(),60512,now());

delete from internationalization_label_master where key = 'name_MANAGE_LOCATION_TYPE' and app_name in ('WEB');

insert into internationalization_label_master(country,key,language,created_by,created_on,custom3b,text,translation_pending,modified_on,app_name)
                                values('IN','name_MANAGE_LOCATION_TYPE','EN','60512',now(),false,'Name',false,now(),'WEB');

insert into system_constraint_field_master(uuid,form_master_uuid,field_key,field_name,field_type,ng_model,app_name,standard_field_master_uuid,created_by,created_on,modified_by,modified_on)
                         values(cast('e50c34f9-3b7f-418a-bed3-ec6ea03f541f' as uuid),(select uuid from system_constraint_form_master where form_code = 'MANAGE_LOCATION_TYPE'),'isSohEnable','isSohEnable','CHECKBOX','formData','WEB',null,60512,now(),60512,now());

delete from internationalization_label_master where key = 'isSohEnable_MANAGE_LOCATION_TYPE' and app_name in ('WEB');

insert into internationalization_label_master(country,key,language,created_by,created_on,custom3b,text,translation_pending,modified_on,app_name)
                                values('IN','isSohEnable_MANAGE_LOCATION_TYPE','EN','60512',now(),false,'Is SOH Enable',false,now(),'WEB');

insert into system_constraint_field_master(uuid,form_master_uuid,field_key,field_name,field_type,ng_model,app_name,standard_field_master_uuid,created_by,created_on,modified_by,modified_on)
                         values(cast('dee2daad-1d09-44a7-9dda-837c4a2ef384' as uuid),(select uuid from system_constraint_form_master where form_code = 'MANAGE_LOCATION_TYPE'),'canAdd','canAdd','DROPDOWN','formData','WEB',null,60512,now(),60512,now());

delete from internationalization_label_master where key = 'canAdd_MANAGE_LOCATION_TYPE' and app_name in ('WEB');

insert into internationalization_label_master(country,key,language,created_by,created_on,custom3b,text,translation_pending,modified_on,app_name)
                                values('IN','canAdd_MANAGE_LOCATION_TYPE','EN','60512',now(),false,'Can Add',false,now(),'WEB');

insert into system_constraint_field_master(uuid,form_master_uuid,field_key,field_name,field_type,ng_model,app_name,standard_field_master_uuid,created_by,created_on,modified_by,modified_on)
                         values(cast('d968b709-2d60-4781-992f-cd380824ba36' as uuid),(select uuid from system_constraint_form_master where form_code = 'MANAGE_LOCATION_TYPE'),'canUpdate','canUpdate','DROPDOWN','formData','WEB',null,60512,now(),60512,now());

delete from internationalization_label_master where key = 'canUpdate_MANAGE_LOCATION_TYPE' and app_name in ('WEB');

insert into internationalization_label_master(country,key,language,created_by,created_on,custom3b,text,translation_pending,modified_on,app_name)
                                values('IN','canUpdate_MANAGE_LOCATION_TYPE','EN','60512',now(),false,'Can Update',false,now(),'WEB');

insert into system_constraint_field_master(uuid,form_master_uuid,field_key,field_name,field_type,ng_model,app_name,standard_field_master_uuid,created_by,created_on,modified_by,modified_on)
                         values(cast('894a1343-a514-476b-9650-8f3c7bf65cb6' as uuid),(select uuid from system_constraint_form_master where form_code = 'MANAGE_LOCATION_TYPE'),'canDelete','canDelete','DROPDOWN','formData','WEB',null,60512,now(),60512,now());

delete from internationalization_label_master where key = 'canDelete_MANAGE_LOCATION_TYPE' and app_name in ('WEB');

insert into internationalization_label_master(country,key,language,created_by,created_on,custom3b,text,translation_pending,modified_on,app_name)
                                values('IN','canDelete_MANAGE_LOCATION_TYPE','EN','60512',now(),false,'Can Delete',false,now(),'WEB');

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('8b3cc940-99c3-49cd-b4e7-95d54e766e02' as uuid),cast('83bdc207-b348-4c3e-8663-057f40a8555f' as uuid),'REQUIRABLE','requirable',null,'null',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('afcc2a6e-bd5e-4ba1-9167-9b7d12b13526' as uuid),cast('83bdc207-b348-4c3e-8663-057f40a8555f' as uuid),'DISABILITY','disability',null,'null',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('afeab0bd-a702-483f-a28f-6498ce6e5876' as uuid),cast('83bdc207-b348-4c3e-8663-057f40a8555f' as uuid),'EVENTS','events',null,'[{"0":{"type":"","value":""},"$$hashKey":"object:1226","type":"Change","value":"typeChanged"}]',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('c19a8be7-f794-46a9-bf07-b27a4954cf5d' as uuid),cast('83bdc207-b348-4c3e-8663-057f40a8555f' as uuid),'BOOLEAN','isHidden',null,'false',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('d857c779-89ba-4dd9-a9d8-f1db8efebacc' as uuid),cast('83bdc207-b348-4c3e-8663-057f40a8555f' as uuid),'TEXT','requiredMessage',null,'Please enter location type',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('045d956b-2248-4e79-a0f0-e64b28ea8f28' as uuid),cast('83bdc207-b348-4c3e-8663-057f40a8555f' as uuid),'NUMBER','minLength',null,'1',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('08464c0d-8b74-414f-97f6-4f0f020a2d59' as uuid),cast('83bdc207-b348-4c3e-8663-057f40a8555f' as uuid),'BOOLEAN','isRequired',null,'true',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('0a0b204d-b87e-4d9a-848b-0286999c939c' as uuid),cast('83bdc207-b348-4c3e-8663-057f40a8555f' as uuid),'VISIBILITY','visibility',null,'null',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('29df6ec0-4985-4437-b905-51a9e49dcb0e' as uuid),cast('83bdc207-b348-4c3e-8663-057f40a8555f' as uuid),'TEXT','placeholder',null,'Type',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('2df823f9-6a0f-49bc-ae22-864f4ae0dbb9' as uuid),cast('83bdc207-b348-4c3e-8663-057f40a8555f' as uuid),'NUMBER','maxLength',null,'10',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('339b451d-db6a-4637-8bd4-fd3ae011eb20' as uuid),cast('83bdc207-b348-4c3e-8663-057f40a8555f' as uuid),'BOOLEAN','hasPattern',null,'false',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('675159ad-1c62-4e6d-9c7f-a751e5f35bb0' as uuid),cast('83bdc207-b348-4c3e-8663-057f40a8555f' as uuid),'BOOLEAN','isDisabled',null,'false',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('35e0411b-1b14-44f0-b3f1-1461842ca998' as uuid),cast('dd871df3-3b25-407e-a3a5-bc49c580e638' as uuid),'BOOLEAN','isHidden',null,'false',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('3f0e6a37-d51c-4850-ad3c-b4945dcb8089' as uuid),cast('dd871df3-3b25-407e-a3a5-bc49c580e638' as uuid),'TEXT','placeholder',null,'Name',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('81544fcf-79aa-403b-8a4d-66ac4946d4d5' as uuid),cast('54ec539b-87f7-4cff-8a4d-25b594ae7b33' as uuid),'TEXT','label',null,'level_MANAGE_LOCATION_TYPE',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('17154eb0-5024-4663-9996-fe836b15022b' as uuid),cast('54ec539b-87f7-4cff-8a4d-25b594ae7b33' as uuid),'TEXT','tooltip',null,'Level',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('8a338cdd-27bc-45ae-adf9-32f553e3a5b5' as uuid),cast('54ec539b-87f7-4cff-8a4d-25b594ae7b33' as uuid),'BOOLEAN','isHidden',null,'false',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('0f9105bb-788a-4658-937c-5acededa8c5c' as uuid),cast('54ec539b-87f7-4cff-8a4d-25b594ae7b33' as uuid),'TEXT','placeholder',null,'Level',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('be5703ef-b7a2-48d4-875d-f564d6775c7a' as uuid),cast('54ec539b-87f7-4cff-8a4d-25b594ae7b33' as uuid),'BOOLEAN','isRequired',null,'true',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('b92f6092-a684-477c-b549-a2d19f4813e7' as uuid),cast('54ec539b-87f7-4cff-8a4d-25b594ae7b33' as uuid),'TEXT','requiredMessage',null,'Please enter location level',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('396c448d-dcba-45b0-a476-cae225bf304d' as uuid),cast('54ec539b-87f7-4cff-8a4d-25b594ae7b33' as uuid),'BOOLEAN','isDisabled',null,'false',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('c0242e5b-5e94-4dcb-a424-f2dda169f366' as uuid),cast('54ec539b-87f7-4cff-8a4d-25b594ae7b33' as uuid),'NUMBER','min',null,'0',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('f17ae3c2-6385-47d6-82c3-adb0e8022e02' as uuid),cast('54ec539b-87f7-4cff-8a4d-25b594ae7b33' as uuid),'NUMBER','max',null,'15',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('4ecaf518-9a04-41bc-b5b7-b13f65bc3222' as uuid),cast('54ec539b-87f7-4cff-8a4d-25b594ae7b33' as uuid),'BOOLEAN','hasPattern',null,'true',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('48edee17-8894-4897-912b-83b58381aa79' as uuid),cast('54ec539b-87f7-4cff-8a4d-25b594ae7b33' as uuid),'TEXT','pattern',null,'^[0-9]*$',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('c8b5b8ad-9cd3-4f9f-b92f-8e859f6ebd10' as uuid),cast('54ec539b-87f7-4cff-8a4d-25b594ae7b33' as uuid),'TEXT','patternMessage',null,'Please enter valid level',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('8f876e6a-a44f-47d3-bd32-07033f475820' as uuid),cast('54ec539b-87f7-4cff-8a4d-25b594ae7b33' as uuid),'EVENTS','events',null,'[]',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('c21a0ee4-3071-4e46-9695-0ed3fea30ac7' as uuid),cast('54ec539b-87f7-4cff-8a4d-25b594ae7b33' as uuid),'VISIBILITY','visibility',null,'{}',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('7b27b6b7-4dc9-45d9-ab83-80cddd262922' as uuid),cast('54ec539b-87f7-4cff-8a4d-25b594ae7b33' as uuid),'REQUIRABLE','requirable',null,'{}',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('c028aace-fd84-4d27-b84e-20849bbb2eea' as uuid),cast('54ec539b-87f7-4cff-8a4d-25b594ae7b33' as uuid),'DISABILITY','disability',null,'{}',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('26eb0976-8a5a-49fe-b1f2-753412a0b74a' as uuid),cast('83bdc207-b348-4c3e-8663-057f40a8555f' as uuid),'TEXT','tooltip',null,'Type',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('710ce0ed-25b4-4d86-8c8c-69dfc8b8d613' as uuid),cast('83bdc207-b348-4c3e-8663-057f40a8555f' as uuid),'TEXT','label',null,'type_MANAGE_LOCATION_TYPE',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('9089ada1-5baa-4b65-b4a1-a9885a8e791a' as uuid),cast('dd871df3-3b25-407e-a3a5-bc49c580e638' as uuid),'TEXT','label',null,'name_MANAGE_LOCATION_TYPE',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('a3380872-5f31-4471-8581-b8f16c37d185' as uuid),cast('dd871df3-3b25-407e-a3a5-bc49c580e638' as uuid),'VISIBILITY','visibility',null,'null',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('a3acc99a-db8f-42f7-a58f-c8f142cc6932' as uuid),cast('dd871df3-3b25-407e-a3a5-bc49c580e638' as uuid),'NUMBER','minLength',null,'1',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('aead89db-c03c-49a9-9ba2-1cc2af8cba61' as uuid),cast('dd871df3-3b25-407e-a3a5-bc49c580e638' as uuid),'TEXT','tooltip',null,'Name',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('c5569ed5-47f1-4d89-a86e-18ad4996d082' as uuid),cast('dd871df3-3b25-407e-a3a5-bc49c580e638' as uuid),'TEXT','requiredMessage',null,'Please enter location name',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('d8e3de4e-3926-4b96-aff4-375f0f3ba330' as uuid),cast('dd871df3-3b25-407e-a3a5-bc49c580e638' as uuid),'BOOLEAN','hasPattern',null,'false',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('e56555c8-acde-4851-bc13-a321d985c593' as uuid),cast('dd871df3-3b25-407e-a3a5-bc49c580e638' as uuid),'EVENTS','events',null,'[{"0":{"type":"","value":""},"$$hashKey":"object:1447","type":"Change","value":"nameChanged"}]',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('ea2799e2-5764-4d2a-8b38-caab58d407e2' as uuid),cast('dd871df3-3b25-407e-a3a5-bc49c580e638' as uuid),'NUMBER','maxLength',null,'20',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('028ef3a2-69c9-4a6a-bc6e-77d2b9d285c2' as uuid),cast('dd871df3-3b25-407e-a3a5-bc49c580e638' as uuid),'BOOLEAN','isRequired',null,'true',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('051ecfb5-deb1-44e9-a931-226778f22891' as uuid),cast('dd871df3-3b25-407e-a3a5-bc49c580e638' as uuid),'BOOLEAN','isDisabled',null,'false',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('30e7e0d5-ad04-4716-ba92-4d0af362dfe4' as uuid),cast('dd871df3-3b25-407e-a3a5-bc49c580e638' as uuid),'DISABILITY','disability',null,'null',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('824b2219-5398-469e-8340-aaa1a83cb17e' as uuid),cast('e50c34f9-3b7f-418a-bed3-ec6ea03f541f' as uuid),'EVENTS','events',null,'null',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('93f181a7-4012-45b1-88fb-1ca789eca9c8' as uuid),cast('e50c34f9-3b7f-418a-bed3-ec6ea03f541f' as uuid),'TEXT','tooltip',null,'Is SOH Enable',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('a252c66a-0bec-4322-b67c-bb1d94b105ad' as uuid),cast('e50c34f9-3b7f-418a-bed3-ec6ea03f541f' as uuid),'JSON','staticOptions',null,'[{"key":"isSohEnable","value":"isSohEnable"}]',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('a4fa1da4-bafd-49c8-8837-e228072a8216' as uuid),cast('e50c34f9-3b7f-418a-bed3-ec6ea03f541f' as uuid),'BOOLEAN','isDisabled',null,'false',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('b06be97f-9fcb-4416-b7d7-2eb528ec47ca' as uuid),cast('e50c34f9-3b7f-418a-bed3-ec6ea03f541f' as uuid),'TEXT','label',null,'isSohEnable_MANAGE_LOCATION_TYPE',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('cc96f74d-d220-4377-9a62-0143d24abb43' as uuid),cast('e50c34f9-3b7f-418a-bed3-ec6ea03f541f' as uuid),'VISIBILITY','visibility',null,'null',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('dd152ec7-fa81-4ef9-a1cb-f271571e1cc3' as uuid),cast('e50c34f9-3b7f-418a-bed3-ec6ea03f541f' as uuid),'TEXT','requiredMessage',null,'Please select is SOH Enable',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('3e35bc02-9c31-432b-9fa9-0666f521642f' as uuid),cast('e50c34f9-3b7f-418a-bed3-ec6ea03f541f' as uuid),'TEXT','placeholder',null,'Is SOH Enable',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('48f45f0d-9e24-47a3-acaf-c8d6a6c9d802' as uuid),cast('e50c34f9-3b7f-418a-bed3-ec6ea03f541f' as uuid),'BOOLEAN','isRequired',null,'false',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('5c20eebb-1662-426b-a098-649dd610d759' as uuid),cast('e50c34f9-3b7f-418a-bed3-ec6ea03f541f' as uuid),'REQUIRABLE','requirable',null,'null',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('61138af1-a030-4118-a760-73c034c53ef7' as uuid),cast('e50c34f9-3b7f-418a-bed3-ec6ea03f541f' as uuid),'BOOLEAN','isHidden',null,'false',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('6bee492e-120a-403a-a1e7-2784fca1aca3' as uuid),cast('e50c34f9-3b7f-418a-bed3-ec6ea03f541f' as uuid),'DISABILITY','disability',null,'null',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('7479bb3e-a7e8-4639-9fee-53bf6c3e42bc' as uuid),cast('dd871df3-3b25-407e-a3a5-bc49c580e638' as uuid),'REQUIRABLE','requirable',null,'null',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('94f7620c-f623-44c4-abed-4f1e426b707e' as uuid),cast('dee2daad-1d09-44a7-9dda-837c4a2ef384' as uuid),'BOOLEAN','isHidden',null,'false',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('88df4287-5ed7-49e4-a033-f129a5f7a0ab' as uuid),cast('d968b709-2d60-4781-992f-cd380824ba36' as uuid),'BOOLEAN','isHidden',null,'false',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('8e65e38a-4d6f-49ca-9b89-17fe19379c7f' as uuid),cast('d968b709-2d60-4781-992f-cd380824ba36' as uuid),'BOOLEAN','additionalStaticOptionsRequired',null,'false',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('93bfafb9-030e-4c93-9324-3f9b94bfa0cf' as uuid),cast('d968b709-2d60-4781-992f-cd380824ba36' as uuid),'TEXT','label',null,'canUpdate_MANAGE_LOCATION_TYPE',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('aa4eb321-8b5c-40a0-8aab-bfbab19fdff8' as uuid),cast('d968b709-2d60-4781-992f-cd380824ba36' as uuid),'TEXT','tooltip',null,'Can Update',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('bf1fb794-2dd2-4990-a763-f8e02876fb64' as uuid),cast('d968b709-2d60-4781-992f-cd380824ba36' as uuid),'EVENTS','events',null,'null',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('dabc2e67-5ed1-4fd5-96c8-0f7d8b2e6d5c' as uuid),cast('d968b709-2d60-4781-992f-cd380824ba36' as uuid),'DROPDOWN','optionsType',null,'queryBuilder',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('f9dcf592-80d0-4cb2-b267-3126c48579a9' as uuid),cast('d968b709-2d60-4781-992f-cd380824ba36' as uuid),'TEXT','requiredMessage',null,'Please select an option',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('fe7fe861-3762-47d7-a488-2768435f01d5' as uuid),cast('d968b709-2d60-4781-992f-cd380824ba36' as uuid),'TEXT','placeholder',null,'Select roles which can update this location',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('0225f038-6a31-4181-814b-3c64a81a4866' as uuid),cast('d968b709-2d60-4781-992f-cd380824ba36' as uuid),'BOOLEAN','isDisabled',null,'false',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('0ef11114-2e67-4738-93c6-b99bb1145bd7' as uuid),cast('d968b709-2d60-4781-992f-cd380824ba36' as uuid),'VISIBILITY','visibility',null,'null',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('167ddc92-96ee-43b0-93a2-25b2ea0b263a' as uuid),cast('d968b709-2d60-4781-992f-cd380824ba36' as uuid),'DISABILITY','disability',null,'null',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('1f49ec58-79a3-43e0-81c7-240c66a5254e' as uuid),cast('d968b709-2d60-4781-992f-cd380824ba36' as uuid),'REQUIRABLE','requirable',null,'null',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('53577439-2093-4cd3-a7da-fb6e9f1231c9' as uuid),cast('d968b709-2d60-4781-992f-cd380824ba36' as uuid),'BOOLEAN','isRequired',null,'false',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('537d3c28-baea-43ad-a45b-f8ac0f2b3178' as uuid),cast('d968b709-2d60-4781-992f-cd380824ba36' as uuid),'TEXT','queryBuilder',null,'backend_serivce_based',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('9007c15e-e4bf-4286-9e5b-df6df990fd51' as uuid),cast('894a1343-a514-476b-9650-8f3c7bf65cb6' as uuid),'BOOLEAN','isHidden',null,'false',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('b40cff84-4c26-47a5-84f2-77ff4f51131f' as uuid),cast('894a1343-a514-476b-9650-8f3c7bf65cb6' as uuid),'BOOLEAN','isRequired',null,'false',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('ddfcc12c-1ebf-422d-a051-97613665da4a' as uuid),cast('894a1343-a514-476b-9650-8f3c7bf65cb6' as uuid),'BOOLEAN','isDisabled',null,'false',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('f3268be8-dc9e-4ed5-a566-27cdd5107ed8' as uuid),cast('894a1343-a514-476b-9650-8f3c7bf65cb6' as uuid),'TEXT','label',null,'canDelete_MANAGE_LOCATION_TYPE',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('47efc27f-7f47-4105-9538-c023abc5e056' as uuid),cast('894a1343-a514-476b-9650-8f3c7bf65cb6' as uuid),'TEXT','placeholder',null,'Select roles which can delete this location',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('4f7c5d42-e863-4287-8918-5d02f6a14912' as uuid),cast('894a1343-a514-476b-9650-8f3c7bf65cb6' as uuid),'DROPDOWN','optionsType',null,'queryBuilder',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('7bf6622b-d9d7-4ce0-8766-5293f5bb61dd' as uuid),cast('894a1343-a514-476b-9650-8f3c7bf65cb6' as uuid),'TEXT','tooltip',null,'Can Delete',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('98510fd3-f369-4db9-8312-3f7d1b612d7f' as uuid),cast('dee2daad-1d09-44a7-9dda-837c4a2ef384' as uuid),'TEXT','label',null,'canAdd_MANAGE_LOCATION_TYPE',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('ab595dce-4784-4f0d-ba81-7d0eb8e44b5e' as uuid),cast('dee2daad-1d09-44a7-9dda-837c4a2ef384' as uuid),'DISABILITY','disability',null,'null',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('b8224e1c-892a-4ebb-9833-a9f5fa8d2df7' as uuid),cast('dee2daad-1d09-44a7-9dda-837c4a2ef384' as uuid),'BOOLEAN','isDisabled',null,'false',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('c10b611f-ae1a-42de-9cbc-146382f049bd' as uuid),cast('dee2daad-1d09-44a7-9dda-837c4a2ef384' as uuid),'VISIBILITY','visibility',null,'null',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('c221e01a-2d45-4e4d-afb4-2cf679391a2d' as uuid),cast('dee2daad-1d09-44a7-9dda-837c4a2ef384' as uuid),'BOOLEAN','isRequired',null,'false',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('cfdbb65b-4e19-4b2a-b39c-c0cf7dba283e' as uuid),cast('dee2daad-1d09-44a7-9dda-837c4a2ef384' as uuid),'BOOLEAN','additionalStaticOptionsRequired',null,'false',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('d055fb39-2271-4a18-b815-cd69107e634b' as uuid),cast('dee2daad-1d09-44a7-9dda-837c4a2ef384' as uuid),'REQUIRABLE','requirable',null,'null',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('db488c6f-8ca5-4907-9902-2c2fc812914a' as uuid),cast('dee2daad-1d09-44a7-9dda-837c4a2ef384' as uuid),'TEXT','tooltip',null,'Can Add',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('2d6e149c-f583-4a9e-b795-92c9665ee79c' as uuid),cast('dee2daad-1d09-44a7-9dda-837c4a2ef384' as uuid),'TEXT','requiredMessage',null,'Please select an option',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('50828e8c-081c-4a6b-8c16-687271a25a0b' as uuid),cast('dee2daad-1d09-44a7-9dda-837c4a2ef384' as uuid),'DROPDOWN','optionsType',null,'queryBuilder',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('5fbd5121-1fd1-4af0-9be6-fef0f1226ce6' as uuid),cast('dee2daad-1d09-44a7-9dda-837c4a2ef384' as uuid),'BOOLEAN','isMultiple',null,'true',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('6208cc6a-1047-43db-a400-acadcca5a450' as uuid),cast('dee2daad-1d09-44a7-9dda-837c4a2ef384' as uuid),'TEXT','placeholder',null,'Select Roles which can add this location',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('6c318338-f887-498e-a8f7-47b83ea490e4' as uuid),cast('dee2daad-1d09-44a7-9dda-837c4a2ef384' as uuid),'TEXT','queryBuilder',null,'backend_service_based',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('7fa11ff2-f7cf-4d74-b3dd-40c79e685706' as uuid),cast('dee2daad-1d09-44a7-9dda-837c4a2ef384' as uuid),'EVENTS','events',null,'null',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('d5c68b1e-9631-4a48-8d15-a1efcf99c8b0' as uuid),cast('894a1343-a514-476b-9650-8f3c7bf65cb6' as uuid),'REQUIRABLE','requirable',null,'null',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('f5779ca6-e15a-4201-95cc-d34d5bddcc5e' as uuid),cast('894a1343-a514-476b-9650-8f3c7bf65cb6' as uuid),'EVENTS','events',null,'null',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('31db1fe9-6cb3-4516-bcb7-519070ca3ad9' as uuid),cast('894a1343-a514-476b-9650-8f3c7bf65cb6' as uuid),'BOOLEAN','isMultiple',null,'true',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('51784a85-6f28-422a-b79d-3000a5be0224' as uuid),cast('894a1343-a514-476b-9650-8f3c7bf65cb6' as uuid),'TEXT','queryBuilder',null,'backend_service_based',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('633d1f44-650e-429d-a979-7157c0d8a216' as uuid),cast('894a1343-a514-476b-9650-8f3c7bf65cb6' as uuid),'DISABILITY','disability',null,'null',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('68f4ce81-8ac5-44fa-b9c4-b9b51cdf07e8' as uuid),cast('894a1343-a514-476b-9650-8f3c7bf65cb6' as uuid),'VISIBILITY','visibility',null,'null',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('7b13c1bf-2774-48bc-b08a-c5303a9269da' as uuid),cast('894a1343-a514-476b-9650-8f3c7bf65cb6' as uuid),'BOOLEAN','additionalStaticOptionsRequired',null,'false',60512,now(),60512,now());

insert into system_constraint_field_value_master(uuid,field_master_uuid,value_type,key,value,default_value,created_by,created_on,modified_by,modified_on)
                         values(cast('6ce66935-b7d4-46ca-a04f-87a1ff1b0769' as uuid),cast('d968b709-2d60-4781-992f-cd380824ba36' as uuid),'BOOLEAN','isMultiple',null,'true',60512,now(),60512,now());

update system_constraint_form_master
set web_template_config = '[{"type":"CARD","config":{"title":"{{ctrl.headerText}}","cssStyles":null,"cssClasses":null,"isRepeatable":false,"showAddRemoveButton":false,"ngModel":null,"isConditional":false,"ngIf":null,"isCollapsible":false},"elements":[{"type":"ROW","config":{"size":"12","cssStyles":null,"cssClasses":null,"isRepeatable":false,"showAddRemoveButton":false,"ngModel":null,"isConditional":false,"ngIf":null},"elements":[{"type":"COL","config":{"size":"6","cssStyles":null,"cssClasses":null,"isRepeatable":false,"showAddRemoveButton":false,"ngModel":null,"isConditional":false,"ngIf":null},"elements":[{"type":"TECHO_FORM_FIELD","config":{"fieldKey":"type","fieldName":"type","fieldType":"SHORT_TEXT","cssStyles":null,"cssClasses":null,"isRepeatable":false,"showAddRemoveButton":false,"ngModel":null,"isConditional":false,"ngIf":null},"elements":[]}]},{"type":"COL","config":{"size":"6","cssStyles":null,"cssClasses":null,"isRepeatable":false,"showAddRemoveButton":false,"ngModel":null,"isConditional":false,"ngIf":null},"elements":[{"type":"TECHO_FORM_FIELD","config":{"fieldKey":"name","fieldName":"name","fieldType":"SHORT_TEXT","cssStyles":null,"cssClasses":null,"isRepeatable":false,"showAddRemoveButton":false,"ngModel":null,"isConditional":false,"ngIf":null},"elements":[]}]},{"type":"COL","config":{"size":"6","cssStyles":null,"cssClasses":null,"isRepeatable":false,"showAddRemoveButton":false,"ngModel":null,"isConditional":false,"ngIf":null},"elements":[{"type":"TECHO_FORM_FIELD","config":{"fieldKey":"level","fieldName":"level","fieldType":"NUMBER","cssStyles":null,"cssClasses":null,"isRepeatable":false,"showAddRemoveButton":false,"ngModel":null,"isConditional":false,"ngIf":null},"elements":[]}]},{"type":"COL","config":{"size":"6","cssStyles":null,"cssClasses":null,"isRepeatable":false,"showAddRemoveButton":false,"ngModel":null,"isConditional":false,"ngIf":null},"elements":[{"type":"TECHO_FORM_FIELD","config":{"fieldKey":"isSohEnable","fieldName":"isSohEnable","fieldType":"CHECKBOX","cssStyles":null,"cssClasses":null,"isRepeatable":false,"showAddRemoveButton":false,"ngModel":null,"isConditional":false,"ngIf":null},"elements":[]}]},{"type":"COL","config":{"size":"6","cssStyles":null,"cssClasses":null,"isRepeatable":false,"showAddRemoveButton":false,"ngModel":null,"isConditional":false,"ngIf":null},"elements":[{"type":"TECHO_FORM_FIELD","config":{"fieldKey":"canAdd","fieldName":"canAdd","fieldType":"DROPDOWN","cssStyles":null,"cssClasses":null,"isRepeatable":false,"showAddRemoveButton":false,"ngModel":null,"isConditional":false,"ngIf":null},"elements":[]}]},{"type":"COL","config":{"size":"6","cssStyles":null,"cssClasses":null,"isRepeatable":false,"showAddRemoveButton":false,"ngModel":null,"isConditional":false,"ngIf":null},"elements":[{"type":"TECHO_FORM_FIELD","config":{"fieldKey":"canUpdate","fieldName":"canUpdate","fieldType":"DROPDOWN","cssStyles":null,"cssClasses":null,"isRepeatable":false,"showAddRemoveButton":false,"ngModel":null,"isConditional":false,"ngIf":null},"elements":[]}]},{"type":"COL","config":{"size":"6","cssStyles":null,"cssClasses":null,"isRepeatable":false,"showAddRemoveButton":false,"ngModel":null,"isConditional":false,"ngIf":null},"elements":[{"type":"TECHO_FORM_FIELD","config":{"fieldKey":"canDelete","fieldName":"canDelete","fieldType":"DROPDOWN","cssStyles":null,"cssClasses":null,"isRepeatable":false,"showAddRemoveButton":false,"ngModel":null,"isConditional":false,"ngIf":null},"elements":[]}]},{"type":"COL","config":{"size":"12","cssStyles":null,"cssClasses":null,"isRepeatable":false,"showAddRemoveButton":false,"ngModel":null,"isConditional":false,"ngIf":null},"elements":[]},{"type":"COL","config":{"size":"12","cssStyles":null,"cssClasses":null,"isRepeatable":false,"showAddRemoveButton":false,"ngModel":null,"isConditional":false,"ngIf":null},"elements":[]},{"type":"COL","config":{"size":"12","cssStyles":null,"cssClasses":null,"isRepeatable":false,"showAddRemoveButton":false,"ngModel":null,"isConditional":false,"ngIf":null},"elements":[]},{"type":"COL","config":{"size":"12","cssStyles":null,"cssClasses":null,"isRepeatable":false,"showAddRemoveButton":false,"ngModel":null,"isConditional":false,"ngIf":null},"elements":[]},{"type":"COL","config":{"size":"6","cssStyles":null,"cssClasses":null,"isRepeatable":false,"showAddRemoveButton":false,"ngModel":null,"isConditional":false,"ngIf":null},"elements":[]},{"type":"COL","config":{"size":"6","cssStyles":null,"cssClasses":null,"isRepeatable":false,"showAddRemoveButton":false,"ngModel":null,"isConditional":false,"ngIf":null},"elements":[]}]}]}]'
where form_code = 'MANAGE_LOCATION_TYPE';