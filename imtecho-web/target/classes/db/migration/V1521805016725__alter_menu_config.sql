UPDATE public.menu_config
   SET  menu_type='fhs',group_id=null
 WHERE navigation_state='techo.dashboard.fhs' or navigation_state='techo.manage.fhsrverification' or navigation_state='techo.manage.moverification' or navigation_state='techo.dashboard.gvkverification' ;


UPDATE public.menu_config
   SET  menu_type='admin',group_id=null
 WHERE navigation_state='techo.manage.menu' or navigation_state='techo.manage.role' or navigation_state='techo.report.config' ;

 UPDATE public.menu_config
   SET  menu_type='training',group_id=null
 WHERE navigation_state='techo.training.scheduled' or navigation_state='techo.training.dashboard' or navigation_state='techo.training.traineeStatus' or navigation_state='techo.manage.course' ;
 UPDATE public.menu_config
   SET  menu_type='manage' ,group_id=null
 WHERE navigation_state='techo.manage.users' or navigation_state='techo.manage.uploadlocation';