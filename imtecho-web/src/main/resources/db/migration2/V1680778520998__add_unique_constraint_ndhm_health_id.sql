update ndhm_health_id_user_details set member_id = null where member_id = -1;

ALTER TABLE ndhm_health_id_user_details
ADD CONSTRAINT ndhm_health_id_user_details_member_id_unique_constraint UNIQUE (member_id),
ADD CONSTRAINT ndhm_health_id_user_details_health_id_unique_constraint UNIQUE (health_id),
ADD CONSTRAINT ndhm_health_id_user_details_health_id_number_unique_constraint UNIQUE (health_id_number);