ALTER table soh_element_configuration
drop column if exists footer_description,
ADD COLUMN footer_description character varying(255);

ALTER table soh_element_module_master
drop column if exists footer_description,
ADD COLUMN footer_description character varying(255);


update soh_element_configuration set footer_description = 'FI : Fully Immunized' where element_name = 'FI';
update soh_element_configuration set footer_description = 'LBW : Low Birth Weight' where element_name = 'LBW';
update soh_element_configuration set footer_description = 'SAM : Severe Acute Malnutrition' where element_name = 'SAM';
update soh_element_configuration set footer_description = 'PW : Pregnant women' where element_name = 'Anemia';
update soh_element_configuration set footer_description = 'DM : Diabetes Mellitus' where element_name = 'NCD_DIABETES';
update soh_element_configuration set footer_description = 'HTN : Hypertension' where element_name = 'NCD_HYPERTENSION';
update soh_element_module_master set footer_description = 'Source of data: TeCHO' where module = 'RCH'