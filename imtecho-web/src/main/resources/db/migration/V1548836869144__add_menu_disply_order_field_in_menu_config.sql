ALTER TABLE public.menu_config 
Drop COLUMN IF exists menu_display_order;

ALTER TABLE public.menu_config 
ADD COLUMN menu_display_order bigint;

ALTER TABLE public.menu_group 
Drop COLUMN IF exists menu_display_order;

ALTER TABLE public.menu_group 
ADD COLUMN menu_display_order bigint;