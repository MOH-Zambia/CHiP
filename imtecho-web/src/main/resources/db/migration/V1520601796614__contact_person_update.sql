update imt_family as f
set contact_person_id = m.id from imt_member as m
where f.family_id = m.family_id 
and m.mobile_number is not null and m.family_head = true;


update imt_family as f
set contact_person_id = m.id from imt_member as m
where f.family_id = m.family_id and f.contact_person_id is null
and m.mobile_number is not null;
