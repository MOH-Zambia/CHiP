DO $$
    BEGIN
        BEGIN
        alter table system_constraint_form_master
        add column mobile_state varchar(50);
        EXCEPTION
            WHEN duplicate_column THEN
 END;
    END;
$$;

do
$$
    begin
        alter table system_constraint_form_master
            rename column state to web_state;

exception
when undefined_column then
end;

$$;

drop table if exists system_constraint_form_version;

CREATE TABLE public.system_constraint_form_version (
	id serial PRIMARY KEY,
	form_master_uuid uuid NOT NULL,
  	template_config text NULL,
  	version int,
  	type text,
  	created_by int NOT NULL,
  	created_on timestamp without time zone NOT NULL,
  	modified_by int,
  	modified_on timestamp without time zone
);

insert
	into
	public.system_constraint_form_version
( form_master_uuid,
	template_config,
	"version",
	"type",
	created_by,
	created_on
	)
select
	scfm.uuid,
	scfm.mobile_template_config,
	sc.key_value::INTEGER,
	'MOBILE',
	97067,
	 now()
from
	system_constraint_form_master scfm,
	system_configuration sc
where
	sc.system_key = 'MOBILE_FORM_VERSION' ;


alter table system_constraint_form_master
	DROP COLUMN if exists mobile_template_config;

