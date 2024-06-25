create or replace function get_financial_year(input_date date) returns text as $$
declare
    financial_year text;
begin
    financial_year := cast(extract(year from input_date) as text);

    if input_date < to_date(financial_year || '-04-01', 'YYYY-MM-DD') then
        financial_year := cast((cast(financial_year as integer) - 1) as varchar) || '-' || financial_year;
    else
        financial_year := financial_year || '-' || cast((cast(financial_year as integer) + 1) as varchar);
    end if;

    return financial_year;
end;
$$ language plpgsql;