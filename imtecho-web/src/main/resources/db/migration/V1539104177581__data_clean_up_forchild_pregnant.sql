create temp table chid_member_detail
(
	member_id bigint
);


insert into chid_member_detail(member_id)
select id from imt_member where dob > now() - Interval '15 year' and is_pregnant = true;


delete from techo_notification_master where member_id in (select member_id from chid_member_detail) and notification_type_id in (1,2,3,5);

delete from rch_pregnancy_registration_det where member_id in (select member_id from chid_member_detail);

delete from rch_anc_dangerous_sign_rel where anc_id in (select id from rch_anc_master where member_id in (select member_id from chid_member_detail));

delete from rch_anc_previous_pregnancy_complication_rel where anc_id in (select id from rch_anc_master where member_id in (select member_id from chid_member_detail));

delete from rch_anc_master where member_id in (select member_id from chid_member_detail);

delete from rch_wpd_mother_danger_signs_rel where wpd_id in (select id from rch_wpd_mother_master where member_id in (select member_id from chid_member_detail));

delete from rch_wpd_mother_master where member_id in (select member_id from chid_member_detail);

delete from rch_wpd_child_congential_deformity_rel where wpd_id in (select id from rch_wpd_child_master where mother_id in (select member_id from chid_member_detail));

delete from rch_wpd_child_master where mother_id in (select member_id from chid_member_detail);

delete from rch_pnc_master where id in (select pnc_master_id from rch_pnc_mother_master where mother_id in (select member_id from chid_member_detail));

delete from rch_pnc_child_master where pnc_master_id in (select pnc_master_id from rch_pnc_mother_master where mother_id in (select member_id from chid_member_detail));


delete from rch_pnc_mother_danger_signs_rel where mother_pnc_id  in (select id from rch_pnc_mother_master where mother_id in (select member_id from chid_member_detail));

delete from rch_pnc_mother_master where mother_id in (select member_id from chid_member_detail);

delete from event_mobile_notification_pending 
where member_id in (select member_id from chid_member_detail) 
and notification_configuration_type_id in ('5d1131bc-f5bc-4a4a-8d7d-6dfd3f512f0a','faedb8e7-3e46-40a2-a9ac-ea7d5de944fa'
,'9b1a331b-fac5-48f0-908e-ef545e0b0c52');

update imt_member SET edd = null ,cur_preg_reg_date = null ,cur_preg_reg_det_id = null, is_pregnant = false , lmp = null where id in (select member_id from chid_member_detail);
