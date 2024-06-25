begin;
update child_cmtc_nrc_screening_detail
set is_case_completed = true
where id in (212340,
212341,
212342,
212761,
212762,
213139,
213140,
212543,
212544,
213263,
213264,
213265,
212617,
212196,
212197,
212360,
213149,
212285,
212702,
212703,
212589);
commit;

--begin;
--drop index if exists child_cmtc_nrc_screening_detail_child_case_complete;
--create unique index child_cmtc_nrc_screening_detail_child_case_complete on child_cmtc_nrc_screening_detail (child_id)
--where is_case_completed is null;
--commit;