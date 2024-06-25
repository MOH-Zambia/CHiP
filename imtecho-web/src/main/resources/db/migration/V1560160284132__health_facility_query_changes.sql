alter table health_infrastructure_details
drop column if exists is_balsakha1,
drop column if exists is_balsakha3,
drop column if exists is_usg_facility,
drop column if exists is_referral_facility,
drop column if exists is_ma_yojna,
drop column if exists is_npcb,
add column is_balsakha1 boolean,
add column is_balsakha3 boolean,
add column is_usg_facility boolean,
add column is_referral_facility boolean,
add column is_ma_yojna boolean,
add column is_npcb boolean;

update menu_config
set feature_json = '{"canAdd":true,"canEditBloodBank":true,"canEdit":true,"canChangeLocation":true,"canEditFru":true,"canEditPediatrician":true,"canEditCmtc":true,"canEditNrc":true,"canEditGynaec":true,"canEditSncu":true,"canEditChiranjeevi":false,"canEditBalsakha1":false,"canEditBalsakha3":false,"canEditUsgFacility":false,"canEditReferralFacility":false,"canEditMaYojna":false,"canEditPmjayFacility":false,"canEditNpcb":false}'
where menu_name = 'Health Facility Mapping';