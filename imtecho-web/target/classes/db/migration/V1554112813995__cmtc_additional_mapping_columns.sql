alter table child_cmtc_nrc_screening_detail
drop column if exists is_case_completed,
add column is_case_completed boolean;

alter table child_cmtc_nrc_admission_detail
drop column if exists case_id,
add column case_id bigint;

alter table child_cmtc_nrc_discharge_detail
drop column if exists case_id,
add column case_id bigint;

alter table child_cmtc_nrc_follow_up
drop column if exists case_id,
add column case_id bigint;

update child_cmtc_nrc_admission_detail
set case_id = t.id
from
(select max(child_cmtc_nrc_screening_detail.id) as id,child_cmtc_nrc_screening_detail.child_id
from child_cmtc_nrc_screening_detail
inner join child_cmtc_nrc_admission_detail on child_cmtc_nrc_screening_detail.child_id = child_cmtc_nrc_admission_detail.child_id
group by child_cmtc_nrc_screening_detail.child_id) as t
where t.child_id = child_cmtc_nrc_admission_detail.child_id;


update child_cmtc_nrc_discharge_detail
set case_id = t.id
from
(select max(child_cmtc_nrc_screening_detail.id) as id,child_cmtc_nrc_screening_detail.child_id
from child_cmtc_nrc_screening_detail
inner join child_cmtc_nrc_discharge_detail on child_cmtc_nrc_screening_detail.child_id = child_cmtc_nrc_discharge_detail.child_id
group by child_cmtc_nrc_screening_detail.child_id) as t
where t.child_id = child_cmtc_nrc_discharge_detail.child_id;

update child_cmtc_nrc_follow_up
set case_id = t.id
from
(select max(child_cmtc_nrc_screening_detail.id) as id,child_cmtc_nrc_screening_detail.child_id
from child_cmtc_nrc_screening_detail
inner join child_cmtc_nrc_follow_up on child_cmtc_nrc_screening_detail.child_id = child_cmtc_nrc_follow_up.child_id
group by child_cmtc_nrc_screening_detail.child_id) as t
where t.child_id = child_cmtc_nrc_follow_up.child_id;

with child_ids as(
	select child_id from child_cmtc_nrc_follow_up
	where follow_up_visit = 3 and program_output is not null
)
update child_cmtc_nrc_screening_detail
set is_case_completed = true
from child_ids
where child_cmtc_nrc_screening_detail.child_id = child_ids.child_id
and child_cmtc_nrc_screening_detail.state = 'DISCHARGE'