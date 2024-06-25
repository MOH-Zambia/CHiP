select pg_terminate_backend(pid) from pg_stat_activity where state = 'active' and state_change < now() - interval '1 seconds';

alter table imt_member
add column previous_pregnancy_complication text;
