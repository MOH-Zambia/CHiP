delete from listvalue_field_value_detail where field_key = '3002';
delete from listvalue_field_value_detail where field_key = '3001';
delete from listvalue_field_value_detail where field_key = '3003';

delete from listvalue_field_master where field_key = '3001';
delete from listvalue_field_master where field_key = '3002';
delete from listvalue_field_master where field_key = '3003';

insert into listvalue_field_master(field_key,field,is_active) values('3001','highRiskSymptomsDuringDelivery',true);
insert into listvalue_field_master(field_key,field,is_active) values('3002','treatmentsDuringDelivery',true);
insert into listvalue_field_master(field_key,field,is_active) values('3003','wpdDangerSigns',true);

insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size)
values(true,false,'superadmin',current_date,'પગે સોજા આવવા',3001,0);
insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size)
values(true,false,'superadmin',current_date,'હાઇ બી.પી.',3001,0);
insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size)
values(true,false,'superadmin',current_date,'Preterm',3001,0);
insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size)
values(true,false,'superadmin',current_date,'ખેંચ આવવી',3001,0);
insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size)
values(true,false,'superadmin',current_date,'જોડિયા બાળકો',3001,0);

insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size)
values(true,false,'superadmin',current_date,'એન્ટી બાયોટીક',3002,0);
insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size)
values(true,false,'superadmin',current_date,'ઓક્સીટોસીન',3002,0);
insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size)
values(true,false,'superadmin',current_date,'કોર્ટીકોસ્ટીરોઇડ',3002,0);
insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size)
values(true,false,'superadmin',current_date,'મેગ્નેસીયમ સલ્ફેટ',3002,0);
insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size)
values(true,false,'superadmin',current_date,'લોહી ચઢાવવું',3002,0);

insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size)
values(true,false,'superadmin',current_date,'લોહી વહી જવું',3003,0);
insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size)
values(true,false,'superadmin',current_date,'તીવ્ર પેટમાં દુખાવો',3003,0);
insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size)
values(true,false,'superadmin',current_date,'તીવ્ર માથાનો દુખાવો અથવા visual disturbance',3003,0);
insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size)
values(true,false,'superadmin',current_date,'શ્વાસ લેવામાં તકલીફ',3003,0);
insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size)
values(true,false,'superadmin',current_date,'તાવ અથવા ઠંડી લાગીને તાવ આવવો',3003,0);
insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size)
values(true,false,'superadmin',current_date,'પેશાબમાં તકલીફ',3003,0);