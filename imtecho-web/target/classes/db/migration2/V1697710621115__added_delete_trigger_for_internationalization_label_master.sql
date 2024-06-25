drop trigger if exists internationalization_label_master_delete on internationalization_label_master;

create or replace function delete_internationalization_label_master() returns trigger as $$

begin

if (select case when key_value = 'P' then true else false end from public.system_configuration where system_key = 'SERVER_TYPE') then
PERFORM dblink_exec
(
(select key_value from system_configuration where system_key = 'TRAINING_DB_NAME'),
'DELETE FROM public.internationalization_label_master
WHERE key = OLD.key and language = OLD.language and app_name = OLD.app_name and country = OLD.country;'
);
end if;

return null;

end;
$$ language plpgsql;

create trigger internationalization_label_master_delete after delete on public.internationalization_label_master
for each row execute procedure delete_internationalization_label_master();
