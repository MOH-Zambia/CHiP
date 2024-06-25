/*INSERT INTO public.team_type_master
(type, state, max_position, created_by, created_on)
VALUES('RBSK', 'ACTIVE', 5, 1, now());


INSERT INTO public.team_type_location_management
(created_by, created_on, team_type_id, location_type, state, "level")
VALUES(1, now(), (select id from team_type_master where type = 'RBSK'), 'B', 'ACTIVE', 4);


INSERT INTO public.team_type_location_management
(created_by, created_on, team_type_id, location_type, state, "level")
VALUES(1, now(), (select id from team_type_master where type = 'RBSK'), 'Z', 'ACTIVE', 4);

INSERT INTO public.team_type_role_master
(id, team_type_id, role_id, state)
VALUES(2, (select id from team_type_master where type = 'RBSK'), (select id from um_role_master where name = 'Super Admin'), 'ACTIVE');

INSERT INTO public.team_type_role_master
(id, team_type_id, role_id, state)
VALUES(2, (select id from team_type_master where type = 'RBSK'), (select id from um_role_master where name = 'Argus Admin'), 'ACTIVE');

INSERT INTO public.team_configuration_det
(team_type_id, role_id, min_member, max_member, state, created_by, created_on)
select (select id from team_type_master where type = 'RBSK'),id,1,1,'ACTIVE', 1, now()
from um_role_master where name = 'RBSK Staff Nurse';


INSERT INTO public.team_configuration_det
(team_type_id, role_id, min_member, max_member, state, created_by, created_on)
select (select id from team_type_master where type = 'RBSK'),id,1,1,'ACTIVE', 1, now()
from um_role_master where name = 'RBSK MO (Lady)';


INSERT INTO public.team_configuration_det
(team_type_id, role_id, min_member, max_member, state, created_by, created_on)
select (select id from team_type_master where type = 'RBSK'),id,1,1,'ACTIVE', 1, now()
from um_role_master where name = 'RBSK Staff Nurse';



INSERT INTO public.team_configuration_det
(team_type_id, role_id, min_member, max_member, state, created_by, created_on)
select (select id from team_type_master where type = 'RBSK'),id,1,1,'ACTIVE', 1, now()
from um_role_master where name = 'RBSK Pharmacist';

*/