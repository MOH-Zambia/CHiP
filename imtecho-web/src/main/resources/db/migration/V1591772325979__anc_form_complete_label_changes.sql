update internationalization_label_master
set text = 'ANC home visit form is complete. The next screen will show you morbidity, if any.',
modified_on = now()
where key = 'ANChomevisitformiscomplete.Thenextscreenwillshowyoumorbidity,ifany.'
and "language" = 'EN';