DROP TABLE IF EXISTS query_analysis_details;
CREATE TABLE query_analysis_details(
id serial,
execution_time timestamp without time zone NOT NULL,
query_string text,
parameters text,
total_rows Integer,
CONSTRAINT query_analysis_details_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS response_analysis_by_time_details;
CREATE TABLE response_analysis_by_time_details(
id serial,
requested_time timestamp without time zone NOT NULL,
requested_url text,
request_body text,
request_param text,
time_taken_in_ms character varying(100),
CONSTRAINT response_analysis_by_time_details_pkey PRIMARY KEY (id)
);