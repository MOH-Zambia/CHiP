ALTER TABLE public.child_cmtc_nrc_weight_detail
   ALTER COLUMN weight_date TYPE date;

ALTER TABLE public.child_cmtc_nrc_weight_detail
  DROP CONSTRAINT IF EXISTS child_cmtc_nrc_weight_detail_pkey;

ALTER TABLE public.child_cmtc_nrc_weight_detail
  ADD PRIMARY KEY (id);

ALTER TABLE public.child_cmtc_nrc_weight_detail
  ADD UNIQUE (admission_id, weight_date);
