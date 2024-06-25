DROP TABLE IF EXISTS imt_family_vehicle_detail_rel;

CREATE TABLE if not exists imt_family_vehicle_detail_rel
(
    family_id bigint NOT NULL,
    vehicle_details text NOT NULL,
    PRIMARY KEY (family_id, vehicle_details),
    FOREIGN KEY (family_id)
        REFERENCES imt_family (id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);

ALTER TABLE imt_family
DROP COLUMN IF EXISTS motorized_vehicle_type;