CREATE TABLE if not exists absent_user_verification
(
  id bigserial NOT NULL,
  user_id bigint,
  last_action_date timestamp without time zone,
  created_on timestamp without time zone,
  created_by bigint,
  gvk_state  varchar(255),
  schedule_date timestamp without time zone,
  call_attempt int default 0,
  modified_on timestamp without time zone,
  modified_by bigint,
  CONSTRAINT absent_user_verification_pkey PRIMARY KEY (id)  
);

CREATE TABLE if not exists gvk_absent_verification
(
  id bigserial NOT NULL,
  user_id bigint,
  created_on timestamp without time zone,
  created_by bigint,
  status  varchar(255),
  reason bigint,
  comment varchar(1000),
  modified_on timestamp without time zone,
  modified_by bigint,
  processing_time bigint,
  CONSTRAINT gvk_absent_verification_pkey PRIMARY KEY (id)  
);