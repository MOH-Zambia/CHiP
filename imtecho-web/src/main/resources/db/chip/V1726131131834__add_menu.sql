delete from menu_config where menu_name = 'Monthly Facility Report Search';

insert into menu_config(active,menu_name,navigation_state,menu_type)
values('TRUE','Monthly Facility Report Search','techo.manage.monthlyfacilityreportingformsearch','manage');