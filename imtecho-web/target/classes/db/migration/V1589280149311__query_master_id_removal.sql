ALTER TABLE query_master 
DROP COLUMN IF EXISTS id;


CREATE OR REPLACE FUNCTION public.uuid_generate_v4()
 RETURNS uuid AS
'$libdir/uuid-ossp', 'uuid_generate_v4'
 LANGUAGE c VOLATILE STRICT
 COST 1;


UPDATE public.query_master
	SET uuid = uuid_generate_v4()
	WHERE uuid is null;