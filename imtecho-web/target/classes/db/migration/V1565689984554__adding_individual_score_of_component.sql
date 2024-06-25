drop table if exists um_user_score;
CREATE TABLE if not exists  public.um_user_score_rank_details
(
  user_id bigint NOT NULL,
  role_id bigint NOT NULL,
  score numeric(20,8) NOT NULL,
  score_date date NOT NULL,
  a_score numeric(20,8),
  b_score numeric(20,8),
  c_score numeric(20,8),
  d_score numeric(20,8),
  PRIMARY KEY (user_id, score_date)
);