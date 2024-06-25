drop table if exists health_infrastructure_monthly_volunteers_details;

create table health_infrastructure_monthly_volunteers_details (
	id bigserial primary key,
	health_infrastructure_id bigint not null,
	no_of_volunteers integer not null,
	month_year date not null,
	created_by bigint not null,
	created_on timestamp without time zone not null,
	modified_by bigint not null,
	modified_on timestamp without time zone not null
);

delete from menu_config where menu_name = 'Manage Volunteers';

insert into menu_config(active,menu_name,navigation_state,menu_type)
values(true,'Manage Volunteers','techo.manage.managevolunteers','manage');
