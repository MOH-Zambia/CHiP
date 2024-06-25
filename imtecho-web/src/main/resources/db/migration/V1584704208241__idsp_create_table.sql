drop table if exists idsp_member_screening_details;
create table idsp_member_screening_details (
id serial primary key,
member_id integer,
family_id integer,
location_id integer,
health_infra_id integer,
service_date date,
is_any_illness_or_discomfort boolean,
travel_detail text,
is_fever boolean,
fever_days smallint,
rashes_on_skin boolean,
fever_with_any_bleeding boolean,
fever_with_daze_or_unconscious boolean,
fever_with_severe_joint_pain_and_swelling boolean,
is_cough boolean,
cough_with_number_of_days smallint,
is_loose_watery_stool boolean,
loose_watery_stool_with_number_of_week integer,
loose_watery_stool_with_blood_in_stool boolean,
dehydration boolean,
type_of_dehydration text,
--loose_watery_stool_with_small_dehydration boolean,
--loose_watery_stool_with_no_dehydration boolean,
is_symptom_of_jaundice boolean,
jaundice_with_number_of_week smallint,
is_acute_jaundice boolean,
is_other_unusual_symptoms boolean,
is_acute_flaccid_paralysis boolean,
other_symptoms text,
under_regular_medications boolean,
all_required_meds_provided text,
created_by integer,
created_on timestamp without time zone,
modified_by integer,
modified_on timestamp without time zone,
latitude text,
longitude text
);

delete from listvalue_field_value_detail where field_key = 'countries';
delete from listvalue_field_master where field_key = 'countries';

INSERT INTO listvalue_field_master
(field_key, field, is_active, field_type, form, role_type)
VALUES('countries', 'Countries list', true, 'T', 'WEB', NULL);


INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Afghanistan','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Aland Islands (Finland)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Albania','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Algeria','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'American Samoa (USA)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Andorra','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Angola','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Anguilla (UK)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Antigua and Barbuda','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Argentina','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Armenia','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Aruba (Netherlands)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Australia','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Austria','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Azerbaijan','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Bahamas','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Bahrain','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Bangladesh','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Barbados','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Belarus','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Belgium','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Belize','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Benin','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Bermuda (UK)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Bhutan','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Bolivia','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Bosnia and Herzegovina','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Botswana','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Brazil','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'British Virgin Islands (UK)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Brunei','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Bulgaria','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Burkina Faso','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Burma','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Burundi','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Cambodia','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Cameroon','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Canada','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Cape Verde','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Caribbean Netherlands (Netherlands)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Cayman Islands (UK)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Central African Republic','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Chad','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Chile','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'China','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Christmas Island (Australia)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Cocos (Keeling) Islands (Australia)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Colombia','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Comoros','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Cook Islands (NZ)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Costa Rica','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Croatia','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Cuba','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Curacao (Netherlands)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Cyprus','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Czech Republic','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Democratic Republic of the Congo','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Denmark','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Djibouti','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Dominica','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Dominican Republic','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Ecuador','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Egypt','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'El Salvador','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Equatorial Guinea','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Eritrea','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Estonia','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Ethiopia','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Falkland Islands (UK)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Faroe Islands (Denmark)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Federated States of Micronesia','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Fiji','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Finland','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'France','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'French Guiana (France)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'French Polynesia (France)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Gabon','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Gambia','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Georgia','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Germany','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Ghana','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Gibraltar (UK)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Greece','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Greenland (Denmark)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Grenada','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Guadeloupe (France)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Guam (USA)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Guatemala','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Guernsey (UK)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Guinea','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Guinea-Bissau','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Guyana','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Haiti','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Honduras','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Hong Kong (China)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Hungary','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Iceland','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'India','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Indonesia','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Iran','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Iraq','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Ireland','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Isle of Man (UK)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Israel','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Italy','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Ivory Coast','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Jamaica','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Japan','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Jersey (UK)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Jordan','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Kazakhstan','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Kenya','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Kiribati','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Kosovo','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Kuwait','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Kyrgyzstan','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Laos','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Latvia','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Lebanon','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Lesotho','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Liberia','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Libya','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Liechtenstein','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Lithuania','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Luxembourg','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Macau (China)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Macedonia','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Madagascar','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Malawi','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Malaysia','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Maldives','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Mali','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Malta','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Marshall Islands','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Martinique (France)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Mauritania','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Mauritius','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Mayotte (France)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Mexico','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Moldov','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Monaco','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Mongolia','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Montenegro','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Montserrat (UK)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Morocco','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Mozambique','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Namibia','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Nauru','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Nepal','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Netherlands','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'New Caledonia (France)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'New Zealand','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Nicaragua','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Niger','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Nigeria','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Niue (NZ)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Norfolk Island (Australia)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Northern Mariana Islands (USA)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'North Korea','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Norway','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Oman','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Pakistan','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Palau','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Palestine','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Panama','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Papua New Guinea','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Paraguay','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Peru','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Philippines','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Pitcairn Islands (UK)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Poland','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Portugal','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Puerto Rico','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Qatar','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Republic of the Congo','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Reunion (France)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Romania','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Russia','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Rwanda','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Saint Barthelemy (France)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Saint Helena, Ascension and Tristan da Cunha (UK)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Saint Kitts and Nevis','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Saint Lucia','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Saint Martin (France)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Saint Pierre and Miquelon (France)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Saint Vincent and the Grenadines','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Samoa','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'San Marino','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Sao Tom and Principe','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Saudi Arabia','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Senegal','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Serbia','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Seychelles','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Sierra Leone','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Singapore','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Sint Maarten (Netherlands)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Slovakia','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Slovenia','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Solomon Islands','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Somalia','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'South Africa','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'South Korea','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'South Sudan','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Spain','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Sri Lanka','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Sudan','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Suriname','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Svalbard and Jan Mayen (Norway)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Swaziland','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Sweden','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Switzerland','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Syria','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Taiwan','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Tajikistan','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Tanzania','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Thailand','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Timor-Leste','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Togo','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Tokelau (NZ)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Tonga','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Trinidad and Tobago','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Tunisia','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Turkey','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Turkmenistan','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Turks and Caicos Islands (UK)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Tuvalu','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Uganda','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Ukraine','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'United Arab Emirates','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'United Kingdom','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'United States','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'United States Virgin Islands (USA)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Uruguay','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Uzbekistan','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Vanuatu','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Vatican City','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Venezuela','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Vietnam','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Wallis and Futuna (France)','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Western Sahara','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Yemen','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Zambia','countries', 0, NULL, NULL);
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, 'superadmin', now(), 'Zimbabwe','countries', 0, NULL, NULL);