Alter Table if exists public.rch_wpd_mother_master
Drop column if exists is_oxytocin ,
Drop column if exists is_IFA_given ,
Drop column if exists was_ART_given ,
Drop column if exists hiv_during_delivery,
Drop column if exists is_ART_given_delivery ;

Alter Table if exists public.rch_wpd_mother_master
Add column is_oxytocin boolean,
Add column is_IFA_given boolean,
Add column was_ART_given boolean,
Add column is_ART_given_delivery boolean,
Add column hiv_during_delivery varchar(20);

Alter Table if exists public.rch_wpd_child_master
Drop column if exists baby_breathe_at_birth ;

Alter Table if exists public.rch_wpd_child_master
Add column baby_breathe_at_birth boolean;

Alter Table if exists public.rch_anc_master
Drop column if exists malaria_test ,
Drop column if exists is_mebendazole_given ,
Drop column if exists mebendazole1_given ,
Drop column if exists mebendazole1_date ,
Drop column if exists mebendazole2_given ,
Drop column if exists mebendazole2_date ,
Drop column if exists hiv_status ,
Drop column if exists hiv_appointment_date,
Drop column if exists hiv_result_date ,
Drop column if exists hiv_test_result ,
Drop column if exists other ;

Alter Table if exists public.rch_anc_master
Add column malaria_test boolean,
Add column hiv_status varchar(20),
Add column mebendazole1_given boolean,
Add column mebendazole1_date timestamp without time zone,
Add column mebendazole2_given boolean,
Add column mebendazole2_date timestamp without time zone,
Add column hiv_appointment_date timestamp without time zone,
Add column hiv_result_date timestamp without time zone,
Add column hiv_test_result varchar(20),
Add column other varchar(200);
