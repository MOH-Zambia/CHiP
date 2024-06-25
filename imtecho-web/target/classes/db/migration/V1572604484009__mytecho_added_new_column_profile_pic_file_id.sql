ALTER TABLE public.mytecho_user
DROP COLUMN IF EXISTS profile_pic_file_id,
ADD COLUMN profile_pic_file_id bigint;