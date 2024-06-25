CREATE TABLE anmol_exception_xml_master
(id bigserial primary key,
source_id bigint,
source_type varchar(255),
xml text,
code text,
created_on timestamp without time zone
);

alter table rch_pnc_child_master
drop column anmol_pnc_xml;

alter table rch_pnc_mother_master
drop column anmol_pnc_xml;

alter table rch_anc_master
drop column anmol_anc_xml;

alter table rch_child_service_master
drop column anmol_child_tracking_xml;

alter table rch_child_service_master
drop column anmol_child_tracking_medical_xml;

alter table anmol_master
drop column eligible_xml;

alter table anmol_master
drop column mother_registration_xml;

alter table anmol_master
drop column mother_medial_registration_xml;

alter table anmol_master
drop column mother_delivery_xml;

alter table rch_lmp_follow_up
drop column anmol_follow_up_xml;