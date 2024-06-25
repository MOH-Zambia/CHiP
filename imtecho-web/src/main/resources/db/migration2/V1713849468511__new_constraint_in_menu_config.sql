 ALTER table if exists public.menu_config
 DROP CONSTRAINT IF EXISTS navigation_state_unique_constraint;


 ALTER table if exists public.menu_config
 ADD CONSTRAINT navigation_state_unique_constraint UNIQUE (navigation_state,active);