ALTER table rbsk_defect_stabilization_info
drop column if exists status,
ADD COLUMN status character varying(15);