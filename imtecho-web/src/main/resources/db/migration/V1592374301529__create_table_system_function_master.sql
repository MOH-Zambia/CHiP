-- Table to store function detail
drop table if exists system_function_master;

CREATE TABLE system_function_master (
	id serial NOT NULL,
	name varchar(500) NOT NULL,/* method name*/
	class_name varchar(500) NOT NULL,/*fully qualified class name example: com.argusoft.imtecho.Example */
	description varchar(1000) ,/* description for the function*/
	parameters text ,/* to store parameter name and type in json (ex- [{"parameterName":"a","parameterType":"Integer"},{"parameterName":"b","parameterType":"String"}]) */
	created_by int4 NOT NULL,
	created_on timestamp NOT NULL,
	modified_by int4 ,
	modified_on timestamp ,
	CONSTRAINT system_function_master_pkey PRIMARY KEY (id)
);

-- Query to retrieve all records of the system_function_master table
DELETE FROM QUERY_MASTER WHERE CODE='system_function_retrieve_all';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'd9dee4e3-60ed-44fe-b796-8d5179f78551', 80208,  current_date , 80208,  current_date , 'system_function_retrieve_all', 
 null, 
'select 
sfm.id ,
sfm.name ,
sfm.description ,
sfm.parameters,
sfm.class_name as "className",
sfm.created_by "createdBy ",
sfm.created_on as "createdOn ",
sfm.modified_on as "modifiedOn ",
sfm.modified_by as "modifiedBy"
from system_function_master sfm ;', 
null, 
true, 'ACTIVE');