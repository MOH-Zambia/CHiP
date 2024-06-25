create table if not exists fhw_score  ( id bigserial,
  user_id bigint NOT NULL,
  score bigint NOT NULL,
  score_date timestamp without time zone NOT NULL,
  district_id bigint,
  rank bigint NOT NULL,
  PRIMARY KEY (id)
);
