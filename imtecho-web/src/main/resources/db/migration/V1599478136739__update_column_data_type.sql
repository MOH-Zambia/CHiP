alter table anmol_asha_anm
alter column "Created_By" type text USING cast("Created_By" as text);


alter table "anmol_child_registration"
alter column "mobile_relates_to" type text USING cast("mobile_relates_to" as text);


alter table "anmol_eligible_couples_2"
alter column "whose_mobile" type text USING cast("whose_mobile" as text);

alter table "anmol_eligible_couples_current"
alter column "whose_mobile" type text USING cast("whose_mobile" as text);

alter table "anmol_mother_infants"
alter column "higher_facility" type text USING cast("higher_facility" as text);


alter table "anmol_mother_medical"
alter column "mobile_relates_to" type text USING cast("mobile_relates_to" as text);

alter table "anmol_mother_medical"
alter column "past_illness" type text USING cast("past_illness" as text);


alter table "anmol_eligible_couples"
alter column "whose_mobile" type text USING cast("whose_mobile" as text);

alter table "anmol_asha_anm"
alter column "IsActual" type text USING cast("IsActual" as text);

alter table "anmol_asha_anm"
alter column "Islinked" type text USING cast("Islinked" as text);

alter table "anmol_asha_anm"
alter column "Is_USSD_Flagged" type text USING cast("Is_USSD_Flagged" as text);

alter table "anmol_asha_anm"
alter column "Updated_by" type text USING cast("Updated_by" as text);


alter table "anmol_asha_anm"
alter column "Updated_on" type text USING cast("Updated_on" as text);