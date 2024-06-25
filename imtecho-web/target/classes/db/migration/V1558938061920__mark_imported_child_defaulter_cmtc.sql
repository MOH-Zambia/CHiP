with ids as (
	select id from child_cmtc_nrc_screening_detail
	where is_imported
	and discharge_id is null
	and admission_id is not null
),cmtc_ids as (
	update child_cmtc_nrc_screening_detail
	set state = 'DEFAULTER'
	from ids
	where child_cmtc_nrc_screening_detail.id = ids.id
	returning child_cmtc_nrc_screening_detail.id
)
update child_cmtc_nrc_admission_detail
set defaulter_date = current_date
from ids
where child_cmtc_nrc_admission_detail.case_id = ids.id;