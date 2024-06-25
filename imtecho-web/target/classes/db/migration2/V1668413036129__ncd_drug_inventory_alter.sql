alter table ncd_drug_inventory_detail
DROP COLUMN IF EXISTS medicine_name,
ADD COLUMN IF NOT EXISTS medicine_id integer;


alter table ncd_drug_inventory_detail
DROP COLUMN IF EXISTS is_return,
ADD COLUMN is_return boolean;


alter table ncd_drug_inventory_detail
drop column IF EXISTS family_id;

alter table ncd_drug_inventory_detail
drop column IF EXISTS location_id;

alter table ncd_drug_inventory_detail
drop column IF EXISTS facility;

