ALTER TABLE public.location_wise_analytics
Drop COLUMN if exists family_varified_last_3_days
  ,ADD COLUMN family_varified_last_3_days bigint
  ,Drop COLUMN if exists seasonal_migrant_families
  ,ADD COLUMN seasonal_migrant_families bigint
  ,Drop COLUMN if exists eligible_couples_in_techo
  ,ADD COLUMN eligible_couples_in_techo bigint
  ,Drop COLUMN if exists pregnant_woman_techo
  ,ADD COLUMN pregnant_woman_techo bigint
  ,Drop COLUMN if exists child_under_5_year
  ,ADD COLUMN child_under_5_year bigint
  ,Drop COLUMN if exists member_with_adhar_number
  ,ADD COLUMN member_with_adhar_number bigint
  ,Drop COLUMN if exists member_with_mobile_number
  ,ADD COLUMN member_with_mobile_number bigint;