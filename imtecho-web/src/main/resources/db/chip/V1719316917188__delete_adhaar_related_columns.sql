ALTER TABLE public.imt_member
DROP COLUMN IF EXISTS agreed_to_share_aadhar,
DROP COLUMN IF EXISTS aadhaar_reference_key;

ALTER TABLE public.um_user
DROP COLUMN IF EXISTS aadhar_number_available,
DROP COLUMN IF EXISTS aadhaar_reference_key,
DROP COLUMN IF EXISTS aadhar_number_encrypted;
