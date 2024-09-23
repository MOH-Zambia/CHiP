-- update data for pregnancy analysis

DELETE FROM EVENT_CONFIGURATION WHERE uuid = '0873826b-e125-446c-bf4f-5e3b0d83c450';

INSERT INTO EVENT_CONFIGURATION(created_by, created_on, modified_by, modified_on, day, description, event_type, event_type_detail_id, form_type_id, hour, minute, name, config_json, state, trigger_when, event_type_detail_code, uuid)
VALUES (
1027,  current_date , 1027,  current_date , null, 'This will do an all count related to the maternal report.', 'TIMMER_BASED', null, null, 2, 0, 'Update Data for Pregnancy Analytics', '[{"query":"select 1;","queryParam":null,"conditions":[{"isConditionReq":false,"condition":null,"conditionParam":null,"description":null,"notificaitonConfigsType":[{"id":"8fb48344-84d1-4c23-ab76-54193ed3ae02","type":"QUERY","template":"begin;\n---1\ndrop table if exists t_pregnancy_registration_det;\ncreate table t_pregnancy_registration_det\n(\n\tpregnancy_reg_id bigint primary key,\n\tmember_id bigint,\n\tunique_health_id text,\n\tdob date,\n\tfamily_id text,\n\tmember_name text,\n\tmobile_number text,\n\treg_service_date date,\n\treg_service_date_month_year date,\n\treg_service_financial_year text,\n\treg_server_date timestamp without time zone,\n\tpregnancy_reg_location_id bigint,\n\tnative_location_id integer,\n\t\n\ttracking_location_id integer,\n\tis_valid_for_tracking_report boolean,\n\t\n\tpregnancy_reg_family_id bigint,\n\tpreg_reg_state text,\n\tmember_basic_state text,\n\tmember_state text,\n\t\n\tfamily_basic_state text,\n\tmarital_status integer,\n\taddress text,\n\thusband_name text,\n\thusband_mobile_number text,\n\thof_name text,\n\thof_mobile_number text,\n\t\n\tlmp_date date,\n\tlmp_month_year date,\n\tlmp_financial_year text,\n\tedd date,\n\tdate_of_delivery date,\n\tdate_of_delivery_month_year date,\n\tdelivery_reg_date date,\n\tdelivery_reg_date_financial_year text,\n\tdelivery_location_id bigint,\n\tdelivery_family_id bigint,\n\tmember_current_location_id bigint,\n\tage_during_delivery smallint,\n\tregistered_with_no_of_child smallint,\n\tregistered_with_male_cnt smallint,\n\tregistered_with_female_cnt smallint,\n\tanc1 date,\n\tanc1_location_id integer,\n\tanc2 date,\n\tanc2_location_id integer,\n\tanc3 date,\n\tanc3_location_id integer,\n\tanc4 date,\n\tanc4_location_id integer,\n\tlast_systolic_bp integer,\n\tlast_diastolic_bp integer,\n\ttotal_regular_anc smallint,\n\ttt1_given date,\n\ttt1_location_id integer,\n\ttt2_given date,\n\ttt2_location_id integer,\n\ttt_boster date,\n\ttt_booster_location_id integer,\n\ttt2_tt_booster_given date,\n\ttt2_tt_booster_location_id integer,\n\tearly_anc boolean,\n\ttotal_anc smallint,\n\t\n\tcomplete_anc_date date,\n\tcomplete_anc_location integer,\n\t\n\t\n\tifa integer,\n\t\n\tifa_180_anc_date date,\n\tifa_180_anc_location integer,\n\t\n\tfa_tab_in_30_day integer,\n\tfa_tab_in_31_to_60_day integer,\n\tfa_tab_in_61_to_90_day integer,\n\tifa_tab_in_4_month_to_9_month integer,\n\thb real,\n\thb_date date,\n\thb_between_90_to_360_days real,\n\ttotal_ca integer,\n\tca_tab_in_91_to_180_day integer,\n\tca_tab_in_181_to_360_day integer,\n\texpected_delivery_place text,\n\t\n\tL2L_Preg_Complication text,\n\tOutcome_L2L_Preg text,\n\tL2L_Preg_Complication_Length smallint,\n\tOutcome_Last_Preg integer,\n\t\n\t\n\talben_given boolean,\n\tmaternal_detah boolean,\n\tmaternal_death_type text,\n\tdeath_date date,\n\tdeath_location_id integer,\n\t\n\tlow_height boolean,\n\turine_albumin boolean,\n\t\n\tsystolic_bp smallint,\n\tdiastolic_bp smallint,\n\tprev_pregnancy_date date,\n\tprev_preg_diff_in_month smallint,\n\tgravida smallint,\n\n\tany_chronic_dis boolean,\n\thigh_risk_mother boolean,\n\t\n\tpre_preg_anemia boolean,\n\tpre_preg_caesarean_section boolean,\n\tpre_preg_aph boolean,\n\tpre_preg_pph boolean,\n\tpre_preg_pre_eclampsia boolean,\n\tpre_preg_abortion boolean,\n\tpre_preg_obstructed_labour boolean,\n\tpre_preg_placenta_previa boolean,\n\tpre_preg_malpresentation  boolean,\n\tpre_preg_birth_defect boolean,\n\tpre_preg_preterm_delivery boolean,\n\tany_prev_preg_complication boolean,\n\t\n\tchro_tb boolean,\n\tchro_diabetes boolean,\n\tchro_heart_kidney boolean,\n\tchro_hiv boolean,\n\tchro_sickle boolean,\n\tchro_thalessemia boolean,\n\t\n\tcur_extreme_age boolean,\n\tcur_low_weight boolean,\n\tcur_severe_anemia boolean,\n\tcur_blood_pressure_issue boolean,\n\tcur_urine_protein_issue boolean,\n\tcur_convulsion_issue boolean,\n\tcur_malaria_issue boolean,\n\tcur_social_vulnerability boolean,\n\tcur_gestational_diabetes_issue boolean,\n\tcur_twin_pregnancy boolean,\n\tcur_mal_presentation_issue boolean,\n\tcur_absent_reduce_fetal_movment boolean,\n\tcur_less_than_18_month_interval boolean,\n\tcur_aph_issue boolean,\n\tcur_pelvic_sepsis boolean,\n\tcur_hiv_issue boolean,\n\tcur_vdrl_issue boolean,\n\tcur_hbsag_issue boolean,\n\tcur_brethless_issue boolean,\n\tany_cur_preg_complication boolean,\n\t\n\thigh_risk_cnt smallint,\n\thbsag_test_cnt smallint,\n\thbsag_reactive_cnt smallint,\n\thbsag_non_reactive_cnt smallint,\n\t\n\tdelivery_outcome text,\n\ttype_of_delivery text,\n\thome_del boolean,\n\tinstitutional_del boolean,\n\tdelivery_108 boolean,\n    \n    delivery_out_of_state_govt boolean,\n    delivery_out_of_state_pvt boolean,\n\n    delivery_place text,\n\tbreast_feeding_in_one_hour boolean,\n\tdelivery_hospital text,\n\tdelivery_health_infrastructure integer, \n\tdel_week smallint,\n\tis_cortico_steroid boolean,\n\tmother_alive boolean,\n\ttotal_out_come smallint,\n\tmale smallint,\n\tfemale smallint,\n\t\n\tstill_birth smallint,\n\tlive_birth smallint,\n\t\n\t\n\tdelivery_done_by text,\n\tpnc1 date,\n\tpnc1_location_id integer,\n\tpnc2 date,\n\tpnc2_location_id integer,\n\tpnc3 date,\n\tpnc3_location_id integer,\n\tpnc4 date,\n\tpnc4_location_id integer,\n    pnc5 date,\n    pnc5_location_id integer,\n    pnc6 date,\n    pnc6_location_id integer,\n\tpnc7 date,\n\tpnc7_location_id integer,\n\n\t\n\tifa_tab_after_delivery smallint,\n\t\n\thaemoglobin_tested_count integer,\n\tiron_def_anemia_inj text,\n\tblood_transfusion boolean,\n\t\n\tppiucd_insert_date date,\n\tppiucd_insert_location integer,\n\n\thigh_risk_reasons text,\n\t\n\tis_fru boolean\n);\n\n\ndelete from rch_pregnancy_analytics_details where pregnancy_reg_id in (\nselect rpa.pregnancy_reg_id\nfrom rch_pregnancy_analytics_details rpa\nleft join imt_member m on rpa.member_id = m.id and m.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'',''DEAD'',''TEMPORARY'',''MIGRATED'')\n--left join imt_family f on m.family_id = f.family_id and f.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'',''TEMPORARY'',''MIGRATED'')\nwhere  m.id is null\n--or f.id is null\n) and (select cast(key_value as boolean) as value from system_configuration where system_key = ''rch_pregnancy_analytics_run_for_all_pregnancy'' ) = false;\n\ndelete from rch_pregnancy_analytics_details where pregnancy_reg_id in (\nselect rpa.pregnancy_reg_id\nfrom rch_pregnancy_analytics_details rpa\nleft join imt_family f on rpa.family_id = f.family_id and f.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'',''TEMPORARY'',''MIGRATED'')\nwhere \nf.id is null\n) and (select cast(key_value as boolean) as value from system_configuration where system_key = ''rch_pregnancy_analytics_run_for_all_pregnancy'' ) = false;\n\ndelete from rch_pregnancy_analytics_details where pregnancy_reg_id in (\nselect rpa.pregnancy_reg_id\nfrom rch_pregnancy_analytics_details rpa\nleft join rch_pregnancy_registration_det rpr on rpr.id = rpa.pregnancy_reg_id and rpr.state in (''DELIVERY_DONE'',''PENDING'',''PREGNANT'')\nwhere rpr.id is null\n)and (select cast(key_value as boolean) as value from system_configuration where system_key = ''rch_pregnancy_analytics_run_for_all_pregnancy'' ) = false;\n\n\nwith parameter as (\nselect \n(select to_date(key_value,''MM-DD-YYYY'') as  from_date from system_configuration  where system_key = ''rch_pregnancy_analytics_last_schedule_date'') as from_date\n,(select cast(key_value as boolean) as value from system_configuration where system_key = ''rch_pregnancy_analytics_run_for_all_pregnancy'') as run_for_all_pregnancy\n), member_det as (\nselect imt_member.id as member_id \nfrom imt_member,rch_pregnancy_registration_det rpa,parameter,imt_family f\nwhere rpa.member_id = imt_member.id\nand f.family_id = imt_member.family_id\n--and  imt_member.modified_on >= (select to_date(key_value,''MM-DD-YYYY'') as  from_date from system_configuration  where system_key = ''rch_pregnancy_analytics_last_schedule_date'') \n--and  imt_member.modified_on >= current_date - interval ''2 day'' \nand f.modified_on >= current_date - interval ''2 day'' \nand parameter.run_for_all_pregnancy = false\nunion\nselect member_id from rch_pregnancy_registration_det,parameter \nwhere parameter.run_for_all_pregnancy = true \n--or modified_on >= (select to_date(key_value,''MM-DD-YYYY'') as  from_date from system_configuration  where system_key = ''rch_pregnancy_analytics_last_schedule_date'')\nor modified_on >= current_date - interval ''2 day'' \nunion\nselect member_id from rch_lmp_follow_up ,parameter\n--where modified_on >= (select to_date(key_value,''MM-DD-YYYY'') as  from_date from system_configuration  where system_key = ''rch_pregnancy_analytics_last_schedule_date'') \nwhere modified_on >= current_date - interval ''2 day'' \nand parameter.run_for_all_pregnancy = false\nunion\nselect member_id from rch_anc_master ,parameter\n--where modified_on >= (select to_date(key_value,''MM-DD-YYYY'') as  from_date from system_configuration  where system_key = ''rch_pregnancy_analytics_last_schedule_date'') \nwhere modified_on >= current_date - interval ''2 day''  \nand parameter.run_for_all_pregnancy = false\nunion\nselect member_id from rch_wpd_mother_master,parameter\n--where modified_on >= (select to_date(key_value,''MM-DD-YYYY'') as  from_date from system_configuration  where system_key = ''rch_pregnancy_analytics_last_schedule_date'') \nwhere modified_on >= current_date - interval ''2 day'' \nand parameter.run_for_all_pregnancy = false\nunion\nselect member_id from rch_pnc_master ,parameter\n--where modified_on >= (select to_date(key_value,''MM-DD-YYYY'') as  from_date from system_configuration  where system_key = ''rch_pregnancy_analytics_last_schedule_date'') \nwhere modified_on >= current_date - interval ''2 day'' \nand parameter.run_for_all_pregnancy = false\n)\ninsert into t_pregnancy_registration_det(\n\tpregnancy_reg_id,member_id,unique_health_id,dob,family_id,member_name,mobile_number,reg_service_date,reg_service_date_month_year,reg_service_financial_year,\n\treg_server_date,pregnancy_reg_location_id,native_location_id,lmp_date,lmp_month_year,lmp_financial_year,edd,preg_reg_state,member_basic_state\n\t,early_anc,is_valid_for_tracking_report, family_basic_state, marital_status, address, husband_name, husband_mobile_number\n\t, hof_name, hof_mobile_number\n)\nselect rch_pregnancy_registration_det.id,\nrch_pregnancy_registration_det.member_id,\nimt_member.unique_health_id,\nimt_member.dob,\nimt_member.family_id,\nconcat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name),\nimt_member.mobile_number,\nreg_date,\ncast(date_trunc(''month'', reg_date) as date),\ncase when extract(month from reg_date) > 3 \n\tthen concat(extract(year from reg_date), ''-'', extract(year from reg_date) + 1)\n\telse concat(extract(year from reg_date) - 1, ''-'', extract(year from reg_date)) end,\nrch_pregnancy_registration_det.created_on,\nrch_pregnancy_registration_det.location_id,\nrch_pregnancy_registration_det.location_id,\nrch_pregnancy_registration_det.lmp_date,\ncast(date_trunc(''month'', rch_pregnancy_registration_det.lmp_date) as date),\ncase when extract(month from rch_pregnancy_registration_det.lmp_date) > 3 \n\tthen concat(extract(year from rch_pregnancy_registration_det.lmp_date), ''-'', extract(year from rch_pregnancy_registration_det.lmp_date) + 1)\n\telse concat(extract(year from rch_pregnancy_registration_det.lmp_date) - 1, ''-'', extract(year from rch_pregnancy_registration_det.lmp_date)) end,\nrch_pregnancy_registration_det.edd as edd,\nrch_pregnancy_registration_det.state as preg_reg_state,\nimt_member.basic_state as member_basic_state,\ncase when rch_pregnancy_registration_det.lmp_date + interval ''84 days'' >= rch_pregnancy_registration_det.reg_date then true else false end,\ncase when (imt_family.state in (''com.argusoft.imtecho.family.state.archived.temporary'',''com.argusoft.imtecho.family.state.archived.temporary.outofstate'', ''com.argusoft.imtecho.family.state.migrated.outofstate'') \n\tor imt_member.state in (''com.argusoft.imtecho.member.state.migrated.lfu'',''com.argusoft.imtecho.member.state.migrated.outofstate'',''com.argusoft.imtecho.member.state.archived.outofstate''))\n\tthen false else true end,\nimt_family.basic_state as family_basic_state,\nimt_member.marital_status as marital_status,\nconcat_ws('', '',imt_family.address1,imt_family.address2) as address,\nconcat_ws('' '', husband.first_name, husband.middle_name, husband.last_name) as husband_name,\nhusband.mobile_number as husband_mobile_number,\nconcat_ws('' '', hof.first_name, hof.middle_name, hof.last_name) as hof_name,\nhof.mobile_number as hof_mobile_number\n\nfrom member_det inner join\nrch_pregnancy_registration_det on member_det.member_id = rch_pregnancy_registration_det.member_id\ninner join imt_member on rch_pregnancy_registration_det.member_id = imt_member.id \nand imt_member.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'',''DEAD'',''TEMPORARY'',''MIGRATED'')\ninner join imt_family on imt_member.family_id = imt_family.family_id\nand imt_family.basic_state in(''VERIFIED'',''REVERIFICATION'',''NEW'',''TEMPORARY'',''MIGRATED'')\nleft join imt_member husband on imt_member.husband_id = husband.id\nleft join imt_member hof on imt_family.hof_id = hof.id\nwhere \nrch_pregnancy_registration_det.state in (''DELIVERY_DONE'',''PENDING'',''PREGNANT'');\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED1''\nwhere event_config_id = 39 and status = ''PROCESSED'';\ncommit;\n---2\nbegin;\nwith rch_anc_det as(\nselect rch_anc_master.*,sum(ifa_tablets_given)OVER(PARTITION BY rch_anc_master.pregnancy_reg_det_id ORDER BY rch_anc_master.service_date) as total_ifa_tab\nfrom rch_anc_master,t_pregnancy_registration_det\nwhere rch_anc_master.pregnancy_reg_det_id = t_pregnancy_registration_det.pregnancy_reg_id\nand rch_anc_master.member_status = ''AVAILABLE''\n)\nupdate t_pregnancy_registration_det \nset anc1 = (case when t.anc1 is not null then t.anc1\n\t\t\t\twhen t.anc2 is not null then t.anc2\n\t\t\t\twhen t.anc3 is not null then t.anc3\n\t\t\t\twhen t.anc4 is not null then t.anc4\n\t\t\tend)\t\t\t\t\n, anc1_location_id = (case when t.anc1 is not null then t.anc1_location_id\n\t\t\t\twhen t.anc2 is not null then t.anc2_location_id\n\t\t\t\twhen t.anc3 is not null then t.anc3_location_id\n\t\t\t\twhen t.anc4 is not null then t.anc4_location_id\n\t\t\tend)\n, anc2 = (case \twhen t.anc2 is not null and t.anc1 is not null then t.anc2\n\t\t\t\twhen t.anc3 is not null and (t.anc1 is not null or t.anc2 is not null) then t.anc3\n\t\t\t\twhen t.anc4 is not null and (t.anc1 is not null or t.anc2 is not null or t.anc3 is not null) then t.anc4\n\t\t\tend)\n, anc2_location_id = (case \twhen t.anc2 is not null and t.anc1 is not null then t.anc2_location_id\n\t\t\t\twhen t.anc3 is not null and (t.anc1 is not null or t.anc2 is not null) then t.anc3_location_id\n\t\t\t\twhen t.anc4 is not null and (t.anc1 is not null or t.anc2 is not null or t.anc3 is not null) then t.anc4_location_id\n\t\t\tend)\n, anc3 = (case \twhen t.anc3 is not null and (t.anc1 is not null and t.anc2 is not null) then t.anc3\n\t\t\t\twhen t.anc4 is not null and ((case when t.anc1 is not null then 1 else 0 end)\n\t\t\t\t\t\t\t\t\t\t\t+(case when t.anc2 is not null then 1 else 0 end)\n\t\t\t\t\t\t\t\t\t\t\t+(case when t.anc3 is not null then 1 else 0 end)) = 2 then t.anc4\n\t\t\t\t\t\t\t\t\t\t\t\n\t\t\tend)\n, anc3_location_id = (case \twhen t.anc3 is not null and (t.anc1 is not null and t.anc2 is not null) then t.anc3_location_id\n\t\t\t\twhen t.anc4 is not null and ((case when t.anc1 is not null then 1 else 0 end)\n\t\t\t\t\t\t\t\t\t\t\t+(case when t.anc2 is not null then 1 else 0 end)\n\t\t\t\t\t\t\t\t\t\t\t+(case when t.anc3 is not null then 1 else 0 end)) = 2 then t.anc4_location_id\n\t\t\t\t\t\t\t\t\t\t\t\n\t\t\tend)\n, anc4 = (case when t.anc4 is not null and t.anc1 is not null and t.anc2 is not null and t.anc3 is not null then t.anc4 end)\n, anc4_location_id = (case when t.anc4 is not null and t.anc1 is not null and t.anc2 is not null and t.anc3 is not null then t.anc4_location_id end)\n--, early_anc = case when t.early_reg = 1 then true else false end\n, alben_given = case when t.alben_given = 1 then true else false end,\nifa = t.ifa_tablets_given\n,ifa_180_anc_date = t.ifa_180_anc_date\n,ifa_180_anc_location = t.ifa_180_anc_location\n, total_anc = t.total_anc\n, fa_tab_in_30_day = t.fa_tab_in_30_day\n, fa_tab_in_31_to_60_day = t.fa_tab_in_31_to_60_day\n, fa_tab_in_61_to_90_day = t.fa_tab_in_61_to_90_day\n, ifa_tab_in_4_month_to_9_month = t.ifa_tab_in_4_month_to_9_month\n, ca_tab_in_91_to_180_day = t.ca_tab_in_91_to_180_day\n, ca_tab_in_181_to_360_day = t.ca_tab_in_181_to_360_day\n, hb = t.hb\n, hb_date = t.hb_date\n, haemoglobin_tested_count = t.haemoglobin_tested_count\n, total_ca = t.total_ca\n, expected_delivery_place = t.expected_delivery_place\n, hb_between_90_to_360_days = t.hb_between_90_to_360_days\n,hbsag_test_cnt = t.hbsag_test_cnt\n,hbsag_reactive_cnt = t.hbsag_reactive_cnt\n,hbsag_non_reactive_cnt = case when t.hbsag_test_cnt = 1 and t.hbsag_reactive_cnt = 0 then 1 else 0 end \n,iron_def_anemia_inj = t.iron_def_anemia_inj\n,blood_transfusion = case when t.blood_transfusion = 1 then true else false end\n,last_systolic_bp = t.systolic_bp\n,last_diastolic_bp = t.diastolic_bp\nfrom(\n\tselect t1.pregnancy_reg_det_id,t1.anc1,t1.anc2,t1.anc3,t1.anc4,t1.alben_given\n\t,t1.ifa_tablets_given,ifa_180_anc.service_date as ifa_180_anc_date,ifa_180_anc.location_id as ifa_180_anc_location\n\t,t1.total_anc\n\t,anc_master1.location_id as anc1_location_id,anc_master2.location_id as anc2_location_id\n\t,anc_master3.location_id as anc3_location_id,anc_master4.location_id as anc4_location_id\n\t,anc_systolic_bp.systolic_bp,anc_diastolic_bp.diastolic_bp\n\t,t1.fa_tab_in_30_day,t1.fa_tab_in_31_to_60_day,t1.fa_tab_in_61_to_90_day\n\t,t1.ifa_tab_in_4_month_to_9_month,anc_hb.haemoglobin_count as hb,anc_hb.service_date as hb_date\n\t,t1.haemoglobin_tested_count,t1.hb_between_90_to_360_days,t1.total_ca,t1.ca_tab_in_91_to_180_day\n\t,t1.ca_tab_in_181_to_360_day,t1.expected_delivery_place\n\t,t1.hbsag_test_cnt,t1.hbsag_reactive_cnt\n\t,iron_def_anemia_inj_det.iron_def_anemia_inj,t1.blood_transfusion\n\tfrom (\n\tselect rch_anc_master.pregnancy_reg_det_id,\n\tmin(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 0 and 84 then rch_anc_master.service_date else null end) anc1,\n\tmin(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 0 and 84 then rch_anc_master.id else null end) anc1_id,\n\tmin(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 85 and 182 then rch_anc_master.service_date else null end) anc2,\n\tmin(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 85 and 182 then rch_anc_master.id else null end) anc2_id,\n\tmin(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 183 and 238 then rch_anc_master.service_date else null end) anc3,\n\tmin(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 183 and 238 then rch_anc_master.id else null end) anc3_id,\n\tmin(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date >= 239 then rch_anc_master.service_date else null end) anc4,\n\tmin(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date >= 239 then rch_anc_master.id else null end) anc4_id,\n\t--max(case when t_pregnancy_registration_det.lmp_date + interval ''84 days'' > t_pregnancy_registration_det.reg_service_date then 1 else 0 end) early_reg,\n\tmax(case when rch_anc_master.systolic_bp is not null then rch_anc_master.id else null end) as systolic_bp,\n\tmax(case when rch_anc_master.diastolic_bp is not null then rch_anc_master.id else null end) as diastolic_bp,\n\tmax(case when albendazole_given then 1 else 0 end) as alben_given,\n\tsum(ifa_tablets_given) as ifa_tablets_given,\n\tsum(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 0 and 30 then fa_tablets_given else 0 end) as fa_tab_in_30_day,\n\tsum(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 31 and 60 then fa_tablets_given else 0 end) as fa_tab_in_31_to_60_day,\n\tsum(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 61 and 90 then fa_tablets_given else 0 end) as fa_tab_in_61_to_90_day,\n\tsum(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 90 and 270 then ifa_tablets_given else 0 end) as ifa_tab_in_4_month_to_9_month,\n\tmax(case when haemoglobin_count is not null then rch_anc_master.id else null end ) as hb,\n\tsum(case when haemoglobin_count is not null then 1 else 0 end )  as haemoglobin_tested_count,\n\tmax(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 90 and 360 then haemoglobin_count else 0 end) as hb_between_90_to_360_days,\n\tsum(calcium_tablets_given) as total_ca,\n\tsum(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 91 and 180 then calcium_tablets_given else 0 end) as ca_tab_in_91_to_180_day,\n\tsum(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 181 and 360 then calcium_tablets_given else 0 end) as ca_tab_in_181_to_360_day,\n\tmax(rch_anc_master.expected_delivery_place) as expected_delivery_place,\n\tmax(case when rch_anc_master.hbsag_test is not null then 1 else 0 end) as hbsag_test_cnt,\n\tmax(case when rch_anc_master.hbsag_test = ''REACTIVE'' then 1 else 0 end) as hbsag_reactive_cnt,\n\tmax(case when rch_anc_master.iron_def_anemia_inj in (''FCM'',''IRON_SUCROSE'') then rch_anc_master.id else null end) as iron_def_anemia_inj_anc_id,\n\tmax(case when rch_anc_master.blood_transfusion = true then 1 else 0 end) as blood_transfusion,\n\tcount(*) total_anc,\n\tmin(case when rch_anc_master.total_ifa_tab >= 180 then rch_anc_master.id end) as ifa_180_anc_id\n\tfrom rch_anc_det as rch_anc_master,t_pregnancy_registration_det\n\twhere rch_anc_master.pregnancy_reg_det_id = t_pregnancy_registration_det.pregnancy_reg_id\n\tand rch_anc_master.member_status = ''AVAILABLE''\n\tgroup by rch_anc_master.pregnancy_reg_det_id) as t1\n\tleft join rch_anc_master anc_master1 on anc_master1.id = t1.anc1_id\n\tleft join rch_anc_master anc_master2 on anc_master2.id = t1.anc2_id\n\tleft join rch_anc_master anc_master3 on anc_master3.id = t1.anc3_id\n\tleft join rch_anc_master anc_master4 on anc_master4.id = t1.anc3_id\n\tleft join rch_anc_master anc_systolic_bp on anc_systolic_bp.id = t1.systolic_bp\n\tleft join rch_anc_master anc_diastolic_bp on anc_diastolic_bp.id = t1.diastolic_bp\n\tleft join rch_anc_master anc_hb on anc_hb.id = t1.hb\n\tleft join rch_anc_master iron_def_anemia_inj_det on iron_def_anemia_inj_det.id = t1.iron_def_anemia_inj_anc_id \n\tleft join rch_anc_master ifa_180_anc on ifa_180_anc.id = t1.ifa_180_anc_id\n\t\n) as t\nwhere t.pregnancy_reg_det_id = t_pregnancy_registration_det.pregnancy_reg_id;\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED2''\nwhere event_config_id = 39 and status = ''PROCESSED1'';\ncommit;\n---3\nbegin;\n/*\nupdate t_pregnancy_registration_det \nset hbsag_test_cnt = t.hbsag_test_cnt,\nhbsag_reactive_cnt = t.hbsag_reactive_cnt,\nhbsag_non_reactive_cnt = case when t.hbsag_test_cnt = 1 and t.hbsag_reactive_cnt = 0 then 1 else 0 end \nfrom (  \n\tselect rch_anc_master.pregnancy_reg_det_id,\n\tmax(case when rch_anc_master.hbsag_test is not null then 1 else 0 end) as hbsag_test_cnt,\n\tmax(case when rch_anc_master.hbsag_test = ''REACTIVE'' then 1 else 0 end) as hbsag_reactive_cnt\n\t--sum(case when rch_anc_master.hbsag_test = ''NON_REACTIVE'' then 1 else 0 end) as hbsag_non_reactive_cnt\n\tfrom rch_anc_master \n\tinner join t_pregnancy_registration_det \n\ton rch_anc_master.pregnancy_reg_det_id = t_pregnancy_registration_det.pregnancy_reg_id\n\twhere rch_anc_master.member_status = ''AVAILABLE''\n\tgroup by rch_anc_master.pregnancy_reg_det_id\n) as t\nwhere t.pregnancy_reg_det_id = t_pregnancy_registration_det.pregnancy_reg_id;\n*/\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED3''\nwhere event_config_id = 39 and status = ''PROCESSED2'';\n\ncommit;\n\n---4\nbegin;\nupdate t_pregnancy_registration_det \nset cur_severe_anemia = case when t.cur_severe_anemia = 1 then true else false end\n,cur_blood_pressure_issue = case when t.cur_blood_pressure_issue = 1 then true else false end \n,low_height = case when t.low_height = 1 then true else false end \n,cur_low_weight = case when t.cur_low_weight = 1 then true else false end\n,urine_albumin = case when t.urine_albumin = 1 then true else false end\n,high_risk_mother = case when t.high_risk_mother = 1 then true else false end\n,pre_preg_anemia = case when t.pre_preg_anemia = 1 then true else false end\n,pre_preg_caesarean_section = case when t.pre_preg_caesarean_section = 1 then true else false end\n,pre_preg_abortion = case when t.pre_preg_abortion = 1 then true else false end\n,pre_preg_aph = case when t.pre_preg_aph = 1 then true else false end\n,pre_preg_pph = case when t.pre_preg_pph = 1 then true else false end\n,pre_preg_pre_eclampsia = case when t.pre_preg_pre_eclampsia = 1 then true else false end\n,pre_preg_obstructed_labour = case when t.pre_preg_obstructed_labour = 1 then true else false end\n,pre_preg_placenta_previa = case when t.pre_preg_placenta_previa = 1 then true else false end\n,pre_preg_malpresentation = case when t.pre_preg_malpresentation = 1 then true else false end\n,pre_preg_birth_defect = case when t.pre_preg_birth_defect = 1 then true else false end\n,pre_preg_preterm_delivery = case when t.pre_preg_preterm_delivery = 1 then true else false end\n,cur_urine_protein_issue = case when t.cur_urine_protein_issue = 1 then true else false end\n,cur_convulsion_issue = case when t.cur_convulsion_issue = 1 then true else false end\n,cur_malaria_issue = case when t.cur_malaria_issue = 1 then true else false end\n,cur_gestational_diabetes_issue = case when t.cur_gestational_diabetes_issue = 1 then true else false end\n,cur_twin_pregnancy = case when t.cur_twin_pregnancy = 1 then true else false end\n,cur_mal_presentation_issue = case when t.cur_mal_presentation_issue = 1 then true else false end\n,cur_absent_reduce_fetal_movment = case when t.cur_absent_reduce_fetal_movment = 1 then true else false end\n,cur_aph_issue = case when t.cur_aph_issue = 1 then true else false end\n,cur_pelvic_sepsis = case when t.cur_pelvic_sepsis = 1 then true else false end\n,cur_hiv_issue = case when t.cur_hiv_issue = 1 then true else false end\n,cur_vdrl_issue = case when t.cur_vdrl_issue = 1 then true else false end\n,cur_hbsag_issue = case when t.cur_hbsag_issue = 1 then true else false end\n,cur_brethless_issue = case when t.cur_brethless_issue = 1 then true else false end\n,high_risk_cnt = t.pre_preg_anemia + t.pre_preg_caesarean_section \n\t+ (case when t.pre_preg_aph = 1 or t.pre_preg_pph = 1 then 1 else 0 end)\n\t+ t.pre_preg_pre_eclampsia + t.pre_preg_abortion + t.pre_preg_obstructed_labour \n\t+ t.pre_preg_placenta_previa + t.pre_preg_malpresentation + t.pre_preg_birth_defect\n\t+ t.pre_preg_preterm_delivery + t.cur_severe_anemia + t.cur_low_weight + t.low_height\n\t+ (case when t.cur_blood_pressure_issue = 1 or t.cur_urine_protein_issue = 1 or t.cur_convulsion_issue = 1 then 1 else 0 end)\n\t+ t.cur_malaria_issue + t.cur_gestational_diabetes_issue + t.cur_twin_pregnancy + t.cur_mal_presentation_issue\n\t+ t.cur_absent_reduce_fetal_movment + t.cur_aph_issue + t.cur_pelvic_sepsis + t.cur_brethless_issue\n\t+ (case when t.cur_hiv_issue = 1 or t.cur_vdrl_issue = 1 or t.cur_hbsag_issue = 1 then 1 else 0 end)\nfrom (\n\tselect rch_anc_master.pregnancy_reg_det_id,\n\tmax(\n\tcase when \n\tdanger_sign.dangerous_sign_id = (\n\tselect id from listvalue_field_value_detail where value = ''Severe anemia''\n\t) or rch_anc_master.haemoglobin_count <= 7 \n\tthen 1 else 0 end\n\t) cur_severe_anemia,\n\tmax(case when rch_anc_master.member_height < 140 then 1 else 0 end) low_height,\n\tmax(case when rch_anc_master.systolic_bp >= 140 or rch_anc_master.diastolic_bp >= 90 then 1 else 0 end) as cur_blood_pressure_issue,\n\tmax(case when rch_anc_master.weight <= 40 then 1 else 0 end) cur_low_weight,\n\tmax(case when rch_anc_master.urine_albumin is not null and rch_anc_master.urine_albumin <> ''0'' then 1 else 0 end) urine_albumin,\n\tmax(\n\tcase when \n\t(urine_sugar is not null and urine_sugar != ''0'') \n\tor sugar_test_after_food_val >140 \n\tor danger_sign.dangerous_sign_id = 769/*Urine sugar*/ \n\tthen 1 else 0 end\n\t) cur_gestational_diabetes_issue,\n\tmax(\n\tcase when \n\trch_anc_master.foetal_movement in (''DECREASED'',''ABSENT'')\n\tor (rch_anc_master.foetal_position is not null and rch_anc_master.foetal_position not in(''VERTEX'',''CBMO''))\n\tor rch_anc_master.hiv_test = ''POSITIVE''\n\tor rch_anc_master.vdrl_test = ''POSITIVE''\n\tor rch_anc_master.hbsag_test = ''REACTIVE''\n\tor pre_compl.previous_pregnancy_complication in (\n\t''SEVANM''/*Anemia*/\n\t,''CAESARIAN''/*Caesarean Section*/\n\t,''APH'',''PPH''/*Ante partum Haemorrhage(APH)/Post partum Haemorrhage (PPH)*/\n\t,''CONVLS''/*Pre Eclampsia or Eclampsia*/\n\t,''P2ABO''/*Abortion*/\n\t,''OBSLBR''/*OBSLBR*/\n\t,''PLPRE''/*Placenta previa*/\n\t,''MLPRST''/*Malpresentation*/\n\t,''CONGDEF''/*Birth defect*/\n\t,''PRETRM''/*Preterm delivery*/\n\t) or danger_sign.dangerous_sign_id in (\n\t768/*urine protein*/\n\t,909/*convulsion*/\n\t,769/*Urine Sugar*/\n\t,912/*Twin*/\n\t,1024/*Malaria Fever*/\n\t,910/*APH*/\n\t,911/*Pelvic sepsis (vaginal discharge)(Foul smelling discharge)*/\n\t,915/*Breathlessness*/\n\t)\n\tthen 1 else 0 end\n\t) as high_risk_mother,\n\tmax(case when pre_compl.previous_pregnancy_complication = ''SEVANM'' then 1 else 0 end) as pre_preg_anemia,\n\tmax(case when pre_compl.previous_pregnancy_complication = ''CAESARIAN'' then 1 else 0 end) as pre_preg_caesarean_section,\n\t--max(case when pre_compl.previous_pregnancy_complication = ''APH'' or pre_compl.previous_pregnancy_complication = ''PPH''  then 1 else 0 end) as prev_aph_pph,\n\tmax(case when pre_compl.previous_pregnancy_complication = ''P2ABO''   then 1 else 0 end) as pre_preg_abortion,\n\t\n\tmax(case when pre_compl.previous_pregnancy_complication = ''APH''   then 1 else 0 end) as pre_preg_aph,\n\tmax(case when pre_compl.previous_pregnancy_complication = ''PPH''   then 1 else 0 end) as pre_preg_pph,\n\tmax(case when pre_compl.previous_pregnancy_complication = ''CONVLS''   then 1 else 0 end) as pre_preg_pre_eclampsia,\n\tmax(case when pre_compl.previous_pregnancy_complication = ''OBSLBR''   then 1 else 0 end) as pre_preg_obstructed_labour,\n\tmax(case when pre_compl.previous_pregnancy_complication = ''PLPRE''   then 1 else 0 end) as pre_preg_placenta_previa,\n\tmax(case when pre_compl.previous_pregnancy_complication = ''MLPRST''   then 1 else 0 end) as pre_preg_malpresentation,\n\tmax(case when pre_compl.previous_pregnancy_complication = ''CONGDEF''   then 1 else 0 end) as pre_preg_birth_defect,\n\tmax(case when pre_compl.previous_pregnancy_complication = ''PRETRM''   then 1 else 0 end) as pre_preg_preterm_delivery,\n\t\n\tmax(case when danger_sign.dangerous_sign_id  = 768   then 1 else 0 end) as cur_urine_protein_issue,\n\tmax(case when danger_sign.dangerous_sign_id  = 909   then 1 else 0 end) as cur_convulsion_issue,\n\tmax(case when danger_sign.dangerous_sign_id  = 1024   then 1 else 0 end) as cur_malaria_issue,\n\tmax(case when danger_sign.dangerous_sign_id  = 912   then 1 else 0 end) as cur_twin_pregnancy,\n\tmax(case when (rch_anc_master.foetal_position is not null and  rch_anc_master.foetal_position not in(''VERTEX'',''CBMO'')) then 1 else 0 end) as cur_mal_presentation_issue,\n\tmax(case when rch_anc_master.foetal_movement in (''DECREASED'',''ABSENT'')   then 1 else 0 end) as cur_absent_reduce_fetal_movment,\n\tmax(case when danger_sign.dangerous_sign_id  = 910   then 1 else 0 end) as cur_aph_issue,\n\tmax(case when danger_sign.dangerous_sign_id  = 911   then 1 else 0 end) as cur_pelvic_sepsis,\n\tmax(case when rch_anc_master.hiv_test = ''POSITIVE'' then 1 else 0 end) as cur_hiv_issue,\n\tmax(case when rch_anc_master.vdrl_test = ''POSITIVE'' then 1 else 0 end) as cur_vdrl_issue,\n\tmax(case when rch_anc_master.hbsag_test = ''REACTIVE'' then 1 else 0 end) as cur_hbsag_issue,\n\tmax(case when danger_sign.dangerous_sign_id  = 915   then 1 else 0 end) as cur_brethless_issue\n\t\n\t--count(DISTINCT danger_sign.dangerous_sign_id) as high_risk_cnt\n\t\n\tfrom rch_anc_master \n\tinner join t_pregnancy_registration_det \n\ton rch_anc_master.pregnancy_reg_det_id = t_pregnancy_registration_det.pregnancy_reg_id\n\tleft join rch_anc_dangerous_sign_rel as danger_sign on danger_sign.anc_id = rch_anc_master.id\n\tleft join rch_anc_previous_pregnancy_complication_rel as pre_compl on pre_compl.anc_id = rch_anc_master.id\n\twhere rch_anc_master.member_status = ''AVAILABLE''\n\tgroup by rch_anc_master.pregnancy_reg_det_id\n) as t\nwhere t.pregnancy_reg_det_id = t_pregnancy_registration_det.pregnancy_reg_id;\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED4''\nwhere event_config_id = 39 and status = ''PROCESSED3'';\ncommit;\n\n---  add high risk reason string\nbegin;\n\tupdate t_pregnancy_registration_det\n\tset \n\thigh_risk_reasons = t.high_risk_reasons\n\tfrom (\n\t\tselect \n\t\tpregnancy_reg_id\n\t\t,concat_ws ('','',\n\t\tcase when r.pre_preg_anemia = true then ''Anaemia'' else null end,\n\t\tcase when r.pre_preg_caesarean_section = true then ''Caesarean Section'' else null end,\n\t\tcase when r.pre_preg_aph = true then ''prev preg Ante partum Haemorrhage(APH)'' else null end,\n\t\tcase when r.pre_preg_pph = true then ''prev preg Post partum Haemorrhage (PPH)'' else null end,\n\t\tcase when r.pre_preg_pre_eclampsia = true then ''Pre Eclampsia/Eclampsia'' else null end,\n\t\tcase when r.pre_preg_abortion = true then ''Abortion'' else null end,\n\t\tcase when r.pre_preg_obstructed_labour = true then ''Obstructed labour'' else null end,\n\t\tcase when r.pre_preg_placenta_previa = true then ''Placenta previa'' else null end,\n\t\tcase when r.pre_preg_malpresentation = true then ''Malpresentation'' else null end,\n\t\tcase when r.pre_preg_birth_defect = true then ''Birth defect'' else null end,\n\t\tcase when r.pre_preg_preterm_delivery = true then ''Preterm delivery'' else null end,\t\t\n\t\tcase when r.chro_tb = true then ''Tuberculosis'' else null end,\n\t\tcase when r.chro_diabetes = true then ''Diabetes Mellitus'' else null end,\n\t\tcase when r.chro_heart_kidney = true then ''Heart/Kidney Diseases'' else null end,\n\t\tcase when r.chro_hiv = true then ''pre existing chronic HIV'' else null end,\n\t\tcase when r.chro_sickle = true then ''Sickle cell Anemia'' else null end,\n\t\tcase when r.chro_thalessemia = true then ''Thalessemia'' else null end,\n\t\tcase when r.cur_extreme_age = true then ''Extreme age(less than 18 and more than 35 years)'' else null end,\n\t\tcase when r.cur_low_weight = true then ''Weight (less than 45 kg)'' else null end,\t\t\n\t\tcase when r.cur_severe_anemia = true then ''present pregnency anemia'' else null end,\n\t\tcase when r.cur_blood_pressure_issue = true then ''Blood Pressure (More than 140/90)'' else null end,\n\t\tcase when r.cur_urine_protein_issue = true then ''oedema or urine protein or headache with blurred vision'' else null end,\n\t\tcase when r.cur_convulsion_issue = true then ''convulsion'' else null end,\n\t\tcase when r.cur_malaria_issue = true then ''Malaria'' else null end,\n\t\tcase when r.cur_social_vulnerability = true then ''Severe social vulnerability'' else null end,\n\t\tcase when r.cur_gestational_diabetes_issue = true then ''Gestational diabetes mellitus'' else null end,\n\t\tcase when r.cur_twin_pregnancy = true then ''Twin Pregnancy'' else null end,\n\t\tcase when r.cur_mal_presentation_issue = true then ''Mal presentation'' else null end,\n\t\tcase when r.cur_absent_reduce_fetal_movment = true then ''Absent or reduced fetal movement'' else null end,\n\t\tcase when r.cur_less_than_18_month_interval = true then ''Interval between two pregnancy (less than 18 Months)'' else null end,\n\t\tcase when r.cur_aph_issue = true then ''present pregnency Antepartum haemorrhage'' else null end,\n\t\tcase when r.cur_pelvic_sepsis = true then ''Pelvic sepsis (vaginal discharge)'' else null end,\n\t\tcase when r.cur_hiv_issue = true then ''present pregnency HIV'' else null end,\n\t\tcase when r.cur_vdrl_issue = true then ''present pregnency VDRL'' else null end,\n\t\tcase when r.cur_hbsag_issue = true then ''present pregnency HBsAg'' else null end,\n\t\tcase when r.cur_brethless_issue = true then ''Breathlessness'' else null end\t\t\n\t\t) as high_risk_reasons\n\t\tfrom \n\t\tt_pregnancy_registration_det r\n\t\twhere r.high_risk_mother = true\t\t\n\t ) as t\n\twhere t_pregnancy_registration_det.pregnancy_reg_id = t.pregnancy_reg_id;\t\n\ncommit;\n\n\n---\n\n\n\n---5\nbegin;\nupdate t_pregnancy_registration_det \nset tt1_given = t.tt1_given\n,tt2_given = t.tt2_given\n,tt_boster = t.tt_boster\n,tt2_tt_booster_given = case when t.tt_boster is not null then t.tt_boster else t.tt2_given end\n,tt1_location_id = t.tt1_location_id\n,tt2_location_id = t.tt2_location_id\n,tt_booster_location_id = t.tt_booster_location_id\n,tt2_tt_booster_location_id = case when t.tt_booster_location_id is not null then t.tt_booster_location_id else t.tt2_location_id end\nfrom (\n\tselect t1.pregnancy_reg_det_id,t1.tt1_given,t1.tt2_given,t1.tt_boster\n\t,tt1_immunization_det.location_id as tt1_location_id\n\t,tt2_immunization_det.location_id as tt2_location_id\n\t,tt_booster_immunization_det.location_id as tt_booster_location_id\n\tfrom (\n\tselect rch_immunisation_master.pregnancy_reg_det_id,\n\tmax(case when rch_immunisation_master.immunisation_given = ''TT1'' then given_on else null end) as tt1_given,\n\tmax(case when rch_immunisation_master.immunisation_given = ''TT1'' then rch_immunisation_master.id else null end) as tt1_id,\n\tmax(case when rch_immunisation_master.immunisation_given = ''TT2'' then given_on else null end) as tt2_given,\n\tmax(case when rch_immunisation_master.immunisation_given = ''TT2'' then rch_immunisation_master.id else null end) as tt2_id,\n\tmax(case when rch_immunisation_master.immunisation_given = ''TT_BOOSTER'' then given_on else null end) as tt_boster,\n\tmax(case when rch_immunisation_master.immunisation_given = ''TT_BOOSTER'' then rch_immunisation_master.id else null end) as tt_boster_id\n\tfrom rch_immunisation_master \n\tinner join t_pregnancy_registration_det \n\ton rch_immunisation_master.pregnancy_reg_det_id = t_pregnancy_registration_det.pregnancy_reg_id\n\tgroup by rch_immunisation_master.pregnancy_reg_det_id\n\t) as t1\n\tleft join rch_immunisation_master tt1_immunization_det on tt1_immunization_det.id = tt1_id\n\tleft join rch_immunisation_master tt2_immunization_det on tt2_immunization_det.id = tt2_id\n\tleft join rch_immunisation_master tt_booster_immunization_det on tt_booster_immunization_det.id = tt_boster_id\t\n) as t\nwhere t.pregnancy_reg_det_id = t_pregnancy_registration_det.pregnancy_reg_id;\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED5''\nwhere event_config_id = 39 and status = ''PROCESSED4'';\ncommit;\n---6\nbegin;\nupdate t_pregnancy_registration_det \nset registered_with_no_of_child = t.registered_with_no_of_child\n,registered_with_male_cnt = t.registered_with_male_cnt\n,registered_with_female_cnt = t.registered_with_female_cnt\n,prev_preg_diff_in_month = EXTRACT(year FROM age(t_pregnancy_registration_det.lmp_date,t.last_delivery_date))*12 + EXTRACT(month FROM age(t_pregnancy_registration_det.lmp_date,t.last_delivery_date))\nfrom (  \n\tselect t_pregnancy_registration_det.pregnancy_reg_id,\n\tsum(case when imt_member.death_detail_id is null or rch_member_death_deatil.dod > t_pregnancy_registration_det.lmp_date then 1 else 0 end) as registered_with_no_of_child,\n\tsum(\n\tcase when (imt_member.death_detail_id is null or rch_member_death_deatil.dod > t_pregnancy_registration_det.lmp_date) \n\tand imt_member.gender = ''M'' then 1 else 0 end\n\t) as registered_with_male_cnt,\n\tsum(\n\tcase when (imt_member.death_detail_id is null or rch_member_death_deatil.dod > t_pregnancy_registration_det.lmp_date) \n\tand imt_member.gender = ''F'' then 1 else 0 end\n\t) as registered_with_female_cnt,\n\tmax(imt_member.dob) as last_delivery_date\n\tfrom imt_member \n\tinner join t_pregnancy_registration_det \n\ton imt_member.mother_id = t_pregnancy_registration_det.member_id\n\tand imt_member.dob < t_pregnancy_registration_det.lmp_date\n\tleft join rch_member_death_deatil on imt_member.death_detail_id = rch_member_death_deatil.id\n\tgroup by t_pregnancy_registration_det.pregnancy_reg_id\n) as t\nwhere t.pregnancy_reg_id = t_pregnancy_registration_det.pregnancy_reg_id;\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED6''\nwhere event_config_id = 39 and status = ''PROCESSED5'';\ncommit;\n\n---7\n---------------------------------------------delivery related-------------------------------------------------------------------------------------------------------\nbegin;\nupdate t_pregnancy_registration_det \nset date_of_delivery_month_year = t.date_of_delivery_month_year\n,date_of_delivery = t.date_of_delivery\n,delivery_reg_date = t.delivery_reg_date\n,delivery_reg_date_financial_year = case when t.delivery_reg_date is not null and extract(month from t.delivery_reg_date) > 3 \n\tthen concat(extract(year from t.delivery_reg_date), ''-'', extract(year from t.delivery_reg_date) + 1)\n\twhen t.delivery_reg_date is not null then concat(extract(year from t.delivery_reg_date) - 1, ''-'', extract(year from t.delivery_reg_date)) end \n,delivery_location_id = t.delivery_location_id\n,delivery_family_id = t.delivery_family_id\n,delivery_hospital = t.delivery_hospital\n,delivery_health_infrastructure = t.delivery_health_infrastructure\n,delivery_outcome = t.delivery_outcome\n,type_of_delivery = t.type_of_delivery\n,delivery_done_by = t.delivery_done_by\n,delivery_place = t.delivery_place\n,home_del = case when t.home_del = 1 then true else false end\n,institutional_del = case when t.institutional_del = 1 then true else false end\n,delivery_108 = case when t.delivery_108 = 1 then true else false end\n,delivery_out_of_state_govt = case when t.delivery_out_of_state_govt = 1 then true else false end\n,delivery_out_of_state_pvt = case when t.delivery_out_of_state_pvt = 1 then true else false end\n,breast_feeding_in_one_hour = case when t.breast_feeding_in_one_hour = 1 then true else false end\n,del_week = t.del_week\n,is_cortico_steroid = case when t.is_cortico_steroid = 1 then true else false end\n,mother_alive = case when t.mother_alive = 1 then true else false end\n,total_out_come = t.total_out_come\n,male = t.male\n,female = t.female\n,still_birth = t.still_birth\n,live_birth = t.live_birth\n,ppiucd_insert_date = t.ppiucd_insert_date\n,ppiucd_insert_location = t.ppiucd_insert_location\n,is_fru = (case when t.is_fru = 1 then true else false end)\nfrom(\n\tselect t_pregnancy_registration_det.pregnancy_reg_id,\n\tmax(cast(date_trunc(''month'', rwmm.date_of_delivery) as date)) as date_of_delivery_month_year,\n\tmax(rwmm.date_of_delivery) as date_of_delivery,\n\tmax(rwmm.date_of_delivery) as delivery_reg_date,\n\tmax(rwmm.location_id) as delivery_location_id,\n\tmax(rwmm.family_id) as delivery_family_id,\n\tmax(rwmm.type_of_hospital) as delivery_hospital,\n\tmax(rwmm.health_infrastructure_id) as delivery_health_infrastructure,\n\tmax(rwmm.pregnancy_outcome) as delivery_outcome,\n\tmax(rwmm.type_of_delivery) as type_of_delivery,\n\tmax(rwmm.delivery_done_by) as delivery_done_by,\n\tmax(case when rwmm.delivery_place in (''HOME'',''ON_THE_WAY'') then 1 else 0 end) as home_del,\n\tmax(case when rwmm.delivery_place = ''HOSP'' then 1 else 0 end) as institutional_del,\n\tmax(case when rwmm.delivery_place = ''108_AMBULANCE'' then 1 else 0 end) as delivery_108,\n    max(case when rwmm.delivery_place = ''OUT_OF_STATE_GOVT'' then 1 else 0 end) as delivery_out_of_state_govt,\n    max(case when rwmm.delivery_place = ''OUT_OF_STATE_PVT'' then 1 else 0 end) as delivery_out_of_state_pvt,\n\tmax(rwmm.delivery_place) as delivery_place,\n\tmax(case when rwmm.breast_feeding_in_one_hour = true or rwmm.breast_feeding_in_one_hour then 1 else 0 end) as breast_feeding_in_one_hour,\n\tmax(TRUNC(DATE_PART(''day'', rwmm.date_of_delivery- cast(t_pregnancy_registration_det.lmp_date as timestamp))/7)) as del_week,\n\tmax(case when rwmm.cortico_steroid_given = true then 1 else 0 end) as is_cortico_steroid,\n\tmax(case when rwmm.mother_alive = false then 0 else 1 end) as mother_alive,\n\tsum(case when rwcm.pregnancy_outcome = ''LBIRTH'' then 1 else 0 end) as total_out_come,\n\tsum(case when rwcm.pregnancy_outcome = ''LBIRTH'' and rwcm.gender = ''M''  then 1 else 0 end) as male,\n\tsum(case when rwcm.pregnancy_outcome = ''LBIRTH'' and rwcm.gender = ''F''  then 1 else 0 end) as female,\n\tsum(case when rwcm.pregnancy_outcome = ''SBIRTH'' then 1 else 0 end) as still_birth,\n\tsum(case when rwcm.pregnancy_outcome = ''LBIRTH'' then 1 else 0 end) as live_birth,\n\tmax(case when rwmm.family_planning_method = ''PPIUCD'' then rwmm.date_of_delivery end) as ppiucd_insert_date,\n\tmax(case when rwmm.family_planning_method = ''PPIUCD'' then rwmm.location_id end) as ppiucd_insert_location,\n\tmax(case when hid.is_fru then 1 else 0 end) as is_fru\n\tfrom t_pregnancy_registration_det \n\tinner join rch_wpd_mother_master rwmm on t_pregnancy_registration_det.pregnancy_reg_id = rwmm.pregnancy_reg_det_id\n\tleft join rch_wpd_child_master rwcm on rwmm.id = rwcm.wpd_mother_id \n\tleft join health_infrastructure_details hid on hid.id = rwmm.health_infrastructure_id\n\twhere rwmm.member_status in (''AVAILABLE'',''DEATH'') and (rwmm.state is null or rwmm.state != ''MARK_AS_FALSE_DELIVERY'')\n\tgroup by t_pregnancy_registration_det.pregnancy_reg_id\n) as t\nwhere t.pregnancy_reg_id = t_pregnancy_registration_det.pregnancy_reg_id;\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED7''\nwhere event_config_id = 39 and status = ''PROCESSED6'';\ncommit;\n\n---8\nbegin;\nupdate t_pregnancy_registration_det \nset prev_preg_diff_in_month = case when \n\tprev_preg_diff_in_month < (\n\tEXTRACT(year FROM age(t_pregnancy_registration_det.lmp_date,t.last_delivery_date))*12 \n\t+ EXTRACT(month FROM age(t_pregnancy_registration_det.lmp_date,t.last_delivery_date))\n\t) \n\tthen prev_preg_diff_in_month \n\telse (\n\tEXTRACT(year FROM age(t_pregnancy_registration_det.lmp_date,t.last_delivery_date))*12 \n\t+ EXTRACT(month FROM age(t_pregnancy_registration_det.lmp_date,t.last_delivery_date))\n\t) end\nfrom (  \n\tselect t_pregnancy_registration_det.pregnancy_reg_id,\n\tmax(rch_wpd_mother_master.date_of_delivery) as last_delivery_date\n\tfrom t_pregnancy_registration_det INNER join\n\trch_wpd_mother_master on t_pregnancy_registration_det.member_id = rch_wpd_mother_master.member_id\n\tand rch_wpd_mother_master.date_of_delivery < t_pregnancy_registration_det.lmp_date\n\tgroup by t_pregnancy_registration_det.pregnancy_reg_id\n) as t\nwhere t.pregnancy_reg_id = t_pregnancy_registration_det.pregnancy_reg_id;\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED8''\nwhere event_config_id = 39 and status = ''PROCESSED7'';\ncommit;\n\n---9\nbegin;\nupdate t_pregnancy_registration_det \nset cur_extreme_age = case when t.cur_extreme_age = 1 then true else false end\n,chro_tb = case when t.chro_tb = 1 then true else false end\n,chro_diabetes = case when t.chro_diabetes = 1 then true else false end\n,chro_heart_kidney = case when t.chro_heart_kidney = 1 then true else false end\n,chro_hiv = case when t.chro_hiv = 1 then true else false end\n,chro_sickle = case when t.chro_sickle = 1 then true else false end\n,chro_thalessemia = case when t.chro_thalessemia = 1 then true else false end\n,member_current_location_id = t.member_current_location_id\n,tracking_location_id = t.member_current_location_id\n,age_during_delivery = t.age_during_delivery\n,any_chronic_dis = case when t.any_chronic_dis = 1 then true else false end\n,cur_social_vulnerability = case when t.cur_social_vulnerability = 1 then true else false end\n,maternal_detah = case when t.maternal_detah = 1 then true else false end\n,maternal_death_type = t.maternal_death_type\n,death_date = t.death_date\n,death_location_id = t.death_location_id\nfrom (\n\tselect t_pregnancy_registration_det.pregnancy_reg_id,\n\tmax (case when extract(years from age(t_pregnancy_registration_det.lmp_date,mem.dob)) < 18 or extract(years from age(t_pregnancy_registration_det.lmp_date,mem.dob)) > 35 then 1 else 0 end) cur_extreme_age,\n\tmax(extract(years from age(t_pregnancy_registration_det.lmp_date,mem.dob))) as age_during_delivery,\n\tmax(case when chronic.chronic_disease_id = ''715'' then 1 else 0 end) as chro_tb,\n\tmax(case when chronic.chronic_disease_id = ''726'' then 1 else 0 end) as chro_diabetes,\n\tmax(case when chronic.chronic_disease_id = ''713'' then 1 else 0 end) as chro_heart_kidney,\n\tmax(case when chronic.chronic_disease_id = ''735'' then 1 else 0 end) as chro_hiv,\n\tmax(case when chronic.chronic_disease_id = ''729'' then 1 else 0 end) as chro_sickle,\n\tmax(case when chronic.chronic_disease_id = ''730'' then 1 else 0 end) as chro_thalessemia,\n\tmax(case when fam.area_id is null then fam.location_id else cast(fam.area_id as bigint) end) as member_current_location_id,\n\tmax(case when chronic.chronic_disease_id is not null then 1 else 0 end) as any_chronic_dis,\n\tmax(case when fam.vulnerable_flag = true then 1 else 0 end) as cur_social_vulnerability,\n\tmax(\n\tcase when \n\tmem.basic_state = ''DEAD''\n\tand (\n\tt_pregnancy_registration_det.date_of_delivery is null \n\tor (\n\trch_member_death_deatil.id is not null \n\tand (cast(rch_member_death_deatil.dod as date) - cast(t_pregnancy_registration_det.date_of_delivery as date) between  0 and 42)\n\t)\n\t) then 1 else 0 end\n\t) as maternal_detah,\n\tmax(\n\t\tcase when \n\t\t\tmem.basic_state = ''DEAD''\n\t\t\tand \n\t\t\tt_pregnancy_registration_det.date_of_delivery is null \n\t\t\tthen ''PRE-PARTUM''\n\t\twhen \n\t\t\tmem.basic_state = ''DEAD''\n\t\t\tand (\n\t\t\trch_member_death_deatil.id is not null \n\t\t\tand (cast(rch_member_death_deatil.dod as date) - cast(t_pregnancy_registration_det.date_of_delivery as date) =  0 )\n\t\t\t) then ''INTRA-PARTUM'' \n\t\twhen\n\t\t\tmem.basic_state = ''DEAD''\n\t\t\tand (\n\t\t\trch_member_death_deatil.id is not null \n\t\t\tand (cast(rch_member_death_deatil.dod as date) - cast(t_pregnancy_registration_det.date_of_delivery as date) between  0 and 42)\n\t\t\t) then ''POST-PARTUM'' \n\t\telse \n\t\t\tnull end\n\t) as maternal_death_type,\n\tmax(rch_member_death_deatil.dod) as death_date,\n\tmax(rch_member_death_deatil.location_id) as death_location_id\n\tfrom t_pregnancy_registration_det \n\tinner join imt_member mem on t_pregnancy_registration_det.member_id = mem.id\n\tinner join imt_family fam on mem.family_id= fam.family_id\n\tleft join  imt_member_chronic_disease_rel chronic on mem.id = chronic.member_id \n\tleft join rch_member_death_deatil on rch_member_death_deatil.id = mem.death_detail_id\n\tgroup by t_pregnancy_registration_det.pregnancy_reg_id\n) as t\nwhere t.pregnancy_reg_id = t_pregnancy_registration_det.pregnancy_reg_id;\n\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED9''\nwhere event_config_id = 39 and status = ''PROCESSED8'';\ncommit;\n\n\n---10\nbegin;\nupdate t_pregnancy_registration_det \nset \npnc1 = (case when t.pnc1 is not null then t.pnc1 end)\n, pnc1_location_id = (case when t.pnc1 is not null then t.pnc1_location_id end)\n, pnc2 = (case when t.pnc2 is not null then t.pnc2 end)\n, pnc2_location_id = (case when t.pnc2 is not null then t.pnc2_location_id end)\n, pnc3 = (case when t.pnc3 is not null then t.pnc3 end)\n, pnc3_location_id = (case when t.pnc3 is not null then t.pnc3_location_id end)\n, pnc4 = (case when t.pnc4 is not null then t.pnc4 end)\n, pnc4_location_id = (case when t.pnc4 is not null then t.pnc4_location_id end)\n, pnc5 = (case when t.pnc5 is not null then t.pnc5 end)\n, pnc5_location_id = (case when t.pnc5 is not null then t.pnc5_location_id end)\n, pnc6 = (case when t.pnc6 is not null then t.pnc6 end)\n, pnc6_location_id = (case when t.pnc6 is not null then t.pnc6_location_id end)\n, pnc7 = (case when t.pnc6 is not null then t.pnc7 end)\n, pnc7_location_id = (case when t.pnc7 is not null then t.pnc7_location_id end)\n, ifa_tab_after_delivery = t.ifa_tab_after_delivery\n, ppiucd_insert_date = case when t.ppiucd_insert_date is not null then t.ppiucd_insert_date else t_pregnancy_registration_det.ppiucd_insert_date end\n, ppiucd_insert_location = case when t.ppiucd_insert_date is not null then t.ppiucd_insert_location else t_pregnancy_registration_det.ppiucd_insert_location end\nfrom (\nselect t1.pregnancy_reg_id\n\t,case when t_pregnancy_registration_det.delivery_place in (''HOME'',''HOSP'',''108_AMBULANCE'') \n\t\tthen t_pregnancy_registration_det.date_of_delivery else t1.pnc1 end as pnc1\n\t,t1.pnc2,t1.pnc3,t1.pnc4,t1.pnc5,t1.pnc6, t1.pnc7\n\t,case when t_pregnancy_registration_det.delivery_place in (''HOME'',''HOSP'',''108_AMBULANCE'') \n\t\tthen t_pregnancy_registration_det.delivery_location_id else pnc1_master.location_id end as pnc1_location_id\n\t,pnc2_master.location_id as pnc2_location_id\n\t,pnc3_master.location_id as pnc3_location_id\n\t,pnc4_master.location_id as pnc4_location_id\n    ,pnc5_master.location_id as pnc5_location_id\n    ,pnc6_master.location_id as pnc6_location_id\n\t,pnc7_master.location_id as pnc7_location_id\n\t,t1.ifa_tab_after_delivery\n\t,t1.ppiucd_insert_date\n\t,t1.ppiucd_insert_location\n\tfrom (\n\tselect t_pregnancy_registration_det.pregnancy_reg_id,\n\tmin(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 0 and 2 then rpm.service_date else null end) as pnc1,\n\tmin(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 0 and 2 then rpm.id else null end) as pnc1_id,\n\t\n\tmin(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 3 and 6 then rpm.service_date else null end) as pnc2,\n\tmin(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 3 and 6 then rpm.id else null end) as pnc2_id,\n\t\n\tmin(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 7 and 13 then rpm.service_date else null end) as pnc3,\n\tmin(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 7 and 13 then rpm.id else null end) as pnc3_id,\n\t\n\tmin(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 14 and 21 then rpm.service_date else null end) as pnc4,\n\tmin(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 14 and 21 then rpm.id else null end) as pnc4_id,\n\n    min(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 22 and 31 then rpm.service_date else null end) as pnc5,\n\tmin(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 22 and 31 then rpm.id else null end) as pnc5_id,\n\n    min(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 32 and 42 then rpm.service_date else null end) as pnc6,\n\tmin(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 32 and 42 then rpm.id else null end) as pnc6_id,\n\n\tmin(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 43 and 60 then rpm.service_date else null end) as pnc7,\n\tmin(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 43 and 60 then rpm.id else null end) as pnc7_id,\n\n\t\n\tsum(rpmm.ifa_tablets_given) as ifa_tab_after_delivery,\n\t\n\tmax(case when family_planning_method = ''PPIUCD'' then cast(rpmm.fp_insert_operate_date as date) end) as ppiucd_insert_date,\n\tmax(case when family_planning_method = ''PPIUCD'' then rpm.location_id end) as ppiucd_insert_location\n\t\n\tfrom t_pregnancy_registration_det \n\tinner join rch_pnc_master rpm on t_pregnancy_registration_det.pregnancy_reg_id = rpm.pregnancy_reg_det_id\n\tleft join rch_pnc_mother_master rpmm on rpmm.pnc_master_id = rpm.id\n\twhere rpm.member_status = ''AVAILABLE''\n\tgroup by t_pregnancy_registration_det.pregnancy_reg_id) as t1\n\tinner join t_pregnancy_registration_det on t_pregnancy_registration_det.pregnancy_reg_id = t1.pregnancy_reg_id\n\tleft join rch_pnc_master pnc1_master on pnc1_master.id = pnc1_id\n\tleft join rch_pnc_master pnc2_master on pnc2_master.id = pnc2_id\n\tleft join rch_pnc_master pnc3_master on pnc3_master.id = pnc3_id\n\tleft join rch_pnc_master pnc4_master on pnc4_master.id = pnc4_id\n    left join rch_pnc_master pnc5_master on pnc5_master.id = pnc5_id\n    left join rch_pnc_master pnc6_master on pnc6_master.id = pnc6_id\n\tleft join rch_pnc_master pnc7_master on pnc7_master.id = pnc7_id\n) as t\nwhere t.pregnancy_reg_id = t_pregnancy_registration_det.pregnancy_reg_id;\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED10''\nwhere event_config_id = 39 and status = ''PROCESSED9'';\ncommit;\n\n---11\n---------------------Updating Data to Main Table-------------------------------------------------------------------------------------------------------------\nbegin;\n/*DROP TABLE IF EXISTS rch_pregnancy_analytics_details_t;\nCREATE TABLE rch_pregnancy_analytics_details_t (\n  pregnancy_reg_id bigint NOT NULL,\n  member_id bigint,\n  dob date,\n  family_id text,\n  member_name text,\n  mobile_number text,\n  reg_service_date date,\n  reg_service_date_month_year date,\n  reg_service_financial_year text,\n  reg_server_date timestamp without time zone,\n  pregnancy_reg_location_id bigint,\n  native_location_id integer,\n  pregnancy_reg_family_id bigint,\n  lmp_date date,\n  edd date,\n  preg_reg_state text,\n  member_basic_state text,\n  lmp_month_year date,\n  lmp_financial_year text,\n  date_of_delivery date,\n  date_of_delivery_month_year date,\n  delivery_location_id bigint,\n  delivery_family_id bigint,\n  delivery_reg_date date,\n  delivery_reg_date_financial_year text,\n  member_current_location_id bigint,\n  age_during_delivery smallint,\n  registered_with_no_of_child smallint,\n  registered_with_male_cnt smallint,\n  registered_with_female_cnt smallint,\n  anc1 date,\n  anc1_location_id integer,\n  anc2 date,\n  anc2_location_id integer,\n  anc3 date,\n  anc3_location_id integer,\n  anc4 date,\n  anc4_location_id integer,\n  total_regular_anc smallint,\n  tt1_given date,\n  tt1_location_id integer,\n  tt2_given date,\n  tt2_location_id integer,\n  tt_boster date,\n  tt_booster_location_id integer,\n  tt2_tt_booster_given date,\n  tt2_tt_booster_location_id integer,\n  early_anc boolean,\n  total_anc smallint,\n  ifa integer,\n  fa_tab_in_30_day integer,\n  fa_tab_in_31_to_60_day integer,\n  fa_tab_in_61_to_90_day integer,\n  ifa_tab_in_4_month_to_9_month integer,\n  hb_between_90_to_360_days integer,\n  hb real,\n  total_ca integer,\n  ca_tab_in_91_to_180_day integer,\n  ca_tab_in_181_to_360_day integer,\n  expected_delivery_place text,\n\t\n  L2L_Preg_Complication text,\n  Outcome_L2L_Preg text,\n  L2L_Preg_Complication_Length smallint,\n  Outcome_Last_Preg integer,\n  \n  alben_given boolean,\n  maternal_detah boolean,\n  maternal_death_type text,\n  death_date date,\n  death_location_id integer,\n  low_height boolean,\n  urine_albumin boolean,\n  systolic_bp smallint,\n  diastolic_bp smallint,\n  prev_pregnancy_date date,\n  prev_preg_diff_in_month smallint,\n  gravida smallint,\n  jsy_beneficiary boolean,\n  jsy_payment_date date,\n  any_chronic_dis boolean,\n  aadhar_and_bank boolean,\n  aadhar_reg boolean,\n  aadhar_with_no_bank boolean,\n  bank_with_no_aadhar boolean,\n  no_aadhar_and_bank boolean,\n  high_risk_mother boolean,\n  pre_preg_anemia boolean,\n  pre_preg_caesarean_section boolean,\n  pre_preg_aph boolean,\n  pre_preg_pph boolean,\n  pre_preg_pre_eclampsia boolean,\n  pre_preg_abortion boolean,\n  pre_preg_obstructed_labour boolean,\n  pre_preg_placenta_previa boolean,\n  pre_preg_malpresentation boolean,\n  pre_preg_birth_defect boolean,\n  pre_preg_preterm_delivery boolean,\n  any_prev_preg_complication boolean,\n  chro_tb boolean,\n  chro_diabetes boolean,\n  chro_heart_kidney boolean,\n  chro_hiv boolean,\n  chro_sickle boolean,\n  chro_thalessemia boolean,\n  cur_extreme_age boolean,\n  cur_low_weight boolean,\n  cur_severe_anemia boolean,\n  cur_blood_pressure_issue boolean,\n  cur_urine_protein_issue boolean,\n  cur_convulsion_issue boolean,\n  cur_malaria_issue boolean,\n  cur_social_vulnerability boolean,\n  cur_gestational_diabetes_issue boolean,\n  cur_twin_pregnancy boolean,\n  cur_mal_presentation_issue boolean,\n  cur_absent_reduce_fetal_movment boolean,\n  cur_less_than_18_month_interval boolean,\n  cur_aph_issue boolean,\n  cur_pelvic_sepsis boolean,\n  cur_hiv_issue boolean,\n  cur_vdrl_issue boolean,\n  cur_hbsag_issue boolean,\n  cur_brethless_issue boolean,\n  any_cur_preg_complication boolean,\n  high_risk_cnt smallint,\n  hbsag_test_cnt smallint,\n  hbsag_reactive_cnt smallint,\n  hbsag_non_reactive_cnt smallint,\n  delivery_outcome text,\n  type_of_delivery text,\n  delivery_place text,\n  home_del boolean,\n  institutional_del boolean,\n  delivery_108 boolean,\n  breast_feeding_in_one_hour boolean,\n  delivery_hospital text,\n  del_week smallint,\n  is_cortico_steroid boolean,\n  mother_alive boolean,\n  total_out_come smallint,\n  male smallint,\n  female smallint,\n  delivery_done_by text,\n  pnc1 date,\n  pnc1_location_id integer,\n  pnc2 date,\n  pnc2_location_id integer,\n  pnc3 date,\n  pnc3_location_id integer,\n  pnc4 date,\n  pnc4_location_id integer,\n  haemoglobin_tested_count integer,\n  iron_def_anemia_inj text,\n  blood_transfusion boolean,\n  ppiucd_insert_date date,\n  PRIMARY KEY (pregnancy_reg_id)\n);\n*/\n\ndelete from rch_pregnancy_analytics_details where (select cast(key_value as boolean) as value \nfrom system_configuration where system_key = ''rch_pregnancy_analytics_run_for_all_pregnancy'') = true;\n\ninsert into rch_pregnancy_analytics_details(\n\tpregnancy_reg_id\n)\nselect t_pregnancy_registration_det.pregnancy_reg_id\nfrom t_pregnancy_registration_det\nleft join rch_pregnancy_analytics_details on t_pregnancy_registration_det.pregnancy_reg_id = rch_pregnancy_analytics_details.pregnancy_reg_id\nwhere rch_pregnancy_analytics_details.pregnancy_reg_id is null;\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED11''\nwhere event_config_id = 39 and status = ''PROCESSED10'';\ncommit;\n\n\n\n---12\nbegin;\nupdate rch_pregnancy_analytics_details \nset \n\tmember_id = t.member_id,\n\tdob = t.dob,\n\tfamily_id = t.family_id,\n\tunique_health_id = t.unique_health_id,\n\tmember_name = t.member_name,\n\tmobile_number = t.mobile_number,\n\tmember_basic_state = t.member_basic_state,\n\tpreg_reg_state = t.preg_reg_state,\n\treg_service_date =t.reg_service_date,\n\treg_service_date_month_year =t.reg_service_date_month_year,\n\treg_service_financial_year = t.reg_service_financial_year,\n\treg_server_date =t.reg_server_date,\n\tpregnancy_reg_location_id = t.pregnancy_reg_location_id,\n\tnative_location_id = t.native_location_id,\n\tpregnancy_reg_family_id = t.pregnancy_reg_family_id,\n\tlmp_date = t.lmp_date,\n\tedd=t.edd,\n\tlmp_month_year = t.lmp_month_year,\n\tlmp_financial_year = t.lmp_financial_year,\n\tdate_of_delivery = t.date_of_delivery,\n\tdate_of_delivery_month_year = t.date_of_delivery_month_year,\n\tdelivery_location_id =t.delivery_location_id,\n\tdelivery_family_id =t.delivery_family_id,\n\tdelivery_reg_date = t.delivery_reg_date,\n\tdelivery_reg_date_financial_year = t.delivery_reg_date_financial_year,\n\t\n\tmember_current_location_id = t.member_current_location_id,\n\tage_during_delivery = t.age_during_delivery,\n\tregistered_with_no_of_child = t.registered_with_no_of_child,\n\tregistered_with_male_cnt = t.registered_with_male_cnt,\n\tregistered_with_female_cnt = t.registered_with_female_cnt,\n\tanc1 =t.anc1,\n\tanc1_location_id = t.anc1_location_id,\n\tanc2 =t.anc2,\n\tanc2_location_id = t.anc2_location_id,\n\tanc3 =t.anc3,\n\tanc3_location_id = t.anc3_location_id,\n\tanc4 =t.anc4,\n\tanc4_location_id = t.anc4_location_id,\n\tlast_systolic_bp = t.last_systolic_bp,\n\tlast_diastolic_bp = t.last_diastolic_bp,\n\ttt1_given =t.tt1_given,\n\ttt1_location_id = t.tt1_location_id,\n\ttt2_given =t.tt2_given,\n\ttt2_location_id = t.tt2_location_id,\n\ttt_boster =t.tt_boster,\n\ttt_booster_location_id = t.tt_booster_location_id,\n\ttt2_tt_booster_given = t.tt2_tt_booster_given,\n\ttt2_tt_booster_location_id = t.tt2_tt_booster_location_id,\n\tearly_anc =t.early_anc,\n\tifa =t.ifa,\n\tifa_180_anc_date = t.ifa_180_anc_date,\n\tifa_180_anc_location = t.ifa_180_anc_location,\n\tfa_tab_in_30_day = t.fa_tab_in_30_day,\n\tfa_tab_in_31_to_60_day = t.fa_tab_in_31_to_60_day,\n\tfa_tab_in_61_to_90_day = t.fa_tab_in_61_to_90_day,\n\tifa_tab_in_4_month_to_9_month = t.ifa_tab_in_4_month_to_9_month,\n\thb =t.hb,\n\thb_date = t.hb_date,\n\thb_between_90_to_360_days = t.hb_between_90_to_360_days,\n\ttotal_ca = t.total_ca,\n\tca_tab_in_91_to_180_day = t.ca_tab_in_91_to_180_day,\n\tca_tab_in_181_to_360_day = t.ca_tab_in_181_to_360_day,\n\texpected_delivery_place = t.expected_delivery_place,\n\t\n\tL2L_Preg_Complication = t.L2L_Preg_Complication,\n\tOutcome_L2L_Preg = t.Outcome_L2L_Preg,\n\tL2L_Preg_Complication_Length = t.L2L_Preg_Complication_Length,\n\t\n\talben_given =t.alben_given,\n\tcur_severe_anemia =t.cur_severe_anemia,\n\tcur_extreme_age =t.cur_extreme_age,\n\tlow_height =t.low_height,\n\tcur_urine_protein_issue = t.cur_urine_protein_issue,\n\tcur_convulsion_issue = t.cur_convulsion_issue,\n\tcur_malaria_issue = t.cur_malaria_issue,\n\tcur_social_vulnerability = t.cur_social_vulnerability,\n\tcur_gestational_diabetes_issue = t.cur_gestational_diabetes_issue,\n\tcur_twin_pregnancy = t.cur_twin_pregnancy,\n\tcur_mal_presentation_issue = t.cur_mal_presentation_issue,\n\tcur_absent_reduce_fetal_movment = t.cur_absent_reduce_fetal_movment,\n\tcur_less_than_18_month_interval = case when t.prev_preg_diff_in_month <= 18 then true else false end,\n\tcur_aph_issue = t.cur_aph_issue,\n\tcur_pelvic_sepsis = t.cur_pelvic_sepsis,\n\tcur_hiv_issue = t.cur_hiv_issue,\n\tcur_vdrl_issue = t.cur_vdrl_issue,\n\tcur_hbsag_issue = t.cur_hbsag_issue,\n\tcur_brethless_issue = t.cur_brethless_issue,\n\tcur_low_weight =t.cur_low_weight,\n\tmaternal_detah = t.maternal_detah,\n\tmaternal_death_type = t.maternal_death_type,\n\tdeath_date = t.death_date,\n\tdeath_location_id = t.death_location_id,\n\tany_cur_preg_complication = case when t.cur_extreme_age or t.cur_low_weight or t.cur_severe_anemia or t.low_height \n\tor t.cur_blood_pressure_issue or t.cur_urine_protein_issue or t.cur_malaria_issue\n\tor t.cur_social_vulnerability or t.cur_gestational_diabetes_issue or t.cur_twin_pregnancy\n\tor t.cur_mal_presentation_issue or t.cur_absent_reduce_fetal_movment or t.prev_preg_diff_in_month <= 18\n\tor t.cur_aph_issue or t.cur_pelvic_sepsis or t.cur_hiv_issue or t.cur_vdrl_issue or t.cur_hbsag_issue\n\tor t.cur_brethless_issue then true else false end,\n\turine_albumin =t.urine_albumin,\n\tcur_blood_pressure_issue =t.cur_blood_pressure_issue,\n\tsystolic_bp =t.systolic_bp,\n\tdiastolic_bp =t.diastolic_bp,\n\tany_prev_preg_complication = case when t.pre_preg_anemia or t.pre_preg_caesarean_section or t.pre_preg_aph \n\tor t.pre_preg_pph or t.pre_preg_pre_eclampsia or t.pre_preg_abortion or t.pre_preg_obstructed_labour\n\tor t.pre_preg_placenta_previa or t.pre_preg_malpresentation or t.pre_preg_birth_defect\n\tor t.pre_preg_preterm_delivery or t.total_out_come >= 3 then true else false end,\n\tprev_pregnancy_date =t.prev_pregnancy_date,\n\tprev_preg_diff_in_month =t.prev_preg_diff_in_month,\n\tgravida =t.registered_with_no_of_child,\n\tany_chronic_dis = case when t.chro_diabetes = true or t.chro_heart_kidney = true\n\tor t.chro_hiv = true or t.chro_thalessemia = true or t.chro_sickle = true \n\tor t.chro_tb = true \n\tthen true else false end,\n\ttotal_anc =t.total_anc,\n\tcomplete_anc_date = case when t.anc4 is not null and t.ifa_180_anc_date is not null then greatest(t.anc4,t.ifa_180_anc_date) end,\n\tcomplete_anc_location = case when (t.anc4 is not null and t.ifa_180_anc_date is not null) and (t.anc4 > t.ifa_180_anc_date) \n\t\t\t\t\t\t\t\t\tthen t.anc4_location_id \n\t\t\t\t\t\t\t\twhen (t.anc4 is not null and t.ifa_180_anc_date is not null) then t.ifa_180_anc_location end,\n\ttotal_regular_anc = (case when t.anc1 is null then 0 else 1 end) \n\t+  (case when t.anc2 is null then 0 else 1 end) \n\t+  (case when t.anc3 is null then 0 else 1 end) \n\t+  (case when t.anc4 is null then 0 else 1 end),  \n\thigh_risk_mother = case when t.high_risk_mother = true or t.total_out_come >= 3 \n\tor t.chro_diabetes = true or t.chro_heart_kidney = true\n\tor t.chro_hiv = true or t.chro_thalessemia = true or t.chro_sickle = true \n\tor t.chro_tb = true or t.cur_extreme_age = true or t.cur_low_weight = true \n\tor t.cur_severe_anemia = true or t.cur_blood_pressure_issue = true \n\tor t.cur_gestational_diabetes_issue = true or t.prev_preg_diff_in_month <= 18\n\tor t.cur_social_vulnerability = true\n\tthen true else false end,\n\thigh_risk_cnt =t.high_risk_cnt + case when t.total_out_come >=3 then 1 else 0 end \n\t+ case when t.chro_tb then 1 else 0 end + case when t.chro_diabetes then 1 else 0 end\n\t+ case when t.chro_heart_kidney then 1 else 0 end + case when t.chro_hiv then 1 else 0 end\n\t+ case when t.chro_thalessemia then 1 else 0 end + case when t.chro_sickle then 1 else 0 end\n\t+ case when t.cur_extreme_age then 1 else 0 end\n\t+ case when t.prev_preg_diff_in_month <= 18 then 1 else 0 end,\n\thbsag_test_cnt =t.hbsag_test_cnt,\n\thbsag_reactive_cnt =t.hbsag_reactive_cnt,\n\thbsag_non_reactive_cnt =t.hbsag_non_reactive_cnt,\n\tpre_preg_anemia =t.pre_preg_anemia,\n\t\n\tpre_preg_aph =t.pre_preg_aph,\n\tpre_preg_pph =t.pre_preg_pph,\n\tpre_preg_pre_eclampsia =t.pre_preg_pre_eclampsia,\n\tpre_preg_obstructed_labour =t.pre_preg_obstructed_labour,\n\tpre_preg_placenta_previa =t.pre_preg_placenta_previa,\n\tpre_preg_malpresentation =t.pre_preg_malpresentation,\n\tpre_preg_birth_defect =t.pre_preg_birth_defect,\n\tpre_preg_preterm_delivery =t.pre_preg_preterm_delivery,\n\t\n\tpre_preg_caesarean_section =t.pre_preg_caesarean_section,\n\tpre_preg_abortion =t.pre_preg_abortion,\n\tchro_tb =t.chro_tb,\n\tchro_diabetes =t.chro_diabetes,\n\tchro_heart_kidney =t.chro_heart_kidney,\n\tchro_hiv =t.chro_hiv,\n\tchro_sickle =t.chro_sickle,\n\tchro_thalessemia =t.chro_thalessemia,\n\tdelivery_outcome =t.delivery_outcome,\n\tdelivery_health_infrastructure = t.delivery_health_infrastructure,\n\ttype_of_delivery=t.type_of_delivery,\n\tdelivery_place = t.delivery_place,\n\thome_del =t.home_del,\n\tinstitutional_del =t.institutional_del,\n\tdelivery_108 = t.delivery_108,\n    \n    delivery_out_of_state_govt = t.delivery_out_of_state_govt,\n    delivery_out_of_state_pvt = t.delivery_out_of_state_pvt,\n\n\tbreast_feeding_in_one_hour =t.breast_feeding_in_one_hour,\n\tdelivery_hospital =t.delivery_hospital,\n\tdel_week =t.del_week,\n\tis_cortico_steroid =t.is_cortico_steroid,\n\tmother_alive =t.mother_alive,\n\ttotal_out_come =t.total_out_come,\n\tmale =t.male,\n\tfemale =t.female,\n\t\n\tstill_birth = t.still_birth,\n\tlive_birth = t.live_birth,\n\t\n\tdelivery_done_by = t.delivery_done_by,\n\tpnc1 =t.pnc1,\n\tpnc1_location_id = t.pnc1_location_id,\n\tpnc2 =t.pnc2,\n\tpnc2_location_id = t.pnc2_location_id,\n\tpnc3 =t.pnc3,\n\tpnc3_location_id = t.pnc3_location_id,\n\tpnc4 =t.pnc4,\n\tpnc4_location_id = t.pnc4_location_id,\n    pnc5 = t.pnc5,\n    pnc5_location_id = t.pnc5_location_id,\n    pnc6 = t.pnc6,\n    pnc6_location_id = t.pnc6_location_id,\n\tpnc7 = t.pnc7,\n\tpnc7_location_id = t.pnc7_location_id,\n\t\n\tifa_tab_after_delivery = t.ifa_tab_after_delivery,\n\t\n\thaemoglobin_tested_count = t.haemoglobin_tested_count,\n\tiron_def_anemia_inj = t.iron_def_anemia_inj,\n\tblood_transfusion = t.blood_transfusion,\n\tppiucd_insert_date = t.ppiucd_insert_date,\n\tppiucd_insert_location = t.ppiucd_insert_location,\n\tis_fru = t.is_fru,\n\thigh_risk_reasons = t.high_risk_reasons,\n\ttracking_location_id = t.tracking_location_id,\n\tis_valid_for_tracking_report = t.is_valid_for_tracking_report,\n\n\tasha_sangini_indicator_newbornvisit = case when t.home_del is true and t.date_of_delivery = t.pnc1 and t.delivery_outcome = ''LBIRTH'' then true else false end,\n\tasha_sangini_indicator_hbnc = case when num_nulls(t.pnc1, t.pnc2, t.pnc3, t.pnc4, t.pnc5, t.pnc6, t.pnc7) = 0 then true else false end,\n\tfamily_basic_state = t.family_basic_state,\n    marital_status = t.marital_status,\n    address = t.address,\n    husband_name = t.husband_name,\n    husband_mobile_number = t.husband_mobile_number,\n    hof_name = t.hof_name,\n    hof_mobile_number = t.hof_mobile_number\nfrom t_pregnancy_registration_det t\nwhere t.pregnancy_reg_id = rch_pregnancy_analytics_details.pregnancy_reg_id;\n/*with member_details as (\n    select distinct on (member_id)\n    member_id,\n    pregnancy_reg_id,\n    high_risk_mother,\n    high_risk_reasons\n    from t_pregnancy_registration_det\n    order by member_id,pregnancy_reg_id desc\n)update imt_member\nset is_high_risk_case = member_details.high_risk_mother,\nadditional_info = concat(cast(additional_info as jsonb),cast(concat(''{\"highRiskReasons\":\"'',case when member_details.high_risk_reasons is not null then member_details.high_risk_reasons else ''null'' end,''\"}'') as jsonb))\nfrom member_details\nwhere imt_member.id = member_details.member_id\nand (\n    imt_member.is_high_risk_case != member_details.high_risk_mother\n    or cast(additional_info as jsonb) ->> ''highRiskReasons'' != member_details.high_risk_reasons\n);*/\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED12''\nwhere event_config_id = 39 and status = ''PROCESSED11'';\ncommit;\n\n---13\nbegin;\ndrop table if exists t_pregnancy_registration_det;\n\ndrop table if exists asha_workers_last_2_months_analytics_t;\ncreate table asha_workers_last_2_months_analytics_t(\n\tuser_id int,\n\tlocation_id int,\n\ttotal_home_deliveries int,\n\tnewbornvisit_on_dob int,\n\ttotal_deliveries int,\n\ttotal_deliveries_with_hbnc int\n);\n\nwith dates as (\n\tselect case when current_date < cast(date_trunc(''month'', now()) + interval ''20 days'' as date) then cast(date_trunc(''month'', now() - interval ''3 months'') + interval ''20 days'' as date)\n\t\telse cast(date_trunc(''month'', now() - interval ''2 months'') + interval ''20 days'' as date)\n\t\tend as from_date,\n\tcase when current_date < cast(date_trunc(''month'', now()) + interval ''20 days'' as date) then cast(date_trunc(''month'', now() - interval ''1 month'') + interval ''19 days'' as date)\n\t\telse cast(date_trunc(''month'', now()) + interval ''19 days'' as date)\n\t\tend as to_date\n), pregnant_woman_details as (\n\tselect rpad.member_id, rpad.member_current_location_id, rpad.date_of_delivery, rpad.home_del,\n\trpad.asha_sangini_indicator_newbornvisit, rpad.asha_sangini_indicator_hbnc\n\tfrom rch_pregnancy_analytics_details rpad \n\tinner join dates on true\n\twhere rpad.date_of_delivery between dates.from_date and dates.to_date and rpad.delivery_outcome = ''LBIRTH''\n), asha_det as (\n\tselect uu.id, uul.loc_id \n\tfrom um_user uu\n\tinner join um_user_location uul on uul.user_id =  uu.id\n\twhere role_id = 24 and uu.state = ''ACTIVE'' and uul.state = ''ACTIVE''\n), counts as (\n\tselect asha_det.id, asha_det.loc_id, \n\tcount(pwd.member_id) filter (where pwd.home_del is true) as total_home_deliveries,\n\tcount(pwd.member_id) filter (where home_del is true and asha_sangini_indicator_newbornvisit is true) as newbornvisit_on_dob,\n\tcount(pwd.member_id) filter (where date_of_delivery <= cast(now() - interval ''60 days'' as date)) as total_deliveries,\n\tcount(pwd.member_id) filter (where asha_sangini_indicator_hbnc is true and date_of_delivery <= cast(now() - interval ''60 days'' as date)) as total_deliveries_with_hbnc\n\tfrom pregnant_woman_details pwd\n\tright join asha_det on asha_det.loc_id = pwd.member_current_location_id\n\tgroup by asha_det.loc_id, asha_det.id \n)\ninsert into asha_workers_last_2_months_analytics_t (\n\tuser_id, location_id, total_home_deliveries, newbornvisit_on_dob, total_deliveries, total_deliveries_with_hbnc\n)\nselect counts.* from counts;\n\ndrop table if exists asha_workers_last_2_months_analytics;\nalter table asha_workers_last_2_months_analytics_t\n\trename to asha_workers_last_2_months_analytics;\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED13''\nwhere event_config_id = 39 and status = ''PROCESSED12'';\ncommit;\n\n\n---14\n-----------------------------------------------------------------------------------------------------------------------------\nbegin;\ndrop table if exists rch_lmp_base_location_wise_data_point_t;\ncreate table rch_lmp_base_location_wise_data_point_t (\n\tlocation_id bigint,\n\tmonth_year date,\n\tfinancial_year text,\n\t\n\tanc_reg bigint,\n\tabortion integer,\n\tmtp integer,\n\tno_of_inst_del integer,\n\tno_of_home_del integer,\n\tdelivery_108 integer,\n    delivery_out_of_state_govt integer,\n    delivery_out_of_state_pvt integer,\n\t\n\tno_of_maternal_death integer,\n\t\n\tno_of_missing_del integer,\n\tno_of_not_missing_del integer,\n\thigh_risk_mother bigint,\n\tpre_preg_pre_eclampsia bigint,\n\tprev_anemia bigint,\n\tprev_caesarian bigint,\n\tprev_aph_pph bigint,\n\tprev_abortion bigint,\n\tmultipara bigint,\n\tcur_mal_presentation_issue bigint,\n\tcur_malaria_issue bigint,\n\t\n\ttb bigint,\n\tdiabetes bigint,\n\theart_kidney bigint,\n\thiv bigint,\n\tsickle bigint,\n\tthalessemia bigint,\n\tearly_anc integer,\n\tanc1 integer,\n\tanc2 integer,\n\tanc3 integer,\n\tanc4 integer,\n\tfull_anc integer,\n\tifa integer,\n\ttt1 integer,\n\ttt2 integer,\n\ttt_booster integer,\n\ttt2_tt_booster integer,\n\tlbirth integer,\n\tsbirth integer,\n\thome_del integer,\n\tbreast_feeding integer,\n\tsc integer,\n\tphc integer,\n\tchc integer,\n\tsdh integer,\n\tuhc integer,\n\tgia integer,\n\tmedi_college integer,\n\ttaluka_hospi integer,\n\tpvt integer,\n\n\thome_del_by_sba integer,\n\thome_del_by_non_sba integer,\n\tdel_over_due integer,\n\tifa_30_tablet_in_30_day integer,\n\tifa_30_tablet_in_31_to_61_day integer,\n\tifa_30_tablet_in_61_to_90_day integer,\n\thb_done integer,\n\thb_more_then_11_in_91_to_360_days integer,\n\tifa_180_with_hb_in_4_to_9_month integer,\n\thb_between_7_to_11 integer,\n\tifa_360_with_hb_between_7_to_11_in_4_to_9_month integer,\n\tca_180_given_in_2nd_trimester integer,\n\tca_180_given_in_3rd_trimester integer,\n\thr_anc_regd integer,\n\thr_tt1 integer,\n\thr_tt2_and_tt_boster integer,\n\thr_tt2_tt_booster integer,\n\thr_early_anc integer,\n\thr_anc1 integer,\n\thr_anc2 integer,\n\thr_anc3 integer,\n\thr_anc4 integer,\n\thr_no_of_delivery integer,\n\thr_mtp integer,\n\thr_abortion integer,\n\thr_pnc1 integer,\n\thr_pnc2 integer,\n\thr_pnc3 integer,\n\thr_pnc4 integer,\n\thr_maternal_death integer,\n\thr_sc integer,\n\thr_phc integer,\n\thr_fru_chc integer,\n\thr_non_fru_chc integer,\n\thr_sdh integer,\n\thr_uhc integer,\n\thr_gia integer,\n\thr_medi_college integer,\n\thr_taluka_hospi integer,\n\thr_pvt integer,\n\thr_home_del_by_sba integer,\n\thr_home_del_by_non_sba integer,\n\tprimary key(location_id,month_year)\n);\n\ninsert into rch_lmp_base_location_wise_data_point_t(\n\tlocation_id,month_year,financial_year,\n\tanc_reg,\n\tabortion,mtp,no_of_maternal_death,no_of_inst_del,no_of_home_del,home_del_by_sba,\n\thome_del_by_non_sba,delivery_108,delivery_out_of_state_govt,delivery_out_of_state_pvt,no_of_missing_del,no_of_not_missing_del,\n\thigh_risk_mother,pre_preg_pre_eclampsia,prev_anemia,prev_caesarian,prev_aph_pph,prev_abortion,multipara,\n\tcur_malaria_issue,cur_mal_presentation_issue,tb,diabetes,heart_kidney,hiv,sickle,thalessemia,\n\tearly_anc,anc1,anc2,anc3,anc4,\n\tfull_anc,ifa,\n\ttt1,tt2,tt_booster,tt2_tt_booster,\n\tlbirth,sbirth,home_del,breast_feeding,sc,phc,chc,sdh,uhc,gia,medi_college,taluka_hospi,pvt,del_over_due\n\t,ifa_30_tablet_in_30_day,ifa_30_tablet_in_31_to_61_day,ifa_30_tablet_in_61_to_90_day,hb_done\n\t,hb_more_then_11_in_91_to_360_days,ifa_180_with_hb_in_4_to_9_month,hb_between_7_to_11,ifa_360_with_hb_between_7_to_11_in_4_to_9_month\n\t,ca_180_given_in_2nd_trimester,ca_180_given_in_3rd_trimester,hr_anc_regd,\n\thr_tt1, hr_tt2_and_tt_boster, hr_tt2_tt_booster, hr_early_anc, hr_anc1, hr_anc2, hr_anc3,\n\thr_anc4, hr_no_of_delivery, hr_mtp, hr_abortion, hr_pnc1, hr_pnc2, hr_pnc3, hr_pnc4, hr_maternal_death,\n \thr_sc, hr_phc, hr_fru_chc, hr_non_fru_chc, hr_sdh, hr_uhc, hr_gia, hr_medi_college, hr_taluka_hospi, hr_pvt, hr_home_del_by_sba,\n\thr_home_del_by_non_sba\n)\nselect tracking_location_id,lmp_month_year,lmp_financial_year,\ncount(*) as anc_regd,\nsum(case when delivery_outcome in (''ABORTION'', ''SPONT_ABORTION'') then 1 else 0 end) as no_of_abortion,\nsum(case when delivery_outcome = ''MTP'' then 1 else 0 end) as no_of_mtp,\nsum(case when maternal_detah = true then 1 else 0 end) as no_of_death,\nsum(case when institutional_del and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as no_of_inst_del,\nsum(case when (home_del) and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as no_of_home_del,\nsum(case when home_del and delivery_outcome in (''LBIRTH'',''SBIRTH'') \n\tand (delivery_done_by is null  or delivery_done_by != ''NON-TBA'') then 1 else 0 end) as home_del_by_sba,\nsum(case when home_del and delivery_outcome in (''LBIRTH'',''SBIRTH'')\n\tand (delivery_done_by is not null  and delivery_done_by = ''NON-TBA'') then 1 else 0 end) as home_del_by_non_sba,\n\t\nsum(case when delivery_108 and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as delivery_108,\n\nsum(case when delivery_out_of_state_govt = true then 1 else 0 end) as delivery_out_of_state_govt,\nsum(case when delivery_out_of_state_pvt = true then 1 else 0 end) as delivery_out_of_state_pvt,\n\nsum(case when preg_reg_state in (''PENDING'',''PREGNANT'') \n\tand maternal_detah is false and edd <= current_date then 1 else 0 end) as no_of_missing_del,\nsum(case when preg_reg_state in (''PENDING'',''PREGNANT'') \n\tand maternal_detah is false and edd > current_date then 1 else 0 end) as no_of_not_missing_del,\t\nsum(case when high_risk_mother = true then 1 else 0 end) as high_risk_mother,\nsum(case when pre_preg_pre_eclampsia then 1 else 0 end) as pre_preg_pre_eclampsia,\nsum(case when pre_preg_anemia then 1 else 0 end) as prev_anemia,\nsum(case when pre_preg_caesarean_section then 1 else 0 end) as prev_caesarian,\nsum(case when pre_preg_aph or pre_preg_pph  then 1 else 0 end) as prev_aph_pph,\nsum(case when pre_preg_abortion then 1 else 0 end) as prev_abortion,\nsum(case when total_out_come>=3 then 1 else 0 end) as multipara,\nsum(case when cur_malaria_issue then 1 else 0 end) as cur_malaria_issue,\nsum(case when cur_mal_presentation_issue then 1 else 0 end) as cur_mal_presentation_issue,\nsum(case when chro_tb then 1 else 0 end) as tb,\nsum(case when chro_diabetes then 1 else 0 end) as diabetes,\nsum(case when chro_heart_kidney then 1 else 0 end) as heart_kidney,\nsum(case when chro_hiv then 1 else 0 end) as hiv,\nsum(case when chro_sickle then 1 else 0 end) as sickle,\nsum(case when chro_thalessemia then 1 else 0 end) as thalessemia,\nsum(case when early_anc then 1 else 0 end) as early_anc,\nsum(case when anc1 is not null then 1 else 0 end) as anc1,\nsum(case when anc2 is not null then 1 else 0 end) as anc2,\nsum(case when anc3 is not null then 1 else 0 end) as anc3,\nsum(case when anc4 is not null then 1 else 0 end) as anc4,\nsum(case when total_regular_anc >=4 and ifa >= 180 and (tt2_given is not null or tt_boster is not null) then 1 else 0 end) as full_anc,\nsum(case when ifa >= 180 then 1 else 0 end) as ifa,\nsum(case when tt1_given is not null then 1 else 0 end) as tt1,\nsum(case when tt2_given is not null then 1 else 0 end) as tt2,\nsum(case when tt_boster is not null then 1 else 0 end) as tt_boster,\nsum(case when tt2_tt_booster_given is not null then 1 else 0 end) as tt2_tt_booster,\nsum(case when delivery_outcome = ''LBIRTH'' then 1 else 0 end) as lbirth,\nsum(case when delivery_outcome = ''SBIRTH'' then 1 else 0 end) as sbirth,\nsum(case when home_del and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as home_del,\nsum(case when breast_feeding_in_one_hour = true then 1 else 0 end) as breast_feeding,\nsum(case when delivery_hospital in (''897'',''1062'') then 1 else 0 end) as sc,  \nsum(case when delivery_hospital in (''899'',''1061'') then 1 else 0 end) as phc,\nsum(case when delivery_hospital in (''895'',''1009'',''1084'') then 1 else 0 end) as chc,\nsum(case when delivery_hospital in (''890'',''1008'') then 1 else 0 end) as sdh,\nsum(case when delivery_hospital in (''894'',''1063'') then 1 else 0 end) as uhc,\nsum(case when delivery_hospital in (''1064'') then 1 else 0 end) as gia,\nsum(case when delivery_hospital in (''891'',''1012'') then 1 else 0 end) as medi_college,\nsum(case when delivery_hospital in (''896'',''1007'') then 1 else 0 end) as taluka_hospi,\nsum(case when delivery_hospital in (''893'',''898'',''1013'',''1010'') then 1 else 0 end) as pvt,\nsum(case when lmp_date + interval ''281 days'' < now() and delivery_outcome is null then 1 else 0  end) as del_over_due,\nsum(case when fa_tab_in_30_day >= 30 then 1 else 0  end) as ifa_30_tablet_in_30_day,\nsum(case when fa_tab_in_31_to_60_day >= 30 then 1 else 0  end) as ifa_30_tablet_in_31_to_61_day,\nsum(case when fa_tab_in_61_to_90_day >= 30 then 1 else 0  end) as ifa_30_tablet_in_61_to_90_day,\nsum(case when hb is not null then 1 else 0  end) as hb_done,\nsum(case when hb_between_90_to_360_days > 11 then 1 else 0  end) as hb_more_then_11_in_91_to_360_days,\nsum(case when hb_between_90_to_360_days > 11 and ifa_tab_in_4_month_to_9_month >= 180 then 1 else 0  end) as ifa_180_with_hb_in_4_to_9_month,\nsum(case when hb_between_90_to_360_days between 7 and 11 then 1 else 0  end) as hb_between_7_to_11,\nsum(case when hb_between_90_to_360_days between 7 and 11 and ifa_tab_in_4_month_to_9_month >= 180 then 1 else 0  end) as ifa_360_with_hb_between_7_to_11_in_4_to_9_month,\nsum(case when ca_tab_in_91_to_180_day >= 180 then 1 else 0  end) as ca_180_given_in_2nd_trimester,\nsum(case when ca_tab_in_181_to_360_day >= 180 then 1 else 0  end) as ca_180_given_in_3rd_trimester,\ncount(*) filter ( where high_risk_mother = true) as hr_anc_regd,\nsum(case when high_risk_mother = true and tt1_given is not null then 1 else 0 end) as hr_tt1,\nsum(case when high_risk_mother = true and tt_boster is not null and  tt2_given is not null then 1 else 0 end) as hr_tt2_and_tt_boster,\nsum(case when high_risk_mother = true and tt2_tt_booster_given is not null then 1 else 0 end) as hr_tt2_tt_booster,\nsum(case when high_risk_mother = true and early_anc then 1 else 0 end) as hr_early_anc,\nsum(case when high_risk_mother = true and anc1 is not null then 1 else 0 end) as hr_anc1,\nsum(case when high_risk_mother = true and anc2 is not null then 1 else 0 end) as hr_anc2,\nsum(case when high_risk_mother = true and anc3 is not null then 1 else 0 end) as hr_anc3,\nsum(case when high_risk_mother = true and anc4 is not null then 1 else 0 end) as hr_anc4,\nsum(case when high_risk_mother = true and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as hr_no_of_delivery,\nsum(case when high_risk_mother = true and delivery_outcome = ''MTP'' then 1 else 0 end) as hr_mtp,\nsum(case when high_risk_mother = true and delivery_outcome in (''ABORTION'', ''SPONT_ABORTION'') then 1 else 0 end) as hr_abortion,\nsum(case when high_risk_mother = true and pnc1 is not null then 1 else 0 end) as hr_pnc1,\nsum(case when high_risk_mother = true and pnc2 is not null then 1 else 0 end) as hr_pnc2,\nsum(case when high_risk_mother = true and pnc3 is not null then 1 else 0 end) as hr_pnc3,\nsum(case when high_risk_mother = true and pnc4 is not null then 1 else 0 end) as hr_pnc4,\nsum(case when high_risk_mother = true and maternal_detah = true then 1 else 0 end) as hr_maternal_death,\nsum(case when high_risk_mother = true and delivery_outcome in (''LBIRTH'',''SBIRTH'') and delivery_hospital in (''897'',''1062'') then 1 else 0 end) as hr_sc,  \nsum(case when high_risk_mother = true and delivery_outcome in (''LBIRTH'',''SBIRTH'') and delivery_hospital in (''899'',''1061'') then 1 else 0 end) as hr_phc,\nsum(case when high_risk_mother = true and delivery_outcome in (''LBIRTH'',''SBIRTH'') and is_fru and delivery_hospital in (''895'',''1009'',''1084'') then 1 else 0 end) as hr_fru_chc,\nsum(case when high_risk_mother = true and delivery_outcome in (''LBIRTH'',''SBIRTH'') and is_fru is false and delivery_hospital in (''895'',''1009'',''1084'') then 1 else 0 end) as hr_non_fru_chc,\nsum(case when high_risk_mother = true and delivery_outcome in (''LBIRTH'',''SBIRTH'') and delivery_hospital in (''890'',''1008'') then 1 else 0 end) as hr_sdh,\nsum(case when high_risk_mother = true and delivery_outcome in (''LBIRTH'',''SBIRTH'') and delivery_hospital in (''894'',''1063'') then 1 else 0 end) as hr_uhc,\nsum(case when high_risk_mother = true and delivery_outcome in (''LBIRTH'',''SBIRTH'') and delivery_hospital in (''1064'') then 1 else 0 end) as hr_gia,\nsum(case when high_risk_mother = true and delivery_outcome in (''LBIRTH'',''SBIRTH'') and delivery_hospital in (''891'',''1012'') then 1 else 0 end) as hr_medi_college,\nsum(case when high_risk_mother = true and delivery_outcome in (''LBIRTH'',''SBIRTH'') and delivery_hospital in (''896'',''1007'') then 1 else 0 end) as hr_taluka_hospi,\nsum(case when high_risk_mother = true and delivery_outcome in (''LBIRTH'',''SBIRTH'') and delivery_hospital in (''893'',''898'',''1013'',''1010'') then 1 else 0 end) as hr_pvt,\nsum(case when high_risk_mother = true and home_del and delivery_outcome in (''LBIRTH'',''SBIRTH'') \n\tand (delivery_done_by is null  or delivery_done_by != ''NON-TBA'') then 1 else 0 end) as hr_home_del_by_sba,\nsum(case when high_risk_mother = true and home_del and delivery_outcome in (''LBIRTH'',''SBIRTH'')\n\tand (delivery_done_by is not null  and delivery_done_by = ''NON-TBA'') then 1 else 0 end) as hr_home_del_by_non_sba\n\nfrom rch_pregnancy_analytics_details\nwhere is_valid_for_tracking_report = true\ngroup by tracking_location_id,lmp_month_year,lmp_financial_year;\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED14''\nwhere event_config_id = 39 and status = ''PROCESSED13'';\ncommit;\n---15\n----------------------------------------------------------------------------------------------------------------------------------------------\nbegin;\ndrop table if exists rch_delivery_date_base_location_wise_data_point_t;\ncreate table rch_delivery_date_base_location_wise_data_point_t (\n\tlocation_id bigint,\n\tmonth_year date,\n\t\n\tdel_reg integer,\n\tdel_reg_still_live_birth integer,\n\tpreg_reg integer,\n\tdel_less_eq_34 integer,\n\tdel_bet_35_37 integer,\n\tdel_greater_37 integer,\n\tcortico_steroid integer,\n\tmtp integer,\n\tlbirth integer,\n\tsbirth integer,\n\tabortion integer,\n\thome_del integer,\n\thome_del_by_sba integer,\n\thome_del_by_non_sba integer,\n\tbreast_feeding integer,\n\tsc integer,\n\tphc integer,\n\tchc integer,\n\tsdh integer,\n\tuhc integer,\n\tgia integer,\n\tpvt integer,\n\tmdh integer,\n\tdh integer,\n\tdelivery_108 integer,\n    \n    delivery_out_of_state_govt integer,\n    delivery_out_of_state_pvt integer,\n\n\tphi_del_3_ancs integer,\n\tinst_del integer,\n\tmaternal_detah integer,\n\tpnc1 integer,\n\tpnc2 integer,\n\tpnc3 integer,\n\tpnc4 integer,\n\tfull_pnc integer,\n\tifa_180_after_delivery integer,\n\tcalcium_360_after_delivery integer,\n\t\n\tprimary key(location_id,month_year)\t\n);\n\ninsert into rch_delivery_date_base_location_wise_data_point_t(\n\tlocation_id,month_year,\n\tdel_reg,del_reg_still_live_birth,del_less_eq_34,del_bet_35_37,del_greater_37,cortico_steroid,\n\tmtp,abortion,lbirth,sbirth,home_del,home_del_by_sba,home_del_by_non_sba,breast_feeding,\n\tsc,phc,chc,sdh,uhc,gia,pvt,mdh,dh,delivery_108,delivery_out_of_state_govt,delivery_out_of_state_pvt,\n\tphi_del_3_ancs,inst_del,pnc1,pnc2,pnc3,pnc4,full_pnc,ifa_180_after_delivery\n)\nselect delivery_location_id,\ncast(date_trunc(''month'',date_of_delivery_month_year) as date) as month_year,\ncount(*),\nsum(case when delivery_outcome in(''LBIRTH'',''SBIRTH'') and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as del_reg_still_live_birth,\nsum(case when del_week <= 34 and delivery_outcome in(''LBIRTH'',''SBIRTH'') and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as del_less_eq_34,\nsum(case when del_week between 35 and 37 and delivery_outcome in(''LBIRTH'',''SBIRTH'') and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as del_bet_35_37,\nsum(case when del_week > 37 and delivery_outcome in(''LBIRTH'',''SBIRTH'') and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as del_greater_37,\nsum(case when del_week <= 34 and delivery_outcome in(''LBIRTH'',''SBIRTH'') and is_cortico_steroid and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as cortico_steroid,\nsum(case when delivery_outcome = ''MTP'' and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as mtp,\nsum(case when delivery_outcome in (''ABORTION'', ''SPONT_ABORTION'') and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as abortion,\nsum(case when delivery_outcome = ''LBIRTH'' and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then total_out_come else 0 end) as lbirth,\nsum(case when (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then still_birth else 0 end) as sbirth,\nsum(case when home_del and delivery_outcome in (''LBIRTH'',''SBIRTH'') and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as home_del,\nsum(case when home_del and delivery_outcome in (''LBIRTH'',''SBIRTH'') \n\tand (delivery_done_by is null  or delivery_done_by != ''NON-TBA'') and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as home_del_by_sba,\nsum(case when home_del and delivery_outcome in (''LBIRTH'',''SBIRTH'') and delivery_done_by is not null \n\tand delivery_done_by = ''NON-TBA'' and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as home_del_by_non_sba,\nsum(case when delivery_hospital in (''897'',''1062'',''899'',''1061'',''895'',''1009'',''890'',''1008'',''894'',''1063'',''892'',''891'',''1012'',''896'',''1007'',''1084'') \n\tand delivery_outcome in (''LBIRTH'',''SBIRTH'') and breast_feeding_in_one_hour = true \n\tthen 1 else 0 end) as breast_feeding,\nsum(case when institutional_del  and  delivery_hospital in (''897'',''1062'') and delivery_outcome in (''LBIRTH'',''SBIRTH'')  then 1 else 0 end) as sc,  \nsum(case when institutional_del  and  delivery_hospital in (''899'',''1061'') and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as phc,\nsum(case when institutional_del  and  delivery_hospital in (''895'',''1009'',''1084'') and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as chc,\nsum(case when institutional_del  and  delivery_hospital in (''890'',''1008'') and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as sdh,\nsum(case when institutional_del  and  delivery_hospital in (''894'',''1063'') and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as uhc,\nsum(case when institutional_del  and  delivery_hospital in (''1064'') and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as gia,\nsum(case when institutional_del  and  delivery_hospital in (''893'',''898'',''1013'',''1010'') and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as pvt,\nsum(case when institutional_del  and  delivery_hospital in (''891'',''1012'') and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as mdh,\nsum(case when institutional_del  and  delivery_hospital in (''896'',''1007'') and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as dh,\nsum(case when delivery_108 and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as delivery_108,\n\nsum(case when delivery_out_of_state_govt = true then 1 else 0 end) as delivery_out_of_state_govt,\nsum(case when delivery_out_of_state_pvt = true then 1 else 0 end) as delivery_out_of_state_pvt,\n\nsum(case when ((institutional_del  and delivery_hospital in (''897'',''1062'',''899'',''1061'',''895'',''1009'',''890'',''1008'',''894'',''1063'',''892'',''891'',''1012'',''896'',''1007'',''1084'')) \n\tor delivery_108)\n\tand delivery_outcome in (''LBIRTH'',''SBIRTH'') and total_regular_anc >= 3  then 1 else 0 end) as phi_del_3_ancs,\nsum(case when (institutional_del) and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as no_of_inst_del,\nsum(case when pnc1 is not null then 1 else 0 end) as pnc1,\nsum(case when pnc2 is not null then 1 else 0 end) as pnc2,\nsum(case when pnc3 is not null then 1 else 0 end) as pnc3,\nsum(case when pnc4 is not null then 1 else 0 end) as pnc4,\nsum(case when pnc4 is not null and ifa_tab_after_delivery >= 180 then 1 else 0 end) as full_pnc,\nsum(case when ifa_tab_after_delivery >= 180 then 1 else 0 end) as ifa_180_after_delivery\n--,sum(case when maternal_detah then 1 else 0 end) as maternal_death\nfrom rch_pregnancy_analytics_details\nwhere date_of_delivery_month_year is not null and delivery_outcome is not null\ngroup by delivery_location_id,date_of_delivery_month_year;\n\n\nwith del_det as(\n\tselect rprd.native_location_id as location_id\n\t,cast(date_trunc(''month'', rprd.reg_service_date) as date) as month_year,\n\tcount(*) as anc_reg,\n\tsum(case when early_anc then 1 else 0 end) as early_anc\n\tfrom rch_pregnancy_analytics_details rprd\n\twhere rprd.reg_service_date >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n\tgroup by rprd.native_location_id,cast(date_trunc(''month'', rprd.reg_service_date) as date)\n),maternal_death_detail as (\n\tselect rch_pregnancy_analytics_details.death_location_id as location_id,\n\tcast(date_trunc(''month'', rch_pregnancy_analytics_details.death_date) as date) as month_year,\n\tcount(*) as maternal_detah \n\tfrom rch_pregnancy_analytics_details\n\twhere rch_pregnancy_analytics_details.death_date >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n\tand rch_pregnancy_analytics_details.maternal_detah = true\n\tgroup by rch_pregnancy_analytics_details.death_location_id\n\t,cast(date_trunc(''month'', rch_pregnancy_analytics_details.death_date) as date)\n),location_det as (\nselect location_id,month_year from del_det\n\tunion\nselect location_id,month_year from maternal_death_detail\t\n)\ninsert into rch_delivery_date_base_location_wise_data_point_t(location_id,month_year)\nselect location_det.location_id,location_det.month_year \nfrom location_det\nleft join rch_delivery_date_base_location_wise_data_point_t \non location_det.location_id = rch_delivery_date_base_location_wise_data_point_t.location_id\nand location_det.month_year = rch_delivery_date_base_location_wise_data_point_t.month_year\nwhere rch_delivery_date_base_location_wise_data_point_t.location_id is null;\n\n\nwith maternal_death_detail as(\n\tselect rch_pregnancy_analytics_details.death_location_id as location_id,\n\tcast(date_trunc(''month'', rch_pregnancy_analytics_details.death_date) as date) as month_year,\n\tcount(*) as maternal_detah \n\tfrom rch_pregnancy_analytics_details\n\twhere rch_pregnancy_analytics_details.death_date >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n\tand rch_pregnancy_analytics_details.maternal_detah = true\n\tgroup by rch_pregnancy_analytics_details.death_location_id\n\t,cast(date_trunc(''month'', rch_pregnancy_analytics_details.death_date) as date)\n)\t\nupdate rch_delivery_date_base_location_wise_data_point_t \nset maternal_detah = maternal_death_detail.maternal_detah\nfrom maternal_death_detail where maternal_death_detail.location_id = rch_delivery_date_base_location_wise_data_point_t.location_id\nand maternal_death_detail.month_year = rch_delivery_date_base_location_wise_data_point_t.month_year;\n\nwith del_det as(\n\tselect rprd.native_location_id as location_id,cast(date_trunc(''month'', rprd.reg_service_date) as date) as month_year,\n\tcount(*) as anc_reg,\n\tsum(case when early_anc then 1 else 0 end) as early_anc\n\tfrom rch_pregnancy_analytics_details rprd\n\twhere rprd.reg_service_date >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n\tgroup by rprd.native_location_id,cast(date_trunc(''month'', rprd.reg_service_date) as date)\n)\t\nupdate rch_delivery_date_base_location_wise_data_point_t \nset preg_reg = anc_reg\nfrom del_det where del_det.location_id = rch_delivery_date_base_location_wise_data_point_t.location_id\nand del_det.month_year = rch_delivery_date_base_location_wise_data_point_t.month_year;\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED15''\nwhere event_config_id = 39 and status = ''PROCESSED14'';\ncommit;\n---16\n------------------------------------------------------------------------------------------------------------------------------------\nbegin;\ndrop table if exists rch_yearly_location_wise_analytics_data_t;\ncreate table rch_yearly_location_wise_analytics_data_t (\n\tlocation_id bigint,\n\tfinancial_year text,\n\tmonth_year date,\n\tage_less_15 integer,\n\tage_15_19 integer,\n\tage_20_24 integer,\n\tage_25_29 integer,\n\tage_30_34 integer,\n\tage_35_39 integer,\n\tage_40_44 integer,\n\tage_45_49 integer,\n\tage_greater_49 integer,\n\tanc_reg integer,\n\thbsag_test integer,\n\tnon_reactive integer,\n\treactive integer,\n\t\n\ttt1 integer,\n\ttt2_tt_booster integer,\n\tearly_anc integer,\n\tanc1 integer,\n\tanc2 integer,\n\tanc3 integer,\n\tanc4 integer,\n\tno_of_del integer,\n\tmtp integer,\n\tabortion integer,\n\tpnc1 integer,\n\tpnc2 integer,\n\tpnc3 integer,\n\tpnc4 integer,\n\tmaternal_detah integer,\n\tprimary key(location_id,financial_year,month_year)\n);\n\ninsert into rch_yearly_location_wise_analytics_data_t(\n\tlocation_id,financial_year,month_year,\n\tage_less_15,age_15_19,age_20_24,age_25_29,age_30_34,age_35_39,age_40_44,age_45_49,age_greater_49,anc_reg,\n\thbsag_test,non_reactive,reactive,\n\ttt1,tt2_tt_booster,early_anc,anc1,anc2,anc3,anc4,no_of_del,mtp,abortion,pnc1,pnc2,pnc3,pnc4,maternal_detah\n)\nselect rprd.tracking_location_id,rprd.reg_service_financial_year,rprd.reg_service_date_month_year,\nsum(case when age_during_delivery < 15 then 1 else 0 end) as age_less_15,\nsum(case when age_during_delivery between 15 and 19 then 1 else 0 end) as age_15_19,\nsum(case when age_during_delivery between 20 and 24 then 1 else 0 end) as age_20_24,\nsum(case when age_during_delivery between 25 and 29 then 1 else 0 end) as age_25_29,\nsum(case when age_during_delivery between 30 and 34 then 1 else 0 end) as age_30_34,  \nsum(case when age_during_delivery between 35 and 39 then 1 else 0 end) as age_35_39,\nsum(case when age_during_delivery between 40 and 44 then 1 else 0 end) as age_40_44,\nsum(case when age_during_delivery between 45 and 49 then 1 else 0 end) as age_45_49, \nsum(case when age_during_delivery > 49 then 1 else 0 end) as age_greater_49,\ncount(*) as anc_reg,\nsum(hbsag_test_cnt) as hbsag_test,              \nsum(hbsag_non_reactive_cnt) as non_reactive,          \nsum(hbsag_reactive_cnt) as reactive,\nsum(case when tt1_given is not null then 1 else 0 end) as tt1,\nsum(case when tt2_given is not null or tt_boster is not null  then 1 else 0 end) as tt2,\nsum(case when early_anc then 1 else 0 end) as early_anc,\nsum(case when total_regular_anc >=1 then 1 else 0 end) as anc1,\nsum(case when total_regular_anc >=2 then 1 else 0 end) as anc2,\nsum(case when total_regular_anc >=3 then 1 else 0 end) as anc3,\nsum(case when total_regular_anc >=4 then 1 else 0 end) as anc4,\nsum(case when delivery_outcome in (''LBIRTH'',''SBIRTH'') and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as no_of_del,\nsum(case when delivery_outcome = ''MTP'' and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as mtp,         \nsum(case when delivery_outcome in (''ABORTION'', ''SPONT_ABORTION'') and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as abortion,\nsum(case when pnc1 is not null then 1 else 0 end) as pnc1,\nsum(case when pnc2 is not null then 1 else 0 end) as pnc2,\nsum(case when pnc3 is not null then 1 else 0 end) as pnc3,\nsum(case when pnc4 is not null then 1 else 0 end) as pnc4,\nsum(case when maternal_detah then 1 else 0 end) as maternal_detah\nfrom rch_pregnancy_analytics_details rprd\nwhere is_valid_for_tracking_report = true\ngroup by rprd.tracking_location_id,rprd.reg_service_financial_year,rprd.reg_service_date_month_year;\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED16''\nwhere event_config_id = 39 and status = ''PROCESSED15'';\ncommit;\n\n\n---17\n-----------------------------------------------------------------------------------------------------------------------------------------\nbegin;\ndrop table if exists rch_current_state_pregnancy_analytics_data_t;\ncreate table rch_current_state_pregnancy_analytics_data_t (\n\tlocation_id bigint primary key,\n\treg_preg_women integer,\n\thigh_risk integer,\n\tprev_compl integer,\n\tchronic integer,\n\ttwo_or_more_risk integer,\n\tcurrent_preg_compl integer,\n\tsevere_anemia integer,\n\tdiabetes integer,\n\tcur_mal_presentation_issue bigint,\n\tcur_malaria_issue bigint,\n\tmultipara bigint,\n\tblood_pressure integer,\n\tinterval_bet_preg_less_18_months integer,\n\textreme_age integer,\n\theight integer,\n\tweight  integer,\n\turine_albumin integer,\n\tanc_in_2or3_trim integer,\n\talben_given integer,\n\talben_not_given integer,\n\t\n\tpre_preg_pre_eclampsia bigint,\n\tprev_anemia bigint,\n\tprev_caesarian bigint,\n\tprev_aph_pph bigint,\n\tprev_abortion bigint,\n\t\n\tchro_tb bigint,\n\tchro_diabetes bigint,\n\tchro_heart_kidney bigint,\n\tchro_hiv bigint,\n\tchro_sickle bigint,\n\tchro_thalessemia bigint\n);\n\ninsert into rch_current_state_pregnancy_analytics_data_t(\n\tlocation_id,reg_preg_women,high_risk,two_or_more_risk,prev_compl,chronic,current_preg_compl\n\t,severe_anemia,blood_pressure,diabetes,cur_mal_presentation_issue,cur_malaria_issue,multipara,extreme_age,height,weight,urine_albumin\n\t,anc_in_2or3_trim,alben_given,alben_not_given,interval_bet_preg_less_18_months\n\t,pre_preg_pre_eclampsia,prev_anemia,prev_caesarian,prev_aph_pph,prev_abortion\n\t,chro_tb,chro_diabetes,chro_heart_kidney,chro_hiv,chro_sickle,chro_thalessemia\n) \nselect member_current_location_id,\ncount(*) as reg_preg_women,\nsum(case when high_risk_mother = true then 1 else 0 end) as high_risk,\nsum(case when high_risk_cnt >= 2 then 1 else 0 end) as two_or_more_risk,\nsum(case when any_prev_preg_complication then 1 else 0 end) as prev_compl,\nsum(case when any_chronic_dis then 1 else 0 end) as chronic,\nsum(case when any_cur_preg_complication then 1 else 0 end) as current_preg_compl,\nsum(case when cur_severe_anemia then 1 else 0 end) as severe_anemia,\nsum(case when cur_blood_pressure_issue then 1 else 0 end) as blood_pressure,\nsum(case when cur_gestational_diabetes_issue then 1 else 0 end) as diabetes,\nsum(case when cur_mal_presentation_issue then 1 else 0 end) as cur_mal_presentation_issue,\nsum(case when cur_malaria_issue then 1 else 0 end) as cur_malaria_issue,\nsum(case when total_out_come>=3 then 1 else 0 end) as multipara,\nsum(case when cur_extreme_age then 1 else 0 end) as extreme_age,\nsum(case when low_height then 1 else 0 end) as height,\nsum(case when cur_low_weight then 1 else 0 end) as weight,\nsum(case when urine_albumin then 1 else 0 end) as urine_albumin,\nsum(case when current_date - lmp_date between 92 and 245 then 1 else 0 end) anc_in_2or3_trim,\nsum(case when current_date - lmp_date between 92 and 245 and alben_given then 1 else 0 end) alben_given,\nsum(case when current_date - lmp_date between 92 and 245 and (alben_given is null or alben_given = false) then 1 else 0 end) alben_not_given,\nsum(case when cur_less_than_18_month_interval then 1 else 0 end) interval_bet_preg_less_18_months,\n\nsum(case when pre_preg_pre_eclampsia then 1 else 0 end) as pre_preg_pre_eclampsia,\nsum(case when pre_preg_anemia then 1 else 0 end) as prev_anemia,\nsum(case when pre_preg_caesarean_section then 1 else 0 end) as prev_caesarian,\nsum(case when pre_preg_aph or pre_preg_pph  then 1 else 0 end) as prev_aph_pph,\nsum(case when pre_preg_abortion then 1 else 0 end) as prev_abortion,\nsum(case when chro_tb then 1 else 0 end) as tb,\nsum(case when chro_diabetes then 1 else 0 end) as diabetes,\nsum(case when chro_heart_kidney then 1 else 0 end) as heart_kidney,\nsum(case when chro_hiv then 1 else 0 end) as hiv,\nsum(case when chro_sickle then 1 else 0 end) as sickle,\nsum(case when chro_thalessemia then 1 else 0 end) as thalessemia\nfrom rch_pregnancy_analytics_details\nwhere rch_pregnancy_analytics_details.member_basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')\nand preg_reg_state in (''PENDING'',''PREGNANT'')\nand is_valid_for_tracking_report = true\ngroup by member_current_location_id;\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED17''\nwhere event_config_id = 39 and status = ''PROCESSED16'';\ncommit;\n\n---18\n--------------------------------------------------------------------------------------------------------------------------------------\nbegin;\ndrop table if exists rch_service_provided_during_year_t;\ncreate table rch_service_provided_during_year_t (\n    location_id bigint,\n    month_year date,\n    financial_year text,\n    anc_reg integer,\n    anc_coverage integer,\n    regd_live_children integer,\n    regd_no_live_children integer,\n    c1_m1 integer,\n    c1_f1 integer,\n    c2_f2 integer,\n    c2_m2 integer,\n    c2_f1_m1 integer,\n    c3_f3 integer,\n    c3_m3 integer,\n    c3_m2_f1 integer,\n    c3_m1_f2 integer,\n\n    high_risk integer,\n    current_preg_compl integer,\n    severe_anemia integer,\n    diabetes integer,\n    cur_mal_presentation_issue bigint,\n    cur_malaria_issue bigint,\n    multipara bigint,\n    blood_pressure integer,\n    interval_bet_preg_less_18_months integer,\n    extreme_age integer,\n    height integer,\n    weight  integer,\n    urine_albumin integer,\n\n\n    tt1 integer,\n    tt2_tt_booster integer,\n    early_anc integer,\n    anc1 integer,\n    anc2 integer,\n    anc3 integer,\n    anc4 integer,\n    no_of_delivery integer,\n    mtp integer,\n    abortion integer,\n    live_birth integer,\n    still_birth integer,\n    pnc1 integer,\n    pnc2 integer,\n    pnc3 integer,\n    pnc4 integer,\n    mother_death integer,\n    ppiucd integer,\n\n    complete_anc_date integer,\n    ifa_180_anc_date integer,\n\tphi_del integer,\n\tphi_del_with_ppiucd integer,\n\n\n    primary key (location_id, month_year)\n);\n\n\nwith rch_service_yearly_pregnancy_reg as (\n    select rprd.native_location_id as location_id,cast(date_trunc(''month'', rprd.reg_service_date) as date) as month_year,\n    count(*) as anc_reg,\n    sum(case when anc1 is not null and anc2 is not null and anc3 is not null and anc4 is not null then 1 else 0 end) as anc_coverage, \n    sum(case when early_anc then 1 else 0 end) as early_anc,\n    sum(case when high_risk_mother = true then 1 else 0 end) as high_risk,\n    sum(case when any_cur_preg_complication then 1 else 0 end) as current_preg_compl,\n    sum(case when cur_severe_anemia then 1 else 0 end) as severe_anemia,\n    sum(case when cur_blood_pressure_issue then 1 else 0 end) as blood_pressure,\n    sum(case when cur_gestational_diabetes_issue then 1 else 0 end) as diabetes,\n    sum(case when cur_mal_presentation_issue then 1 else 0 end) as cur_mal_presentation_issue,\n    sum(case when cur_malaria_issue then 1 else 0 end) as cur_malaria_issue,\n    sum(case when total_out_come>=3 then 1 else 0 end) as multipara,\n    sum(case when cur_extreme_age then 1 else 0 end) as extreme_age,\n    sum(case when low_height then 1 else 0 end) as height,\n    sum(case when cur_low_weight then 1 else 0 end) as weight,\n    sum(case when urine_albumin then 1 else 0 end) as urine_albumin,\n    sum(case when cur_less_than_18_month_interval then 1 else 0 end) interval_bet_preg_less_18_months,\n\n    sum(case when registered_with_no_of_child > 0 then 1 else 0 end) as regd_live_children,\n    sum(case when registered_with_no_of_child = 0 or registered_with_no_of_child is null then 1 else 0 end) as regd_no_live_children,\n    sum(case when registered_with_no_of_child = 1 and registered_with_male_cnt = 1 then 1 else 0 end) as c1_m1,\n    sum(case when registered_with_no_of_child = 1 and registered_with_female_cnt = 1 then 1 else 0 end) as c1_f1,\n    sum(case when registered_with_no_of_child = 2 and registered_with_female_cnt = 2 then 1 else 0 end) as c2_f2,\n    sum(case when registered_with_no_of_child = 2 and registered_with_male_cnt = 2 then 1 else 0 end) as c2_m2,\n    sum(case when registered_with_no_of_child = 2 and registered_with_male_cnt = 1 and registered_with_female_cnt = 1 then 1 else 0 end) as c2_f1_m1,\n    sum(case when registered_with_no_of_child = 3 and registered_with_female_cnt = 3 then 1 else 0 end) as c3_f3,\n    sum(case when registered_with_no_of_child = 3 and registered_with_male_cnt = 3 then 1 else 0 end) as c3_m3,\n    sum(case when registered_with_no_of_child = 3 and registered_with_male_cnt = 2 and registered_with_female_cnt = 1 then 1 else 0 end) as c3_m2_f1,\n    sum(case when registered_with_no_of_child = 3 and registered_with_male_cnt = 1 and registered_with_female_cnt = 2 then 1 else 0 end) as c3_m1_f2,\n\tsum(case when ((institutional_del  and delivery_hospital in (''897'',''1062'',''899'',''1061'',''895'',''1009'',''890'',''1008'',''894'',''1063'',''892'',''891'',''1012'',''896'',''1007'',''1084'')) \n\tor delivery_108)\n\tand delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as phi_del,\n\tsum(case when ((institutional_del  and delivery_hospital in (''897'',''1062'',''899'',''1061'',''895'',''1009'',''890'',''1008'',''894'',''1063'',''892'',''891'',''1012'',''896'',''1007'',''1084'')) \n\tor delivery_108)\n\tand delivery_outcome in (''LBIRTH'',''SBIRTH'') and ppiucd_insert_date is not null then 1 else 0 end) as phi_del_with_ppiucd\n\n    from rch_pregnancy_analytics_details rprd\n    where rprd.reg_service_date >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n    group by rprd.native_location_id,cast(date_trunc(''month'', rprd.reg_service_date) as date)\n), rch_yearly_vacination_tt1 as (\n    select rch_pregnancy_analytics_details.tt1_location_id as location_id\n    ,cast(date_trunc(''month'', rch_pregnancy_analytics_details.tt1_given) as date) as month_year\n    ,sum(1) as tt1\n    from rch_pregnancy_analytics_details\n    where rch_pregnancy_analytics_details.tt1_given >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n    group by rch_pregnancy_analytics_details.tt1_location_id, cast(date_trunc(''month'', rch_pregnancy_analytics_details.tt1_given) as date)\n), rch_yearly_vacination_tt2_tt_booster as (\n    select rch_pregnancy_analytics_details.tt2_tt_booster_location_id as location_id,\n    cast(date_trunc(''month'', rch_pregnancy_analytics_details.tt2_tt_booster_given) as date) as month_year,\n    sum(1) as tt2_tt_booster\n    from rch_pregnancy_analytics_details\n    where rch_pregnancy_analytics_details.tt2_tt_booster_given >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n    group by rch_pregnancy_analytics_details.tt2_tt_booster_location_id, cast(date_trunc(''month'', rch_pregnancy_analytics_details.tt2_tt_booster_given) as date)\n), rch_yearly_anc1 as (\n    select rch_pregnancy_analytics_details.anc1_location_id as location_id,\n    cast(date_trunc(''month'', rch_pregnancy_analytics_details.anc1) as date) as month_year,\n    sum(1) as anc1\n    from rch_pregnancy_analytics_details\n    where anc1 >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n    group by rch_pregnancy_analytics_details.anc1_location_id, cast(date_trunc(''month'', rch_pregnancy_analytics_details.anc1) as date)\n), rch_yearly_anc2 as (\n    select rch_pregnancy_analytics_details.anc2_location_id as location_id,\n    cast(date_trunc(''month'', rch_pregnancy_analytics_details.anc2) as date) as month_year,\n    sum(1) as anc2\n    from rch_pregnancy_analytics_details\n    where anc2 >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n    group by rch_pregnancy_analytics_details.anc2_location_id, cast(date_trunc(''month'', rch_pregnancy_analytics_details.anc2) as date)\n), rch_yearly_anc3 as (\n    select rch_pregnancy_analytics_details.anc3_location_id as location_id,\n    cast(date_trunc(''month'', rch_pregnancy_analytics_details.anc3) as date) as month_year,\n    sum(1) as anc3\n    from rch_pregnancy_analytics_details\n    where anc3 >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n    group by rch_pregnancy_analytics_details.anc3_location_id, cast(date_trunc(''month'', rch_pregnancy_analytics_details.anc3) as date)\n), rch_yearly_anc4 as (\n    select rch_pregnancy_analytics_details.anc4_location_id as location_id,\n    cast(date_trunc(''month'', rch_pregnancy_analytics_details.anc4) as date) as month_year,\n    sum(1) as anc4\n    from rch_pregnancy_analytics_details\n    where anc4 >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n    group by rch_pregnancy_analytics_details.anc4_location_id,cast(date_trunc(''month'', rch_pregnancy_analytics_details.anc4) as date)\n), rch_wpd_anc_det as (\n    select rprd.delivery_location_id as location_id\n    ,cast(date_trunc(''month'', rprd.delivery_reg_date) as date) as month_year,\n    sum(case when delivery_outcome in (''LBIRTH'',''SBIRTH'') and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as no_of_delivery,\n    sum(case when delivery_outcome = ''MTP'' and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as mtp,\n    sum(case when delivery_outcome in (''ABORTION'', ''SPONT_ABORTION'') and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as abortion,\n    sum(case when (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then live_birth else 0 end) as live_birth,\n    sum(case when (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then still_birth else 0 end) as still_birth\n    from rch_pregnancy_analytics_details rprd\n    where rprd.delivery_reg_date >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n    group by rprd.delivery_location_id,cast(date_trunc(''month'', rprd.delivery_reg_date) as date)\n), rch_yearly_pnc1 as (\n    select rch_pregnancy_analytics_details.pnc1_location_id as location_id,\n    cast(date_trunc(''month'', rch_pregnancy_analytics_details.pnc1) as date) as month_year,\n    sum(case when pnc1 >= to_date(''01-04-2013'',''DD-MM-YYYY'') then 1 else 0 end) as pnc1\n    from rch_pregnancy_analytics_details\n    where pnc1 >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n    group by rch_pregnancy_analytics_details.pnc1_location_id, cast(date_trunc(''month'', rch_pregnancy_analytics_details.pnc1) as date)\n), rch_yearly_pnc2 as (\n    select rch_pregnancy_analytics_details.pnc2_location_id as location_id,\n    cast(date_trunc(''month'', rch_pregnancy_analytics_details.pnc2) as date) as month_year,\n    sum(case when pnc2 >= to_date(''01-04-2013'',''DD-MM-YYYY'') then 1 else 0 end) as pnc2\n    from rch_pregnancy_analytics_details\n    where pnc2 >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n    group by rch_pregnancy_analytics_details.pnc2_location_id, cast(date_trunc(''month'', rch_pregnancy_analytics_details.pnc2) as date)\n), rch_yearly_pnc3 as (\n    select rch_pregnancy_analytics_details.pnc3_location_id as location_id,\n    cast(date_trunc(''month'', rch_pregnancy_analytics_details.pnc3) as date) as month_year,\n    sum(case when pnc3 >= to_date(''01-04-2013'',''DD-MM-YYYY'') then 1 else 0 end) as pnc3\n    from rch_pregnancy_analytics_details\n    where pnc3 >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n    group by rch_pregnancy_analytics_details.pnc3_location_id, cast(date_trunc(''month'', rch_pregnancy_analytics_details.pnc3) as date)\n), rch_yearly_pnc4 as (\n    select rch_pregnancy_analytics_details.pnc4_location_id as location_id,\n    cast(date_trunc(''month'', rch_pregnancy_analytics_details.pnc4) as date) as month_year,\n    sum(case when pnc4 >= to_date(''01-04-2013'',''DD-MM-YYYY'') then 1 else 0 end) as pnc4\n    from rch_pregnancy_analytics_details\n    where pnc4 >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n    group by rch_pregnancy_analytics_details.pnc4_location_id, cast(date_trunc(''month'', rch_pregnancy_analytics_details.pnc4) as date)\n), rch_yearly_maternal_death_det as (\n    select rch_pregnancy_analytics_details.death_location_id as location_id,\n    cast(date_trunc(''month'', rch_pregnancy_analytics_details.death_date) as date) as month_year,\n    count(*) as maternal_detah\n    from rch_pregnancy_analytics_details\n    where rch_pregnancy_analytics_details.death_date >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n    and rch_pregnancy_analytics_details.maternal_detah = true\n    group by rch_pregnancy_analytics_details.death_location_id,cast(date_trunc(''month'', rch_pregnancy_analytics_details.death_date) as date)\n), ppiucd_det as (\n    select rch_pregnancy_analytics_details.ppiucd_insert_location as location_id,\n    cast(date_trunc(''month'', rch_pregnancy_analytics_details.ppiucd_insert_date) as date) as month_year,\n    count(*) filter (where delivery_hospital in (''897'',''1062'',''899'',''1061'',''895'',''1009'',''890'',''1008'',''894'',''1063'',''892'',''891'',''1012'',''896'',''1007'',''1084'')) as ppiucd\n    from rch_pregnancy_analytics_details\n    where rch_pregnancy_analytics_details.ppiucd_insert_date is not null and rch_pregnancy_analytics_details.institutional_del = true\n    group by rch_pregnancy_analytics_details.ppiucd_insert_location,cast(date_trunc(''month'', rch_pregnancy_analytics_details.ppiucd_insert_date) as date)\n), complete_anc_date_det as (\n    select rch_pregnancy_analytics_details.complete_anc_location as location_id,\n    cast(date_trunc(''month'', rch_pregnancy_analytics_details.complete_anc_date) as date) as month_year,\n    sum(1) as complete_anc_date\n    from rch_pregnancy_analytics_details\n    where complete_anc_date >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n    group by rch_pregnancy_analytics_details.complete_anc_location, cast(date_trunc(''month'', rch_pregnancy_analytics_details.complete_anc_date) as date)\n)\n, ifa_180_anc_date_det as (\n    select rch_pregnancy_analytics_details.ifa_180_anc_location as location_id,\n    cast(date_trunc(''month'', rch_pregnancy_analytics_details.ifa_180_anc_date) as date) as month_year,\n    sum(1) as ifa_180_anc_date\n    from rch_pregnancy_analytics_details\n    where ifa_180_anc_date >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n    group by rch_pregnancy_analytics_details.ifa_180_anc_location, cast(date_trunc(''month'', rch_pregnancy_analytics_details.ifa_180_anc_date) as date)\n)\n\n, locations as (\n    select distinct location_id, month_year from (\n    select location_id, month_year from rch_service_yearly_pregnancy_reg\n    union\n    select location_id, month_year from rch_yearly_vacination_tt1\n    union\n    select location_id, month_year from rch_yearly_vacination_tt2_tt_booster\n    union\n    select location_id, month_year from rch_yearly_anc1\n    union\n    select location_id, month_year from rch_yearly_anc2\n    union\n    select location_id, month_year from rch_yearly_anc3\n    union\n    select location_id, month_year from rch_yearly_anc4\n    union\n    select location_id, month_year from rch_wpd_anc_det\n    union\n    select location_id, month_year from rch_yearly_pnc1\n    union\n    select location_id, month_year from rch_yearly_pnc2\n    union\n    select location_id, month_year from rch_yearly_pnc3\n    union\n    select location_id, month_year from rch_yearly_pnc4\n    union\n    select location_id, month_year from rch_yearly_maternal_death_det\n    union\n    select location_id, month_year from ppiucd_det\n    union\n    select location_id, month_year from complete_anc_date_det\n    union\n    select location_id, month_year from ifa_180_anc_date_det\n    ) as t where location_id is not null\n)\ninsert into rch_service_provided_during_year_t (\n    location_id,month_year,financial_year,anc_reg, anc_coverage,\n\n    regd_live_children,regd_no_live_children,c1_m1,c1_f1,c2_f2,c2_m2,c2_f1_m1,c3_f3,c3_m3,c3_m2_f1,c3_m1_f2,phi_del,phi_del_with_ppiucd\n\n    ,high_risk,current_preg_compl,severe_anemia,diabetes,\n    cur_mal_presentation_issue,cur_malaria_issue,multipara,\n    blood_pressure,interval_bet_preg_less_18_months,extreme_age,\n    height,weight,urine_albumin,\n\n    tt1,tt2_tt_booster,\n    early_anc,anc1,anc2,anc3,anc4,\n    no_of_delivery,mtp,abortion,live_birth,still_birth,\n    pnc1,pnc2,pnc3,pnc4,mother_death\n    ,ppiucd\n    ,complete_anc_date\n    ,ifa_180_anc_date\n\n)\nselect locations.location_id, locations.month_year\n,case when extract(month from locations.month_year) > 3\n    then concat(extract(year from locations.month_year), ''-'', extract(year from locations.month_year) + 1)\n    else concat(extract(year from locations.month_year) - 1, ''-'', extract(year from locations.month_year)) end as financial_year\n,rch_service_yearly_pregnancy_reg.anc_reg\n,rch_service_yearly_pregnancy_reg.anc_coverage\n,rch_service_yearly_pregnancy_reg.regd_live_children\n,rch_service_yearly_pregnancy_reg.regd_no_live_children\n,rch_service_yearly_pregnancy_reg.c1_m1\n,rch_service_yearly_pregnancy_reg.c1_f1\n,rch_service_yearly_pregnancy_reg.c2_f2\n,rch_service_yearly_pregnancy_reg.c2_m2\n,rch_service_yearly_pregnancy_reg.c2_f1_m1\n,rch_service_yearly_pregnancy_reg.c3_f3\n,rch_service_yearly_pregnancy_reg.c3_m3\n,rch_service_yearly_pregnancy_reg.c3_m2_f1\n,rch_service_yearly_pregnancy_reg.c3_m1_f2\n,rch_service_yearly_pregnancy_reg.phi_del\n,rch_service_yearly_pregnancy_reg.phi_del_with_ppiucd\n\n,rch_service_yearly_pregnancy_reg.high_risk,current_preg_compl\n,rch_service_yearly_pregnancy_reg.severe_anemia,diabetes\n,rch_service_yearly_pregnancy_reg.cur_mal_presentation_issue\n,rch_service_yearly_pregnancy_reg.cur_malaria_issue\n,rch_service_yearly_pregnancy_reg.multipara\n,rch_service_yearly_pregnancy_reg.blood_pressure\n,rch_service_yearly_pregnancy_reg.interval_bet_preg_less_18_months\n,rch_service_yearly_pregnancy_reg.extreme_age\n,rch_service_yearly_pregnancy_reg.height\n,rch_service_yearly_pregnancy_reg.weight\n,rch_service_yearly_pregnancy_reg.urine_albumin\n\n,rch_yearly_vacination_tt1.tt1,\nrch_yearly_vacination_tt2_tt_booster.tt2_tt_booster,\nrch_service_yearly_pregnancy_reg.early_anc,\nrch_yearly_anc1.anc1,\nrch_yearly_anc2.anc2,\nrch_yearly_anc3.anc3,\nrch_yearly_anc4.anc4,\nrch_wpd_anc_det.no_of_delivery,\nrch_wpd_anc_det.mtp,\nrch_wpd_anc_det.abortion,\nrch_wpd_anc_det.live_birth,\nrch_wpd_anc_det.still_birth,\nrch_yearly_pnc1.pnc1,\nrch_yearly_pnc2.pnc2,\nrch_yearly_pnc3.pnc3,\nrch_yearly_pnc4.pnc4,\nrch_yearly_maternal_death_det.maternal_detah,\nppiucd_det.ppiucd,\ncomplete_anc_date_det.complete_anc_date,\nifa_180_anc_date_det.ifa_180_anc_date\nfrom locations\nleft join rch_service_yearly_pregnancy_reg on rch_service_yearly_pregnancy_reg.location_id = locations.location_id\n    and rch_service_yearly_pregnancy_reg.month_year = locations.month_year\nleft join rch_yearly_vacination_tt1 on rch_yearly_vacination_tt1.location_id = locations.location_id\n    and rch_yearly_vacination_tt1.month_year = locations.month_year\nleft join rch_yearly_vacination_tt2_tt_booster on rch_yearly_vacination_tt2_tt_booster.location_id = locations.location_id\n    and rch_yearly_vacination_tt2_tt_booster.month_year = locations.month_year\nleft join rch_yearly_anc1 on rch_yearly_anc1.location_id = locations.location_id\n    and rch_yearly_anc1.month_year = locations.month_year\nleft join rch_yearly_anc2 on rch_yearly_anc2.location_id = locations.location_id\n    and rch_yearly_anc2.month_year = locations.month_year\nleft join rch_yearly_anc3 on rch_yearly_anc3.location_id = locations.location_id\n    and rch_yearly_anc3.month_year = locations.month_year\nleft join rch_yearly_anc4 on rch_yearly_anc4.location_id = locations.location_id\n    and rch_yearly_anc4.month_year = locations.month_year\nleft join rch_wpd_anc_det on rch_wpd_anc_det.location_id = locations.location_id\n    and rch_wpd_anc_det.month_year = locations.month_year\nleft join rch_yearly_pnc1 on rch_yearly_pnc1.location_id = locations.location_id\n    and rch_yearly_pnc1.month_year = locations.month_year\nleft join rch_yearly_pnc2 on rch_yearly_pnc2.location_id = locations.location_id\n    and rch_yearly_pnc2.month_year = locations.month_year\nleft join rch_yearly_pnc3 on rch_yearly_pnc3.location_id = locations.location_id\n    and rch_yearly_pnc3.month_year = locations.month_year\nleft join rch_yearly_pnc4 on rch_yearly_pnc4.location_id = locations.location_id\n    and rch_yearly_pnc4.month_year = locations.month_year\nleft join rch_yearly_maternal_death_det on rch_yearly_maternal_death_det.location_id = locations.location_id\n    and rch_yearly_maternal_death_det.month_year = locations.month_year\nleft join ppiucd_det on ppiucd_det.location_id = locations.location_id\n    and ppiucd_det.month_year = locations.month_year\nleft join complete_anc_date_det on complete_anc_date_det.location_id = locations.location_id\n    and complete_anc_date_det.month_year = locations.month_year\nleft join ifa_180_anc_date_det on ifa_180_anc_date_det.location_id = locations.location_id\n    and ifa_180_anc_date_det.month_year = locations.month_year;\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED18''\nwhere event_config_id = 39 and status = ''PROCESSED17'';\ncommit;\n\nbegin; \n\ndrop table if exists rch_lmp_base_location_wise_data_point;\nALTER TABLE rch_lmp_base_location_wise_data_point_t\n  RENAME TO rch_lmp_base_location_wise_data_point;\n\n---21\ndrop table if exists rch_delivery_date_base_location_wise_data_point;\nALTER TABLE rch_delivery_date_base_location_wise_data_point_t\n  RENAME TO rch_delivery_date_base_location_wise_data_point;\n  \n---22\ndrop table if exists rch_yearly_location_wise_analytics_data;\nALTER TABLE rch_yearly_location_wise_analytics_data_t\n  RENAME TO rch_yearly_location_wise_analytics_data;\n  \n---23\ndrop table if exists rch_current_state_pregnancy_analytics_data;\nALTER TABLE rch_current_state_pregnancy_analytics_data_t\n  RENAME TO rch_current_state_pregnancy_analytics_data;\n  \n---24\ndrop table if exists rch_service_provided_during_year;\nALTER TABLE rch_service_provided_during_year_t\n  RENAME TO rch_service_provided_during_year;\n  \nupdate system_configuration set key_value = TO_CHAR(current_date, ''MM-DD-YYYY'') \nwhere system_key = ''rch_pregnancy_analytics_last_schedule_date'';\n\nupdate system_configuration set key_value = ''false'' \nwhere system_key = ''rch_pregnancy_analytics_run_for_all_pregnancy'';\n  \nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED19''\nwhere event_config_id = 39 and status = ''PROCESSED18'';\n\ncommit;\n\nbegin;\ndrop table if exists rch_anemia_status_analytics_t;\ncreate table rch_anemia_status_analytics_t(\nlocation_id integer,\nmonth_year date,\nanc_reg integer,\nanc_with_hb integer,\nanc_with_hb_more_than_4 integer,\nmild_hb integer,\nmodrate_hb integer,\nsevere_hb integer,\nnormal_hb integer,\nsevere_hb_with_iron_def_inj integer,\nsevere_hb_with_blood_transfusion integer,\nprimary key (location_id,month_year)\n);\n\ninsert into rch_anemia_status_analytics_t(\nlocation_id\n,month_year\n,anc_reg\n,anc_with_hb\n,anc_with_hb_more_than_4\n,mild_hb\n,modrate_hb\n,severe_hb\n,normal_hb\n,severe_hb_with_iron_def_inj\n,severe_hb_with_blood_transfusion\n)\nselect \nrprd.native_location_id as location_id\n,cast(date_trunc(''month'', rprd.reg_service_date) as date) as month_year\n,count(*) as anc_reg\n,count(1) filter(where hb >= 0.1) as anc_with_hb\n,count(1) filter(where haemoglobin_tested_count >= 4) as anc_with_hb_more_than_4\n,count(1) filter(where hb between 10 and 10.99) as mild_hb\n,count(1) filter(where hb between 7 and 9.99) as modrate_hb\n,count(1) filter(where hb between 0.1 and 6.99) as severe_hb\n,count(1) filter(where hb >= 11) as normal_hb\n,count(1) filter(where hb between 0.1 and 6.99 and iron_def_anemia_inj is not null) as severe_hb_with_iron_def_inj\n,count(1) filter(where hb between 0.1 and 6.99 and blood_transfusion) as severe_hb_with_blood_transfusion\nfrom rch_pregnancy_analytics_details rprd\ngroup by rprd.native_location_id,cast(date_trunc(''month'', rprd.reg_service_date) as date);\n\ndrop table if exists rch_anemia_status_analytics;\nALTER TABLE rch_anemia_status_analytics_t\n  RENAME TO rch_anemia_status_analytics;\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''COMPLETED''\nwhere event_config_id = 39 and status = ''PROCESSED19'';\n\ncommit;","mobileNotificationType":null,"mobileNotificationTypeUUID":null,"emailSubject":null,"emailSubjectParameter":null,"templateParameter":null,"baseDateFieldName":null,"refCode":null,"memberFieldName":null,"userFieldName":null,"familyFieldName":null,"trigerWhen":"IMMEDIATELY","day":null,"hour":null,"miniute":null,"mobileNotificationConfigs":null,"configId":39,"eventConfigUUID":null,"queryMasterId":null,"queryCode":null,"queryMasterParamJson":null,"exceptionType":null,"exceptionMessage":null,"smsConfigJson":null,"pushNotificationConfigJson":null,"systemFunctionId":null,"functionParams":null}]}]}]', 'ACTIVE', 'DAILY', null, '0873826b-e125-446c-bf4f-5e3b0d83c450');

DELETE FROM TIMER_EVENT WHERE event_config_uuid ='0873826b-e125-446c-bf4f-5e3b0d83c450' and status = 'NEW';

INSERT INTO timer_event(event_config_uuid, processed, status, type, system_trigger_on)
VALUES (
'0873826b-e125-446c-bf4f-5e3b0d83c450', false, 'NEW', 'TIMER_EVENT', '07-03-2024 02:00:00');

DELETE FROM EVENT_CONFIGURATION_TYPE WHERE event_config_uuid ='0873826b-e125-446c-bf4f-5e3b0d83c450';

INSERT INTO EVENT_CONFIGURATION_TYPE(id, base_date_field_name, event_config_uuid, day, email_subject, email_subject_parameter, hour, minute, mobile_notification_type, template, template_parameter, triger_when, type, user_field_name, family_field_name, member_field_name, query_master_id, query_master_param_json, query_code, sms_config_json, push_notification_config_json)
VALUES (
'8fb48344-84d1-4c23-ab76-54193ed3ae02', null, '0873826b-e125-446c-bf4f-5e3b0d83c450', null, null, null, null, null, null, 'begin;
---1
drop table if exists t_pregnancy_registration_det;
create table t_pregnancy_registration_det
(
	pregnancy_reg_id bigint primary key,
	member_id bigint,
	unique_health_id text,
	dob date,
	family_id text,
	member_name text,
	mobile_number text,
	reg_service_date date,
	reg_service_date_month_year date,
	reg_service_financial_year text,
	reg_server_date timestamp without time zone,
	pregnancy_reg_location_id bigint,
	native_location_id integer,

	tracking_location_id integer,
	is_valid_for_tracking_report boolean,

	pregnancy_reg_family_id bigint,
	preg_reg_state text,
	member_basic_state text,
	member_state text,

	family_basic_state text,
	marital_status integer,
	address text,
	husband_name text,
	husband_mobile_number text,
	hof_name text,
	hof_mobile_number text,

	lmp_date date,
	lmp_month_year date,
	lmp_financial_year text,
	edd date,
	date_of_delivery date,
	date_of_delivery_month_year date,
	delivery_reg_date date,
	delivery_reg_date_financial_year text,
	delivery_location_id bigint,
	delivery_family_id bigint,
	member_current_location_id bigint,
	age_during_delivery smallint,
	registered_with_no_of_child smallint,
	registered_with_male_cnt smallint,
	registered_with_female_cnt smallint,
	anc1 date,
	anc1_location_id integer,
	anc2 date,
	anc2_location_id integer,
	anc3 date,
	anc3_location_id integer,
	anc4 date,
	anc4_location_id integer,
	last_systolic_bp integer,
	last_diastolic_bp integer,
	total_regular_anc smallint,
	tt1_given date,
	tt1_location_id integer,
	tt2_given date,
	tt2_location_id integer,
	tt_boster date,
	tt_booster_location_id integer,
	tt2_tt_booster_given date,
	tt2_tt_booster_location_id integer,
	early_anc boolean,
	total_anc smallint,

	complete_anc_date date,
	complete_anc_location integer,


	ifa integer,

	ifa_180_anc_date date,
	ifa_180_anc_location integer,

	fa_tab_in_30_day integer,
	fa_tab_in_31_to_60_day integer,
	fa_tab_in_61_to_90_day integer,
	ifa_tab_in_4_month_to_9_month integer,
	hb real,
	hb_date date,
	hb_between_90_to_360_days real,
	total_ca integer,
	ca_tab_in_91_to_180_day integer,
	ca_tab_in_181_to_360_day integer,
	expected_delivery_place text,

	L2L_Preg_Complication text,
	Outcome_L2L_Preg text,
	L2L_Preg_Complication_Length smallint,
	Outcome_Last_Preg integer,


	alben_given boolean,
	maternal_detah boolean,
	maternal_death_type text,
	death_date date,
	death_location_id integer,

	low_height boolean,
	urine_albumin boolean,

	systolic_bp smallint,
	diastolic_bp smallint,
	prev_pregnancy_date date,
	prev_preg_diff_in_month smallint,
	gravida smallint,

	any_chronic_dis boolean,
	high_risk_mother boolean,

	pre_preg_anemia boolean,
	pre_preg_caesarean_section boolean,
	pre_preg_aph boolean,
	pre_preg_pph boolean,
	pre_preg_pre_eclampsia boolean,
	pre_preg_abortion boolean,
	pre_preg_obstructed_labour boolean,
	pre_preg_placenta_previa boolean,
	pre_preg_malpresentation  boolean,
	pre_preg_birth_defect boolean,
	pre_preg_preterm_delivery boolean,
	any_prev_preg_complication boolean,

	chro_tb boolean,
	chro_diabetes boolean,
	chro_heart_kidney boolean,
	chro_hiv boolean,
	chro_sickle boolean,
	chro_thalessemia boolean,

	cur_extreme_age boolean,
	cur_low_weight boolean,
	cur_severe_anemia boolean,
	cur_blood_pressure_issue boolean,
	cur_urine_protein_issue boolean,
	cur_convulsion_issue boolean,
	cur_malaria_issue boolean,
	cur_social_vulnerability boolean,
	cur_gestational_diabetes_issue boolean,
	cur_twin_pregnancy boolean,
	cur_mal_presentation_issue boolean,
	cur_absent_reduce_fetal_movment boolean,
	cur_less_than_18_month_interval boolean,
	cur_aph_issue boolean,
	cur_pelvic_sepsis boolean,
	cur_hiv_issue boolean,
	cur_vdrl_issue boolean,
	cur_hbsag_issue boolean,
	cur_brethless_issue boolean,
	any_cur_preg_complication boolean,

	high_risk_cnt smallint,
	hbsag_test_cnt smallint,
	hbsag_reactive_cnt smallint,
	hbsag_non_reactive_cnt smallint,

	delivery_outcome text,
	type_of_delivery text,
	home_del boolean,
	institutional_del boolean,
	delivery_108 boolean,

    delivery_out_of_state_govt boolean,
    delivery_out_of_state_pvt boolean,

    delivery_place text,
	breast_feeding_in_one_hour boolean,
	delivery_hospital text,
	delivery_health_infrastructure integer,
	del_week smallint,
	is_cortico_steroid boolean,
	mother_alive boolean,
	total_out_come smallint,
	male smallint,
	female smallint,

	still_birth smallint,
	live_birth smallint,


	delivery_done_by text,
	pnc1 date,
	pnc1_location_id integer,
	pnc2 date,
	pnc2_location_id integer,
	pnc3 date,
	pnc3_location_id integer,
	pnc4 date,
	pnc4_location_id integer,
    pnc5 date,
    pnc5_location_id integer,
    pnc6 date,
    pnc6_location_id integer,
	pnc7 date,
	pnc7_location_id integer,


	ifa_tab_after_delivery smallint,

	haemoglobin_tested_count integer,
	iron_def_anemia_inj text,
	blood_transfusion boolean,

	ppiucd_insert_date date,
	ppiucd_insert_location integer,

	high_risk_reasons text,

	is_fru boolean
);


delete from rch_pregnancy_analytics_details where pregnancy_reg_id in (
select rpa.pregnancy_reg_id
from rch_pregnancy_analytics_details rpa
left join imt_member m on rpa.member_id = m.id and m.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'',''DEAD'',''TEMPORARY'',''MIGRATED'')
--left join imt_family f on m.family_id = f.family_id and f.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'',''TEMPORARY'',''MIGRATED'')
where  m.id is null
--or f.id is null
) and (select cast(key_value as boolean) as value from system_configuration where system_key = ''rch_pregnancy_analytics_run_for_all_pregnancy'' ) = false;

delete from rch_pregnancy_analytics_details where pregnancy_reg_id in (
select rpa.pregnancy_reg_id
from rch_pregnancy_analytics_details rpa
left join imt_family f on rpa.family_id = f.family_id and f.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'',''TEMPORARY'',''MIGRATED'')
where
f.id is null
) and (select cast(key_value as boolean) as value from system_configuration where system_key = ''rch_pregnancy_analytics_run_for_all_pregnancy'' ) = false;

delete from rch_pregnancy_analytics_details where pregnancy_reg_id in (
select rpa.pregnancy_reg_id
from rch_pregnancy_analytics_details rpa
left join rch_pregnancy_registration_det rpr on rpr.id = rpa.pregnancy_reg_id and rpr.state in (''DELIVERY_DONE'',''PENDING'',''PREGNANT'')
where rpr.id is null
)and (select cast(key_value as boolean) as value from system_configuration where system_key = ''rch_pregnancy_analytics_run_for_all_pregnancy'' ) = false;


with parameter as (
select
(select to_date(key_value,''MM-DD-YYYY'') as  from_date from system_configuration  where system_key = ''rch_pregnancy_analytics_last_schedule_date'') as from_date
,(select cast(key_value as boolean) as value from system_configuration where system_key = ''rch_pregnancy_analytics_run_for_all_pregnancy'') as run_for_all_pregnancy
), member_det as (
select imt_member.id as member_id
from imt_member,rch_pregnancy_registration_det rpa,parameter,imt_family f
where rpa.member_id = imt_member.id
and f.family_id = imt_member.family_id
--and  imt_member.modified_on >= (select to_date(key_value,''MM-DD-YYYY'') as  from_date from system_configuration  where system_key = ''rch_pregnancy_analytics_last_schedule_date'')
--and  imt_member.modified_on >= current_date - interval ''2 day''
and f.modified_on >= current_date - interval ''2 day''
and parameter.run_for_all_pregnancy = false
union
select member_id from rch_pregnancy_registration_det,parameter
where parameter.run_for_all_pregnancy = true
--or modified_on >= (select to_date(key_value,''MM-DD-YYYY'') as  from_date from system_configuration  where system_key = ''rch_pregnancy_analytics_last_schedule_date'')
or modified_on >= current_date - interval ''2 day''
union
select member_id from rch_lmp_follow_up ,parameter
--where modified_on >= (select to_date(key_value,''MM-DD-YYYY'') as  from_date from system_configuration  where system_key = ''rch_pregnancy_analytics_last_schedule_date'')
where modified_on >= current_date - interval ''2 day''
and parameter.run_for_all_pregnancy = false
union
select member_id from rch_anc_master ,parameter
--where modified_on >= (select to_date(key_value,''MM-DD-YYYY'') as  from_date from system_configuration  where system_key = ''rch_pregnancy_analytics_last_schedule_date'')
where modified_on >= current_date - interval ''2 day''
and parameter.run_for_all_pregnancy = false
union
select member_id from rch_wpd_mother_master,parameter
--where modified_on >= (select to_date(key_value,''MM-DD-YYYY'') as  from_date from system_configuration  where system_key = ''rch_pregnancy_analytics_last_schedule_date'')
where modified_on >= current_date - interval ''2 day''
and parameter.run_for_all_pregnancy = false
union
select member_id from rch_pnc_master ,parameter
--where modified_on >= (select to_date(key_value,''MM-DD-YYYY'') as  from_date from system_configuration  where system_key = ''rch_pregnancy_analytics_last_schedule_date'')
where modified_on >= current_date - interval ''2 day''
and parameter.run_for_all_pregnancy = false
)
insert into t_pregnancy_registration_det(
	pregnancy_reg_id,member_id,unique_health_id,dob,family_id,member_name,mobile_number,reg_service_date,reg_service_date_month_year,reg_service_financial_year,
	reg_server_date,pregnancy_reg_location_id,native_location_id,lmp_date,lmp_month_year,lmp_financial_year,edd,preg_reg_state,member_basic_state
	,early_anc,is_valid_for_tracking_report, family_basic_state, marital_status, address, husband_name, husband_mobile_number
	, hof_name, hof_mobile_number
)
select rch_pregnancy_registration_det.id,
rch_pregnancy_registration_det.member_id,
imt_member.unique_health_id,
imt_member.dob,
imt_member.family_id,
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name),
imt_member.mobile_number,
reg_date,
cast(date_trunc(''month'', reg_date) as date),
case when extract(month from reg_date) > 3
	then concat(extract(year from reg_date), ''-'', extract(year from reg_date) + 1)
	else concat(extract(year from reg_date) - 1, ''-'', extract(year from reg_date)) end,
rch_pregnancy_registration_det.created_on,
rch_pregnancy_registration_det.location_id,
rch_pregnancy_registration_det.location_id,
rch_pregnancy_registration_det.lmp_date,
cast(date_trunc(''month'', rch_pregnancy_registration_det.lmp_date) as date),
case when extract(month from rch_pregnancy_registration_det.lmp_date) > 3
	then concat(extract(year from rch_pregnancy_registration_det.lmp_date), ''-'', extract(year from rch_pregnancy_registration_det.lmp_date) + 1)
	else concat(extract(year from rch_pregnancy_registration_det.lmp_date) - 1, ''-'', extract(year from rch_pregnancy_registration_det.lmp_date)) end,
rch_pregnancy_registration_det.edd as edd,
rch_pregnancy_registration_det.state as preg_reg_state,
imt_member.basic_state as member_basic_state,
case when rch_pregnancy_registration_det.lmp_date + interval ''84 days'' >= rch_pregnancy_registration_det.reg_date then true else false end,
case when (imt_family.state in (''com.argusoft.imtecho.family.state.archived.temporary'',''com.argusoft.imtecho.family.state.archived.temporary.outofstate'', ''com.argusoft.imtecho.family.state.migrated.outofstate'')
	or imt_member.state in (''com.argusoft.imtecho.member.state.migrated.lfu'',''com.argusoft.imtecho.member.state.migrated.outofstate'',''com.argusoft.imtecho.member.state.archived.outofstate''))
	then false else true end,
imt_family.basic_state as family_basic_state,
imt_member.marital_status as marital_status,
concat_ws('', '',imt_family.address1,imt_family.address2) as address,
concat_ws('' '', husband.first_name, husband.middle_name, husband.last_name) as husband_name,
husband.mobile_number as husband_mobile_number,
concat_ws('' '', hof.first_name, hof.middle_name, hof.last_name) as hof_name,
hof.mobile_number as hof_mobile_number

from member_det inner join
rch_pregnancy_registration_det on member_det.member_id = rch_pregnancy_registration_det.member_id
inner join imt_member on rch_pregnancy_registration_det.member_id = imt_member.id
and imt_member.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'',''DEAD'',''TEMPORARY'',''MIGRATED'')
inner join imt_family on imt_member.family_id = imt_family.family_id
and imt_family.basic_state in(''VERIFIED'',''REVERIFICATION'',''NEW'',''TEMPORARY'',''MIGRATED'')
left join imt_member husband on imt_member.husband_id = husband.id
left join imt_member hof on imt_family.hof_id = hof.id
where
rch_pregnancy_registration_det.state in (''DELIVERY_DONE'',''PENDING'',''PREGNANT'');

update timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED1''
where event_config_id = 39 and status = ''PROCESSED'';
commit;
---2
begin;
with rch_anc_det as(
select rch_anc_master.*,sum(ifa_tablets_given)OVER(PARTITION BY rch_anc_master.pregnancy_reg_det_id ORDER BY rch_anc_master.service_date) as total_ifa_tab
from rch_anc_master,t_pregnancy_registration_det
where rch_anc_master.pregnancy_reg_det_id = t_pregnancy_registration_det.pregnancy_reg_id
and rch_anc_master.member_status = ''AVAILABLE''
)
update t_pregnancy_registration_det
set anc1 = (case when t.anc1 is not null then t.anc1
				when t.anc2 is not null then t.anc2
				when t.anc3 is not null then t.anc3
				when t.anc4 is not null then t.anc4
			end)
, anc1_location_id = (case when t.anc1 is not null then t.anc1_location_id
				when t.anc2 is not null then t.anc2_location_id
				when t.anc3 is not null then t.anc3_location_id
				when t.anc4 is not null then t.anc4_location_id
			end)
, anc2 = (case 	when t.anc2 is not null and t.anc1 is not null then t.anc2
				when t.anc3 is not null and (t.anc1 is not null or t.anc2 is not null) then t.anc3
				when t.anc4 is not null and (t.anc1 is not null or t.anc2 is not null or t.anc3 is not null) then t.anc4
			end)
, anc2_location_id = (case 	when t.anc2 is not null and t.anc1 is not null then t.anc2_location_id
				when t.anc3 is not null and (t.anc1 is not null or t.anc2 is not null) then t.anc3_location_id
				when t.anc4 is not null and (t.anc1 is not null or t.anc2 is not null or t.anc3 is not null) then t.anc4_location_id
			end)
, anc3 = (case 	when t.anc3 is not null and (t.anc1 is not null and t.anc2 is not null) then t.anc3
				when t.anc4 is not null and ((case when t.anc1 is not null then 1 else 0 end)
											+(case when t.anc2 is not null then 1 else 0 end)
											+(case when t.anc3 is not null then 1 else 0 end)) = 2 then t.anc4

			end)
, anc3_location_id = (case 	when t.anc3 is not null and (t.anc1 is not null and t.anc2 is not null) then t.anc3_location_id
				when t.anc4 is not null and ((case when t.anc1 is not null then 1 else 0 end)
											+(case when t.anc2 is not null then 1 else 0 end)
											+(case when t.anc3 is not null then 1 else 0 end)) = 2 then t.anc4_location_id

			end)
, anc4 = (case when t.anc4 is not null and t.anc1 is not null and t.anc2 is not null and t.anc3 is not null then t.anc4 end)
, anc4_location_id = (case when t.anc4 is not null and t.anc1 is not null and t.anc2 is not null and t.anc3 is not null then t.anc4_location_id end)
--, early_anc = case when t.early_reg = 1 then true else false end
, alben_given = case when t.alben_given = 1 then true else false end,
ifa = t.ifa_tablets_given
,ifa_180_anc_date = t.ifa_180_anc_date
,ifa_180_anc_location = t.ifa_180_anc_location
, total_anc = t.total_anc
, fa_tab_in_30_day = t.fa_tab_in_30_day
, fa_tab_in_31_to_60_day = t.fa_tab_in_31_to_60_day
, fa_tab_in_61_to_90_day = t.fa_tab_in_61_to_90_day
, ifa_tab_in_4_month_to_9_month = t.ifa_tab_in_4_month_to_9_month
, ca_tab_in_91_to_180_day = t.ca_tab_in_91_to_180_day
, ca_tab_in_181_to_360_day = t.ca_tab_in_181_to_360_day
, hb = t.hb
, hb_date = t.hb_date
, haemoglobin_tested_count = t.haemoglobin_tested_count
, total_ca = t.total_ca
, expected_delivery_place = t.expected_delivery_place
, hb_between_90_to_360_days = t.hb_between_90_to_360_days
,hbsag_test_cnt = t.hbsag_test_cnt
,hbsag_reactive_cnt = t.hbsag_reactive_cnt
,hbsag_non_reactive_cnt = case when t.hbsag_test_cnt = 1 and t.hbsag_reactive_cnt = 0 then 1 else 0 end
,iron_def_anemia_inj = t.iron_def_anemia_inj
,blood_transfusion = case when t.blood_transfusion = 1 then true else false end
,last_systolic_bp = t.systolic_bp
,last_diastolic_bp = t.diastolic_bp
from(
	select t1.pregnancy_reg_det_id,t1.anc1,t1.anc2,t1.anc3,t1.anc4,t1.alben_given
	,t1.ifa_tablets_given,ifa_180_anc.service_date as ifa_180_anc_date,ifa_180_anc.location_id as ifa_180_anc_location
	,t1.total_anc
	,anc_master1.location_id as anc1_location_id,anc_master2.location_id as anc2_location_id
	,anc_master3.location_id as anc3_location_id,anc_master4.location_id as anc4_location_id
	,anc_systolic_bp.systolic_bp,anc_diastolic_bp.diastolic_bp
	,t1.fa_tab_in_30_day,t1.fa_tab_in_31_to_60_day,t1.fa_tab_in_61_to_90_day
	,t1.ifa_tab_in_4_month_to_9_month,anc_hb.haemoglobin_count as hb,anc_hb.service_date as hb_date
	,t1.haemoglobin_tested_count,t1.hb_between_90_to_360_days,t1.total_ca,t1.ca_tab_in_91_to_180_day
	,t1.ca_tab_in_181_to_360_day,t1.expected_delivery_place
	,t1.hbsag_test_cnt,t1.hbsag_reactive_cnt
	,iron_def_anemia_inj_det.iron_def_anemia_inj,t1.blood_transfusion
	from (
	select rch_anc_master.pregnancy_reg_det_id,
	min(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 0 and 84 then rch_anc_master.service_date else null end) anc1,
	min(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 0 and 84 then rch_anc_master.id else null end) anc1_id,
	min(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 85 and 182 then rch_anc_master.service_date else null end) anc2,
	min(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 85 and 182 then rch_anc_master.id else null end) anc2_id,
	min(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 183 and 238 then rch_anc_master.service_date else null end) anc3,
	min(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 183 and 238 then rch_anc_master.id else null end) anc3_id,
	min(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date >= 239 then rch_anc_master.service_date else null end) anc4,
	min(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date >= 239 then rch_anc_master.id else null end) anc4_id,
	--max(case when t_pregnancy_registration_det.lmp_date + interval ''84 days'' > t_pregnancy_registration_det.reg_service_date then 1 else 0 end) early_reg,
	max(case when rch_anc_master.systolic_bp is not null then rch_anc_master.id else null end) as systolic_bp,
	max(case when rch_anc_master.diastolic_bp is not null then rch_anc_master.id else null end) as diastolic_bp,
	max(case when albendazole_given then 1 else 0 end) as alben_given,
	sum(ifa_tablets_given) as ifa_tablets_given,
	sum(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 0 and 30 then fa_tablets_given else 0 end) as fa_tab_in_30_day,
	sum(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 31 and 60 then fa_tablets_given else 0 end) as fa_tab_in_31_to_60_day,
	sum(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 61 and 90 then fa_tablets_given else 0 end) as fa_tab_in_61_to_90_day,
	sum(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 90 and 270 then ifa_tablets_given else 0 end) as ifa_tab_in_4_month_to_9_month,
	max(case when haemoglobin_count is not null then rch_anc_master.id else null end ) as hb,
	sum(case when haemoglobin_count is not null then 1 else 0 end )  as haemoglobin_tested_count,
	max(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 90 and 360 then haemoglobin_count else 0 end) as hb_between_90_to_360_days,
	sum(calcium_tablets_given) as total_ca,
	sum(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 91 and 180 then calcium_tablets_given else 0 end) as ca_tab_in_91_to_180_day,
	sum(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 181 and 360 then calcium_tablets_given else 0 end) as ca_tab_in_181_to_360_day,
	max(rch_anc_master.expected_delivery_place) as expected_delivery_place,
	max(case when rch_anc_master.hbsag_test is not null then 1 else 0 end) as hbsag_test_cnt,
	max(case when rch_anc_master.hbsag_test = ''REACTIVE'' then 1 else 0 end) as hbsag_reactive_cnt,
	max(case when rch_anc_master.iron_def_anemia_inj in (''FCM'',''IRON_SUCROSE'') then rch_anc_master.id else null end) as iron_def_anemia_inj_anc_id,
	max(case when rch_anc_master.blood_transfusion = true then 1 else 0 end) as blood_transfusion,
	count(*) total_anc,
	min(case when rch_anc_master.total_ifa_tab >= 180 then rch_anc_master.id end) as ifa_180_anc_id
	from rch_anc_det as rch_anc_master,t_pregnancy_registration_det
	where rch_anc_master.pregnancy_reg_det_id = t_pregnancy_registration_det.pregnancy_reg_id
	and rch_anc_master.member_status = ''AVAILABLE''
	group by rch_anc_master.pregnancy_reg_det_id) as t1
	left join rch_anc_master anc_master1 on anc_master1.id = t1.anc1_id
	left join rch_anc_master anc_master2 on anc_master2.id = t1.anc2_id
	left join rch_anc_master anc_master3 on anc_master3.id = t1.anc3_id
	left join rch_anc_master anc_master4 on anc_master4.id = t1.anc3_id
	left join rch_anc_master anc_systolic_bp on anc_systolic_bp.id = t1.systolic_bp
	left join rch_anc_master anc_diastolic_bp on anc_diastolic_bp.id = t1.diastolic_bp
	left join rch_anc_master anc_hb on anc_hb.id = t1.hb
	left join rch_anc_master iron_def_anemia_inj_det on iron_def_anemia_inj_det.id = t1.iron_def_anemia_inj_anc_id
	left join rch_anc_master ifa_180_anc on ifa_180_anc.id = t1.ifa_180_anc_id

) as t
where t.pregnancy_reg_det_id = t_pregnancy_registration_det.pregnancy_reg_id;

update timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED2''
where event_config_id = 39 and status = ''PROCESSED1'';
commit;
---3
begin;
/*
update t_pregnancy_registration_det
set hbsag_test_cnt = t.hbsag_test_cnt,
hbsag_reactive_cnt = t.hbsag_reactive_cnt,
hbsag_non_reactive_cnt = case when t.hbsag_test_cnt = 1 and t.hbsag_reactive_cnt = 0 then 1 else 0 end
from (
	select rch_anc_master.pregnancy_reg_det_id,
	max(case when rch_anc_master.hbsag_test is not null then 1 else 0 end) as hbsag_test_cnt,
	max(case when rch_anc_master.hbsag_test = ''REACTIVE'' then 1 else 0 end) as hbsag_reactive_cnt
	--sum(case when rch_anc_master.hbsag_test = ''NON_REACTIVE'' then 1 else 0 end) as hbsag_non_reactive_cnt
	from rch_anc_master
	inner join t_pregnancy_registration_det
	on rch_anc_master.pregnancy_reg_det_id = t_pregnancy_registration_det.pregnancy_reg_id
	where rch_anc_master.member_status = ''AVAILABLE''
	group by rch_anc_master.pregnancy_reg_det_id
) as t
where t.pregnancy_reg_det_id = t_pregnancy_registration_det.pregnancy_reg_id;
*/
update timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED3''
where event_config_id = 39 and status = ''PROCESSED2'';

commit;

---4
begin;
update t_pregnancy_registration_det
set cur_severe_anemia = case when t.cur_severe_anemia = 1 then true else false end
,cur_blood_pressure_issue = case when t.cur_blood_pressure_issue = 1 then true else false end
,low_height = case when t.low_height = 1 then true else false end
,cur_low_weight = case when t.cur_low_weight = 1 then true else false end
,urine_albumin = case when t.urine_albumin = 1 then true else false end
,high_risk_mother = case when t.high_risk_mother = 1 then true else false end
,pre_preg_anemia = case when t.pre_preg_anemia = 1 then true else false end
,pre_preg_caesarean_section = case when t.pre_preg_caesarean_section = 1 then true else false end
,pre_preg_abortion = case when t.pre_preg_abortion = 1 then true else false end
,pre_preg_aph = case when t.pre_preg_aph = 1 then true else false end
,pre_preg_pph = case when t.pre_preg_pph = 1 then true else false end
,pre_preg_pre_eclampsia = case when t.pre_preg_pre_eclampsia = 1 then true else false end
,pre_preg_obstructed_labour = case when t.pre_preg_obstructed_labour = 1 then true else false end
,pre_preg_placenta_previa = case when t.pre_preg_placenta_previa = 1 then true else false end
,pre_preg_malpresentation = case when t.pre_preg_malpresentation = 1 then true else false end
,pre_preg_birth_defect = case when t.pre_preg_birth_defect = 1 then true else false end
,pre_preg_preterm_delivery = case when t.pre_preg_preterm_delivery = 1 then true else false end
,cur_urine_protein_issue = case when t.cur_urine_protein_issue = 1 then true else false end
,cur_convulsion_issue = case when t.cur_convulsion_issue = 1 then true else false end
,cur_malaria_issue = case when t.cur_malaria_issue = 1 then true else false end
,cur_gestational_diabetes_issue = case when t.cur_gestational_diabetes_issue = 1 then true else false end
,cur_twin_pregnancy = case when t.cur_twin_pregnancy = 1 then true else false end
,cur_mal_presentation_issue = case when t.cur_mal_presentation_issue = 1 then true else false end
,cur_absent_reduce_fetal_movment = case when t.cur_absent_reduce_fetal_movment = 1 then true else false end
,cur_aph_issue = case when t.cur_aph_issue = 1 then true else false end
,cur_pelvic_sepsis = case when t.cur_pelvic_sepsis = 1 then true else false end
,cur_hiv_issue = case when t.cur_hiv_issue = 1 then true else false end
,cur_vdrl_issue = case when t.cur_vdrl_issue = 1 then true else false end
,cur_hbsag_issue = case when t.cur_hbsag_issue = 1 then true else false end
,cur_brethless_issue = case when t.cur_brethless_issue = 1 then true else false end
,high_risk_cnt = t.pre_preg_anemia + t.pre_preg_caesarean_section
	+ (case when t.pre_preg_aph = 1 or t.pre_preg_pph = 1 then 1 else 0 end)
	+ t.pre_preg_pre_eclampsia + t.pre_preg_abortion + t.pre_preg_obstructed_labour
	+ t.pre_preg_placenta_previa + t.pre_preg_malpresentation + t.pre_preg_birth_defect
	+ t.pre_preg_preterm_delivery + t.cur_severe_anemia + t.cur_low_weight + t.low_height
	+ (case when t.cur_blood_pressure_issue = 1 or t.cur_urine_protein_issue = 1 or t.cur_convulsion_issue = 1 then 1 else 0 end)
	+ t.cur_malaria_issue + t.cur_gestational_diabetes_issue + t.cur_twin_pregnancy + t.cur_mal_presentation_issue
	+ t.cur_absent_reduce_fetal_movment + t.cur_aph_issue + t.cur_pelvic_sepsis + t.cur_brethless_issue
	+ (case when t.cur_hiv_issue = 1 or t.cur_vdrl_issue = 1 or t.cur_hbsag_issue = 1 then 1 else 0 end)
from (
	select rch_anc_master.pregnancy_reg_det_id,
	max(
	case when
	danger_sign.dangerous_sign_id = (
	select id from listvalue_field_value_detail where value = ''Severe anemia''
	) or rch_anc_master.haemoglobin_count <= 7
	then 1 else 0 end
	) cur_severe_anemia,
	max(case when rch_anc_master.member_height < 140 then 1 else 0 end) low_height,
	max(case when rch_anc_master.systolic_bp >= 140 or rch_anc_master.diastolic_bp >= 90 then 1 else 0 end) as cur_blood_pressure_issue,
	max(case when rch_anc_master.weight <= 40 then 1 else 0 end) cur_low_weight,
	max(case when rch_anc_master.urine_albumin is not null and rch_anc_master.urine_albumin <> ''0'' then 1 else 0 end) urine_albumin,
	max(
	case when
	(urine_sugar is not null and urine_sugar != ''0'')
	or sugar_test_after_food_val >140
	or danger_sign.dangerous_sign_id = 769/*Urine sugar*/
	then 1 else 0 end
	) cur_gestational_diabetes_issue,
	max(
	case when
	rch_anc_master.foetal_movement in (''DECREASED'',''ABSENT'')
	or (rch_anc_master.foetal_position is not null and rch_anc_master.foetal_position not in(''VERTEX'',''CBMO''))
	or rch_anc_master.hiv_test = ''POSITIVE''
	or rch_anc_master.vdrl_test = ''POSITIVE''
	or rch_anc_master.hbsag_test = ''REACTIVE''
	or pre_compl.previous_pregnancy_complication in (
	''SEVANM''/*Anemia*/
	,''CAESARIAN''/*Caesarean Section*/
	,''APH'',''PPH''/*Ante partum Haemorrhage(APH)/Post partum Haemorrhage (PPH)*/
	,''CONVLS''/*Pre Eclampsia or Eclampsia*/
	,''P2ABO''/*Abortion*/
	,''OBSLBR''/*OBSLBR*/
	,''PLPRE''/*Placenta previa*/
	,''MLPRST''/*Malpresentation*/
	,''CONGDEF''/*Birth defect*/
	,''PRETRM''/*Preterm delivery*/
	) or danger_sign.dangerous_sign_id in (
	768/*urine protein*/
	,909/*convulsion*/
	,769/*Urine Sugar*/
	,912/*Twin*/
	,1024/*Malaria Fever*/
	,910/*APH*/
	,911/*Pelvic sepsis (vaginal discharge)(Foul smelling discharge)*/
	,915/*Breathlessness*/
	)
	then 1 else 0 end
	) as high_risk_mother,
	max(case when pre_compl.previous_pregnancy_complication = ''SEVANM'' then 1 else 0 end) as pre_preg_anemia,
	max(case when pre_compl.previous_pregnancy_complication = ''CAESARIAN'' then 1 else 0 end) as pre_preg_caesarean_section,
	--max(case when pre_compl.previous_pregnancy_complication = ''APH'' or pre_compl.previous_pregnancy_complication = ''PPH''  then 1 else 0 end) as prev_aph_pph,
	max(case when pre_compl.previous_pregnancy_complication = ''P2ABO''   then 1 else 0 end) as pre_preg_abortion,

	max(case when pre_compl.previous_pregnancy_complication = ''APH''   then 1 else 0 end) as pre_preg_aph,
	max(case when pre_compl.previous_pregnancy_complication = ''PPH''   then 1 else 0 end) as pre_preg_pph,
	max(case when pre_compl.previous_pregnancy_complication = ''CONVLS''   then 1 else 0 end) as pre_preg_pre_eclampsia,
	max(case when pre_compl.previous_pregnancy_complication = ''OBSLBR''   then 1 else 0 end) as pre_preg_obstructed_labour,
	max(case when pre_compl.previous_pregnancy_complication = ''PLPRE''   then 1 else 0 end) as pre_preg_placenta_previa,
	max(case when pre_compl.previous_pregnancy_complication = ''MLPRST''   then 1 else 0 end) as pre_preg_malpresentation,
	max(case when pre_compl.previous_pregnancy_complication = ''CONGDEF''   then 1 else 0 end) as pre_preg_birth_defect,
	max(case when pre_compl.previous_pregnancy_complication = ''PRETRM''   then 1 else 0 end) as pre_preg_preterm_delivery,

	max(case when danger_sign.dangerous_sign_id  = 768   then 1 else 0 end) as cur_urine_protein_issue,
	max(case when danger_sign.dangerous_sign_id  = 909   then 1 else 0 end) as cur_convulsion_issue,
	max(case when danger_sign.dangerous_sign_id  = 1024   then 1 else 0 end) as cur_malaria_issue,
	max(case when danger_sign.dangerous_sign_id  = 912   then 1 else 0 end) as cur_twin_pregnancy,
	max(case when (rch_anc_master.foetal_position is not null and  rch_anc_master.foetal_position not in(''VERTEX'',''CBMO'')) then 1 else 0 end) as cur_mal_presentation_issue,
	max(case when rch_anc_master.foetal_movement in (''DECREASED'',''ABSENT'')   then 1 else 0 end) as cur_absent_reduce_fetal_movment,
	max(case when danger_sign.dangerous_sign_id  = 910   then 1 else 0 end) as cur_aph_issue,
	max(case when danger_sign.dangerous_sign_id  = 911   then 1 else 0 end) as cur_pelvic_sepsis,
	max(case when rch_anc_master.hiv_test = ''POSITIVE'' then 1 else 0 end) as cur_hiv_issue,
	max(case when rch_anc_master.vdrl_test = ''POSITIVE'' then 1 else 0 end) as cur_vdrl_issue,
	max(case when rch_anc_master.hbsag_test = ''REACTIVE'' then 1 else 0 end) as cur_hbsag_issue,
	max(case when danger_sign.dangerous_sign_id  = 915   then 1 else 0 end) as cur_brethless_issue

	--count(DISTINCT danger_sign.dangerous_sign_id) as high_risk_cnt

	from rch_anc_master
	inner join t_pregnancy_registration_det
	on rch_anc_master.pregnancy_reg_det_id = t_pregnancy_registration_det.pregnancy_reg_id
	left join rch_anc_dangerous_sign_rel as danger_sign on danger_sign.anc_id = rch_anc_master.id
	left join rch_anc_previous_pregnancy_complication_rel as pre_compl on pre_compl.anc_id = rch_anc_master.id
	where rch_anc_master.member_status = ''AVAILABLE''
	group by rch_anc_master.pregnancy_reg_det_id
) as t
where t.pregnancy_reg_det_id = t_pregnancy_registration_det.pregnancy_reg_id;

update timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED4''
where event_config_id = 39 and status = ''PROCESSED3'';
commit;

---  add high risk reason string
begin;
	update t_pregnancy_registration_det
	set
	high_risk_reasons = t.high_risk_reasons
	from (
		select
		pregnancy_reg_id
		,concat_ws ('','',
		case when r.pre_preg_anemia = true then ''Anaemia'' else null end,
		case when r.pre_preg_caesarean_section = true then ''Caesarean Section'' else null end,
		case when r.pre_preg_aph = true then ''prev preg Ante partum Haemorrhage(APH)'' else null end,
		case when r.pre_preg_pph = true then ''prev preg Post partum Haemorrhage (PPH)'' else null end,
		case when r.pre_preg_pre_eclampsia = true then ''Pre Eclampsia/Eclampsia'' else null end,
		case when r.pre_preg_abortion = true then ''Abortion'' else null end,
		case when r.pre_preg_obstructed_labour = true then ''Obstructed labour'' else null end,
		case when r.pre_preg_placenta_previa = true then ''Placenta previa'' else null end,
		case when r.pre_preg_malpresentation = true then ''Malpresentation'' else null end,
		case when r.pre_preg_birth_defect = true then ''Birth defect'' else null end,
		case when r.pre_preg_preterm_delivery = true then ''Preterm delivery'' else null end,
		case when r.chro_tb = true then ''Tuberculosis'' else null end,
		case when r.chro_diabetes = true then ''Diabetes Mellitus'' else null end,
		case when r.chro_heart_kidney = true then ''Heart/Kidney Diseases'' else null end,
		case when r.chro_hiv = true then ''pre existing chronic HIV'' else null end,
		case when r.chro_sickle = true then ''Sickle cell Anemia'' else null end,
		case when r.chro_thalessemia = true then ''Thalessemia'' else null end,
		case when r.cur_extreme_age = true then ''Extreme age(less than 18 and more than 35 years)'' else null end,
		case when r.cur_low_weight = true then ''Weight (less than 45 kg)'' else null end,
		case when r.cur_severe_anemia = true then ''present pregnency anemia'' else null end,
		case when r.cur_blood_pressure_issue = true then ''Blood Pressure (More than 140/90)'' else null end,
		case when r.cur_urine_protein_issue = true then ''oedema or urine protein or headache with blurred vision'' else null end,
		case when r.cur_convulsion_issue = true then ''convulsion'' else null end,
		case when r.cur_malaria_issue = true then ''Malaria'' else null end,
		case when r.cur_social_vulnerability = true then ''Severe social vulnerability'' else null end,
		case when r.cur_gestational_diabetes_issue = true then ''Gestational diabetes mellitus'' else null end,
		case when r.cur_twin_pregnancy = true then ''Twin Pregnancy'' else null end,
		case when r.cur_mal_presentation_issue = true then ''Mal presentation'' else null end,
		case when r.cur_absent_reduce_fetal_movment = true then ''Absent or reduced fetal movement'' else null end,
		case when r.cur_less_than_18_month_interval = true then ''Interval between two pregnancy (less than 18 Months)'' else null end,
		case when r.cur_aph_issue = true then ''present pregnency Antepartum haemorrhage'' else null end,
		case when r.cur_pelvic_sepsis = true then ''Pelvic sepsis (vaginal discharge)'' else null end,
		case when r.cur_hiv_issue = true then ''present pregnency HIV'' else null end,
		case when r.cur_vdrl_issue = true then ''present pregnency VDRL'' else null end,
		case when r.cur_hbsag_issue = true then ''present pregnency HBsAg'' else null end,
		case when r.cur_brethless_issue = true then ''Breathlessness'' else null end
		) as high_risk_reasons
		from
		t_pregnancy_registration_det r
		where r.high_risk_mother = true
	 ) as t
	where t_pregnancy_registration_det.pregnancy_reg_id = t.pregnancy_reg_id;

commit;


---



---5
begin;
update t_pregnancy_registration_det
set tt1_given = t.tt1_given
,tt2_given = t.tt2_given
,tt_boster = t.tt_boster
,tt2_tt_booster_given = case when t.tt_boster is not null then t.tt_boster else t.tt2_given end
,tt1_location_id = t.tt1_location_id
,tt2_location_id = t.tt2_location_id
,tt_booster_location_id = t.tt_booster_location_id
,tt2_tt_booster_location_id = case when t.tt_booster_location_id is not null then t.tt_booster_location_id else t.tt2_location_id end
from (
	select t1.pregnancy_reg_det_id,t1.tt1_given,t1.tt2_given,t1.tt_boster
	,tt1_immunization_det.location_id as tt1_location_id
	,tt2_immunization_det.location_id as tt2_location_id
	,tt_booster_immunization_det.location_id as tt_booster_location_id
	from (
	select rch_immunisation_master.pregnancy_reg_det_id,
	max(case when rch_immunisation_master.immunisation_given = ''TT1'' then given_on else null end) as tt1_given,
	max(case when rch_immunisation_master.immunisation_given = ''TT1'' then rch_immunisation_master.id else null end) as tt1_id,
	max(case when rch_immunisation_master.immunisation_given = ''TT2'' then given_on else null end) as tt2_given,
	max(case when rch_immunisation_master.immunisation_given = ''TT2'' then rch_immunisation_master.id else null end) as tt2_id,
	max(case when rch_immunisation_master.immunisation_given = ''TT_BOOSTER'' then given_on else null end) as tt_boster,
	max(case when rch_immunisation_master.immunisation_given = ''TT_BOOSTER'' then rch_immunisation_master.id else null end) as tt_boster_id
	from rch_immunisation_master
	inner join t_pregnancy_registration_det
	on rch_immunisation_master.pregnancy_reg_det_id = t_pregnancy_registration_det.pregnancy_reg_id
	group by rch_immunisation_master.pregnancy_reg_det_id
	) as t1
	left join rch_immunisation_master tt1_immunization_det on tt1_immunization_det.id = tt1_id
	left join rch_immunisation_master tt2_immunization_det on tt2_immunization_det.id = tt2_id
	left join rch_immunisation_master tt_booster_immunization_det on tt_booster_immunization_det.id = tt_boster_id
) as t
where t.pregnancy_reg_det_id = t_pregnancy_registration_det.pregnancy_reg_id;

update timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED5''
where event_config_id = 39 and status = ''PROCESSED4'';
commit;
---6
begin;
update t_pregnancy_registration_det
set registered_with_no_of_child = t.registered_with_no_of_child
,registered_with_male_cnt = t.registered_with_male_cnt
,registered_with_female_cnt = t.registered_with_female_cnt
,prev_preg_diff_in_month = EXTRACT(year FROM age(t_pregnancy_registration_det.lmp_date,t.last_delivery_date))*12 + EXTRACT(month FROM age(t_pregnancy_registration_det.lmp_date,t.last_delivery_date))
from (
	select t_pregnancy_registration_det.pregnancy_reg_id,
	sum(case when imt_member.death_detail_id is null or rch_member_death_deatil.dod > t_pregnancy_registration_det.lmp_date then 1 else 0 end) as registered_with_no_of_child,
	sum(
	case when (imt_member.death_detail_id is null or rch_member_death_deatil.dod > t_pregnancy_registration_det.lmp_date)
	and imt_member.gender = ''M'' then 1 else 0 end
	) as registered_with_male_cnt,
	sum(
	case when (imt_member.death_detail_id is null or rch_member_death_deatil.dod > t_pregnancy_registration_det.lmp_date)
	and imt_member.gender = ''F'' then 1 else 0 end
	) as registered_with_female_cnt,
	max(imt_member.dob) as last_delivery_date
	from imt_member
	inner join t_pregnancy_registration_det
	on imt_member.mother_id = t_pregnancy_registration_det.member_id
	and imt_member.dob < t_pregnancy_registration_det.lmp_date
	left join rch_member_death_deatil on imt_member.death_detail_id = rch_member_death_deatil.id
	group by t_pregnancy_registration_det.pregnancy_reg_id
) as t
where t.pregnancy_reg_id = t_pregnancy_registration_det.pregnancy_reg_id;

update timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED6''
where event_config_id = 39 and status = ''PROCESSED5'';
commit;

---7
---------------------------------------------delivery related-------------------------------------------------------------------------------------------------------
begin;
update t_pregnancy_registration_det
set date_of_delivery_month_year = t.date_of_delivery_month_year
,date_of_delivery = t.date_of_delivery
,delivery_reg_date = t.delivery_reg_date
,delivery_reg_date_financial_year = case when t.delivery_reg_date is not null and extract(month from t.delivery_reg_date) > 3
	then concat(extract(year from t.delivery_reg_date), ''-'', extract(year from t.delivery_reg_date) + 1)
	when t.delivery_reg_date is not null then concat(extract(year from t.delivery_reg_date) - 1, ''-'', extract(year from t.delivery_reg_date)) end
,delivery_location_id = t.delivery_location_id
,delivery_family_id = t.delivery_family_id
,delivery_hospital = t.delivery_hospital
,delivery_health_infrastructure = t.delivery_health_infrastructure
,delivery_outcome = t.delivery_outcome
,type_of_delivery = t.type_of_delivery
,delivery_done_by = t.delivery_done_by
,delivery_place = t.delivery_place
,home_del = case when t.home_del = 1 then true else false end
,institutional_del = case when t.institutional_del = 1 then true else false end
,delivery_108 = case when t.delivery_108 = 1 then true else false end
,delivery_out_of_state_govt = case when t.delivery_out_of_state_govt = 1 then true else false end
,delivery_out_of_state_pvt = case when t.delivery_out_of_state_pvt = 1 then true else false end
,breast_feeding_in_one_hour = case when t.breast_feeding_in_one_hour = 1 then true else false end
,del_week = t.del_week
,is_cortico_steroid = case when t.is_cortico_steroid = 1 then true else false end
,mother_alive = case when t.mother_alive = 1 then true else false end
,total_out_come = t.total_out_come
,male = t.male
,female = t.female
,still_birth = t.still_birth
,live_birth = t.live_birth
,ppiucd_insert_date = t.ppiucd_insert_date
,ppiucd_insert_location = t.ppiucd_insert_location
,is_fru = (case when t.is_fru = 1 then true else false end)
from(
	select t_pregnancy_registration_det.pregnancy_reg_id,
	max(cast(date_trunc(''month'', rwmm.date_of_delivery) as date)) as date_of_delivery_month_year,
	max(rwmm.date_of_delivery) as date_of_delivery,
	max(rwmm.date_of_delivery) as delivery_reg_date,
	max(rwmm.location_id) as delivery_location_id,
	max(rwmm.family_id) as delivery_family_id,
	max(rwmm.type_of_hospital) as delivery_hospital,
	max(rwmm.health_infrastructure_id) as delivery_health_infrastructure,
	max(rwmm.pregnancy_outcome) as delivery_outcome,
	max(rwmm.type_of_delivery) as type_of_delivery,
	max(rwmm.delivery_done_by) as delivery_done_by,
	max(case when rwmm.delivery_place in (''HOME'',''ON_THE_WAY'') then 1 else 0 end) as home_del,
	max(case when rwmm.delivery_place = ''HOSP'' then 1 else 0 end) as institutional_del,
	max(case when rwmm.delivery_place = ''108_AMBULANCE'' then 1 else 0 end) as delivery_108,
    max(case when rwmm.delivery_place = ''OUT_OF_STATE_GOVT'' then 1 else 0 end) as delivery_out_of_state_govt,
    max(case when rwmm.delivery_place = ''OUT_OF_STATE_PVT'' then 1 else 0 end) as delivery_out_of_state_pvt,
	max(rwmm.delivery_place) as delivery_place,
	max(case when rwmm.breast_feeding_in_one_hour = true or rwmm.breast_feeding_in_one_hour then 1 else 0 end) as breast_feeding_in_one_hour,
	max(TRUNC(DATE_PART(''day'', rwmm.date_of_delivery- cast(t_pregnancy_registration_det.lmp_date as timestamp))/7)) as del_week,
	max(case when rwmm.cortico_steroid_given = true then 1 else 0 end) as is_cortico_steroid,
	max(case when rwmm.mother_alive = false then 0 else 1 end) as mother_alive,
	sum(case when rwcm.pregnancy_outcome = ''LBIRTH'' then 1 else 0 end) as total_out_come,
	sum(case when rwcm.pregnancy_outcome = ''LBIRTH'' and rwcm.gender = ''M''  then 1 else 0 end) as male,
	sum(case when rwcm.pregnancy_outcome = ''LBIRTH'' and rwcm.gender = ''F''  then 1 else 0 end) as female,
	sum(case when rwcm.pregnancy_outcome = ''SBIRTH'' then 1 else 0 end) as still_birth,
	sum(case when rwcm.pregnancy_outcome = ''LBIRTH'' then 1 else 0 end) as live_birth,
	max(case when rwmm.family_planning_method = ''PPIUCD'' then rwmm.date_of_delivery end) as ppiucd_insert_date,
	max(case when rwmm.family_planning_method = ''PPIUCD'' then rwmm.location_id end) as ppiucd_insert_location,
	max(case when hid.is_fru then 1 else 0 end) as is_fru
	from t_pregnancy_registration_det
	inner join rch_wpd_mother_master rwmm on t_pregnancy_registration_det.pregnancy_reg_id = rwmm.pregnancy_reg_det_id
	left join rch_wpd_child_master rwcm on rwmm.id = rwcm.wpd_mother_id
	left join health_infrastructure_details hid on hid.id = rwmm.health_infrastructure_id
	where rwmm.member_status in (''AVAILABLE'',''DEATH'') and (rwmm.state is null or rwmm.state != ''MARK_AS_FALSE_DELIVERY'')
	group by t_pregnancy_registration_det.pregnancy_reg_id
) as t
where t.pregnancy_reg_id = t_pregnancy_registration_det.pregnancy_reg_id;

update timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED7''
where event_config_id = 39 and status = ''PROCESSED6'';
commit;

---8
begin;
update t_pregnancy_registration_det
set prev_preg_diff_in_month = case when
	prev_preg_diff_in_month < (
	EXTRACT(year FROM age(t_pregnancy_registration_det.lmp_date,t.last_delivery_date))*12
	+ EXTRACT(month FROM age(t_pregnancy_registration_det.lmp_date,t.last_delivery_date))
	)
	then prev_preg_diff_in_month
	else (
	EXTRACT(year FROM age(t_pregnancy_registration_det.lmp_date,t.last_delivery_date))*12
	+ EXTRACT(month FROM age(t_pregnancy_registration_det.lmp_date,t.last_delivery_date))
	) end
from (
	select t_pregnancy_registration_det.pregnancy_reg_id,
	max(rch_wpd_mother_master.date_of_delivery) as last_delivery_date
	from t_pregnancy_registration_det INNER join
	rch_wpd_mother_master on t_pregnancy_registration_det.member_id = rch_wpd_mother_master.member_id
	and rch_wpd_mother_master.date_of_delivery < t_pregnancy_registration_det.lmp_date
	group by t_pregnancy_registration_det.pregnancy_reg_id
) as t
where t.pregnancy_reg_id = t_pregnancy_registration_det.pregnancy_reg_id;

update timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED8''
where event_config_id = 39 and status = ''PROCESSED7'';
commit;

---9
begin;
update t_pregnancy_registration_det
set cur_extreme_age = case when t.cur_extreme_age = 1 then true else false end
,chro_tb = case when t.chro_tb = 1 then true else false end
,chro_diabetes = case when t.chro_diabetes = 1 then true else false end
,chro_heart_kidney = case when t.chro_heart_kidney = 1 then true else false end
,chro_hiv = case when t.chro_hiv = 1 then true else false end
,chro_sickle = case when t.chro_sickle = 1 then true else false end
,chro_thalessemia = case when t.chro_thalessemia = 1 then true else false end
,member_current_location_id = t.member_current_location_id
,tracking_location_id = t.member_current_location_id
,age_during_delivery = t.age_during_delivery
,any_chronic_dis = case when t.any_chronic_dis = 1 then true else false end
,cur_social_vulnerability = case when t.cur_social_vulnerability = 1 then true else false end
,maternal_detah = case when t.maternal_detah = 1 then true else false end
,maternal_death_type = t.maternal_death_type
,death_date = t.death_date
,death_location_id = t.death_location_id
from (
	select t_pregnancy_registration_det.pregnancy_reg_id,
	max (case when extract(years from age(t_pregnancy_registration_det.lmp_date,mem.dob)) < 18 or extract(years from age(t_pregnancy_registration_det.lmp_date,mem.dob)) > 35 then 1 else 0 end) cur_extreme_age,
	max(extract(years from age(t_pregnancy_registration_det.lmp_date,mem.dob))) as age_during_delivery,
	max(case when chronic.chronic_disease_id = ''715'' then 1 else 0 end) as chro_tb,
	max(case when chronic.chronic_disease_id = ''726'' then 1 else 0 end) as chro_diabetes,
	max(case when chronic.chronic_disease_id = ''713'' then 1 else 0 end) as chro_heart_kidney,
	max(case when chronic.chronic_disease_id = ''735'' then 1 else 0 end) as chro_hiv,
	max(case when chronic.chronic_disease_id = ''729'' then 1 else 0 end) as chro_sickle,
	max(case when chronic.chronic_disease_id = ''730'' then 1 else 0 end) as chro_thalessemia,
	max(case when fam.area_id is null then fam.location_id else cast(fam.area_id as bigint) end) as member_current_location_id,
	max(case when chronic.chronic_disease_id is not null then 1 else 0 end) as any_chronic_dis,
	max(case when fam.vulnerable_flag = true then 1 else 0 end) as cur_social_vulnerability,
	max(
	case when
	mem.basic_state = ''DEAD''
	and (
	t_pregnancy_registration_det.date_of_delivery is null
	or (
	rch_member_death_deatil.id is not null
	and (cast(rch_member_death_deatil.dod as date) - cast(t_pregnancy_registration_det.date_of_delivery as date) between  0 and 42)
	)
	) then 1 else 0 end
	) as maternal_detah,
	max(
		case when
			mem.basic_state = ''DEAD''
			and
			t_pregnancy_registration_det.date_of_delivery is null
			then ''PRE-PARTUM''
		when
			mem.basic_state = ''DEAD''
			and (
			rch_member_death_deatil.id is not null
			and (cast(rch_member_death_deatil.dod as date) - cast(t_pregnancy_registration_det.date_of_delivery as date) =  0 )
			) then ''INTRA-PARTUM''
		when
			mem.basic_state = ''DEAD''
			and (
			rch_member_death_deatil.id is not null
			and (cast(rch_member_death_deatil.dod as date) - cast(t_pregnancy_registration_det.date_of_delivery as date) between  0 and 42)
			) then ''POST-PARTUM''
		else
			null end
	) as maternal_death_type,
	max(rch_member_death_deatil.dod) as death_date,
	max(rch_member_death_deatil.location_id) as death_location_id
	from t_pregnancy_registration_det
	inner join imt_member mem on t_pregnancy_registration_det.member_id = mem.id
	inner join imt_family fam on mem.family_id= fam.family_id
	left join  imt_member_chronic_disease_rel chronic on mem.id = chronic.member_id
	left join rch_member_death_deatil on rch_member_death_deatil.id = mem.death_detail_id
	group by t_pregnancy_registration_det.pregnancy_reg_id
) as t
where t.pregnancy_reg_id = t_pregnancy_registration_det.pregnancy_reg_id;


update timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED9''
where event_config_id = 39 and status = ''PROCESSED8'';
commit;


---10
begin;
update t_pregnancy_registration_det
set
pnc1 = (case when t.pnc1 is not null then t.pnc1 end)
, pnc1_location_id = (case when t.pnc1 is not null then t.pnc1_location_id end)
, pnc2 = (case when t.pnc2 is not null then t.pnc2 end)
, pnc2_location_id = (case when t.pnc2 is not null then t.pnc2_location_id end)
, pnc3 = (case when t.pnc3 is not null then t.pnc3 end)
, pnc3_location_id = (case when t.pnc3 is not null then t.pnc3_location_id end)
, pnc4 = (case when t.pnc4 is not null then t.pnc4 end)
, pnc4_location_id = (case when t.pnc4 is not null then t.pnc4_location_id end)
, pnc5 = (case when t.pnc5 is not null then t.pnc5 end)
, pnc5_location_id = (case when t.pnc5 is not null then t.pnc5_location_id end)
, pnc6 = (case when t.pnc6 is not null then t.pnc6 end)
, pnc6_location_id = (case when t.pnc6 is not null then t.pnc6_location_id end)
, pnc7 = (case when t.pnc6 is not null then t.pnc7 end)
, pnc7_location_id = (case when t.pnc7 is not null then t.pnc7_location_id end)
, ifa_tab_after_delivery = t.ifa_tab_after_delivery
, ppiucd_insert_date = case when t.ppiucd_insert_date is not null then t.ppiucd_insert_date else t_pregnancy_registration_det.ppiucd_insert_date end
, ppiucd_insert_location = case when t.ppiucd_insert_date is not null then t.ppiucd_insert_location else t_pregnancy_registration_det.ppiucd_insert_location end
from (
select t1.pregnancy_reg_id
	,case when t_pregnancy_registration_det.delivery_place in (''HOME'',''HOSP'',''108_AMBULANCE'')
		then t_pregnancy_registration_det.date_of_delivery else t1.pnc1 end as pnc1
	,t1.pnc2,t1.pnc3,t1.pnc4,t1.pnc5,t1.pnc6, t1.pnc7
	,case when t_pregnancy_registration_det.delivery_place in (''HOME'',''HOSP'',''108_AMBULANCE'')
		then t_pregnancy_registration_det.delivery_location_id else pnc1_master.location_id end as pnc1_location_id
	,pnc2_master.location_id as pnc2_location_id
	,pnc3_master.location_id as pnc3_location_id
	,pnc4_master.location_id as pnc4_location_id
    ,pnc5_master.location_id as pnc5_location_id
    ,pnc6_master.location_id as pnc6_location_id
	,pnc7_master.location_id as pnc7_location_id
	,t1.ifa_tab_after_delivery
	,t1.ppiucd_insert_date
	,t1.ppiucd_insert_location
	from (
	select t_pregnancy_registration_det.pregnancy_reg_id,
	min(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 0 and 2 then rpm.service_date else null end) as pnc1,
	min(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 0 and 2 then rpm.id else null end) as pnc1_id,

	min(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 3 and 6 then rpm.service_date else null end) as pnc2,
	min(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 3 and 6 then rpm.id else null end) as pnc2_id,

	min(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 7 and 13 then rpm.service_date else null end) as pnc3,
	min(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 7 and 13 then rpm.id else null end) as pnc3_id,

	min(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 14 and 21 then rpm.service_date else null end) as pnc4,
	min(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 14 and 21 then rpm.id else null end) as pnc4_id,

    min(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 22 and 31 then rpm.service_date else null end) as pnc5,
	min(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 22 and 31 then rpm.id else null end) as pnc5_id,

    min(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 32 and 42 then rpm.service_date else null end) as pnc6,
	min(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 32 and 42 then rpm.id else null end) as pnc6_id,

	min(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 43 and 60 then rpm.service_date else null end) as pnc7,
	min(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 43 and 60 then rpm.id else null end) as pnc7_id,


	sum(rpmm.ifa_tablets_given) as ifa_tab_after_delivery,

	max(case when family_planning_method = ''PPIUCD'' then cast(rpmm.fp_insert_operate_date as date) end) as ppiucd_insert_date,
	max(case when family_planning_method = ''PPIUCD'' then rpm.location_id end) as ppiucd_insert_location

	from t_pregnancy_registration_det
	inner join rch_pnc_master rpm on t_pregnancy_registration_det.pregnancy_reg_id = rpm.pregnancy_reg_det_id
	left join rch_pnc_mother_master rpmm on rpmm.pnc_master_id = rpm.id
	where rpm.member_status = ''AVAILABLE''
	group by t_pregnancy_registration_det.pregnancy_reg_id) as t1
	inner join t_pregnancy_registration_det on t_pregnancy_registration_det.pregnancy_reg_id = t1.pregnancy_reg_id
	left join rch_pnc_master pnc1_master on pnc1_master.id = pnc1_id
	left join rch_pnc_master pnc2_master on pnc2_master.id = pnc2_id
	left join rch_pnc_master pnc3_master on pnc3_master.id = pnc3_id
	left join rch_pnc_master pnc4_master on pnc4_master.id = pnc4_id
    left join rch_pnc_master pnc5_master on pnc5_master.id = pnc5_id
    left join rch_pnc_master pnc6_master on pnc6_master.id = pnc6_id
	left join rch_pnc_master pnc7_master on pnc7_master.id = pnc7_id
) as t
where t.pregnancy_reg_id = t_pregnancy_registration_det.pregnancy_reg_id;

update timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED10''
where event_config_id = 39 and status = ''PROCESSED9'';
commit;

---11
---------------------Updating Data to Main Table-------------------------------------------------------------------------------------------------------------
begin;
/*DROP TABLE IF EXISTS rch_pregnancy_analytics_details_t;
CREATE TABLE rch_pregnancy_analytics_details_t (
  pregnancy_reg_id bigint NOT NULL,
  member_id bigint,
  dob date,
  family_id text,
  member_name text,
  mobile_number text,
  reg_service_date date,
  reg_service_date_month_year date,
  reg_service_financial_year text,
  reg_server_date timestamp without time zone,
  pregnancy_reg_location_id bigint,
  native_location_id integer,
  pregnancy_reg_family_id bigint,
  lmp_date date,
  edd date,
  preg_reg_state text,
  member_basic_state text,
  lmp_month_year date,
  lmp_financial_year text,
  date_of_delivery date,
  date_of_delivery_month_year date,
  delivery_location_id bigint,
  delivery_family_id bigint,
  delivery_reg_date date,
  delivery_reg_date_financial_year text,
  member_current_location_id bigint,
  age_during_delivery smallint,
  registered_with_no_of_child smallint,
  registered_with_male_cnt smallint,
  registered_with_female_cnt smallint,
  anc1 date,
  anc1_location_id integer,
  anc2 date,
  anc2_location_id integer,
  anc3 date,
  anc3_location_id integer,
  anc4 date,
  anc4_location_id integer,
  total_regular_anc smallint,
  tt1_given date,
  tt1_location_id integer,
  tt2_given date,
  tt2_location_id integer,
  tt_boster date,
  tt_booster_location_id integer,
  tt2_tt_booster_given date,
  tt2_tt_booster_location_id integer,
  early_anc boolean,
  total_anc smallint,
  ifa integer,
  fa_tab_in_30_day integer,
  fa_tab_in_31_to_60_day integer,
  fa_tab_in_61_to_90_day integer,
  ifa_tab_in_4_month_to_9_month integer,
  hb_between_90_to_360_days integer,
  hb real,
  total_ca integer,
  ca_tab_in_91_to_180_day integer,
  ca_tab_in_181_to_360_day integer,
  expected_delivery_place text,

  L2L_Preg_Complication text,
  Outcome_L2L_Preg text,
  L2L_Preg_Complication_Length smallint,
  Outcome_Last_Preg integer,

  alben_given boolean,
  maternal_detah boolean,
  maternal_death_type text,
  death_date date,
  death_location_id integer,
  low_height boolean,
  urine_albumin boolean,
  systolic_bp smallint,
  diastolic_bp smallint,
  prev_pregnancy_date date,
  prev_preg_diff_in_month smallint,
  gravida smallint,
  jsy_beneficiary boolean,
  jsy_payment_date date,
  any_chronic_dis boolean,
  aadhar_and_bank boolean,
  aadhar_reg boolean,
  aadhar_with_no_bank boolean,
  bank_with_no_aadhar boolean,
  no_aadhar_and_bank boolean,
  high_risk_mother boolean,
  pre_preg_anemia boolean,
  pre_preg_caesarean_section boolean,
  pre_preg_aph boolean,
  pre_preg_pph boolean,
  pre_preg_pre_eclampsia boolean,
  pre_preg_abortion boolean,
  pre_preg_obstructed_labour boolean,
  pre_preg_placenta_previa boolean,
  pre_preg_malpresentation boolean,
  pre_preg_birth_defect boolean,
  pre_preg_preterm_delivery boolean,
  any_prev_preg_complication boolean,
  chro_tb boolean,
  chro_diabetes boolean,
  chro_heart_kidney boolean,
  chro_hiv boolean,
  chro_sickle boolean,
  chro_thalessemia boolean,
  cur_extreme_age boolean,
  cur_low_weight boolean,
  cur_severe_anemia boolean,
  cur_blood_pressure_issue boolean,
  cur_urine_protein_issue boolean,
  cur_convulsion_issue boolean,
  cur_malaria_issue boolean,
  cur_social_vulnerability boolean,
  cur_gestational_diabetes_issue boolean,
  cur_twin_pregnancy boolean,
  cur_mal_presentation_issue boolean,
  cur_absent_reduce_fetal_movment boolean,
  cur_less_than_18_month_interval boolean,
  cur_aph_issue boolean,
  cur_pelvic_sepsis boolean,
  cur_hiv_issue boolean,
  cur_vdrl_issue boolean,
  cur_hbsag_issue boolean,
  cur_brethless_issue boolean,
  any_cur_preg_complication boolean,
  high_risk_cnt smallint,
  hbsag_test_cnt smallint,
  hbsag_reactive_cnt smallint,
  hbsag_non_reactive_cnt smallint,
  delivery_outcome text,
  type_of_delivery text,
  delivery_place text,
  home_del boolean,
  institutional_del boolean,
  delivery_108 boolean,
  breast_feeding_in_one_hour boolean,
  delivery_hospital text,
  del_week smallint,
  is_cortico_steroid boolean,
  mother_alive boolean,
  total_out_come smallint,
  male smallint,
  female smallint,
  delivery_done_by text,
  pnc1 date,
  pnc1_location_id integer,
  pnc2 date,
  pnc2_location_id integer,
  pnc3 date,
  pnc3_location_id integer,
  pnc4 date,
  pnc4_location_id integer,
  haemoglobin_tested_count integer,
  iron_def_anemia_inj text,
  blood_transfusion boolean,
  ppiucd_insert_date date,
  PRIMARY KEY (pregnancy_reg_id)
);
*/

delete from rch_pregnancy_analytics_details where (select cast(key_value as boolean) as value
from system_configuration where system_key = ''rch_pregnancy_analytics_run_for_all_pregnancy'') = true;

insert into rch_pregnancy_analytics_details(
	pregnancy_reg_id
)
select t_pregnancy_registration_det.pregnancy_reg_id
from t_pregnancy_registration_det
left join rch_pregnancy_analytics_details on t_pregnancy_registration_det.pregnancy_reg_id = rch_pregnancy_analytics_details.pregnancy_reg_id
where rch_pregnancy_analytics_details.pregnancy_reg_id is null;

update timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED11''
where event_config_id = 39 and status = ''PROCESSED10'';
commit;



---12
begin;
update rch_pregnancy_analytics_details
set
	member_id = t.member_id,
	dob = t.dob,
	family_id = t.family_id,
	unique_health_id = t.unique_health_id,
	member_name = t.member_name,
	mobile_number = t.mobile_number,
	member_basic_state = t.member_basic_state,
	preg_reg_state = t.preg_reg_state,
	reg_service_date =t.reg_service_date,
	reg_service_date_month_year =t.reg_service_date_month_year,
	reg_service_financial_year = t.reg_service_financial_year,
	reg_server_date =t.reg_server_date,
	pregnancy_reg_location_id = t.pregnancy_reg_location_id,
	native_location_id = t.native_location_id,
	pregnancy_reg_family_id = t.pregnancy_reg_family_id,
	lmp_date = t.lmp_date,
	edd=t.edd,
	lmp_month_year = t.lmp_month_year,
	lmp_financial_year = t.lmp_financial_year,
	date_of_delivery = t.date_of_delivery,
	date_of_delivery_month_year = t.date_of_delivery_month_year,
	delivery_location_id =t.delivery_location_id,
	delivery_family_id =t.delivery_family_id,
	delivery_reg_date = t.delivery_reg_date,
	delivery_reg_date_financial_year = t.delivery_reg_date_financial_year,

	member_current_location_id = t.member_current_location_id,
	age_during_delivery = t.age_during_delivery,
	registered_with_no_of_child = t.registered_with_no_of_child,
	registered_with_male_cnt = t.registered_with_male_cnt,
	registered_with_female_cnt = t.registered_with_female_cnt,
	anc1 =t.anc1,
	anc1_location_id = t.anc1_location_id,
	anc2 =t.anc2,
	anc2_location_id = t.anc2_location_id,
	anc3 =t.anc3,
	anc3_location_id = t.anc3_location_id,
	anc4 =t.anc4,
	anc4_location_id = t.anc4_location_id,
	last_systolic_bp = t.last_systolic_bp,
	last_diastolic_bp = t.last_diastolic_bp,
	tt1_given =t.tt1_given,
	tt1_location_id = t.tt1_location_id,
	tt2_given =t.tt2_given,
	tt2_location_id = t.tt2_location_id,
	tt_boster =t.tt_boster,
	tt_booster_location_id = t.tt_booster_location_id,
	tt2_tt_booster_given = t.tt2_tt_booster_given,
	tt2_tt_booster_location_id = t.tt2_tt_booster_location_id,
	early_anc =t.early_anc,
	ifa =t.ifa,
	ifa_180_anc_date = t.ifa_180_anc_date,
	ifa_180_anc_location = t.ifa_180_anc_location,
	fa_tab_in_30_day = t.fa_tab_in_30_day,
	fa_tab_in_31_to_60_day = t.fa_tab_in_31_to_60_day,
	fa_tab_in_61_to_90_day = t.fa_tab_in_61_to_90_day,
	ifa_tab_in_4_month_to_9_month = t.ifa_tab_in_4_month_to_9_month,
	hb =t.hb,
	hb_date = t.hb_date,
	hb_between_90_to_360_days = t.hb_between_90_to_360_days,
	total_ca = t.total_ca,
	ca_tab_in_91_to_180_day = t.ca_tab_in_91_to_180_day,
	ca_tab_in_181_to_360_day = t.ca_tab_in_181_to_360_day,
	expected_delivery_place = t.expected_delivery_place,

	L2L_Preg_Complication = t.L2L_Preg_Complication,
	Outcome_L2L_Preg = t.Outcome_L2L_Preg,
	L2L_Preg_Complication_Length = t.L2L_Preg_Complication_Length,

	alben_given =t.alben_given,
	cur_severe_anemia =t.cur_severe_anemia,
	cur_extreme_age =t.cur_extreme_age,
	low_height =t.low_height,
	cur_urine_protein_issue = t.cur_urine_protein_issue,
	cur_convulsion_issue = t.cur_convulsion_issue,
	cur_malaria_issue = t.cur_malaria_issue,
	cur_social_vulnerability = t.cur_social_vulnerability,
	cur_gestational_diabetes_issue = t.cur_gestational_diabetes_issue,
	cur_twin_pregnancy = t.cur_twin_pregnancy,
	cur_mal_presentation_issue = t.cur_mal_presentation_issue,
	cur_absent_reduce_fetal_movment = t.cur_absent_reduce_fetal_movment,
	cur_less_than_18_month_interval = case when t.prev_preg_diff_in_month <= 18 then true else false end,
	cur_aph_issue = t.cur_aph_issue,
	cur_pelvic_sepsis = t.cur_pelvic_sepsis,
	cur_hiv_issue = t.cur_hiv_issue,
	cur_vdrl_issue = t.cur_vdrl_issue,
	cur_hbsag_issue = t.cur_hbsag_issue,
	cur_brethless_issue = t.cur_brethless_issue,
	cur_low_weight =t.cur_low_weight,
	maternal_detah = t.maternal_detah,
	maternal_death_type = t.maternal_death_type,
	death_date = t.death_date,
	death_location_id = t.death_location_id,
	any_cur_preg_complication = case when t.cur_extreme_age or t.cur_low_weight or t.cur_severe_anemia or t.low_height
	or t.cur_blood_pressure_issue or t.cur_urine_protein_issue or t.cur_malaria_issue
	or t.cur_social_vulnerability or t.cur_gestational_diabetes_issue or t.cur_twin_pregnancy
	or t.cur_mal_presentation_issue or t.cur_absent_reduce_fetal_movment or t.prev_preg_diff_in_month <= 18
	or t.cur_aph_issue or t.cur_pelvic_sepsis or t.cur_hiv_issue or t.cur_vdrl_issue or t.cur_hbsag_issue
	or t.cur_brethless_issue then true else false end,
	urine_albumin =t.urine_albumin,
	cur_blood_pressure_issue =t.cur_blood_pressure_issue,
	systolic_bp =t.systolic_bp,
	diastolic_bp =t.diastolic_bp,
	any_prev_preg_complication = case when t.pre_preg_anemia or t.pre_preg_caesarean_section or t.pre_preg_aph
	or t.pre_preg_pph or t.pre_preg_pre_eclampsia or t.pre_preg_abortion or t.pre_preg_obstructed_labour
	or t.pre_preg_placenta_previa or t.pre_preg_malpresentation or t.pre_preg_birth_defect
	or t.pre_preg_preterm_delivery or t.total_out_come >= 3 then true else false end,
	prev_pregnancy_date =t.prev_pregnancy_date,
	prev_preg_diff_in_month =t.prev_preg_diff_in_month,
	gravida =t.registered_with_no_of_child,
	any_chronic_dis = case when t.chro_diabetes = true or t.chro_heart_kidney = true
	or t.chro_hiv = true or t.chro_thalessemia = true or t.chro_sickle = true
	or t.chro_tb = true
	then true else false end,
	total_anc =t.total_anc,
	complete_anc_date = case when t.anc4 is not null and t.ifa_180_anc_date is not null then greatest(t.anc4,t.ifa_180_anc_date) end,
	complete_anc_location = case when (t.anc4 is not null and t.ifa_180_anc_date is not null) and (t.anc4 > t.ifa_180_anc_date)
									then t.anc4_location_id
								when (t.anc4 is not null and t.ifa_180_anc_date is not null) then t.ifa_180_anc_location end,
	total_regular_anc = (case when t.anc1 is null then 0 else 1 end)
	+  (case when t.anc2 is null then 0 else 1 end)
	+  (case when t.anc3 is null then 0 else 1 end)
	+  (case when t.anc4 is null then 0 else 1 end),
	high_risk_mother = case when t.high_risk_mother = true or t.total_out_come >= 3
	or t.chro_diabetes = true or t.chro_heart_kidney = true
	or t.chro_hiv = true or t.chro_thalessemia = true or t.chro_sickle = true
	or t.chro_tb = true or t.cur_extreme_age = true or t.cur_low_weight = true
	or t.cur_severe_anemia = true or t.cur_blood_pressure_issue = true
	or t.cur_gestational_diabetes_issue = true or t.prev_preg_diff_in_month <= 18
	or t.cur_social_vulnerability = true
	then true else false end,
	high_risk_cnt =t.high_risk_cnt + case when t.total_out_come >=3 then 1 else 0 end
	+ case when t.chro_tb then 1 else 0 end + case when t.chro_diabetes then 1 else 0 end
	+ case when t.chro_heart_kidney then 1 else 0 end + case when t.chro_hiv then 1 else 0 end
	+ case when t.chro_thalessemia then 1 else 0 end + case when t.chro_sickle then 1 else 0 end
	+ case when t.cur_extreme_age then 1 else 0 end
	+ case when t.prev_preg_diff_in_month <= 18 then 1 else 0 end,
	hbsag_test_cnt =t.hbsag_test_cnt,
	hbsag_reactive_cnt =t.hbsag_reactive_cnt,
	hbsag_non_reactive_cnt =t.hbsag_non_reactive_cnt,
	pre_preg_anemia =t.pre_preg_anemia,

	pre_preg_aph =t.pre_preg_aph,
	pre_preg_pph =t.pre_preg_pph,
	pre_preg_pre_eclampsia =t.pre_preg_pre_eclampsia,
	pre_preg_obstructed_labour =t.pre_preg_obstructed_labour,
	pre_preg_placenta_previa =t.pre_preg_placenta_previa,
	pre_preg_malpresentation =t.pre_preg_malpresentation,
	pre_preg_birth_defect =t.pre_preg_birth_defect,
	pre_preg_preterm_delivery =t.pre_preg_preterm_delivery,

	pre_preg_caesarean_section =t.pre_preg_caesarean_section,
	pre_preg_abortion =t.pre_preg_abortion,
	chro_tb =t.chro_tb,
	chro_diabetes =t.chro_diabetes,
	chro_heart_kidney =t.chro_heart_kidney,
	chro_hiv =t.chro_hiv,
	chro_sickle =t.chro_sickle,
	chro_thalessemia =t.chro_thalessemia,
	delivery_outcome =t.delivery_outcome,
	delivery_health_infrastructure = t.delivery_health_infrastructure,
	type_of_delivery=t.type_of_delivery,
	delivery_place = t.delivery_place,
	home_del =t.home_del,
	institutional_del =t.institutional_del,
	delivery_108 = t.delivery_108,

    delivery_out_of_state_govt = t.delivery_out_of_state_govt,
    delivery_out_of_state_pvt = t.delivery_out_of_state_pvt,

	breast_feeding_in_one_hour =t.breast_feeding_in_one_hour,
	delivery_hospital =t.delivery_hospital,
	del_week =t.del_week,
	is_cortico_steroid =t.is_cortico_steroid,
	mother_alive =t.mother_alive,
	total_out_come =t.total_out_come,
	male =t.male,
	female =t.female,

	still_birth = t.still_birth,
	live_birth = t.live_birth,

	delivery_done_by = t.delivery_done_by,
	pnc1 =t.pnc1,
	pnc1_location_id = t.pnc1_location_id,
	pnc2 =t.pnc2,
	pnc2_location_id = t.pnc2_location_id,
	pnc3 =t.pnc3,
	pnc3_location_id = t.pnc3_location_id,
	pnc4 =t.pnc4,
	pnc4_location_id = t.pnc4_location_id,
    pnc5 = t.pnc5,
    pnc5_location_id = t.pnc5_location_id,
    pnc6 = t.pnc6,
    pnc6_location_id = t.pnc6_location_id,
	pnc7 = t.pnc7,
	pnc7_location_id = t.pnc7_location_id,

	ifa_tab_after_delivery = t.ifa_tab_after_delivery,

	haemoglobin_tested_count = t.haemoglobin_tested_count,
	iron_def_anemia_inj = t.iron_def_anemia_inj,
	blood_transfusion = t.blood_transfusion,
	ppiucd_insert_date = t.ppiucd_insert_date,
	ppiucd_insert_location = t.ppiucd_insert_location,
	is_fru = t.is_fru,
	high_risk_reasons = t.high_risk_reasons,
	tracking_location_id = t.tracking_location_id,
	is_valid_for_tracking_report = t.is_valid_for_tracking_report,

	asha_sangini_indicator_newbornvisit = case when t.home_del is true and t.date_of_delivery = t.pnc1 and t.delivery_outcome = ''LBIRTH'' then true else false end,
	asha_sangini_indicator_hbnc = case when num_nulls(t.pnc1, t.pnc2, t.pnc3, t.pnc4, t.pnc5, t.pnc6, t.pnc7) = 0 then true else false end,
	family_basic_state = t.family_basic_state,
    marital_status = t.marital_status,
    address = t.address,
    husband_name = t.husband_name,
    husband_mobile_number = t.husband_mobile_number,
    hof_name = t.hof_name,
    hof_mobile_number = t.hof_mobile_number
from t_pregnancy_registration_det t
where t.pregnancy_reg_id = rch_pregnancy_analytics_details.pregnancy_reg_id;
/*with member_details as (
    select distinct on (member_id)
    member_id,
    pregnancy_reg_id,
    high_risk_mother,
    high_risk_reasons
    from t_pregnancy_registration_det
    order by member_id,pregnancy_reg_id desc
)update imt_member
set is_high_risk_case = member_details.high_risk_mother,
additional_info = concat(cast(additional_info as jsonb),cast(concat(''{"highRiskReasons":"'',case when member_details.high_risk_reasons is not null then member_details.high_risk_reasons else ''null'' end,''"}'') as jsonb))
from member_details
where imt_member.id = member_details.member_id
and (
    imt_member.is_high_risk_case != member_details.high_risk_mother
    or cast(additional_info as jsonb) ->> ''highRiskReasons'' != member_details.high_risk_reasons
);*/
update timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED12''
where event_config_id = 39 and status = ''PROCESSED11'';
commit;

---13
begin;
drop table if exists t_pregnancy_registration_det;

drop table if exists asha_workers_last_2_months_analytics_t;
create table asha_workers_last_2_months_analytics_t(
	user_id int,
	location_id int,
	total_home_deliveries int,
	newbornvisit_on_dob int,
	total_deliveries int,
	total_deliveries_with_hbnc int
);

with dates as (
	select case when current_date < cast(date_trunc(''month'', now()) + interval ''20 days'' as date) then cast(date_trunc(''month'', now() - interval ''3 months'') + interval ''20 days'' as date)
		else cast(date_trunc(''month'', now() - interval ''2 months'') + interval ''20 days'' as date)
		end as from_date,
	case when current_date < cast(date_trunc(''month'', now()) + interval ''20 days'' as date) then cast(date_trunc(''month'', now() - interval ''1 month'') + interval ''19 days'' as date)
		else cast(date_trunc(''month'', now()) + interval ''19 days'' as date)
		end as to_date
), pregnant_woman_details as (
	select rpad.member_id, rpad.member_current_location_id, rpad.date_of_delivery, rpad.home_del,
	rpad.asha_sangini_indicator_newbornvisit, rpad.asha_sangini_indicator_hbnc
	from rch_pregnancy_analytics_details rpad
	inner join dates on true
	where rpad.date_of_delivery between dates.from_date and dates.to_date and rpad.delivery_outcome = ''LBIRTH''
), asha_det as (
	select uu.id, uul.loc_id
	from um_user uu
	inner join um_user_location uul on uul.user_id =  uu.id
	where role_id = 24 and uu.state = ''ACTIVE'' and uul.state = ''ACTIVE''
), counts as (
	select asha_det.id, asha_det.loc_id,
	count(pwd.member_id) filter (where pwd.home_del is true) as total_home_deliveries,
	count(pwd.member_id) filter (where home_del is true and asha_sangini_indicator_newbornvisit is true) as newbornvisit_on_dob,
	count(pwd.member_id) filter (where date_of_delivery <= cast(now() - interval ''60 days'' as date)) as total_deliveries,
	count(pwd.member_id) filter (where asha_sangini_indicator_hbnc is true and date_of_delivery <= cast(now() - interval ''60 days'' as date)) as total_deliveries_with_hbnc
	from pregnant_woman_details pwd
	right join asha_det on asha_det.loc_id = pwd.member_current_location_id
	group by asha_det.loc_id, asha_det.id
)
insert into asha_workers_last_2_months_analytics_t (
	user_id, location_id, total_home_deliveries, newbornvisit_on_dob, total_deliveries, total_deliveries_with_hbnc
)
select counts.* from counts;

drop table if exists asha_workers_last_2_months_analytics;
alter table asha_workers_last_2_months_analytics_t
	rename to asha_workers_last_2_months_analytics;

update timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED13''
where event_config_id = 39 and status = ''PROCESSED12'';
commit;


---14
-----------------------------------------------------------------------------------------------------------------------------
begin;
drop table if exists rch_lmp_base_location_wise_data_point_t;
create table rch_lmp_base_location_wise_data_point_t (
	location_id bigint,
	month_year date,
	financial_year text,

	anc_reg bigint,
	abortion integer,
	mtp integer,
	no_of_inst_del integer,
	no_of_home_del integer,
	delivery_108 integer,
    delivery_out_of_state_govt integer,
    delivery_out_of_state_pvt integer,

	no_of_maternal_death integer,

	no_of_missing_del integer,
	no_of_not_missing_del integer,
	high_risk_mother bigint,
	pre_preg_pre_eclampsia bigint,
	prev_anemia bigint,
	prev_caesarian bigint,
	prev_aph_pph bigint,
	prev_abortion bigint,
	multipara bigint,
	cur_mal_presentation_issue bigint,
	cur_malaria_issue bigint,

	tb bigint,
	diabetes bigint,
	heart_kidney bigint,
	hiv bigint,
	sickle bigint,
	thalessemia bigint,
	early_anc integer,
	anc1 integer,
	anc2 integer,
	anc3 integer,
	anc4 integer,
	full_anc integer,
	ifa integer,
	tt1 integer,
	tt2 integer,
	tt_booster integer,
	tt2_tt_booster integer,
	lbirth integer,
	sbirth integer,
	home_del integer,
	breast_feeding integer,
	sc integer,
	phc integer,
	chc integer,
	sdh integer,
	uhc integer,
	gia integer,
	medi_college integer,
	taluka_hospi integer,
	pvt integer,

	home_del_by_sba integer,
	home_del_by_non_sba integer,
	del_over_due integer,
	ifa_30_tablet_in_30_day integer,
	ifa_30_tablet_in_31_to_61_day integer,
	ifa_30_tablet_in_61_to_90_day integer,
	hb_done integer,
	hb_more_then_11_in_91_to_360_days integer,
	ifa_180_with_hb_in_4_to_9_month integer,
	hb_between_7_to_11 integer,
	ifa_360_with_hb_between_7_to_11_in_4_to_9_month integer,
	ca_180_given_in_2nd_trimester integer,
	ca_180_given_in_3rd_trimester integer,
	hr_anc_regd integer,
	hr_tt1 integer,
	hr_tt2_and_tt_boster integer,
	hr_tt2_tt_booster integer,
	hr_early_anc integer,
	hr_anc1 integer,
	hr_anc2 integer,
	hr_anc3 integer,
	hr_anc4 integer,
	hr_no_of_delivery integer,
	hr_mtp integer,
	hr_abortion integer,
	hr_pnc1 integer,
	hr_pnc2 integer,
	hr_pnc3 integer,
	hr_pnc4 integer,
	hr_maternal_death integer,
	hr_sc integer,
	hr_phc integer,
	hr_fru_chc integer,
	hr_non_fru_chc integer,
	hr_sdh integer,
	hr_uhc integer,
	hr_gia integer,
	hr_medi_college integer,
	hr_taluka_hospi integer,
	hr_pvt integer,
	hr_home_del_by_sba integer,
	hr_home_del_by_non_sba integer,
	primary key(location_id,month_year)
);

insert into rch_lmp_base_location_wise_data_point_t(
	location_id,month_year,financial_year,
	anc_reg,
	abortion,mtp,no_of_maternal_death,no_of_inst_del,no_of_home_del,home_del_by_sba,
	home_del_by_non_sba,delivery_108,delivery_out_of_state_govt,delivery_out_of_state_pvt,no_of_missing_del,no_of_not_missing_del,
	high_risk_mother,pre_preg_pre_eclampsia,prev_anemia,prev_caesarian,prev_aph_pph,prev_abortion,multipara,
	cur_malaria_issue,cur_mal_presentation_issue,tb,diabetes,heart_kidney,hiv,sickle,thalessemia,
	early_anc,anc1,anc2,anc3,anc4,
	full_anc,ifa,
	tt1,tt2,tt_booster,tt2_tt_booster,
	lbirth,sbirth,home_del,breast_feeding,sc,phc,chc,sdh,uhc,gia,medi_college,taluka_hospi,pvt,del_over_due
	,ifa_30_tablet_in_30_day,ifa_30_tablet_in_31_to_61_day,ifa_30_tablet_in_61_to_90_day,hb_done
	,hb_more_then_11_in_91_to_360_days,ifa_180_with_hb_in_4_to_9_month,hb_between_7_to_11,ifa_360_with_hb_between_7_to_11_in_4_to_9_month
	,ca_180_given_in_2nd_trimester,ca_180_given_in_3rd_trimester,hr_anc_regd,
	hr_tt1, hr_tt2_and_tt_boster, hr_tt2_tt_booster, hr_early_anc, hr_anc1, hr_anc2, hr_anc3,
	hr_anc4, hr_no_of_delivery, hr_mtp, hr_abortion, hr_pnc1, hr_pnc2, hr_pnc3, hr_pnc4, hr_maternal_death,
 	hr_sc, hr_phc, hr_fru_chc, hr_non_fru_chc, hr_sdh, hr_uhc, hr_gia, hr_medi_college, hr_taluka_hospi, hr_pvt, hr_home_del_by_sba,
	hr_home_del_by_non_sba
)
select tracking_location_id,lmp_month_year,lmp_financial_year,
count(*) as anc_regd,
sum(case when delivery_outcome in (''ABORTION'', ''SPONT_ABORTION'') then 1 else 0 end) as no_of_abortion,
sum(case when delivery_outcome = ''MTP'' then 1 else 0 end) as no_of_mtp,
sum(case when maternal_detah = true then 1 else 0 end) as no_of_death,
sum(case when institutional_del and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as no_of_inst_del,
sum(case when (home_del) and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as no_of_home_del,
sum(case when home_del and delivery_outcome in (''LBIRTH'',''SBIRTH'')
	and (delivery_done_by is null  or delivery_done_by != ''NON-TBA'') then 1 else 0 end) as home_del_by_sba,
sum(case when home_del and delivery_outcome in (''LBIRTH'',''SBIRTH'')
	and (delivery_done_by is not null  and delivery_done_by = ''NON-TBA'') then 1 else 0 end) as home_del_by_non_sba,

sum(case when delivery_108 and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as delivery_108,

sum(case when delivery_out_of_state_govt = true then 1 else 0 end) as delivery_out_of_state_govt,
sum(case when delivery_out_of_state_pvt = true then 1 else 0 end) as delivery_out_of_state_pvt,

sum(case when preg_reg_state in (''PENDING'',''PREGNANT'')
	and maternal_detah is false and edd <= current_date then 1 else 0 end) as no_of_missing_del,
sum(case when preg_reg_state in (''PENDING'',''PREGNANT'')
	and maternal_detah is false and edd > current_date then 1 else 0 end) as no_of_not_missing_del,
sum(case when high_risk_mother = true then 1 else 0 end) as high_risk_mother,
sum(case when pre_preg_pre_eclampsia then 1 else 0 end) as pre_preg_pre_eclampsia,
sum(case when pre_preg_anemia then 1 else 0 end) as prev_anemia,
sum(case when pre_preg_caesarean_section then 1 else 0 end) as prev_caesarian,
sum(case when pre_preg_aph or pre_preg_pph  then 1 else 0 end) as prev_aph_pph,
sum(case when pre_preg_abortion then 1 else 0 end) as prev_abortion,
sum(case when total_out_come>=3 then 1 else 0 end) as multipara,
sum(case when cur_malaria_issue then 1 else 0 end) as cur_malaria_issue,
sum(case when cur_mal_presentation_issue then 1 else 0 end) as cur_mal_presentation_issue,
sum(case when chro_tb then 1 else 0 end) as tb,
sum(case when chro_diabetes then 1 else 0 end) as diabetes,
sum(case when chro_heart_kidney then 1 else 0 end) as heart_kidney,
sum(case when chro_hiv then 1 else 0 end) as hiv,
sum(case when chro_sickle then 1 else 0 end) as sickle,
sum(case when chro_thalessemia then 1 else 0 end) as thalessemia,
sum(case when early_anc then 1 else 0 end) as early_anc,
sum(case when anc1 is not null then 1 else 0 end) as anc1,
sum(case when anc2 is not null then 1 else 0 end) as anc2,
sum(case when anc3 is not null then 1 else 0 end) as anc3,
sum(case when anc4 is not null then 1 else 0 end) as anc4,
sum(case when total_regular_anc >=4 and ifa >= 180 and (tt2_given is not null or tt_boster is not null) then 1 else 0 end) as full_anc,
sum(case when ifa >= 180 then 1 else 0 end) as ifa,
sum(case when tt1_given is not null then 1 else 0 end) as tt1,
sum(case when tt2_given is not null then 1 else 0 end) as tt2,
sum(case when tt_boster is not null then 1 else 0 end) as tt_boster,
sum(case when tt2_tt_booster_given is not null then 1 else 0 end) as tt2_tt_booster,
sum(case when delivery_outcome = ''LBIRTH'' then 1 else 0 end) as lbirth,
sum(case when delivery_outcome = ''SBIRTH'' then 1 else 0 end) as sbirth,
sum(case when home_del and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as home_del,
sum(case when breast_feeding_in_one_hour = true then 1 else 0 end) as breast_feeding,
sum(case when delivery_hospital in (''897'',''1062'') then 1 else 0 end) as sc,
sum(case when delivery_hospital in (''899'',''1061'') then 1 else 0 end) as phc,
sum(case when delivery_hospital in (''895'',''1009'',''1084'') then 1 else 0 end) as chc,
sum(case when delivery_hospital in (''890'',''1008'') then 1 else 0 end) as sdh,
sum(case when delivery_hospital in (''894'',''1063'') then 1 else 0 end) as uhc,
sum(case when delivery_hospital in (''1064'') then 1 else 0 end) as gia,
sum(case when delivery_hospital in (''891'',''1012'') then 1 else 0 end) as medi_college,
sum(case when delivery_hospital in (''896'',''1007'') then 1 else 0 end) as taluka_hospi,
sum(case when delivery_hospital in (''893'',''898'',''1013'',''1010'') then 1 else 0 end) as pvt,
sum(case when lmp_date + interval ''281 days'' < now() and delivery_outcome is null then 1 else 0  end) as del_over_due,
sum(case when fa_tab_in_30_day >= 30 then 1 else 0  end) as ifa_30_tablet_in_30_day,
sum(case when fa_tab_in_31_to_60_day >= 30 then 1 else 0  end) as ifa_30_tablet_in_31_to_61_day,
sum(case when fa_tab_in_61_to_90_day >= 30 then 1 else 0  end) as ifa_30_tablet_in_61_to_90_day,
sum(case when hb is not null then 1 else 0  end) as hb_done,
sum(case when hb_between_90_to_360_days > 11 then 1 else 0  end) as hb_more_then_11_in_91_to_360_days,
sum(case when hb_between_90_to_360_days > 11 and ifa_tab_in_4_month_to_9_month >= 180 then 1 else 0  end) as ifa_180_with_hb_in_4_to_9_month,
sum(case when hb_between_90_to_360_days between 7 and 11 then 1 else 0  end) as hb_between_7_to_11,
sum(case when hb_between_90_to_360_days between 7 and 11 and ifa_tab_in_4_month_to_9_month >= 180 then 1 else 0  end) as ifa_360_with_hb_between_7_to_11_in_4_to_9_month,
sum(case when ca_tab_in_91_to_180_day >= 180 then 1 else 0  end) as ca_180_given_in_2nd_trimester,
sum(case when ca_tab_in_181_to_360_day >= 180 then 1 else 0  end) as ca_180_given_in_3rd_trimester,
count(*) filter ( where high_risk_mother = true) as hr_anc_regd,
sum(case when high_risk_mother = true and tt1_given is not null then 1 else 0 end) as hr_tt1,
sum(case when high_risk_mother = true and tt_boster is not null and  tt2_given is not null then 1 else 0 end) as hr_tt2_and_tt_boster,
sum(case when high_risk_mother = true and tt2_tt_booster_given is not null then 1 else 0 end) as hr_tt2_tt_booster,
sum(case when high_risk_mother = true and early_anc then 1 else 0 end) as hr_early_anc,
sum(case when high_risk_mother = true and anc1 is not null then 1 else 0 end) as hr_anc1,
sum(case when high_risk_mother = true and anc2 is not null then 1 else 0 end) as hr_anc2,
sum(case when high_risk_mother = true and anc3 is not null then 1 else 0 end) as hr_anc3,
sum(case when high_risk_mother = true and anc4 is not null then 1 else 0 end) as hr_anc4,
sum(case when high_risk_mother = true and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as hr_no_of_delivery,
sum(case when high_risk_mother = true and delivery_outcome = ''MTP'' then 1 else 0 end) as hr_mtp,
sum(case when high_risk_mother = true and delivery_outcome in (''ABORTION'', ''SPONT_ABORTION'') then 1 else 0 end) as hr_abortion,
sum(case when high_risk_mother = true and pnc1 is not null then 1 else 0 end) as hr_pnc1,
sum(case when high_risk_mother = true and pnc2 is not null then 1 else 0 end) as hr_pnc2,
sum(case when high_risk_mother = true and pnc3 is not null then 1 else 0 end) as hr_pnc3,
sum(case when high_risk_mother = true and pnc4 is not null then 1 else 0 end) as hr_pnc4,
sum(case when high_risk_mother = true and maternal_detah = true then 1 else 0 end) as hr_maternal_death,
sum(case when high_risk_mother = true and delivery_outcome in (''LBIRTH'',''SBIRTH'') and delivery_hospital in (''897'',''1062'') then 1 else 0 end) as hr_sc,
sum(case when high_risk_mother = true and delivery_outcome in (''LBIRTH'',''SBIRTH'') and delivery_hospital in (''899'',''1061'') then 1 else 0 end) as hr_phc,
sum(case when high_risk_mother = true and delivery_outcome in (''LBIRTH'',''SBIRTH'') and is_fru and delivery_hospital in (''895'',''1009'',''1084'') then 1 else 0 end) as hr_fru_chc,
sum(case when high_risk_mother = true and delivery_outcome in (''LBIRTH'',''SBIRTH'') and is_fru is false and delivery_hospital in (''895'',''1009'',''1084'') then 1 else 0 end) as hr_non_fru_chc,
sum(case when high_risk_mother = true and delivery_outcome in (''LBIRTH'',''SBIRTH'') and delivery_hospital in (''890'',''1008'') then 1 else 0 end) as hr_sdh,
sum(case when high_risk_mother = true and delivery_outcome in (''LBIRTH'',''SBIRTH'') and delivery_hospital in (''894'',''1063'') then 1 else 0 end) as hr_uhc,
sum(case when high_risk_mother = true and delivery_outcome in (''LBIRTH'',''SBIRTH'') and delivery_hospital in (''1064'') then 1 else 0 end) as hr_gia,
sum(case when high_risk_mother = true and delivery_outcome in (''LBIRTH'',''SBIRTH'') and delivery_hospital in (''891'',''1012'') then 1 else 0 end) as hr_medi_college,
sum(case when high_risk_mother = true and delivery_outcome in (''LBIRTH'',''SBIRTH'') and delivery_hospital in (''896'',''1007'') then 1 else 0 end) as hr_taluka_hospi,
sum(case when high_risk_mother = true and delivery_outcome in (''LBIRTH'',''SBIRTH'') and delivery_hospital in (''893'',''898'',''1013'',''1010'') then 1 else 0 end) as hr_pvt,
sum(case when high_risk_mother = true and home_del and delivery_outcome in (''LBIRTH'',''SBIRTH'')
	and (delivery_done_by is null  or delivery_done_by != ''NON-TBA'') then 1 else 0 end) as hr_home_del_by_sba,
sum(case when high_risk_mother = true and home_del and delivery_outcome in (''LBIRTH'',''SBIRTH'')
	and (delivery_done_by is not null  and delivery_done_by = ''NON-TBA'') then 1 else 0 end) as hr_home_del_by_non_sba

from rch_pregnancy_analytics_details
where is_valid_for_tracking_report = true
group by tracking_location_id,lmp_month_year,lmp_financial_year;

update timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED14''
where event_config_id = 39 and status = ''PROCESSED13'';
commit;
---15
----------------------------------------------------------------------------------------------------------------------------------------------
begin;
drop table if exists rch_delivery_date_base_location_wise_data_point_t;
create table rch_delivery_date_base_location_wise_data_point_t (
	location_id bigint,
	month_year date,

	del_reg integer,
	del_reg_still_live_birth integer,
	preg_reg integer,
	del_less_eq_34 integer,
	del_bet_35_37 integer,
	del_greater_37 integer,
	cortico_steroid integer,
	mtp integer,
	lbirth integer,
	sbirth integer,
	abortion integer,
	home_del integer,
	home_del_by_sba integer,
	home_del_by_non_sba integer,
	breast_feeding integer,
	sc integer,
	phc integer,
	chc integer,
	sdh integer,
	uhc integer,
	gia integer,
	pvt integer,
	mdh integer,
	dh integer,
	delivery_108 integer,

    delivery_out_of_state_govt integer,
    delivery_out_of_state_pvt integer,

	phi_del_3_ancs integer,
	inst_del integer,
	maternal_detah integer,
	pnc1 integer,
	pnc2 integer,
	pnc3 integer,
	pnc4 integer,
	full_pnc integer,
	ifa_180_after_delivery integer,
	calcium_360_after_delivery integer,

	primary key(location_id,month_year)
);

insert into rch_delivery_date_base_location_wise_data_point_t(
	location_id,month_year,
	del_reg,del_reg_still_live_birth,del_less_eq_34,del_bet_35_37,del_greater_37,cortico_steroid,
	mtp,abortion,lbirth,sbirth,home_del,home_del_by_sba,home_del_by_non_sba,breast_feeding,
	sc,phc,chc,sdh,uhc,gia,pvt,mdh,dh,delivery_108,delivery_out_of_state_govt,delivery_out_of_state_pvt,
	phi_del_3_ancs,inst_del,pnc1,pnc2,pnc3,pnc4,full_pnc,ifa_180_after_delivery
)
select delivery_location_id,
cast(date_trunc(''month'',date_of_delivery_month_year) as date) as month_year,
count(*),
sum(case when delivery_outcome in(''LBIRTH'',''SBIRTH'') and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as del_reg_still_live_birth,
sum(case when del_week <= 34 and delivery_outcome in(''LBIRTH'',''SBIRTH'') and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as del_less_eq_34,
sum(case when del_week between 35 and 37 and delivery_outcome in(''LBIRTH'',''SBIRTH'') and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as del_bet_35_37,
sum(case when del_week > 37 and delivery_outcome in(''LBIRTH'',''SBIRTH'') and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as del_greater_37,
sum(case when del_week <= 34 and delivery_outcome in(''LBIRTH'',''SBIRTH'') and is_cortico_steroid and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as cortico_steroid,
sum(case when delivery_outcome = ''MTP'' and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as mtp,
sum(case when delivery_outcome in (''ABORTION'', ''SPONT_ABORTION'') and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as abortion,
sum(case when delivery_outcome = ''LBIRTH'' and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then total_out_come else 0 end) as lbirth,
sum(case when (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then still_birth else 0 end) as sbirth,
sum(case when home_del and delivery_outcome in (''LBIRTH'',''SBIRTH'') and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as home_del,
sum(case when home_del and delivery_outcome in (''LBIRTH'',''SBIRTH'')
	and (delivery_done_by is null  or delivery_done_by != ''NON-TBA'') and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as home_del_by_sba,
sum(case when home_del and delivery_outcome in (''LBIRTH'',''SBIRTH'') and delivery_done_by is not null
	and delivery_done_by = ''NON-TBA'' and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as home_del_by_non_sba,
sum(case when delivery_hospital in (''897'',''1062'',''899'',''1061'',''895'',''1009'',''890'',''1008'',''894'',''1063'',''892'',''891'',''1012'',''896'',''1007'',''1084'')
	and delivery_outcome in (''LBIRTH'',''SBIRTH'') and breast_feeding_in_one_hour = true
	then 1 else 0 end) as breast_feeding,
sum(case when institutional_del  and  delivery_hospital in (''897'',''1062'') and delivery_outcome in (''LBIRTH'',''SBIRTH'')  then 1 else 0 end) as sc,
sum(case when institutional_del  and  delivery_hospital in (''899'',''1061'') and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as phc,
sum(case when institutional_del  and  delivery_hospital in (''895'',''1009'',''1084'') and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as chc,
sum(case when institutional_del  and  delivery_hospital in (''890'',''1008'') and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as sdh,
sum(case when institutional_del  and  delivery_hospital in (''894'',''1063'') and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as uhc,
sum(case when institutional_del  and  delivery_hospital in (''1064'') and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as gia,
sum(case when institutional_del  and  delivery_hospital in (''893'',''898'',''1013'',''1010'') and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as pvt,
sum(case when institutional_del  and  delivery_hospital in (''891'',''1012'') and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as mdh,
sum(case when institutional_del  and  delivery_hospital in (''896'',''1007'') and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as dh,
sum(case when delivery_108 and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as delivery_108,

sum(case when delivery_out_of_state_govt = true then 1 else 0 end) as delivery_out_of_state_govt,
sum(case when delivery_out_of_state_pvt = true then 1 else 0 end) as delivery_out_of_state_pvt,

sum(case when ((institutional_del  and delivery_hospital in (''897'',''1062'',''899'',''1061'',''895'',''1009'',''890'',''1008'',''894'',''1063'',''892'',''891'',''1012'',''896'',''1007'',''1084''))
	or delivery_108)
	and delivery_outcome in (''LBIRTH'',''SBIRTH'') and total_regular_anc >= 3  then 1 else 0 end) as phi_del_3_ancs,
sum(case when (institutional_del) and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as no_of_inst_del,
sum(case when pnc1 is not null then 1 else 0 end) as pnc1,
sum(case when pnc2 is not null then 1 else 0 end) as pnc2,
sum(case when pnc3 is not null then 1 else 0 end) as pnc3,
sum(case when pnc4 is not null then 1 else 0 end) as pnc4,
sum(case when pnc4 is not null and ifa_tab_after_delivery >= 180 then 1 else 0 end) as full_pnc,
sum(case when ifa_tab_after_delivery >= 180 then 1 else 0 end) as ifa_180_after_delivery
--,sum(case when maternal_detah then 1 else 0 end) as maternal_death
from rch_pregnancy_analytics_details
where date_of_delivery_month_year is not null and delivery_outcome is not null
group by delivery_location_id,date_of_delivery_month_year;


with del_det as(
	select rprd.native_location_id as location_id
	,cast(date_trunc(''month'', rprd.reg_service_date) as date) as month_year,
	count(*) as anc_reg,
	sum(case when early_anc then 1 else 0 end) as early_anc
	from rch_pregnancy_analytics_details rprd
	where rprd.reg_service_date >= to_date(''01-04-2013'',''DD-MM-YYYY'')
	group by rprd.native_location_id,cast(date_trunc(''month'', rprd.reg_service_date) as date)
),maternal_death_detail as (
	select rch_pregnancy_analytics_details.death_location_id as location_id,
	cast(date_trunc(''month'', rch_pregnancy_analytics_details.death_date) as date) as month_year,
	count(*) as maternal_detah
	from rch_pregnancy_analytics_details
	where rch_pregnancy_analytics_details.death_date >= to_date(''01-04-2013'',''DD-MM-YYYY'')
	and rch_pregnancy_analytics_details.maternal_detah = true
	group by rch_pregnancy_analytics_details.death_location_id
	,cast(date_trunc(''month'', rch_pregnancy_analytics_details.death_date) as date)
),location_det as (
select location_id,month_year from del_det
	union
select location_id,month_year from maternal_death_detail
)
insert into rch_delivery_date_base_location_wise_data_point_t(location_id,month_year)
select location_det.location_id,location_det.month_year
from location_det
left join rch_delivery_date_base_location_wise_data_point_t
on location_det.location_id = rch_delivery_date_base_location_wise_data_point_t.location_id
and location_det.month_year = rch_delivery_date_base_location_wise_data_point_t.month_year
where rch_delivery_date_base_location_wise_data_point_t.location_id is null;


with maternal_death_detail as(
	select rch_pregnancy_analytics_details.death_location_id as location_id,
	cast(date_trunc(''month'', rch_pregnancy_analytics_details.death_date) as date) as month_year,
	count(*) as maternal_detah
	from rch_pregnancy_analytics_details
	where rch_pregnancy_analytics_details.death_date >= to_date(''01-04-2013'',''DD-MM-YYYY'')
	and rch_pregnancy_analytics_details.maternal_detah = true
	group by rch_pregnancy_analytics_details.death_location_id
	,cast(date_trunc(''month'', rch_pregnancy_analytics_details.death_date) as date)
)
update rch_delivery_date_base_location_wise_data_point_t
set maternal_detah = maternal_death_detail.maternal_detah
from maternal_death_detail where maternal_death_detail.location_id = rch_delivery_date_base_location_wise_data_point_t.location_id
and maternal_death_detail.month_year = rch_delivery_date_base_location_wise_data_point_t.month_year;

with del_det as(
	select rprd.native_location_id as location_id,cast(date_trunc(''month'', rprd.reg_service_date) as date) as month_year,
	count(*) as anc_reg,
	sum(case when early_anc then 1 else 0 end) as early_anc
	from rch_pregnancy_analytics_details rprd
	where rprd.reg_service_date >= to_date(''01-04-2013'',''DD-MM-YYYY'')
	group by rprd.native_location_id,cast(date_trunc(''month'', rprd.reg_service_date) as date)
)
update rch_delivery_date_base_location_wise_data_point_t
set preg_reg = anc_reg
from del_det where del_det.location_id = rch_delivery_date_base_location_wise_data_point_t.location_id
and del_det.month_year = rch_delivery_date_base_location_wise_data_point_t.month_year;

update timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED15''
where event_config_id = 39 and status = ''PROCESSED14'';
commit;
---16
------------------------------------------------------------------------------------------------------------------------------------
begin;
drop table if exists rch_yearly_location_wise_analytics_data_t;
create table rch_yearly_location_wise_analytics_data_t (
	location_id bigint,
	financial_year text,
	month_year date,
	age_less_15 integer,
	age_15_19 integer,
	age_20_24 integer,
	age_25_29 integer,
	age_30_34 integer,
	age_35_39 integer,
	age_40_44 integer,
	age_45_49 integer,
	age_greater_49 integer,
	anc_reg integer,
	hbsag_test integer,
	non_reactive integer,
	reactive integer,

	tt1 integer,
	tt2_tt_booster integer,
	early_anc integer,
	anc1 integer,
	anc2 integer,
	anc3 integer,
	anc4 integer,
	no_of_del integer,
	mtp integer,
	abortion integer,
	pnc1 integer,
	pnc2 integer,
	pnc3 integer,
	pnc4 integer,
	maternal_detah integer,
	primary key(location_id,financial_year,month_year)
);

insert into rch_yearly_location_wise_analytics_data_t(
	location_id,financial_year,month_year,
	age_less_15,age_15_19,age_20_24,age_25_29,age_30_34,age_35_39,age_40_44,age_45_49,age_greater_49,anc_reg,
	hbsag_test,non_reactive,reactive,
	tt1,tt2_tt_booster,early_anc,anc1,anc2,anc3,anc4,no_of_del,mtp,abortion,pnc1,pnc2,pnc3,pnc4,maternal_detah
)
select rprd.tracking_location_id,rprd.reg_service_financial_year,rprd.reg_service_date_month_year,
sum(case when age_during_delivery < 15 then 1 else 0 end) as age_less_15,
sum(case when age_during_delivery between 15 and 19 then 1 else 0 end) as age_15_19,
sum(case when age_during_delivery between 20 and 24 then 1 else 0 end) as age_20_24,
sum(case when age_during_delivery between 25 and 29 then 1 else 0 end) as age_25_29,
sum(case when age_during_delivery between 30 and 34 then 1 else 0 end) as age_30_34,
sum(case when age_during_delivery between 35 and 39 then 1 else 0 end) as age_35_39,
sum(case when age_during_delivery between 40 and 44 then 1 else 0 end) as age_40_44,
sum(case when age_during_delivery between 45 and 49 then 1 else 0 end) as age_45_49,
sum(case when age_during_delivery > 49 then 1 else 0 end) as age_greater_49,
count(*) as anc_reg,
sum(hbsag_test_cnt) as hbsag_test,
sum(hbsag_non_reactive_cnt) as non_reactive,
sum(hbsag_reactive_cnt) as reactive,
sum(case when tt1_given is not null then 1 else 0 end) as tt1,
sum(case when tt2_given is not null or tt_boster is not null  then 1 else 0 end) as tt2,
sum(case when early_anc then 1 else 0 end) as early_anc,
sum(case when total_regular_anc >=1 then 1 else 0 end) as anc1,
sum(case when total_regular_anc >=2 then 1 else 0 end) as anc2,
sum(case when total_regular_anc >=3 then 1 else 0 end) as anc3,
sum(case when total_regular_anc >=4 then 1 else 0 end) as anc4,
sum(case when delivery_outcome in (''LBIRTH'',''SBIRTH'') and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as no_of_del,
sum(case when delivery_outcome = ''MTP'' and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as mtp,
sum(case when delivery_outcome in (''ABORTION'', ''SPONT_ABORTION'') and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as abortion,
sum(case when pnc1 is not null then 1 else 0 end) as pnc1,
sum(case when pnc2 is not null then 1 else 0 end) as pnc2,
sum(case when pnc3 is not null then 1 else 0 end) as pnc3,
sum(case when pnc4 is not null then 1 else 0 end) as pnc4,
sum(case when maternal_detah then 1 else 0 end) as maternal_detah
from rch_pregnancy_analytics_details rprd
where is_valid_for_tracking_report = true
group by rprd.tracking_location_id,rprd.reg_service_financial_year,rprd.reg_service_date_month_year;

update timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED16''
where event_config_id = 39 and status = ''PROCESSED15'';
commit;


---17
-----------------------------------------------------------------------------------------------------------------------------------------
begin;
drop table if exists rch_current_state_pregnancy_analytics_data_t;
create table rch_current_state_pregnancy_analytics_data_t (
	location_id bigint primary key,
	reg_preg_women integer,
	high_risk integer,
	prev_compl integer,
	chronic integer,
	two_or_more_risk integer,
	current_preg_compl integer,
	severe_anemia integer,
	diabetes integer,
	cur_mal_presentation_issue bigint,
	cur_malaria_issue bigint,
	multipara bigint,
	blood_pressure integer,
	interval_bet_preg_less_18_months integer,
	extreme_age integer,
	height integer,
	weight  integer,
	urine_albumin integer,
	anc_in_2or3_trim integer,
	alben_given integer,
	alben_not_given integer,

	pre_preg_pre_eclampsia bigint,
	prev_anemia bigint,
	prev_caesarian bigint,
	prev_aph_pph bigint,
	prev_abortion bigint,

	chro_tb bigint,
	chro_diabetes bigint,
	chro_heart_kidney bigint,
	chro_hiv bigint,
	chro_sickle bigint,
	chro_thalessemia bigint
);

insert into rch_current_state_pregnancy_analytics_data_t(
	location_id,reg_preg_women,high_risk,two_or_more_risk,prev_compl,chronic,current_preg_compl
	,severe_anemia,blood_pressure,diabetes,cur_mal_presentation_issue,cur_malaria_issue,multipara,extreme_age,height,weight,urine_albumin
	,anc_in_2or3_trim,alben_given,alben_not_given,interval_bet_preg_less_18_months
	,pre_preg_pre_eclampsia,prev_anemia,prev_caesarian,prev_aph_pph,prev_abortion
	,chro_tb,chro_diabetes,chro_heart_kidney,chro_hiv,chro_sickle,chro_thalessemia
)
select member_current_location_id,
count(*) as reg_preg_women,
sum(case when high_risk_mother = true then 1 else 0 end) as high_risk,
sum(case when high_risk_cnt >= 2 then 1 else 0 end) as two_or_more_risk,
sum(case when any_prev_preg_complication then 1 else 0 end) as prev_compl,
sum(case when any_chronic_dis then 1 else 0 end) as chronic,
sum(case when any_cur_preg_complication then 1 else 0 end) as current_preg_compl,
sum(case when cur_severe_anemia then 1 else 0 end) as severe_anemia,
sum(case when cur_blood_pressure_issue then 1 else 0 end) as blood_pressure,
sum(case when cur_gestational_diabetes_issue then 1 else 0 end) as diabetes,
sum(case when cur_mal_presentation_issue then 1 else 0 end) as cur_mal_presentation_issue,
sum(case when cur_malaria_issue then 1 else 0 end) as cur_malaria_issue,
sum(case when total_out_come>=3 then 1 else 0 end) as multipara,
sum(case when cur_extreme_age then 1 else 0 end) as extreme_age,
sum(case when low_height then 1 else 0 end) as height,
sum(case when cur_low_weight then 1 else 0 end) as weight,
sum(case when urine_albumin then 1 else 0 end) as urine_albumin,
sum(case when current_date - lmp_date between 92 and 245 then 1 else 0 end) anc_in_2or3_trim,
sum(case when current_date - lmp_date between 92 and 245 and alben_given then 1 else 0 end) alben_given,
sum(case when current_date - lmp_date between 92 and 245 and (alben_given is null or alben_given = false) then 1 else 0 end) alben_not_given,
sum(case when cur_less_than_18_month_interval then 1 else 0 end) interval_bet_preg_less_18_months,

sum(case when pre_preg_pre_eclampsia then 1 else 0 end) as pre_preg_pre_eclampsia,
sum(case when pre_preg_anemia then 1 else 0 end) as prev_anemia,
sum(case when pre_preg_caesarean_section then 1 else 0 end) as prev_caesarian,
sum(case when pre_preg_aph or pre_preg_pph  then 1 else 0 end) as prev_aph_pph,
sum(case when pre_preg_abortion then 1 else 0 end) as prev_abortion,
sum(case when chro_tb then 1 else 0 end) as tb,
sum(case when chro_diabetes then 1 else 0 end) as diabetes,
sum(case when chro_heart_kidney then 1 else 0 end) as heart_kidney,
sum(case when chro_hiv then 1 else 0 end) as hiv,
sum(case when chro_sickle then 1 else 0 end) as sickle,
sum(case when chro_thalessemia then 1 else 0 end) as thalessemia
from rch_pregnancy_analytics_details
where rch_pregnancy_analytics_details.member_basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')
and preg_reg_state in (''PENDING'',''PREGNANT'')
and is_valid_for_tracking_report = true
group by member_current_location_id;

update timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED17''
where event_config_id = 39 and status = ''PROCESSED16'';
commit;

---18
--------------------------------------------------------------------------------------------------------------------------------------
begin;
drop table if exists rch_service_provided_during_year_t;
create table rch_service_provided_during_year_t (
    location_id bigint,
    month_year date,
    financial_year text,
    anc_reg integer,
    anc_coverage integer,
    regd_live_children integer,
    regd_no_live_children integer,
    c1_m1 integer,
    c1_f1 integer,
    c2_f2 integer,
    c2_m2 integer,
    c2_f1_m1 integer,
    c3_f3 integer,
    c3_m3 integer,
    c3_m2_f1 integer,
    c3_m1_f2 integer,

    high_risk integer,
    current_preg_compl integer,
    severe_anemia integer,
    diabetes integer,
    cur_mal_presentation_issue bigint,
    cur_malaria_issue bigint,
    multipara bigint,
    blood_pressure integer,
    interval_bet_preg_less_18_months integer,
    extreme_age integer,
    height integer,
    weight  integer,
    urine_albumin integer,


    tt1 integer,
    tt2_tt_booster integer,
    early_anc integer,
    anc1 integer,
    anc2 integer,
    anc3 integer,
    anc4 integer,
    no_of_delivery integer,
    mtp integer,
    abortion integer,
    live_birth integer,
    still_birth integer,
    pnc1 integer,
    pnc2 integer,
    pnc3 integer,
    pnc4 integer,
    mother_death integer,
    ppiucd integer,

    complete_anc_date integer,
    ifa_180_anc_date integer,
	phi_del integer,
	phi_del_with_ppiucd integer,


    primary key (location_id, month_year)
);


with rch_service_yearly_pregnancy_reg as (
    select rprd.native_location_id as location_id,cast(date_trunc(''month'', rprd.reg_service_date) as date) as month_year,
    count(*) as anc_reg,
    sum(case when anc1 is not null and anc2 is not null and anc3 is not null and anc4 is not null then 1 else 0 end) as anc_coverage,
    sum(case when early_anc then 1 else 0 end) as early_anc,
    sum(case when high_risk_mother = true then 1 else 0 end) as high_risk,
    sum(case when any_cur_preg_complication then 1 else 0 end) as current_preg_compl,
    sum(case when cur_severe_anemia then 1 else 0 end) as severe_anemia,
    sum(case when cur_blood_pressure_issue then 1 else 0 end) as blood_pressure,
    sum(case when cur_gestational_diabetes_issue then 1 else 0 end) as diabetes,
    sum(case when cur_mal_presentation_issue then 1 else 0 end) as cur_mal_presentation_issue,
    sum(case when cur_malaria_issue then 1 else 0 end) as cur_malaria_issue,
    sum(case when total_out_come>=3 then 1 else 0 end) as multipara,
    sum(case when cur_extreme_age then 1 else 0 end) as extreme_age,
    sum(case when low_height then 1 else 0 end) as height,
    sum(case when cur_low_weight then 1 else 0 end) as weight,
    sum(case when urine_albumin then 1 else 0 end) as urine_albumin,
    sum(case when cur_less_than_18_month_interval then 1 else 0 end) interval_bet_preg_less_18_months,

    sum(case when registered_with_no_of_child > 0 then 1 else 0 end) as regd_live_children,
    sum(case when registered_with_no_of_child = 0 or registered_with_no_of_child is null then 1 else 0 end) as regd_no_live_children,
    sum(case when registered_with_no_of_child = 1 and registered_with_male_cnt = 1 then 1 else 0 end) as c1_m1,
    sum(case when registered_with_no_of_child = 1 and registered_with_female_cnt = 1 then 1 else 0 end) as c1_f1,
    sum(case when registered_with_no_of_child = 2 and registered_with_female_cnt = 2 then 1 else 0 end) as c2_f2,
    sum(case when registered_with_no_of_child = 2 and registered_with_male_cnt = 2 then 1 else 0 end) as c2_m2,
    sum(case when registered_with_no_of_child = 2 and registered_with_male_cnt = 1 and registered_with_female_cnt = 1 then 1 else 0 end) as c2_f1_m1,
    sum(case when registered_with_no_of_child = 3 and registered_with_female_cnt = 3 then 1 else 0 end) as c3_f3,
    sum(case when registered_with_no_of_child = 3 and registered_with_male_cnt = 3 then 1 else 0 end) as c3_m3,
    sum(case when registered_with_no_of_child = 3 and registered_with_male_cnt = 2 and registered_with_female_cnt = 1 then 1 else 0 end) as c3_m2_f1,
    sum(case when registered_with_no_of_child = 3 and registered_with_male_cnt = 1 and registered_with_female_cnt = 2 then 1 else 0 end) as c3_m1_f2,
	sum(case when ((institutional_del  and delivery_hospital in (''897'',''1062'',''899'',''1061'',''895'',''1009'',''890'',''1008'',''894'',''1063'',''892'',''891'',''1012'',''896'',''1007'',''1084''))
	or delivery_108)
	and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as phi_del,
	sum(case when ((institutional_del  and delivery_hospital in (''897'',''1062'',''899'',''1061'',''895'',''1009'',''890'',''1008'',''894'',''1063'',''892'',''891'',''1012'',''896'',''1007'',''1084''))
	or delivery_108)
	and delivery_outcome in (''LBIRTH'',''SBIRTH'') and ppiucd_insert_date is not null then 1 else 0 end) as phi_del_with_ppiucd

    from rch_pregnancy_analytics_details rprd
    where rprd.reg_service_date >= to_date(''01-04-2013'',''DD-MM-YYYY'')
    group by rprd.native_location_id,cast(date_trunc(''month'', rprd.reg_service_date) as date)
), rch_yearly_vacination_tt1 as (
    select rch_pregnancy_analytics_details.tt1_location_id as location_id
    ,cast(date_trunc(''month'', rch_pregnancy_analytics_details.tt1_given) as date) as month_year
    ,sum(1) as tt1
    from rch_pregnancy_analytics_details
    where rch_pregnancy_analytics_details.tt1_given >= to_date(''01-04-2013'',''DD-MM-YYYY'')
    group by rch_pregnancy_analytics_details.tt1_location_id, cast(date_trunc(''month'', rch_pregnancy_analytics_details.tt1_given) as date)
), rch_yearly_vacination_tt2_tt_booster as (
    select rch_pregnancy_analytics_details.tt2_tt_booster_location_id as location_id,
    cast(date_trunc(''month'', rch_pregnancy_analytics_details.tt2_tt_booster_given) as date) as month_year,
    sum(1) as tt2_tt_booster
    from rch_pregnancy_analytics_details
    where rch_pregnancy_analytics_details.tt2_tt_booster_given >= to_date(''01-04-2013'',''DD-MM-YYYY'')
    group by rch_pregnancy_analytics_details.tt2_tt_booster_location_id, cast(date_trunc(''month'', rch_pregnancy_analytics_details.tt2_tt_booster_given) as date)
), rch_yearly_anc1 as (
    select rch_pregnancy_analytics_details.anc1_location_id as location_id,
    cast(date_trunc(''month'', rch_pregnancy_analytics_details.anc1) as date) as month_year,
    sum(1) as anc1
    from rch_pregnancy_analytics_details
    where anc1 >= to_date(''01-04-2013'',''DD-MM-YYYY'')
    group by rch_pregnancy_analytics_details.anc1_location_id, cast(date_trunc(''month'', rch_pregnancy_analytics_details.anc1) as date)
), rch_yearly_anc2 as (
    select rch_pregnancy_analytics_details.anc2_location_id as location_id,
    cast(date_trunc(''month'', rch_pregnancy_analytics_details.anc2) as date) as month_year,
    sum(1) as anc2
    from rch_pregnancy_analytics_details
    where anc2 >= to_date(''01-04-2013'',''DD-MM-YYYY'')
    group by rch_pregnancy_analytics_details.anc2_location_id, cast(date_trunc(''month'', rch_pregnancy_analytics_details.anc2) as date)
), rch_yearly_anc3 as (
    select rch_pregnancy_analytics_details.anc3_location_id as location_id,
    cast(date_trunc(''month'', rch_pregnancy_analytics_details.anc3) as date) as month_year,
    sum(1) as anc3
    from rch_pregnancy_analytics_details
    where anc3 >= to_date(''01-04-2013'',''DD-MM-YYYY'')
    group by rch_pregnancy_analytics_details.anc3_location_id, cast(date_trunc(''month'', rch_pregnancy_analytics_details.anc3) as date)
), rch_yearly_anc4 as (
    select rch_pregnancy_analytics_details.anc4_location_id as location_id,
    cast(date_trunc(''month'', rch_pregnancy_analytics_details.anc4) as date) as month_year,
    sum(1) as anc4
    from rch_pregnancy_analytics_details
    where anc4 >= to_date(''01-04-2013'',''DD-MM-YYYY'')
    group by rch_pregnancy_analytics_details.anc4_location_id,cast(date_trunc(''month'', rch_pregnancy_analytics_details.anc4) as date)
), rch_wpd_anc_det as (
    select rprd.delivery_location_id as location_id
    ,cast(date_trunc(''month'', rprd.delivery_reg_date) as date) as month_year,
    sum(case when delivery_outcome in (''LBIRTH'',''SBIRTH'') and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as no_of_delivery,
    sum(case when delivery_outcome = ''MTP'' and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as mtp,
    sum(case when delivery_outcome in (''ABORTION'', ''SPONT_ABORTION'') and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as abortion,
    sum(case when (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then live_birth else 0 end) as live_birth,
    sum(case when (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then still_birth else 0 end) as still_birth
    from rch_pregnancy_analytics_details rprd
    where rprd.delivery_reg_date >= to_date(''01-04-2013'',''DD-MM-YYYY'')
    group by rprd.delivery_location_id,cast(date_trunc(''month'', rprd.delivery_reg_date) as date)
), rch_yearly_pnc1 as (
    select rch_pregnancy_analytics_details.pnc1_location_id as location_id,
    cast(date_trunc(''month'', rch_pregnancy_analytics_details.pnc1) as date) as month_year,
    sum(case when pnc1 >= to_date(''01-04-2013'',''DD-MM-YYYY'') then 1 else 0 end) as pnc1
    from rch_pregnancy_analytics_details
    where pnc1 >= to_date(''01-04-2013'',''DD-MM-YYYY'')
    group by rch_pregnancy_analytics_details.pnc1_location_id, cast(date_trunc(''month'', rch_pregnancy_analytics_details.pnc1) as date)
), rch_yearly_pnc2 as (
    select rch_pregnancy_analytics_details.pnc2_location_id as location_id,
    cast(date_trunc(''month'', rch_pregnancy_analytics_details.pnc2) as date) as month_year,
    sum(case when pnc2 >= to_date(''01-04-2013'',''DD-MM-YYYY'') then 1 else 0 end) as pnc2
    from rch_pregnancy_analytics_details
    where pnc2 >= to_date(''01-04-2013'',''DD-MM-YYYY'')
    group by rch_pregnancy_analytics_details.pnc2_location_id, cast(date_trunc(''month'', rch_pregnancy_analytics_details.pnc2) as date)
), rch_yearly_pnc3 as (
    select rch_pregnancy_analytics_details.pnc3_location_id as location_id,
    cast(date_trunc(''month'', rch_pregnancy_analytics_details.pnc3) as date) as month_year,
    sum(case when pnc3 >= to_date(''01-04-2013'',''DD-MM-YYYY'') then 1 else 0 end) as pnc3
    from rch_pregnancy_analytics_details
    where pnc3 >= to_date(''01-04-2013'',''DD-MM-YYYY'')
    group by rch_pregnancy_analytics_details.pnc3_location_id, cast(date_trunc(''month'', rch_pregnancy_analytics_details.pnc3) as date)
), rch_yearly_pnc4 as (
    select rch_pregnancy_analytics_details.pnc4_location_id as location_id,
    cast(date_trunc(''month'', rch_pregnancy_analytics_details.pnc4) as date) as month_year,
    sum(case when pnc4 >= to_date(''01-04-2013'',''DD-MM-YYYY'') then 1 else 0 end) as pnc4
    from rch_pregnancy_analytics_details
    where pnc4 >= to_date(''01-04-2013'',''DD-MM-YYYY'')
    group by rch_pregnancy_analytics_details.pnc4_location_id, cast(date_trunc(''month'', rch_pregnancy_analytics_details.pnc4) as date)
), rch_yearly_maternal_death_det as (
    select rch_pregnancy_analytics_details.death_location_id as location_id,
    cast(date_trunc(''month'', rch_pregnancy_analytics_details.death_date) as date) as month_year,
    count(*) as maternal_detah
    from rch_pregnancy_analytics_details
    where rch_pregnancy_analytics_details.death_date >= to_date(''01-04-2013'',''DD-MM-YYYY'')
    and rch_pregnancy_analytics_details.maternal_detah = true
    group by rch_pregnancy_analytics_details.death_location_id,cast(date_trunc(''month'', rch_pregnancy_analytics_details.death_date) as date)
), ppiucd_det as (
    select rch_pregnancy_analytics_details.ppiucd_insert_location as location_id,
    cast(date_trunc(''month'', rch_pregnancy_analytics_details.ppiucd_insert_date) as date) as month_year,
    count(*) filter (where delivery_hospital in (''897'',''1062'',''899'',''1061'',''895'',''1009'',''890'',''1008'',''894'',''1063'',''892'',''891'',''1012'',''896'',''1007'',''1084'')) as ppiucd
    from rch_pregnancy_analytics_details
    where rch_pregnancy_analytics_details.ppiucd_insert_date is not null and rch_pregnancy_analytics_details.institutional_del = true
    group by rch_pregnancy_analytics_details.ppiucd_insert_location,cast(date_trunc(''month'', rch_pregnancy_analytics_details.ppiucd_insert_date) as date)
), complete_anc_date_det as (
    select rch_pregnancy_analytics_details.complete_anc_location as location_id,
    cast(date_trunc(''month'', rch_pregnancy_analytics_details.complete_anc_date) as date) as month_year,
    sum(1) as complete_anc_date
    from rch_pregnancy_analytics_details
    where complete_anc_date >= to_date(''01-04-2013'',''DD-MM-YYYY'')
    group by rch_pregnancy_analytics_details.complete_anc_location, cast(date_trunc(''month'', rch_pregnancy_analytics_details.complete_anc_date) as date)
)
, ifa_180_anc_date_det as (
    select rch_pregnancy_analytics_details.ifa_180_anc_location as location_id,
    cast(date_trunc(''month'', rch_pregnancy_analytics_details.ifa_180_anc_date) as date) as month_year,
    sum(1) as ifa_180_anc_date
    from rch_pregnancy_analytics_details
    where ifa_180_anc_date >= to_date(''01-04-2013'',''DD-MM-YYYY'')
    group by rch_pregnancy_analytics_details.ifa_180_anc_location, cast(date_trunc(''month'', rch_pregnancy_analytics_details.ifa_180_anc_date) as date)
)

, locations as (
    select distinct location_id, month_year from (
    select location_id, month_year from rch_service_yearly_pregnancy_reg
    union
    select location_id, month_year from rch_yearly_vacination_tt1
    union
    select location_id, month_year from rch_yearly_vacination_tt2_tt_booster
    union
    select location_id, month_year from rch_yearly_anc1
    union
    select location_id, month_year from rch_yearly_anc2
    union
    select location_id, month_year from rch_yearly_anc3
    union
    select location_id, month_year from rch_yearly_anc4
    union
    select location_id, month_year from rch_wpd_anc_det
    union
    select location_id, month_year from rch_yearly_pnc1
    union
    select location_id, month_year from rch_yearly_pnc2
    union
    select location_id, month_year from rch_yearly_pnc3
    union
    select location_id, month_year from rch_yearly_pnc4
    union
    select location_id, month_year from rch_yearly_maternal_death_det
    union
    select location_id, month_year from ppiucd_det
    union
    select location_id, month_year from complete_anc_date_det
    union
    select location_id, month_year from ifa_180_anc_date_det
    ) as t where location_id is not null
)
insert into rch_service_provided_during_year_t (
    location_id,month_year,financial_year,anc_reg, anc_coverage,

    regd_live_children,regd_no_live_children,c1_m1,c1_f1,c2_f2,c2_m2,c2_f1_m1,c3_f3,c3_m3,c3_m2_f1,c3_m1_f2,phi_del,phi_del_with_ppiucd

    ,high_risk,current_preg_compl,severe_anemia,diabetes,
    cur_mal_presentation_issue,cur_malaria_issue,multipara,
    blood_pressure,interval_bet_preg_less_18_months,extreme_age,
    height,weight,urine_albumin,

    tt1,tt2_tt_booster,
    early_anc,anc1,anc2,anc3,anc4,
    no_of_delivery,mtp,abortion,live_birth,still_birth,
    pnc1,pnc2,pnc3,pnc4,mother_death
    ,ppiucd
    ,complete_anc_date
    ,ifa_180_anc_date

)
select locations.location_id, locations.month_year
,case when extract(month from locations.month_year) > 3
    then concat(extract(year from locations.month_year), ''-'', extract(year from locations.month_year) + 1)
    else concat(extract(year from locations.month_year) - 1, ''-'', extract(year from locations.month_year)) end as financial_year
,rch_service_yearly_pregnancy_reg.anc_reg
,rch_service_yearly_pregnancy_reg.anc_coverage
,rch_service_yearly_pregnancy_reg.regd_live_children
,rch_service_yearly_pregnancy_reg.regd_no_live_children
,rch_service_yearly_pregnancy_reg.c1_m1
,rch_service_yearly_pregnancy_reg.c1_f1
,rch_service_yearly_pregnancy_reg.c2_f2
,rch_service_yearly_pregnancy_reg.c2_m2
,rch_service_yearly_pregnancy_reg.c2_f1_m1
,rch_service_yearly_pregnancy_reg.c3_f3
,rch_service_yearly_pregnancy_reg.c3_m3
,rch_service_yearly_pregnancy_reg.c3_m2_f1
,rch_service_yearly_pregnancy_reg.c3_m1_f2
,rch_service_yearly_pregnancy_reg.phi_del
,rch_service_yearly_pregnancy_reg.phi_del_with_ppiucd

,rch_service_yearly_pregnancy_reg.high_risk,current_preg_compl
,rch_service_yearly_pregnancy_reg.severe_anemia,diabetes
,rch_service_yearly_pregnancy_reg.cur_mal_presentation_issue
,rch_service_yearly_pregnancy_reg.cur_malaria_issue
,rch_service_yearly_pregnancy_reg.multipara
,rch_service_yearly_pregnancy_reg.blood_pressure
,rch_service_yearly_pregnancy_reg.interval_bet_preg_less_18_months
,rch_service_yearly_pregnancy_reg.extreme_age
,rch_service_yearly_pregnancy_reg.height
,rch_service_yearly_pregnancy_reg.weight
,rch_service_yearly_pregnancy_reg.urine_albumin

,rch_yearly_vacination_tt1.tt1,
rch_yearly_vacination_tt2_tt_booster.tt2_tt_booster,
rch_service_yearly_pregnancy_reg.early_anc,
rch_yearly_anc1.anc1,
rch_yearly_anc2.anc2,
rch_yearly_anc3.anc3,
rch_yearly_anc4.anc4,
rch_wpd_anc_det.no_of_delivery,
rch_wpd_anc_det.mtp,
rch_wpd_anc_det.abortion,
rch_wpd_anc_det.live_birth,
rch_wpd_anc_det.still_birth,
rch_yearly_pnc1.pnc1,
rch_yearly_pnc2.pnc2,
rch_yearly_pnc3.pnc3,
rch_yearly_pnc4.pnc4,
rch_yearly_maternal_death_det.maternal_detah,
ppiucd_det.ppiucd,
complete_anc_date_det.complete_anc_date,
ifa_180_anc_date_det.ifa_180_anc_date
from locations
left join rch_service_yearly_pregnancy_reg on rch_service_yearly_pregnancy_reg.location_id = locations.location_id
    and rch_service_yearly_pregnancy_reg.month_year = locations.month_year
left join rch_yearly_vacination_tt1 on rch_yearly_vacination_tt1.location_id = locations.location_id
    and rch_yearly_vacination_tt1.month_year = locations.month_year
left join rch_yearly_vacination_tt2_tt_booster on rch_yearly_vacination_tt2_tt_booster.location_id = locations.location_id
    and rch_yearly_vacination_tt2_tt_booster.month_year = locations.month_year
left join rch_yearly_anc1 on rch_yearly_anc1.location_id = locations.location_id
    and rch_yearly_anc1.month_year = locations.month_year
left join rch_yearly_anc2 on rch_yearly_anc2.location_id = locations.location_id
    and rch_yearly_anc2.month_year = locations.month_year
left join rch_yearly_anc3 on rch_yearly_anc3.location_id = locations.location_id
    and rch_yearly_anc3.month_year = locations.month_year
left join rch_yearly_anc4 on rch_yearly_anc4.location_id = locations.location_id
    and rch_yearly_anc4.month_year = locations.month_year
left join rch_wpd_anc_det on rch_wpd_anc_det.location_id = locations.location_id
    and rch_wpd_anc_det.month_year = locations.month_year
left join rch_yearly_pnc1 on rch_yearly_pnc1.location_id = locations.location_id
    and rch_yearly_pnc1.month_year = locations.month_year
left join rch_yearly_pnc2 on rch_yearly_pnc2.location_id = locations.location_id
    and rch_yearly_pnc2.month_year = locations.month_year
left join rch_yearly_pnc3 on rch_yearly_pnc3.location_id = locations.location_id
    and rch_yearly_pnc3.month_year = locations.month_year
left join rch_yearly_pnc4 on rch_yearly_pnc4.location_id = locations.location_id
    and rch_yearly_pnc4.month_year = locations.month_year
left join rch_yearly_maternal_death_det on rch_yearly_maternal_death_det.location_id = locations.location_id
    and rch_yearly_maternal_death_det.month_year = locations.month_year
left join ppiucd_det on ppiucd_det.location_id = locations.location_id
    and ppiucd_det.month_year = locations.month_year
left join complete_anc_date_det on complete_anc_date_det.location_id = locations.location_id
    and complete_anc_date_det.month_year = locations.month_year
left join ifa_180_anc_date_det on ifa_180_anc_date_det.location_id = locations.location_id
    and ifa_180_anc_date_det.month_year = locations.month_year;

update timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED18''
where event_config_id = 39 and status = ''PROCESSED17'';
commit;

begin;

drop table if exists rch_lmp_base_location_wise_data_point;
ALTER TABLE rch_lmp_base_location_wise_data_point_t
  RENAME TO rch_lmp_base_location_wise_data_point;

---21
drop table if exists rch_delivery_date_base_location_wise_data_point;
ALTER TABLE rch_delivery_date_base_location_wise_data_point_t
  RENAME TO rch_delivery_date_base_location_wise_data_point;

---22
drop table if exists rch_yearly_location_wise_analytics_data;
ALTER TABLE rch_yearly_location_wise_analytics_data_t
  RENAME TO rch_yearly_location_wise_analytics_data;

---23
drop table if exists rch_current_state_pregnancy_analytics_data;
ALTER TABLE rch_current_state_pregnancy_analytics_data_t
  RENAME TO rch_current_state_pregnancy_analytics_data;

---24
drop table if exists rch_service_provided_during_year;
ALTER TABLE rch_service_provided_during_year_t
  RENAME TO rch_service_provided_during_year;

update system_configuration set key_value = TO_CHAR(current_date, ''MM-DD-YYYY'')
where system_key = ''rch_pregnancy_analytics_last_schedule_date'';

update system_configuration set key_value = ''false''
where system_key = ''rch_pregnancy_analytics_run_for_all_pregnancy'';

update timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED19''
where event_config_id = 39 and status = ''PROCESSED18'';

commit;

begin;
drop table if exists rch_anemia_status_analytics_t;
create table rch_anemia_status_analytics_t(
location_id integer,
month_year date,
anc_reg integer,
anc_with_hb integer,
anc_with_hb_more_than_4 integer,
mild_hb integer,
modrate_hb integer,
severe_hb integer,
normal_hb integer,
severe_hb_with_iron_def_inj integer,
severe_hb_with_blood_transfusion integer,
primary key (location_id,month_year)
);

insert into rch_anemia_status_analytics_t(
location_id
,month_year
,anc_reg
,anc_with_hb
,anc_with_hb_more_than_4
,mild_hb
,modrate_hb
,severe_hb
,normal_hb
,severe_hb_with_iron_def_inj
,severe_hb_with_blood_transfusion
)
select
rprd.native_location_id as location_id
,cast(date_trunc(''month'', rprd.reg_service_date) as date) as month_year
,count(*) as anc_reg
,count(1) filter(where hb >= 0.1) as anc_with_hb
,count(1) filter(where haemoglobin_tested_count >= 4) as anc_with_hb_more_than_4
,count(1) filter(where hb between 10 and 10.99) as mild_hb
,count(1) filter(where hb between 7 and 9.99) as modrate_hb
,count(1) filter(where hb between 0.1 and 6.99) as severe_hb
,count(1) filter(where hb >= 11) as normal_hb
,count(1) filter(where hb between 0.1 and 6.99 and iron_def_anemia_inj is not null) as severe_hb_with_iron_def_inj
,count(1) filter(where hb between 0.1 and 6.99 and blood_transfusion) as severe_hb_with_blood_transfusion
from rch_pregnancy_analytics_details rprd
group by rprd.native_location_id,cast(date_trunc(''month'', rprd.reg_service_date) as date);

drop table if exists rch_anemia_status_analytics;
ALTER TABLE rch_anemia_status_analytics_t
  RENAME TO rch_anemia_status_analytics;

update timer_event SET completed_on = clock_timestamp(),status = ''COMPLETED''
where event_config_id = 39 and status = ''PROCESSED19'';

commit;', null, 'IMMEDIATELY', 'QUERY', null, null, null, null, null, null, null, null);

INSERT INTO SYNC_SYSTEM_CONFIGURATION_MASTER(feature_type, config_json, created_on, created_by, feature_uuid, feature_name)
VALUES (
'EVENT_BUILDER', '{"id":39,"name":"Update Data for Pregnancy Analytics","description":"This will do an all count related to the maternal report.","eventType":"TIMMER_BASED","eventTypeDetailId":null,"formTypeId":null,"eventTypeDetailCode":null,"trigerWhen":"DAILY","day":null,"hour":2,"minute":0,"state":"ACTIVE","createdBy":1027,"createdOn":1719909228670,"notificationConfigDetails":[{"query":"select 1;","queryParam":null,"conditions":[{"isConditionReq":false,"condition":null,"conditionParam":null,"description":null,"notificaitonConfigsType":[{"id":"8fb48344-84d1-4c23-ab76-54193ed3ae02","type":"QUERY","template":"begin;\n---1\ndrop table if exists t_pregnancy_registration_det;\ncreate table t_pregnancy_registration_det\n(\n\tpregnancy_reg_id bigint primary key,\n\tmember_id bigint,\n\tunique_health_id text,\n\tdob date,\n\tfamily_id text,\n\tmember_name text,\n\tmobile_number text,\n\treg_service_date date,\n\treg_service_date_month_year date,\n\treg_service_financial_year text,\n\treg_server_date timestamp without time zone,\n\tpregnancy_reg_location_id bigint,\n\tnative_location_id integer,\n\t\n\ttracking_location_id integer,\n\tis_valid_for_tracking_report boolean,\n\t\n\tpregnancy_reg_family_id bigint,\n\tpreg_reg_state text,\n\tmember_basic_state text,\n\tmember_state text,\n\t\n\tfamily_basic_state text,\n\tmarital_status integer,\n\taddress text,\n\thusband_name text,\n\thusband_mobile_number text,\n\thof_name text,\n\thof_mobile_number text,\n\t\n\tlmp_date date,\n\tlmp_month_year date,\n\tlmp_financial_year text,\n\tedd date,\n\tdate_of_delivery date,\n\tdate_of_delivery_month_year date,\n\tdelivery_reg_date date,\n\tdelivery_reg_date_financial_year text,\n\tdelivery_location_id bigint,\n\tdelivery_family_id bigint,\n\tmember_current_location_id bigint,\n\tage_during_delivery smallint,\n\tregistered_with_no_of_child smallint,\n\tregistered_with_male_cnt smallint,\n\tregistered_with_female_cnt smallint,\n\tanc1 date,\n\tanc1_location_id integer,\n\tanc2 date,\n\tanc2_location_id integer,\n\tanc3 date,\n\tanc3_location_id integer,\n\tanc4 date,\n\tanc4_location_id integer,\n\tlast_systolic_bp integer,\n\tlast_diastolic_bp integer,\n\ttotal_regular_anc smallint,\n\ttt1_given date,\n\ttt1_location_id integer,\n\ttt2_given date,\n\ttt2_location_id integer,\n\ttt_boster date,\n\ttt_booster_location_id integer,\n\ttt2_tt_booster_given date,\n\ttt2_tt_booster_location_id integer,\n\tearly_anc boolean,\n\ttotal_anc smallint,\n\t\n\tcomplete_anc_date date,\n\tcomplete_anc_location integer,\n\t\n\t\n\tifa integer,\n\t\n\tifa_180_anc_date date,\n\tifa_180_anc_location integer,\n\t\n\tfa_tab_in_30_day integer,\n\tfa_tab_in_31_to_60_day integer,\n\tfa_tab_in_61_to_90_day integer,\n\tifa_tab_in_4_month_to_9_month integer,\n\thb real,\n\thb_date date,\n\thb_between_90_to_360_days real,\n\ttotal_ca integer,\n\tca_tab_in_91_to_180_day integer,\n\tca_tab_in_181_to_360_day integer,\n\texpected_delivery_place text,\n\t\n\tL2L_Preg_Complication text,\n\tOutcome_L2L_Preg text,\n\tL2L_Preg_Complication_Length smallint,\n\tOutcome_Last_Preg integer,\n\t\n\t\n\talben_given boolean,\n\tmaternal_detah boolean,\n\tmaternal_death_type text,\n\tdeath_date date,\n\tdeath_location_id integer,\n\t\n\tlow_height boolean,\n\turine_albumin boolean,\n\t\n\tsystolic_bp smallint,\n\tdiastolic_bp smallint,\n\tprev_pregnancy_date date,\n\tprev_preg_diff_in_month smallint,\n\tgravida smallint,\n\n\tany_chronic_dis boolean,\n\thigh_risk_mother boolean,\n\t\n\tpre_preg_anemia boolean,\n\tpre_preg_caesarean_section boolean,\n\tpre_preg_aph boolean,\n\tpre_preg_pph boolean,\n\tpre_preg_pre_eclampsia boolean,\n\tpre_preg_abortion boolean,\n\tpre_preg_obstructed_labour boolean,\n\tpre_preg_placenta_previa boolean,\n\tpre_preg_malpresentation  boolean,\n\tpre_preg_birth_defect boolean,\n\tpre_preg_preterm_delivery boolean,\n\tany_prev_preg_complication boolean,\n\t\n\tchro_tb boolean,\n\tchro_diabetes boolean,\n\tchro_heart_kidney boolean,\n\tchro_hiv boolean,\n\tchro_sickle boolean,\n\tchro_thalessemia boolean,\n\t\n\tcur_extreme_age boolean,\n\tcur_low_weight boolean,\n\tcur_severe_anemia boolean,\n\tcur_blood_pressure_issue boolean,\n\tcur_urine_protein_issue boolean,\n\tcur_convulsion_issue boolean,\n\tcur_malaria_issue boolean,\n\tcur_social_vulnerability boolean,\n\tcur_gestational_diabetes_issue boolean,\n\tcur_twin_pregnancy boolean,\n\tcur_mal_presentation_issue boolean,\n\tcur_absent_reduce_fetal_movment boolean,\n\tcur_less_than_18_month_interval boolean,\n\tcur_aph_issue boolean,\n\tcur_pelvic_sepsis boolean,\n\tcur_hiv_issue boolean,\n\tcur_vdrl_issue boolean,\n\tcur_hbsag_issue boolean,\n\tcur_brethless_issue boolean,\n\tany_cur_preg_complication boolean,\n\t\n\thigh_risk_cnt smallint,\n\thbsag_test_cnt smallint,\n\thbsag_reactive_cnt smallint,\n\thbsag_non_reactive_cnt smallint,\n\t\n\tdelivery_outcome text,\n\ttype_of_delivery text,\n\thome_del boolean,\n\tinstitutional_del boolean,\n\tdelivery_108 boolean,\n    \n    delivery_out_of_state_govt boolean,\n    delivery_out_of_state_pvt boolean,\n\n    delivery_place text,\n\tbreast_feeding_in_one_hour boolean,\n\tdelivery_hospital text,\n\tdelivery_health_infrastructure integer, \n\tdel_week smallint,\n\tis_cortico_steroid boolean,\n\tmother_alive boolean,\n\ttotal_out_come smallint,\n\tmale smallint,\n\tfemale smallint,\n\t\n\tstill_birth smallint,\n\tlive_birth smallint,\n\t\n\t\n\tdelivery_done_by text,\n\tpnc1 date,\n\tpnc1_location_id integer,\n\tpnc2 date,\n\tpnc2_location_id integer,\n\tpnc3 date,\n\tpnc3_location_id integer,\n\tpnc4 date,\n\tpnc4_location_id integer,\n    pnc5 date,\n    pnc5_location_id integer,\n    pnc6 date,\n    pnc6_location_id integer,\n\tpnc7 date,\n\tpnc7_location_id integer,\n\n\t\n\tifa_tab_after_delivery smallint,\n\t\n\thaemoglobin_tested_count integer,\n\tiron_def_anemia_inj text,\n\tblood_transfusion boolean,\n\t\n\tppiucd_insert_date date,\n\tppiucd_insert_location integer,\n\n\thigh_risk_reasons text,\n\t\n\tis_fru boolean\n);\n\n\ndelete from rch_pregnancy_analytics_details where pregnancy_reg_id in (\nselect rpa.pregnancy_reg_id\nfrom rch_pregnancy_analytics_details rpa\nleft join imt_member m on rpa.member_id = m.id and m.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'',''DEAD'',''TEMPORARY'',''MIGRATED'')\n--left join imt_family f on m.family_id = f.family_id and f.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'',''TEMPORARY'',''MIGRATED'')\nwhere  m.id is null\n--or f.id is null\n) and (select cast(key_value as boolean) as value from system_configuration where system_key = ''rch_pregnancy_analytics_run_for_all_pregnancy'' ) = false;\n\ndelete from rch_pregnancy_analytics_details where pregnancy_reg_id in (\nselect rpa.pregnancy_reg_id\nfrom rch_pregnancy_analytics_details rpa\nleft join imt_family f on rpa.family_id = f.family_id and f.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'',''TEMPORARY'',''MIGRATED'')\nwhere \nf.id is null\n) and (select cast(key_value as boolean) as value from system_configuration where system_key = ''rch_pregnancy_analytics_run_for_all_pregnancy'' ) = false;\n\ndelete from rch_pregnancy_analytics_details where pregnancy_reg_id in (\nselect rpa.pregnancy_reg_id\nfrom rch_pregnancy_analytics_details rpa\nleft join rch_pregnancy_registration_det rpr on rpr.id = rpa.pregnancy_reg_id and rpr.state in (''DELIVERY_DONE'',''PENDING'',''PREGNANT'')\nwhere rpr.id is null\n)and (select cast(key_value as boolean) as value from system_configuration where system_key = ''rch_pregnancy_analytics_run_for_all_pregnancy'' ) = false;\n\n\nwith parameter as (\nselect \n(select to_date(key_value,''MM-DD-YYYY'') as  from_date from system_configuration  where system_key = ''rch_pregnancy_analytics_last_schedule_date'') as from_date\n,(select cast(key_value as boolean) as value from system_configuration where system_key = ''rch_pregnancy_analytics_run_for_all_pregnancy'') as run_for_all_pregnancy\n), member_det as (\nselect imt_member.id as member_id \nfrom imt_member,rch_pregnancy_registration_det rpa,parameter,imt_family f\nwhere rpa.member_id = imt_member.id\nand f.family_id = imt_member.family_id\n--and  imt_member.modified_on >= (select to_date(key_value,''MM-DD-YYYY'') as  from_date from system_configuration  where system_key = ''rch_pregnancy_analytics_last_schedule_date'') \n--and  imt_member.modified_on >= current_date - interval ''2 day'' \nand f.modified_on >= current_date - interval ''2 day'' \nand parameter.run_for_all_pregnancy = false\nunion\nselect member_id from rch_pregnancy_registration_det,parameter \nwhere parameter.run_for_all_pregnancy = true \n--or modified_on >= (select to_date(key_value,''MM-DD-YYYY'') as  from_date from system_configuration  where system_key = ''rch_pregnancy_analytics_last_schedule_date'')\nor modified_on >= current_date - interval ''2 day'' \nunion\nselect member_id from rch_lmp_follow_up ,parameter\n--where modified_on >= (select to_date(key_value,''MM-DD-YYYY'') as  from_date from system_configuration  where system_key = ''rch_pregnancy_analytics_last_schedule_date'') \nwhere modified_on >= current_date - interval ''2 day'' \nand parameter.run_for_all_pregnancy = false\nunion\nselect member_id from rch_anc_master ,parameter\n--where modified_on >= (select to_date(key_value,''MM-DD-YYYY'') as  from_date from system_configuration  where system_key = ''rch_pregnancy_analytics_last_schedule_date'') \nwhere modified_on >= current_date - interval ''2 day''  \nand parameter.run_for_all_pregnancy = false\nunion\nselect member_id from rch_wpd_mother_master,parameter\n--where modified_on >= (select to_date(key_value,''MM-DD-YYYY'') as  from_date from system_configuration  where system_key = ''rch_pregnancy_analytics_last_schedule_date'') \nwhere modified_on >= current_date - interval ''2 day'' \nand parameter.run_for_all_pregnancy = false\nunion\nselect member_id from rch_pnc_master ,parameter\n--where modified_on >= (select to_date(key_value,''MM-DD-YYYY'') as  from_date from system_configuration  where system_key = ''rch_pregnancy_analytics_last_schedule_date'') \nwhere modified_on >= current_date - interval ''2 day'' \nand parameter.run_for_all_pregnancy = false\n)\ninsert into t_pregnancy_registration_det(\n\tpregnancy_reg_id,member_id,unique_health_id,dob,family_id,member_name,mobile_number,reg_service_date,reg_service_date_month_year,reg_service_financial_year,\n\treg_server_date,pregnancy_reg_location_id,native_location_id,lmp_date,lmp_month_year,lmp_financial_year,edd,preg_reg_state,member_basic_state\n\t,early_anc,is_valid_for_tracking_report, family_basic_state, marital_status, address, husband_name, husband_mobile_number\n\t, hof_name, hof_mobile_number\n)\nselect rch_pregnancy_registration_det.id,\nrch_pregnancy_registration_det.member_id,\nimt_member.unique_health_id,\nimt_member.dob,\nimt_member.family_id,\nconcat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name),\nimt_member.mobile_number,\nreg_date,\ncast(date_trunc(''month'', reg_date) as date),\ncase when extract(month from reg_date) > 3 \n\tthen concat(extract(year from reg_date), ''-'', extract(year from reg_date) + 1)\n\telse concat(extract(year from reg_date) - 1, ''-'', extract(year from reg_date)) end,\nrch_pregnancy_registration_det.created_on,\nrch_pregnancy_registration_det.location_id,\nrch_pregnancy_registration_det.location_id,\nrch_pregnancy_registration_det.lmp_date,\ncast(date_trunc(''month'', rch_pregnancy_registration_det.lmp_date) as date),\ncase when extract(month from rch_pregnancy_registration_det.lmp_date) > 3 \n\tthen concat(extract(year from rch_pregnancy_registration_det.lmp_date), ''-'', extract(year from rch_pregnancy_registration_det.lmp_date) + 1)\n\telse concat(extract(year from rch_pregnancy_registration_det.lmp_date) - 1, ''-'', extract(year from rch_pregnancy_registration_det.lmp_date)) end,\nrch_pregnancy_registration_det.edd as edd,\nrch_pregnancy_registration_det.state as preg_reg_state,\nimt_member.basic_state as member_basic_state,\ncase when rch_pregnancy_registration_det.lmp_date + interval ''84 days'' >= rch_pregnancy_registration_det.reg_date then true else false end,\ncase when (imt_family.state in (''com.argusoft.imtecho.family.state.archived.temporary'',''com.argusoft.imtecho.family.state.archived.temporary.outofstate'', ''com.argusoft.imtecho.family.state.migrated.outofstate'') \n\tor imt_member.state in (''com.argusoft.imtecho.member.state.migrated.lfu'',''com.argusoft.imtecho.member.state.migrated.outofstate'',''com.argusoft.imtecho.member.state.archived.outofstate''))\n\tthen false else true end,\nimt_family.basic_state as family_basic_state,\nimt_member.marital_status as marital_status,\nconcat_ws('', '',imt_family.address1,imt_family.address2) as address,\nconcat_ws('' '', husband.first_name, husband.middle_name, husband.last_name) as husband_name,\nhusband.mobile_number as husband_mobile_number,\nconcat_ws('' '', hof.first_name, hof.middle_name, hof.last_name) as hof_name,\nhof.mobile_number as hof_mobile_number\n\nfrom member_det inner join\nrch_pregnancy_registration_det on member_det.member_id = rch_pregnancy_registration_det.member_id\ninner join imt_member on rch_pregnancy_registration_det.member_id = imt_member.id \nand imt_member.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'',''DEAD'',''TEMPORARY'',''MIGRATED'')\ninner join imt_family on imt_member.family_id = imt_family.family_id\nand imt_family.basic_state in(''VERIFIED'',''REVERIFICATION'',''NEW'',''TEMPORARY'',''MIGRATED'')\nleft join imt_member husband on imt_member.husband_id = husband.id\nleft join imt_member hof on imt_family.hof_id = hof.id\nwhere \nrch_pregnancy_registration_det.state in (''DELIVERY_DONE'',''PENDING'',''PREGNANT'');\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED1''\nwhere event_config_id = 39 and status = ''PROCESSED'';\ncommit;\n---2\nbegin;\nwith rch_anc_det as(\nselect rch_anc_master.*,sum(ifa_tablets_given)OVER(PARTITION BY rch_anc_master.pregnancy_reg_det_id ORDER BY rch_anc_master.service_date) as total_ifa_tab\nfrom rch_anc_master,t_pregnancy_registration_det\nwhere rch_anc_master.pregnancy_reg_det_id = t_pregnancy_registration_det.pregnancy_reg_id\nand rch_anc_master.member_status = ''AVAILABLE''\n)\nupdate t_pregnancy_registration_det \nset anc1 = (case when t.anc1 is not null then t.anc1\n\t\t\t\twhen t.anc2 is not null then t.anc2\n\t\t\t\twhen t.anc3 is not null then t.anc3\n\t\t\t\twhen t.anc4 is not null then t.anc4\n\t\t\tend)\t\t\t\t\n, anc1_location_id = (case when t.anc1 is not null then t.anc1_location_id\n\t\t\t\twhen t.anc2 is not null then t.anc2_location_id\n\t\t\t\twhen t.anc3 is not null then t.anc3_location_id\n\t\t\t\twhen t.anc4 is not null then t.anc4_location_id\n\t\t\tend)\n, anc2 = (case \twhen t.anc2 is not null and t.anc1 is not null then t.anc2\n\t\t\t\twhen t.anc3 is not null and (t.anc1 is not null or t.anc2 is not null) then t.anc3\n\t\t\t\twhen t.anc4 is not null and (t.anc1 is not null or t.anc2 is not null or t.anc3 is not null) then t.anc4\n\t\t\tend)\n, anc2_location_id = (case \twhen t.anc2 is not null and t.anc1 is not null then t.anc2_location_id\n\t\t\t\twhen t.anc3 is not null and (t.anc1 is not null or t.anc2 is not null) then t.anc3_location_id\n\t\t\t\twhen t.anc4 is not null and (t.anc1 is not null or t.anc2 is not null or t.anc3 is not null) then t.anc4_location_id\n\t\t\tend)\n, anc3 = (case \twhen t.anc3 is not null and (t.anc1 is not null and t.anc2 is not null) then t.anc3\n\t\t\t\twhen t.anc4 is not null and ((case when t.anc1 is not null then 1 else 0 end)\n\t\t\t\t\t\t\t\t\t\t\t+(case when t.anc2 is not null then 1 else 0 end)\n\t\t\t\t\t\t\t\t\t\t\t+(case when t.anc3 is not null then 1 else 0 end)) = 2 then t.anc4\n\t\t\t\t\t\t\t\t\t\t\t\n\t\t\tend)\n, anc3_location_id = (case \twhen t.anc3 is not null and (t.anc1 is not null and t.anc2 is not null) then t.anc3_location_id\n\t\t\t\twhen t.anc4 is not null and ((case when t.anc1 is not null then 1 else 0 end)\n\t\t\t\t\t\t\t\t\t\t\t+(case when t.anc2 is not null then 1 else 0 end)\n\t\t\t\t\t\t\t\t\t\t\t+(case when t.anc3 is not null then 1 else 0 end)) = 2 then t.anc4_location_id\n\t\t\t\t\t\t\t\t\t\t\t\n\t\t\tend)\n, anc4 = (case when t.anc4 is not null and t.anc1 is not null and t.anc2 is not null and t.anc3 is not null then t.anc4 end)\n, anc4_location_id = (case when t.anc4 is not null and t.anc1 is not null and t.anc2 is not null and t.anc3 is not null then t.anc4_location_id end)\n--, early_anc = case when t.early_reg = 1 then true else false end\n, alben_given = case when t.alben_given = 1 then true else false end,\nifa = t.ifa_tablets_given\n,ifa_180_anc_date = t.ifa_180_anc_date\n,ifa_180_anc_location = t.ifa_180_anc_location\n, total_anc = t.total_anc\n, fa_tab_in_30_day = t.fa_tab_in_30_day\n, fa_tab_in_31_to_60_day = t.fa_tab_in_31_to_60_day\n, fa_tab_in_61_to_90_day = t.fa_tab_in_61_to_90_day\n, ifa_tab_in_4_month_to_9_month = t.ifa_tab_in_4_month_to_9_month\n, ca_tab_in_91_to_180_day = t.ca_tab_in_91_to_180_day\n, ca_tab_in_181_to_360_day = t.ca_tab_in_181_to_360_day\n, hb = t.hb\n, hb_date = t.hb_date\n, haemoglobin_tested_count = t.haemoglobin_tested_count\n, total_ca = t.total_ca\n, expected_delivery_place = t.expected_delivery_place\n, hb_between_90_to_360_days = t.hb_between_90_to_360_days\n,hbsag_test_cnt = t.hbsag_test_cnt\n,hbsag_reactive_cnt = t.hbsag_reactive_cnt\n,hbsag_non_reactive_cnt = case when t.hbsag_test_cnt = 1 and t.hbsag_reactive_cnt = 0 then 1 else 0 end \n,iron_def_anemia_inj = t.iron_def_anemia_inj\n,blood_transfusion = case when t.blood_transfusion = 1 then true else false end\n,last_systolic_bp = t.systolic_bp\n,last_diastolic_bp = t.diastolic_bp\nfrom(\n\tselect t1.pregnancy_reg_det_id,t1.anc1,t1.anc2,t1.anc3,t1.anc4,t1.alben_given\n\t,t1.ifa_tablets_given,ifa_180_anc.service_date as ifa_180_anc_date,ifa_180_anc.location_id as ifa_180_anc_location\n\t,t1.total_anc\n\t,anc_master1.location_id as anc1_location_id,anc_master2.location_id as anc2_location_id\n\t,anc_master3.location_id as anc3_location_id,anc_master4.location_id as anc4_location_id\n\t,anc_systolic_bp.systolic_bp,anc_diastolic_bp.diastolic_bp\n\t,t1.fa_tab_in_30_day,t1.fa_tab_in_31_to_60_day,t1.fa_tab_in_61_to_90_day\n\t,t1.ifa_tab_in_4_month_to_9_month,anc_hb.haemoglobin_count as hb,anc_hb.service_date as hb_date\n\t,t1.haemoglobin_tested_count,t1.hb_between_90_to_360_days,t1.total_ca,t1.ca_tab_in_91_to_180_day\n\t,t1.ca_tab_in_181_to_360_day,t1.expected_delivery_place\n\t,t1.hbsag_test_cnt,t1.hbsag_reactive_cnt\n\t,iron_def_anemia_inj_det.iron_def_anemia_inj,t1.blood_transfusion\n\tfrom (\n\tselect rch_anc_master.pregnancy_reg_det_id,\n\tmin(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 0 and 84 then rch_anc_master.service_date else null end) anc1,\n\tmin(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 0 and 84 then rch_anc_master.id else null end) anc1_id,\n\tmin(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 85 and 182 then rch_anc_master.service_date else null end) anc2,\n\tmin(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 85 and 182 then rch_anc_master.id else null end) anc2_id,\n\tmin(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 183 and 238 then rch_anc_master.service_date else null end) anc3,\n\tmin(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 183 and 238 then rch_anc_master.id else null end) anc3_id,\n\tmin(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date >= 239 then rch_anc_master.service_date else null end) anc4,\n\tmin(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date >= 239 then rch_anc_master.id else null end) anc4_id,\n\t--max(case when t_pregnancy_registration_det.lmp_date + interval ''84 days'' > t_pregnancy_registration_det.reg_service_date then 1 else 0 end) early_reg,\n\tmax(case when rch_anc_master.systolic_bp is not null then rch_anc_master.id else null end) as systolic_bp,\n\tmax(case when rch_anc_master.diastolic_bp is not null then rch_anc_master.id else null end) as diastolic_bp,\n\tmax(case when albendazole_given then 1 else 0 end) as alben_given,\n\tsum(ifa_tablets_given) as ifa_tablets_given,\n\tsum(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 0 and 30 then fa_tablets_given else 0 end) as fa_tab_in_30_day,\n\tsum(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 31 and 60 then fa_tablets_given else 0 end) as fa_tab_in_31_to_60_day,\n\tsum(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 61 and 90 then fa_tablets_given else 0 end) as fa_tab_in_61_to_90_day,\n\tsum(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 90 and 270 then ifa_tablets_given else 0 end) as ifa_tab_in_4_month_to_9_month,\n\tmax(case when haemoglobin_count is not null then rch_anc_master.id else null end ) as hb,\n\tsum(case when haemoglobin_count is not null then 1 else 0 end )  as haemoglobin_tested_count,\n\tmax(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 90 and 360 then haemoglobin_count else 0 end) as hb_between_90_to_360_days,\n\tsum(calcium_tablets_given) as total_ca,\n\tsum(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 91 and 180 then calcium_tablets_given else 0 end) as ca_tab_in_91_to_180_day,\n\tsum(case when cast(rch_anc_master.service_date as date) - t_pregnancy_registration_det.lmp_date between 181 and 360 then calcium_tablets_given else 0 end) as ca_tab_in_181_to_360_day,\n\tmax(rch_anc_master.expected_delivery_place) as expected_delivery_place,\n\tmax(case when rch_anc_master.hbsag_test is not null then 1 else 0 end) as hbsag_test_cnt,\n\tmax(case when rch_anc_master.hbsag_test = ''REACTIVE'' then 1 else 0 end) as hbsag_reactive_cnt,\n\tmax(case when rch_anc_master.iron_def_anemia_inj in (''FCM'',''IRON_SUCROSE'') then rch_anc_master.id else null end) as iron_def_anemia_inj_anc_id,\n\tmax(case when rch_anc_master.blood_transfusion = true then 1 else 0 end) as blood_transfusion,\n\tcount(*) total_anc,\n\tmin(case when rch_anc_master.total_ifa_tab >= 180 then rch_anc_master.id end) as ifa_180_anc_id\n\tfrom rch_anc_det as rch_anc_master,t_pregnancy_registration_det\n\twhere rch_anc_master.pregnancy_reg_det_id = t_pregnancy_registration_det.pregnancy_reg_id\n\tand rch_anc_master.member_status = ''AVAILABLE''\n\tgroup by rch_anc_master.pregnancy_reg_det_id) as t1\n\tleft join rch_anc_master anc_master1 on anc_master1.id = t1.anc1_id\n\tleft join rch_anc_master anc_master2 on anc_master2.id = t1.anc2_id\n\tleft join rch_anc_master anc_master3 on anc_master3.id = t1.anc3_id\n\tleft join rch_anc_master anc_master4 on anc_master4.id = t1.anc3_id\n\tleft join rch_anc_master anc_systolic_bp on anc_systolic_bp.id = t1.systolic_bp\n\tleft join rch_anc_master anc_diastolic_bp on anc_diastolic_bp.id = t1.diastolic_bp\n\tleft join rch_anc_master anc_hb on anc_hb.id = t1.hb\n\tleft join rch_anc_master iron_def_anemia_inj_det on iron_def_anemia_inj_det.id = t1.iron_def_anemia_inj_anc_id \n\tleft join rch_anc_master ifa_180_anc on ifa_180_anc.id = t1.ifa_180_anc_id\n\t\n) as t\nwhere t.pregnancy_reg_det_id = t_pregnancy_registration_det.pregnancy_reg_id;\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED2''\nwhere event_config_id = 39 and status = ''PROCESSED1'';\ncommit;\n---3\nbegin;\n/*\nupdate t_pregnancy_registration_det \nset hbsag_test_cnt = t.hbsag_test_cnt,\nhbsag_reactive_cnt = t.hbsag_reactive_cnt,\nhbsag_non_reactive_cnt = case when t.hbsag_test_cnt = 1 and t.hbsag_reactive_cnt = 0 then 1 else 0 end \nfrom (  \n\tselect rch_anc_master.pregnancy_reg_det_id,\n\tmax(case when rch_anc_master.hbsag_test is not null then 1 else 0 end) as hbsag_test_cnt,\n\tmax(case when rch_anc_master.hbsag_test = ''REACTIVE'' then 1 else 0 end) as hbsag_reactive_cnt\n\t--sum(case when rch_anc_master.hbsag_test = ''NON_REACTIVE'' then 1 else 0 end) as hbsag_non_reactive_cnt\n\tfrom rch_anc_master \n\tinner join t_pregnancy_registration_det \n\ton rch_anc_master.pregnancy_reg_det_id = t_pregnancy_registration_det.pregnancy_reg_id\n\twhere rch_anc_master.member_status = ''AVAILABLE''\n\tgroup by rch_anc_master.pregnancy_reg_det_id\n) as t\nwhere t.pregnancy_reg_det_id = t_pregnancy_registration_det.pregnancy_reg_id;\n*/\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED3''\nwhere event_config_id = 39 and status = ''PROCESSED2'';\n\ncommit;\n\n---4\nbegin;\nupdate t_pregnancy_registration_det \nset cur_severe_anemia = case when t.cur_severe_anemia = 1 then true else false end\n,cur_blood_pressure_issue = case when t.cur_blood_pressure_issue = 1 then true else false end \n,low_height = case when t.low_height = 1 then true else false end \n,cur_low_weight = case when t.cur_low_weight = 1 then true else false end\n,urine_albumin = case when t.urine_albumin = 1 then true else false end\n,high_risk_mother = case when t.high_risk_mother = 1 then true else false end\n,pre_preg_anemia = case when t.pre_preg_anemia = 1 then true else false end\n,pre_preg_caesarean_section = case when t.pre_preg_caesarean_section = 1 then true else false end\n,pre_preg_abortion = case when t.pre_preg_abortion = 1 then true else false end\n,pre_preg_aph = case when t.pre_preg_aph = 1 then true else false end\n,pre_preg_pph = case when t.pre_preg_pph = 1 then true else false end\n,pre_preg_pre_eclampsia = case when t.pre_preg_pre_eclampsia = 1 then true else false end\n,pre_preg_obstructed_labour = case when t.pre_preg_obstructed_labour = 1 then true else false end\n,pre_preg_placenta_previa = case when t.pre_preg_placenta_previa = 1 then true else false end\n,pre_preg_malpresentation = case when t.pre_preg_malpresentation = 1 then true else false end\n,pre_preg_birth_defect = case when t.pre_preg_birth_defect = 1 then true else false end\n,pre_preg_preterm_delivery = case when t.pre_preg_preterm_delivery = 1 then true else false end\n,cur_urine_protein_issue = case when t.cur_urine_protein_issue = 1 then true else false end\n,cur_convulsion_issue = case when t.cur_convulsion_issue = 1 then true else false end\n,cur_malaria_issue = case when t.cur_malaria_issue = 1 then true else false end\n,cur_gestational_diabetes_issue = case when t.cur_gestational_diabetes_issue = 1 then true else false end\n,cur_twin_pregnancy = case when t.cur_twin_pregnancy = 1 then true else false end\n,cur_mal_presentation_issue = case when t.cur_mal_presentation_issue = 1 then true else false end\n,cur_absent_reduce_fetal_movment = case when t.cur_absent_reduce_fetal_movment = 1 then true else false end\n,cur_aph_issue = case when t.cur_aph_issue = 1 then true else false end\n,cur_pelvic_sepsis = case when t.cur_pelvic_sepsis = 1 then true else false end\n,cur_hiv_issue = case when t.cur_hiv_issue = 1 then true else false end\n,cur_vdrl_issue = case when t.cur_vdrl_issue = 1 then true else false end\n,cur_hbsag_issue = case when t.cur_hbsag_issue = 1 then true else false end\n,cur_brethless_issue = case when t.cur_brethless_issue = 1 then true else false end\n,high_risk_cnt = t.pre_preg_anemia + t.pre_preg_caesarean_section \n\t+ (case when t.pre_preg_aph = 1 or t.pre_preg_pph = 1 then 1 else 0 end)\n\t+ t.pre_preg_pre_eclampsia + t.pre_preg_abortion + t.pre_preg_obstructed_labour \n\t+ t.pre_preg_placenta_previa + t.pre_preg_malpresentation + t.pre_preg_birth_defect\n\t+ t.pre_preg_preterm_delivery + t.cur_severe_anemia + t.cur_low_weight + t.low_height\n\t+ (case when t.cur_blood_pressure_issue = 1 or t.cur_urine_protein_issue = 1 or t.cur_convulsion_issue = 1 then 1 else 0 end)\n\t+ t.cur_malaria_issue + t.cur_gestational_diabetes_issue + t.cur_twin_pregnancy + t.cur_mal_presentation_issue\n\t+ t.cur_absent_reduce_fetal_movment + t.cur_aph_issue + t.cur_pelvic_sepsis + t.cur_brethless_issue\n\t+ (case when t.cur_hiv_issue = 1 or t.cur_vdrl_issue = 1 or t.cur_hbsag_issue = 1 then 1 else 0 end)\nfrom (\n\tselect rch_anc_master.pregnancy_reg_det_id,\n\tmax(\n\tcase when \n\tdanger_sign.dangerous_sign_id = (\n\tselect id from listvalue_field_value_detail where value = ''Severe anemia''\n\t) or rch_anc_master.haemoglobin_count <= 7 \n\tthen 1 else 0 end\n\t) cur_severe_anemia,\n\tmax(case when rch_anc_master.member_height < 140 then 1 else 0 end) low_height,\n\tmax(case when rch_anc_master.systolic_bp >= 140 or rch_anc_master.diastolic_bp >= 90 then 1 else 0 end) as cur_blood_pressure_issue,\n\tmax(case when rch_anc_master.weight <= 40 then 1 else 0 end) cur_low_weight,\n\tmax(case when rch_anc_master.urine_albumin is not null and rch_anc_master.urine_albumin <> ''0'' then 1 else 0 end) urine_albumin,\n\tmax(\n\tcase when \n\t(urine_sugar is not null and urine_sugar != ''0'') \n\tor sugar_test_after_food_val >140 \n\tor danger_sign.dangerous_sign_id = 769/*Urine sugar*/ \n\tthen 1 else 0 end\n\t) cur_gestational_diabetes_issue,\n\tmax(\n\tcase when \n\trch_anc_master.foetal_movement in (''DECREASED'',''ABSENT'')\n\tor (rch_anc_master.foetal_position is not null and rch_anc_master.foetal_position not in(''VERTEX'',''CBMO''))\n\tor rch_anc_master.hiv_test = ''POSITIVE''\n\tor rch_anc_master.vdrl_test = ''POSITIVE''\n\tor rch_anc_master.hbsag_test = ''REACTIVE''\n\tor pre_compl.previous_pregnancy_complication in (\n\t''SEVANM''/*Anemia*/\n\t,''CAESARIAN''/*Caesarean Section*/\n\t,''APH'',''PPH''/*Ante partum Haemorrhage(APH)/Post partum Haemorrhage (PPH)*/\n\t,''CONVLS''/*Pre Eclampsia or Eclampsia*/\n\t,''P2ABO''/*Abortion*/\n\t,''OBSLBR''/*OBSLBR*/\n\t,''PLPRE''/*Placenta previa*/\n\t,''MLPRST''/*Malpresentation*/\n\t,''CONGDEF''/*Birth defect*/\n\t,''PRETRM''/*Preterm delivery*/\n\t) or danger_sign.dangerous_sign_id in (\n\t768/*urine protein*/\n\t,909/*convulsion*/\n\t,769/*Urine Sugar*/\n\t,912/*Twin*/\n\t,1024/*Malaria Fever*/\n\t,910/*APH*/\n\t,911/*Pelvic sepsis (vaginal discharge)(Foul smelling discharge)*/\n\t,915/*Breathlessness*/\n\t)\n\tthen 1 else 0 end\n\t) as high_risk_mother,\n\tmax(case when pre_compl.previous_pregnancy_complication = ''SEVANM'' then 1 else 0 end) as pre_preg_anemia,\n\tmax(case when pre_compl.previous_pregnancy_complication = ''CAESARIAN'' then 1 else 0 end) as pre_preg_caesarean_section,\n\t--max(case when pre_compl.previous_pregnancy_complication = ''APH'' or pre_compl.previous_pregnancy_complication = ''PPH''  then 1 else 0 end) as prev_aph_pph,\n\tmax(case when pre_compl.previous_pregnancy_complication = ''P2ABO''   then 1 else 0 end) as pre_preg_abortion,\n\t\n\tmax(case when pre_compl.previous_pregnancy_complication = ''APH''   then 1 else 0 end) as pre_preg_aph,\n\tmax(case when pre_compl.previous_pregnancy_complication = ''PPH''   then 1 else 0 end) as pre_preg_pph,\n\tmax(case when pre_compl.previous_pregnancy_complication = ''CONVLS''   then 1 else 0 end) as pre_preg_pre_eclampsia,\n\tmax(case when pre_compl.previous_pregnancy_complication = ''OBSLBR''   then 1 else 0 end) as pre_preg_obstructed_labour,\n\tmax(case when pre_compl.previous_pregnancy_complication = ''PLPRE''   then 1 else 0 end) as pre_preg_placenta_previa,\n\tmax(case when pre_compl.previous_pregnancy_complication = ''MLPRST''   then 1 else 0 end) as pre_preg_malpresentation,\n\tmax(case when pre_compl.previous_pregnancy_complication = ''CONGDEF''   then 1 else 0 end) as pre_preg_birth_defect,\n\tmax(case when pre_compl.previous_pregnancy_complication = ''PRETRM''   then 1 else 0 end) as pre_preg_preterm_delivery,\n\t\n\tmax(case when danger_sign.dangerous_sign_id  = 768   then 1 else 0 end) as cur_urine_protein_issue,\n\tmax(case when danger_sign.dangerous_sign_id  = 909   then 1 else 0 end) as cur_convulsion_issue,\n\tmax(case when danger_sign.dangerous_sign_id  = 1024   then 1 else 0 end) as cur_malaria_issue,\n\tmax(case when danger_sign.dangerous_sign_id  = 912   then 1 else 0 end) as cur_twin_pregnancy,\n\tmax(case when (rch_anc_master.foetal_position is not null and  rch_anc_master.foetal_position not in(''VERTEX'',''CBMO'')) then 1 else 0 end) as cur_mal_presentation_issue,\n\tmax(case when rch_anc_master.foetal_movement in (''DECREASED'',''ABSENT'')   then 1 else 0 end) as cur_absent_reduce_fetal_movment,\n\tmax(case when danger_sign.dangerous_sign_id  = 910   then 1 else 0 end) as cur_aph_issue,\n\tmax(case when danger_sign.dangerous_sign_id  = 911   then 1 else 0 end) as cur_pelvic_sepsis,\n\tmax(case when rch_anc_master.hiv_test = ''POSITIVE'' then 1 else 0 end) as cur_hiv_issue,\n\tmax(case when rch_anc_master.vdrl_test = ''POSITIVE'' then 1 else 0 end) as cur_vdrl_issue,\n\tmax(case when rch_anc_master.hbsag_test = ''REACTIVE'' then 1 else 0 end) as cur_hbsag_issue,\n\tmax(case when danger_sign.dangerous_sign_id  = 915   then 1 else 0 end) as cur_brethless_issue\n\t\n\t--count(DISTINCT danger_sign.dangerous_sign_id) as high_risk_cnt\n\t\n\tfrom rch_anc_master \n\tinner join t_pregnancy_registration_det \n\ton rch_anc_master.pregnancy_reg_det_id = t_pregnancy_registration_det.pregnancy_reg_id\n\tleft join rch_anc_dangerous_sign_rel as danger_sign on danger_sign.anc_id = rch_anc_master.id\n\tleft join rch_anc_previous_pregnancy_complication_rel as pre_compl on pre_compl.anc_id = rch_anc_master.id\n\twhere rch_anc_master.member_status = ''AVAILABLE''\n\tgroup by rch_anc_master.pregnancy_reg_det_id\n) as t\nwhere t.pregnancy_reg_det_id = t_pregnancy_registration_det.pregnancy_reg_id;\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED4''\nwhere event_config_id = 39 and status = ''PROCESSED3'';\ncommit;\n\n---  add high risk reason string\nbegin;\n\tupdate t_pregnancy_registration_det\n\tset \n\thigh_risk_reasons = t.high_risk_reasons\n\tfrom (\n\t\tselect \n\t\tpregnancy_reg_id\n\t\t,concat_ws ('','',\n\t\tcase when r.pre_preg_anemia = true then ''Anaemia'' else null end,\n\t\tcase when r.pre_preg_caesarean_section = true then ''Caesarean Section'' else null end,\n\t\tcase when r.pre_preg_aph = true then ''prev preg Ante partum Haemorrhage(APH)'' else null end,\n\t\tcase when r.pre_preg_pph = true then ''prev preg Post partum Haemorrhage (PPH)'' else null end,\n\t\tcase when r.pre_preg_pre_eclampsia = true then ''Pre Eclampsia/Eclampsia'' else null end,\n\t\tcase when r.pre_preg_abortion = true then ''Abortion'' else null end,\n\t\tcase when r.pre_preg_obstructed_labour = true then ''Obstructed labour'' else null end,\n\t\tcase when r.pre_preg_placenta_previa = true then ''Placenta previa'' else null end,\n\t\tcase when r.pre_preg_malpresentation = true then ''Malpresentation'' else null end,\n\t\tcase when r.pre_preg_birth_defect = true then ''Birth defect'' else null end,\n\t\tcase when r.pre_preg_preterm_delivery = true then ''Preterm delivery'' else null end,\t\t\n\t\tcase when r.chro_tb = true then ''Tuberculosis'' else null end,\n\t\tcase when r.chro_diabetes = true then ''Diabetes Mellitus'' else null end,\n\t\tcase when r.chro_heart_kidney = true then ''Heart/Kidney Diseases'' else null end,\n\t\tcase when r.chro_hiv = true then ''pre existing chronic HIV'' else null end,\n\t\tcase when r.chro_sickle = true then ''Sickle cell Anemia'' else null end,\n\t\tcase when r.chro_thalessemia = true then ''Thalessemia'' else null end,\n\t\tcase when r.cur_extreme_age = true then ''Extreme age(less than 18 and more than 35 years)'' else null end,\n\t\tcase when r.cur_low_weight = true then ''Weight (less than 45 kg)'' else null end,\t\t\n\t\tcase when r.cur_severe_anemia = true then ''present pregnency anemia'' else null end,\n\t\tcase when r.cur_blood_pressure_issue = true then ''Blood Pressure (More than 140/90)'' else null end,\n\t\tcase when r.cur_urine_protein_issue = true then ''oedema or urine protein or headache with blurred vision'' else null end,\n\t\tcase when r.cur_convulsion_issue = true then ''convulsion'' else null end,\n\t\tcase when r.cur_malaria_issue = true then ''Malaria'' else null end,\n\t\tcase when r.cur_social_vulnerability = true then ''Severe social vulnerability'' else null end,\n\t\tcase when r.cur_gestational_diabetes_issue = true then ''Gestational diabetes mellitus'' else null end,\n\t\tcase when r.cur_twin_pregnancy = true then ''Twin Pregnancy'' else null end,\n\t\tcase when r.cur_mal_presentation_issue = true then ''Mal presentation'' else null end,\n\t\tcase when r.cur_absent_reduce_fetal_movment = true then ''Absent or reduced fetal movement'' else null end,\n\t\tcase when r.cur_less_than_18_month_interval = true then ''Interval between two pregnancy (less than 18 Months)'' else null end,\n\t\tcase when r.cur_aph_issue = true then ''present pregnency Antepartum haemorrhage'' else null end,\n\t\tcase when r.cur_pelvic_sepsis = true then ''Pelvic sepsis (vaginal discharge)'' else null end,\n\t\tcase when r.cur_hiv_issue = true then ''present pregnency HIV'' else null end,\n\t\tcase when r.cur_vdrl_issue = true then ''present pregnency VDRL'' else null end,\n\t\tcase when r.cur_hbsag_issue = true then ''present pregnency HBsAg'' else null end,\n\t\tcase when r.cur_brethless_issue = true then ''Breathlessness'' else null end\t\t\n\t\t) as high_risk_reasons\n\t\tfrom \n\t\tt_pregnancy_registration_det r\n\t\twhere r.high_risk_mother = true\t\t\n\t ) as t\n\twhere t_pregnancy_registration_det.pregnancy_reg_id = t.pregnancy_reg_id;\t\n\ncommit;\n\n\n---\n\n\n\n---5\nbegin;\nupdate t_pregnancy_registration_det \nset tt1_given = t.tt1_given\n,tt2_given = t.tt2_given\n,tt_boster = t.tt_boster\n,tt2_tt_booster_given = case when t.tt_boster is not null then t.tt_boster else t.tt2_given end\n,tt1_location_id = t.tt1_location_id\n,tt2_location_id = t.tt2_location_id\n,tt_booster_location_id = t.tt_booster_location_id\n,tt2_tt_booster_location_id = case when t.tt_booster_location_id is not null then t.tt_booster_location_id else t.tt2_location_id end\nfrom (\n\tselect t1.pregnancy_reg_det_id,t1.tt1_given,t1.tt2_given,t1.tt_boster\n\t,tt1_immunization_det.location_id as tt1_location_id\n\t,tt2_immunization_det.location_id as tt2_location_id\n\t,tt_booster_immunization_det.location_id as tt_booster_location_id\n\tfrom (\n\tselect rch_immunisation_master.pregnancy_reg_det_id,\n\tmax(case when rch_immunisation_master.immunisation_given = ''TT1'' then given_on else null end) as tt1_given,\n\tmax(case when rch_immunisation_master.immunisation_given = ''TT1'' then rch_immunisation_master.id else null end) as tt1_id,\n\tmax(case when rch_immunisation_master.immunisation_given = ''TT2'' then given_on else null end) as tt2_given,\n\tmax(case when rch_immunisation_master.immunisation_given = ''TT2'' then rch_immunisation_master.id else null end) as tt2_id,\n\tmax(case when rch_immunisation_master.immunisation_given = ''TT_BOOSTER'' then given_on else null end) as tt_boster,\n\tmax(case when rch_immunisation_master.immunisation_given = ''TT_BOOSTER'' then rch_immunisation_master.id else null end) as tt_boster_id\n\tfrom rch_immunisation_master \n\tinner join t_pregnancy_registration_det \n\ton rch_immunisation_master.pregnancy_reg_det_id = t_pregnancy_registration_det.pregnancy_reg_id\n\tgroup by rch_immunisation_master.pregnancy_reg_det_id\n\t) as t1\n\tleft join rch_immunisation_master tt1_immunization_det on tt1_immunization_det.id = tt1_id\n\tleft join rch_immunisation_master tt2_immunization_det on tt2_immunization_det.id = tt2_id\n\tleft join rch_immunisation_master tt_booster_immunization_det on tt_booster_immunization_det.id = tt_boster_id\t\n) as t\nwhere t.pregnancy_reg_det_id = t_pregnancy_registration_det.pregnancy_reg_id;\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED5''\nwhere event_config_id = 39 and status = ''PROCESSED4'';\ncommit;\n---6\nbegin;\nupdate t_pregnancy_registration_det \nset registered_with_no_of_child = t.registered_with_no_of_child\n,registered_with_male_cnt = t.registered_with_male_cnt\n,registered_with_female_cnt = t.registered_with_female_cnt\n,prev_preg_diff_in_month = EXTRACT(year FROM age(t_pregnancy_registration_det.lmp_date,t.last_delivery_date))*12 + EXTRACT(month FROM age(t_pregnancy_registration_det.lmp_date,t.last_delivery_date))\nfrom (  \n\tselect t_pregnancy_registration_det.pregnancy_reg_id,\n\tsum(case when imt_member.death_detail_id is null or rch_member_death_deatil.dod > t_pregnancy_registration_det.lmp_date then 1 else 0 end) as registered_with_no_of_child,\n\tsum(\n\tcase when (imt_member.death_detail_id is null or rch_member_death_deatil.dod > t_pregnancy_registration_det.lmp_date) \n\tand imt_member.gender = ''M'' then 1 else 0 end\n\t) as registered_with_male_cnt,\n\tsum(\n\tcase when (imt_member.death_detail_id is null or rch_member_death_deatil.dod > t_pregnancy_registration_det.lmp_date) \n\tand imt_member.gender = ''F'' then 1 else 0 end\n\t) as registered_with_female_cnt,\n\tmax(imt_member.dob) as last_delivery_date\n\tfrom imt_member \n\tinner join t_pregnancy_registration_det \n\ton imt_member.mother_id = t_pregnancy_registration_det.member_id\n\tand imt_member.dob < t_pregnancy_registration_det.lmp_date\n\tleft join rch_member_death_deatil on imt_member.death_detail_id = rch_member_death_deatil.id\n\tgroup by t_pregnancy_registration_det.pregnancy_reg_id\n) as t\nwhere t.pregnancy_reg_id = t_pregnancy_registration_det.pregnancy_reg_id;\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED6''\nwhere event_config_id = 39 and status = ''PROCESSED5'';\ncommit;\n\n---7\n---------------------------------------------delivery related-------------------------------------------------------------------------------------------------------\nbegin;\nupdate t_pregnancy_registration_det \nset date_of_delivery_month_year = t.date_of_delivery_month_year\n,date_of_delivery = t.date_of_delivery\n,delivery_reg_date = t.delivery_reg_date\n,delivery_reg_date_financial_year = case when t.delivery_reg_date is not null and extract(month from t.delivery_reg_date) > 3 \n\tthen concat(extract(year from t.delivery_reg_date), ''-'', extract(year from t.delivery_reg_date) + 1)\n\twhen t.delivery_reg_date is not null then concat(extract(year from t.delivery_reg_date) - 1, ''-'', extract(year from t.delivery_reg_date)) end \n,delivery_location_id = t.delivery_location_id\n,delivery_family_id = t.delivery_family_id\n,delivery_hospital = t.delivery_hospital\n,delivery_health_infrastructure = t.delivery_health_infrastructure\n,delivery_outcome = t.delivery_outcome\n,type_of_delivery = t.type_of_delivery\n,delivery_done_by = t.delivery_done_by\n,delivery_place = t.delivery_place\n,home_del = case when t.home_del = 1 then true else false end\n,institutional_del = case when t.institutional_del = 1 then true else false end\n,delivery_108 = case when t.delivery_108 = 1 then true else false end\n,delivery_out_of_state_govt = case when t.delivery_out_of_state_govt = 1 then true else false end\n,delivery_out_of_state_pvt = case when t.delivery_out_of_state_pvt = 1 then true else false end\n,breast_feeding_in_one_hour = case when t.breast_feeding_in_one_hour = 1 then true else false end\n,del_week = t.del_week\n,is_cortico_steroid = case when t.is_cortico_steroid = 1 then true else false end\n,mother_alive = case when t.mother_alive = 1 then true else false end\n,total_out_come = t.total_out_come\n,male = t.male\n,female = t.female\n,still_birth = t.still_birth\n,live_birth = t.live_birth\n,ppiucd_insert_date = t.ppiucd_insert_date\n,ppiucd_insert_location = t.ppiucd_insert_location\n,is_fru = (case when t.is_fru = 1 then true else false end)\nfrom(\n\tselect t_pregnancy_registration_det.pregnancy_reg_id,\n\tmax(cast(date_trunc(''month'', rwmm.date_of_delivery) as date)) as date_of_delivery_month_year,\n\tmax(rwmm.date_of_delivery) as date_of_delivery,\n\tmax(rwmm.date_of_delivery) as delivery_reg_date,\n\tmax(rwmm.location_id) as delivery_location_id,\n\tmax(rwmm.family_id) as delivery_family_id,\n\tmax(rwmm.type_of_hospital) as delivery_hospital,\n\tmax(rwmm.health_infrastructure_id) as delivery_health_infrastructure,\n\tmax(rwmm.pregnancy_outcome) as delivery_outcome,\n\tmax(rwmm.type_of_delivery) as type_of_delivery,\n\tmax(rwmm.delivery_done_by) as delivery_done_by,\n\tmax(case when rwmm.delivery_place in (''HOME'',''ON_THE_WAY'') then 1 else 0 end) as home_del,\n\tmax(case when rwmm.delivery_place = ''HOSP'' then 1 else 0 end) as institutional_del,\n\tmax(case when rwmm.delivery_place = ''108_AMBULANCE'' then 1 else 0 end) as delivery_108,\n    max(case when rwmm.delivery_place = ''OUT_OF_STATE_GOVT'' then 1 else 0 end) as delivery_out_of_state_govt,\n    max(case when rwmm.delivery_place = ''OUT_OF_STATE_PVT'' then 1 else 0 end) as delivery_out_of_state_pvt,\n\tmax(rwmm.delivery_place) as delivery_place,\n\tmax(case when rwmm.breast_feeding_in_one_hour = true or rwmm.breast_feeding_in_one_hour then 1 else 0 end) as breast_feeding_in_one_hour,\n\tmax(TRUNC(DATE_PART(''day'', rwmm.date_of_delivery- cast(t_pregnancy_registration_det.lmp_date as timestamp))/7)) as del_week,\n\tmax(case when rwmm.cortico_steroid_given = true then 1 else 0 end) as is_cortico_steroid,\n\tmax(case when rwmm.mother_alive = false then 0 else 1 end) as mother_alive,\n\tsum(case when rwcm.pregnancy_outcome = ''LBIRTH'' then 1 else 0 end) as total_out_come,\n\tsum(case when rwcm.pregnancy_outcome = ''LBIRTH'' and rwcm.gender = ''M''  then 1 else 0 end) as male,\n\tsum(case when rwcm.pregnancy_outcome = ''LBIRTH'' and rwcm.gender = ''F''  then 1 else 0 end) as female,\n\tsum(case when rwcm.pregnancy_outcome = ''SBIRTH'' then 1 else 0 end) as still_birth,\n\tsum(case when rwcm.pregnancy_outcome = ''LBIRTH'' then 1 else 0 end) as live_birth,\n\tmax(case when rwmm.family_planning_method = ''PPIUCD'' then rwmm.date_of_delivery end) as ppiucd_insert_date,\n\tmax(case when rwmm.family_planning_method = ''PPIUCD'' then rwmm.location_id end) as ppiucd_insert_location,\n\tmax(case when hid.is_fru then 1 else 0 end) as is_fru\n\tfrom t_pregnancy_registration_det \n\tinner join rch_wpd_mother_master rwmm on t_pregnancy_registration_det.pregnancy_reg_id = rwmm.pregnancy_reg_det_id\n\tleft join rch_wpd_child_master rwcm on rwmm.id = rwcm.wpd_mother_id \n\tleft join health_infrastructure_details hid on hid.id = rwmm.health_infrastructure_id\n\twhere rwmm.member_status in (''AVAILABLE'',''DEATH'') and (rwmm.state is null or rwmm.state != ''MARK_AS_FALSE_DELIVERY'')\n\tgroup by t_pregnancy_registration_det.pregnancy_reg_id\n) as t\nwhere t.pregnancy_reg_id = t_pregnancy_registration_det.pregnancy_reg_id;\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED7''\nwhere event_config_id = 39 and status = ''PROCESSED6'';\ncommit;\n\n---8\nbegin;\nupdate t_pregnancy_registration_det \nset prev_preg_diff_in_month = case when \n\tprev_preg_diff_in_month < (\n\tEXTRACT(year FROM age(t_pregnancy_registration_det.lmp_date,t.last_delivery_date))*12 \n\t+ EXTRACT(month FROM age(t_pregnancy_registration_det.lmp_date,t.last_delivery_date))\n\t) \n\tthen prev_preg_diff_in_month \n\telse (\n\tEXTRACT(year FROM age(t_pregnancy_registration_det.lmp_date,t.last_delivery_date))*12 \n\t+ EXTRACT(month FROM age(t_pregnancy_registration_det.lmp_date,t.last_delivery_date))\n\t) end\nfrom (  \n\tselect t_pregnancy_registration_det.pregnancy_reg_id,\n\tmax(rch_wpd_mother_master.date_of_delivery) as last_delivery_date\n\tfrom t_pregnancy_registration_det INNER join\n\trch_wpd_mother_master on t_pregnancy_registration_det.member_id = rch_wpd_mother_master.member_id\n\tand rch_wpd_mother_master.date_of_delivery < t_pregnancy_registration_det.lmp_date\n\tgroup by t_pregnancy_registration_det.pregnancy_reg_id\n) as t\nwhere t.pregnancy_reg_id = t_pregnancy_registration_det.pregnancy_reg_id;\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED8''\nwhere event_config_id = 39 and status = ''PROCESSED7'';\ncommit;\n\n---9\nbegin;\nupdate t_pregnancy_registration_det \nset cur_extreme_age = case when t.cur_extreme_age = 1 then true else false end\n,chro_tb = case when t.chro_tb = 1 then true else false end\n,chro_diabetes = case when t.chro_diabetes = 1 then true else false end\n,chro_heart_kidney = case when t.chro_heart_kidney = 1 then true else false end\n,chro_hiv = case when t.chro_hiv = 1 then true else false end\n,chro_sickle = case when t.chro_sickle = 1 then true else false end\n,chro_thalessemia = case when t.chro_thalessemia = 1 then true else false end\n,member_current_location_id = t.member_current_location_id\n,tracking_location_id = t.member_current_location_id\n,age_during_delivery = t.age_during_delivery\n,any_chronic_dis = case when t.any_chronic_dis = 1 then true else false end\n,cur_social_vulnerability = case when t.cur_social_vulnerability = 1 then true else false end\n,maternal_detah = case when t.maternal_detah = 1 then true else false end\n,maternal_death_type = t.maternal_death_type\n,death_date = t.death_date\n,death_location_id = t.death_location_id\nfrom (\n\tselect t_pregnancy_registration_det.pregnancy_reg_id,\n\tmax (case when extract(years from age(t_pregnancy_registration_det.lmp_date,mem.dob)) < 18 or extract(years from age(t_pregnancy_registration_det.lmp_date,mem.dob)) > 35 then 1 else 0 end) cur_extreme_age,\n\tmax(extract(years from age(t_pregnancy_registration_det.lmp_date,mem.dob))) as age_during_delivery,\n\tmax(case when chronic.chronic_disease_id = ''715'' then 1 else 0 end) as chro_tb,\n\tmax(case when chronic.chronic_disease_id = ''726'' then 1 else 0 end) as chro_diabetes,\n\tmax(case when chronic.chronic_disease_id = ''713'' then 1 else 0 end) as chro_heart_kidney,\n\tmax(case when chronic.chronic_disease_id = ''735'' then 1 else 0 end) as chro_hiv,\n\tmax(case when chronic.chronic_disease_id = ''729'' then 1 else 0 end) as chro_sickle,\n\tmax(case when chronic.chronic_disease_id = ''730'' then 1 else 0 end) as chro_thalessemia,\n\tmax(case when fam.area_id is null then fam.location_id else cast(fam.area_id as bigint) end) as member_current_location_id,\n\tmax(case when chronic.chronic_disease_id is not null then 1 else 0 end) as any_chronic_dis,\n\tmax(case when fam.vulnerable_flag = true then 1 else 0 end) as cur_social_vulnerability,\n\tmax(\n\tcase when \n\tmem.basic_state = ''DEAD''\n\tand (\n\tt_pregnancy_registration_det.date_of_delivery is null \n\tor (\n\trch_member_death_deatil.id is not null \n\tand (cast(rch_member_death_deatil.dod as date) - cast(t_pregnancy_registration_det.date_of_delivery as date) between  0 and 42)\n\t)\n\t) then 1 else 0 end\n\t) as maternal_detah,\n\tmax(\n\t\tcase when \n\t\t\tmem.basic_state = ''DEAD''\n\t\t\tand \n\t\t\tt_pregnancy_registration_det.date_of_delivery is null \n\t\t\tthen ''PRE-PARTUM''\n\t\twhen \n\t\t\tmem.basic_state = ''DEAD''\n\t\t\tand (\n\t\t\trch_member_death_deatil.id is not null \n\t\t\tand (cast(rch_member_death_deatil.dod as date) - cast(t_pregnancy_registration_det.date_of_delivery as date) =  0 )\n\t\t\t) then ''INTRA-PARTUM'' \n\t\twhen\n\t\t\tmem.basic_state = ''DEAD''\n\t\t\tand (\n\t\t\trch_member_death_deatil.id is not null \n\t\t\tand (cast(rch_member_death_deatil.dod as date) - cast(t_pregnancy_registration_det.date_of_delivery as date) between  0 and 42)\n\t\t\t) then ''POST-PARTUM'' \n\t\telse \n\t\t\tnull end\n\t) as maternal_death_type,\n\tmax(rch_member_death_deatil.dod) as death_date,\n\tmax(rch_member_death_deatil.location_id) as death_location_id\n\tfrom t_pregnancy_registration_det \n\tinner join imt_member mem on t_pregnancy_registration_det.member_id = mem.id\n\tinner join imt_family fam on mem.family_id= fam.family_id\n\tleft join  imt_member_chronic_disease_rel chronic on mem.id = chronic.member_id \n\tleft join rch_member_death_deatil on rch_member_death_deatil.id = mem.death_detail_id\n\tgroup by t_pregnancy_registration_det.pregnancy_reg_id\n) as t\nwhere t.pregnancy_reg_id = t_pregnancy_registration_det.pregnancy_reg_id;\n\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED9''\nwhere event_config_id = 39 and status = ''PROCESSED8'';\ncommit;\n\n\n---10\nbegin;\nupdate t_pregnancy_registration_det \nset \npnc1 = (case when t.pnc1 is not null then t.pnc1 end)\n, pnc1_location_id = (case when t.pnc1 is not null then t.pnc1_location_id end)\n, pnc2 = (case when t.pnc2 is not null then t.pnc2 end)\n, pnc2_location_id = (case when t.pnc2 is not null then t.pnc2_location_id end)\n, pnc3 = (case when t.pnc3 is not null then t.pnc3 end)\n, pnc3_location_id = (case when t.pnc3 is not null then t.pnc3_location_id end)\n, pnc4 = (case when t.pnc4 is not null then t.pnc4 end)\n, pnc4_location_id = (case when t.pnc4 is not null then t.pnc4_location_id end)\n, pnc5 = (case when t.pnc5 is not null then t.pnc5 end)\n, pnc5_location_id = (case when t.pnc5 is not null then t.pnc5_location_id end)\n, pnc6 = (case when t.pnc6 is not null then t.pnc6 end)\n, pnc6_location_id = (case when t.pnc6 is not null then t.pnc6_location_id end)\n, pnc7 = (case when t.pnc6 is not null then t.pnc7 end)\n, pnc7_location_id = (case when t.pnc7 is not null then t.pnc7_location_id end)\n, ifa_tab_after_delivery = t.ifa_tab_after_delivery\n, ppiucd_insert_date = case when t.ppiucd_insert_date is not null then t.ppiucd_insert_date else t_pregnancy_registration_det.ppiucd_insert_date end\n, ppiucd_insert_location = case when t.ppiucd_insert_date is not null then t.ppiucd_insert_location else t_pregnancy_registration_det.ppiucd_insert_location end\nfrom (\nselect t1.pregnancy_reg_id\n\t,case when t_pregnancy_registration_det.delivery_place in (''HOME'',''HOSP'',''108_AMBULANCE'') \n\t\tthen t_pregnancy_registration_det.date_of_delivery else t1.pnc1 end as pnc1\n\t,t1.pnc2,t1.pnc3,t1.pnc4,t1.pnc5,t1.pnc6, t1.pnc7\n\t,case when t_pregnancy_registration_det.delivery_place in (''HOME'',''HOSP'',''108_AMBULANCE'') \n\t\tthen t_pregnancy_registration_det.delivery_location_id else pnc1_master.location_id end as pnc1_location_id\n\t,pnc2_master.location_id as pnc2_location_id\n\t,pnc3_master.location_id as pnc3_location_id\n\t,pnc4_master.location_id as pnc4_location_id\n    ,pnc5_master.location_id as pnc5_location_id\n    ,pnc6_master.location_id as pnc6_location_id\n\t,pnc7_master.location_id as pnc7_location_id\n\t,t1.ifa_tab_after_delivery\n\t,t1.ppiucd_insert_date\n\t,t1.ppiucd_insert_location\n\tfrom (\n\tselect t_pregnancy_registration_det.pregnancy_reg_id,\n\tmin(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 0 and 2 then rpm.service_date else null end) as pnc1,\n\tmin(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 0 and 2 then rpm.id else null end) as pnc1_id,\n\t\n\tmin(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 3 and 6 then rpm.service_date else null end) as pnc2,\n\tmin(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 3 and 6 then rpm.id else null end) as pnc2_id,\n\t\n\tmin(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 7 and 13 then rpm.service_date else null end) as pnc3,\n\tmin(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 7 and 13 then rpm.id else null end) as pnc3_id,\n\t\n\tmin(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 14 and 21 then rpm.service_date else null end) as pnc4,\n\tmin(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 14 and 21 then rpm.id else null end) as pnc4_id,\n\n    min(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 22 and 31 then rpm.service_date else null end) as pnc5,\n\tmin(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 22 and 31 then rpm.id else null end) as pnc5_id,\n\n    min(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 32 and 42 then rpm.service_date else null end) as pnc6,\n\tmin(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 32 and 42 then rpm.id else null end) as pnc6_id,\n\n\tmin(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 43 and 60 then rpm.service_date else null end) as pnc7,\n\tmin(case when cast(rpm.service_date as date) - t_pregnancy_registration_det.date_of_delivery between 43 and 60 then rpm.id else null end) as pnc7_id,\n\n\t\n\tsum(rpmm.ifa_tablets_given) as ifa_tab_after_delivery,\n\t\n\tmax(case when family_planning_method = ''PPIUCD'' then cast(rpmm.fp_insert_operate_date as date) end) as ppiucd_insert_date,\n\tmax(case when family_planning_method = ''PPIUCD'' then rpm.location_id end) as ppiucd_insert_location\n\t\n\tfrom t_pregnancy_registration_det \n\tinner join rch_pnc_master rpm on t_pregnancy_registration_det.pregnancy_reg_id = rpm.pregnancy_reg_det_id\n\tleft join rch_pnc_mother_master rpmm on rpmm.pnc_master_id = rpm.id\n\twhere rpm.member_status = ''AVAILABLE''\n\tgroup by t_pregnancy_registration_det.pregnancy_reg_id) as t1\n\tinner join t_pregnancy_registration_det on t_pregnancy_registration_det.pregnancy_reg_id = t1.pregnancy_reg_id\n\tleft join rch_pnc_master pnc1_master on pnc1_master.id = pnc1_id\n\tleft join rch_pnc_master pnc2_master on pnc2_master.id = pnc2_id\n\tleft join rch_pnc_master pnc3_master on pnc3_master.id = pnc3_id\n\tleft join rch_pnc_master pnc4_master on pnc4_master.id = pnc4_id\n    left join rch_pnc_master pnc5_master on pnc5_master.id = pnc5_id\n    left join rch_pnc_master pnc6_master on pnc6_master.id = pnc6_id\n\tleft join rch_pnc_master pnc7_master on pnc7_master.id = pnc7_id\n) as t\nwhere t.pregnancy_reg_id = t_pregnancy_registration_det.pregnancy_reg_id;\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED10''\nwhere event_config_id = 39 and status = ''PROCESSED9'';\ncommit;\n\n---11\n---------------------Updating Data to Main Table-------------------------------------------------------------------------------------------------------------\nbegin;\n/*DROP TABLE IF EXISTS rch_pregnancy_analytics_details_t;\nCREATE TABLE rch_pregnancy_analytics_details_t (\n  pregnancy_reg_id bigint NOT NULL,\n  member_id bigint,\n  dob date,\n  family_id text,\n  member_name text,\n  mobile_number text,\n  reg_service_date date,\n  reg_service_date_month_year date,\n  reg_service_financial_year text,\n  reg_server_date timestamp without time zone,\n  pregnancy_reg_location_id bigint,\n  native_location_id integer,\n  pregnancy_reg_family_id bigint,\n  lmp_date date,\n  edd date,\n  preg_reg_state text,\n  member_basic_state text,\n  lmp_month_year date,\n  lmp_financial_year text,\n  date_of_delivery date,\n  date_of_delivery_month_year date,\n  delivery_location_id bigint,\n  delivery_family_id bigint,\n  delivery_reg_date date,\n  delivery_reg_date_financial_year text,\n  member_current_location_id bigint,\n  age_during_delivery smallint,\n  registered_with_no_of_child smallint,\n  registered_with_male_cnt smallint,\n  registered_with_female_cnt smallint,\n  anc1 date,\n  anc1_location_id integer,\n  anc2 date,\n  anc2_location_id integer,\n  anc3 date,\n  anc3_location_id integer,\n  anc4 date,\n  anc4_location_id integer,\n  total_regular_anc smallint,\n  tt1_given date,\n  tt1_location_id integer,\n  tt2_given date,\n  tt2_location_id integer,\n  tt_boster date,\n  tt_booster_location_id integer,\n  tt2_tt_booster_given date,\n  tt2_tt_booster_location_id integer,\n  early_anc boolean,\n  total_anc smallint,\n  ifa integer,\n  fa_tab_in_30_day integer,\n  fa_tab_in_31_to_60_day integer,\n  fa_tab_in_61_to_90_day integer,\n  ifa_tab_in_4_month_to_9_month integer,\n  hb_between_90_to_360_days integer,\n  hb real,\n  total_ca integer,\n  ca_tab_in_91_to_180_day integer,\n  ca_tab_in_181_to_360_day integer,\n  expected_delivery_place text,\n\t\n  L2L_Preg_Complication text,\n  Outcome_L2L_Preg text,\n  L2L_Preg_Complication_Length smallint,\n  Outcome_Last_Preg integer,\n  \n  alben_given boolean,\n  maternal_detah boolean,\n  maternal_death_type text,\n  death_date date,\n  death_location_id integer,\n  low_height boolean,\n  urine_albumin boolean,\n  systolic_bp smallint,\n  diastolic_bp smallint,\n  prev_pregnancy_date date,\n  prev_preg_diff_in_month smallint,\n  gravida smallint,\n  jsy_beneficiary boolean,\n  jsy_payment_date date,\n  any_chronic_dis boolean,\n  aadhar_and_bank boolean,\n  aadhar_reg boolean,\n  aadhar_with_no_bank boolean,\n  bank_with_no_aadhar boolean,\n  no_aadhar_and_bank boolean,\n  high_risk_mother boolean,\n  pre_preg_anemia boolean,\n  pre_preg_caesarean_section boolean,\n  pre_preg_aph boolean,\n  pre_preg_pph boolean,\n  pre_preg_pre_eclampsia boolean,\n  pre_preg_abortion boolean,\n  pre_preg_obstructed_labour boolean,\n  pre_preg_placenta_previa boolean,\n  pre_preg_malpresentation boolean,\n  pre_preg_birth_defect boolean,\n  pre_preg_preterm_delivery boolean,\n  any_prev_preg_complication boolean,\n  chro_tb boolean,\n  chro_diabetes boolean,\n  chro_heart_kidney boolean,\n  chro_hiv boolean,\n  chro_sickle boolean,\n  chro_thalessemia boolean,\n  cur_extreme_age boolean,\n  cur_low_weight boolean,\n  cur_severe_anemia boolean,\n  cur_blood_pressure_issue boolean,\n  cur_urine_protein_issue boolean,\n  cur_convulsion_issue boolean,\n  cur_malaria_issue boolean,\n  cur_social_vulnerability boolean,\n  cur_gestational_diabetes_issue boolean,\n  cur_twin_pregnancy boolean,\n  cur_mal_presentation_issue boolean,\n  cur_absent_reduce_fetal_movment boolean,\n  cur_less_than_18_month_interval boolean,\n  cur_aph_issue boolean,\n  cur_pelvic_sepsis boolean,\n  cur_hiv_issue boolean,\n  cur_vdrl_issue boolean,\n  cur_hbsag_issue boolean,\n  cur_brethless_issue boolean,\n  any_cur_preg_complication boolean,\n  high_risk_cnt smallint,\n  hbsag_test_cnt smallint,\n  hbsag_reactive_cnt smallint,\n  hbsag_non_reactive_cnt smallint,\n  delivery_outcome text,\n  type_of_delivery text,\n  delivery_place text,\n  home_del boolean,\n  institutional_del boolean,\n  delivery_108 boolean,\n  breast_feeding_in_one_hour boolean,\n  delivery_hospital text,\n  del_week smallint,\n  is_cortico_steroid boolean,\n  mother_alive boolean,\n  total_out_come smallint,\n  male smallint,\n  female smallint,\n  delivery_done_by text,\n  pnc1 date,\n  pnc1_location_id integer,\n  pnc2 date,\n  pnc2_location_id integer,\n  pnc3 date,\n  pnc3_location_id integer,\n  pnc4 date,\n  pnc4_location_id integer,\n  haemoglobin_tested_count integer,\n  iron_def_anemia_inj text,\n  blood_transfusion boolean,\n  ppiucd_insert_date date,\n  PRIMARY KEY (pregnancy_reg_id)\n);\n*/\n\ndelete from rch_pregnancy_analytics_details where (select cast(key_value as boolean) as value \nfrom system_configuration where system_key = ''rch_pregnancy_analytics_run_for_all_pregnancy'') = true;\n\ninsert into rch_pregnancy_analytics_details(\n\tpregnancy_reg_id\n)\nselect t_pregnancy_registration_det.pregnancy_reg_id\nfrom t_pregnancy_registration_det\nleft join rch_pregnancy_analytics_details on t_pregnancy_registration_det.pregnancy_reg_id = rch_pregnancy_analytics_details.pregnancy_reg_id\nwhere rch_pregnancy_analytics_details.pregnancy_reg_id is null;\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED11''\nwhere event_config_id = 39 and status = ''PROCESSED10'';\ncommit;\n\n\n\n---12\nbegin;\nupdate rch_pregnancy_analytics_details \nset \n\tmember_id = t.member_id,\n\tdob = t.dob,\n\tfamily_id = t.family_id,\n\tunique_health_id = t.unique_health_id,\n\tmember_name = t.member_name,\n\tmobile_number = t.mobile_number,\n\tmember_basic_state = t.member_basic_state,\n\tpreg_reg_state = t.preg_reg_state,\n\treg_service_date =t.reg_service_date,\n\treg_service_date_month_year =t.reg_service_date_month_year,\n\treg_service_financial_year = t.reg_service_financial_year,\n\treg_server_date =t.reg_server_date,\n\tpregnancy_reg_location_id = t.pregnancy_reg_location_id,\n\tnative_location_id = t.native_location_id,\n\tpregnancy_reg_family_id = t.pregnancy_reg_family_id,\n\tlmp_date = t.lmp_date,\n\tedd=t.edd,\n\tlmp_month_year = t.lmp_month_year,\n\tlmp_financial_year = t.lmp_financial_year,\n\tdate_of_delivery = t.date_of_delivery,\n\tdate_of_delivery_month_year = t.date_of_delivery_month_year,\n\tdelivery_location_id =t.delivery_location_id,\n\tdelivery_family_id =t.delivery_family_id,\n\tdelivery_reg_date = t.delivery_reg_date,\n\tdelivery_reg_date_financial_year = t.delivery_reg_date_financial_year,\n\t\n\tmember_current_location_id = t.member_current_location_id,\n\tage_during_delivery = t.age_during_delivery,\n\tregistered_with_no_of_child = t.registered_with_no_of_child,\n\tregistered_with_male_cnt = t.registered_with_male_cnt,\n\tregistered_with_female_cnt = t.registered_with_female_cnt,\n\tanc1 =t.anc1,\n\tanc1_location_id = t.anc1_location_id,\n\tanc2 =t.anc2,\n\tanc2_location_id = t.anc2_location_id,\n\tanc3 =t.anc3,\n\tanc3_location_id = t.anc3_location_id,\n\tanc4 =t.anc4,\n\tanc4_location_id = t.anc4_location_id,\n\tlast_systolic_bp = t.last_systolic_bp,\n\tlast_diastolic_bp = t.last_diastolic_bp,\n\ttt1_given =t.tt1_given,\n\ttt1_location_id = t.tt1_location_id,\n\ttt2_given =t.tt2_given,\n\ttt2_location_id = t.tt2_location_id,\n\ttt_boster =t.tt_boster,\n\ttt_booster_location_id = t.tt_booster_location_id,\n\ttt2_tt_booster_given = t.tt2_tt_booster_given,\n\ttt2_tt_booster_location_id = t.tt2_tt_booster_location_id,\n\tearly_anc =t.early_anc,\n\tifa =t.ifa,\n\tifa_180_anc_date = t.ifa_180_anc_date,\n\tifa_180_anc_location = t.ifa_180_anc_location,\n\tfa_tab_in_30_day = t.fa_tab_in_30_day,\n\tfa_tab_in_31_to_60_day = t.fa_tab_in_31_to_60_day,\n\tfa_tab_in_61_to_90_day = t.fa_tab_in_61_to_90_day,\n\tifa_tab_in_4_month_to_9_month = t.ifa_tab_in_4_month_to_9_month,\n\thb =t.hb,\n\thb_date = t.hb_date,\n\thb_between_90_to_360_days = t.hb_between_90_to_360_days,\n\ttotal_ca = t.total_ca,\n\tca_tab_in_91_to_180_day = t.ca_tab_in_91_to_180_day,\n\tca_tab_in_181_to_360_day = t.ca_tab_in_181_to_360_day,\n\texpected_delivery_place = t.expected_delivery_place,\n\t\n\tL2L_Preg_Complication = t.L2L_Preg_Complication,\n\tOutcome_L2L_Preg = t.Outcome_L2L_Preg,\n\tL2L_Preg_Complication_Length = t.L2L_Preg_Complication_Length,\n\t\n\talben_given =t.alben_given,\n\tcur_severe_anemia =t.cur_severe_anemia,\n\tcur_extreme_age =t.cur_extreme_age,\n\tlow_height =t.low_height,\n\tcur_urine_protein_issue = t.cur_urine_protein_issue,\n\tcur_convulsion_issue = t.cur_convulsion_issue,\n\tcur_malaria_issue = t.cur_malaria_issue,\n\tcur_social_vulnerability = t.cur_social_vulnerability,\n\tcur_gestational_diabetes_issue = t.cur_gestational_diabetes_issue,\n\tcur_twin_pregnancy = t.cur_twin_pregnancy,\n\tcur_mal_presentation_issue = t.cur_mal_presentation_issue,\n\tcur_absent_reduce_fetal_movment = t.cur_absent_reduce_fetal_movment,\n\tcur_less_than_18_month_interval = case when t.prev_preg_diff_in_month <= 18 then true else false end,\n\tcur_aph_issue = t.cur_aph_issue,\n\tcur_pelvic_sepsis = t.cur_pelvic_sepsis,\n\tcur_hiv_issue = t.cur_hiv_issue,\n\tcur_vdrl_issue = t.cur_vdrl_issue,\n\tcur_hbsag_issue = t.cur_hbsag_issue,\n\tcur_brethless_issue = t.cur_brethless_issue,\n\tcur_low_weight =t.cur_low_weight,\n\tmaternal_detah = t.maternal_detah,\n\tmaternal_death_type = t.maternal_death_type,\n\tdeath_date = t.death_date,\n\tdeath_location_id = t.death_location_id,\n\tany_cur_preg_complication = case when t.cur_extreme_age or t.cur_low_weight or t.cur_severe_anemia or t.low_height \n\tor t.cur_blood_pressure_issue or t.cur_urine_protein_issue or t.cur_malaria_issue\n\tor t.cur_social_vulnerability or t.cur_gestational_diabetes_issue or t.cur_twin_pregnancy\n\tor t.cur_mal_presentation_issue or t.cur_absent_reduce_fetal_movment or t.prev_preg_diff_in_month <= 18\n\tor t.cur_aph_issue or t.cur_pelvic_sepsis or t.cur_hiv_issue or t.cur_vdrl_issue or t.cur_hbsag_issue\n\tor t.cur_brethless_issue then true else false end,\n\turine_albumin =t.urine_albumin,\n\tcur_blood_pressure_issue =t.cur_blood_pressure_issue,\n\tsystolic_bp =t.systolic_bp,\n\tdiastolic_bp =t.diastolic_bp,\n\tany_prev_preg_complication = case when t.pre_preg_anemia or t.pre_preg_caesarean_section or t.pre_preg_aph \n\tor t.pre_preg_pph or t.pre_preg_pre_eclampsia or t.pre_preg_abortion or t.pre_preg_obstructed_labour\n\tor t.pre_preg_placenta_previa or t.pre_preg_malpresentation or t.pre_preg_birth_defect\n\tor t.pre_preg_preterm_delivery or t.total_out_come >= 3 then true else false end,\n\tprev_pregnancy_date =t.prev_pregnancy_date,\n\tprev_preg_diff_in_month =t.prev_preg_diff_in_month,\n\tgravida =t.registered_with_no_of_child,\n\tany_chronic_dis = case when t.chro_diabetes = true or t.chro_heart_kidney = true\n\tor t.chro_hiv = true or t.chro_thalessemia = true or t.chro_sickle = true \n\tor t.chro_tb = true \n\tthen true else false end,\n\ttotal_anc =t.total_anc,\n\tcomplete_anc_date = case when t.anc4 is not null and t.ifa_180_anc_date is not null then greatest(t.anc4,t.ifa_180_anc_date) end,\n\tcomplete_anc_location = case when (t.anc4 is not null and t.ifa_180_anc_date is not null) and (t.anc4 > t.ifa_180_anc_date) \n\t\t\t\t\t\t\t\t\tthen t.anc4_location_id \n\t\t\t\t\t\t\t\twhen (t.anc4 is not null and t.ifa_180_anc_date is not null) then t.ifa_180_anc_location end,\n\ttotal_regular_anc = (case when t.anc1 is null then 0 else 1 end) \n\t+  (case when t.anc2 is null then 0 else 1 end) \n\t+  (case when t.anc3 is null then 0 else 1 end) \n\t+  (case when t.anc4 is null then 0 else 1 end),  \n\thigh_risk_mother = case when t.high_risk_mother = true or t.total_out_come >= 3 \n\tor t.chro_diabetes = true or t.chro_heart_kidney = true\n\tor t.chro_hiv = true or t.chro_thalessemia = true or t.chro_sickle = true \n\tor t.chro_tb = true or t.cur_extreme_age = true or t.cur_low_weight = true \n\tor t.cur_severe_anemia = true or t.cur_blood_pressure_issue = true \n\tor t.cur_gestational_diabetes_issue = true or t.prev_preg_diff_in_month <= 18\n\tor t.cur_social_vulnerability = true\n\tthen true else false end,\n\thigh_risk_cnt =t.high_risk_cnt + case when t.total_out_come >=3 then 1 else 0 end \n\t+ case when t.chro_tb then 1 else 0 end + case when t.chro_diabetes then 1 else 0 end\n\t+ case when t.chro_heart_kidney then 1 else 0 end + case when t.chro_hiv then 1 else 0 end\n\t+ case when t.chro_thalessemia then 1 else 0 end + case when t.chro_sickle then 1 else 0 end\n\t+ case when t.cur_extreme_age then 1 else 0 end\n\t+ case when t.prev_preg_diff_in_month <= 18 then 1 else 0 end,\n\thbsag_test_cnt =t.hbsag_test_cnt,\n\thbsag_reactive_cnt =t.hbsag_reactive_cnt,\n\thbsag_non_reactive_cnt =t.hbsag_non_reactive_cnt,\n\tpre_preg_anemia =t.pre_preg_anemia,\n\t\n\tpre_preg_aph =t.pre_preg_aph,\n\tpre_preg_pph =t.pre_preg_pph,\n\tpre_preg_pre_eclampsia =t.pre_preg_pre_eclampsia,\n\tpre_preg_obstructed_labour =t.pre_preg_obstructed_labour,\n\tpre_preg_placenta_previa =t.pre_preg_placenta_previa,\n\tpre_preg_malpresentation =t.pre_preg_malpresentation,\n\tpre_preg_birth_defect =t.pre_preg_birth_defect,\n\tpre_preg_preterm_delivery =t.pre_preg_preterm_delivery,\n\t\n\tpre_preg_caesarean_section =t.pre_preg_caesarean_section,\n\tpre_preg_abortion =t.pre_preg_abortion,\n\tchro_tb =t.chro_tb,\n\tchro_diabetes =t.chro_diabetes,\n\tchro_heart_kidney =t.chro_heart_kidney,\n\tchro_hiv =t.chro_hiv,\n\tchro_sickle =t.chro_sickle,\n\tchro_thalessemia =t.chro_thalessemia,\n\tdelivery_outcome =t.delivery_outcome,\n\tdelivery_health_infrastructure = t.delivery_health_infrastructure,\n\ttype_of_delivery=t.type_of_delivery,\n\tdelivery_place = t.delivery_place,\n\thome_del =t.home_del,\n\tinstitutional_del =t.institutional_del,\n\tdelivery_108 = t.delivery_108,\n    \n    delivery_out_of_state_govt = t.delivery_out_of_state_govt,\n    delivery_out_of_state_pvt = t.delivery_out_of_state_pvt,\n\n\tbreast_feeding_in_one_hour =t.breast_feeding_in_one_hour,\n\tdelivery_hospital =t.delivery_hospital,\n\tdel_week =t.del_week,\n\tis_cortico_steroid =t.is_cortico_steroid,\n\tmother_alive =t.mother_alive,\n\ttotal_out_come =t.total_out_come,\n\tmale =t.male,\n\tfemale =t.female,\n\t\n\tstill_birth = t.still_birth,\n\tlive_birth = t.live_birth,\n\t\n\tdelivery_done_by = t.delivery_done_by,\n\tpnc1 =t.pnc1,\n\tpnc1_location_id = t.pnc1_location_id,\n\tpnc2 =t.pnc2,\n\tpnc2_location_id = t.pnc2_location_id,\n\tpnc3 =t.pnc3,\n\tpnc3_location_id = t.pnc3_location_id,\n\tpnc4 =t.pnc4,\n\tpnc4_location_id = t.pnc4_location_id,\n    pnc5 = t.pnc5,\n    pnc5_location_id = t.pnc5_location_id,\n    pnc6 = t.pnc6,\n    pnc6_location_id = t.pnc6_location_id,\n\tpnc7 = t.pnc7,\n\tpnc7_location_id = t.pnc7_location_id,\n\t\n\tifa_tab_after_delivery = t.ifa_tab_after_delivery,\n\t\n\thaemoglobin_tested_count = t.haemoglobin_tested_count,\n\tiron_def_anemia_inj = t.iron_def_anemia_inj,\n\tblood_transfusion = t.blood_transfusion,\n\tppiucd_insert_date = t.ppiucd_insert_date,\n\tppiucd_insert_location = t.ppiucd_insert_location,\n\tis_fru = t.is_fru,\n\thigh_risk_reasons = t.high_risk_reasons,\n\ttracking_location_id = t.tracking_location_id,\n\tis_valid_for_tracking_report = t.is_valid_for_tracking_report,\n\n\tasha_sangini_indicator_newbornvisit = case when t.home_del is true and t.date_of_delivery = t.pnc1 and t.delivery_outcome = ''LBIRTH'' then true else false end,\n\tasha_sangini_indicator_hbnc = case when num_nulls(t.pnc1, t.pnc2, t.pnc3, t.pnc4, t.pnc5, t.pnc6, t.pnc7) = 0 then true else false end,\n\tfamily_basic_state = t.family_basic_state,\n    marital_status = t.marital_status,\n    address = t.address,\n    husband_name = t.husband_name,\n    husband_mobile_number = t.husband_mobile_number,\n    hof_name = t.hof_name,\n    hof_mobile_number = t.hof_mobile_number\nfrom t_pregnancy_registration_det t\nwhere t.pregnancy_reg_id = rch_pregnancy_analytics_details.pregnancy_reg_id;\n/*with member_details as (\n    select distinct on (member_id)\n    member_id,\n    pregnancy_reg_id,\n    high_risk_mother,\n    high_risk_reasons\n    from t_pregnancy_registration_det\n    order by member_id,pregnancy_reg_id desc\n)update imt_member\nset is_high_risk_case = member_details.high_risk_mother,\nadditional_info = concat(cast(additional_info as jsonb),cast(concat(''{\"highRiskReasons\":\"'',case when member_details.high_risk_reasons is not null then member_details.high_risk_reasons else ''null'' end,''\"}'') as jsonb))\nfrom member_details\nwhere imt_member.id = member_details.member_id\nand (\n    imt_member.is_high_risk_case != member_details.high_risk_mother\n    or cast(additional_info as jsonb) ->> ''highRiskReasons'' != member_details.high_risk_reasons\n);*/\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED12''\nwhere event_config_id = 39 and status = ''PROCESSED11'';\ncommit;\n\n---13\nbegin;\ndrop table if exists t_pregnancy_registration_det;\n\ndrop table if exists asha_workers_last_2_months_analytics_t;\ncreate table asha_workers_last_2_months_analytics_t(\n\tuser_id int,\n\tlocation_id int,\n\ttotal_home_deliveries int,\n\tnewbornvisit_on_dob int,\n\ttotal_deliveries int,\n\ttotal_deliveries_with_hbnc int\n);\n\nwith dates as (\n\tselect case when current_date < cast(date_trunc(''month'', now()) + interval ''20 days'' as date) then cast(date_trunc(''month'', now() - interval ''3 months'') + interval ''20 days'' as date)\n\t\telse cast(date_trunc(''month'', now() - interval ''2 months'') + interval ''20 days'' as date)\n\t\tend as from_date,\n\tcase when current_date < cast(date_trunc(''month'', now()) + interval ''20 days'' as date) then cast(date_trunc(''month'', now() - interval ''1 month'') + interval ''19 days'' as date)\n\t\telse cast(date_trunc(''month'', now()) + interval ''19 days'' as date)\n\t\tend as to_date\n), pregnant_woman_details as (\n\tselect rpad.member_id, rpad.member_current_location_id, rpad.date_of_delivery, rpad.home_del,\n\trpad.asha_sangini_indicator_newbornvisit, rpad.asha_sangini_indicator_hbnc\n\tfrom rch_pregnancy_analytics_details rpad \n\tinner join dates on true\n\twhere rpad.date_of_delivery between dates.from_date and dates.to_date and rpad.delivery_outcome = ''LBIRTH''\n), asha_det as (\n\tselect uu.id, uul.loc_id \n\tfrom um_user uu\n\tinner join um_user_location uul on uul.user_id =  uu.id\n\twhere role_id = 24 and uu.state = ''ACTIVE'' and uul.state = ''ACTIVE''\n), counts as (\n\tselect asha_det.id, asha_det.loc_id, \n\tcount(pwd.member_id) filter (where pwd.home_del is true) as total_home_deliveries,\n\tcount(pwd.member_id) filter (where home_del is true and asha_sangini_indicator_newbornvisit is true) as newbornvisit_on_dob,\n\tcount(pwd.member_id) filter (where date_of_delivery <= cast(now() - interval ''60 days'' as date)) as total_deliveries,\n\tcount(pwd.member_id) filter (where asha_sangini_indicator_hbnc is true and date_of_delivery <= cast(now() - interval ''60 days'' as date)) as total_deliveries_with_hbnc\n\tfrom pregnant_woman_details pwd\n\tright join asha_det on asha_det.loc_id = pwd.member_current_location_id\n\tgroup by asha_det.loc_id, asha_det.id \n)\ninsert into asha_workers_last_2_months_analytics_t (\n\tuser_id, location_id, total_home_deliveries, newbornvisit_on_dob, total_deliveries, total_deliveries_with_hbnc\n)\nselect counts.* from counts;\n\ndrop table if exists asha_workers_last_2_months_analytics;\nalter table asha_workers_last_2_months_analytics_t\n\trename to asha_workers_last_2_months_analytics;\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED13''\nwhere event_config_id = 39 and status = ''PROCESSED12'';\ncommit;\n\n\n---14\n-----------------------------------------------------------------------------------------------------------------------------\nbegin;\ndrop table if exists rch_lmp_base_location_wise_data_point_t;\ncreate table rch_lmp_base_location_wise_data_point_t (\n\tlocation_id bigint,\n\tmonth_year date,\n\tfinancial_year text,\n\t\n\tanc_reg bigint,\n\tabortion integer,\n\tmtp integer,\n\tno_of_inst_del integer,\n\tno_of_home_del integer,\n\tdelivery_108 integer,\n    delivery_out_of_state_govt integer,\n    delivery_out_of_state_pvt integer,\n\t\n\tno_of_maternal_death integer,\n\t\n\tno_of_missing_del integer,\n\tno_of_not_missing_del integer,\n\thigh_risk_mother bigint,\n\tpre_preg_pre_eclampsia bigint,\n\tprev_anemia bigint,\n\tprev_caesarian bigint,\n\tprev_aph_pph bigint,\n\tprev_abortion bigint,\n\tmultipara bigint,\n\tcur_mal_presentation_issue bigint,\n\tcur_malaria_issue bigint,\n\t\n\ttb bigint,\n\tdiabetes bigint,\n\theart_kidney bigint,\n\thiv bigint,\n\tsickle bigint,\n\tthalessemia bigint,\n\tearly_anc integer,\n\tanc1 integer,\n\tanc2 integer,\n\tanc3 integer,\n\tanc4 integer,\n\tfull_anc integer,\n\tifa integer,\n\ttt1 integer,\n\ttt2 integer,\n\ttt_booster integer,\n\ttt2_tt_booster integer,\n\tlbirth integer,\n\tsbirth integer,\n\thome_del integer,\n\tbreast_feeding integer,\n\tsc integer,\n\tphc integer,\n\tchc integer,\n\tsdh integer,\n\tuhc integer,\n\tgia integer,\n\tmedi_college integer,\n\ttaluka_hospi integer,\n\tpvt integer,\n\n\thome_del_by_sba integer,\n\thome_del_by_non_sba integer,\n\tdel_over_due integer,\n\tifa_30_tablet_in_30_day integer,\n\tifa_30_tablet_in_31_to_61_day integer,\n\tifa_30_tablet_in_61_to_90_day integer,\n\thb_done integer,\n\thb_more_then_11_in_91_to_360_days integer,\n\tifa_180_with_hb_in_4_to_9_month integer,\n\thb_between_7_to_11 integer,\n\tifa_360_with_hb_between_7_to_11_in_4_to_9_month integer,\n\tca_180_given_in_2nd_trimester integer,\n\tca_180_given_in_3rd_trimester integer,\n\thr_anc_regd integer,\n\thr_tt1 integer,\n\thr_tt2_and_tt_boster integer,\n\thr_tt2_tt_booster integer,\n\thr_early_anc integer,\n\thr_anc1 integer,\n\thr_anc2 integer,\n\thr_anc3 integer,\n\thr_anc4 integer,\n\thr_no_of_delivery integer,\n\thr_mtp integer,\n\thr_abortion integer,\n\thr_pnc1 integer,\n\thr_pnc2 integer,\n\thr_pnc3 integer,\n\thr_pnc4 integer,\n\thr_maternal_death integer,\n\thr_sc integer,\n\thr_phc integer,\n\thr_fru_chc integer,\n\thr_non_fru_chc integer,\n\thr_sdh integer,\n\thr_uhc integer,\n\thr_gia integer,\n\thr_medi_college integer,\n\thr_taluka_hospi integer,\n\thr_pvt integer,\n\thr_home_del_by_sba integer,\n\thr_home_del_by_non_sba integer,\n\tprimary key(location_id,month_year)\n);\n\ninsert into rch_lmp_base_location_wise_data_point_t(\n\tlocation_id,month_year,financial_year,\n\tanc_reg,\n\tabortion,mtp,no_of_maternal_death,no_of_inst_del,no_of_home_del,home_del_by_sba,\n\thome_del_by_non_sba,delivery_108,delivery_out_of_state_govt,delivery_out_of_state_pvt,no_of_missing_del,no_of_not_missing_del,\n\thigh_risk_mother,pre_preg_pre_eclampsia,prev_anemia,prev_caesarian,prev_aph_pph,prev_abortion,multipara,\n\tcur_malaria_issue,cur_mal_presentation_issue,tb,diabetes,heart_kidney,hiv,sickle,thalessemia,\n\tearly_anc,anc1,anc2,anc3,anc4,\n\tfull_anc,ifa,\n\ttt1,tt2,tt_booster,tt2_tt_booster,\n\tlbirth,sbirth,home_del,breast_feeding,sc,phc,chc,sdh,uhc,gia,medi_college,taluka_hospi,pvt,del_over_due\n\t,ifa_30_tablet_in_30_day,ifa_30_tablet_in_31_to_61_day,ifa_30_tablet_in_61_to_90_day,hb_done\n\t,hb_more_then_11_in_91_to_360_days,ifa_180_with_hb_in_4_to_9_month,hb_between_7_to_11,ifa_360_with_hb_between_7_to_11_in_4_to_9_month\n\t,ca_180_given_in_2nd_trimester,ca_180_given_in_3rd_trimester,hr_anc_regd,\n\thr_tt1, hr_tt2_and_tt_boster, hr_tt2_tt_booster, hr_early_anc, hr_anc1, hr_anc2, hr_anc3,\n\thr_anc4, hr_no_of_delivery, hr_mtp, hr_abortion, hr_pnc1, hr_pnc2, hr_pnc3, hr_pnc4, hr_maternal_death,\n \thr_sc, hr_phc, hr_fru_chc, hr_non_fru_chc, hr_sdh, hr_uhc, hr_gia, hr_medi_college, hr_taluka_hospi, hr_pvt, hr_home_del_by_sba,\n\thr_home_del_by_non_sba\n)\nselect tracking_location_id,lmp_month_year,lmp_financial_year,\ncount(*) as anc_regd,\nsum(case when delivery_outcome in (''ABORTION'', ''SPONT_ABORTION'') then 1 else 0 end) as no_of_abortion,\nsum(case when delivery_outcome = ''MTP'' then 1 else 0 end) as no_of_mtp,\nsum(case when maternal_detah = true then 1 else 0 end) as no_of_death,\nsum(case when institutional_del and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as no_of_inst_del,\nsum(case when (home_del) and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as no_of_home_del,\nsum(case when home_del and delivery_outcome in (''LBIRTH'',''SBIRTH'') \n\tand (delivery_done_by is null  or delivery_done_by != ''NON-TBA'') then 1 else 0 end) as home_del_by_sba,\nsum(case when home_del and delivery_outcome in (''LBIRTH'',''SBIRTH'')\n\tand (delivery_done_by is not null  and delivery_done_by = ''NON-TBA'') then 1 else 0 end) as home_del_by_non_sba,\n\t\nsum(case when delivery_108 and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as delivery_108,\n\nsum(case when delivery_out_of_state_govt = true then 1 else 0 end) as delivery_out_of_state_govt,\nsum(case when delivery_out_of_state_pvt = true then 1 else 0 end) as delivery_out_of_state_pvt,\n\nsum(case when preg_reg_state in (''PENDING'',''PREGNANT'') \n\tand maternal_detah is false and edd <= current_date then 1 else 0 end) as no_of_missing_del,\nsum(case when preg_reg_state in (''PENDING'',''PREGNANT'') \n\tand maternal_detah is false and edd > current_date then 1 else 0 end) as no_of_not_missing_del,\t\nsum(case when high_risk_mother = true then 1 else 0 end) as high_risk_mother,\nsum(case when pre_preg_pre_eclampsia then 1 else 0 end) as pre_preg_pre_eclampsia,\nsum(case when pre_preg_anemia then 1 else 0 end) as prev_anemia,\nsum(case when pre_preg_caesarean_section then 1 else 0 end) as prev_caesarian,\nsum(case when pre_preg_aph or pre_preg_pph  then 1 else 0 end) as prev_aph_pph,\nsum(case when pre_preg_abortion then 1 else 0 end) as prev_abortion,\nsum(case when total_out_come>=3 then 1 else 0 end) as multipara,\nsum(case when cur_malaria_issue then 1 else 0 end) as cur_malaria_issue,\nsum(case when cur_mal_presentation_issue then 1 else 0 end) as cur_mal_presentation_issue,\nsum(case when chro_tb then 1 else 0 end) as tb,\nsum(case when chro_diabetes then 1 else 0 end) as diabetes,\nsum(case when chro_heart_kidney then 1 else 0 end) as heart_kidney,\nsum(case when chro_hiv then 1 else 0 end) as hiv,\nsum(case when chro_sickle then 1 else 0 end) as sickle,\nsum(case when chro_thalessemia then 1 else 0 end) as thalessemia,\nsum(case when early_anc then 1 else 0 end) as early_anc,\nsum(case when anc1 is not null then 1 else 0 end) as anc1,\nsum(case when anc2 is not null then 1 else 0 end) as anc2,\nsum(case when anc3 is not null then 1 else 0 end) as anc3,\nsum(case when anc4 is not null then 1 else 0 end) as anc4,\nsum(case when total_regular_anc >=4 and ifa >= 180 and (tt2_given is not null or tt_boster is not null) then 1 else 0 end) as full_anc,\nsum(case when ifa >= 180 then 1 else 0 end) as ifa,\nsum(case when tt1_given is not null then 1 else 0 end) as tt1,\nsum(case when tt2_given is not null then 1 else 0 end) as tt2,\nsum(case when tt_boster is not null then 1 else 0 end) as tt_boster,\nsum(case when tt2_tt_booster_given is not null then 1 else 0 end) as tt2_tt_booster,\nsum(case when delivery_outcome = ''LBIRTH'' then 1 else 0 end) as lbirth,\nsum(case when delivery_outcome = ''SBIRTH'' then 1 else 0 end) as sbirth,\nsum(case when home_del and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as home_del,\nsum(case when breast_feeding_in_one_hour = true then 1 else 0 end) as breast_feeding,\nsum(case when delivery_hospital in (''897'',''1062'') then 1 else 0 end) as sc,  \nsum(case when delivery_hospital in (''899'',''1061'') then 1 else 0 end) as phc,\nsum(case when delivery_hospital in (''895'',''1009'',''1084'') then 1 else 0 end) as chc,\nsum(case when delivery_hospital in (''890'',''1008'') then 1 else 0 end) as sdh,\nsum(case when delivery_hospital in (''894'',''1063'') then 1 else 0 end) as uhc,\nsum(case when delivery_hospital in (''1064'') then 1 else 0 end) as gia,\nsum(case when delivery_hospital in (''891'',''1012'') then 1 else 0 end) as medi_college,\nsum(case when delivery_hospital in (''896'',''1007'') then 1 else 0 end) as taluka_hospi,\nsum(case when delivery_hospital in (''893'',''898'',''1013'',''1010'') then 1 else 0 end) as pvt,\nsum(case when lmp_date + interval ''281 days'' < now() and delivery_outcome is null then 1 else 0  end) as del_over_due,\nsum(case when fa_tab_in_30_day >= 30 then 1 else 0  end) as ifa_30_tablet_in_30_day,\nsum(case when fa_tab_in_31_to_60_day >= 30 then 1 else 0  end) as ifa_30_tablet_in_31_to_61_day,\nsum(case when fa_tab_in_61_to_90_day >= 30 then 1 else 0  end) as ifa_30_tablet_in_61_to_90_day,\nsum(case when hb is not null then 1 else 0  end) as hb_done,\nsum(case when hb_between_90_to_360_days > 11 then 1 else 0  end) as hb_more_then_11_in_91_to_360_days,\nsum(case when hb_between_90_to_360_days > 11 and ifa_tab_in_4_month_to_9_month >= 180 then 1 else 0  end) as ifa_180_with_hb_in_4_to_9_month,\nsum(case when hb_between_90_to_360_days between 7 and 11 then 1 else 0  end) as hb_between_7_to_11,\nsum(case when hb_between_90_to_360_days between 7 and 11 and ifa_tab_in_4_month_to_9_month >= 180 then 1 else 0  end) as ifa_360_with_hb_between_7_to_11_in_4_to_9_month,\nsum(case when ca_tab_in_91_to_180_day >= 180 then 1 else 0  end) as ca_180_given_in_2nd_trimester,\nsum(case when ca_tab_in_181_to_360_day >= 180 then 1 else 0  end) as ca_180_given_in_3rd_trimester,\ncount(*) filter ( where high_risk_mother = true) as hr_anc_regd,\nsum(case when high_risk_mother = true and tt1_given is not null then 1 else 0 end) as hr_tt1,\nsum(case when high_risk_mother = true and tt_boster is not null and  tt2_given is not null then 1 else 0 end) as hr_tt2_and_tt_boster,\nsum(case when high_risk_mother = true and tt2_tt_booster_given is not null then 1 else 0 end) as hr_tt2_tt_booster,\nsum(case when high_risk_mother = true and early_anc then 1 else 0 end) as hr_early_anc,\nsum(case when high_risk_mother = true and anc1 is not null then 1 else 0 end) as hr_anc1,\nsum(case when high_risk_mother = true and anc2 is not null then 1 else 0 end) as hr_anc2,\nsum(case when high_risk_mother = true and anc3 is not null then 1 else 0 end) as hr_anc3,\nsum(case when high_risk_mother = true and anc4 is not null then 1 else 0 end) as hr_anc4,\nsum(case when high_risk_mother = true and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as hr_no_of_delivery,\nsum(case when high_risk_mother = true and delivery_outcome = ''MTP'' then 1 else 0 end) as hr_mtp,\nsum(case when high_risk_mother = true and delivery_outcome in (''ABORTION'', ''SPONT_ABORTION'') then 1 else 0 end) as hr_abortion,\nsum(case when high_risk_mother = true and pnc1 is not null then 1 else 0 end) as hr_pnc1,\nsum(case when high_risk_mother = true and pnc2 is not null then 1 else 0 end) as hr_pnc2,\nsum(case when high_risk_mother = true and pnc3 is not null then 1 else 0 end) as hr_pnc3,\nsum(case when high_risk_mother = true and pnc4 is not null then 1 else 0 end) as hr_pnc4,\nsum(case when high_risk_mother = true and maternal_detah = true then 1 else 0 end) as hr_maternal_death,\nsum(case when high_risk_mother = true and delivery_outcome in (''LBIRTH'',''SBIRTH'') and delivery_hospital in (''897'',''1062'') then 1 else 0 end) as hr_sc,  \nsum(case when high_risk_mother = true and delivery_outcome in (''LBIRTH'',''SBIRTH'') and delivery_hospital in (''899'',''1061'') then 1 else 0 end) as hr_phc,\nsum(case when high_risk_mother = true and delivery_outcome in (''LBIRTH'',''SBIRTH'') and is_fru and delivery_hospital in (''895'',''1009'',''1084'') then 1 else 0 end) as hr_fru_chc,\nsum(case when high_risk_mother = true and delivery_outcome in (''LBIRTH'',''SBIRTH'') and is_fru is false and delivery_hospital in (''895'',''1009'',''1084'') then 1 else 0 end) as hr_non_fru_chc,\nsum(case when high_risk_mother = true and delivery_outcome in (''LBIRTH'',''SBIRTH'') and delivery_hospital in (''890'',''1008'') then 1 else 0 end) as hr_sdh,\nsum(case when high_risk_mother = true and delivery_outcome in (''LBIRTH'',''SBIRTH'') and delivery_hospital in (''894'',''1063'') then 1 else 0 end) as hr_uhc,\nsum(case when high_risk_mother = true and delivery_outcome in (''LBIRTH'',''SBIRTH'') and delivery_hospital in (''1064'') then 1 else 0 end) as hr_gia,\nsum(case when high_risk_mother = true and delivery_outcome in (''LBIRTH'',''SBIRTH'') and delivery_hospital in (''891'',''1012'') then 1 else 0 end) as hr_medi_college,\nsum(case when high_risk_mother = true and delivery_outcome in (''LBIRTH'',''SBIRTH'') and delivery_hospital in (''896'',''1007'') then 1 else 0 end) as hr_taluka_hospi,\nsum(case when high_risk_mother = true and delivery_outcome in (''LBIRTH'',''SBIRTH'') and delivery_hospital in (''893'',''898'',''1013'',''1010'') then 1 else 0 end) as hr_pvt,\nsum(case when high_risk_mother = true and home_del and delivery_outcome in (''LBIRTH'',''SBIRTH'') \n\tand (delivery_done_by is null  or delivery_done_by != ''NON-TBA'') then 1 else 0 end) as hr_home_del_by_sba,\nsum(case when high_risk_mother = true and home_del and delivery_outcome in (''LBIRTH'',''SBIRTH'')\n\tand (delivery_done_by is not null  and delivery_done_by = ''NON-TBA'') then 1 else 0 end) as hr_home_del_by_non_sba\n\nfrom rch_pregnancy_analytics_details\nwhere is_valid_for_tracking_report = true\ngroup by tracking_location_id,lmp_month_year,lmp_financial_year;\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED14''\nwhere event_config_id = 39 and status = ''PROCESSED13'';\ncommit;\n---15\n----------------------------------------------------------------------------------------------------------------------------------------------\nbegin;\ndrop table if exists rch_delivery_date_base_location_wise_data_point_t;\ncreate table rch_delivery_date_base_location_wise_data_point_t (\n\tlocation_id bigint,\n\tmonth_year date,\n\t\n\tdel_reg integer,\n\tdel_reg_still_live_birth integer,\n\tpreg_reg integer,\n\tdel_less_eq_34 integer,\n\tdel_bet_35_37 integer,\n\tdel_greater_37 integer,\n\tcortico_steroid integer,\n\tmtp integer,\n\tlbirth integer,\n\tsbirth integer,\n\tabortion integer,\n\thome_del integer,\n\thome_del_by_sba integer,\n\thome_del_by_non_sba integer,\n\tbreast_feeding integer,\n\tsc integer,\n\tphc integer,\n\tchc integer,\n\tsdh integer,\n\tuhc integer,\n\tgia integer,\n\tpvt integer,\n\tmdh integer,\n\tdh integer,\n\tdelivery_108 integer,\n    \n    delivery_out_of_state_govt integer,\n    delivery_out_of_state_pvt integer,\n\n\tphi_del_3_ancs integer,\n\tinst_del integer,\n\tmaternal_detah integer,\n\tpnc1 integer,\n\tpnc2 integer,\n\tpnc3 integer,\n\tpnc4 integer,\n\tfull_pnc integer,\n\tifa_180_after_delivery integer,\n\tcalcium_360_after_delivery integer,\n\t\n\tprimary key(location_id,month_year)\t\n);\n\ninsert into rch_delivery_date_base_location_wise_data_point_t(\n\tlocation_id,month_year,\n\tdel_reg,del_reg_still_live_birth,del_less_eq_34,del_bet_35_37,del_greater_37,cortico_steroid,\n\tmtp,abortion,lbirth,sbirth,home_del,home_del_by_sba,home_del_by_non_sba,breast_feeding,\n\tsc,phc,chc,sdh,uhc,gia,pvt,mdh,dh,delivery_108,delivery_out_of_state_govt,delivery_out_of_state_pvt,\n\tphi_del_3_ancs,inst_del,pnc1,pnc2,pnc3,pnc4,full_pnc,ifa_180_after_delivery\n)\nselect delivery_location_id,\ncast(date_trunc(''month'',date_of_delivery_month_year) as date) as month_year,\ncount(*),\nsum(case when delivery_outcome in(''LBIRTH'',''SBIRTH'') and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as del_reg_still_live_birth,\nsum(case when del_week <= 34 and delivery_outcome in(''LBIRTH'',''SBIRTH'') and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as del_less_eq_34,\nsum(case when del_week between 35 and 37 and delivery_outcome in(''LBIRTH'',''SBIRTH'') and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as del_bet_35_37,\nsum(case when del_week > 37 and delivery_outcome in(''LBIRTH'',''SBIRTH'') and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as del_greater_37,\nsum(case when del_week <= 34 and delivery_outcome in(''LBIRTH'',''SBIRTH'') and is_cortico_steroid and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as cortico_steroid,\nsum(case when delivery_outcome = ''MTP'' and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as mtp,\nsum(case when delivery_outcome in (''ABORTION'', ''SPONT_ABORTION'') and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as abortion,\nsum(case when delivery_outcome = ''LBIRTH'' and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then total_out_come else 0 end) as lbirth,\nsum(case when (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then still_birth else 0 end) as sbirth,\nsum(case when home_del and delivery_outcome in (''LBIRTH'',''SBIRTH'') and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as home_del,\nsum(case when home_del and delivery_outcome in (''LBIRTH'',''SBIRTH'') \n\tand (delivery_done_by is null  or delivery_done_by != ''NON-TBA'') and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as home_del_by_sba,\nsum(case when home_del and delivery_outcome in (''LBIRTH'',''SBIRTH'') and delivery_done_by is not null \n\tand delivery_done_by = ''NON-TBA'' and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as home_del_by_non_sba,\nsum(case when delivery_hospital in (''897'',''1062'',''899'',''1061'',''895'',''1009'',''890'',''1008'',''894'',''1063'',''892'',''891'',''1012'',''896'',''1007'',''1084'') \n\tand delivery_outcome in (''LBIRTH'',''SBIRTH'') and breast_feeding_in_one_hour = true \n\tthen 1 else 0 end) as breast_feeding,\nsum(case when institutional_del  and  delivery_hospital in (''897'',''1062'') and delivery_outcome in (''LBIRTH'',''SBIRTH'')  then 1 else 0 end) as sc,  \nsum(case when institutional_del  and  delivery_hospital in (''899'',''1061'') and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as phc,\nsum(case when institutional_del  and  delivery_hospital in (''895'',''1009'',''1084'') and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as chc,\nsum(case when institutional_del  and  delivery_hospital in (''890'',''1008'') and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as sdh,\nsum(case when institutional_del  and  delivery_hospital in (''894'',''1063'') and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as uhc,\nsum(case when institutional_del  and  delivery_hospital in (''1064'') and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as gia,\nsum(case when institutional_del  and  delivery_hospital in (''893'',''898'',''1013'',''1010'') and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as pvt,\nsum(case when institutional_del  and  delivery_hospital in (''891'',''1012'') and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as mdh,\nsum(case when institutional_del  and  delivery_hospital in (''896'',''1007'') and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as dh,\nsum(case when delivery_108 and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as delivery_108,\n\nsum(case when delivery_out_of_state_govt = true then 1 else 0 end) as delivery_out_of_state_govt,\nsum(case when delivery_out_of_state_pvt = true then 1 else 0 end) as delivery_out_of_state_pvt,\n\nsum(case when ((institutional_del  and delivery_hospital in (''897'',''1062'',''899'',''1061'',''895'',''1009'',''890'',''1008'',''894'',''1063'',''892'',''891'',''1012'',''896'',''1007'',''1084'')) \n\tor delivery_108)\n\tand delivery_outcome in (''LBIRTH'',''SBIRTH'') and total_regular_anc >= 3  then 1 else 0 end) as phi_del_3_ancs,\nsum(case when (institutional_del) and delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as no_of_inst_del,\nsum(case when pnc1 is not null then 1 else 0 end) as pnc1,\nsum(case when pnc2 is not null then 1 else 0 end) as pnc2,\nsum(case when pnc3 is not null then 1 else 0 end) as pnc3,\nsum(case when pnc4 is not null then 1 else 0 end) as pnc4,\nsum(case when pnc4 is not null and ifa_tab_after_delivery >= 180 then 1 else 0 end) as full_pnc,\nsum(case when ifa_tab_after_delivery >= 180 then 1 else 0 end) as ifa_180_after_delivery\n--,sum(case when maternal_detah then 1 else 0 end) as maternal_death\nfrom rch_pregnancy_analytics_details\nwhere date_of_delivery_month_year is not null and delivery_outcome is not null\ngroup by delivery_location_id,date_of_delivery_month_year;\n\n\nwith del_det as(\n\tselect rprd.native_location_id as location_id\n\t,cast(date_trunc(''month'', rprd.reg_service_date) as date) as month_year,\n\tcount(*) as anc_reg,\n\tsum(case when early_anc then 1 else 0 end) as early_anc\n\tfrom rch_pregnancy_analytics_details rprd\n\twhere rprd.reg_service_date >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n\tgroup by rprd.native_location_id,cast(date_trunc(''month'', rprd.reg_service_date) as date)\n),maternal_death_detail as (\n\tselect rch_pregnancy_analytics_details.death_location_id as location_id,\n\tcast(date_trunc(''month'', rch_pregnancy_analytics_details.death_date) as date) as month_year,\n\tcount(*) as maternal_detah \n\tfrom rch_pregnancy_analytics_details\n\twhere rch_pregnancy_analytics_details.death_date >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n\tand rch_pregnancy_analytics_details.maternal_detah = true\n\tgroup by rch_pregnancy_analytics_details.death_location_id\n\t,cast(date_trunc(''month'', rch_pregnancy_analytics_details.death_date) as date)\n),location_det as (\nselect location_id,month_year from del_det\n\tunion\nselect location_id,month_year from maternal_death_detail\t\n)\ninsert into rch_delivery_date_base_location_wise_data_point_t(location_id,month_year)\nselect location_det.location_id,location_det.month_year \nfrom location_det\nleft join rch_delivery_date_base_location_wise_data_point_t \non location_det.location_id = rch_delivery_date_base_location_wise_data_point_t.location_id\nand location_det.month_year = rch_delivery_date_base_location_wise_data_point_t.month_year\nwhere rch_delivery_date_base_location_wise_data_point_t.location_id is null;\n\n\nwith maternal_death_detail as(\n\tselect rch_pregnancy_analytics_details.death_location_id as location_id,\n\tcast(date_trunc(''month'', rch_pregnancy_analytics_details.death_date) as date) as month_year,\n\tcount(*) as maternal_detah \n\tfrom rch_pregnancy_analytics_details\n\twhere rch_pregnancy_analytics_details.death_date >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n\tand rch_pregnancy_analytics_details.maternal_detah = true\n\tgroup by rch_pregnancy_analytics_details.death_location_id\n\t,cast(date_trunc(''month'', rch_pregnancy_analytics_details.death_date) as date)\n)\t\nupdate rch_delivery_date_base_location_wise_data_point_t \nset maternal_detah = maternal_death_detail.maternal_detah\nfrom maternal_death_detail where maternal_death_detail.location_id = rch_delivery_date_base_location_wise_data_point_t.location_id\nand maternal_death_detail.month_year = rch_delivery_date_base_location_wise_data_point_t.month_year;\n\nwith del_det as(\n\tselect rprd.native_location_id as location_id,cast(date_trunc(''month'', rprd.reg_service_date) as date) as month_year,\n\tcount(*) as anc_reg,\n\tsum(case when early_anc then 1 else 0 end) as early_anc\n\tfrom rch_pregnancy_analytics_details rprd\n\twhere rprd.reg_service_date >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n\tgroup by rprd.native_location_id,cast(date_trunc(''month'', rprd.reg_service_date) as date)\n)\t\nupdate rch_delivery_date_base_location_wise_data_point_t \nset preg_reg = anc_reg\nfrom del_det where del_det.location_id = rch_delivery_date_base_location_wise_data_point_t.location_id\nand del_det.month_year = rch_delivery_date_base_location_wise_data_point_t.month_year;\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED15''\nwhere event_config_id = 39 and status = ''PROCESSED14'';\ncommit;\n---16\n------------------------------------------------------------------------------------------------------------------------------------\nbegin;\ndrop table if exists rch_yearly_location_wise_analytics_data_t;\ncreate table rch_yearly_location_wise_analytics_data_t (\n\tlocation_id bigint,\n\tfinancial_year text,\n\tmonth_year date,\n\tage_less_15 integer,\n\tage_15_19 integer,\n\tage_20_24 integer,\n\tage_25_29 integer,\n\tage_30_34 integer,\n\tage_35_39 integer,\n\tage_40_44 integer,\n\tage_45_49 integer,\n\tage_greater_49 integer,\n\tanc_reg integer,\n\thbsag_test integer,\n\tnon_reactive integer,\n\treactive integer,\n\t\n\ttt1 integer,\n\ttt2_tt_booster integer,\n\tearly_anc integer,\n\tanc1 integer,\n\tanc2 integer,\n\tanc3 integer,\n\tanc4 integer,\n\tno_of_del integer,\n\tmtp integer,\n\tabortion integer,\n\tpnc1 integer,\n\tpnc2 integer,\n\tpnc3 integer,\n\tpnc4 integer,\n\tmaternal_detah integer,\n\tprimary key(location_id,financial_year,month_year)\n);\n\ninsert into rch_yearly_location_wise_analytics_data_t(\n\tlocation_id,financial_year,month_year,\n\tage_less_15,age_15_19,age_20_24,age_25_29,age_30_34,age_35_39,age_40_44,age_45_49,age_greater_49,anc_reg,\n\thbsag_test,non_reactive,reactive,\n\ttt1,tt2_tt_booster,early_anc,anc1,anc2,anc3,anc4,no_of_del,mtp,abortion,pnc1,pnc2,pnc3,pnc4,maternal_detah\n)\nselect rprd.tracking_location_id,rprd.reg_service_financial_year,rprd.reg_service_date_month_year,\nsum(case when age_during_delivery < 15 then 1 else 0 end) as age_less_15,\nsum(case when age_during_delivery between 15 and 19 then 1 else 0 end) as age_15_19,\nsum(case when age_during_delivery between 20 and 24 then 1 else 0 end) as age_20_24,\nsum(case when age_during_delivery between 25 and 29 then 1 else 0 end) as age_25_29,\nsum(case when age_during_delivery between 30 and 34 then 1 else 0 end) as age_30_34,  \nsum(case when age_during_delivery between 35 and 39 then 1 else 0 end) as age_35_39,\nsum(case when age_during_delivery between 40 and 44 then 1 else 0 end) as age_40_44,\nsum(case when age_during_delivery between 45 and 49 then 1 else 0 end) as age_45_49, \nsum(case when age_during_delivery > 49 then 1 else 0 end) as age_greater_49,\ncount(*) as anc_reg,\nsum(hbsag_test_cnt) as hbsag_test,              \nsum(hbsag_non_reactive_cnt) as non_reactive,          \nsum(hbsag_reactive_cnt) as reactive,\nsum(case when tt1_given is not null then 1 else 0 end) as tt1,\nsum(case when tt2_given is not null or tt_boster is not null  then 1 else 0 end) as tt2,\nsum(case when early_anc then 1 else 0 end) as early_anc,\nsum(case when total_regular_anc >=1 then 1 else 0 end) as anc1,\nsum(case when total_regular_anc >=2 then 1 else 0 end) as anc2,\nsum(case when total_regular_anc >=3 then 1 else 0 end) as anc3,\nsum(case when total_regular_anc >=4 then 1 else 0 end) as anc4,\nsum(case when delivery_outcome in (''LBIRTH'',''SBIRTH'') and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as no_of_del,\nsum(case when delivery_outcome = ''MTP'' and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as mtp,         \nsum(case when delivery_outcome in (''ABORTION'', ''SPONT_ABORTION'') and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as abortion,\nsum(case when pnc1 is not null then 1 else 0 end) as pnc1,\nsum(case when pnc2 is not null then 1 else 0 end) as pnc2,\nsum(case when pnc3 is not null then 1 else 0 end) as pnc3,\nsum(case when pnc4 is not null then 1 else 0 end) as pnc4,\nsum(case when maternal_detah then 1 else 0 end) as maternal_detah\nfrom rch_pregnancy_analytics_details rprd\nwhere is_valid_for_tracking_report = true\ngroup by rprd.tracking_location_id,rprd.reg_service_financial_year,rprd.reg_service_date_month_year;\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED16''\nwhere event_config_id = 39 and status = ''PROCESSED15'';\ncommit;\n\n\n---17\n-----------------------------------------------------------------------------------------------------------------------------------------\nbegin;\ndrop table if exists rch_current_state_pregnancy_analytics_data_t;\ncreate table rch_current_state_pregnancy_analytics_data_t (\n\tlocation_id bigint primary key,\n\treg_preg_women integer,\n\thigh_risk integer,\n\tprev_compl integer,\n\tchronic integer,\n\ttwo_or_more_risk integer,\n\tcurrent_preg_compl integer,\n\tsevere_anemia integer,\n\tdiabetes integer,\n\tcur_mal_presentation_issue bigint,\n\tcur_malaria_issue bigint,\n\tmultipara bigint,\n\tblood_pressure integer,\n\tinterval_bet_preg_less_18_months integer,\n\textreme_age integer,\n\theight integer,\n\tweight  integer,\n\turine_albumin integer,\n\tanc_in_2or3_trim integer,\n\talben_given integer,\n\talben_not_given integer,\n\t\n\tpre_preg_pre_eclampsia bigint,\n\tprev_anemia bigint,\n\tprev_caesarian bigint,\n\tprev_aph_pph bigint,\n\tprev_abortion bigint,\n\t\n\tchro_tb bigint,\n\tchro_diabetes bigint,\n\tchro_heart_kidney bigint,\n\tchro_hiv bigint,\n\tchro_sickle bigint,\n\tchro_thalessemia bigint\n);\n\ninsert into rch_current_state_pregnancy_analytics_data_t(\n\tlocation_id,reg_preg_women,high_risk,two_or_more_risk,prev_compl,chronic,current_preg_compl\n\t,severe_anemia,blood_pressure,diabetes,cur_mal_presentation_issue,cur_malaria_issue,multipara,extreme_age,height,weight,urine_albumin\n\t,anc_in_2or3_trim,alben_given,alben_not_given,interval_bet_preg_less_18_months\n\t,pre_preg_pre_eclampsia,prev_anemia,prev_caesarian,prev_aph_pph,prev_abortion\n\t,chro_tb,chro_diabetes,chro_heart_kidney,chro_hiv,chro_sickle,chro_thalessemia\n) \nselect member_current_location_id,\ncount(*) as reg_preg_women,\nsum(case when high_risk_mother = true then 1 else 0 end) as high_risk,\nsum(case when high_risk_cnt >= 2 then 1 else 0 end) as two_or_more_risk,\nsum(case when any_prev_preg_complication then 1 else 0 end) as prev_compl,\nsum(case when any_chronic_dis then 1 else 0 end) as chronic,\nsum(case when any_cur_preg_complication then 1 else 0 end) as current_preg_compl,\nsum(case when cur_severe_anemia then 1 else 0 end) as severe_anemia,\nsum(case when cur_blood_pressure_issue then 1 else 0 end) as blood_pressure,\nsum(case when cur_gestational_diabetes_issue then 1 else 0 end) as diabetes,\nsum(case when cur_mal_presentation_issue then 1 else 0 end) as cur_mal_presentation_issue,\nsum(case when cur_malaria_issue then 1 else 0 end) as cur_malaria_issue,\nsum(case when total_out_come>=3 then 1 else 0 end) as multipara,\nsum(case when cur_extreme_age then 1 else 0 end) as extreme_age,\nsum(case when low_height then 1 else 0 end) as height,\nsum(case when cur_low_weight then 1 else 0 end) as weight,\nsum(case when urine_albumin then 1 else 0 end) as urine_albumin,\nsum(case when current_date - lmp_date between 92 and 245 then 1 else 0 end) anc_in_2or3_trim,\nsum(case when current_date - lmp_date between 92 and 245 and alben_given then 1 else 0 end) alben_given,\nsum(case when current_date - lmp_date between 92 and 245 and (alben_given is null or alben_given = false) then 1 else 0 end) alben_not_given,\nsum(case when cur_less_than_18_month_interval then 1 else 0 end) interval_bet_preg_less_18_months,\n\nsum(case when pre_preg_pre_eclampsia then 1 else 0 end) as pre_preg_pre_eclampsia,\nsum(case when pre_preg_anemia then 1 else 0 end) as prev_anemia,\nsum(case when pre_preg_caesarean_section then 1 else 0 end) as prev_caesarian,\nsum(case when pre_preg_aph or pre_preg_pph  then 1 else 0 end) as prev_aph_pph,\nsum(case when pre_preg_abortion then 1 else 0 end) as prev_abortion,\nsum(case when chro_tb then 1 else 0 end) as tb,\nsum(case when chro_diabetes then 1 else 0 end) as diabetes,\nsum(case when chro_heart_kidney then 1 else 0 end) as heart_kidney,\nsum(case when chro_hiv then 1 else 0 end) as hiv,\nsum(case when chro_sickle then 1 else 0 end) as sickle,\nsum(case when chro_thalessemia then 1 else 0 end) as thalessemia\nfrom rch_pregnancy_analytics_details\nwhere rch_pregnancy_analytics_details.member_basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')\nand preg_reg_state in (''PENDING'',''PREGNANT'')\nand is_valid_for_tracking_report = true\ngroup by member_current_location_id;\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED17''\nwhere event_config_id = 39 and status = ''PROCESSED16'';\ncommit;\n\n---18\n--------------------------------------------------------------------------------------------------------------------------------------\nbegin;\ndrop table if exists rch_service_provided_during_year_t;\ncreate table rch_service_provided_during_year_t (\n    location_id bigint,\n    month_year date,\n    financial_year text,\n    anc_reg integer,\n    anc_coverage integer,\n    regd_live_children integer,\n    regd_no_live_children integer,\n    c1_m1 integer,\n    c1_f1 integer,\n    c2_f2 integer,\n    c2_m2 integer,\n    c2_f1_m1 integer,\n    c3_f3 integer,\n    c3_m3 integer,\n    c3_m2_f1 integer,\n    c3_m1_f2 integer,\n\n    high_risk integer,\n    current_preg_compl integer,\n    severe_anemia integer,\n    diabetes integer,\n    cur_mal_presentation_issue bigint,\n    cur_malaria_issue bigint,\n    multipara bigint,\n    blood_pressure integer,\n    interval_bet_preg_less_18_months integer,\n    extreme_age integer,\n    height integer,\n    weight  integer,\n    urine_albumin integer,\n\n\n    tt1 integer,\n    tt2_tt_booster integer,\n    early_anc integer,\n    anc1 integer,\n    anc2 integer,\n    anc3 integer,\n    anc4 integer,\n    no_of_delivery integer,\n    mtp integer,\n    abortion integer,\n    live_birth integer,\n    still_birth integer,\n    pnc1 integer,\n    pnc2 integer,\n    pnc3 integer,\n    pnc4 integer,\n    mother_death integer,\n    ppiucd integer,\n\n    complete_anc_date integer,\n    ifa_180_anc_date integer,\n\tphi_del integer,\n\tphi_del_with_ppiucd integer,\n\n\n    primary key (location_id, month_year)\n);\n\n\nwith rch_service_yearly_pregnancy_reg as (\n    select rprd.native_location_id as location_id,cast(date_trunc(''month'', rprd.reg_service_date) as date) as month_year,\n    count(*) as anc_reg,\n    sum(case when anc1 is not null and anc2 is not null and anc3 is not null and anc4 is not null then 1 else 0 end) as anc_coverage, \n    sum(case when early_anc then 1 else 0 end) as early_anc,\n    sum(case when high_risk_mother = true then 1 else 0 end) as high_risk,\n    sum(case when any_cur_preg_complication then 1 else 0 end) as current_preg_compl,\n    sum(case when cur_severe_anemia then 1 else 0 end) as severe_anemia,\n    sum(case when cur_blood_pressure_issue then 1 else 0 end) as blood_pressure,\n    sum(case when cur_gestational_diabetes_issue then 1 else 0 end) as diabetes,\n    sum(case when cur_mal_presentation_issue then 1 else 0 end) as cur_mal_presentation_issue,\n    sum(case when cur_malaria_issue then 1 else 0 end) as cur_malaria_issue,\n    sum(case when total_out_come>=3 then 1 else 0 end) as multipara,\n    sum(case when cur_extreme_age then 1 else 0 end) as extreme_age,\n    sum(case when low_height then 1 else 0 end) as height,\n    sum(case when cur_low_weight then 1 else 0 end) as weight,\n    sum(case when urine_albumin then 1 else 0 end) as urine_albumin,\n    sum(case when cur_less_than_18_month_interval then 1 else 0 end) interval_bet_preg_less_18_months,\n\n    sum(case when registered_with_no_of_child > 0 then 1 else 0 end) as regd_live_children,\n    sum(case when registered_with_no_of_child = 0 or registered_with_no_of_child is null then 1 else 0 end) as regd_no_live_children,\n    sum(case when registered_with_no_of_child = 1 and registered_with_male_cnt = 1 then 1 else 0 end) as c1_m1,\n    sum(case when registered_with_no_of_child = 1 and registered_with_female_cnt = 1 then 1 else 0 end) as c1_f1,\n    sum(case when registered_with_no_of_child = 2 and registered_with_female_cnt = 2 then 1 else 0 end) as c2_f2,\n    sum(case when registered_with_no_of_child = 2 and registered_with_male_cnt = 2 then 1 else 0 end) as c2_m2,\n    sum(case when registered_with_no_of_child = 2 and registered_with_male_cnt = 1 and registered_with_female_cnt = 1 then 1 else 0 end) as c2_f1_m1,\n    sum(case when registered_with_no_of_child = 3 and registered_with_female_cnt = 3 then 1 else 0 end) as c3_f3,\n    sum(case when registered_with_no_of_child = 3 and registered_with_male_cnt = 3 then 1 else 0 end) as c3_m3,\n    sum(case when registered_with_no_of_child = 3 and registered_with_male_cnt = 2 and registered_with_female_cnt = 1 then 1 else 0 end) as c3_m2_f1,\n    sum(case when registered_with_no_of_child = 3 and registered_with_male_cnt = 1 and registered_with_female_cnt = 2 then 1 else 0 end) as c3_m1_f2,\n\tsum(case when ((institutional_del  and delivery_hospital in (''897'',''1062'',''899'',''1061'',''895'',''1009'',''890'',''1008'',''894'',''1063'',''892'',''891'',''1012'',''896'',''1007'',''1084'')) \n\tor delivery_108)\n\tand delivery_outcome in (''LBIRTH'',''SBIRTH'') then 1 else 0 end) as phi_del,\n\tsum(case when ((institutional_del  and delivery_hospital in (''897'',''1062'',''899'',''1061'',''895'',''1009'',''890'',''1008'',''894'',''1063'',''892'',''891'',''1012'',''896'',''1007'',''1084'')) \n\tor delivery_108)\n\tand delivery_outcome in (''LBIRTH'',''SBIRTH'') and ppiucd_insert_date is not null then 1 else 0 end) as phi_del_with_ppiucd\n\n    from rch_pregnancy_analytics_details rprd\n    where rprd.reg_service_date >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n    group by rprd.native_location_id,cast(date_trunc(''month'', rprd.reg_service_date) as date)\n), rch_yearly_vacination_tt1 as (\n    select rch_pregnancy_analytics_details.tt1_location_id as location_id\n    ,cast(date_trunc(''month'', rch_pregnancy_analytics_details.tt1_given) as date) as month_year\n    ,sum(1) as tt1\n    from rch_pregnancy_analytics_details\n    where rch_pregnancy_analytics_details.tt1_given >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n    group by rch_pregnancy_analytics_details.tt1_location_id, cast(date_trunc(''month'', rch_pregnancy_analytics_details.tt1_given) as date)\n), rch_yearly_vacination_tt2_tt_booster as (\n    select rch_pregnancy_analytics_details.tt2_tt_booster_location_id as location_id,\n    cast(date_trunc(''month'', rch_pregnancy_analytics_details.tt2_tt_booster_given) as date) as month_year,\n    sum(1) as tt2_tt_booster\n    from rch_pregnancy_analytics_details\n    where rch_pregnancy_analytics_details.tt2_tt_booster_given >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n    group by rch_pregnancy_analytics_details.tt2_tt_booster_location_id, cast(date_trunc(''month'', rch_pregnancy_analytics_details.tt2_tt_booster_given) as date)\n), rch_yearly_anc1 as (\n    select rch_pregnancy_analytics_details.anc1_location_id as location_id,\n    cast(date_trunc(''month'', rch_pregnancy_analytics_details.anc1) as date) as month_year,\n    sum(1) as anc1\n    from rch_pregnancy_analytics_details\n    where anc1 >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n    group by rch_pregnancy_analytics_details.anc1_location_id, cast(date_trunc(''month'', rch_pregnancy_analytics_details.anc1) as date)\n), rch_yearly_anc2 as (\n    select rch_pregnancy_analytics_details.anc2_location_id as location_id,\n    cast(date_trunc(''month'', rch_pregnancy_analytics_details.anc2) as date) as month_year,\n    sum(1) as anc2\n    from rch_pregnancy_analytics_details\n    where anc2 >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n    group by rch_pregnancy_analytics_details.anc2_location_id, cast(date_trunc(''month'', rch_pregnancy_analytics_details.anc2) as date)\n), rch_yearly_anc3 as (\n    select rch_pregnancy_analytics_details.anc3_location_id as location_id,\n    cast(date_trunc(''month'', rch_pregnancy_analytics_details.anc3) as date) as month_year,\n    sum(1) as anc3\n    from rch_pregnancy_analytics_details\n    where anc3 >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n    group by rch_pregnancy_analytics_details.anc3_location_id, cast(date_trunc(''month'', rch_pregnancy_analytics_details.anc3) as date)\n), rch_yearly_anc4 as (\n    select rch_pregnancy_analytics_details.anc4_location_id as location_id,\n    cast(date_trunc(''month'', rch_pregnancy_analytics_details.anc4) as date) as month_year,\n    sum(1) as anc4\n    from rch_pregnancy_analytics_details\n    where anc4 >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n    group by rch_pregnancy_analytics_details.anc4_location_id,cast(date_trunc(''month'', rch_pregnancy_analytics_details.anc4) as date)\n), rch_wpd_anc_det as (\n    select rprd.delivery_location_id as location_id\n    ,cast(date_trunc(''month'', rprd.delivery_reg_date) as date) as month_year,\n    sum(case when delivery_outcome in (''LBIRTH'',''SBIRTH'') and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as no_of_delivery,\n    sum(case when delivery_outcome = ''MTP'' and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as mtp,\n    sum(case when delivery_outcome in (''ABORTION'', ''SPONT_ABORTION'') and (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then 1 else 0 end) as abortion,\n    sum(case when (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then live_birth else 0 end) as live_birth,\n    sum(case when (delivery_out_of_state_govt is false and delivery_out_of_state_pvt is false) then still_birth else 0 end) as still_birth\n    from rch_pregnancy_analytics_details rprd\n    where rprd.delivery_reg_date >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n    group by rprd.delivery_location_id,cast(date_trunc(''month'', rprd.delivery_reg_date) as date)\n), rch_yearly_pnc1 as (\n    select rch_pregnancy_analytics_details.pnc1_location_id as location_id,\n    cast(date_trunc(''month'', rch_pregnancy_analytics_details.pnc1) as date) as month_year,\n    sum(case when pnc1 >= to_date(''01-04-2013'',''DD-MM-YYYY'') then 1 else 0 end) as pnc1\n    from rch_pregnancy_analytics_details\n    where pnc1 >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n    group by rch_pregnancy_analytics_details.pnc1_location_id, cast(date_trunc(''month'', rch_pregnancy_analytics_details.pnc1) as date)\n), rch_yearly_pnc2 as (\n    select rch_pregnancy_analytics_details.pnc2_location_id as location_id,\n    cast(date_trunc(''month'', rch_pregnancy_analytics_details.pnc2) as date) as month_year,\n    sum(case when pnc2 >= to_date(''01-04-2013'',''DD-MM-YYYY'') then 1 else 0 end) as pnc2\n    from rch_pregnancy_analytics_details\n    where pnc2 >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n    group by rch_pregnancy_analytics_details.pnc2_location_id, cast(date_trunc(''month'', rch_pregnancy_analytics_details.pnc2) as date)\n), rch_yearly_pnc3 as (\n    select rch_pregnancy_analytics_details.pnc3_location_id as location_id,\n    cast(date_trunc(''month'', rch_pregnancy_analytics_details.pnc3) as date) as month_year,\n    sum(case when pnc3 >= to_date(''01-04-2013'',''DD-MM-YYYY'') then 1 else 0 end) as pnc3\n    from rch_pregnancy_analytics_details\n    where pnc3 >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n    group by rch_pregnancy_analytics_details.pnc3_location_id, cast(date_trunc(''month'', rch_pregnancy_analytics_details.pnc3) as date)\n), rch_yearly_pnc4 as (\n    select rch_pregnancy_analytics_details.pnc4_location_id as location_id,\n    cast(date_trunc(''month'', rch_pregnancy_analytics_details.pnc4) as date) as month_year,\n    sum(case when pnc4 >= to_date(''01-04-2013'',''DD-MM-YYYY'') then 1 else 0 end) as pnc4\n    from rch_pregnancy_analytics_details\n    where pnc4 >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n    group by rch_pregnancy_analytics_details.pnc4_location_id, cast(date_trunc(''month'', rch_pregnancy_analytics_details.pnc4) as date)\n), rch_yearly_maternal_death_det as (\n    select rch_pregnancy_analytics_details.death_location_id as location_id,\n    cast(date_trunc(''month'', rch_pregnancy_analytics_details.death_date) as date) as month_year,\n    count(*) as maternal_detah\n    from rch_pregnancy_analytics_details\n    where rch_pregnancy_analytics_details.death_date >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n    and rch_pregnancy_analytics_details.maternal_detah = true\n    group by rch_pregnancy_analytics_details.death_location_id,cast(date_trunc(''month'', rch_pregnancy_analytics_details.death_date) as date)\n), ppiucd_det as (\n    select rch_pregnancy_analytics_details.ppiucd_insert_location as location_id,\n    cast(date_trunc(''month'', rch_pregnancy_analytics_details.ppiucd_insert_date) as date) as month_year,\n    count(*) filter (where delivery_hospital in (''897'',''1062'',''899'',''1061'',''895'',''1009'',''890'',''1008'',''894'',''1063'',''892'',''891'',''1012'',''896'',''1007'',''1084'')) as ppiucd\n    from rch_pregnancy_analytics_details\n    where rch_pregnancy_analytics_details.ppiucd_insert_date is not null and rch_pregnancy_analytics_details.institutional_del = true\n    group by rch_pregnancy_analytics_details.ppiucd_insert_location,cast(date_trunc(''month'', rch_pregnancy_analytics_details.ppiucd_insert_date) as date)\n), complete_anc_date_det as (\n    select rch_pregnancy_analytics_details.complete_anc_location as location_id,\n    cast(date_trunc(''month'', rch_pregnancy_analytics_details.complete_anc_date) as date) as month_year,\n    sum(1) as complete_anc_date\n    from rch_pregnancy_analytics_details\n    where complete_anc_date >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n    group by rch_pregnancy_analytics_details.complete_anc_location, cast(date_trunc(''month'', rch_pregnancy_analytics_details.complete_anc_date) as date)\n)\n, ifa_180_anc_date_det as (\n    select rch_pregnancy_analytics_details.ifa_180_anc_location as location_id,\n    cast(date_trunc(''month'', rch_pregnancy_analytics_details.ifa_180_anc_date) as date) as month_year,\n    sum(1) as ifa_180_anc_date\n    from rch_pregnancy_analytics_details\n    where ifa_180_anc_date >= to_date(''01-04-2013'',''DD-MM-YYYY'')\n    group by rch_pregnancy_analytics_details.ifa_180_anc_location, cast(date_trunc(''month'', rch_pregnancy_analytics_details.ifa_180_anc_date) as date)\n)\n\n, locations as (\n    select distinct location_id, month_year from (\n    select location_id, month_year from rch_service_yearly_pregnancy_reg\n    union\n    select location_id, month_year from rch_yearly_vacination_tt1\n    union\n    select location_id, month_year from rch_yearly_vacination_tt2_tt_booster\n    union\n    select location_id, month_year from rch_yearly_anc1\n    union\n    select location_id, month_year from rch_yearly_anc2\n    union\n    select location_id, month_year from rch_yearly_anc3\n    union\n    select location_id, month_year from rch_yearly_anc4\n    union\n    select location_id, month_year from rch_wpd_anc_det\n    union\n    select location_id, month_year from rch_yearly_pnc1\n    union\n    select location_id, month_year from rch_yearly_pnc2\n    union\n    select location_id, month_year from rch_yearly_pnc3\n    union\n    select location_id, month_year from rch_yearly_pnc4\n    union\n    select location_id, month_year from rch_yearly_maternal_death_det\n    union\n    select location_id, month_year from ppiucd_det\n    union\n    select location_id, month_year from complete_anc_date_det\n    union\n    select location_id, month_year from ifa_180_anc_date_det\n    ) as t where location_id is not null\n)\ninsert into rch_service_provided_during_year_t (\n    location_id,month_year,financial_year,anc_reg, anc_coverage,\n\n    regd_live_children,regd_no_live_children,c1_m1,c1_f1,c2_f2,c2_m2,c2_f1_m1,c3_f3,c3_m3,c3_m2_f1,c3_m1_f2,phi_del,phi_del_with_ppiucd\n\n    ,high_risk,current_preg_compl,severe_anemia,diabetes,\n    cur_mal_presentation_issue,cur_malaria_issue,multipara,\n    blood_pressure,interval_bet_preg_less_18_months,extreme_age,\n    height,weight,urine_albumin,\n\n    tt1,tt2_tt_booster,\n    early_anc,anc1,anc2,anc3,anc4,\n    no_of_delivery,mtp,abortion,live_birth,still_birth,\n    pnc1,pnc2,pnc3,pnc4,mother_death\n    ,ppiucd\n    ,complete_anc_date\n    ,ifa_180_anc_date\n\n)\nselect locations.location_id, locations.month_year\n,case when extract(month from locations.month_year) > 3\n    then concat(extract(year from locations.month_year), ''-'', extract(year from locations.month_year) + 1)\n    else concat(extract(year from locations.month_year) - 1, ''-'', extract(year from locations.month_year)) end as financial_year\n,rch_service_yearly_pregnancy_reg.anc_reg\n,rch_service_yearly_pregnancy_reg.anc_coverage\n,rch_service_yearly_pregnancy_reg.regd_live_children\n,rch_service_yearly_pregnancy_reg.regd_no_live_children\n,rch_service_yearly_pregnancy_reg.c1_m1\n,rch_service_yearly_pregnancy_reg.c1_f1\n,rch_service_yearly_pregnancy_reg.c2_f2\n,rch_service_yearly_pregnancy_reg.c2_m2\n,rch_service_yearly_pregnancy_reg.c2_f1_m1\n,rch_service_yearly_pregnancy_reg.c3_f3\n,rch_service_yearly_pregnancy_reg.c3_m3\n,rch_service_yearly_pregnancy_reg.c3_m2_f1\n,rch_service_yearly_pregnancy_reg.c3_m1_f2\n,rch_service_yearly_pregnancy_reg.phi_del\n,rch_service_yearly_pregnancy_reg.phi_del_with_ppiucd\n\n,rch_service_yearly_pregnancy_reg.high_risk,current_preg_compl\n,rch_service_yearly_pregnancy_reg.severe_anemia,diabetes\n,rch_service_yearly_pregnancy_reg.cur_mal_presentation_issue\n,rch_service_yearly_pregnancy_reg.cur_malaria_issue\n,rch_service_yearly_pregnancy_reg.multipara\n,rch_service_yearly_pregnancy_reg.blood_pressure\n,rch_service_yearly_pregnancy_reg.interval_bet_preg_less_18_months\n,rch_service_yearly_pregnancy_reg.extreme_age\n,rch_service_yearly_pregnancy_reg.height\n,rch_service_yearly_pregnancy_reg.weight\n,rch_service_yearly_pregnancy_reg.urine_albumin\n\n,rch_yearly_vacination_tt1.tt1,\nrch_yearly_vacination_tt2_tt_booster.tt2_tt_booster,\nrch_service_yearly_pregnancy_reg.early_anc,\nrch_yearly_anc1.anc1,\nrch_yearly_anc2.anc2,\nrch_yearly_anc3.anc3,\nrch_yearly_anc4.anc4,\nrch_wpd_anc_det.no_of_delivery,\nrch_wpd_anc_det.mtp,\nrch_wpd_anc_det.abortion,\nrch_wpd_anc_det.live_birth,\nrch_wpd_anc_det.still_birth,\nrch_yearly_pnc1.pnc1,\nrch_yearly_pnc2.pnc2,\nrch_yearly_pnc3.pnc3,\nrch_yearly_pnc4.pnc4,\nrch_yearly_maternal_death_det.maternal_detah,\nppiucd_det.ppiucd,\ncomplete_anc_date_det.complete_anc_date,\nifa_180_anc_date_det.ifa_180_anc_date\nfrom locations\nleft join rch_service_yearly_pregnancy_reg on rch_service_yearly_pregnancy_reg.location_id = locations.location_id\n    and rch_service_yearly_pregnancy_reg.month_year = locations.month_year\nleft join rch_yearly_vacination_tt1 on rch_yearly_vacination_tt1.location_id = locations.location_id\n    and rch_yearly_vacination_tt1.month_year = locations.month_year\nleft join rch_yearly_vacination_tt2_tt_booster on rch_yearly_vacination_tt2_tt_booster.location_id = locations.location_id\n    and rch_yearly_vacination_tt2_tt_booster.month_year = locations.month_year\nleft join rch_yearly_anc1 on rch_yearly_anc1.location_id = locations.location_id\n    and rch_yearly_anc1.month_year = locations.month_year\nleft join rch_yearly_anc2 on rch_yearly_anc2.location_id = locations.location_id\n    and rch_yearly_anc2.month_year = locations.month_year\nleft join rch_yearly_anc3 on rch_yearly_anc3.location_id = locations.location_id\n    and rch_yearly_anc3.month_year = locations.month_year\nleft join rch_yearly_anc4 on rch_yearly_anc4.location_id = locations.location_id\n    and rch_yearly_anc4.month_year = locations.month_year\nleft join rch_wpd_anc_det on rch_wpd_anc_det.location_id = locations.location_id\n    and rch_wpd_anc_det.month_year = locations.month_year\nleft join rch_yearly_pnc1 on rch_yearly_pnc1.location_id = locations.location_id\n    and rch_yearly_pnc1.month_year = locations.month_year\nleft join rch_yearly_pnc2 on rch_yearly_pnc2.location_id = locations.location_id\n    and rch_yearly_pnc2.month_year = locations.month_year\nleft join rch_yearly_pnc3 on rch_yearly_pnc3.location_id = locations.location_id\n    and rch_yearly_pnc3.month_year = locations.month_year\nleft join rch_yearly_pnc4 on rch_yearly_pnc4.location_id = locations.location_id\n    and rch_yearly_pnc4.month_year = locations.month_year\nleft join rch_yearly_maternal_death_det on rch_yearly_maternal_death_det.location_id = locations.location_id\n    and rch_yearly_maternal_death_det.month_year = locations.month_year\nleft join ppiucd_det on ppiucd_det.location_id = locations.location_id\n    and ppiucd_det.month_year = locations.month_year\nleft join complete_anc_date_det on complete_anc_date_det.location_id = locations.location_id\n    and complete_anc_date_det.month_year = locations.month_year\nleft join ifa_180_anc_date_det on ifa_180_anc_date_det.location_id = locations.location_id\n    and ifa_180_anc_date_det.month_year = locations.month_year;\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED18''\nwhere event_config_id = 39 and status = ''PROCESSED17'';\ncommit;\n\nbegin; \n\ndrop table if exists rch_lmp_base_location_wise_data_point;\nALTER TABLE rch_lmp_base_location_wise_data_point_t\n  RENAME TO rch_lmp_base_location_wise_data_point;\n\n---21\ndrop table if exists rch_delivery_date_base_location_wise_data_point;\nALTER TABLE rch_delivery_date_base_location_wise_data_point_t\n  RENAME TO rch_delivery_date_base_location_wise_data_point;\n  \n---22\ndrop table if exists rch_yearly_location_wise_analytics_data;\nALTER TABLE rch_yearly_location_wise_analytics_data_t\n  RENAME TO rch_yearly_location_wise_analytics_data;\n  \n---23\ndrop table if exists rch_current_state_pregnancy_analytics_data;\nALTER TABLE rch_current_state_pregnancy_analytics_data_t\n  RENAME TO rch_current_state_pregnancy_analytics_data;\n  \n---24\ndrop table if exists rch_service_provided_during_year;\nALTER TABLE rch_service_provided_during_year_t\n  RENAME TO rch_service_provided_during_year;\n  \nupdate system_configuration set key_value = TO_CHAR(current_date, ''MM-DD-YYYY'') \nwhere system_key = ''rch_pregnancy_analytics_last_schedule_date'';\n\nupdate system_configuration set key_value = ''false'' \nwhere system_key = ''rch_pregnancy_analytics_run_for_all_pregnancy'';\n  \nupdate timer_event SET completed_on = clock_timestamp(),status = ''PROCESSED19''\nwhere event_config_id = 39 and status = ''PROCESSED18'';\n\ncommit;\n\nbegin;\ndrop table if exists rch_anemia_status_analytics_t;\ncreate table rch_anemia_status_analytics_t(\nlocation_id integer,\nmonth_year date,\nanc_reg integer,\nanc_with_hb integer,\nanc_with_hb_more_than_4 integer,\nmild_hb integer,\nmodrate_hb integer,\nsevere_hb integer,\nnormal_hb integer,\nsevere_hb_with_iron_def_inj integer,\nsevere_hb_with_blood_transfusion integer,\nprimary key (location_id,month_year)\n);\n\ninsert into rch_anemia_status_analytics_t(\nlocation_id\n,month_year\n,anc_reg\n,anc_with_hb\n,anc_with_hb_more_than_4\n,mild_hb\n,modrate_hb\n,severe_hb\n,normal_hb\n,severe_hb_with_iron_def_inj\n,severe_hb_with_blood_transfusion\n)\nselect \nrprd.native_location_id as location_id\n,cast(date_trunc(''month'', rprd.reg_service_date) as date) as month_year\n,count(*) as anc_reg\n,count(1) filter(where hb >= 0.1) as anc_with_hb\n,count(1) filter(where haemoglobin_tested_count >= 4) as anc_with_hb_more_than_4\n,count(1) filter(where hb between 10 and 10.99) as mild_hb\n,count(1) filter(where hb between 7 and 9.99) as modrate_hb\n,count(1) filter(where hb between 0.1 and 6.99) as severe_hb\n,count(1) filter(where hb >= 11) as normal_hb\n,count(1) filter(where hb between 0.1 and 6.99 and iron_def_anemia_inj is not null) as severe_hb_with_iron_def_inj\n,count(1) filter(where hb between 0.1 and 6.99 and blood_transfusion) as severe_hb_with_blood_transfusion\nfrom rch_pregnancy_analytics_details rprd\ngroup by rprd.native_location_id,cast(date_trunc(''month'', rprd.reg_service_date) as date);\n\ndrop table if exists rch_anemia_status_analytics;\nALTER TABLE rch_anemia_status_analytics_t\n  RENAME TO rch_anemia_status_analytics;\n\nupdate timer_event SET completed_on = clock_timestamp(),status = ''COMPLETED''\nwhere event_config_id = 39 and status = ''PROCESSED19'';\n\ncommit;","mobileNotificationType":null,"mobileNotificationTypeUUID":null,"emailSubject":null,"emailSubjectParameter":null,"templateParameter":null,"baseDateFieldName":null,"refCode":null,"memberFieldName":null,"userFieldName":null,"familyFieldName":null,"trigerWhen":"IMMEDIATELY","day":null,"hour":null,"miniute":null,"mobileNotificationConfigs":null,"configId":39,"eventConfigUUID":null,"queryMasterId":null,"queryCode":null,"queryMasterParamJson":null,"exceptionType":null,"exceptionMessage":null,"smsConfigJson":null,"pushNotificationConfigJson":null,"systemFunctionId":null,"functionParams":null}]}]}],"status":null,"completionTime":null,"configJson":null,"uuid":"0873826b-e125-446c-bf4f-5e3b0d83c450"}',  current_date , 1027, '0873826b-e125-446c-bf4f-5e3b0d83c450', 'Update Data for Pregnancy Analytics');

-- fhs_dashboard_data_update

DELETE FROM QUERY_MASTER WHERE CODE='fhs_dashboard_data_update';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'2b910d68-28f8-483e-8fbb-babdf13ada27', 74724,  current_date , 74724,  current_date , 'fhs_dashboard_data_update',
 null,
'begin;

WITH family_wise_details AS (
select fam.family_id,case when fam.area_id is null then fam.location_id else fam.area_id end as location_id1
				,count(mem.id) filter (where fam.created_by is null and mem.created_by is null)
				as imported_from_emamta_mem

				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')) as total_member
				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.gender = ''M'') as total_male
				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.gender = ''F'') as total_female

				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and date_part(''year'',age(mem.dob)) >= 30) as total_member_over_thirty

				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and date_part(''year'',age(mem.dob)) >= 30 and mem.gender = ''M'') as total_male_over_thirty

				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and date_part(''year'',age(mem.dob)) >= 30 and mem.gender = ''F'') as total_female_over_thirty

				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.marital_status = ''629'' and mem.gender = ''F''
					and date_part(''year'',age(mem.dob)) >= 20 and date_part(''year'',age(mem.dob)) <= 40) as total_eligible_couple

				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.marital_status = ''630'' and mem.gender = ''F''
					and date_part(''year'',age(mem.dob)) between 10 and 14) as total_10_to_14_unmarried_female
		,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.gender = ''F''
					and date_part(''year'',age(mem.dob)) between 10 and 14) as total_10_to_14_female

				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.marital_status = ''630'' and mem.gender = ''M''
					and date_part(''year'',age(mem.dob)) between 10 and 14) as total_10_to_14_unmarried_male
		,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.gender = ''M''
					and date_part(''year'',age(mem.dob)) between 10 and 14) as total_10_to_14_male

				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.marital_status = ''630'' and mem.gender = ''F''
					and date_part(''year'',age(mem.dob)) between 15 and 18) as total_15_to_18_unmarried_female
				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.gender = ''F''
					and date_part(''year'',age(mem.dob)) between 15 and 18) as total_15_to_18_female

				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.marital_status = ''630'' and mem.gender = ''M''
					and date_part(''year'',age(mem.dob)) between 15 and 18) as total_15_to_18_unmarried_male

				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.gender = ''M''
					and date_part(''year'',age(mem.dob)) between 15 and 18) as total_15_to_18_male
				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and date_part(''year'',age(mem.dob)) between 0 and 18) as total_population_0_to_18

				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and date_part(''year'',age(mem.dob)) between 19 and 40) as total_population_19_to_40

				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and date_part(''year'',age(mem.dob)) > 40) as total_population_more_than_40
				,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.is_pregnant = true) as total_pregnant_woman

		,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.dob > CURRENT_DATE - INTERVAL ''5 year'') as child_less_then_5_year
		,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'',''TEMPORARY'',''IDSP'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'',''TEMPORARY'',''IDSP'')
					and mem.dob < CURRENT_DATE - INTERVAL ''60 year'') as member_60_plus_age


		,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.mobile_number is not null) as member_with_mobile_num

		,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.dob > CURRENT_DATE - INTERVAL ''1 year'') as total_0to1_children

		,count(mem.id) filter (where fam.basic_state in (''VERIFIED'',''REVERIFICATION'',''NEW'')
					and mem.basic_state in (''DEAD'')
					and dob > rch_member_death_deatil.dod - interval ''1 year'') as total_infant_deaths

		,count(distinct mem.family_id) filter (where fam.created_by is null) as imported

		,count(distinct mem.family_id) filter (where fam.basic_state in (''UNVERIFIED'',''ORPHAN'')) as toBeProcessed

		,count(distinct mem.family_id) filter (where fam.basic_state in (''VERIFIED'')) as Verified

		,count(distinct mem.family_id) filter (where fam.basic_state in (''VERIFIED'')
			and  fam.modified_on > CURRENT_DATE - INTERVAL ''3 day'' ) as verified_last_3days

		,count(distinct mem.family_id) filter (where fam.basic_state in (''VERIFIED'')
			and  fam.migratory_flag) as seasonal_migrant_family

				,count(distinct mem.family_id) filter (where fam.basic_state in (''ARCHIVED'')) as Archived

		,count(distinct mem.family_id) filter (where fam.basic_state in (''REVERIFICATION'')) as inReverification

		,count(distinct mem.family_id) filter (where fam.basic_state in (''NEW'')) as newFamily
		,count(mem.id) filter (where mem.state in (''CFHC_MV'') and um.code = ''FHW'') as chfc_member_verified_by_fhw
		,count(mem.id) filter (where mem.state in (''CFHC_MV'') and um.code = ''ASHA'') as chfc_member_verified_by_asha
		,count(mem.id) filter (where mem.state in (''CFHC_MV'') and um.code = ''MPHW'') as chfc_member_verified_by_mphw
		,count(distinct mem.family_id) filter (where fam.state in (''CFHC_FV'',''CFHC_GVK_FRVP'',''CFHC_MO_FRVP'') and um.code = ''FHW'') as chfc_family_verified_by_fhw
		,count(distinct mem.family_id) filter (where fam.state in (''CFHC_FV'',''CFHC_GVK_FRVP'',''CFHC_MO_FRVP'') and um.code = ''MPHW'') as chfc_family_verified_by_mphw
		,count(mem.id) filter (where mem.state in (''CFHC_MN'') and um.code = ''FHW'') as chfc_new_member_by_fhw
		,count(mem.id) filter (where mem.state in (''CFHC_MN'') and um.code = ''ASHA'') as chfc_new_member_by_asha
		,count(mem.id) filter (where mem.state in (''CFHC_MN'') and um.code = ''MPHW'') as chfc_new_member_by_mphw
		,count(distinct mem.family_id) filter (where fam.state in (''CFHC_FN'') and um.code = ''FHW'') as chfc_new_family_by_fhw
		,count(distinct mem.family_id) filter (where fam.state in (''CFHC_FN'') and um.code = ''ASHA'') as chfc_new_family_by_asha
		,count(distinct mem.family_id) filter (where fam.state in (''CFHC_FN'') and um.code = ''MPHW'') as chfc_new_family_by_mphw
		,count(mem.id) filter (where mem.state in (''CFHC_MIR'') and um.code = ''FHW'') as chfc_member_in_reverification_by_fhw
		,count(mem.id) filter (where mem.state in (''CFHC_MIR'') and um.code = ''MPHW'') as chfc_member_in_reverification_by_mphw
		,count(distinct mem.family_id) filter (where fam.state in (''CFHC_FIR'') and um.code = ''FHW'') as chfc_family_in_reverification_by_fhw
		,count(distinct mem.family_id) filter (where fam.state in (''CFHC_FIR'') and um.code = ''MPHW'') as chfc_family_in_reverification_by_mphw
		,count(distinct unique_health_id) filter(where last_method_of_contraception is not null or not_using_fp_reason is not null) as visit_count
        ,case when count(mem.id) filter (where fam.basic_state  in (''UNVERIFIED'', ''NEW'', ''VERIFIED'') and
         mem.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'',''TEMPORARY'')) >= 1 then 1 else 0 end as chfc_remaining_family
		,case when count(mem.id) filter (where fam.state in (''CFHC_FV'') and mem.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'',''TEMPORARY'')) = 1 then 1 else 0 end as chfc_single_member_existing_families
		,case when count(mem.id) filter (where fam.state in (''CFHC_FN'') and mem.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'',''TEMPORARY'')) = 1 then 1 else 0 end as chfc_single_member_newly_added_families
		,case when count(mem.id) filter (where fam.state in (''CFHC_FV'') and mem.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'',''TEMPORARY'')) = 2 then 1 else 0 end as chfc_two_member_existing_families
		,case when count(mem.id) filter (where fam.state in (''CFHC_FN'') and mem.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'',''TEMPORARY'')) = 2 then 1 else 0 end as chfc_two_member_newly_added_families
		,case when count(mem.id) filter (where fam.state in (''CFHC_FV'') and mem.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'',''TEMPORARY'')) = 3 then 1 else 0 end as chfc_three_member_existing_families
		,case when count(mem.id) filter (where fam.state in (''CFHC_FN'') and mem.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'',''TEMPORARY'')) = 3 then 1 else 0 end as chfc_three_member_newly_added_families
		,case when count(mem.id) filter (where fam.state in (''CFHC_FV'') and mem.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'',''TEMPORARY'')) > 3 then 1 else 0 end as chfc_more_then_three_member_existing_families
		,case when count(mem.id) filter (where fam.state in (''CFHC_FN'') and mem.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'',''TEMPORARY'')) > 3 then 1 else 0 end as chfc_more_then_three_member_newly_added_families


		from imt_family fam
		inner join imt_member mem on fam.family_id = mem.family_id
		left join rch_member_death_deatil on mem.death_detail_id = rch_member_death_deatil.id
		left join imt_family_cfhc_done_by_details chfc on chfc.family_id = fam.family_id
		left join um_role_master um on um.id = chfc.role_id
		group by fam.family_id,location_id1
),
location_wise_details as (
select location_id1 as location_id
,sum(imported) as imported
,sum(imported_from_emamta_mem) as imported_from_emamta_mem
,sum(toBeProcessed) as toBeProcessed
,sum(Verified) as Verified
,sum(Archived) as Archived
,sum(newFamily) as newFamily
,sum(total_member) as total_member
,sum(total_male) as total_male
,sum(total_female) as total_female
,sum(total_member_over_thirty) as total_member_over_thirty
,sum(total_male_over_thirty) as total_male_over_thirty
,sum(total_female_over_thirty) as total_female_over_thirty
,sum(inReverification ) as inReverification
,sum(verified_last_3days ) as verified_last_3days
,sum(seasonal_migrant_family) as seasonal_migrant_family
,sum(total_infant_deaths) as total_infant_deaths
,sum(total_eligible_couple ) as total_eligible_couple
,sum(total_pregnant_woman ) as total_pregnant_woman
,sum(child_less_then_5_year ) as child_less_then_5_year
,sum(member_60_plus_age ) as member_60_plus_age
,sum(member_with_mobile_num) as member_with_mobile_num
,sum(total_0to1_children) as total_0to1_children
,sum(total_10_to_14_unmarried_female) as total_10_to_14_unmarried_female
,sum(total_10_to_14_unmarried_male) as total_10_to_14_unmarried_male
,sum(total_15_to_18_unmarried_female) as total_15_to_18_unmarried_female
,sum(total_15_to_18_unmarried_male) as total_15_to_18_unmarried_male
,sum(total_10_to_14_male) as total_10_to_14_male
,sum(total_10_to_14_female) as total_10_to_14_female
,sum(total_15_to_18_male) as total_15_to_18_male
,sum(total_15_to_18_female) as total_15_to_18_female
,sum(total_population_0_to_18) as total_population_0_to_18
,sum(total_population_19_to_40) as total_population_19_to_40
,sum(total_population_more_than_40) as total_population_more_than_40
,sum(chfc_member_verified_by_fhw) as chfc_member_verified_by_fhw
,sum(chfc_member_verified_by_asha) as chfc_member_verified_by_asha
,sum(chfc_member_verified_by_mphw) as chfc_member_verified_by_mphw
,sum(chfc_family_verified_by_fhw) as chfc_family_verified_by_fhw
,sum(chfc_family_verified_by_mphw) as chfc_family_verified_by_mphw
,sum(chfc_new_member_by_fhw) as chfc_new_member_by_fhw
,sum(chfc_new_member_by_asha) as chfc_new_member_by_asha
,sum(chfc_new_member_by_mphw) as chfc_new_member_by_mphw
,sum(chfc_new_family_by_fhw) as chfc_new_family_by_fhw
,sum(chfc_new_family_by_asha) as chfc_new_family_by_asha
,sum(chfc_new_family_by_mphw) as chfc_new_family_by_mphw
,sum(chfc_member_in_reverification_by_fhw) as chfc_member_in_reverification_by_fhw
,sum(chfc_member_in_reverification_by_mphw) as chfc_member_in_reverification_by_mphw
,sum(chfc_family_in_reverification_by_fhw) as chfc_family_in_reverification_by_fhw
,sum(chfc_family_in_reverification_by_mphw) as chfc_family_in_reverification_by_mphw
,sum(case when chfc_remaining_family = 1 then total_member else 0 end) as chfc_remaining_family
,sum(chfc_single_member_existing_families) as chfc_single_member_existing_families
,sum(chfc_single_member_newly_added_families) as chfc_single_member_newly_added_families
,sum(chfc_two_member_existing_families) as chfc_two_member_existing_families
,sum(chfc_two_member_newly_added_families) as chfc_two_member_newly_added_families
,sum(chfc_three_member_existing_families) as chfc_three_member_existing_families
,sum(chfc_three_member_newly_added_families) as chfc_three_member_newly_added_families
,sum(chfc_more_then_three_member_existing_families) as chfc_more_then_three_member_existing_families
,sum(chfc_more_then_three_member_newly_added_families) as chfc_more_then_three_member_newly_added_families
,sum(visit_count) as rep_modification_visit_count_by_location
from family_wise_details fwd
group by location_id
),lmp_count_by_location as(
    select count(*) as lmp_count,location_id  from rch_lmp_follow_up rlfu  group by location_id
),anc_count_by_location as(
	    select count(*) as anc_count,location_id  from rch_anc_master  group by location_id
),wpd_count_by_location as(
	    select count(*) as wpd_count,location_id from rch_wpd_mother_master  group by location_id
),pnc_count_by_location as (
	    select count(*) as pnc_count,location_id from rch_pnc_master rpm group by location_id
),csv_count_by_location as(
	    select count(*) as csv_count,location_id  from rch_child_service_master rcsm  group by location_id
),tb_count_by_location as (
	    select count(*) as tb_count,location_id  from tuberculosis_screening_details  group by location_id
),malaria_count_by_location as(
	    select count(*) as malaria_count,location_id  from malaria_details  group by location_id
),hiv_count_by_location as(
	    select count(*) as hiv_count,location_id from rch_hiv_screening_master group by location_id
),covid_count_by_location as(
		select count(*) as covid_count,location_id  from covid_screening_details group by location_id
)

update location_wise_analytics
		set fhs_imported_from_emamta_family = fhs_det.imported
		,fhs_imported_from_emamta_member = fhs_det.imported_from_emamta_mem
		,fhs_to_be_processed_family = fhs_det.toBeProcessed
		,fhs_verified_family = fhs_det.Verified
		,fhs_archived_family = fhs_det.Archived
		,fhs_new_family = fhs_det.newFamily
		,fhs_total_member = fhs_det.total_member
		,total_male = fhs_det.total_male
		,total_female = fhs_det.total_female
		,total_member_over_thirty = fhs_det.total_member_over_thirty
		,total_male_over_thirty = fhs_det.total_male_over_thirty
		,total_female_over_thirty = fhs_det.total_female_over_thirty
				,fhs_inreverification_family = fhs_det.inReverification
		,family_varified_last_3_days = fhs_det.verified_last_3days
		,seasonal_migrant_families  = fhs_det.seasonal_migrant_family
		,eligible_couples_in_techo  = fhs_det.total_eligible_couple
		,pregnant_woman_techo  = fhs_det.total_pregnant_woman
		,child_under_5_year  = fhs_det.child_less_then_5_year
		,member_60_plus_age  = fhs_det.member_60_plus_age
		,member_with_mobile_number  = fhs_det.member_with_mobile_num
		,total_0to1_children = fhs_det.total_0to1_children
		,total_0to5_children = fhs_det.child_less_then_5_year
		,total_10_to_14_unmarried_female = fhs_det.total_10_to_14_unmarried_female
		,total_10_to_14_unmarried_male = fhs_det.total_10_to_14_unmarried_male
		,total_15_to_18_unmarried_female = fhs_det.total_15_to_18_unmarried_female
		,total_15_to_18_unmarried_male = fhs_det.total_15_to_18_unmarried_male
		,total_infant_deaths = fhs_det.total_infant_deaths
	,total_10_to_14_male = fhs_det.total_10_to_14_male
	,total_10_to_14_female = fhs_det.total_10_to_14_female
	,total_15_to_18_male = fhs_det.total_15_to_18_male
		,total_15_to_18_female = fhs_det.total_15_to_18_female
		,total_population_0_to_18 = fhs_det.total_population_0_to_18
		,total_population_19_to_40 = fhs_det.total_population_19_to_40
		,total_population_more_than_40 = fhs_det.total_population_more_than_40
		,chfc_member_verified_by_fhw = fhs_det.chfc_member_verified_by_fhw
		,chfc_member_verified_by_asha = fhs_det.chfc_member_verified_by_asha
,chfc_member_verified_by_mphw = fhs_det.chfc_member_verified_by_mphw
,chfc_family_verified_by_fhw = fhs_det.chfc_family_verified_by_fhw
,chfc_family_verified_by_mphw = fhs_det.chfc_family_verified_by_mphw
,chfc_new_member_by_fhw = fhs_det.chfc_new_member_by_fhw
,chfc_new_member_by_asha = fhs_det.chfc_new_member_by_asha
,chfc_new_member_by_mphw = fhs_det.chfc_new_member_by_mphw
,chfc_new_family_by_fhw = fhs_det.chfc_new_family_by_fhw
,chfc_new_family_by_asha = fhs_det.chfc_new_family_by_asha
,chfc_new_family_by_mphw = fhs_det.chfc_new_family_by_mphw
,chfc_member_in_reverification_by_fhw = fhs_det.chfc_member_in_reverification_by_fhw
,chfc_member_in_reverification_by_mphw = fhs_det.chfc_member_in_reverification_by_mphw
,chfc_family_in_reverification_by_fhw = fhs_det.chfc_family_in_reverification_by_fhw
,chfc_family_in_reverification_by_mphw = fhs_det.chfc_family_in_reverification_by_mphw
,chfc_remaining_family = fhs_det.chfc_remaining_family
,chfc_single_member_existing_families = fhs_det.chfc_single_member_existing_families
,chfc_single_member_newly_added_families = fhs_det.chfc_single_member_newly_added_families
,chfc_two_member_existing_families = fhs_det.chfc_two_member_existing_families
,chfc_two_member_newly_added_families = fhs_det.chfc_two_member_newly_added_families
,chfc_three_member_existing_families = fhs_det.chfc_three_member_existing_families
,chfc_three_member_newly_added_families = fhs_det.chfc_three_member_newly_added_families
,chfc_more_then_three_member_existing_families = fhs_det.chfc_more_then_three_member_existing_families
,chfc_more_then_three_member_newly_added_families = fhs_det.chfc_more_then_three_member_newly_added_families
,lmp_count_by_location = fhs_det.lmp_count
,anc_count_by_location = fhs_det.anc_count
,wpd_count_by_location = fhs_det.wpd_count
,pnc_count_by_location = fhs_det.pnc_count
,csv_count_by_location = fhs_det.csv_count
,tb_count_by_location = fhs_det.tb_count
,malaria_count_by_location = fhs_det.malaria_count
,hiv_count_by_location = fhs_det.hiv_count
,covid_count_by_location = fhs_det.covid_count
,rep_modification_visit_count_by_location = fhs_det.rep_modification_visit_count_by_location
,total_family_count_by_location = fhs_inreverification_family + fhs_verified_family + fhs_new_family
		from (
		select loc.id, mem_det.imported,mem_det.imported_from_emamta_mem
		,mem_det.toBeProcessed,mem_det.Verified ,mem_det.Archived ,mem_det.newFamily
		,mem_det.total_member ,mem_det.total_male, mem_det.total_female ,mem_det.total_member_over_thirty
		,mem_det.total_male_over_thirty, mem_det.total_female_over_thirty
		,mem_det.inReverification ,verified_last_3days ,seasonal_migrant_family
		,total_infant_deaths
		,total_eligible_couple ,total_pregnant_woman ,child_less_then_5_year
		,member_60_plus_age
		,member_with_mobile_num,total_0to1_children
		,total_10_to_14_unmarried_female,total_10_to_14_unmarried_male
		,total_15_to_18_unmarried_female,total_15_to_18_unmarried_male
	,total_10_to_14_male
	,total_10_to_14_female
	,total_15_to_18_male
		,total_15_to_18_female
		,total_population_0_to_18
		,total_population_19_to_40
		,total_population_more_than_40
		,chfc_member_verified_by_fhw
		,chfc_member_verified_by_asha
		,chfc_member_verified_by_mphw
,chfc_family_verified_by_fhw
,chfc_family_verified_by_mphw
,chfc_new_member_by_fhw
,chfc_new_member_by_asha
,chfc_new_member_by_mphw
,chfc_new_family_by_fhw
,chfc_new_family_by_asha
,chfc_new_family_by_mphw
,chfc_member_in_reverification_by_fhw
,chfc_member_in_reverification_by_mphw
,chfc_family_in_reverification_by_fhw
,chfc_family_in_reverification_by_mphw
,chfc_remaining_family
,chfc_single_member_existing_families
,chfc_single_member_newly_added_families
,chfc_two_member_existing_families
,chfc_two_member_newly_added_families
,chfc_three_member_existing_families
,chfc_three_member_newly_added_families
,chfc_more_then_three_member_existing_families
,chfc_more_then_three_member_newly_added_families
,lmp_count
,anc_count
,wpd_count
,pnc_count
,csv_count
,tb_count
,malaria_count
,hiv_count
,covid_count
,rep_modification_visit_count_by_location

		from location_master loc
			left join location_wise_details as mem_det
			on loc.id = mem_det.location_id
			left join lmp_count_by_location as lcbl
			on mem_det.location_id = lcbl.location_id
			left join anc_count_by_location as acbl
			on mem_det.location_id = acbl.location_id
			left join wpd_count_by_location as wcbl
			on mem_det.location_id = wcbl.location_id
			left join pnc_count_by_location as pcbl
			on mem_det.location_id = pcbl.location_id
			left join csv_count_by_location as cscbl
			on mem_det.location_id = cscbl.location_id
			left join tb_count_by_location as tcbl
			on mem_det.location_id = tcbl.location_id
			left join malaria_count_by_location as mcbl
			on mem_det.location_id = mcbl.location_id
			left join hiv_count_by_location as hcbl
			on mem_det.location_id = hcbl.location_id
			left join covid_count_by_location as ccbl
			on mem_det.location_id = ccbl.location_id


		) as fhs_det
		where fhs_det.id = location_wise_analytics.loc_id;



update system_configuration  set key_value = cast(cast(EXTRACT(EPOCH FROM clock_timestamp()) * 1000 as bigint)as text) where system_key = ''FHS_LAST_UPDATE_TIME'';
update timer_event SET completed_on = clock_timestamp(),status = ''COMPLETED''
where event_config_id in (7,8) and status = ''PROCESSED'';
commit;',
'This will update fhs dashboard data',
false, 'ACTIVE');