drop index if exists aadhar_number_encrypted_index;

create index aadhar_number_encrypted_index
on imt_member(aadhar_number_encrypted);