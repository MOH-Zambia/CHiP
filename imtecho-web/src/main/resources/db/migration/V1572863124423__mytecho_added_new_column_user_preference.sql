ALTER TABLE public.mytecho_user
DROP COLUMN IF EXISTS user_preferences,
ADD COLUMN user_preferences text;