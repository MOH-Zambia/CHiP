ALTER TABLE public.anganwadi_master
	RENAME COLUMN updated_by TO modified_by;
	
ALTER TABLE public.anganwadi_master
	RENAME COLUMN updated_on TO modified_on;

UPDATE public.anganwadi_master
	SET created_by = null WHERE created_by = 'dataloader';

ALTER TABLE public.anganwadi_master
	ALTER COLUMN id TYPE bigint,
	ALTER COLUMN parent TYPE bigint,
	ALTER COLUMN created_by TYPE bigint USING created_by::bigint,
	ALTER COLUMN modified_by TYPE bigint USING modified_by::bigint;