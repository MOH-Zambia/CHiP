drop table if exists rbsk_location_wise_monthly_analytics;

create table rbsk_location_wise_monthly_analytics
(
location_id integer,
month_year date,
new_born_screened integer,
primary key (location_id,month_year)
);