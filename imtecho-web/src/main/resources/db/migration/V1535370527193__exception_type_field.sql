ALTER TABLE public.uncaught_exception_mobile DROP COLUMN IF EXISTS exception_type;
ALTER TABLE public.uncaught_exception_mobile ADD COLUMN exception_type text;