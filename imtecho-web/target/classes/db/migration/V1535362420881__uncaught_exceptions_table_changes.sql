ALTER TABLE public.uncaught_exception_mobile RENAME user_id  TO user_name;
ALTER TABLE public.uncaught_exception_mobile DROP COLUMN IF EXISTS user_id;
ALTER TABLE public.uncaught_exception_mobile ADD COLUMN user_id bigint;
