DROP TABLE IF EXISTS public.anmol_api_status;

create table anmol_api_status (
source_type varchar(30) not null,
created_on text not NULL,
wsdl_code varchar(50) not null,
wsdl_code_count int not null
);