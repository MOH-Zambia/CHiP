DROP TABLE IF EXISTS public.cm_dashboard_request_log;
CREATE TABLE public.cm_dashboard_request_log(
id bigserial, 
request_time timestamp without time zone NOT NULL,
response_json text,
exception text,
state varchar(10),
CONSTRAINT cm_dashboard_request_log_pkey PRIMARY KEY (id)
);
