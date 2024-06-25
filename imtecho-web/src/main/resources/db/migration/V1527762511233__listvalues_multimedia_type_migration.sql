update listvalue_field_value_detail vt1
  set multimedia_type=(
case when reverse(split_part(reverse(vt1.value), '.', 1))= ANY('{gif,jpg,png,psd,tif,jpeg}'::text[]) then 'image'  
when  reverse(split_part(reverse(vt1.value), '.', 1)) = ANY ('{amr,wma,mp3}'::text[]) then 'audio' 
when  reverse(split_part(reverse(vt1.value), '.', 1))= ANY('{mp4,avi,mpg,3gp,wmv,mov}'::text[]) then 'video' 
 end 
  )
  from listvalue_field_value_detail vt2
  where vt1.id=vt2.id
  and vt1.value like '%.%' 