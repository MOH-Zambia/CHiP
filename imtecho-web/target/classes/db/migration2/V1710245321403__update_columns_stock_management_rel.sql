
UPDATE stock_medicines_rel
SET approved_qty = 0
WHERE approved_qty IS NULL;

ALTER TABLE IF EXISTS stock_medicines_rel
ALTER COLUMN approved_qty SET NOT NULL;