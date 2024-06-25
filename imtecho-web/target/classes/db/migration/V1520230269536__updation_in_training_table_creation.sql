Drop TABLE if exists tr_training_role_rel;

CREATE TABLE if not exists tr_training_trainer_role_rel
(
  training_id bigint NOT NULL,
  role_id bigint NOT NULL,
  CONSTRAINT tr_training_trainer_role_rel_pkey PRIMARY KEY (training_id, role_id),
  FOREIGN KEY (training_id)
      REFERENCES tr_training_master (training_id)
);
