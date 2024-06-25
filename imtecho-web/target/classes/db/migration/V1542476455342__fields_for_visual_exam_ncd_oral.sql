ALTER TABLE public.ncd_member_oral_detail
DROP COLUMN IF EXISTS growth_of_recent_origins,
ADD COLUMN growth_of_recent_origins text,
DROP COLUMN IF EXISTS non_healing_ulcers,
ADD COLUMN non_healing_ulcers text,
DROP COLUMN IF EXISTS red_patches,
ADD COLUMN red_patches text,
DROP COLUMN IF EXISTS white_patches,
ADD COLUMN white_patches text;