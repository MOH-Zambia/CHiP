ALTER table ndhm_hiu_master
DROP column if exists is_default,
ADD column is_default boolean NOT NULL DEFAULT false,
DROP column if exists is_active,
ADD column is_active boolean NOT NULL DEFAULT false;
