UPDATE public.menu_config
   SET only_admin=true
 WHERE navigation_state='techo.notification.all' or navigation_state='techo.report.all';