DROP TABLE IF EXISTS public.cm_dashboard_expected_target_details;
CREATE TABLE public.cm_dashboard_expected_target_details(
location_id bigint,
financial_year varchar(20),
expected_mother_reg bigint,
expected_delivery_Reg bigint,
ELA_DPT_OPV_mes_vitA_1Dose bigint,
CONSTRAINT cm_dashboard_expected_target_details_pkey PRIMARY KEY (location_id,financial_year)
);
