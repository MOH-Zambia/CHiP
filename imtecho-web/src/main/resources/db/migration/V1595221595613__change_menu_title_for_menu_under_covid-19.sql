update menu_config set menu_name = 'Contact Tracing' where menu_name = 'COVID-19 Contact Tracing';

update menu_config set menu_name = 'Rapid Response Dashboard' where menu_name = 'COVID-19 Rapid Response Dashboard';

update menu_config set menu_name = 'Suspect List' where menu_name = 'Covid2019 Suspect List';

update menu_config set menu_name = 'Hospital Admission' where menu_name = 'COVID-19 Hospital Admission';

update menu_config set menu_name = 'Positive Case Detail' where menu_name = 'Covid19 Positive Case Detail';

update menu_config set menu_name = 'Hospitalwise detail' where menu_name = 'Covid2019 Hospitalwise detail';

update menu_config set menu_name = 'Cluster Management' where menu_name = 'COVID-19 Cluster Management';

delete from menu_group mg where mg.group_name = 'COVID-19 Report';

INSERT INTO menu_group
(group_name, active, parent_group, group_type, menu_display_order)
VALUES('COVID-19 Report', true,null, 'manage', null);

update menu_config set group_id = (select mg2.id from menu_group mg2 where mg2.group_name = 'COVID-19 Report')
where group_id = (select id from menu_group mg where mg.group_name = 'COVID-19') 
and navigation_state like 'techo.report.view%' and active = true and is_dynamic_report = true; 
