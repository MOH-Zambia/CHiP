ALTER TABLE public.mytecho_family
DROP COLUMN IF EXISTS techo_family_id,
ADD COLUMN techo_family_id bigint;

alter table public.mytecho_member
drop column IF EXISTS techo_member_id,
ADD COLUMN techo_member_id bigint;

ALTER TABLE public.mytecho_member
   ALTER COLUMN mobile_number DROP NOT NULL;