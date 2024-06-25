alter table imt_member
add column eligible_couple_date timestamp without time zone;

--select to_date(CONCAT(year_of_wedding::text,'-01-01'),'YYYY-MM-DD') from imt_member where year_of_wedding is not null limit 10