ALTER table soh_element_configuration
drop column if exists rank_field_name,
ADD COLUMN rank_field_name character varying(255);

update soh_element_configuration set rank_field_name = 'percentage' where element_name = 'PREG_REG';
update soh_element_configuration set rank_field_name = 'calculatedtarget' where element_name = 'MMR';
update soh_element_configuration set rank_field_name = 'calculatedtarget' where element_name = 'IMR';
update soh_element_configuration set rank_field_name = 'chart1' where element_name = 'Anemia';
update soh_element_configuration set rank_field_name = 'chart4' where element_name = 'LBW';
update soh_element_configuration set rank_field_name = 'value' where element_name = 'SAM';
update soh_element_configuration set rank_field_name = 'displayvalue' where element_name = 'SR';
update soh_element_configuration set rank_field_name = 'percentage' where element_name = 'ID';
update soh_element_configuration set rank_field_name = 'percentage' where element_name = 'DATA_QUALITY';


