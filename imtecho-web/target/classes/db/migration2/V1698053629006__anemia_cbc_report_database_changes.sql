alter table anemia_member_detail
add column lab_id integer;

drop table if exists anemia_member_cbc_report;
CREATE TABLE anemia_member_cbc_report
(
	id serial primary key,
	member_id integer,
	lab_id integer not null,
    wbc_count text,
    rbc_count text,
    hgb_count text,
    hct_count text,
    mcv_count text,
    mch_count text,
    mchc_count text,
    plt_count text,
    rdw_cv text,
    message text,
    status text,
	created_on timestamp without time zone,
	modified_on timestamp without time zone,
	created_by integer,
	modified_by integer
);
