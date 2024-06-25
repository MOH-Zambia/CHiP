delete
from
	listvalue_field_value_detail
where
	field_key = 'cfhc_death_verification_mo';

delete
from
	listvalue_field_master
where
	field_key = 'cfhc_death_verification_mo';

insert
	into
	listvalue_field_master(field_key,
	field,
	is_active,
	field_type)
values('cfhc_death_verification_mo',
'cfhc_death_verification_mo',
true,
'T');

insert
	into
	listvalue_field_value_detail( is_active,
	is_archive,
	last_modified_by,
	last_modified_on,
	file_size,
	value,
	field_key,
	code)
values (true,
false,
'superadmin',
now(),
0 ,
'Confirmed',
'cfhc_death_verification_mo',
'C');

insert
	into
	listvalue_field_value_detail( is_active,
	is_archive,
	last_modified_by,
	last_modified_on,
	file_size,
	value,
	field_key,
	code)
values (true,
false,
'superadmin',
now(),
0 ,
'Mark As False Death',
'cfhc_death_verification_mo',
'D');