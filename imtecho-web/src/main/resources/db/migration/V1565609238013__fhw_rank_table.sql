drop table if exists fhw_score;
CREATE TABLE if not exists um_user_score
(
  id bigserial,
  user_id bigint NOT NULL,
  role_id bigint NOT NULL,
  score bigint NOT NULL,
  score_date timestamp without time zone NOT NULL,
  PRIMARY KEY (id)
);