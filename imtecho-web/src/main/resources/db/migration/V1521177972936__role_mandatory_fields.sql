ALTER TABLE public.um_role_master
  ADD COLUMN is_email_mandatory boolean;
ALTER TABLE public.um_role_master
  ADD COLUMN is_contact_num_mandatory boolean;
ALTER TABLE public.um_role_master
  ADD COLUMN is_aadhar_num_mandatory boolean;