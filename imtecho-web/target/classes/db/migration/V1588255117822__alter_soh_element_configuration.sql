ALTER table soh_element_configuration
drop column if exists is_filter_enable,
ADD COLUMN is_filter_enable boolean;

update
	soh_element_configuration
set
	is_filter_enable = true
where
	element_name != 'FI'
	and element_name != 'COVID19_RESPONSE';