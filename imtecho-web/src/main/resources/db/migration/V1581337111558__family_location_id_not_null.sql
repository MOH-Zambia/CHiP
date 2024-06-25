select pg_terminate_backend(pid) from pg_stat_activity where state = 'active' and state_change < now() - interval '1 seconds';

update imt_family set location_id = -1 where location_id is null;

ALTER TABLE public.imt_family
  ALTER COLUMN location_id SET NOT NULL;