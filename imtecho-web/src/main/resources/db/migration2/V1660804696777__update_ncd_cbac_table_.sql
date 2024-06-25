alter table ncd_member_cbac_detail
    add column if not exists forget_names boolean;
alter table ncd_member_cbac_detail
    add column if not exists  need_help_from_others boolean;
alter table ncd_member_cbac_detail
    add column if not exists  physical_disability boolean;
alter table ncd_member_cbac_detail
    alter column feeling_down type text;