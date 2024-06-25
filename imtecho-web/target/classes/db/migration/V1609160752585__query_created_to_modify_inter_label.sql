-- update query created to modify internationalization label for NoPregnantWomeninyourarea key

update internationalization_label_master
set text = 'No pregnant women in your area', modified_on = now()
where "key" = 'NoPregnantWomeninyourarea' and "language" = 'EN';