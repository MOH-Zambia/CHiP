ALTER TABLE imt_member
DROP COLUMN IF EXISTS last_delivery_outcome,
ADD COLUMN last_delivery_outcome text;

CREATE TABLE if not exists imt_member_previous_pregnancy_complication_rel
(
  member_id bigint NOT NULL,
  previous_pregnancy_complication text NOT NULL,
  PRIMARY KEY (member_id, previous_pregnancy_complication),
  FOREIGN KEY (member_id)
      REFERENCES imt_member (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);