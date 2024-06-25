DELETE FROM QUERY_MASTER WHERE CODE='get_member_details_by_unique_health_id_for_digilocker';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'95251b96-7ae1-4951-8254-170042d5b862', 74840,  current_date , 74840,  current_date , 'get_member_details_by_unique_health_id_for_digilocker',
'unique_health_id',
'with member_details as (
	select
	mem.id as member_id,
	concat(mem.first_name, '' '', mem.last_name, '' ('', mem.unique_health_id, '')'') as member_name,
	mem.middle_name as father_name,
	case
	    when (fam.address1 is null and fam.address2 is null) then ''N/A''
	    else
	        case
	            when fam.address1 is null then fam.address2
	            when fam.address2 is null then fam.address1
	            else concat(fam.address1, '','', fam.address2)
	        end
	end as address,
	date_part(''years'', age(localtimestamp, dob)) as age,
	dob as child_dob,
	to_char(dob,''dd-MM-yyyy'') as dob,
	case
		when rel.value = ''HINDU'' then ''Hindu''
		when rel.value = ''CHRISTIAN'' then ''Christian''
		when rel.value = ''MUSLIM'' then ''Muslim''
		when rel.value = ''OTHERS'' then ''Others''
		else rel.value
	end as religion,
	case
		when cas.value = ''GENERAL'' then ''General''
		else cas.value
	end as cast
	from imt_member mem

	inner join imt_family fam on mem.family_id = fam.family_id
	left join listvalue_field_value_detail cas on fam.caste = (cast(cas.id as varchar))
	left join listvalue_field_value_detail rel on fam.religion = (cast(rel.id as varchar))
	where mem.unique_health_id = ''#unique_health_id#''
)
select * from member_details',
null,
true, 'ACTIVE');