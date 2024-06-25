alter table timer_event
drop column if exists completed_on,
drop column if exists exception_string,
add column completed_on timestamp without time zone,
add column exception_string text;