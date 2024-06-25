DROP TABLE IF EXISTS public.ncd_dell_api_push_response;
CREATE TABLE public.ncd_dell_api_push_response
(
  id bigserial,
  location_id bigint,
  location_name text,
  request_start_date timestamp without time zone,
  request_end_date timestamp without time zone,
  response text,
  CONSTRAINT ncd_dell_api_push_response_pkey PRIMARY KEY (id)
);
 