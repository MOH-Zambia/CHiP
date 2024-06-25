alter table um_user
drop column if exists aadhaar_reference_key,
add column aadhaar_reference_key uuid,
drop column if exists aadhar_number_available,
add column aadhar_number_available BOOLEAN;