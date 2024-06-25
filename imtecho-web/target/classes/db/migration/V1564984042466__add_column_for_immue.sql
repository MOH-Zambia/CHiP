
		 alter table rch_immunisation_master
		add column anmol_child_tracking_status character varying(50);

		alter table rch_immunisation_master
		add column anmol_child_tracking_wsdl_code text;

		alter table rch_immunisation_master
		add column anmol_child_tracking_date timestamp without time zone;

        alter table rch_immunisation_master
	    add column vitamin_a_no integer;

	    alter table rch_immunisation_master
	    add column anmol_child_tracking_reg_id character varying (255);


		 /*
		  with immu as(
          select  id,ROW_NUMBER () OVER (ORDER BY member_id) as sr
		  from rch_immunisation_master
		  --where member_id =118846401  and
		  where immunisation_given = 'VITAMIN_A'
		  order by given_on)
		  update rch_immunisation_master set vitamin_a_no = immu.sr
		  from immu where
		  immu.id = rch_immunisation_master.id;

		  */

INSERT INTO public.anmol_immunisation_master (immunisation_given,immucode) VALUES
('VITAMIN_A-1',23),
('VITAMIN_A-2',24),
('VITAMIN_A-3',25),
('VITAMIN_A-4',26),
('VITAMIN_A-5',27),
('VITAMIN_A-6',28),
('VITAMIN_A-7',29),
('VITAMIN_A-8',30),
('VITAMIN_A-9',31);