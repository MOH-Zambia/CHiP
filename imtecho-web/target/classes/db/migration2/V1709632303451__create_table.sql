CREATE TABLE IF NOT EXISTS stock_inventory_entity (
    health_infra_id INT NOT NULL,
    medicine_id INT NOT NULL,
    medicine_stock_amount INT NOT NULL,
    approved_by INT NOT NULL,
    requested_by INT NOT NULL,
    used int,
    created_by INT NOT NULL,
    created_on TIMESTAMP NOT NULL,
    modified_by INT,
    modified_on TIMESTAMP
);

