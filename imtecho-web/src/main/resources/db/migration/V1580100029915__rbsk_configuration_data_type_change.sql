ALTER table rbsk_defect_configuration
ALTER COLUMN defect_name type character varying(255),
ALTER COLUMN defect_image type integer using cast(defect_image as integer),
drop column if exists state,
ADD COLUMN state character varying(15);



ALTER table rbsk_defect_stabilization_info
ALTER COLUMN code type character varying(255);


ALTER table rbsk_defect_configuration_stabilization_info_rel
ALTER COLUMN stabilization_info_code type character varying(255);