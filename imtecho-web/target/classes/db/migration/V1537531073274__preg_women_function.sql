CREATE OR REPLACE FUNCTION getAncDates(in lmp date,in arr text,out ANC1 text,out ANC2 text,out ANC3 text,out ANC4 text)
AS
$$
declare 
	arr_date text[];
	dt date;
	dif double precision;
begin
  ANC1 := 'NA';
  ANC2 := 'NA';
  ANC3 := 'NA';
  ANC4 := 'NA';
  if arr is null then
  	return;
  end if;	
  arr_date :=  string_to_array (arr,',');
  FOR i IN 1.. array_upper(arr_date, 1)
  LOOP
    dt := to_date(arr_date[i],'DD/MM/YYYY');
    dif := DATE_PART('day',  dt::timestamp - lmp::timestamp );
    if dif >= 0 and dif <= 91 then
    	ANC1 := dt;
    elsif dif >= 92 and dif <= 182 then
    	ANC2 := dt;
    elsif dif >= 183 and dif <= 245 then
    	ANC3 :=dt;
    elseif dif >= 246 then
    	ANC4 := dt;
    end if;	
  END LOOP;
end;
$$
LANGUAGE plpgsql;