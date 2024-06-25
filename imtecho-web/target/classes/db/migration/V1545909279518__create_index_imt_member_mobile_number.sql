drop index if exists mobile_number_index;

create index mobile_number_index
on imt_member(mobile_number);