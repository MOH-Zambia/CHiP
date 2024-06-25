alter table imt_family alter column area_id type bigint using area_id::bigint;

update imt_family set anganwadi_id  = null where length(anganwadi_id) > 5;

alter table imt_family alter column anganwadi_id type bigint using anganwadi_id::bigint;
