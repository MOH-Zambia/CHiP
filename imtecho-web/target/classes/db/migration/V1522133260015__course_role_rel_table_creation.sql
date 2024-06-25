CREATE TABLE if not exists tr_course_role_rel
(
  course_id bigint NOT NULL,
  role_id bigint, 
    FOREIGN KEY (course_id)
      REFERENCES tr_course_master (course_id)
);