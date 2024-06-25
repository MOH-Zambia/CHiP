update system_configuration 
set key_value = cast(key_value as int) + 1
where system_key in ('ASHA SHEET VERSION','FHW SHEET VERSION');