ALTER table ndhm_health_id_user_details
DROP column if exists benefit_id,
ADD column benefit_id varchar(255);