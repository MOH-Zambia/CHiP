-- Renamed menu name
update menu_config set menu_name = 'Performance Dashboard' , navigation_state ='techo.manage.performancedashboard'
where menu_name = 'DashboardPOC' and navigation_state = 'techo.manage.dashboardpoc';
