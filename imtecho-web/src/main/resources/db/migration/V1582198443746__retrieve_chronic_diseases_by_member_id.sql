-- retrieve chronic diseases by member id

delete from query_master where code='retrieve_chronic_diseases_by_member_id';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'retrieve_chronic_diseases_by_member_id', 'memberId', '
    select
    string_agg(lfvd.value, '', '') as "chronicDiseases"
    from imt_member im
    left join imt_member_chronic_disease_rel imcdr on imcdr.member_id = im.id
    inner join listvalue_field_value_detail lfvd on lfvd.id = imcdr.chronic_disease_id
    where im.id = #memberId#
    group by im.id
', true, 'ACTIVE', 'Retrieve Chronic Diseases by Member Id');
