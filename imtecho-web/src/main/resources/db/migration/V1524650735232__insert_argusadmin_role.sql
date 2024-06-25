INSERT INTO public.um_role_master(
           created_by, created_on, code, 
            name, state)
    VALUES ( 1, current_date, 'argusadmin', 'Argus Admin','ACTIVE');

ALTER TABLE public.menu_config
  ADD COLUMN only_admin boolean;
