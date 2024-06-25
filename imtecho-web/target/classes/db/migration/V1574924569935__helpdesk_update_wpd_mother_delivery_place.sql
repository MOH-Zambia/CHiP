delete from query_master where code = 'helpdesk_update_wpd_mother_delivery_place';

insert into query_master (created_by , created_on , modified_by , modified_on, code , params , query ,returns_result_set , state , description)
VALUES (-1  , now() , -1  , now() , 
'helpdesk_update_wpd_mother_delivery_place' , 'deliveryPlace,healthInfrastructureId,typeOfHospital,userId,id',
'
INSERT INTO member_audit_log (member_id , table_name,  created_on , user_id, data , column_name, ref_code)
Values ((select member_id from rch_wpd_mother_master where id=#id# ), ''rch_wpd_mother_master'' , now() , #userId# , json_build_object(''id'',#id# , ''health_infrastructure_id'' , (select health_infrastructure_id from rch_wpd_mother_master where id= #id#) , ''type_of_hospital'' , (select type_of_hospital from rch_wpd_mother_master where id= #id#) ,''delivery_place'', (select rch_wpd_mother_master.delivery_place from rch_wpd_mother_master where id= #id# )) , ''health_infrastructure_id'' , #id#);

INSERT INTO member_audit_log  (member_id , table_name,  created_on , user_id, data , column_name, ref_code) 
select member_id,''imt_member'' , now() , #userId# , json_build_object(''id'',member_id , ''place_of_birth'' , (select place_of_birth from imt_member where id = member_id)),''place_of_birth'', member_id from rch_wpd_child_master where wpd_mother_id = #id#;

update rch_wpd_mother_master set delivery_place = ''#deliveryPlace#'' , health_infrastructure_id = #healthInfrastructureId# , type_of_hospital = #typeOfHospital# , modified_on = now() , modified_by = #userId# where id = #id#;

update imt_member set place_of_birth = ''#deliveryPlace#'',modified_by = #userId# , modified_on = now() where id IN (select member_id from rch_wpd_child_master where wpd_mother_id = #id# );',
false , 'ACTIVE' , 'Update Delivery Place' );


update menu_config set feature_json = '{"canModifyMemberDob":false,"canModifyMemberGender":false,"canModifyPregnancyRegDate":false,"canModifyLmpDate":false,"canModifyAncServiceDate":false,"canModifyWpdServiceDate":false,"canModifyWpdDeliveryDate":false,"canModifyPncServiceDate":false,"canModifyChvServiceDate":false,"canModifyImmuGivenDate":false,"canModifyWpdDeliveryPlace":false}' where menu_name = 'Helpdesk Tool - Search'
