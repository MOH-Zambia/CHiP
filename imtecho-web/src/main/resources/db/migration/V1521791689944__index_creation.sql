DROP INDEX IF EXISTS um_user_aadhar_number_idx;

CREATE INDEX um_user_aadhar_number_idx
ON um_user (aadhar_number);

DROP INDEX IF EXISTS um_user_contact_number_idx;

CREATE INDEX um_user_contact_number_idx
ON um_user (contact_number);

DROP INDEX IF EXISTS um_user_search_text_idx;

CREATE INDEX um_user_search_text_idx
ON um_user (search_text);

DROP INDEX IF EXISTS um_user_role_id_idx;

CREATE INDEX um_user_role_id_idx
ON um_user (role_id);

DROP INDEX IF EXISTS um_user_state_idx;

CREATE INDEX um_user_state_idx
ON um_user (state);

DROP INDEX IF EXISTS um_user_user_name_idx;

CREATE INDEX um_user_user_name_idx
ON um_user (user_name);

DROP INDEX IF EXISTS um_user_loc_id_idx;

CREATE INDEX um_user_loc_id_idx
ON um_user_location (loc_id);

DROP INDEX IF EXISTS um_user_user_id_idx;

CREATE INDEX um_user_user_id_idx
ON um_user_location (user_id);

DROP INDEX IF EXISTS um_user_state_idx;

CREATE INDEX um_user_state_idx
ON um_user_location (state);

DROP INDEX IF EXISTS imt_family_anganwadi_id_idx;

CREATE INDEX imt_family_anganwadi_id_idx
ON imt_family (anganwadi_id);

DROP INDEX IF EXISTS imt_family_area_id_idx;

CREATE INDEX imt_family_area_id_idx
ON imt_family (area_id);

DROP INDEX IF EXISTS imt_family_family_id_idx;

CREATE INDEX imt_family_family_id_idx
ON imt_family (family_id);

DROP INDEX IF EXISTS imt_family_state_idx;

CREATE INDEX imt_family_state_idx
ON imt_family (state);

DROP INDEX IF EXISTS imt_family_location_id_idx;

CREATE INDEX imt_family_location_id_idx
ON imt_family (location_id);

DROP INDEX  IF EXISTS imt_family_assigned_to_idx;

CREATE INDEX imt_family_assigned_to_idx
ON imt_family (assigned_to);

DROP INDEX IF EXISTS imt_member_aadhar_number_idx;

CREATE INDEX imt_member_aadhar_number_idx
ON imt_member (aadhar_number);

DROP INDEX IF EXISTS imt_member_emamta_health_id_idx;

CREATE INDEX imt_member_emamta_health_id_idx
ON imt_member (emamta_health_id);

DROP INDEX IF EXISTS imt_member_mobile_number_idx;

CREATE INDEX imt_member_mobile_number_idx
ON imt_member (mobile_number);

DROP INDEX IF EXISTS imt_member_family_id_idx;

CREATE INDEX imt_member_family_id_idx
ON imt_member (family_id);

DROP INDEX IF EXISTS imt_member_state_idx;

CREATE INDEX imt_member_state_idx
ON imt_member (state);